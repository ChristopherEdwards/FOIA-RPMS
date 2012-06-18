ACPT29L ;IHS/SD/SDR - ACPT 2.09 install ; 12/29/2008 11:32
 ;;2.09;CPT FILES;;JAN 2, 2009
 ;
 Q  ;
 ;
 ;
IMPORT ;  this tag will load the complete file into ^TMP("ACPT-IMP",$J) using the concept ID
 ;  and the property ID as the identifiers
 K ^TMP("ACPT-IMP",$J),^TMP("ACPT-CPTS",$J),^TMP("ACPT-CNT",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2009.l","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open CPT file.")
 .E  D MES^XPDUTL("Reading CPT file.")
 ;
 W !
 K ACPTCNT  ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 .;
 .K ACPTLINE  ; each line extracted from the file
 .U IO R ACPTLINE Q:$$STATUS^%ZISH
 .S ACPTFIEN=$P(ACPTLINE,"|")  ;file IEN (concept ID)
 .S ACPTPID=$P(ACPTLINE,"|",2)  ;property ID
 .;the below check has to be done for long description; it could be spread over
 .;multiple lines and have 01, 02 etc on each line.
 .S ACPTLCNT=$S(ACPTPID=106:1,$P(ACPTLINE,"|",3)[":"&($P(+$P(ACPTLINE,"|",3),":")'=0):+$P($P(ACPTLINE,"|",3),":"),1:1)
 .S ACPTDATA=$S(+$P($P(ACPTLINE,"|",3),":",2)'=0&(ACPTPID'=106):$P($P(ACPTLINE,"|",3),":",2),(+$P($P(ACPTLINE,"|",3),":",2)=0)&(ACPTPID'=106):$P(ACPTLINE,"|",3),1:$P(ACPTLINE,"|",3))
 .S ^TMP("ACPT-IMP",$J,ACPTFIEN,ACPTPID,ACPTLCNT)=ACPTDATA
 .I ACPTPID=104,($P(ACPTLINE,"|",3)'="") D
 ..S ^TMP("ACPT-CPTS",$J,ACPTFIEN,$P(ACPTLINE,"|",3),ACPTPID)=""  ;only CPT entries
 ..S ^TMP("ACPT-CNT",$J)=+$G(^TMP("ACPT-CNT",$J))+1  ;count
 ..I '(ACPTFIEN#100) U IO(0) W "."
 D ^%ZISC  ; close the file
 ;now actually load codes
 W !,"ADDING CODES:"
 S ACPTFIEN=0
 F  S ACPTFIEN=$O(^TMP("ACPT-CPTS",$J,ACPTFIEN)) Q:+ACPTFIEN=0  D
 .S ACPTCODE=""
 .F  S ACPTCODE=$O(^TMP("ACPT-CPTS",$J,ACPTFIEN,ACPTCODE)) Q:ACPTCODE=""  D
 ..D LOADCODE  ;this will actually load code into ^ICPT
 ..I $G(ACPTNEW)=1 W !?5,ACPTCODE,?15,ACPTSHRT
 Q
LOADCODE ; load CPTs from ^TMP("ACPT-IMP",$J)
 ;
 K ACPTNEW,ACPTIEN,ACPTSHRT,ACPTDESC
 Q:(ACPTCODE'?5N)&(ACPTCODE'?4N1U)  ;cpt of ####F
 ;
 S ACPTIEN=$O(^ICPT("B",ACPTCODE,0))  ; find the code's record number
 I '$D(^ICPT("B",ACPTCODE)) D  ; if there isn't one, create it
 .S ACPTNEW=1
 .S ACPTIEN=$S(ACPTCODE?4N1U:$A($E(ACPTCODE,1))_$A($E(ACPTCODE,2))_$A($E(ACPTCODE,3))_$A($E(ACPTCODE,4))_$A($E(ACPTCODE,5)),1:+ACPTCODE)
 .S ^ICPT(ACPTIEN,0)=ACPTCODE  ; CPT Code field (.01)
 .S ^ICPT("B",ACPTCODE,ACPTIEN)=""  ; index of CPT Codes
 .S $P(^ICPT(ACPTIEN,0),U,6)=ACPTYR  ; Date Added (7) to 3080000
 ;
 S ACPTNODE=$G(^ICPT(ACPTIEN,0))  ; get record's header node
 S ACPTSHRT=$$CLEAN($G(^TMP("ACPT-IMP",$J,ACPTFIEN,111,1)))  ; clean up the Short Name
 I ACPTSHRT'="" S $P(ACPTNODE,U,2)=ACPTSHRT  ; update it
 ;
 I $G(ACPTNEW)=1 D  ; handle new codes specially
 .;S $P(ACPTNODE,U,4)=1  ; Inactive Flag (5) is true till step 6
 .S $P(ACPTNODE,U,6)=ACPTYR  ; use special Date Added (7) flag
 E  D  ; for all other codes:
 .S $P(ACPTNODE,U,4)=""  ; Inactive Flag is cleared
 .I $P(ACPTNODE,U,6)="" S $P(ACPTNODE,U,6)=ACPTYR  ; set Date Added
 ;
 S $P(ACPTNODE,U,7)=""  ; clear Date Deleted field (8)
 ;
 S ^ICPT(ACPTIEN,0)=ACPTNODE  ; update header node
 ;
 S ACPTL=0
 S ACPTDESC=""
 F  S ACPTL=$O(^TMP("ACPT-IMP",$J,ACPTFIEN,106,ACPTL)) Q:+ACPTL=0  D
 .I ACPTDESC'="" S ACPTDESC=ACPTDESC_" "_$G(^TMP("ACPT-IMP",$J,ACPTFIEN,106,ACPTL))
 .I ACPTDESC="" S ACPTDESC=$G(^TMP("ACPT-IMP",$J,ACPTFIEN,106,ACPTL))
 S ACPTDESC=$$CLEAN(ACPTDESC)  ; clean up the Description
 D TEXT(.ACPTDESC) ; convert string to WP array
 K ^ICPT(ACPTIEN,"D") ; clean out old Description (50)
 M ^ICPT(ACPTIEN,"D")=ACPTDESC ; copy array to field, incl. header
 ;
 S ACPTEDT=$O(^ICPT(ACPTIEN,60,"B",9999999),-1)  ; find the last
 N ACPTEIEN S ACPTEIEN=$O(^ICPT(ACPTIEN,60,"B",+ACPTEDT,0))  ; its IEN
 ;
 I ACPTEDT=3090101,ACPTEIEN D  ; if there is one for this install date
 .Q:$P($G(^ICPT(ACPTIEN,60,ACPTEIEN,0)),U,2)  ; if active, we're fine
 .; otherwise, we need to activate it:
 .K DIC,DIE,DA,DIR,X,Y
 .S DA=+ACPTEIEN  ; IEN of last Effective Date
 .S DA(1)=ACPTIEN  ; IEN of its parent CPT
 .S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 .S DR=".02////1"  ; set Status field to ACTIVE
 .N DIDEL,DTOUT  ; other parameters for DIE
 .D ^DIE  ; Fileman Data Edit call
 ;
 E  D  ; if not, then we need one
 .K DIC,DIE,DA,X,Y,DIR
 .S DA(1)=ACPTIEN  ; into subfile under new entry
 .S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 .S DIC(0)="L"  ; LAYGO
 .S DIC("P")=$P(^DD(81,60,0),U,2)  ; subfile # & specifier codes
 .S X="01/01/2009"  ; new entry for 1/1/2008
 .S DIC("DR")=".02////1"  ; with Status = 1 (active)
 .N DLAYGO,Y,DTOUT,DUOUT  ; other parameters
 .D ^DIC  ; Fileman LAYGO lookup
 ;
 U IO(0) W:'(ACPTCNT#100) "."
 Q
 ;
CLEAN(ACPTDESC,ACPTUP) ; clean up description field
 ;
 ;strip out control characters
 I ACPTDESC?.E1C.E D CLEAN^ACPT28P1(.ACPTDESC)
 ;
 ;trim extra spaces
 N ACPTCLN S ACPTCLN=""
 N ACPTPIEC F ACPTPIEC=1:1:$L(ACPTDESC," ") D  ; traverse words
 .N ACPTWORD S ACPTWORD=$P(ACPTDESC," ",ACPTPIEC)  ; grab each word
 .Q:ACPTWORD=""  ; skip empty words (multiple spaces together)
 .S ACPTCLN=ACPTCLN_" "_ACPTWORD  ; reassemble words with 1 space between
 S $E(ACPTCLN)=""  ; remove extraneous leading space
 ;
 ;optionally, convert to upper case
 I $G(ACPTUP) S ACPTDESC=$$UP^XLFSTR(ACPTCLN)
 ;
 Q ACPTCLN
DELETE ;  this tag will load the complete file into ^TMP("ACPT-DEL",$J) using the concept ID
 ;  and the property ID as the identifiers
 K ^TMP("ACPT-DEL",$J),^TMP("ACPT-DCNT",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2009.d","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open CPT delete file.")
 .E  D MES^XPDUTL("Reading CPT delete file.")
 ;
 K ACPTCNT  ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 .;
 .K ACPTLINE  ; each line extracted from the file
 .U IO R ACPTLINE Q:$$STATUS^%ZISH
 .S ACPTFIEN=$P(ACPTLINE,"|")  ;file IEN (concept ID)
 .Q:+ACPTFIEN=0  ;no file IEN
 .S ACPTCD=$P(ACPTLINE,"|",2)  ;code
 .Q:$L(ACPTCD)'=5  ;all codes should be 5 chars
 .Q:$P(ACPTLINE,"|",3)'=2009  ;only do 2009 deletes
 .S ^TMP("ACPT-DEL",$J,ACPTFIEN,ACPTCD)=$P(ACPTLINE,"|",3),^TMP("ACPT-DCNT",$J)=+$G(^TMP("ACPT-DCNT",$J))+1  ;only CPT entries
 D ^%ZISC  ; close the file
 ;now actually load codes
 W !,"Deleting Codes:"
 S ACPTFIEN=0
 F  S ACPTFIEN=$O(^TMP("ACPT-DEL",$J,ACPTFIEN)) Q:+ACPTFIEN=0  D
 .S ACPTCODE=0
 .F  S ACPTCODE=$O(^TMP("ACPT-DEL",$J,ACPTFIEN,ACPTCODE)) Q:+ACPTCODE=0  D
 ..D DELCODE  ;this will actually flag code as deleted in ^ICPT
 ..W !?3,ACPTCODE_" "_ACPTDESC
 Q
DELCODE ;
 S ACPTIEN=0
 S ACPTDESC="Couldn't find code to inactivate"
 F  S ACPTIEN=$O(^ICPT("B",ACPTCODE,ACPTIEN)) Q:'ACPTIEN  D  ; find the code's record number
 .S:$P($G(^ICPT(ACPTIEN,0)),U,2)'="" ACPTDESC=$P(^ICPT(ACPTIEN,0),U,2)
 .S $P(^ICPT(ACPTIEN,0),U,7)=ACPTYR  ; Date Deleted (8) to 3081231
 .;
 .K DIC,DIE,DIR,X,Y,DA,DR
 .S DA(1)=ACPTIEN  ; parent record, i.e., the CPT code
 .S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 .S DIC(0)="L"  ; allow LAYGO (Learn As You Go, i.e., add if not found)
 .S DIC("P")=$P(^DD(81,60,0),"^",2)  ; subfile # & specifier codes
 .S X="01/01/2009"  ; value to lookup in the subfile
 .N DLAYGO,Y,DTOUT,DUOUT  ; other parameters for DIC
 .D ^DIC  ; Fileman Lookup call
 .S DA=+Y  ; save IEN of found/added record for next call below
 .;
 .K DIR,DIE,DIC,X,Y,DR
 .S DA(1)=ACPTIEN
 .S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 .S DR=".02////0"  ; set Status field to INACTIVE
 .N DIDEL,DTOUT  ; other parameters for DIE
 .D ^DIE  ; Fileman Data Edit call
 Q
TEXT(ACPTDESC) ; convert Description text to Word-Processing data type
 ; input: .ACPTDESC = passed by reference, starts out as long string,
 ; ends as Fileman WP-format array complete with header
 ;
 N ACPTSTRN S ACPTSTRN=ACPTDESC ; copy string out
 K ACPTDESC ; clear what will now become a WP array
 N ACPTCNT S ACPTCNT=0 ; count WP lines for header
 ;
 F  Q:ACPTSTRN=""  D  ; loop until ACPTSTRN is fully transformed
 .;
 .N ACPTBRK S ACPTBRK=0 ; character position to break at
 .;
 .D  ; find the character position to break at
 ..N ACPTRY ; break position to try
 ..S ACPTRY=$L(ACPTSTRN) ; how long is the string?
 ..I ACPTRY<81 S ACPTBRK=ACPTRY Q  ; if 1 full line or less, we're done
 ..;
 ..F ACPTRY=80:-1:2 D  Q:ACPTBRK
 ...I $E(ACPTSTRN,ACPTRY+1)=" " D  Q  ; can break on a space
 ....S $E(ACPTSTRN,ACPTRY+1)="" ; remove the space
 ....S ACPTBRK=ACPTRY ; and let's break here
 ...;
 ...I "&_+-*/<=>}])|:;,.?!"[$E(ACPTSTRN,ACPTRY) D  Q  ; on delimiter?
 ....S ACPTBRK=ACPTRY ; so let's break here
 ..;
 ..Q:ACPTBRK  ; if we found a good spot to break, we're done
 ..;
 ..S ACPTBRK=80 ; otherwise, hard-break on 80 (weird content)
 .;
 .S ACPTCNT=ACPTCNT+1 ; one more line
 .S ACPTDESC(ACPTCNT,0)=$E(ACPTSTRN,1,ACPTBRK) ; copy line into array
 .S $E(ACPTSTRN,1,ACPTBRK)="" ; & remove it from the string
 ;
 S ACPTDESC(0)="^81.01A^"_ACPTCNT_U_ACPTCNT_U_DT ; set WP header
 ;
 Q
