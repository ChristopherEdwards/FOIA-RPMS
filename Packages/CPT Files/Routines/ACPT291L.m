ACPT291L ;IHS/SD/SDR - ACPT*2.09*1 install ; 12/29/2008 11:32
 ;;2.09;CPT FILES;**1**;JAN 8, 2009
 ;
 Q  ;
 ;
 ;
IMPORT ;  this tag will load the complete file into ^TMP("ACPT-IMP",$J) using the concept ID
 ;  and the property ID as the identifiers
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2009.01h","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open HCPCS file.")
 .E  D MES^XPDUTL("Reading HCPCS file.")
 ;
 ; Fields that will be used with their character counts
 ; Chars   Field
 ; 1-5     HCPCS code
 ; 4-5     HCPCS modifier
 ; 6-10    HCPCS Sequence # - used to group proc or modifier codes together
 ; 11-11   HCPCS Rec ID code
 ;   3=First line of proc code
 ;   4=Second, third, fourth, etc. desc of proc
 ;   7=First line of mod code
 ;   8=Second, third, fourth, etc desc of mod
 ; 12-91   Long description
 ; 92-119  Short description
 ; 269-276 HCPCS Code Added Date
 ;;;; 277-284 HCPCS Action Effective Date (not used)
 ; 285-292 HCPCS Termination Date
 ; 293-293 HCPCS Action Code
 ;  a A=Add proc or mod code
 ;  c B=Change in both admin data field & long desc.
 ;  c C=Change in long desc
 ;  d D=Discontinued
 ;  n F=Change in admin data field
 ;  n N=No maintenance for this code
 ;  n P=Payment change
 ;  a R=Reactivate disc/deleted code
 ;  c S=Change in short desc
 ;  n T=Misc change (TOS, BETOS, etc)
 ;
 W !
 K ^TMP("ACPT-HCPCS")
 K ACPTCNT  ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 .;
 .K ACPTLINE  ; each line extracted from the file
 .U IO R ACPTLINE Q:$$STATUS^%ZISH
 .;
 .I $E(ACPTLINE,1)=" " D  ;this is a modifier
 ..S ACPTMOD=$E(ACPTLINE,4,5)  ;modifier code
 ..I $E(ACPTLINE,11)=7 D  ;first line of mod
 ...S ACPTLONG=$E(ACPTLINE,12,91)  ;mod long desc.
 ...S ACPTSHRT=$E(ACPTLINE,92,119)  ;mod short desc.
 ...S ^TMP("ACPT-HCPCS",$J,"M",ACPTMOD)=ACPTSHRT_"^"_ACPTLONG
 ..I $E(ACPTLINE,11)=8 D  ;second line of mod
 ...S $P(^TMP("ACPT-HCPCS",$J,"M",ACPTMOD),U,2)=$P(^TMP("ACPT-HCPCS",$J,"M",ACPTMOD),U,2)_" "_ACPTLONG
 .;
 .I $E(ACPTLINE,1)'=" " D  ;this is a proc code
 ..S ACPTCODE=$E(ACPTLINE,1,5)  ;Proc code
 ..I $E(ACPTLINE,11)=3 D  ;first line of proc
 ...S ACPTLONG=$E(ACPTLINE,12,91)  ;proc long desc.
 ...S ACPTSHRT=$E(ACPTLINE,92,119)  ;proc short desc.
 ...S ACPTACT=$E(ACPTLINE,293)  ;proc action code
 ...S ACPTACT=$S(ACPTACT="R":"A",ACPTACT="B"!(ACPTACT="S"):"C",ACPTACT="F"!(ACPTACT="P")!(ACPTACT="T"):"N",1:ACPTACT)
 ...Q:ACPTACT="N"  ;no maintenance codes are skipped
 ...S ^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)=ACPTSHRT_"^"_ACPTLONG
 ..I $E(ACPTLINE,11)=4 D  ;second line of proc
 ...Q:'$D(^TMP("ACPT-HCPCS",$J,"A",ACPTCODE))&'$D(^TMP("ACPT-HCPCS",$J,"C",ACPTCODE))&'$D(^TMP("ACPT-HCPCS",$J,"D",ACPTCODE))
 ...S ACPTACT=$S($D(^TMP("ACPT-HCPCS",$J,"A",ACPTCODE)):"A",$D(^TMP("ACPT-HCPCS",$J,"C",ACPTCODE)):"C",$D(^TMP("ACPT-HCPCS",$J,"D",ACPTCODE)):"D",1:"")
 ...Q:ACPTACT=""
 ...S ACPTLONG=$E(ACPTLINE,12,91)
 ...S $P(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE),U,2)=$P(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE),U,2)_" "_ACPTLONG
 .;
 .I '(ACPTCNT#100) U IO(0) W "."
 D ^%ZISC  ; close the file
 ;
 ;now actually load codes
 F ACPTACT="A","C","D","M" D
 .W !!,$S(ACPTACT="A":"ADDING",ACPTACT="C":"Modifying",ACPTACT="D":"Deleting",1:"Modifier")_" Codes:"
 .S ACPTCODE=""
 .F  S ACPTCODE=$O(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)) Q:ACPTCODE=""  D
 ..I ACPTACT'="D" D LOADCODE  ;this will actually load code into ^ICPT
 ..I ACPTACT="D" D DELCODE  ;delete codes
 ..W !?5,ACPTCODE,?15,ACPTSHRT
 Q
LOADCODE ; load CPTs from ^TMP("ACPT-IMP",$J)
 ;
 K ACPTNEW,ACPTIEN,ACPTSHRT,ACPTDESC
 Q:(ACPTCODE'?1U4N)&(ACPTCODE'?2U)&(ACPTCODE'?1U1N)  ;check format of code
 ;
 I ACPTCODE?1U4N D  ;HCPCS codes
 .S ACPTIEN=$O(^ICPT("B",ACPTCODE,0))  ; find the code's record number
 .I '$D(^ICPT("B",ACPTCODE)) D  ; if there isn't one, create it
 ..S ACPTIEN=$A($E(ACPTCODE,1))_$E(ACPTCODE,2,5)
 ..S ^ICPT(ACPTIEN,0)=ACPTCODE  ; CPT Code field (.01)
 ..S ^ICPT("B",ACPTCODE,ACPTIEN)=""  ; index of CPT Codes
 ..S $P(^ICPT(ACPTIEN,0),U,6)=ACPTYR  ; Date Added (7) to 3090000
 ..S:ACPTCODE="K0739"!(ACPTCODE="K0740")!(ACPTCODE="S3865")!(ACPTCODE="S3866")!(ACPTCODE="S3870") $P(^ICPT(ACPTIEN,0),U,6)=3090401  ;this codes are effective 4/1/09
 .;
 .S ACPTNODE=$G(^ICPT(ACPTIEN,0))  ; get record's header node
 .S ACPTSHRT=$$CLEAN($P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U))  ; clean up the Short Name
 .I ACPTSHRT'="" S $P(ACPTNODE,U,2)=ACPTSHRT  ; update it
 .S $P(ACPTNODE,U,7)=""  ; clear Date Deleted field (8)
 .S ^ICPT(ACPTIEN,0)=ACPTNODE  ; update header node
 .;
 .S ACPTDESC=$$CLEAN($P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,2))  ; clean up the Description
 .D TEXT(.ACPTDESC) ; convert string to WP array
 .K ^ICPT(ACPTIEN,"D") ; clean out old Description (50)
 .M ^ICPT(ACPTIEN,"D")=ACPTDESC ; copy array to field, incl. header
 .;
 .S ACPTEDT=$O(^ICPT(ACPTIEN,60,"B",9999999),-1)  ; find the last
 .N ACPTEIEN S ACPTEIEN=$O(^ICPT(ACPTIEN,60,"B",+ACPTEDT,0))  ; its IEN
 .;
 .I ACPTEDT=3090101,ACPTEIEN D  ; if there is one for this install date
 ..Q:$P($G(^ICPT(ACPTIEN,60,ACPTEIEN,0)),U,2)  ; if active, we're fine
 ..; otherwise, we need to activate it:
 ..K DIC,DIE,DA,DIR,X,Y
 ..S DA=+ACPTEIEN  ; IEN of last Effective Date
 ..S DA(1)=ACPTIEN  ; IEN of its parent CPT
 ..S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 ..S DR=".02////1"  ; set Status field to ACTIVE
 ..N DIDEL,DTOUT  ; other parameters for DIE
 ..D ^DIE  ; Fileman Data Edit call
 .;
 .E  D  ; if not, then we need one
 ..K DIC,DIE,DA,X,Y,DIR
 ..S DA(1)=ACPTIEN  ; into subfile under new entry
 ..S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 ..S DIC(0)="L"  ; LAYGO
 ..S DIC("P")=$P(^DD(81,60,0),U,2)  ; subfile # & specifier codes
 ..S X="01/01/2009"  ; new entry for 1/1/2009
 ..S:ACPTCODE="K0739"!(ACPTCODE="K0740")!(ACPTCODE="S3865")!(ACPTCODE="S3866")!(ACPTCODE="S3870") X="04/01/2009"  ;this codes are effective 4/1/09
 ..S DIC("DR")=".02////1"  ; with Status = 1 (active)
 ..N DLAYGO,Y,DTOUT,DUOUT  ; other parameters
 ..D ^DIC  ; Fileman LAYGO lookup
 ;
 ; add modifiers
 I ACPTCODE?2U!(ACPTCODE?1U1N) D
 .S ACPTIEN=$O(^AUTTCMOD("B",ACPTCODE,0)) ; find code's record number
 .I 'ACPTIEN D  ; if there isn't one yet, create it
 ..S ACPTIEN=$A(ACPTCODE)_$A(ACPTCODE,2) ; DINUM based on ASCII of code
 ..S ^AUTTCMOD(ACPTIEN,0)=ACPTCODE_U_U_ACPTYR ; set Code & Date Added
 ..S ^AUTTCMOD("B",ACPTCODE,ACPTIEN)="" ; and cross-reference it
 .;
 .S ACPTSHRT=$$CLEAN($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U),1)  ;Short desc
 .I ACPTSHRT'="" D  ; if a description is present in the AMA file
 ..S $P(^AUTTCMOD(ACPTIEN,0),U,2)=ACPTSHRT ; set the field
 .S $P(^AUTTCMOD(ACPTIEN,0),U,4)="" ; clear Date Deleted (.04)
 .;
 .N ACPTDESC ; Long Description (1)
 .S ACPTDESC=$$CLEAN($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,2))  ;Long Desc
 .D TEXT(.ACPTDESC) ; convert string to WP array
 .K ^AUTTCMOD(ACPTIEN,1) ; delete its subtree
 .M ^AUTTCMOD(ACPTIEN,1)=ACPTDESC  ; copy array to field, incl. header
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
DELCODE ;
 S ACPTIEN=0
 S ACPTSHRT="Couldn't find code to inactivate"
 F  S ACPTIEN=$O(^ICPT("B",ACPTCODE,ACPTIEN)) Q:'ACPTIEN  D  ; find the code's record number
 .S:$P($G(^ICPT(ACPTIEN,0)),U,2)'="" ACPTSHRT=$P(^ICPT(ACPTIEN,0),U,2)
 .S $P(^ICPT(ACPTIEN,0),U,7)=ACPTYR  ; Date Deleted (8) to 3081231
 .S:ACPTCODE="S8190" $P(^ICPT(ACPTIEN,0),U,7)=3090401
 .;
 .K DIC,DIE,DIR,X,Y,DA,DR
 .S DA(1)=ACPTIEN  ; parent record, i.e., the CPT code
 .S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 .S DIC(0)="L"  ; allow LAYGO (Learn As You Go, i.e., add if not found)
 .S DIC("P")=$P(^DD(81,60,0),"^",2)  ; subfile # & specifier codes
 .S X="01/01/2009"  ; value to lookup in the subfile
 .S:ACPTCODE="S8190" X="04/01/2009"
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
