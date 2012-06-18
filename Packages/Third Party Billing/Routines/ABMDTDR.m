ABMDTDR ; IHS/ASDST/DMJ - Table Maintenance of DRUG FILE ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S U="^" W !
 ;
EDIT W !! K DIC S DIC="^PSDRUG(",DIC("A")="Select DRUG to Edit: ",DIC(0)="QZEAM" D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G EDIT
 S DA=+Y
 S DIE="^PSDRUG(",DR="W !;31NDC Number.....: " D ^ABMDDIE G XIT:$D(ABM("DIE-FAIL"))
 W ! I $P($G(^PSDRUG(DA,660)),U,8)]"" W !?5,"(Units: ",$P(^(660),U,8),")"
 S DR="16Price Per Dispense Unit..: " D ^ABMDDIE G XIT:$D(ABM("DIE-FAIL"))
 I X S DR="13////"_(X*$P($G(^PSDRUG(DA,660)),U,5)) D ^ABMDDIE
 G EDIT
 ;
XIT K DIR,DIC,DIE
 Q
