MASETUP1 ;IHS/ADC/PDW/ENM - Routine to install MAS modelling KIDS [ 05/13/1999  2:44 PM ]
 ;;5.0;MAS INSTALLATION;**1**;MAY 04, 1999
 ;IHS/DSD/ENM This setup program is a copy of MASSETUP.
 ;It was created to do a different environment check for
 ;outpatient only sites!
 ;searhc/maw added call to POST for post processing
 Q
EN ;EP START      
 W !,?10,"Welcome to the MAS Installation Shell",!
 W !,?10,"Doing ^XUP ... >> DO NOT PICK AN OPTION !! <<",!
 D ^XUP
 W !,?10,"Doing P^DI ... >> DO NOT PICK AN OPTION, Press 'Return' !! <<",! ;IHS/DSD/ENM 05/06/99
 D Q^DI ;IHS/DSD/ENM 05/06/99
 W !!
 I $G(DUZ)'>0 W !,"Not a valid user ... Stopping Installation" Q
 S MASSITETYPE=2 ;IHS/DSD/ENM 05/03/99
 S X="ADMISSION/DISCHARGE/TRANSFER"
 S DIC=$$DIC^XBDIQ1(9.4),DIC(0)="MX" D ^DIC
 I Y'>0 W !,"Possible Problem with ADT package not found in Package File"
 S XBDGDA=+Y
 S X="IHS SCHEDULING"
 S DIC=$$DIC^XBDIQ1(9.4),DIC(0)="MX" D ^DIC
 I Y'>0 W !,"Possible Problem with IHS SCHEDULING package not found in Package File"
 S XBSDDA=+Y
 S XBDGVER=$$VAL^XBDIQ1(9.4,XBDGDA,13)
 S XBSDVER=$$VAL^XBDIQ1(9.4,XBSDDA,13)
 W !!,?5,"Package",?40,"Current Version"
 W !!,?5,"ADMISSION/DISCHARGE/TRANSFER",?40,XBDGVER
 W !,?5,"IHS SCHEDULING",?40,XBSDVER
 I +XBDGVER I XBDGVER'>4.1 W !!,"Stopping Installation ... ADT not 4.2 or later" G EXIT ;====>> ;IHS/DSD/ENM 07/24/98 VERSION #CHANGED
 I '$D(^XTMP("MAS_INSTAL")) D SET
STAT ;EP scan the footprint and process
 W !!,?10,"MAS Installation Shell Tracking"
 W !,?5,"Step",?15,"Function",?35,"Completed"
 S MASNEXT=0,MASLAST=0
 S I=0 F  S I=$O(^XTMP("MAS_INSTAL",I)) Q:I'>0  D WRITE
 S MASNEXT=MASLAST+1
 ; if a previous installation was started MASNEXT = the nextstep
 ;
 W !!,"The next step is step ",MASNEXT,!
 I MASNEXT=1 G MAS2
 W !,?5,"C -Continue   E -Exit   S -Start Over   R -Rerun Last Step",!
 K DIR S DIR(0)="SB^C:Continue;E:Exit;S:Start Over;R:Rerun Last Step" D ^DIR
 I Y="E" W !!,"EXITING",! G EXIT
 I Y="S" W !!,"Starting Over",! K ^XTMP("MAS_INSTAL") G EN
 I Y="R" W !!,"Rerun Last Step" S MASNEXT=MASNEXT-1 G MAS2
 I Y'="C" G EXIT
MAS2 ;EP picking up where the instal left off
 S MAS2=$O(^XTMP("MAS_INSTAL",MASNEXT,0)),MAS3=$O(^(MAS2,0))
 ; branch to the next step in MAS3
 G @MAS3 ;====>> @MAS3
 ;
 ;
WRITE ;EP
 S MAS2=$O(^XTMP("MAS_INSTAL",I,0)),MAS3=$O(^(MAS2,0))
 W !?5,I,?15,MAS2
 S MAST=$G(^XTMP("MAS_INSTAL",I))
 I 'MAST W ?35,"NO" Q
 E  W ?35,"YES"
 I MAST S MASLAST=I
 Q
 ; **** entry to the entry points is controlled by STAT
DGYPINIT ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=1,MAS2="D ^DGYPINIT",MAS3="DGYPINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT
 W @IOF,?10,MAS2
 W !,"Ready to run ^DGYPINIT ..  answer yes to all questions,"
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DGYPINIT
 S ^XTMP(MAS1,MASI)=1
 ;
ORINIT ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=2,MAS2="D ^ORINIT",MAS3="ORINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^ORINIT ..  answer yes to all questions (5+ MIN),"
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^ORINIT
 S ^XTMP(MAS1,MASI)=1
 ;
DPTINIT ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=3,MAS2="D ^DPTINIT",MAS3="DPTINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^DPTINIT ..  answer yes to all questions (3+ MIN),"
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DPTINIT
 S ^XTMP(MAS1,MASI)=1
 ;
DGINIT ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=4,MAS2="D ^DGINIT",MAS3="DGINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^DGINIT ..  answer yes to all questions (>>1 & 1/2 HOURS<<),"
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DGINIT
 S ^XTMP(MAS1,MASI)=1
 ;
DG5INIT ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=5,MAS2="D ^DG5INIT",MAS3="DG5INIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^DG5INIT ..  answer yes to all questions (30+ MIN),"
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DG5INIT
 S ^XTMP(MAS1,MASI)=1
 ;
SDINIT ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=6,MAS2="D ^SDINIT",MAS3="SDINIT",MAS3="SDINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^SDINIT ..  answer yes to all questions (40+ MIN),"
 I '+$G(XBSDVER) D  I Y'>1 G SKIPSD ;====>>
 . W !,"Scheduling is not previously installed on your system",!
 . S DIR(0)="E",DIR("A")="Enter ""^"" to Skip SDINIT" D ^DIR
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^SDINIT
SKIPSD ;EP skipping SDINIT
 S ^XTMP(MAS1,MASI)=1
 ;
DGPM5P1 ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=7,MAS2="D ^DGPM5 part 1",MAS3="DGPM5P1"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^DGPM5 part 1 .."
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DGPM5
 S ^XTMP(MAS1,MASI)=1
 ;
DGPM5P2 ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=8,MAS2="D ^DGPM5 part 2",MAS3="DGPM5P2"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^DGPM5 part 2 .."
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DGPM5
 S ^XTMP(MAS1,MASI)=1
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 ;
 ;
POST ;EP
 ;searhc/maw this should be called last, it will convert the pointers
 ;in the V Hospitalization file, patient movement and provider 
 ;pointers
 S MAS1="MAS_INSTAL",MASI=8,MAS2="POST^MASSETUP",MAS3="POST"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 W @IOF,?10,MAS2
 W !,"Ready to run MAS Post Init Processing .."
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit"
 D ^DIR
 I Y'=1 G EXIT
 D ^ADGGFL
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit"
 I Y'=1 G EXIT
 D ^ADGCP
 S ^XTMP(MAS1,MASI)=1
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit"
 I Y'=1 G EXIT
 ;
DELINI ;EP delete routines
 S MAS1="MAS_INSTAL",MASI=9,MAS2="Delete Inits",MAS3="DELINI"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to Delete Inits .."
 S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 K DIR
 S DIR(0)="Y"
 K ^XTMP("ZIBRSEL",$J)
 S Z=$$RSEL^ZIBRSEL("DGINI-DGINIZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DGONI-DGONIZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DG5INI-DG5INIZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DGYP-DGYPZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("SDINI-SDINIZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("SDONI-SDONIZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("ORINI-ORINIZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DPTIN-DPTINZZZ") D DEL
 K ^XTMP("ZIBRSEL",$J)
 S ^XTMP(MAS1,MASI)=1
 ;
FINISH ;EP
 W !,"MAS VERSION 5.0 Installation has been completed"
 W !,"Proceed with step 11 of the installation instructions"
 S DIR(0)="E",DIR("A")="<CR>" D ^DIR
 ;
EXIT ;EP             
 D EN^XBVK("MAS"),EN^XBVK("XB")
 Q
DEL ;EP
 W !!,Z S X="" F I=1:1 S X=$O(^TMP("ZIBRSEL",$J,X)) Q:X=""  D
 . W ?(10*I),X
 . X ^%ZOSF("DEL")
 . I I=7 W ! S I=0
 Q
SET ;EP
 S X1=DT,X2=30 D C^%DTC
 S MAS1="MAS_INSTAL",MASI=1,MAS2="D ^DGYPINIT",MAS3="DGYPINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=2,MAS2="D ^ORINIT",MAS3="ORINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=3,MAS2="D ^DPTINIT",MAS3="DPTINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=4,MAS2="D ^DGINIT",MAS3="DGINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=5,MAS2="D ^DG5INIT",MAS3="DG5INIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=6,MAS2="D ^SDINIT",MAS3="SDINIT",MAS3="SDINIT"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=7,MAS2="D ^DGPM5 part 1",MAS3="DGPM5P1"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=8,MAS2="D ^DGPM5 part 2",MAS3="DGPM5P2"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=9,MAS2="D POST^MASSETUP",MAS3="POST"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 S MAS1="MAS_INSTAL",MASI=10,MAS2="Delete Inits",MAS3="DELINI"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 Q
