LR72PRE ; IHS/DIR/AAB - PRE-INSTALL ROUTINE FOR LR*5.2*72 ;
 ;;5.2;LR;**1002**;JUN 01, 1998
 ;;5.2;LAB SERVICE;**72**;SEP 27, 1994
 ;
 D LR127P  ;IHS/OIRM TUC/AAB 2/17/98
 D DD  ;IHS/DIR TUC/AAB 05/22/98
 D LRARIPRE  ;IHS/DIR TUC/AAB 05/18/98
 D LR138P  ;IHS/DIR TUC/AAB 05/19/98
 D PRELR163  ;IHS/DIR TUC/AAB 05/20/98
 W !!,"Pre Install Completed  ",!!
 Q
LR127P ;
EN ;
 Q:'$D(XPDNM)
 I $O(^LAB(64.81,0)) W !?5,"You have old data in LAB NLT/CPT CODES file ",!,"INSTALL ABORTED ",$C(7) S XPDQUIT=2 Q
 N DA,DIK
 S DA(1)=69.9,DA=615,DIK="^DD(69.9," D ^DIK
 K DA,DIK S DA(1)=64,DA=18,DIK="^DD(64," D ^DIK
 K DA,DIK S DA(1)=64,DA=14,DIK="^DD(64," D ^DIK
 K DA,DIK S DA(1)=69.9,DA=614,DIK="^DD(69.9," D ^DIK
 K:'$D(^LAB(64.81,0)) ^LAM("AD")
 W !,$$CJ^XLFSTR("Pre Install 127 Complete",80),!!
 Q
DD ;
 K DIK,DA S DIK="^DD(66,",DA(1)=66 F DA=1,2 D ^DIK
 K DIK,DA S DIK="^DD(69.9,",DA=1 D ^DIK
 K DIK,DA
 Q
LRARIPRE ;
EN1 ;
 W !!,">>> Deleting OLD 'LAB' ARCHIVE FILES.",!
AWD W !!,"DELETING ARCHIVED WKLD DATA FILE."
 S DIU="^LRO(64.19999,",DIU(0)="D" D EN^DIU2
ALM W !!,"DELETING ARCHIVED LAB MONTHLY WORKLOADS FILE."
 S DIU="^LRO(67.99999,",DIU(0)="D" D EN^DIU2
ABI W !!,"DELETING ARCHIVED BLOOD INVENTORY FILE."
 S DIU="^LRD(65.9999,",DIU(0)="D" D EN^DIU2
 K DIU
 W !!,"The data dictionaries for these files will be reinstalled during the inits."
 Q
BXREF ;Kills B xref on PATIENT XMATCH field (#65.01)
 ;This xref is in the DD's but not the file.
 Q:'$D(^DD(65.01,0,"IX","B",65.01,.01))  ;already deleted
 S LRARI=0 F  S LRARI=$O(^DD(65.01,.01,1,LRARI)) Q:'LRARI  D
 . K:$G(^DD(65.01,.01,1,LRARI,0))="65.01^B" ^DD(65.01,.01,1,LRARI)
 K ^DD(65.01,0,"IX","B",65.01,.01)
 K:'$O(^DD(65.01,.01,1,0)) ^DD(65.01,"IX",.01) ;no xrefs left on field
 Q
LR138P ;
EN2 ;
 Q:'$D(XPDNM)
 ;Removing Alpha site dds
 K DIK,DA S DA(1)=63.04,DIK="^DD(63.04," F DA=.064,.065,.066,.067 D ^DIK
 K DIK,DA S DA(1)=63.05,DIK="^DD(63.05," F DA=.064,.065,.066,.067 D ^DIK
 K DIK,DA S DA(1)=68.02,DIK="^DD(68.02," F DA=95,96,97,98 D ^DIK
 K DIK,DA
 I $O(^LAB(64.81,0)) W !?5,"You still have unistalled data in LAB NLT/CPT CODES file ",!,$C(7)
 S X="SCDXUAPI" X ^%ZOSF("TEST") I '$T D  S XPDQUIT=2 Q
 .;W !!,$$CJ^XLFSTR("You must Load the SD*5.3*63 to add OOS clinic locations",80),!,$$CJ^XLFSTR("BEFORE YOU INSTALL THIS PATCH",80),!! S LRSDCX=1
 S LRPKG=$O(^DIC(9.4,"B","LR",0))
 I 'LRPKG S LRPKG=$O(^DIC(9.4,"B","LAB SERVICE",0))
 I 'LRPKG W !!?10,"Not able to find 'LAB SERVICE' in your Package (#9.4) file.",!,"Contact your IRM Service !!",!!,$C(7) H 5 S XPDQUIT=2 Q
 K DA,DIK S DA(1)=64,DA=14,DIK="^DD(64," D ^DIK K DA,DIK
 W !!,$$CJ^XLFSTR("LOCKING THE ^LRO(69,AA) GLOBAL",80),!
 L +LRO(69,"AA"):10 I '$T W !!?5,"Not able to LOCK ^LRO(69,AA) Global" S XPDQUIT=2 Q
 W !,$$CJ^XLFSTR("Pre Install 138 Complete",80),!!
 Q
PRELR163 ;
PRE ;LR*5.2*163 AFTER USER COMMITS ROUTINE KIDS INSTALL"
ENPRE ;
 Q:'$D(XPDNM)
 ;Cleanup broken X-Ref
 N I,N
 S I=0 F  S I=$O(^LAM(I)) Q:I<1  D
 . Q:'$D(^LAM(I,"7","B","LRDATA"))
 . S N=0 F  S N=$O(^LAM(I,7,"B","LRDATA",N)) Q:N<1  D
 . . K ^LAM(I,7,"B","LRDATA",N),^LAM(I,7,N,0)
 . . I $P(^LAM(I,7,0),U,4) S $P(^LAM(I,7,0),U,4)=$P(^LAM(I,7,0),U,4)-1
 I $D(^LAB(64.81,0))#2 S X=$P(^(0),U,1,2) K ^LAB(64.81) S ^LAB(64.81,0)=X
 S:$D(^LAM(0))#2 $P(^LAM(0),U,3)=2225 D
 . D BMES^XPDUTL($$CJ^XLFSTR("Removing 'Reserve 2 field (#8) in WKLD CODE file (#64).",80))
 . D BMES^XPDUTL($$CJ^XLFSTR("The field will be renamed 'PRICE'.",80))
 . N DA,DIK
 . S DA=8,DIK="^DD(64," D ^DIK
 D BMES^XPDUTL($$CJ^XLFSTR("Removing 'Reserve 2 field (#8) in WKLD CODE SUFFIX file (#64.2).",80))
 D BMES^XPDUTL($$CJ^XLFSTR("The field will be renamed 'PRICE'.",80)) D
 . N DA,DIK
 . S DA=8,DIK="^DD(64.2," D ^DIK
 D BMES^XPDUTL($$CJ^XLFSTR("Removing existing CPT codes for WKLD CODE file.",80))
 W ! S I=0 F  S I=$O(^LAM(I)) Q:I<1  D
 . I '$D(^LAM(I,0))#2 K ^LAM(I) Q
 . S:'$P(^LAM(I,0),U,7) $P(^(0),U,7)=38 K:$D(^LAM(I,4)) ^LAM(I,4) W:'(I#50) "."
 K ^LAM("AD")
 D SPCK
 D BMES^XPDUTL($$CJ^XLFSTR("** Pre Install 163 Complete **",80))
 Q
SPCK K ^XTMP("LR","SPELL ERR")
 S ^XTMP("LR","SPELL ERR")="LR*5.2*163 Spelling errors"
 D BMES^XPDUTL($$CJ^XLFSTR("Correcting Duplicates or Spelling Errors",80))
 D BMES^XPDUTL($$CJ^XLFSTR("Names that begin with 'X*' have codes that are incorrect.",80))
 K CK S CK="" F I=1:1 S LN=$T(SPELL+I) Q:$P(LN,";;",2)="STOP"  S CK(I)=LN
 S I=0 F  S I=$O(CK(I)) Q:I<1  D BMES^XPDUTL($$CJ^XLFSTR($P(CK(I),";",3)_"  "_$P(CK(I),";",4),80))
 K DIC S DIC=64,DIC(0)="XNZM"
 S II=0 F  S II=$O(CK(II)) Q:II<1  D
 . S X=$P(CK(II),";",3)_".0000",NM=$P(CK(II),";",4) D ^DIC
 . I Y<1 D BMES^XPDUTL($$CJ^XLFSTR("*** Unable to find WKLD Code [ "_X_" ] in your file #64 ****",80)) Q
 . ;W !,Y  W:Y>1 !,Y(0)
 . S LNX=$P(Y,U,2) I LNX'=NM S CK=1 D FILE
 D BMES^XPDUTL($$CJ^XLFSTR("Spelling updates completed.",80))
 Q
SPELL ;
 ;;97485;X*Hepatitis C RNA;
 ;;STOP
FILE ;
 N LRROOT,DA
 D BMES^XPDUTL($$CJ^XLFSTR("Correcting Spelling of entry "_+Y_" from "_LNX_" to "_NM,80))
 S DA=+Y,LRROOT(64,DA_",",.01)=NM
 D FILE^DIE("","LRROOT",^XTMP("LR","SPELL ERR"))
 Q
