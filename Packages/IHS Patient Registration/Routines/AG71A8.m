AG71A8 ;VNGT/HS/BEE - Patient Registration 7.1 PATCH 8 POST INSTALL ; MAY 07, 2010   
 ;;7.1;PATIENT REGISTRATION;**8**;AUG 25, 2005
 ;
 Q
 ;
POST ;EP - From KIDS.
 ;
 N MMSG,IEN
 D TS,BMES^XPDUTL("Beginning post-install routine (POST^AG71A8).")
 ;
 S MMSG=" --- AG v 7.1 Patch 8 has been installed into this uci --- "
 ;
 ;Set new 'LINK AOB TO ROI FIELD' to default of 'NO'
 ;and define new facility parameter ROI/AOB required prompts
 W !
 S IEN=0 F  S IEN=$O(^AGFAC(IEN)) Q:'IEN  D
  . ;
 . ;Set up new AOB Required registration parameter prompt
 . D AOB^AG71A8(IEN)
 . ;
 . ;Set up new ROI Required registration parameter prompt
 . D ROI^AG71A8(IEN)
 . ;
 . N AGVAR,FLD,ERROR
 . S FLD=$$GET1^DIQ(9009061,IEN_",","26","I") Q:FLD]""
 . S AGVAR(9009061,IEN_",","26")="N"
 . D FILE^DIE("","AGVAR","ERROR")
 . I $D(ERROR) S MMSG=" --- AG v 7.1 Patch 8 Post Install Encountered Issues (37) --- "
 ;
 ;Convert Internet single WHERE field to new multiple field
 D WEB
 ;
 D TS,BMES^XPDUTL("Delivering v 7.1 Patch 8 install message to select users...")
 ;
 ;Deliver Mail Message
 D MAIL(MMSG)
 ;
 D TS,BMES^XPDUTL("AG v 7.1 Patch 8 Post-install is complete.")
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
AOB(FAC) ;Add ASSIGN BENEFITS OBTAINED DATE to facility required field list
 ;
 N AOBIEN,DA,DIC,FLIEN,X,Y
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
 ;Quit if ASSIGN BENEFITS OBTAINED DATE already defined
 I $O(^AGFAC(FAC,11,FLIEN,1,"B","ASSIGN BENEFITS OBTAINED DATE",""))]"" Q
 ; 
 ;Now change the file to 9000001.71 so it can pass input transform check
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(1)=FAC,DA=FLIEN
 S DIE="^AGFAC("_DA(1)_",11,"
 S DR=".01////9000001.71"
 D ^DIE
 ;
 ;Now add the ASSIGN BENEFITS OBTAINED DATE
 W !
 K DA,DIE,DR
 N DA,DIC,X,Y
 S DA(2)=FAC,DA(1)=FLIEN
 S DIC="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="LS"
 S X=".01"
 D ^DIC
 S AOBIEN=+Y
 I +AOBIEN W " REQUIRED? parameter added for site: ",$$GET1^DIQ(9999999.06,FAC_",",.01,"E")
 ;
 ;Set the required value to NO
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(2)=FAC,DA(1)=FLIEN,DA=AOBIEN
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
ROI(FAC) ;Add RELEASE OF INFORMATION to facility required field list
 ;
 N ROIIEN,DA,DIC,FLIEN,X,Y
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
 ;Quit if RELEASE OF INFORMATION already defined
 I $O(^AGFAC(FAC,11,FLIEN,1,"B","RELEASE OF INFORMATION",""))]"" Q
 ; 
 ;Now change the file to 9000001.03601 so it can pass input transform check
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(1)=FAC,DA=FLIEN
 S DIE="^AGFAC("_DA(1)_",11,"
 S DR=".01////9000001.03601"
 D ^DIE
 ;
 ;Now add the RELEASE OF INFORMATION
 W !
 K DA,DIE,DR
 N DA,DIC,X,Y
 S DA(2)=FAC,DA(1)=FLIEN
 S DIC="^AGFAC("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="LS"
 S X=".01"
 D ^DIC
 S ROIIEN=+Y
 I +ROIIEN W " REQUIRED? parameter added for site: ",$$GET1^DIQ(9999999.06,FAC_",",.01,"E")
 ;
 ;Set the required value to NO
 K DA,DIC,X,Y
 N DA,DIE,DR
 S DA(2)=FAC,DA(1)=FLIEN,DA=ROIIEN
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
 Q
 ;
WEB ;Copy Internet WHERE from single field to new multiple
 ;
 N DFN,LDT,LIEN,WHERE,DIC,X,Y,DLAYGO
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 . ;
 . ;Loop through each stored entry
 . S LIEN=0 F  S LIEN=$O(^AUPNPAT(DFN,81,LIEN)) Q:'LIEN  D
 .. I $D(^AUPNPAT(DFN,81,LIEN,1,0)) Q  ;Already completed
 .. ;
 .. ;Pull current single WHERE value
 .. S WHERE=$$GET1^DIQ(9000001.81,LIEN_","_DFN_",",.03,"I") Q:WHERE=""
 .. ;
 .. ;Define new entry and save
 .. S DIC="^AUPNPAT("_DFN_",81,"_LIEN_",1,",DA(2)=DFN,DA(1)=LIEN
 .. S DIC(0)="L"
 .. S X=WHERE
 .. S DLAYGO="9000001.811",DIC("P")=DLAYGO
 .. I '$D(^AUPNPAT(DFN,81,LIEN,1,0)) S ^AUPNPAT(DFN,81,LIEN,1,0)="^9000001.811SA^^"
 .. K DO,DD D FILE^DICN
 ;
 Q
 ;
PRE ;EP - From KIDS
 ;
 ;Remove current - AG PATIENT REGISTRATION ERROR CODES entries
 ;(New File with data will be included in patch)
 NEW DA,DIK
 S DA=0,DIK="^AGEDERRS("
 F  S DA=$O(^AGEDERRS(DA)) Q:'DA  D ^DIK
 ;
 Q
