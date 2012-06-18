ACPT28PD ;IHS/VEN/TOAD - ACPT*2.08*1 postinit step 4.2 ; 04/21/2008 11:24
 ;;2.08;CPT FILES;**1**;DEC 17, 2007
 ;
 ; This subroutine of the post-init for ACPT*2.08*1 loads the HCPCS 2008
 ; modifiers from the American Medical Association's text file
 ; acpt2008.01c and installs them in the RPMS CPT Modifier file
 ; (9999999.88). It does not do all of the actions needed to install
 ; those modifiers, only the raw loading. See routine ACPT28PA for the
 ; complete algorithm and overview.
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at LOADMOD by ACPT28PA as part of the
 ; post-init for ACPT*2.08*1.
 ;
 ; 2008 04 16-20 Rick Marshall refactored this routine for
 ; maintainability. All commented-out code was removed so this version of 
 ; the routine handles only HCPCS codes. Fixed bug in unportable handling 
 ; of Description & Long Description fields. Renamed routine from
 ; ACPTPST2 to ACPT28PD.
 ;
 ; The original code was written by IHS/ASDST/DMJ and Shonda Render
 ; (SDR).
 ;
 ;
LOADMOD ;load HCPCS modifiers from AMA HCPCS Modifiers file
 ;
 ; private: called only by step 4 of routine ACPT28PA
 ;
 ; input: ACPTPTH = path to directory where file is stored
 ; ACPTYR = flag to identify newly added entries (3080000)
 ;
 N POP D  Q:POP
 . D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2008.01c","R") ; open read-only
 . U IO(0) ; use terminal
 . I POP D MES^XPDUTL($$T("MSG+1")) ; Could not open HCPCS Modifiers f...
 . E  D MES^XPDUTL($$T("MSG+2")) ; Reading HCPCS Modifiers file.
 ;
 N ACPTCNT ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 . ;
 . N ACPTLINE ; each line extracted from the file
 . U IO R ACPTLINE Q:$$STATUS^%ZISH
 . ;
 . N ACPTCODE ; HCPCS modifier, aka Code (.01)
 . S ACPTCODE=$E(ACPTLINE,1,2) ; 1st 2 chars contain the HCPCS modifier
 . ;
 . N ACPTIEN ; IEN of entry in CPT Modifier file
 . S ACPTIEN=$O(^AUTTCMOD("B",ACPTCODE,0)) ; find code's record number
 . I 'ACPTIEN D  ; if there isn't one yet, create it
 . . S ACPTIEN=$A(ACPTCODE)_$A(ACPTCODE,2) ; DINUM based on ASCII of code
 . . S ^AUTTCMOD(ACPTIEN,0)=ACPTCODE_U_U_ACPTYR ; set Code & Date Added
 . . S ^AUTTCMOD("B",ACPTCODE,ACPTIEN)="" ; and cross-reference it
 . ;
 . N ACPTDESC ; Description (.02)
 . S ACPTDESC=$$CLEAN($E(ACPTLINE,3,153),1) ; Description up to 150 chars
 . I ACPTDESC'="" D  ; if a description is present in the AMA file
 . . S $P(^AUTTCMOD(ACPTIEN,0),U,2)=ACPTDESC ; set the field
 . I "^AE^AF^AG^AK^CB^FP^QA^"[(U_ACPTCODE_U) D  ; if one of these codes
 . . S $P(^AUTTCMOD(ACPTIEN,0),U,2)="" ; description is wrong, so delete
 . ;
 . S $P(^AUTTCMOD(ACPTIEN,0),U,4)="" ; clear Date Deleted (.04)
 . ;
 . N ACPTLONG ; Long Description (1)
 . S ACPTLONG=$$CLEAN($E(ACPTLINE,3,536)) ; rest of up to 536 = Long Desc
 . D TEXT(.ACPTLONG) ; convert string to WP array
 . K ^AUTTCMOD(ACPTIEN,1) ; delete its subtree
 . M ^AUTTCMOD(ACPTIEN,1)=ACPTLONG ; copy array to field, incl. header
 . ;
 . U IO(0) W:'(ACPTCNT#100) "."
 ;
 D ^%ZISC ; close the file
 ;
 QUIT  ; end of LOADMOD
 ;
 ;
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
 ;
MSG ; messages to display
 ;;Could not open HCPCS Modifiers file.
 ;;Reading HCPCS Modifiers file.
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
TEXT(ACPTLONG) ; convert Long Description text to Word-Processing data type
 ;
 ; private, called only by LOADCODE above
 ;
 ; input: .ACPTLONG = passed by reference, starts out as long string,
 ; ends as Fileman WP-format array complete with header
 ;
 N ACPTSTRN S ACPTSTRN=ACPTLONG ; copy string out
 K ACPTLONG ; clear what will now become a WP array
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
 . S ACPTLONG(ACPTCNT,0)=$E(ACPTSTRN,1,ACPTBRK) ; copy line into array
 . S $E(ACPTSTRN,1,ACPTBRK)="" ; & remove it from the string
 ;
 S ACPTLONG(0)="^9999999.881^"_ACPTCNT_U_ACPTCNT_U_DT ; set WP header
 ;
 QUIT  ; end of TEXT
 ;
 ;
 ; end of routine ACPT28PD
