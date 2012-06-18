AUMDOPKG ;IHS/OIRM/DSD/AEF - UPDATE AUM VERSION [ 12/03/1998   2:35 PM ]
 ;;99.1;ICD UPDATE;;DEC 03, 1998
 ;
 ;This routine updates the Package file with installation information
 ;for the AUM ICD Updates package
 ;
UPDATE ;EP -- UPDATE PACKAGE FILE
 ;
 N AUMDOTXT,DA,DD,DIC,DIE,DIK,DO,DR,IENS,X,Y
 D ^XBKVAR
 I $G(AUMDO("QUIT")) W !,"Did not update installation information in Package file",! Q
 S AUMDO("PKG IEN")=$O(^DIC(9.4,"C","AUM",0))
 I 'AUMDO("PKG IEN") D ADDPKG
 Q:'AUMDO("PKG IEN")
 S AUMDO("VER")=$P($T(AUMDOPKG+1),";",3)
 S DA=AUMDO("PKG IEN")
 S DIE="^DIC(9.4,"
 S DR="11.01////"_"IHS/OIRM/DIR"_";10////"_"IHS/OIRM/DIR/AEF"_";13////"_AUMDO("VER")_";11.1///"_"@"_";916///"_"@"_";916.5///"_"@"_";914///"_"@"_";914.5///"_"@"_";913///"_"@"_";913.5///"_"@"
 D ^DIE
 S DA(1)=DA
 S DIC=DIE_DA(1)_",22,"
 S DIC(0)="L"
 S DIC("P")=$P(^DD(9.4,22,0),U,2)
 S X=AUMDO("VER")
 K DD,DO
 D FILE^DICN
 Q:Y'>0
 S DA=+Y
 S DIE=DIC
 S DR="1///"_$P($T(AUMDOPKG+1),";",6)_";2////"_DT_";3////"_DUZ
 D ^DIE
 ;-----
 F I=1:1 S X=$P($T(TEXT+I),";",3) Q:X["$$END"  D
 . S AUMDOTXT(I,0)=X
 S IENS=AUMDO("PKG IEN")_","
 D WP^DIE(9.4,IENS,3,,"AUMDOTXT")
 ;-----
 S DA(1)=AUMDO("PKG IEN")
 S DIK="^DIC(9.4,"_DA(1)_",4,"
 S DA=0 F  S DA=$O(^DIC(9.4,DA(1),4,DA)) Q:'DA  D ^DIK
 ;-----
 S DIK="^DIC(9.4,"_DA(1)_",2,"
 S DA=0 F  S DA=$O(^DIC(9.4,DA(1),2,DA)) Q:'DA  D ^DIK
 ;-----
 S DIK="^DIC(9.4,"_DA(1)_",3,"
 S DA=0 F  S DA=$O(^DIC(9.4,DA(1),3,DA)) Q:'DA  D ^DIK
 Q
 ;
ADDPKG ;----- ADD AUM (ICD UPDATE) PACKAGE TO PACKAGE FILE
 ;
 N DA,DD,DIC,DIE,DO,DR,X,Y
 S DIC="^DIC(9.4,"
 S DIC(0)="L"
 S X="ICD UPDATE"
 K DD,DO
 D FILE^DICN
 Q:+Y'>0
 S AUMDO("PKG IEN")=+Y
 S DA=+Y
 S DIE=DIC
 S DR="1////"_"AUM"_";2////"_"AUMDO ICD Update Utility"
 D ^DIE
 Q
 ;
TEXT ;----- TEXT FOR PACKAGE DESCRIPTION FIELD OF PACKAGE FILE
 ;;The AUMDO utility provides the capability to update the IHS ICD
 ;;Operations and Procedures (ICD0) and ICD Diagnosis (ICD9) files with
 ;;new or changed ICD information.  The update date will reflect the
 ;;most current ICD Official Authorized Addenda distributed by the
 ;;American Medical Records Association.
 ;;  
 ;;All update actions to the ICD files are managed by the Division of
 ;;Information Resources, Office of Information Resources Management
 ;;in Albuquerque.
 ;;  
 ;;Distribution of updates will be done periodically and identified by
 ;;a version number.
 ;;$$END
 ;
RTNAME ;;AUMDOPKG
