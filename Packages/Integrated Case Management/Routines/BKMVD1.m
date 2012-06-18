BKMVD1 ;PRXM/HC/BHS - V-File Elder Care Add/Edit/Delete; 24-JAN-2005 ; 12 Apr 2005  1:22 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT --  ListMan template BKMV PCC ELDER UPDATE
 ; Called by Add New Data option for Elder Care
 ; Assumes existence of DFN,DUZ
 ;
 ; Display temporary disabled message until
 ;  V Elder Care API template for APCDALVR is created
 D EN^DDIOL("This option is currently unavailable.")
 S BKMTMP=$$PAUSE^BKMIXX3()
 K BKMTMP
 Q
 ;
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 K ^TMP("BKMVD1",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC ELDER UPDATE")
 D ^XBFMK
 D EXIT
 Q
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
 K ^TMP("BKMVD1",$J)
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
 N DA0,DA1,TEXT,ELDER,IENS
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD1"","""_$J_""")",VALM0=""
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 S ELDER=""
 F  S ELDER=$O(^BKM(90459,DA1,16,"B",ELDER),-1) Q:ELDER=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,16,"B",ELDER,DA0)) Q:DA0=""  D
 . . S DA(1)=DA1,DA=DA0
 . . S IENS=$$IENS^DILF(.DA)
 . . S TEXT=$$PAD^BKMIXX4($$FMTE^XLFDT($$GET1^DIQ(90459.1616,IENS,".01","I"),5),">"," ",55)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Toileting: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".04","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Bathing: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".05","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Dressing: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".06","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Transfers: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".07","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Feeding: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".08","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Continence: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".09","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Finances: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".11","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Cooking: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".12","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Shopping: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".13","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Housework: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".14","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Medications: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".15","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Transportation: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".16","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Change In Function: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".17","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Patient Caregiver: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,".18","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Ordering Provider: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,"1202","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Clinic: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,"1203","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Encounter Provider: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,"1204","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" External Key: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,"1209","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Outside Prov Name: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(90459.1616,IENS,"1210","E"),">"," ",55)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 D ^XBFMK
 Q
 ;
ADD ; Add entry to File 90459
 D FULL^VALM1
 N DA,DIC,Y,DIE,DR,BKDTM
 S DA(1)=$O(^BKM(90459,"B",$J,""))
 Q:DA(1)=""
 ; Default to today's date for prompt
 ;D NOW^%DTC
 S X=$$NOW^XLFDT()
 I $G(AUPNDOD)'="" S X=$$FMADD^XLFDT(AUPNDOD,-1)
 S DIC="^BKM(90459,"_DA(1)_",16,"
 S DIC(0)="L"
 ; Add new entry
 K DO
 D FILE^DICN
 I Y'=-1 D
 . ; Edit Exam fields in subfile
 . S DIE=DIC
 . K DIC
 . ; Internal entry number of subentry chosen
 . S DA=+Y
 . S DR=".02;.01;.04"
 . D ^DIE
 . S BKDTM=$$GET1^DIQ(90459.1616,DA_","_DA(1)_",",.01,"I")
 . I $P(BKMDTM,".")#100=0!(BKMDTM=(BKMDTM\1)) D
 . . ; Default to first day of month, if date is imprecise
 . . I $P(BKMDTM,".")#100=0 D
 . . . S BKMDTM=$S($L(BKMDTM,".")=2:($P(BKMDTM,".")+1)_"."_$P(BKMDTM,".",2),1:$P(BKMDTM,".")+1)
 . . ; Default time to noon, if not included, unless it is in the future
 . . I BKMDTM=(BKMDTM\1) D
 . . . S BKMDTM=BKMDTM_".1200"
 . . . I BKMDTM>$$NOW^XLFDT() S BKMDTM=$$NOW^XLFDT()
 . . S DR=".01///"_BKDTM
 . . D ^DIE
 ;
 K ^TMP("BKMVD1",$J)
 D INIT
 Q
 ;
EDIT ; Edit File 90459
 I +$G(VALMCNT)=0 D EN^DDIOL("No items to select") H 2 Q
 D FULL^VALM1
 N BKMLST,BKMI,VALMI,VALMAT,DA,DIE,DR,BKDTM
 S BKMLST=$$SELECT^BKMVD2()
 I BKMLST'="" D
 . F BKMI=1:1:$L(BKMLST,",") S VALMI=$P(BKMLST,",",BKMI) Q:'VALMI  D
 . . S VALMAT=$O(@VALMAR@("IDX",VALMI,""))
 . . Q:VALMAT=""
 . . S DA(1)=$O(^BKM(90459,"B",$J,""))
 . . Q:DA(1)=""
 . . S DA=VALMAT
 . . S DIE="^BKM(90459,"_DA(1)_",16,"
 . . S DR=".02;.01;.04"
 . . D ^DIE
 . . S BKDTM=$$GET1^DIQ(90459.1616,DA_","_DA(1)_",",.01,"I")
 . . I $P(BKMDTM,".")#100=0!(BKMDTM=(BKMDTM\1)) D
 . . . ; Default to first day of month, if date is imprecise
 . . . I $P(BKMDTM,".")#100=0 D
 . . . . S BKMDTM=$S($L(BKMDTM,".")=2:($P(BKMDTM,".")+1)_"."_$P(BKMDTM,".",2),1:$P(BKMDTM,".")+1)
 . . . ; Default time to noon, if not included, unless it is in the future
 . . . I BKMDTM=(BKMDTM\1) D
 . . . . S BKMDTM=BKMDTM_".1200"
 . . . . I BKMDTM>$$NOW^XLFDT() S BKMDTM=$$NOW^XLFDT()
 . . . S DR=".01///"_BKDTM
 . . . D ^DIE
 . . W " Edited!" H 2
 K ^TMP("BKMVD1",$J)
 D INIT
 Q
 ;
DELETE ; Delete entry in File 90459
 I +$G(VALMCNT)=0 D EN^DDIOL("No items to select") H 2 Q
 D FULL^VALM1
 N BKMLST,BKMI,VALMI,VALMAT,DA,DIK
 S BKMLST=$$SELECT^BKMVD2()
 I BKMLST'="" D
 . F BKMI=1:1:$L(BKMLST,",") S VALMI=$P(BKMLST,",",BKMI) Q:'VALMI  D
 . . S VALMAT=$O(@VALMAR@("IDX",VALMI,""))
 . . Q:VALMAT=""
 . . ; Confirm deletion
 . . I '$$YNP^BKMVD2("Confirm deletion of Item "_VALMI) Q
 . . S DA(1)=$O(^BKM(90459,"B",$J,""))
 . . Q:DA(1)=""
 . . S DA=VALMAT
 . . S DIK="^BKM(90459,"_DA(1)_",16,"
 . . D ^DIK
 . . W " Deleted!" H 2
 K ^TMP("BKMVD1",$J)
 D INIT
 Q
 ;
 ;
