AGTMEMPL ; IHS/ASDS/EFG - Table Maintenance of EMPLOYER FILE ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S U="^"
 W !
EDIT W !! K DIC S DIC="^AUTNEMPL(",DIC("A")="Select EMPLOYER: ",DIC(0)="QLEAM" D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G EDIT
 S DA=+Y
 S DIE="^AUTNEMPL(",DR="W !;.01Employer..:;.02Street....:;.03City......:;.04State.....:;.05Zip.......:;.06Phone.....:;.07Abbrev....:" D ^DIE K DR
 G EDIT
XIT K AG,DIR,DIC,DIE
 Q
