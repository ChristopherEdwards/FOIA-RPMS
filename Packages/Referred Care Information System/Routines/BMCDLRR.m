BMCDLRR ; IHS/PHXAO/TMJ - delete routine referral definition ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 W !!,"This option allows the user to delete a routine referral definition.",!,"This should only be done if the routine referral is no longer valid.",!!
 S DIC="^BMCRTNRF(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !!,"NO DEFINTION SELECTED." G XIT
 S BMCRR=+Y
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete the "_$P(^BMCRTNRF(BMCRR,0),U)_" referral definition",DIR("B")="N" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 G:'Y XIT
 W !!,"DELETING ",$P(^BMCRTNRF(BMCRR,0),U)
 S DA=BMCRR,DIK="^BMCRTNRF(" D ^DIK K DA,DIK
XIT ;
 K BMCRR
 K DIR
 D ^XBFMK
 Q
