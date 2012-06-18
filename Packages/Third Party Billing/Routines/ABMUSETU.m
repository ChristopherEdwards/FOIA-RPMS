ABMUSETU ; IHS/SD/SDR - 3PB/UFMS Setup Option   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New routine - v2.5 p12 SDD item 4.9.2.7
EP ;
 ;Option to turn off UFMS export/cashiering if tribal
 S ABMADIEN=$O(^AUTTLOC(DUZ(2),11,9999999),-1)
 I +$G(ABMADIEN)=0 W !,"Affiliation has not been set up.  Contact your site manager to add this entry",!,"to the Location file." H 2 Q
TRIBAL I $P($G(^AUTTLOC(DUZ(2),11,ABMADIEN,0)),U,3)'="1" D  ;if affiliation anything but IHS
 .K DIC,DIE,X,Y,DA
 .S DIE="^ABMDPARM(DUZ(2),"
 .S DA=1
 .S DR="414"
 .D ^DIE
 .I ($P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1) D
 ..D FINDAOPN^ABMUCUTL
 ..I $D(ABMO) W !!,"PLEASE NOTE: YOU CURRENTLY HAVE OPEN SESSIONS ON YOUR SYSTEM!",! H 1
 .S DR="415"
 .D ^DIE
 .I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1,($P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=0) D
 ..W !!,"You have chosen not to do cashiering sessions (export files are created based on"
 ..W !,"these sessions).  By not doing cashiering sessions, export files can not be"
 ..W !,"created."
 ..W !!,"If you continue, TPB will override the UFMS export to NO and data will NOT be"
 ..W !,"exported.",!
 ..K DIC,DIE,DIR,X,Y,DA
 ..S DIR(0)="Y",DIR("A")="Do you wish to continue" D ^DIR K DIR
 ..S ABMCANS=+Y
 .;if yes to export, no to cashiering and no to continue
 .I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1,($P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=0),($G(ABMCANS)=0) G TRIBAL
 .;if yes to export, no to cashiering and yes to continue
 .I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1,($P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=0),($G(ABMCANS)=1) D  Q
 ..K DIC,DIE,X,Y,DA
 ..S DIE="^ABMDPARM(DUZ(2),"
 ..S DA=1
 ..S DR="414////0"
 ..D ^DIE
 .;if no to export,yes to cashiering
 .I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=0,($P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1) D
 ..K DIC,DIE,X,Y,DA
 ..S DIE="^ABMDPARM(DUZ(2),"
 ..S DA=1
 ..S DR="416//5"
 ..D ^DIE
 I $P($G(^AUTTLOC(DUZ(2),11,ABMADIEN,0)),U,3)="1"!($P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1) D
 .K DIC,DIE,X,Y,DA
 .S DIE="^ABMDPARM(DUZ(2),"
 .S DA=1
 .S DR="413;416//5;417"
 .D ^DIE
 ;
 I $P($G(^AUTTLOC(DUZ(2),11,ABMADIEN,0)),U,3)="1" D ^ABMUXCLD  ;exclude tribal data
 Q
