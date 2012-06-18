APCLDMAP ; IHS/CMI/LAB - print hs for dm patients with appts ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
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
 S APCLREG=""
 W ! S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 S APCLREG="" W !,"No Register Selected." G EOJ
 S APCLREG=+Y
DATES K APCLED,APCLBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Appointment Date"
 D ^DIR G:Y<1 REGISTER S APCLBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Appointment Date"
 D ^DIR G:Y<1 REGISTER  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S APCLSD=$$FMADD^XLFDT(APCLBD,-1)_".9999"
 ;
CLIN ;
 S APCLCLN=""
 S DIR(0)="S^A:ANY Clinic;S:One or more selected Clinics",DIR("A")="Include patients with Appointments to",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) DATES
 S APCLCLN=Y
 I APCLCLN="A" K APCLCLN G ZIS
 ;get which clinics
 K APCLCLN
CLIN1 ;
 W ! S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select CLINIC: "
 S DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC
 I Y=-1,'$D(APCLCLN) G CLIN
 I X="^" G CLIN
 I Y="",$D(APCLCLN) G ZIS
 I Y=-1,$D(APCLCLN) G ZIS
 I X="",'$D(APCLCLN) G CLIN
 S APCLCLN(+Y)=""
 G CLIN1
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CLIN
 S XBRP="PRINT^APCLDMAP",XBRC="PROC^APCLDMAP",XBRX="EOJ^APCLDMAP",XBNS="APCL"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 D EN^XBVK("APCL")
 Q
 ;
TEST ;
 D BDMG(1,3040101,3041231,13)
 Q
BDMG(APCLREG,APCLBD,APCLED,APCLCLN) ;EP - GUI DMS Entry Point
 ;cmi/anch/maw added 10/19/2004
 S APCLSD=$$FMADD^XLFDT(APCLBD,-1)_".9999"
 S APCLGUI=1
 N APCLOPT,APCLNOW,APCLIEN  ;maw
 S APCLOPT="List Patients on a Register w/an Appointment"
 D NOW^%DTC
 S APCLNOW=$G(%)
 K DD,D0,DIC
 S X=DUZ_$$NOW^XLFDT
 S DIC("DR")=".02////"_DUZ_";.03////"_APCLNOW_";.06///"_$G(APCLOPT)_";.07////R"
 S DIC="^APCLGUIR(",DIC(0)="L",DIADD=1,DLAYGO=9001004.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S APCLIEN=-1 Q
 S APCLIEN=+Y
 S BDMGIEN=APCLIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^APCLDMAP",ZTDESC="GUI DM REG APPT" D ^%ZTLOAD
 D EOJ
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"APCLDMAP")
 S IOM=80
 D GUIR^XBLM("PRINT^APCLDMAP","^TMP($J,""APCLDMAP"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"APCLDMAP",X)) Q:X'=+X  D
 .S APCLDATA=^TMP($J,"APCLDMAP",X)
 .I APCLDATA="ZZZZZZZ" S APCLDATA=$C(12)
 .S ^APCLGUIR(APCLIEN,11,X,0)=APCLDATA,C=C+1
 S ^APCLGUIR(APCLIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=APCLIEN,DIK="^APCLGUIR(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"APCLDMAP")
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S APCLNOW=$G(%)
 S DIE="^APCLGUIR(",DA=APCLIEN,DR=".04////"_APCLNOW_";.07////C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
PROC ;
 S APCLJ=$J,APCLH=$H
 S ^XTMP("APCLDMAP",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"REGISTER PTS WITH APPT"
 S APCLDMX=0 F  S APCLDMX=$O(^ACM(41,"B",APCLREG,APCLDMX)) Q:APCLDMX'=+APCLDMX  D
 .;check to see if patient has an appt
 .S DFN=$P(^ACM(41,APCLDMX,0),U,2)
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .S APCLDMY=APCLSD F  S APCLDMY=$O(^DPT(DFN,"S",APCLDMY)) Q:APCLDMY=""!($P(APCLDMY,".")>APCLED)  D
 ..I $P(^DPT(DFN,"S",APCLDMY,0),U,2)["C" Q  ;cancelled
 ..I $D(APCLCLN) S X=$P(^DPT(DFN,"S",APCLDMY,0),U) I '$D(APCLCLN(X)) Q  ;not a clinic of interest
 ..S ^XTMP("APCLDMAP",APCLJ,APCLH,"APPTS",DFN,APCLDMY,$P(^DPT(DFN,"S",APCLDMY,0),U))=""
 ..Q
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K APCLTS,APCLS,APCLM,APCLET
 K ^XTMP("APCLDMAP",APCLJ,APCLH),APCLJ,APCLH
 Q
 ;
PRINT ;EP - called from xbdbque
 S APCLIOSL=$S($G(APCLGUI):55,1:IOSL)
 K APCLQ S APCLPG=0 D HEADER
 I '$D(^XTMP("APCLDMAP",APCLJ,APCLH)) W !!,"NO DATA TO REPORT",! G DONE
 S DFN=0 F  S DFN=$O(^XTMP("APCLDMAP",APCLJ,APCLH,"APPTS",DFN)) Q:DFN'=+DFN!($D(APCLQ))  D
 .S APCLD=0 F  S APCLD=$O(^XTMP("APCLDMAP",APCLJ,APCLH,"APPTS",DFN,APCLD)) Q:APCLD'=+APCLD!($D(APCLQ))  D
 ..S APCLC=0 F  S APCLC=$O(^XTMP("APCLDMAP",APCLJ,APCLH,"APPTS",DFN,APCLD,APCLC)) Q:APCLC'=+APCLC!($D(APCLQ))  D
 ...I $Y>(APCLIOSL-4) D HEADER Q:$D(APCLQ)
 ...W !,$$HRN^AUPNPAT(DFN,DUZ(2)),?7,$E($P(^DPT(DFN,0),U),1,25),?38,$E($P(^SC(APCLC,0),U),1,20),?59,$$FMTE^XLFDT($P(APCLD,".")),?72,$P($$FMTE^XLFDT(APCLD,"2P")," ",2)
 D DONE
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 I $G(APCLGUI),APCLPG'=1 W !,"ZZZZZZZ"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("PATIENTS ON THE "_$P(^ACM(41.1,APCLREG,0),U)_" REGISTER WITH AN APPOINTMENT",80),!
 S X="Appointment Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 W $$CTR("CLINICS: "_$S($D(APCLCLN):"USER SELECTED",1:"ANY"),80),!
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
 S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCL DM REG APPT CLN","APCL")
 I 'X W "Attempt to new appt list of reg pats failed.." H 3
 Q
