KMPSUTL ;SF/KAK - SAGG Utilities ;01 SEP 97 11:15 am
 ;;1.8;SAGG PROJECT;**1**;May 14, 1999
STAT ;
 W !,?25,"SAGG Project Status",!,?29,"Version ",$P($T(+2),";",3),!,?(35-($L($P($T(+2),";",5))/2)),$P($T(+2),";",5),!
 S U="^",KMPSX2=$P(^%ZOSF("PROD"),",")
 S KMPSDA=0 I '$D(^DIC(19,"B","KMPS SAGG REPORT")) W !," The 'SAGG Master Background Task' option [KMPS SAGG REPORT] is missing !",*7,!
 E  S KMPSDA=$O(^DIC(19,"B","KMPS SAGG REPORT",0)),KMPSDA=+$O(^DIC(19.2,"B",KMPSDA,0)),KMPSX=$G(^DIC(19.2,KMPSDA,0)),Y=+$P(KMPSX,U,2) D:Y DD^%DT S $P(KMPSX,U,2)=Y
 S KMPSTSK=+$G(^DIC(19.2,+KMPSDA,1))
 W !,?5,"The 'SAGG Master Background Task' [KMPS SAGG REPORT] is ",$S('KMPSTSK:"NOT ",1:""),"scheduled",$S('KMPSTSK:".",1:""),!
 I KMPSTSK D
 .W ?5,"to run as Task ID ",KMPSTSK," on ",$S($P(KMPSX,U,2)="":"NO DATE",1:$P(KMPSX,U,2))
 .S KMPSX=$P(KMPSX,U,6) W " every ",$S(KMPSX="":"UNKNOWN",1:+KMPSX)," ",$S(KMPSX["D":"day",KMPSX["M":"month",1:KMPSX)
 .W:KMPSX>1 "s" W ".",!
 D SYS
 W !,?5,"SAGG Project collection routines will monitor the following:",!!,?7 S (KMPS,KMPSX)=0
 F  S KMPSX=$O(^KMPS(8970.1,1,1,"B",KMPSX)) Q:KMPSX=""  D  W:KMPS " - " W $S(KMPSSYS'="OMNT":KMPSX3_",",1:""),KMPSX S KMPS=KMPS+1 I KMPS=6 S KMPS=0 W !,?7
 .S KMPSX3=$O(^KMPS(8970.1,1,1,"B",KMPSX,0)),KMPSX3=$P(^KMPS(8970.1,1,1,KMPSX3,0),U,2) S:KMPSX3="" KMPSX3=KMPSX2
 D SYS
 W ! I KMPSSYS'="OMNT" S KMPSX=$G(^KMPS(8970.1,1,0)) W !,?5,"XTMP(""KMPS"") Global Location: ",$S($P(KMPSX,U,3)="":KMPSX2,1:$P(KMPSX,U,3)),",",$S($P(KMPSX,U,2)="":"UNKNOWN",1:$P(KMPSX,U,2)),!
 S KMPS=^DD("SITE",1)
 W !,?5,"The temporary collection global (i.e., ^XTMP(""KMPS"")) has ",$S('$D(^XTMP("KMPS",KMPS)):"no ",1:""),"data.",!
 I $D(^XTMP("KMPS",KMPS,0)) S %H=+^(0) W !,?5,"Session #",%H D YX^%DTC W " is running for ",Y,".",! I +$H-%H>1 W ?5,"This session has probably errored out.",!
 I $D(^XTMP("KMPS","START")) W !,?5,"The SAGG Project routines are still running on:",!!,?7 S (KMPS,KMPSX)=0 F  S KMPSX=$O(^XTMP("KMPS","START",KMPSX)) Q:KMPSX=""  W:KMPS ", " W KMPSX S KMPS=KMPS+1 I KMPS=12 S KMPS=0 W !,?7
 W ! I $D(^XTMP("KMPS","ERROR")) W !!,"Press <RETURN> to continue: " R X:DTIME G:'$T!(X["^") END W @IOF,!,?5,"The SAGG Project collection routines have recorded an error on",!,?5,"Volume Set(s):",!! D  W !
 .S KMPS=0,KMPSX="" F  S KMPSX=$O(^XTMP("KMPS","ERROR",KMPSX)) Q:KMPSX=""  W:KMPS ", " W:'KMPS ?7 W KMPSX S KMPS=1
 I $D(^XTMP("KMPS","STOP")) W !,?5,"The SAGG Project collection routines have been informed to begin",!,?5,"an orderly shut-down process."
 I $D(^XTMP("KMPS","STOP")),$D(^XTMP("KMPS","START")) W "  The routines will stop running",!,?5,"after reaching the appropriate break-point."
 W !!,"Press <RETURN> to continue: " R X:DTIME
END ;
 K %,%H,KMPS,KMPSDA,KMPSSYS,KMPSX,KMPSX2,KMPSX3,X,Y Q
STOP ;
 I '$D(^XTMP("KMPS","START")) W !,?5,"The SAGG Project collection routines have not started.",! Q
 D STAT W !
 S DIR("A")="Do you wish to manually STOP the SAGG Project collection routines (Y/N)",DIR("B")="N",DIR(0)="Y" D ^DIR W !
 I Y S ^XTMP("KMPS","STOP")=1 W !,?5,"The SAGG Project collection routines have been notified to begin an",!,?5,"orderly shut-down process.",!
 K DIR,X,Y Q
FILE ;
 D SYS I KMPSSYS'="OMNT" D
 .W !!,"Please specify the Volume Set and UCI which will hold"
 .W !,"the ^XTMP(""KMPS"") global.",!
 .S DIE="^KMPS(8970.1,",DLAYGO=8970.1,DA=1,DR=".02;.025" D ^DIE
 W !!,"Specify the " W $S(KMPSSYS="VAX":"Volume Sets",1:"Directories")
 W " which hold your VistA production globals:",!!,"For example:",!!,?10
 I KMPSSYS="VAX" W "For DSM =>  ROU, VAA, VBB, VCC ... Vxx"
 I KMPSSYS="MSM" W "For MSM =>  FDA, FDB, FDC ... FDx"
 I KMPSSYS="OMNT" W "For OpenM-NT =>  W:\VAA, W:\VBB, W:\VCC ... V:\Vxx"
 I KMPSSYS="UNKWN" W "Specify all locations of VistA globals"
 W !!,"Do NOT specify 'scratch/test/training' " W $S(KMPSSYS="VAX":"Volume Sets",1:"Directories")
 W " (i.e., ZAA, UTL," W !,"TST, etc.).",!
 S DIE="^KMPS(8970.1,",DA=1,DR=.03 S:KMPSSYS="OMNT" DR(2,8970.11)=.01 D ^DIE
 K DA,DIC,DIE,DLAYGO,DR,KMPSSYS Q
MAIL ;
 W !!,"Specify the users that will receive SAGG notification messages.",!
 S (DIC,DIE)="^XMB(3.8,",DIC(0)="LZ",DLAYGO=3.8,X="KMPS-SAGG" D ^DIC
 S DA=+Y,DR=2 D ^DIE
 K DA,DIC,DIE,DLAYGO,DR,X,Y Q
SYS ;
 S KMPSSYS=$P($P(^%ZOSF("OS"),U),"("),KMPSSYS=$S(KMPSSYS="VAX DSM":"VAX",KMPSSYS["MSM-PC":"MSM",KMPSSYS="OpenM-NT":"OMNT",1:"UNKWN")
 Q
