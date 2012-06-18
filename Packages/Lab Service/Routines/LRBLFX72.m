LRBLFX72 ; IHS/DIR/AAB -PUT DIVISION ;
 ;;5.2;LR;**1002**;JUN 01, 1998
 ;;5.2;LAB SERVICE;**72**;Sep 27, 1994
 ;S DUZ(2)=+$$SITE^VASITE
 D ^LR127PO  ;IHS/OIRM TUC/AAB 2/17/98 PATCH 127
 D LR72PO   ;IHS/DIR TUC/AAB 5/18/98   PATCH 72
 D ^LRARIPOS  ;IHS/DIR TUC/AAB 5/18/98 PATCH 59
 D ^LR138PO  ;IHS/DIR TUC/AAB 05/19/98 PATCH 138
 D ^LRFIXAU  ;IHS/DIR TUC/AAB 05/19/98 PATCH 134
 D ^LR132P  ;IHS/DIR TUC/AAB 05/20/98  PATCH 132
 D POST^LR157  ;IHS/DIR TUC/AAB 05/20/98 PATCH 157
 D POST^LR163  ;IHS/DIR TUC/AAB 05/20/98 PATCH 163
 Q
LR72PO ;
 S DUZ(2)=+$$SITE^HLZFUNC  ;IHS/OIRM TUC/AAB 3/1/98
 I $D(^LRO(68,"VR")) D ^LRAPFIX Q
 ;
 ; Populate file 68 ASSOCIATED DIVISION field multiple
 N DO,DD,DA,LRSS,X
 S DA=0 F  S DA=$O(^LRO(68,DA)) Q:DA'>0  D
 . S DA(1)=DA
 . S LRSS=$P(^LRO(68,DA,0),U,2)
 . S DIC="^LRO(68,"_DA(1)_",3,"
 . S DIC(0)="L"
 . S DIC("P")="68.03PA"
 . S X=DUZ(2),DINUM=X
 . D FILE^DICN
 D BMES^XPDUTL("Your ASSOCIATED DIVISION field in file 68 has been populated for all accession areas.")
 ;
 ; Populate file 65 DIVISION field.
 S DA=0 F  S DA=$O(^LRD(65,DA)) Q:'DA  S X=^(DA,0) I '$P(X,"^",16) S $P(^(0),"^",16)=DUZ(2),^LRD(65,"D",DUZ(2),DA)=""
 ;
 ; Populate file 66 ASSOCIATED DIVISION field
BP S DA=0 F  S DA=$O(^LAB(66,DA)) Q:+DA'>0  I '$O(^LAB(66,DA,10,0)) S ^(DUZ(2),0)=DUZ(2),^LAB(66,DA,10,0)="^66.1PA^"_DUZ(2)_"^"_1
 D BMES^XPDUTL("Your new DIVISION field in files 65 & 66 has been populated") W $C(7),!!!
 D BMES^XPDUTL("You MAY NOW let users back on--HOWEVER, all ANATOMIC PATHOLOGY options should be DISABLED while I convert the AP accession numbers to their new format") W $C(7),$C(7),!!
 D ^LRAPFIX Q
