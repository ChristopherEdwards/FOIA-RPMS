BGP0DPA9 ; IHS/CMI/LAB - COMP NATIONAL GPRA FOR PTS W/APPT ;
 ;;10.0;IHS CLINICAL REPORTING;**1**;JUN 18, 2010
 ;
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 D TERM^VALM0
 S BGPCTRL=$O(^BGPCTRL("B",2010,0))
 S X=0 F  S X=$O(^BGPCTRL(BGPCTRL,69,X)) Q:X'=+X  W !,^BGPCTRL(BGPCTRL,69,X,0)
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" D ^DIR K DIR
 I '$D(^XUSEC("BGPZ PATIENT LISTS",DUZ)) W !!,"You do not have the security access to print patient lists.",!,"Please see your supervisor or program manager if you feel you should have",!,"the BGPZ PATIENT LISTS security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 ;
RTYPE ;
 S BGPRT1=""
 S DIR(0)="S^C:By CLINIC NAME for a specified appointment date range;P:Selected Patients w/Appointments;D:One Facility's or Divisions Appointments;A:Any selected set of patients regardless of appt status"
 S DIR("A")="Create List/Sort by",DIR("B")="C" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 S BGPRT1=Y
 I BGPRT1="C" D CLIN G:$G(BGPQUIT) RTYPE G DATES
 I BGPRT1="D" D DIV G:$G(BGPQUIT) RTYPE G DATES
 I BGPRT1="P" D GETPAT G:$G(BGPQUIT) RTYPE G DATES
 I BGPRT1="A" D SELPT G:$G(BGPQUIT) RTYPE G ZIS
DATES K BGPAED,BGPABD
 K DIR W ! S DIR(0)="DO^::E",DIR("A")="Enter Beginning Appointment Date"
 D ^DIR G:Y<1 EOJ S BGPABD=Y
 K DIR S DIR(0)="DO^::EX",DIR("A")="Enter Ending Appointment Date"
 D ^DIR G:Y<1 EOJ  S BGPAED=Y
 ;
 I BGPAED<BGPABD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S BGPASD=$$FMADD^XLFDT(BGPABD,-1)_".9999"
 ;
ZIS ;
 S BGPRTYPE=1,BGP0RPTH="",BGPCPPL=1,BGPINDT="G",BGP0GPU=1,BGPALLPT=1,BGPBEN=3
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 ;I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2
 ;W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
ENDDATE ;
 ;AI ;gather all gpra measures
 S X=0 F  S X=$O(^BGPINDT("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S X=$O(^BGPCTRL("B",2010,0))
 S Y=^BGPCTRL(X,0)
 S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 S BGPPER=$P(Y,U,14),BGPQTR=3
 ;ADDED FOR 09 REPORT
 S BGPBD=3100701,BGPED=3110630
 S BGPPBD=3090701,BGPPED=3100630
 S BGPPER=3110000
 S BGPNGR09=1
 S BGPLIST="A"
 S BGPCPLC=0
 ;
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D EOJ Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 I $D(ZTQUEUED) S ZTREQ="@"
 D PROC^BGP0DPA9
 U IO
 D PRINT^BGP0DPAW
 D ^%ZISC
 D EOJ
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP0DPA9",ZTDTH="",ZTDESC="CRS 10 SCHED REPORT FOR 11" D ^%ZTLOAD D EOJ Q
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR,DFN
 D EN^XBVK("BGP"),EN^XBVK("BSD"),EN^XBVK("AMQQ")
 K ^TMP($J)
 Q
 ;
DIV ;
 S BGPQUIT="",BGPDIVI=""
 K DIC
 S DIC="^DG(40.8,",DIC(0)="AEMQ"  ; I $O(^DG(40.8,"C",DUZ(2),0)) S DIC("B")=$P(^DIC(4,$O(^DG(40.8,"C",DUZ(2),0)),0),U)
 D ^DIC K DIC
 I Y=-1 S BGPQUIT=1 Q
 S BGPDIVI=+Y
CLIN ;
 S BGPCLN="",BGPQUIT=""
 S DIR(0)="S^A:ANY Clinic;S:One or more selected Clinics",DIR("A")="Include patients with Appointments to",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BGPQUIT=1 Q
 S BGPCLN=Y
 I BGPCLN="A" K BGPCLN Q
 ;get which clinics
 K BGPCLN
CLIN1 ;
 W ! S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select CLINIC: "
 S DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC
 I Y=-1,'$D(BGPCLN) G CLIN
 I X="^" G CLIN
 I Y="",$D(BGPCLN) Q
 I Y=-1,$D(BGPCLN) Q
 I X="",'$D(BGPCLN) G CLIN
 S BGPCLN(+Y)=""
 G CLIN1
GETPAT ;
 K BGPPATS
GETPAT1 ;
 S BGPQUIT="",BGPDIVI=""
 K DIC
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1,'$D(BGPPATS) S BGPQUIT=1 Q
 S BGPPATS(+Y)=""
 Q
SELPT ;
 K BGPPATS
 S BGPSMI=0
 F  D  Q:U[X
 .S DIR(0)="FOU",DIR("A")="Select patient(s)"
 .S DIR("?",1)="     Enter a patient's HRN or name (HORSECHIEF,JOHN DOE or HORSECHIEF,JOHN).",DIR("?",2)=""
 .S DIR("?",3)="     A template can also be selected by typing a ""["" followed by",DIR("?",4)="     the template name."
 .S DIR("?",5)="",DIR("?")="     ""[??"" will list your templates.",DIR("??")="^D LIST^BGP0DPAP"
 .D ^DIR K DIR
 .S:X[U X=U
 .I $E(X)="[" D  Q
 .. S X=$E(X,2,$L(X))
 .. K DIC S DIC=.401,DIC(0)=$S(X="":"AEMQ",1:"EMQ"),DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001),($P(^(0),U,5)=$G(DUZ))!(DUZ(0)=""@"")" D ^DIC
 .. I Y>0 D
 ... S BGPPATS=0,Y=+Y F BGPMJ=0:1 S BGPPATS=$O(^DIBT(Y,1,BGPPATS)) Q:'BGPPATS  S BGPSMI=BGPSMI+1,BGPPATS(BGPSMI)=BGPPATS
 ... W !,BGPMJ,$S(BGPMJ=1:" entry",1:" entries")," added."
 .K DIC S DIC=9000001,DIC(0)="EQM" D ^DIC
 .I Y>0 S BGPPATS=+Y,BGPSMI=BGPSMI+1,BGPPATS(BGPSMI)=BGPPATS
 W !
 I X=U K BGPPATS W !,"All selections cancelled!"
 I '$O(BGPPATS("")) W !,"No patients selected." S BGPQUIT=1 Q
 Q
 ;
BDMG(BGPBD,BGPED,BGPCLN) ;EP - GUI DMS Entry Point
 ;cmi/anch/maw added 10/19/2004
 S BGPSD=$$FMADD^XLFDT(BGPBD,-1)_".9999"
 S BGPGUI=1
 N BGPOPT,BGPNOW,BGPIEN  ;maw
 S BGPOPT="List Patients on a Register w/an Appointment"
 S BGPRTYPE=1,BGP0RPTH="",BGPCPPL=1,BGPINDT="G",BGP0GPU=1
 D NOW^%DTC
 S BGPNOW=$G(%)
 K DD,D0,DIC
 S X=DUZ_$$NOW^XLFDT
 S DIC("DR")=".02////"_DUZ_";.03////"_BGPNOW_";.06///"_$G(BGPOPT)_";.07////R"
 S DIC="^BGPGUIT(",DIC(0)="L",DIADD=1,DLAYGO=9001004.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BGPIEN=-1 Q
 S BGPIEN=+Y
 S BDMGIEN=BGPIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BGP0DPA9",ZTDESC="GUI CN GRPA APPT" D ^%ZTLOAD
 D EOJ
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"BGP0DPA")
 S IOM=80
 D GUIR^XBLM("PRINT^BGP0DPA9","^TMP($J,""BGP0DPA"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BGP0DPA",X)) Q:X'=+X  D
 .S BGPDATA=^TMP($J,"BGP0DPA",X)
 .I BGPDATA="ZZZZZZZ" S BGPDATA=$C(12)
 .S ^BGPGUIT(BGPIEN,11,X,0)=BGPDATA,C=C+1
 S ^BGPGUIT(BGPIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BGPIEN,DIK="^BGPGUIT(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BGP0DPA")
 S ZTREQ="@"
 Q
 ;
GUIECP ;EP
 K ^TMP($J,"BGP0DPA")
 S IOM=80
 D GUIR^XBLM("CPPRINT^BGP0DPA9","^TMP($J,""BGP0DPA"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BGP0DPA",X)) Q:X'=+X  D
 .S BGPDATA=^TMP($J,"BGP0DPA",X)
 .I BGPDATA="ZZZZZZZ" S BGPDATA=$C(12)
 .S ^BGPGUIT(BGPIEN,11,X,0)=BGPDATA,C=C+1
 S ^BGPGUIT(BGPIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BGPIEN,DIK="^BGPGUIT(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BGP0DPA")
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S BGPNOW=$G(%)
 S DIE="^BGPGUIT(",DA=BGPIEN,DR=".04////"_BGPNOW_";.06////C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
PROC ;EP
 D JRNL^BGP0UTL
 S BGPGPRAJ=$J,BGPGPRAH=$H
 S BGPCHWC=0
 S BGPCHSO=$P($G(^BGPSITE(DUZ(2),0)),U,6)
 ;calculate 3 years before end of each time frame
 S BGP3YE=$$FMADD^XLFDT(BGPED,-1096)
 K ^XTMP("BGP0DPA",BGPGPRAJ,BGPGPRAH)
 S ^XTMP("BGP0DPA",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PTS WITH GPRA DATA"
 K BGPAPPT,BGPAPPTS
 S BGPTA=0
 I BGPRT1="A" D  Q
 .S BGPSOX=0 F  S BGPSOX=$O(BGPPATS(BGPSOX)) Q:BGPSOX'=+BGPSOX  D
 ..S DFN=BGPPATS(BGPSOX)
 ..Q:$P($G(^DPT(DFN,0)),U)["DEMO,PATIENT"
 ..I $P($G(^BGPSITE(DUZ(2),0)),U,12) Q:$D(^DIBT($P(^BGPSITE(DUZ(2),0),U,12),1,DFN))
 ..S BGPIISO=1,BGPISST="A" D PROCCY^BGP0D1
 .Q
 S BGPSD=$$FMADD^XLFDT(BGPABD,-1)
 S BGPOD=BGPSD F  S BGPOD=$$FMADD^XLFDT(BGPOD,1) Q:BGPOD>BGPAED  D
 .K BGPAPPT
 .S BGPCLN=$S('$O(BGPCLN(0)):"ALL",1:"")
 .S BGPARRAY="BGPAPPT("  ;maw
 .;S BGPARRAY="^TMP(""BGPAPPT"",$J,"
 .I BGPRT1="D" S BGPCLN("DEV")=BGPDIVI
 .D LIST^BSDAPI2(BGPOD,"W",.BGPCLN,BGPARRAY)
 .S X=0 F  S X=$O(BGPAPPT(X)) Q:X'=+X  D  ;maw
 ..;S X=0 F  S X=$O(^TMP("BGPAPPT",$J,X)) Q:X'=+X  D  ;maw
 ..S Y=$P(BGPAPPT(X),U)  ;maw
 ..;S Y=$P(^TMP("BGPAPPT",$J,X),U)  ;maw
 ..I BGPRT1="P" I Y,'$D(BGPPATS(Y)) Q  ;if patients only want that set of patients
 ..I Y Q:$P($G(^DPT(Y,0)),U)["DEMO,PATIENT"
 ..I $P($G(^BGPSITE(DUZ(2),0)),U,12) Q:$D(^DIBT($P(^BGPSITE(DUZ(2),0),U,12),1,Y))
 ..S BGPTA=BGPTA+1,BGPAPPTS(BGPTA)=BGPAPPT(X)  ;maw
 ..;S BGPTA=BGPTA+1,^TMP("BGPAPPTS",$J,BGPTA)=^TMP("BGPAPPT",$J,X)  ;maw
 .Q
 S BGPSOX=0 F  S BGPSOX=$O(BGPAPPTS(BGPSOX)) Q:BGPSOX'=+BGPSOX  D   ;maw
 .;S BGPSOX=0 F  S BGPSOX=$O(^TMP("BGPAPPTS",$J,BGPSOX)) Q:BGPSOX'=+BGPSOX  D  ;maw
 .S DFN=$P(BGPAPPTS(BGPSOX),U,1)  ;maw
 .;S DFN=$P(^TMP("BGPAPPTS",$J,BGPSOX),U)  ;maw
 .Q:$P($G(^DPT(DFN,0)),U,1)["DEMO,PATIENT"
 .I $P($G(^BGPSITE(DUZ(2),0)),U,12) Q:$D(^DIBT($P(^BGPSITE(DUZ(2),0),U,12),1,DFN))
 .S BGPIISO=1,BGPISST=BGPRT1,BGPISSO=1 D PROCCY^BGP0D1
 .Q
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 K DIR
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
COVPAGE ;EP - called from option to display the cover page
 W !!,"This option is used to print out the denominator definitions"
 W !,"used in the GPRA Measures Forecast Patient List.",!!
ZISCP ;
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D EOJ Q
 ;
 I $D(IO("Q")) G TSKMNCP
 ;
CPPRINT ;EP - called from xbdbque
 U IO
 I $D(ZTQUEUED) S ZTREQ="@"
 S BGPPG=0
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 I $G(BGPGUI) S IOSL=55  ;cmi/maw added 1/14/2009
 D CPHEADER
 S BGPGYR=2010,BGPGYR=$O(^BGPCTRL("B",BGPGYR,0))
 S BGPX=0 F  S BGPX=$O(^BGPCTRL(BGPGYR,39,BGPX)) Q:BGPX'=+BGPX  D
 .I $Y>(IOSL-2) D CPHEADER Q:$D(BGPQ)
 .W !,^BGPCTRL(BGPGYR,39,BGPX,0)
 D CPDONE
 Q
CPHEADER ;EP
 G:'BGPPG CPHEAD1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQ="" Q
CPHEAD1 ;
 W:$D(IOF) @IOF
 S BGPPG=BGPPG+1
 I $G(BGPGUI),BGPPG'=1 W !,"ZZZZZZZ"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPPG,!
 Q
CPDONE ;
 K DIR
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K BGPTS,BGPS,BGPM,BGPET,BGPX,BGPGPYR
 Q
TSKMNCP ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="CPPRINT^BGP0DPA",ZTDTH="",ZTDESC="CRS 10 SCHED REPORT DENOM" D ^%ZTLOAD D EOJ Q
 Q
