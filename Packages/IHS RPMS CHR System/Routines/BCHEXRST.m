BCHEXRST ; IHS/TUCSON/LAB - RESET TX LOG AUGUST 14, 1992 ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 W !!,"This routine will reset the CHR Data Transmission Log.  You must be",!,"absolutely sure that you have corrected the underlying problem that caused ","the Transmission process to fail in the first place!",!!
 W "The CHR Data Transmission log entry you choose will be REMOVED from the log",!,"file and all Utility and Data globals associated with that run will be killed!!",!!
 W "You must now select the Log Entry to be RESET.  <<< SELECT CAREFULLY >>>",!
 S DIC="^BCHXLOG(",DIC(0)="AEMQ",DIC("S")="I $P(^BCHXLOG(Y,0),U,15)'=""C"",$P(^BCHXLOG(Y,0),U,15)'=""P""" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G EOJ
 S BCHDFN=+Y
 D DISP
 S DIR(0)="Y",DIR("A")="Are you sure you want to do this",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y'=1 D EOJ Q
DIK ;
 S DA=BCHDFN,DIK="^BCHXLOG(" D ^DIK
 K ^TMP("BCHDR"),^TMP("BCHREDO"),^BCHRDATA ;UNSUBSCRIPTED VARIABLES KILLED - THESE ARE CMB STANDARD DEFINED SCRATCH GLOBALS FOR TRANSMITTING DATA TO DATA CENTER
 S X=$P(^BCHSITE(DUZ(2),0),U,11) I X S X=X-1,DIE="^BCHSITE(",DA=DUZ(2),DR=".11///"_X D ^DIE K DIE,DA,DR
 D EOJ
 Q
DISP ;
DIQ ; CALL TO DIQ
 W !!,"Information for Log Entry ",BCHDFN,!
 S DIC="^BCHXLOG(",DA=BCHDFN,DR="0;11",DIQ(0)="C" D EN^DIQ
 K DIC,DIQ,DR,DA
 Q
EOJ ;
 K DA,DIK,BCHDFN,Y,X,DIR,DIRUT
 Q
