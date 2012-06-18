ABMDTEMP ; IHS/ASDST/DMJ - Table Maintenance of EMPLOYER FILE ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S U="^"
EDIT W !! K DIC S DIC="^AUTNEMPL(",DIC("A")="Select EMPLOYER: ",DIC(0)="QLEAM" D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G EDIT
 S DA=+Y
 S DIE="^AUTNEMPL(",DR="W !;.01Employer..:;.02Street....:;.03City......:;.04State.....:;.05Zip.......:;.06Phone.....:;.07Abbrev....:;W !;.08Billing Entity for Workmen's Comp.:" D ^ABMDDIE K DR
 ;
XIT K DIR,DIC,DIE
 Q
