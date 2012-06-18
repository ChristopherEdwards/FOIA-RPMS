AG71A9 ;VNGT/HS/BEE - Patient Registration 7.1 PATCH 9 POST INSTALL ; MAY 07, 2010   
 ;;7.1;PATIENT REGISTRATION;**9**;AUG 25, 2005
 ;
 Q
 ;
POST ;EP - From KIDS.
 ;
 N CLBEN,MMSG,IEN,AMIND
 D TS,BMES^XPDUTL("Beginning post-install routine (POST^AG71A9).")
 ;
 S MMSG=" --- AG v 7.1 Patch 9 has been installed into this uci --- "
 ;
 ;Set new 'LINK AOB TO ROI FIELD' to default of 'NO'
 ;and define new facility parameter ROI/AOB required prompts
 W !
 S IEN=0 F  S IEN=$O(^AGFAC(IEN)) Q:'IEN  D
 . ;
 . ;Set up new ETHNICITY INFORMATION Required registration parameter prompt
 . D ETHN^AG71A9(IEN)
 . ;
 . ;Set up new RACE Required registration parameter prompt
 . D RACE^AG71A9(IEN)
 . ;
 . ;Set up new PREFERRED LANGUAGE Required registration parameter prompt
 . D PREF^AG71A9(IEN)
 . ;
 . ;Set up new PRIMARY LANGUAGE Required registration parameter prompt
 . D PRIM^AG71A9(IEN)
 . ;
 . ;Set up Homeless and Migrant prompts with default of no
 . D HOM^AG71A9(IEN)
 ;
 ;Remove the lock from the AGSETSITE option
 N DIC,X,Y S DIC="^DIC(19,",X="AGSETSITE"
 D ^DIC
 I +Y>0 D
 . N DA,DIC,DIE,DR,X
 . S DA=+Y
 . S DIE="^DIC(19,"
 . S DR="3////@"
 . D ^DIE
 K DIC,X,Y
 ;
 ;Populate Race field based on CLASSIFICATION/BENEFICIARY
 D TS,BMES^XPDUTL("AutoPopulating PATIENT RACE field (POST^AG71A9).")
 S CLBEN=$O(^AUTTBEN("B","INDIAN/ALASKA NATIVE",""))  ;Get Classification IEN
 S AMIND=$O(^DIC(10,"B","AMERICAN INDIAN OR ALASKA NATIVE","")) ;Get Amer/Ind IEN
 ;
 I CLBEN]"",AMIND]"" D
 . N DFN,X,ERROR
 . S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:'DFN  D
 .. ;
 .. ;Quit if CLASSIFICATION/BENEFICIARY not equal to INDIAN/ALASKA NATIVE
 .. Q:$$GET1^DIQ(9000001,DFN_",",1111,"I")'=CLBEN
 .. ;
 .. ;Update RACE
 .. K DA,DIC,X,Y
 .. N DA,DIE,DR
 .. S DA=DFN
 .. S DIE="^DPT("
 .. S DR=".06////"_AMIND
 .. D ^DIE
 ;
 D TS,BMES^XPDUTL("Delivering v 7.1 Patch 9 install message to select users...")
 ;
 ;Deliver Mail Message
 D MAIL(MMSG)
 ;
 D TS,BMES^XPDUTL("AG v 7.1 Patch 9 Post-install is complete.")
 Q
 ;
MAIL(MMSG) ;Send install mail message.
 N %,CNT,DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("AG71MS",$J)
 S ^TMP("AG71MS",$J,1)=$G(MMSG)
 S ^TMP("AG71MS",$J,2)=" "
 S CNT=3
 ;
 S %=0
 Q:$G(XPDA)=""
 Q:$G(XPDBLD)=""
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AG71MS",$J,(%+CNT))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AG71MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("AG71MS",$J)
 Q
SINGLE(K) ;EP - Get holders of a single key K.
 N Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
TS D MES^XPDUTL($$HTE^XLFDT($H)) Q
 ;
HOM(FAC) ;Set Homeless and Migrant Display parameters
 ;
 N VAL
 ;
 ;Homeless Display
 S VAL=$$GET1^DIQ(9009061,FAC_",",28) I VAL="" D
 . ;
 . ;Set the display to "YES"
 . K DA,DIC,X,Y
 . N DA,DIE,DR
 . S DA=FAC
 . S DIE="^AGFAC("
 . S DR="28////Y"
 . D ^DIE
 ;
 ;Migrant Display
 S VAL=$$GET1^DIQ(9009061,FAC_",",27) I VAL="" D
 . ;
 . ;Set the display to "YES"
 . K DA,DIC,X,Y
 . N DA,DIE,DR
 . S DA=FAC
 . S DIE="^AGFAC("
 . S DR="27////Y"
 . D ^DIE
 ;
 Q
 ;
ETHN(FAC) ;Now add the ETHNICITY field
 ;
 N PRFIEN,DA,DIC,FLIEN,X,Y
 ;
 ;First Look for existing 2 entry
 S DA(1)=FAC
 S DIC="^AGFAC("_FAC_",11,"
 S DIC(0)="L"
 S X="2"
 D ^DIC
 Q:Y'>0
 S FLIEN=+Y
 ;
 ;Quit if ETHNICITY INFORMATION already defined
 I $O(^AGFAC(FAC,11,FLIEN,1,"B","ETHNICITY INFORMATION",""))]"" Q
 ; 
 ;Now add the ETHNICITY field
 W !
 K DA,DIE,DR
 N DA,DIC,X,Y
 S DA(2)=FAC,DA(1)=FLIEN
 S DIC="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="LS"
 S X="6"
 D ^DIC
 S PRFIEN=+Y
 I +PRFIEN W " REQUIRED? parameter added for site: ",$$GET1^DIQ(9999999.06,FAC_",",.01,"E")
 ;
 ;Set the required value to NO
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(2)=FAC,DA(1)=FLIEN,DA=PRFIEN
 S DIE="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DR=".02////0"
 D ^DIE
 Q
 ;
RACE(FAC) ;Now add the RACE field
 ;
 N PRFIEN,DA,DIC,FLIEN,X,Y
 ;
 ;First Look for existing 2 entry
 S DA(1)=FAC
 S DIC="^AGFAC("_FAC_",11,"
 S DIC(0)="L"
 S X="2"
 D ^DIC
 Q:Y'>0
 S FLIEN=+Y
 ;
 ;Quit if RACE already defined
 I $O(^AGFAC(FAC,11,FLIEN,1,"B","RACE",""))]"" Q
 ; 
 ;Now add the RACE field
 W !
 K DA,DIE,DR
 N DA,DIC,X,Y
 S DA(2)=FAC,DA(1)=FLIEN
 S DIC="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="LS"
 S X=".06"
 D ^DIC
 S PRFIEN=+Y
 I +PRFIEN W " REQUIRED? parameter added for site: ",$$GET1^DIQ(9999999.06,FAC_",",.01,"E")
 ;
 ;Set the required value to NO
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(2)=FAC,DA(1)=FLIEN,DA=PRFIEN
 S DIE="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DR=".02////0"
 D ^DIE
 ;
 Q
 ;
PREF(FAC) ;Add PREFERRED LANGUAGE to facility required field list
 ;
 N PRFIEN,DA,DIC,FLIEN,X,Y
 ;
 ;First Look for existing 9000001 entry
 S DA(1)=FAC
 S DIC="^AGFAC("_FAC_",11,"
 S DIC(0)="L"
 S X="9000001"
 D ^DIC
 Q:Y'>0
 S FLIEN=+Y
 ;
 ;Quit if PREFERRED LANGUAGE already defined
 I $O(^AGFAC(FAC,11,FLIEN,1,"B","PREFERRED LANGUAGE",""))]"" Q
 ; 
 ;Now change the file to 9000001.86 so it can pass input transform check
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(1)=FAC,DA=FLIEN
 S DIE="^AGFAC("_DA(1)_",11,"
 S DR=".01////9000001.86"
 D ^DIE
 ;
 ;Now add the PREFERRED LANGUAGE field
 W !
 K DA,DIE,DR
 N DA,DIC,X,Y
 S DA(2)=FAC,DA(1)=FLIEN
 S DIC="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="LS"
 S X=".04"
 D ^DIC
 S PRFIEN=+Y
 I +PRFIEN W " REQUIRED? parameter added for site: ",$$GET1^DIQ(9999999.06,FAC_",",.01,"E")
 ;
 ;Set the required value to NO
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(2)=FAC,DA(1)=FLIEN,DA=PRFIEN
 S DIE="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DR=".02////0"
 D ^DIE
 ;
 ;Now change the file back to 9000001
 K DA,DIE,DR
 N DA,DIE,DR
 S DA(1)=FAC,DA=FLIEN
 S DIE="^AGFAC("_DA(1)_",11,"
 S DR=".01////9000001"
 D ^DIE
 ;
 Q
 ;
PRIM(FAC) ;Add PRIMARY LANGUAGE to facility required field list
 ;
 N PRFIEN,DA,DIC,FLIEN,X,Y
 ;
 ;First Look for existing 9000001 entry
 S DA(1)=FAC
 S DIC="^AGFAC("_FAC_",11,"
 S DIC(0)="L"
 S X="9000001"
 D ^DIC
 Q:Y'>0
 S FLIEN=+Y
 ;
 ;Quit if PRIMARY LANGUAGE already defined
 I $O(^AGFAC(FAC,11,FLIEN,1,"B","PRIMARY LANGUAGE",""))]"" Q
 ; 
 ;Now change the file to 9000001.86 so it can pass input transform check
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(1)=FAC,DA=FLIEN
 S DIE="^AGFAC("_DA(1)_",11,"
 S DR=".01////9000001.86"
 D ^DIE
 ;
 ;Now add the PRIMARY LANGUAGE field
 W !
 K DA,DIE,DR
 N DA,DIC,X,Y
 S DA(2)=FAC,DA(1)=FLIEN
 S DIC="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="LS"
 S X=".02"
 D ^DIC
 S PRFIEN=+Y
 I +PRFIEN W " REQUIRED? parameter added for site: ",$$GET1^DIQ(9999999.06,FAC_",",.01,"E")
 ;
 ;Set the required value to NO
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(2)=FAC,DA(1)=FLIEN,DA=PRFIEN
 S DIE="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DR=".02////0"
 D ^DIE
 ;
 ;Now change the file back to 9000001
 K DA,DIE,DR
 N DA,DIE,DR
 S DA(1)=FAC,DA=FLIEN
 S DIE="^AGFAC("_DA(1)_",11,"
 S DR=".01////9000001"
 D ^DIE
 ;
 Q
