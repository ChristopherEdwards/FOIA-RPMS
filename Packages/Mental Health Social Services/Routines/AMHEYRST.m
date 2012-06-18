AMHEYRST ; IHS/CMI/LAB - RESET TX LOG AUGUST 14, 1992 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 W !!,"This routine will reset the BH Data Transmission Log.  You must be",!,"absolutely sure that you have corrected the underlying problem that caused ","the Transmission process to fail in the first place!",!!
 W "The BH Data Transmission log entry you choose will be REMOVED from the log",!,"file and all Utility and Data globals associated with that run will be killed!!",!!
 W "You must now select the Log Entry to be RESET.  <<< SELECT CAREFULLY >>>",!
 S DIC="^AMHXLOG(",DIC(0)="AEMQ",DIC("S")="I $P(^AMHXLOG(Y,0),U,15)'=""C"",$P(^AMHXLOG(Y,0),U,15)'=""P""" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G EOJ
 S AMHDFN=+Y
 D DISP
 S DIR(0)="Y",DIR("A")="Are you sure you want to do this",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y'=1 D EOJ Q
DIK ;
 S DA=AMHDFN,DIK="^AMHXLOG(" D ^DIK
 K ^XTMP("AMHDR"),^XTMP("AMHSF"),^XTMP("AMHREDO"),^BHSXDATA ;UNSUBSCRIPTED VARIABLES KILLED - THESE ARE CMB STANDARD DEFINED SCRATCH GLOBALS FOR TRANSMITTING DATA TO DATA CENTER
 D EOJ
 Q
DISP ;
DIQ ; CALL TO DIQ
 W !!,"Information for Log Entry ",AMHDFN,!
 S DIC="^AMHXLOG(",DA=AMHDFN,DR="0;11",DIQ(0)="C" D EN^DIQ
 K DIC,DIQ,DR,DA
 Q
EOJ ;
 K DA,DIK,AMHDFN,Y,X,DIR,DIRUT
 Q
