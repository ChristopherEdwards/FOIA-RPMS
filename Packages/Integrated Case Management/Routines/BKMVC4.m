BKMVC4 ;PRXM/HC/JGH - User Maintenance; 24-JAN-2005
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
EN ; EP - Main entry point for BKMV List Users
 NEW N,T,UR,HIVIEN,DFN,TEXT
 ; Check for existence of HIV system
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) D EN^DDIOL("You are not a valid HMS user.") H 2 Q
 K ^TMP("BKMVC4",$J)
 D EN^VALM("BKMV LIST USERS")
 QUIT
 ;
HDR ; -- header code
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-$L(SITE)+2)\2)_"["_$G(SITE)_"]"
 S VALMHDR(2)="    User Name"_$$PAD^BKMIXX4("Access Role","<"," ",38)
 QUIT
 ;
INIT ; -- init variables and list array
 K BKM
 NEW BKMNM
 S VALMCNT=0,VALMAR="^TMP(""BKMVC4"","_$J_")",VALM0=""
 S DFN=""
 F  S DFN=$O(^BKM(90450,HIVIEN,11,"B",DFN)) Q:DFN=""  D
 .S BKM($P(^VA(200,DFN,0),U,1))=DFN
 S BKMNM="" F  S BKMNM=$O(BKM(BKMNM)) Q:BKMNM=""  D
 .S N=BKMNM,DFN=BKM(BKMNM)
 . S T="",UR=$O(^BKM(90450,HIVIEN,11,"B",DFN,""))
 . S:UR'="" T=$$GET1^DIQ(90450.011,UR_","_HIVIEN,.5,"E")
 . S TEXT=$$PAD^BKMIXX4(" ","<"," ",4)_$$PAD^BKMIXX4(N,">"," ",36)_T
 . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 QUIT
 ;
HELP ; -- help code
 N X S VALMBCK=""
 W !!,"Enter 'A' to provide a user with access to HMS,"
 W !,"      'E' to edit an existing HMS user's access role or"
 W !,"      'D' to delete a user's access to HMS."
 S X=$$PAUSE^BKMIXX3
    S X="?" D DISP^XQORM1 W !
 QUIT
 ;
EXIT ; -- exit code
 K DA,IENS,SITE,IEN,CHC,KEY,VALM0,VALMBCK,USER,BKMUSER,OCCUP,EXIT,KEYCHK,KEY,KEYIEN
 K ^TMP("BKMVC4",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
ADS(ACTION) ;Add, Edit or Delete User
 ;ACTION is set to A, E or D, respectively
 D ADSUSER^BKMVB1(ACTION)
 W @IOF
 K ^TMP("BKMVC4",$J)
 D INIT
 QUIT
