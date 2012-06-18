BKM11PST ;APTIV/HC/ALA-Ver 1.1 Post Install ; 10 Jan 2008  11:30 AM
 ;;2.0;HIV MANAGEMENT SYSTEM;;May 29, 2009
 ;
 ;**Program Description**
 ;    This is the post-installation program to set up values for the
 ;    HIV Management System
 ;
EN ;  Entry Point
 ;
 ;  Never before installed
 I $O(^BKM(90450,0))="" D
 . D INIT
 ;
 I '$$PATCH^XPDUTL("BKM*1.0*1") D PTCH1
 I '$$PATCH^XPDUTL("BKM*1.0*2") D PTCH2
 ;
 Q
 ;
PRE ;  Preinstall
 NEW DA,DIK
 S DIK="^BKM(90454,"
 S DA=0
 F  S DA=$O(^BKM(90454,DA)) Q:'DA  D ^DIK
 ;
 S DA=1,DIK="^BKM(90456," D ^DIK
 ;
 NEW DA,DIK
 S DIK="^BKM(90450,",DA=1 D ^DIK
 Q
 ;
INIT ;  Set up the HIV registry entry
 NEW X,DIC,DLAYGO,REGISTER,DA,DR,DIE,Y
 S X="HMS REGISTER",DIC(0)="LMNZ",DLAYGO=90450,DIC="^BKM(90450,"
 D ^DIC
 S (REGISTER,DA)=+Y
 S DR=".02////HMS;12////1;12.5////1;19////0",DIE=DIC D ^DIE
 ;
 ;  Add the intro text for autopopulate
 NEW BI,LM K ^TMP($J,"BKMTXT")
 F BI=1:1:18 S LM=$T(TXT+BI) Q:LM=" Q"  S ^TMP($J,"BKMTXT",BI,0)=$P(LM,";;",2)
 D WP^DIE(90450,REGISTER,50,"","^TMP($J,""BKMTXT"")")
 K ^TMP($J,"BKMTXT")
 ;
QM ;  Set up QMAN entries
 NEW X,DIC,DLAYGO,DA,DR,DIE,LINK,Y,TERM
 S X="PATIENT;IMM",DIC(0)="LMNZ",DLAYGO=9009071,DIC="^AMQQ(1,"
 D ^DIC
 S (DA,LINK)=+Y
 S BKMUPD(9009071,LINK_",",1)=9999999.14,BKMUPD(9009071,LINK_",",2)=9000010.11
 S BKMUPD(9009071,LINK_",",3)=".01",BKMUPD(9009071,LINK_",",4)=10,BKMUPD(9009071,LINK_",",7)=1
 D FILE^DIE("","BKMUPD")
 K BKMUPD,X,DA,DIC,DIE,DLAYGO,Y
 ;
 S X="HMS IMMUNIZATION",DIC(0)="LMNZ",DLAYGO=9009075,DIC="^AMQQ(5,"
 D ^DIC
 S (DA,TERM)=+Y
 S BKMUPD(9009075,TERM_",",1)="P",BKMUPD(9009075,TERM_",",3)=1,BKMUPD(9009075,TERM_",",4)=LINK
 S BKMUPD(9009075,TERM_",",13)=3,BKMUPD(9009075,TERM_",",14)="IMMUNIZATION"
 S BKMUPD(9009075,TERM_",",18)="AUTTIMM(",BKMUPD(9009075,TERM_",",19)="C"
 S BKMUPD(9009075,TERM_",",20)="M"
 D FILE^DIE("","BKMUPD")
 K BKMUPD,X,DA,DIC,DIE,DLAYGO,Y
 ;
 S X="HMS IMMUNIZATIONS",DA(1)=TERM,DIC(0)="LMNZ",DIC="^AMQQ(5,"_DA(1)_",1,",DLAYGO=9009075.01
 D ^DIC
 ;
 NEW X,DIC,DLAYGO,DA,DR,DIE,LINK,Y,TERM
 S X="PATIENT;LOINC",DIC(0)="LMNZ",DLAYGO=9009071,DIC="^AMQQ(1,"
 D ^DIC
 S (DA,LINK)=+Y
 S BKMUPD(9009071,LINK_",",1)=95.3,BKMUPD(9009071,LINK_",",2)=9000010.09
 S BKMUPD(9009071,LINK_",",3)=".01",BKMUPD(9009071,LINK_",",4)=10,BKMUPD(9009071,LINK_",",7)=1
 D FILE^DIE("","BKMUPD")
 K BKMUPD,X,DA,DIC,DIE,DLAYGO,Y
 ;
 S X="LOINC",DIC(0)="LMNZ",DLAYGO=9009075,DIC="^AMQQ(5,"
 D ^DIC
 S (DA,TERM)=+Y
 S BKMUPD(9009075,TERM_",",1)="P",BKMUPD(9009075,TERM_",",3)=4,BKMUPD(9009075,TERM_",",4)=LINK
 S BKMUPD(9009075,TERM_",",13)=3,BKMUPD(9009075,TERM_",",14)="LOINC"
 S BKMUPD(9009075,TERM_",",18)="LAB(95.3,",BKMUPD(9009075,TERM_",",19)="C"
 S BKMUPD(9009075,TERM_",",20)="M"
 D FILE^DIE("","BKMUPD")
 K BKMUPD,X,DA,DIC,DIE,DLAYGO,Y
 ;
 S X="HMS IMMUNIZATIONS",DA(1)=TERM,DIC(0)="LMNZ",DIC="^AMQQ(5,"_DA(1)_",1,",DLAYGO=9009075.01
 D ^DIC
 ;
MENU ;  Add option to menu
 S MOK=$$ADD^XPDMENU("BKMV REPORTS","BGPMENU","GPRA",7)
 S MOK=$$ADD^XPDMENU("BKMV OTHER RPMS","LR IHS MENU")
 S MOK=$$ADD^XPDMENU("BKMV OTHER RPMS","PSO USER1")
 S MOK=$$ADD^XPDMENU("BKMV OTHER RPMS","GMRAMGR")
 S MOK=$$ADD^XPDMENU("BKMV OTHER RPMS","AGMENU")
 S MOK=$$ADD^XPDMENU("BKMV OTHER RPMS","BMCMENU")
 S MOK=$$ADD^XPDMENU("BKMV OTHER RPMS","AMQQMENU")
 S MOK=$$ADD^XPDMENU("BKMV OTHER RPMS","BSDMENU")
 S MOK=$$ADD^XPDMENU("XUCORE","BKMVMENU","HMS",7)
 K MOK
 ;
BLR ;
 ; Check the IHS LAB CPT CODE File for bad pointers
 NEW CT,BLN,LBN,XMY,XMZ
 K ^TMP("BQIMAIL",$J)
 S BLN=0,CT=0
 F  S BLN=$O(^BLRCPT(BLN)) Q:'BLN  D
 . S LBN=$P($G(^BLRCPT(BLN,1)),U,1)
 . Q:LBN=""
 . Q:$G(^LAB(60,LBN,0))'=""
 . S CT=CT+1,^TMP("BQIMAIL",$J,CT,0)="The "_$P(^BLRCPT(BLN,0),U,1)_" record in the IHS LAB CPT CODE File #9009021 PANEL/TEST pointer does not exist in the LAB TEST File #60."
 I $D(^TMP("BQIMAIL",$J))>0 D
 . S CT=CT+1,^TMP("BQIMAIL",$J,CT,0)=" "
 . S CT=CT+1,^TMP("BQIMAIL",$J,CT,0)="Go to option BLR EDIT IHS LAB CPT FILE to correct these records."
 . S XMSUB="iCare Install Problem"
 . S XMTEXT="^TMP(""BQIMAIL"",$J,"
 . I $G(DUZ)'="" S XMDUZ=DUZ,XMY(DUZ)=""
 . I $G(DUZ)="" S XMDUZ="iCare Install"
 . S XMY(DUZ)=""
 . NEW BDUZ
 . S BDUZ="" F  S BDUZ=$O(^XUSEC("LRLIASON",BDUZ)) Q:BDUZ=""  D
 .. I $P($G(^VA(200,BDUZ,0)),U,11)'="" Q
 .. S XMY(BDUZ)=""
 . I '$D(XMY) S XMY(.5)=""
 . D ^XMD
 ;
LTAX ;  Add Lab Taxonomies to ^ATXLAB
 NEW X,DIC,DLAYGO,DA,DR,DIE,Y,LTAX
 S DIC="^ATXLAB(",DIC(0)="L",DLAYGO=9002228
 ; Loop through the Taxonomies as stored in routine BKMVTAX4.
 D LDLAB^BKMVTAX4(.LTAX)
 F BJ=1:1 Q:'$D(LTAX(BJ))  S X=LTAX(BJ) D
 . I $D(^ATXLAB("B",X)) Q  ; Skip pre-existing Lab taxonomies
 . D ^DIC S DA=+Y
 . I DA<1 Q
 . S BKTXUP(9002228,DA_",",.02)=$P(X," ",2,999)
 . S BKTXUP(9002228,DA_",",.05)=DUZ
 . S BKTXUP(9002228,DA_",",.06)=DT
 . S BKTXUP(9002228,DA_",",.09)=60
 . D FILE^DIE("I","BKTXUP")
 . S BKTXUP(9002228,DA_",",.08)="B"
 . D FILE^DIE("E","BKTXUP")
 ;
 K DA,BJ,BKTXUP
 ;
TAX ;  Set up the taxonomies
 D ^BKMTX
 D ^BKMATX
 D ^BKMBTX
 D ^BKMCTX
 D ^BKMDTX
 ;
USR ;  Set up the Case File Manager
 ;D CFM^BKMVB1
 K IEN,HIVIEN,GETDFN,BKMUSER,OCCUP,USER,X,Y
 ;
 ; PRXM/HC/BHS - 05/10/2006 - Convert UN code to UNR per IHS
UNR ; Check the HMS CANDIDATE File for Status (.03) = "UN" and
 ; if found convert to "UNR"
 NEW DA,DIE,DR,STATUS
 S DA=0
 F  S DA=$O(^BKM(90451.2,DA)) Q:'DA  D
 . S STATUS=$$GET1^DIQ(90451.2,DA,".03","I")
 . ; Only convert UN code to UNR
 . Q:STATUS'="UN"
 . S DIE="^BKM(90451.2,",DR=".03///UNR"
 . D ^DIE
 ;
 Q
 ;
TXT ; Text to be stored
 ;;The autopopulate function will search your RPMS database to identify
 ;;patient candidates for your site's HMS Register.  You can review your
 ;;candidate list (REV option) after the autopopulate and move selected
 ;;patients to the Register.
 ;;  
 ;;HMS uses the following logic to identify patients as candidates:
 ;;   1.  at least one POV or Problem List diagnosis of HIV ever; or
 ;;   2.  a positive result on an HIV test; or
 ;;   3.  at least 2 of any antiretroviral medications (NRTI, NNRTI, PI or
 ;;       FI medications)
 ;;  
 ;;See the User Manual for complete, detailed definitions and related
 ;;taxonomies.
 ;;  
 ;;Checking for Taxonomies . . .
 ;;  
 ;;In order for the HMS autopopulate function to find all necessary data,
 ;;several taxonomies must be established.
 Q
 ;
PTCH1 ; Patch 1 postinstall fixes
 ;  Check candidate list and remove entries
 NEW DFN,MED,DFLG,STAT,TAX
 S DFN=0
 F  S DFN=$O(^BKM(90451.2,DFN)) Q:'DFN  D
 . S STAT=$P(^BKM(90451.2,DFN,0),U,3)
 . I STAT="NOT"!(STAT="REM") Q
 . S MED=0,DFLG=0
 . F  S MED=$O(^BKM(90451.2,DFN,3,MED)) Q:'MED  D  Q:DFLG
 .. S TAX=$P(^BKM(90451.2,DFN,3,MED,0),U,3)
 .. I TAX="BKMV EI MEDS"!(TAX="BKMV NNRTI MEDS")!(TAX="BKMV NRTI MEDS")!(TAX="BKMV PI MEDS") S DFLG=1 Q
 . I DFLG D
 .. NEW DA,DIK
 .. S DA=DFN,DIK="^BKM(90451.2," D ^DIK
 ;
TX ;  Check taxonomies
 NEW TAX,DIC,X,TDA,Y
 S DIC="^ATXAX(",DIC(0)="Z"
 S TAX="BKMV EI MEDS",X=TAX D ^DIC S TDA=+Y
 I TDA'=-1 D
 . NEW DA,VALUE
 . S DA(1)=TDA,DA=0
 . F  S DA=$O(^ATXAX(TDA,21,DA)) Q:'DA  D
 .. S VALUE=$P(^ATXAX(TDA,21,DA,0),U,1)
 .. I VALUE=5201!(VALUE=83677)!(VALUE=84151) D
 ... S DIK="^ATXAX("_DA(1)_",21," D ^DIK
 ;
 NEW TAX,DIC,X,TDA,Y
 S DIC="^ATXAX(",DIC(0)="Z"
 S TAX="BKMV NNRTI MEDS",X=TAX D ^DIC S TDA=+Y
 I TDA'=-1 D
 . NEW DA,VALUE
 . S DA(1)=TDA,DA=0
 . F  S DA=$O(^ATXAX(TDA,21,DA)) Q:'DA  D
 .. S VALUE=$P(^ATXAX(TDA,21,DA,0),U,1)
 .. I VALUE=84282!(VALUE=84317)!(VALUE=84318) D
 ... S DIK="^ATXAX("_DA(1)_",21," D ^DIK
 ;
 NEW TAX,DIC,X,TDA,Y
 S DIC="^ATXAX(",DIC(0)="Z"
 S TAX="BKMV NRTI MEDS",X=TAX D ^DIC S TDA=+Y
 I TDA'=-1 D
 . NEW DA,VALUE
 . S DA(1)=TDA,DA=0
 . F  S DA=$O(^ATXAX(TDA,21,DA)) Q:'DA  D
 .. S VALUE=$P(^ATXAX(TDA,21,DA,0),U,1)
 .. I VALUE=83981!(VALUE=84378)!(VALUE=84431)!(VALUE=84317)!(VALUE=84089) D
 ... S DIK="^ATXAX("_DA(1)_",21," D ^DIK
 ;
 NEW TAX,DIC,X,TDA,Y
 S DIC="^ATXAX(",DIC(0)="Z"
 S TAX="BKMV PI MEDS",X=TAX D ^DIC S TDA=+Y
 I TDA'=-1 D
 . NEW DA,VALUE
 . S DA(1)=TDA,DA=0
 . F  S DA=$O(^ATXAX(TDA,21,DA)) Q:'DA  D
 .. S VALUE=$P(^ATXAX(TDA,21,DA,0),U,1)
 .. I VALUE=84281!(VALUE=84374)!(VALUE=84318) D
 ... S DIK="^ATXAX("_DA(1)_",21," D ^DIK
 Q
 ;
PTCH2 ; Patch 2 post install fixes
 ; Set up new taxonomies for STI
 D ^BKMETX
 ;
LLTAX ;  Add Lab Taxonomies to ^ATXLAB
 NEW X,DIC,DLAYGO,DA,DR,DIE,Y,LTAX
 S DIC="^ATXLAB(",DIC(0)="L",DLAYGO=9002228
 ; Loop through the Taxonomies as stored in routine BKMVTAX4.
 D LDLAB(.LTAX)
 F BJ=1:1 Q:'$D(LTAX(BJ))  S X=LTAX(BJ) D
 . I $D(^ATXLAB("B",X)) Q  ; Skip pre-existing Lab taxonomies
 . D ^DIC S DA=+Y
 . I DA<1 Q
 . S BQTXUP(9002228,DA_",",.02)=$P(X," ",2,999)
 . S BQTXUP(9002228,DA_",",.05)=DUZ
 . S BQTXUP(9002228,DA_",",.06)=DT
 . S BQTXUP(9002228,DA_",",.09)=60
 . D FILE^DIE("I","BQTXUP")
 . S BQTXUP(9002228,DA_",",.08)="B"
 . D FILE^DIE("E","BQTXUP")
 ;
 K DA,BJ,BQTXUP
 Q
 ;
LDLAB(ARRAY) ;EP - Load site-populated Lab tests
 NEW I,TEXT
 F I=1:1 S TEXT=$P($T(LAB+I),";;",2) Q:TEXT=""  S ARRAY(I)=TEXT
 Q
 ;
LAB ;LAB TESTS (SITE-POPULATED)
 ;;BGP CHLAMYDIA TESTS TAX
 ;;BGP HIV TEST TAX
 ;;BKM GONORRHEA TEST TAX
 ;;BKM HEP B TAX
 ;;BKM FTA-ABS TEST TAX
 ;;BKM RPR TAX
 ;;
