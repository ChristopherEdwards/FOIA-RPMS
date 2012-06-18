LRIPRE ;SLC/FHS/REG - PRE-INIT FOR VERSION 5.2 AFTER USER COMMIT;10/18/90 13:36 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
EN1 ;
 Q:'$D(DIFQ)
 I '$D(^DD(60,0))#2 W !!?10,"It appears you are installing DHCP Laboratory Package ",!,"for the first time. ",! S LRFIRST=1
 S U="^",LRVR=$G(^DD(60,0,"VR"))
 K DIK,DA S DA=60.12,DIK="^DD(60.12," D ^DIK
 K DIK,DA S DA=65.91,DIK="^DD(65.91," D ^DIK
 I '$G(LRFIRST),$G(LRVR)<5.11 D ^LRIPRE1
 I $G(LRFIRST) D LRO^LRIPRE1
 I $G(LRVR)>5.1 K DA,DIK S DA=7.5,DA(1)=64.1111,DIK="^DD(64.1111," D ^DIK ;removing a bad fields from Alpha sites.
 K ^LAB(69.91) S ^LAB(69.91,0)="LR ROUTINE INTEGRITY CHECKER^69.91I^0^0"
 G:$G(LRVR)>5.11!($G(LRFIRST)) END
 W !?5,"Clearing 67.9",!
 K DIU S DIU="^LRO(67.9,",DIU(0)="DT" D EN^DIU2 K DIU W !,"Done",!
 W !?5,"Clearing 69.91 ",!
 K DIU S DIU="^LAB(69.91,",DIU(0)="DT" D EN^DIU2 K DIU W !,"Done",!
END ;
 W !!,"Pre Init completed -- Starting init process ",!!
 Q
