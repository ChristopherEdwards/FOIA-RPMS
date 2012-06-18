ACPT28PC ;IHS/VEN/TOAD - ACPT*2.08*1 postinit step 4.1 ; 04/21/2008 11:32
 ;;2.08;CPT FILES;**1**;DEC 17, 2007
 ;
 ; This subroutine of the post-init for ACPT*2.08*1 loads the HCPCS 2008
 ; codes from the American Medical Association's text file acpt2008.01h
 ; and installs them in the RPMS CPT file (81). It does not do all of the
 ; actions needed to install those codes, only the initial cleanup of the
 ; file and raw loading of the codes. See routine ACPT28PA for the
 ; complete algorithm and overview.
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at LOADCODE by ACPT28PA as part of the
 ; post-init for ACPT*2.08*1.
 ;
 ; 2008 04 16 Rick Marshall created this routine because ACPTPOST (now
 ; ACPT28PA) expanded beyond the 10,000 character routine portability
 ; limit when it was refactored for ACPT*2.08*1. All of the code in this
 ; routine was previously in ACPT28PA. In addition to the refactoring,
 ; this patch fixes two bugs: 1) undeleted codes are properly
 ; reactivated, and (2) when the AMA shortened its long description, old
 ; nodes left over from the previous, longer description were left; this
 ; routine now kills the description before setting the new nodes.
 ;
 ; 2008 04 17-20 Rick Marshall did invasive surgery on the algorithm,
 ; which was full of so many holes I cannot even summarize them
 ; effectively here. In short, the code had been patched so many times
 ; the logic was frayed and failed to handle any but the most typical
 ; cases. Just about every unexpected case resulted in incorrect
 ; behavior. A corresponding change was made to ACTIV8^ACPT28PE (used to
 ; be ACT^ACPTSINF). Fixed bug in nonportable handling of Description
 ; field.
 ;
 ; The original code in ACPTPOST upon which this was based was written by
 ; IHS/ASDST/DMJ and Shonda Render (SDR).
 ;
 ;
LOADCODE ; load HCPCS codes from AMA HCPCS Description file
 ;
 ; private: called only by step 4 of routine ACPT28PA
 ;
 ; input: ACPTPTH = path to directory where file is stored
 ;
 N POP D  Q:POP
 . D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2008.01h","R") ; open read-only
 . U IO(0) ; use terminal
 . I POP D MES^XPDUTL($$T("MSG+1")) ; Could not open HCPCS file.
 . E  D MES^XPDUTL($$T("MSG+2")) ; Reading HCPCS Codes file.
 ;
 N ACPTCNT ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 . ;
 . N ACPTLINE ; each line extracted from the file
 . U IO R ACPTLINE Q:$$STATUS^%ZISH
 . ;
 . N ACPTCODE ; HCPCS code
 . S ACPTCODE=$E(ACPTLINE,1,5) ; first 5 chars contain the HCPCS code
 . Q:ACPTCODE'?1U4N  ; skip any non-HCPCS codes found (should be none)
 . ;
 . N ACPTACT ; action code, if any
 . S ACPTACT=$E(ACPTLINE,6)  ; action code
 . ;
 . N ACPTIEN ; IEN of entry in CPT file
 . S ACPTIEN=$O(^ICPT("B",ACPTCODE,0)) ; find the code's record number
 . I '$D(^ICPT("B",ACPTCODE)) D  ; if there isn't one, create it
 . . S ACPTIEN=$A($E(ACPTCODE))_$E(ACPTCODE,2,5) ; CPT range three
 . . S ^ICPT(ACPTIEN,0)=ACPTCODE ; CPT Code field (.01)
 . . S ^ICPT("B",ACPTCODE,ACPTIEN)="" ; index of CPT Codes
 . . S $P(^ICPT(ACPTIEN,0),U,6)=ACPTYR ; Date Added (7) to 3080000
 . ;
 . N ACPTNODE S ACPTNODE=$G(^ICPT(ACPTIEN,0)) ; get record's header node
 . ;
 . ; Q:ACPTACT=""  ; no action code (unchanged code, so do nothing)
 . ; TOAD: I am not convinced the action codes are always correct.
 . ; If a code has no action code but has actually been changed, this
 . ; line will prevent the change from being applied. Someone should
 . ; write some code to check out the validity of these action codes.
 . ; This version of the patch will be conservative and not trust the
 . ; data at the sites to be completely in synch with AMA; this patch
 . ; will run more slowly, but subsequent HCPCS updates may then
 . ; reinstate this line for improved efficiency knowing the data's in
 . ; synch to begin with.
 . ;
 . N ACPTSHRT ; Short Name (2)
 . S ACPTSHRT=$$CLEAN($E(ACPTLINE,7,41),1) ; clean up the Short Name
 . I ACPTSHRT'="" S $P(ACPTNODE,U,2)=ACPTSHRT ; update it
 . ;
 . I ACPTACT="A" D  ; handle new codes specially:
 . . S $P(ACPTNODE,U,4)=1 ; Inactive Flag (5) is true till step 6
 . . S $P(ACPTNODE,U,6)=ACPTYR ; use special Date Added (7) flag
 . E  D  ; for all other codes:
 . . S $P(ACPTNODE,U,4)="" ; Inactive Flag is cleared
 . . I $P(ACPTNODE,U,6)="" S $P(ACPTNODE,U,6)=3080101 ; set Date Added
 . ;
 . S $P(ACPTNODE,U,7)="" ; clear Date Deleted field (8)
 . ;
 . S ^ICPT(ACPTIEN,0)=ACPTNODE ; update header node
 . ;
 . N ACPTDESC ; Description field (50)
 . S ACPTDESC=$$CLEAN($E(ACPTLINE,42,1097)) ; clean up the Description
 . D TEXT(.ACPTDESC) ; convert string to WP array
 . K ^ICPT(ACPTIEN,"D") ; clean out old Description (50)
 . M ^ICPT(ACPTIEN,"D")=ACPTDESC ; copy array to field, incl. header
 . ;
 . N ACPTEDT ; last Effective Date
 . S ACPTEDT=$O(^ICPT(ACPTIEN,60,"B",9999999),-1) ; find the last
 . N ACPTEIEN S ACPTEIEN=$O(^ICPT(ACPTIEN,60,"B",+ACPTEDT,0)) ; its IEN
 . ;
 . I ACPTEDT=3080101,ACPTEIEN D  ; if there is one for this install date
 . . Q:$P($G(^ICPT(ACPTIEN,60,ACPTEIEN,0)),U,2)  ; if active, we're fine
 . . ; otherwise, we need to activate it:
 . . N DA S DA=+ACPTEIEN ; IEN of last Effective Date
 . . S DA(1)=ACPTIEN ; IEN of its parent CPT
 . . N DIE S DIE="^ICPT("_DA(1)_",60," ; Effective Date (60/81.02)
 . . N DR S DR=".02////1" ; set Status field to ACTIVE
 . . N DIDEL,DTOUT ; other parameters for DIE
 . . D ^DIE ; Fileman Data Edit call
 . ;
 . E  D  ; if not, then we need one
 . . N DA S DA(1)=ACPTIEN ; into subfile under new entry
 . . N DIC S DIC="^ICPT("_DA(1)_",60," ; Effective Date (60/81.02)
 . . S DIC(0)="L" ; LAYGO
 . . S DIC("P")=$P(^DD(81,60,0),U,2) ; subfile # & specifier codes
 . . N X S X="01/01/2008" ; new entry for 1/1/2008
 . . S DIC("DR")=".02////1" ; with Status = 1 (active)
 . . N DLAYGO,Y,DTOUT,DUOUT ; other parameters
 . . D ^DIC ; Fileman LAYGO lookup
 . ;
 . U IO(0) W:'(ACPTCNT#100) "."
 ;
 D ^%ZISC ; close the file
 ;
 QUIT  ; end of LOADCODE
 ;
 ;
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
 ;
MSG ; messages to display
 ;;Could not open HCPCS file.
 ;;Reading HCPCS Codes file.
 ;
 ;
CLEAN(ACPTDESC,ACPTUP) ; clean up description field
 ;
 ; private, called only by LOADCODE above
 ;
 ; 1) strip out control characters
 I ACPTDESC?.E1C.E D CLEAN^ACPT28P1(.ACPTDESC)
 ;
 ; 2) trim extra spaces
 N ACPTCLN S ACPTCLN=""
 N ACPTPIEC F ACPTPIEC=1:1:$L(ACPTDESC," ") D  ; traverse words
 . N ACPTWORD S ACPTWORD=$P(ACPTDESC," ",ACPTPIEC) ; grab each word
 . Q:ACPTWORD=""  ; skip empty words (multiple spaces together)
 . S ACPTCLN=ACPTCLN_" "_ACPTWORD ; reassemble words with 1 space between
 S $E(ACPTCLN)="" ; remove extraneous leading space
 ;
 ; 3) optionally, convert to upper case
 I $G(ACPTUP) S ACPTDESC=$$UP^XLFSTR(ACPTCLN)
 ;
 QUIT ACPTCLN ; end of CLEAN
 ;
 ;
TEXT(ACPTDESC) ; convert Description text to Word-Processing data type
 ;
 ; private, called only by LOADCODE above
 ;
 ; input: .ACPTDESC = passed by reference, starts out as long string,
 ; ends as Fileman WP-format array complete with header
 ;
 N ACPTSTRN S ACPTSTRN=ACPTDESC ; copy string out
 K ACPTDESC ; clear what will now become a WP array
 N ACPTCNT S ACPTCNT=0 ; count WP lines for header
 ;
 F  Q:ACPTSTRN=""  D  ; loop until ACPTSTRN is fully transformed
 . ;
 . N ACPTBRK S ACPTBRK=0 ; character position to break at
 . ;
 . D  ; find the character position to break at
 . . N ACPTRY ; break position to try
 . . S ACPTRY=$L(ACPTSTRN) ; how long is the string?
 . . I ACPTRY<81 S ACPTBRK=ACPTRY Q  ; if 1 full line or less, we're done
 . . ;
 . . F ACPTRY=80:-1:2 D  Q:ACPTBRK
 . . . I $E(ACPTSTRN,ACPTRY+1)=" " D  Q  ; can break on a space
 . . . . S $E(ACPTSTRN,ACPTRY+1)="" ; remove the space
 . . . . S ACPTBRK=ACPTRY ; and let's break here
 . . . ;
 . . . I "&_+-*/<=>}])|:;,.?!"[$E(ACPTSTRN,ACPTRY) D  Q  ; on delimiter?
 . . . . S ACPTBRK=ACPTRY ; so let's break here
 . . ;
 . . Q:ACPTBRK  ; if we found a good spot to break, we're done
 . . ;
 . . S ACPTBRK=80 ; otherwise, hard-break on 80 (weird content)
 . ;
 . S ACPTCNT=ACPTCNT+1 ; one more line
 . S ACPTDESC(ACPTCNT,0)=$E(ACPTSTRN,1,ACPTBRK) ; copy line into array
 . S $E(ACPTSTRN,1,ACPTBRK)="" ; & remove it from the string
 ;
 S ACPTDESC(0)="^81.01A^"_ACPTCNT_U_ACPTCNT_U_DT ; set WP header
 ;
 QUIT  ; end of TEXT
 ;
 ;
 ; end of routine ACPT28PC
