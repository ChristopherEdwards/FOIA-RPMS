BKM1POST ;PRXM/HC/ALA - HMS Version 1.0 Post-Installation ; 21 Jul 2005  9:46 PM
 ;;1.0;HIV MANAGEMENT SYSTEM;;Sep 08, 2006
 ;
 ;**Program Description**
 ;    This is the post-installation program to set up values for the
 ;    HIV Management System
 ;
EN ;  Entry Point
 ;
 ;  Set up the HIV registry entry
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
 D CFM^BKMVB1
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
