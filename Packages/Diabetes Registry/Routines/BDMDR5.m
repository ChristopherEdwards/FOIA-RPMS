BDMDR5 ; IHS/CMI/LAB - patients w/o dm on problem list ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2,3,8,9**;JUN 14, 2007;Build 78
 ;
 ;
START ;
 D INFORM
 D EXIT
R ;
 S BDMREG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." D EXIT Q
 S BDMREG=+Y
STAT ;get status
 W !!,"Select the Patient Status for this report"
 S BDMSTAT=""
 K DIR
 S DIR(0)="S^"_$P(^DD(9002241,1,0),U,3)_";0:All Register Patients",DIR("A")="Which Status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G R
 I Y=0 S BDMSTAT="" G CLINIC
 S BDMSTAT=Y
CLINIC ;
 W !!,"Enter the list of clinics that you have determined to be primary care clinics."
 W !,"You can enter them 1 at a time or enter a taxonomy using the '[' notation."
 K BDMCLIN
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA
 D PEP^AMQQGTX0(+Y,"BDMCLIN(")
 I '$D(BDMCLIN) W !,"NO CLINICS SELECTED" K BDMCLIN G STAT
 I $D(BDMCLIN("*")) W !,"ALL (ANY) CLINIC WILL BE INCLUDED" K BDMCLIN
GETDATES ;
BD ;
 W !!!,"Enter the time frame to look for visits.",! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) CLINIC
 S BDMBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Visit Date:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATES
 I Y<BDMBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S BDMED=Y
 S X1=BDMBD,X2=-1 D C^%DTC S BDMSD=X
ZIS ;
 S BDMTEMP=""
 S DIR(0)="S^P:PRINT the List;B:BROWSE the List on the Screen",DIR("A")="Output Type",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETDATES
 S BDMTEMP=Y
 ;call to XBDBQUE
DEMO ;
 D DEMOCHK^BDMUTL(.BDMDEMO)
 I BDMDEMO=-1 D EXIT Q
 I BDMTEMP="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BDMDR5",XBRC="PROC^BDMDR5",XBRX="EXIT^BDMDR5",XBNS="BDM"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDMDR5"")"
 S XBRC="PROC^BDMDR5",XBRX="EXIT^BDMDR5",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;clean up and exit
 I '$D(BDMGUI) D EN^XBVK("BDM")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will list patients who are on the diabetes register who have not",!
 W "had a visit to a set of primary care clinics in a date range defined by the ",!,"user.",!
 W "The report provides a way to identify patients who could possibly be inactivated",!
 W "in the register.",!!
 Q
PROC ;EP - called from XBDBQUE
 S BDMJOB=$J,BDMBTH=$H
 K ^XTMP("BDMDR5",BDMJOB,BDMBTH)
 D XTMP^BDMOSUT("BDMDR5","DM ON REGISTER NOT ACTIVE")
 S BDMP=0 F  S BDMP=$O(^ACM(41,"B",BDMREG,BDMP)) Q:BDMP'=+BDMP  D
 .Q:'$D(^ACM(41,BDMP))
 .S BDMPAT=$P(^ACM(41,BDMP,0),U,2)
 .Q:$$DEMO^BDMUTL(BDMPAT,$G(BDMDEMO))
 .I $G(BDMSTAT)]"",$P($G(^ACM(41,BDMP,"DT")),U,1)'=BDMSTAT Q
 .;LOOP VISITS UNTIL FIND ONE THAT FITS DEFINITION
 .K BDMV
 .D ALLV^APCLAPIU(BDMPAT,BDMBD,BDMED,"BDMV")
 .S BDMG=0,BDMX=0
 .F  S BDMX=$O(BDMV(BDMX)) Q:BDMX'=+BDMX!(BDMG)  D
 ..S BDMVST=$P(BDMV(BDMX),U,5)
 ..S BDMC=$$GET1^DIQ(9000010,BDMVST,.08,"I")
 ..Q:'BDMC
 ..I $D(BDMCLIN),'$D(BDMCLIN(BDMC)) Q  ;not a clinic of interest
 ..S BDMG=1
 .I 'BDMG S ^XTMP("BDMDR5",BDMJOB,BDMBTH,"PATIENTS",$$GET1^DIQ(2,BDMPAT,.01),BDMPAT)=""
 Q
PRINT ;EP - called from xbdbque
 S BDMIOSL=$S($G(BDMGUI):55,1:IOSL)
 S BDM80D="-------------------------------------------------------------------------------"
 S BDMPG=0 D HEAD
 I '$D(^XTMP("BDMDR5",BDMJOB,BDMBTH)) W !!,"NO PATIENTS TO REPORT" G DONE
 S BDMNAME="" K BDMQ
 F  S BDMNAME=$O(^XTMP("BDMDR5",BDMJOB,BDMBTH,"PATIENTS",BDMNAME)) Q:BDMNAME=""!($D(BDMQ))  D
 .S DFN="" F  S DFN=$O(^XTMP("BDMDR5",BDMJOB,BDMBTH,"PATIENTS",BDMNAME,DFN)) Q:DFN=""!($D(BDMQ))  S BDMX=^XTMP("BDMDR5",BDMJOB,BDMBTH,"PATIENTS",BDMNAME,DFN) D
 ..I $Y>(BDMIOSL-4) D HEAD Q:$D(BDMQ)
 ..W !,$E(BDMNAME,1,20),?22,$$HRN^AUPNPAT(DFN,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2))),?29,$E($$RSTAT(BDMREG,DFN),1,8)
 ..W ?38,$E($$CM(BDMREG,DFN),1,10)
 ..S V=$$LASTV(DFN)
 ..W ?49,$$DATE^BDMS9B1($P(V,U,1))
 ..W ?61,$$LBLK^BDMUTL($$NUMDXS(DFN),5)
 ..W ?68,$$DATE^BDMS9B1($$LASTDMDX(DFN))
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("BDMDR5",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
HEAD I 'BDMPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",BDMPG,!
 W ?(80-$L($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U))/2),$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),!
 W $$CTR("Patients on the "_$P(^ACM(41.1,BDMREG,0),U)_" Register",80),!
 W $$CTR("without a visit between "_$$FMTE^XLFDT(BDMBD)_" and "_$$FMTE^XLFDT(BDMED),80),!
PIH W !,"PATIENT NAME",?22,"HRN",?29,"STATUS",?38,"CASE ",?49,"LAST VISIT",?61,"# DM",?68,"LAST DM DX",!,?38,"MANAGER",?61,"DXS",!,BDM80D
 Q
NUMDXS(P) ;
 I '$G(P) Q ""
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^ALL DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y)
 S (X,Y)=0
 F  S X=$O(BDM(X)) Q:X'=+X  S Y=Y+1
 Q Y
LASTV(P) ;
 NEW X,Y,Z,V,D
 S V=""
 S D=0 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D'=+D!(V)  D
 .S X=0 F  S X=$O(^AUPNVSIT("AA",P,D,X)) Q:X'=+X!(V)  D
 ..Q:'$D(^AUPNVSIT(X,0))
 ..Q:$P(^AUPNVSIT(X,0),U,11)  ;deleted
 ..Q:'$P(^AUPNVSIT(X,0),U,9)  ;ZERO DEP
 ..Q:"CTNEDX"[$P(^AUPNVSIT(X,0),U,7)
 ..S V=X
 I V="" Q ""
 Q $$GET1^DIQ(9000010,V,.01,"I")_U_$$GET1^DIQ(9000010,V,.08,"I")
LASTDMDX(P) ;
 I '$G(P) Q ""
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^LAST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) Q $P(BDM(1),U)
 Q ""
CM(REG,PAT) ;
 NEW X
 S X=$G(^ACM(41,"AC",PAT,REG))
 I X="" Q ""
 Q $$GET1^DIQ(9002241,X,6)
RSTAT(REG,PAT) ;
 NEW X
 S X=$G(^ACM(41,"AC",PAT,REG))
 I X="" Q ""
 Q $$GET1^DIQ(9002241,X,1)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
TEST ;
 D BDMG("R",1,"A")
 Q
BDMG(BDMTR,BDMREG,BDMSTAT,BDMND,BDMLDAT) ;EP - GUI DMS Entry Point
 S BDMND=$G(BDMND)
 S BDMGUI=1
 S BDMLDAT=$G(BDMLDAT)
 NEW BDMNOW,BDMOPT,BDMIEN
 S BDMOPT="Patients w/no Diagnosis of DM on Problem Lis"
 D NOW^%DTC
 S BDMNOW=$G(%)
 K DD,DO,DIC
 S X=DUZ_BDMNOW
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
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMDR5",ZTDESC="GUI DM PTS NO DX PL" D ^%ZTLOAD
 D EXIT
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"BDMDR5")
 S IOM=80
 D GUIR^XBLM("PRINT^BDMDR5","^TMP($J,""BDMDR5"",")
  S X=0,C=0 F  S X=$O(^TMP($J,"BDMDR5",X)) Q:X'=+X  D
 .S BDMDATA=^TMP($J,"BDMDR5",X)
 .I BDMDATA="ZZZZZZZ" S BDMDATA=$C(12)
 .S ^BDMGUI(BDMIEN,11,X,0)=BDMDATA,C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BDMDR5")
 D EXIT
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
