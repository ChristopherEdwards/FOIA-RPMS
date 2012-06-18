BKMVD2 ;PRXM/HC/JGH - V-File Exam Add/Edit/Delete; 24-JAN-2005 ; 12 Apr 2005  1:54 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT --  ListMan template BKMV PCC EXAM UPDATE
 ; Called by Add New Data option for Exam
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 K ^TMP("BKMVD2",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC EXAM UPDATE")
 D ^XBFMK
 D EXIT
 Q
 ;
YNP(PROMPT,DFLT) ; EP - Yes/No Prompt
 ; Input variables:
 ;  PROMPT - Prompt text
 ;  DFLT   - 'YES' or 'NO'
 ; Output variables:
 ;  0/1 - Returned extrinsically
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("A")=PROMPT
 I $G(DFLT)="NO"!($G(DFLT)="YES") S DIR("B")=$G(DFLT)
 D ^DIR I $D(DTOUT)!$D(DUOUT) Q 0
 Q $S(+$G(Y)=0:0,1:1)
 ;
HDR ; -- header code
 ; Assumes existence of DUZ
 N DA,IENS,SITE
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-$L(SITE)+2)\2)_"["_$G(SITE)_"]"
 S VALMHDR(2)=$G(RCRDHDR)
 Q
 ;
INIT ; -- init variables and list array
 ; Assumes existence of DFN
 D GETALL(DFN)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVD2",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GETALL(DFN) ; Build ListMan display array
 ; Input variables:
 ;  DFN - IEN for File 2
 ; Output variables:
 ;  VALMAR - Builds ListMan array
 ;  VALMCNT - List array count
 ;  VALM0
 N DA0,DA1,TEXT,XAMDT,IENS,PXAMDT
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD2"","""_$J_""")",VALM0=""
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 S (XAMDT,PXAMDT)=""
 F  S XAMDT=$O(^BKM(90459,DA1,17,"B",XAMDT),-1) Q:XAMDT=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,17,"B",XAMDT,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S IENS=$$IENS^DILF(.DA)
 . . S VALMCNT=$G(VALMCNT)+1
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($$PAD^BKMIXX4(VALMCNT,"<"," ",3)_".",TEXT,"Item")
 . . ;S TEXT=$$SETFLD^VALM1($$FMTE^XLFDT($$GET1^DIQ(90459.1717,IENS,".01","I"),"5Z"),TEXT,"Visit")
 . . ; Display only date when it does not equal the previous date
 . . S TEXT=$$SETFLD^VALM1($S((XAMDT\1)'=(PXAMDT\1):$$FMTE^XLFDT(XAMDT\1,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(90459.1717,IENS,".02","E"),TEXT,"Exam")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(90459.1717,IENS,".04","E"),TEXT,"Result")
 . . D SET^VALM10(VALMCNT,TEXT,DA0)
 . . S PXAMDT=XAMDT
 D ^XBFMK
 Q
 ;
ADD ; Add entry to File 90459
 D FULL^VALM1
 N DA,DA1,DA0,DIC,Y,DIE,DR,BKMDTM,IENS,BKMXAM,DIK,BKMDOD
 S (DA(1),DA1)=$O(^BKM(90459,"B",$J,""))
 Q:DA(1)=""
 ; Default to today's date for prompt, except for deceased patients
 ;S X=$$NOW^XLFDT()
 S X=$$DT^XLFDT()
 S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 I BKMDOD'="" S X=$$FMADD^XLFDT(BKMDOD,-1)
 S DIC="^BKM(90459,"_DA(1)_",17,"
 S DIC(0)="L"
 ; Add new entry
 K DO
 D FILE^DICN
 I Y=-1 G ADDX
 S DA0=+Y
ADD1 ; Edit Exam fields in subfile
 S DIE="^BKM(90459,"_DA1_",17,"
 ; Internal entry number of subentry chosen
 S DA=DA0,DA(1)=DA1
 S DR=".02;.01;.04"
 D ^DIE
 K DA
 S DA=DA0,DA(1)=DA1,IENS=$$IENS^DILF(.DA)
 S BKMDTM=$$GET1^DIQ(90459.1717,IENS,".01","I")
 S BKMXAM=$$GET1^DIQ(90459.1717,IENS,".02","I")
 I BKMDTM=""!(BKMXAM="") D  G ADDX
 . K DA
 . S DA=DA0,DA(1)=DA1
 . S DIK="^BKM(90459,"_DA(1)_",17,"
 . D ^DIK
 . W " *** Required field(s) missing, entry deleted! ***" H 1
 I $P(BKMDTM,".")#100=0!(BKMDTM=(BKMDTM\1)) D
 . ; Default to first day of month, if date is imprecise
 . I $P(BKMDTM,".")#100=0 D
 . . S BKMDTM=$S($L(BKMDTM,".")=2:($P(BKMDTM,".")+1)_"."_$P(BKMDTM,".",2),1:$P(BKMDTM,".")+1)
 . ; Default time to noon, if not included, unless it is in the future
 . I BKMDTM=(BKMDTM\1) D
 . . S BKMDTM=BKMDTM_".1200"
 . . I BKMDTM>$$NOW^XLFDT() S BKMDTM=$$NOW^XLFDT()
 . S DR=".01///"_BKMDTM
 . D ^DIE
 ;
ADDX ; Add entry exit point
 K ^TMP("BKMVD2",$J)
 D INIT
 Q
 ;
EDIT ; Edit File 90459
 I +$G(VALMCNT)=0 D EN^DDIOL("No items to select") H 2 Q
 D FULL^VALM1
 N BKMLST,BKMI,VALMI,VALMAT,DA,DIE,DR,BKMDTM
 S BKMLST=$$SELECT()
 I BKMLST'="" D
 . F BKMI=1:1:$L(BKMLST,",") S VALMI=$P(BKMLST,",",BKMI) Q:'VALMI  D
 . . S VALMAT=$O(@VALMAR@("IDX",VALMI,""))
 . . Q:VALMAT=""
 . . S DA(1)=$O(^BKM(90459,"B",$J,""))
 . . Q:DA(1)=""
 . . S DA=VALMAT
 . . S DIE="^BKM(90459,"_DA(1)_",17,"
 . . S DR=".02;.01;.04"
 . . D ^DIE
 . . ; If user deleted .01 field, DA is killed so quit this iteration
 . . I '$D(DA) Q
 . . S BKMDTM=$$GET1^DIQ(90459.1717,DA_","_DA(1)_",",.01,"I")
 . . I $P(BKMDTM,".")#100=0!(BKMDTM=(BKMDTM\1)) D
 . . . ; Default to first day of month, if date is imprecise
 . . . I $P(BKMDTM,".")#100=0 D
 . . . . S BKMDTM=$S($L(BKMDTM,".")=2:($P(BKMDTM,".")+1)_"."_$P(BKMDTM,".",2),1:$P(BKMDTM,".")+1)
 . . . ; Default time to noon, if not included, unless it is in the future
 . . . I BKMDTM=(BKMDTM\1) D
 . . . . S BKMDTM=BKMDTM_".1200"
 . . . . I BKMDTM>$$NOW^XLFDT() S BKMDTM=$$NOW^XLFDT()
 . . . S DR=".01///"_BKMDTM
 . . . D ^DIE
 . . W " Edited!" H 2
 K ^TMP("BKMVD2",$J)
 D INIT
 Q
 ;
DELETE ; Delete entry in File 90459
 I +$G(VALMCNT)=0 D EN^DDIOL("No items to select") H 2 Q
 D FULL^VALM1
 N BKMLST,BKMI,VALMI,VALMAT,DA,DIK
 S BKMLST=$$SELECT()
 I BKMLST'="" D
 . F BKMI=1:1:$L(BKMLST,",") S VALMI=$P(BKMLST,",",BKMI) Q:'VALMI  D
 . . S VALMAT=$O(@VALMAR@("IDX",VALMI,""))
 . . Q:VALMAT=""
 . . ; Confirm deletion
 . . I '$$YNP("Confirm deletion of Item "_VALMI,"NO") Q
 . . S DA(1)=$O(^BKM(90459,"B",$J,""))
 . . Q:DA(1)=""
 . . S DA=VALMAT
 . . S DIK="^BKM(90459,"_DA(1)_",17,"
 . . D ^DIK
 . . W " Deleted!" H 2
 K ^TMP("BKMVD2",$J)
 D INIT
 Q
 ;
SELECT() ; EP - Select one entry from the list
 N DIR,X,Y,DTOUT,DUOUT
 S DIR(0)="L^1:"_$G(VALMCNT)
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q ""
 Q Y
 ;
 ;
