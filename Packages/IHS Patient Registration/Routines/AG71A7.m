AG71A7 ;VNGT/HS/BEE - Patient Registration 7.1 PATCH 7 POST INSTALL ; MAR 19, 2010   
 ;;7.1;PATIENT REGISTRATION;**7**;AUG 25, 2005
 ;
 Q
 ;
POST ;EP - From KIDS.
 ;
 D TS,BMES^XPDUTL("Beginning post-install routine (POST^AG71A7).")
 ;
 ;AG PATIENT REGISTRATION ERROR CODES file changes
 ;
 ;Change Error 37 Page from 1 to 10
 N DIC,X,Y,MMSG
 S MMSG=" --- AG v 7.1 Patch 7 has been installed into this uci --- "
 S DIC="^AGEDERRS("
 S DIC(0)=""
 S X=37
 D ^DIC
 I +Y D
 . N DIE,IEN1,IEN2,AGVAR,ERROR
 . S IEN1=+Y
 . S IEN2=$O(^AGEDERRS(IEN1,11,"B",1,"")) Q:IEN2=""
 . S AGVAR(9009061.511,IEN2_","_IEN1_",",".01")=10
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (37) --- "
 K DIC,X,Y
 ;
 ;Add Error 38
 N DIC,X,Y
 S DIC="^AGEDERRS("
 S DIC(0)="L"
 S X=38
 D ^DIC
 I +Y D
 . N DA,DIE,IEN1,IEN2,AGVAR,ERROR,WP,AGWP
 . S (DA(1),IEN1)=+Y
 . S AGVAR(9009061.5,IEN1_",",".01")="38"
 . S AGVAR(9009061.5,IEN1_",",".02")="E"
 . S AGVAR(9009061.5,IEN1_",",".03")="Patient's Ethnicity/Method of Collection incomplete"
 . S AGVAR(9009061.5,IEN1_",",".04")="PETHNIC"
 . S AGVAR(9009061.5,IEN1_",",".05")="AGEDERR2(DFN)"
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (38A) --- "
 . K AGVAR
 . ;
 . ;Save CORRECTIVE ACTION
 . K WP
 . S WP(1)="An entry for the ETHNICITY or METHOD OF COLLECTION fields is missing. Complete the patient's Ethnicity information on page 10."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",501,"",AGWP)
 . ;
 . ;SAVE LOGIC REASONING FOR ERROR
 . K WP
 . S WP(1)="Error does not generate if patient is deceased, has been inactivated, has not been updated in three"
 . S WP(2)="years or has no eligibility on file."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",502,"",AGWP)
 . ;
 . ;Save Apply to Page
 . N DIC,X,Y
 . S DIC="^AGEDERRS("_DA(1)_",11,",DIC(0)="L"
 . S X=10
 . D ^DIC
 . I 'Y S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (38B) --- "
 ;
 ;Add Error 39
 N DIC,X,Y
 S DIC="^AGEDERRS("
 S DIC(0)="L"
 S X=39
 D ^DIC
 I +Y D
 . N DA,DIE,IEN1,IEN2,AGVAR,ERROR,WP,AGWP
 . S (DA(1),IEN1)=+Y
 . S AGVAR(9009061.5,IEN1_",",".01")="39"
 . S AGVAR(9009061.5,IEN1_",",".02")="E"
 . S AGVAR(9009061.5,IEN1_",",".03")="Patient's Migrant Worker information incomplete"
 . S AGVAR(9009061.5,IEN1_",",".04")="PMIG"
 . S AGVAR(9009061.5,IEN1_",",".05")="AGEDERR2(DFN)"
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (39A) --- "
 . K AGVAR
 . ;
 . ;Save CORRECTIVE ACTION
 . K WP
 . S WP(1)="An entry for the MIGRANT WORKER STATUS or MIGRANT WORKER TYPE fields is"
 . S WP(2)="missing. The MIGRANT WORKER STATUS field is required and the MIGRANT"
 . S WP(3)="WORKER TYPE field is required if the MIGRANT WORKER STATUS field is set to"
 . S WP(4)="'YES'. Complete the patient's Migrant Worker information on page 10."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",501,"",AGWP)
 . ;
 . ;SAVE LOGIC REASONING FOR ERROR
 . K WP
 . S WP(1)="Error does not generate if patient is deceased, has been inactivated, has not been updated in three"
 . S WP(2)="years or has no eligibility on file."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",502,"",AGWP)
 . ;
 . ;Save Apply to Page
 . N DIC,X,Y
 . S DIC="^AGEDERRS("_DA(1)_",11,",DIC(0)="L"
 . S X=10
 . D ^DIC
 . I 'Y S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (39B) --- "
 ;
 ;Add Error 40
 N DIC,X,Y
 S DIC="^AGEDERRS("
 S DIC(0)="L"
 S X=40
 D ^DIC
 I +Y D
 . N DA,DIE,IEN1,IEN2,AGVAR,ERROR,WP,AGWP
 . S (DA(1),IEN1)=+Y
 . S AGVAR(9009061.5,IEN1_",",".01")="40"
 . S AGVAR(9009061.5,IEN1_",",".02")="E"
 . S AGVAR(9009061.5,IEN1_",",".03")="Patient's Homeless information incomplete"
 . S AGVAR(9009061.5,IEN1_",",".04")="PHOM"
 . S AGVAR(9009061.5,IEN1_",",".05")="AGEDERR2(DFN)"
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (40A) --- "
 . K AGVAR
 . ;
 . ;Save CORRECTIVE ACTION
 . K WP
 . S WP(1)="An entry for the HOMELESS STATUS or HOMELESS TYPE fields is missing. The"
 . S WP(2)="HOMELESS STATUS field is required and the HOMELESS TYPE field is required"
 . S WP(3)="if the HOMELESS STATUS field is set to 'YES'. Complete the patient's"
 . S WP(4)="Homeless information on page 10."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",501,"",AGWP)
 . ;
 . ;SAVE LOGIC REASONING FOR ERROR
 . K WP
 . S WP(1)="Error does not generate if patient is deceased, has been inactivated, has not been updated in three"
 . S WP(2)="years or has no eligibility on file."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",502,"",AGWP)
 . ;
 . ;Save Apply to Page
 . N DIC,X,Y
 . S DIC="^AGEDERRS("_DA(1)_",11,",DIC(0)="L"
 . S X=10
 . D ^DIC
 . I 'Y S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (40B) --- "
 ;
 ;Add Error 41
 N DIC,X,Y
 S DIC="^AGEDERRS("
 S DIC(0)="L"
 S X=41
 D ^DIC
 I +Y D
 . N DA,DIE,IEN1,IEN2,AGVAR,ERROR,WP,AGWP
 . S (DA(1),IEN1)=+Y
 . S AGVAR(9009061.5,IEN1_",",".01")="41"
 . S AGVAR(9009061.5,IEN1_",",".02")="E"
 . S AGVAR(9009061.5,IEN1_",",".03")="Patient's Primary Language, Proficiency or Interpreter Required incomplete"
 . S AGVAR(9009061.5,IEN1_",",".04")="LPRM"
 . S AGVAR(9009061.5,IEN1_",",".05")="AGEDERR2(DFN)"
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (41A) --- "
 . K AGVAR
 . ;
 . ;Save CORRECTIVE ACTION
 . K WP
 . S WP(1)="The patient's PRIMARY LANGUAGE is required. If the PRIMARY"
 . S WP(2)="LANGUAGE is anything other than ENGLISH, the INTERPRETER REQUIRED"
 . S WP(3)="field is also required.  Complete the patient's PRIMARY LANGUAGE field on"
 . S WP(4)="page 10."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",501,"",AGWP)
 . ;
 . ;SAVE LOGIC REASONING FOR ERROR
 . K WP
 . S WP(1)="Error does not generate if patient is deceased, has been inactivated, has not been updated in three"
 . S WP(2)="years or has no eligibility on file."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",502,"",AGWP)
 . ;
 . ;Save Apply to Page
 . N DIC,X,Y
 . S DIC="^AGEDERRS("_DA(1)_",11,",DIC(0)="L"
 . S X=10
 . D ^DIC
 . I 'Y S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (41B) --- "
 ;
 ;Add Error 42
 N DIC,X,Y
 S DIC="^AGEDERRS("
 S DIC(0)="L"
 S X=42
 D ^DIC
 I +Y D
 . N DA,DIE,IEN1,IEN2,AGVAR,ERROR,WP,AGWP
 . S (DA(1),IEN1)=+Y
 . S AGVAR(9009061.5,IEN1_",",".01")="42"
 . S AGVAR(9009061.5,IEN1_",",".02")="E"
 . S AGVAR(9009061.5,IEN1_",",".03")="Patient's Preferred Language incomplete or not in patient's list of languages"
 . S AGVAR(9009061.5,IEN1_",",".04")="LPRE"
 . S AGVAR(9009061.5,IEN1_",",".05")="AGEDERR2(DFN)"
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (42A) --- "
 . K AGVAR
 . ;
 . ;Save CORRECTIVE ACTION
 . K WP
 . S WP(1)="The patient's PREFERRED LANGUAGE is required. Complete the patient's"
 . S WP(2)="PREFERRED LANGUAGE field on page 10, picking from either the patient's"
 . S WP(3)="PRIMARY LANGUAGE or a language they have entered in the OTHER"
 . S WP(4)="LANGUAGE SPOKEN field."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",501,"",AGWP)
 . ;
 . ;SAVE LOGIC REASONING FOR ERROR
 . K WP
 . S WP(1)="Error does not generate if patient is deceased, has been inactivated, has not been updated in three"
 . S WP(2)="years or has no eligibility on file."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",502,"",AGWP)
 . ;
 . ;Save Apply to Page
 . N DIC,X,Y
 . S DIC="^AGEDERRS("_DA(1)_",11,",DIC(0)="L"
 . S X=10
 . D ^DIC
 . I 'Y S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (42B) --- "
 ;
 ;Add Error 43
 N DIC,X,Y
 S DIC="^AGEDERRS("
 S DIC(0)="L"
 S X=43
 D ^DIC
 I +Y D
 . N DA,DIE,IEN1,IEN2,AGVAR,ERROR,WP,AGWP
 . S (DA(1),IEN1)=+Y
 . S AGVAR(9009061.5,IEN1_",",".01")="43"
 . S AGVAR(9009061.5,IEN1_",",".02")="E"
 . S AGVAR(9009061.5,IEN1_",",".03")="Patient's Household Income Period incomplete"
 . S AGVAR(9009061.5,IEN1_",",".04")="HIP"
 . S AGVAR(9009061.5,IEN1_",",".05")="AGEDERR2(DFN)"
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (43A) --- "
 . K AGVAR
 . ;
 . ;Save CORRECTIVE ACTION
 . K WP
 . S WP(1)="The patient's HOUSEHOLD INCOME PERIOD is required when the TOTAL"
 . S WP(2)="HOUSEHOLD INCOME field is populated. Complete the patient's HOUSEHOLD"
 . S WP(3)="INCOME PERIOD on page 10."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",501,"",AGWP)
 . ;
 . ;SAVE LOGIC REASONING FOR ERROR
 . K WP
 . S WP(1)="Error does not generate if patient is deceased, has been inactivated, has not been updated in three"
 . S WP(2)="years or has no eligibility on file."
 . S AGWP="WP"
 . D WP^DIE(9009061.5,IEN1_",",502,"",AGWP)
 . ;
 . ;Save Apply to Page
 . N DIC,X,Y
 . S DIC="^AGEDERRS("_DA(1)_",11,",DIC(0)="L"
 . S X=10
 . D ^DIC
 . I 'Y S MMSG=" --- AG v 7.1 Patch 7 Post Install Encountered Issues (43B) --- "
 ;
 D TS,BMES^XPDUTL("Delivering v 7.1 Patch 7 install message to select users...")
 ;
 ;Deliver Mail Message
 D MAIL(MMSG)
 ;
 D TS,BMES^XPDUTL("AG v 7.1 Patch 7 Post-install is complete.")
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
