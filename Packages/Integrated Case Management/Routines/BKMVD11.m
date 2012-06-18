BKMVD11 ;PRXM/HC/JGH - V File Elder Care Review History; 24-JAN-2005 ; 12 Apr 2005  1:32 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC ELDER REVIEW
 ; Called by Review History option for Elder Care
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVD11",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC ELDER REVIEW")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ,RCRDHDR
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
 K ^TMP("BKMVD11",$J)
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
 N DA0,DA1,TEXT,ELDER,IENS,BKMODT,VELD
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD11"","""_$J_""")",VALM0=""
 S BKMODT=0
 F  S BKMODT=$O(^AUPNVELD("AA",DFN,BKMODT)) Q:BKMODT=""  D
 . S VELD="" F  S VELD=$O(^AUPNVELD("AA",DFN,BKMODT,VELD)) Q:VELD=""  D
 . . D ^XBFMK
 . . S DA=VELD
 . . S IENS=$$IENS^DILF(.DA)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,"")
 . . S TEXT=$$PAD^BKMIXX4($$FMTE^XLFDT($$GET1^DIQ(9000010.35,IENS,"1201","I"),5),">"," ",55)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Toileting: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".04","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Bathing: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".05","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Dressing: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".06","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Transfers: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".07","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Feeding: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".08","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Continence: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".09","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Finances: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".11","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Cooking: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".12","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Shopping: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".13","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Housework: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".14","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Medications: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".15","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Transportation: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".16","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Change In Function: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".17","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Patient Caregiver: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,".18","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Ordering Provider: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,"1202","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" Clinic: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,"1203","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Encounter Provider: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,"1204","E"),">"," ",20)
 . . S TEXT=TEXT_$$PAD^BKMIXX4(" External Key: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,"1209","E"),">"," ",20)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("Outside Prov Name: ",">"," ",20)_$$PAD^BKMIXX4($$GET1^DIQ(9000010.35,IENS,"1210","E"),">"," ",55)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 D ^XBFMK
 Q
 ;
GETDA(DFN,VALUE) ; Return IEN for the Patient DFN with the Register value
 ; Search for the appropriate register VALUE for the patient DFN and return the
 ; patient IEN in the variable DA.
 ; If the variable VALUE contains a 1 then the IEN for the patient in the 
 ; HIV Management System is returned.
 ; Returns the entry from the HMS PCC ENTRY UPDATE file for the DFN that is associated with the HIV Registry
 N DA
 S DA="" F  S DA=$O(^AUPNVELD("AC",DFN,DA)) Q:DA=""
 Q DA
 ;
 ;
