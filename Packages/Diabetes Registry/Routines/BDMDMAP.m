BDMDMAP ; IHS/CMI/LAB - print hs for dm patients with appts ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;
 ;this routine will go through the Diabetes Register
 ;and then see if the patient has an appt, if so print health sum
 ;
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 W !!,"This option will print a list of all patients on a register"
 W !,"e.g. Diabetes Register) who have an appointment in a date range"
 W !,"in any clinic or in a selected set of clinics.",!!
 W !!,"You will be asked to enter the name of the register, the date range of the"
 W !,"appointments and the clinic names if selecting a set of clinics.",!
REGISTER ;get register name
 S BDMREG=""
 W ! S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 S BDMREG="" W !,"No Register Selected." G EOJ
 S BDMREG=+Y
DATES K BDMED,BDMBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Appointment Date"
 D ^DIR G:Y<1 REGISTER S BDMBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Appointment Date"
 D ^DIR G:Y<1 REGISTER  S BDMED=Y
 ;
 I BDMED<BDMBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S BDMSD=$$FMADD^XLFDT(BDMBD,-1)_".9999"
 ;
CLIN ;
 S BDMCLN=""
 S DIR(0)="S^A:ANY Clinic;S:One or more selected Clinics",DIR("A")="Include patients with Appointments to",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) DATES
 S BDMCLN=Y
 I BDMCLN="A" K BDMCLN G ZIS
 ;get which clinics
 K BDMCLN
CLIN1 ;
 W ! S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select CLINIC: "
 S DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC
 I Y=-1,'$D(BDMCLN) G CLIN
 I X="^" G CLIN
 I Y="",$D(BDMCLN) G ZIS
 I Y=-1,$D(BDMCLN) G ZIS
 I X="",'$D(BDMCLN) G CLIN
 S BDMCLN(+Y)=""
 G CLIN1
ZIS ;
DEMO ;
 D DEMOCHK^BDMUTL(.BDMDEMO)
 I BDMDEMO=-1 G CLIN
 S XBRP="PRINT^BDMDMAP",XBRC="PROC^BDMDMAP",XBRX="EOJ^BDMDMAP",XBNS="BDM"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 I '$D(BDMGUI) D EN^XBVK("BDM")
 Q
 ;
TEST ;
 D BDMG(1,3040101,3041231,13)
 Q
BDMG(BDMREG,BDMBD,BDMED,BDMCLN) ;EP - GUI DMS Entry Point
 ;cmi/anch/maw added 10/19/2004
 S BDMSD=$$FMADD^XLFDT(BDMBD,-1)_".9999"
 S BDMGUI=1
 N BDMOPT,BDMNOW,BDMIEN  ;maw
 S BDMOPT="List Patients on a Register w/an Appointment"
 D NOW^%DTC
 S BDMNOW=$G(%)
 K DD,D0,DIC
 S X=DUZ_$$NOW^XLFDT
 S DIC("DR")=".02////"_DUZ_";.03////"_BDMNOW_";.06///"_$G(BDMOPT)_";.07////R"
 S DIC="^BDMGUI(",DIC(0)="L",DIADD=1,DLAYGO=9003201.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BDMIEN=-1 Q
 S BDMIEN=+Y
 S BDMGIEN=BDMIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMDMAP",ZTDESC="GUI DM REG APPT" D ^%ZTLOAD
 D EOJ
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"BDMDMAP")
 S IOM=80
 D GUIR^XBLM("PRINT^BDMDMAP","^TMP($J,""BDMDMAP"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BDMDMAP",X)) Q:X'=+X  D
 .S BDMDATA=^TMP($J,"BDMDMAP",X)
 .I BDMDATA="ZZZZZZZ" S BDMDATA=$C(12)
 .S ^BDMGUI(BDMIEN,11,X,0)=BDMDATA,C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BDMDMAP")
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S BDMNOW=$G(%)
 S DIE="^BDMGUI(",DA=BDMIEN,DR=".04////"_BDMNOW_";.07////C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
PROC ;
 S BDMJ=$J,BDMH=$H
 S ^XTMP("BDMDMAP",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"REGISTER PTS WITH APPT"
 S BDMDMX=0 F  S BDMDMX=$O(^ACM(41,"B",BDMREG,BDMDMX)) Q:BDMDMX'=+BDMDMX  D
 .;check to see if patient has an appt
 .S DFN=$P(^ACM(41,BDMDMX,0),U,2)
 .Q:$$DEMO^BDMUTL(DFN,$G(BDMDEMO))
 .S BDMDMY=BDMSD F  S BDMDMY=$O(^DPT(DFN,"S",BDMDMY)) Q:BDMDMY=""!($P(BDMDMY,".")>BDMED)  D
 ..I $P(^DPT(DFN,"S",BDMDMY,0),U,2)["C" Q  ;cancelled
 ..I $D(BDMCLN) S X=$P(^DPT(DFN,"S",BDMDMY,0),U) I '$D(BDMCLN(X)) Q  ;not a clinic of interest
 ..S ^XTMP("BDMDMAP",BDMJ,BDMH,"APPTS",DFN,BDMDMY,$P(^DPT(DFN,"S",BDMDMY,0),U))=""
 ..Q
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K BDMTS,BDMS,BDMM,BDMET
 K ^XTMP("BDMDMAP",BDMJ,BDMH),BDMJ,BDMH
 Q
 ;
PRINT ;EP - called from xbdbque
 S BDMIOSL=$S($G(BDMGUI):55,1:IOSL)
 K BDMQ S BDMPG=0 D HEADER
 I '$D(^XTMP("BDMDMAP",BDMJ,BDMH)) W !!,"NO DATA TO REPORT",! G DONE
 S DFN=0 F  S DFN=$O(^XTMP("BDMDMAP",BDMJ,BDMH,"APPTS",DFN)) Q:DFN'=+DFN!($D(BDMQ))  D
 .S BDMD=0 F  S BDMD=$O(^XTMP("BDMDMAP",BDMJ,BDMH,"APPTS",DFN,BDMD)) Q:BDMD'=+BDMD!($D(BDMQ))  D
 ..S BDMC=0 F  S BDMC=$O(^XTMP("BDMDMAP",BDMJ,BDMH,"APPTS",DFN,BDMD,BDMC)) Q:BDMC'=+BDMC!($D(BDMQ))  D
 ...I $Y>(BDMIOSL-4) D HEADER Q:$D(BDMQ)
 ...W !,$$HRN^AUPNPAT(DFN,DUZ(2)),?7,$E($P(^DPT(DFN,0),U),1,25),?38,$E($P(^SC(BDMC,0),U),1,20),?59,$$FMTE^XLFDT($P(BDMD,".")),?72,$P($$FMTE^XLFDT(BDMD,"2P")," ",2)
 D DONE
 Q
HEADER ;EP
 G:'BDMPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("PATIENTS ON THE "_$P(^ACM(41.1,BDMREG,0),U)_" REGISTER WITH AN APPOINTMENT",80),!
 S X="Appointment Dates: "_$$FMTE^XLFDT(BDMBD)_" to "_$$FMTE^XLFDT(BDMED) W $$CTR(X,80),!
 W $$CTR("CLINICS: "_$S($D(BDMCLN):"USER SELECTED",1:"ANY"),80),!
 W !,"HRN",?7,"PATIENT NAME",?38,"CLINIC NAME",?59,"DATE",?72,"TIME"
 W !,$TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
POST ;
 NEW X
 S X=$$ADD^XPDMENU("BDM M MAIN DM MENU","BDM DM REG APPT CLN","BDM")
 I 'X W "Attempt to new appt list of reg pats failed.." H 3
 Q
