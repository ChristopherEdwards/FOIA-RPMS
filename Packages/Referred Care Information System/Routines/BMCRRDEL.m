BMCRRDEL ; IHS/PHXAO/TMJ - delete Routine Referral Templates ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;This routine will do a DIC lookup into the Routine Referral
 ;file and delete the entry
 ;
EN ;EP - called from an option 
 W !!,"This option enables the user to delete a Routine Referral Template.",!!
 D GETRPT
 G:'BMCRRPT XIT ;no report selected
 D DELETE
 D XIT
 Q
GETRPT ;get Rourtine Referral entry - Any Routine Referral May be Deleted
 S BMCRRPT=""
 S DIC="^BMCRTNRF(" S DIC(0)="AEQ",DIC("A")="ROUTINE REFERRAL TEMPLATE  NAME:  " D ^DIC K DIC,DA,DR
 Q:Y=-1
 S BMCRRPT=+Y
 Q
DELETE ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete the "_$P(^BMCRTNRF(BMCRRPT,0),U)_" Routine Referral",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:'Y
 W !,"Routine Referral ",$P(^BMCRTNRF(BMCRRPT,0),U)," deleted.",!
 S DA=BMCRRPT,DIK="^BMCRTNRF(" D ^DIK
 Q
XIT ;
 K BMCRRPT
 K DA,DIK,D0
 Q
