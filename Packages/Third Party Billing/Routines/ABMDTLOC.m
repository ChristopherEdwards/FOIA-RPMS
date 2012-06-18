ABMDTLOC ; IHS/ASDST/DMJ - Table Maintenance of LOCATION FILE ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 10/19/01 - V2.4 Patch 9 - NOIS HQW-1001-100086
 ;     Allow Place of Service entry
 ;
 ; *********************************************************************
 ;
 S U="^" W !
 ;
EDIT W !! K DIC S DIC="^AUTTLOC(",DIC("A")="Select LOCATION to Edit: ",DIC(0)="QZEAM" D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G EDIT
 S DA=+Y
 S DIE="^AUTTLOC("
 S DR="W !;.14T;.15T;.16T;.17T;.13T;.21T;.22T"
 D ^ABMDDIE K DR
 S DIE="^DIC(4,"
 S DR="W !;1.01;1.02;1.03;.02;1.04;W !"
 D ^DIE K DR
 S ABMLOC=DA
 I '$D(^ABMDPARM(ABMLOC)) D
 .S ^ABMDPARM(ABMLOC,0)="3P PARAMETERS^9002274.5P^1^1"
 .S ^ABMDPARM(ABMLOC,1,0)=ABMLOC
 .S ^ABMDPARM(ABMLOC,"B",ABMLOC,1)=""
 S DIE="^ABMDPARM("_ABMLOC_","
 S DA=1
 S DR=".36;.24;.51"
 D ^DIE
 K ABMLOC
 G EDIT
 ;
XIT K ABM,DIR,DIC,DIE
 Q
