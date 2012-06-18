APCPRSET ; IHS/TUCSON/LAB - RESET TX LOG AUGUST 14, 1992 ; [ 09/16/02 12:16 PM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,6**;APR 03, 1998
 ;IHS/CMI/LAB - XTMP
 W !!,"This routine will reset the PCC Data Transmission Log.  You must be",!,"absolutely sure that you have corrected the underlying problem that caused ","the Transmission process to fail in the first place!",!!
 W "The PCC Data Transmission log entry you choose will be REMOVED from the log",!,"file and all Utility and Data globals associated with that run will be killed!!",!!
 W "You must now select the Log Entry to be RESET.  <<< SELECT CAREFULLY >>>",!
 S DIC="^APCPLOG(",DIC(0)="AEMQ",DIC("S")="I $P(^APCPLOG(Y,0),U,15)'=""C"",$P(^APCPLOG(Y,0),U,15)'=""P""" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G EOJ
 S APCPDFN=+Y
 D DISP
 S DIR(0)="Y",DIR("A")="Are you sure you want to do this",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y'=1 D EOJ Q
DIK ;
 S DA=APCPDFN,DIK="^APCPLOG(" D ^DIK
 K ^XTMP("APCPDR"),^XTMP("APCPREDO"),^BAPCDATA ;UNSUBSCRIPTED VARIABLES KILLED - THESE ARE CMB STANDARD DEFINED SCRATCH GLOBALS FOR TRANSMITTING DATA TO DATA CENTER IHS/CMI/LAB XTMP
 D EOJ
 Q
DISP ;
DIQ ; CALL TO DIQ
 W !!,"Information for Log Entry ",APCPDFN,!
 S DIC="^APCPLOG(",DA=APCPDFN,DR="0;11",DIQ(0)="C" D EN^DIQ
 K DIC,DIQ,DR,DA
 Q
EOJ ;
 K DA,DIK,APCPDFN,Y,X,DIR,DIRUT
 Q
