BDMDR6 ; IHS/CMI/LAB - patients w/o dm on problem list ;
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
GETDATES ;
BD ;
 W !!!,"Enter the time frame to look for visits with a diabetes diagnosis.",!
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) R
 S BDMBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Visit Date:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATES
 I Y<BDMBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S BDMED=Y
 S X1=BDMBD,X2=-1 D C^%DTC S BDMSD=X
D ;
 ;how many
 S BDMND=""
 S DIR(0)="N^1:99:0",DIR("A")="How many diagnoses must the patient have had in that time period",DIR("B")="3" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETDATES
 S BDMND=Y
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
 S XBRP="PRINT^BDMDR6",XBRC="PROC^BDMDR6",XBRX="EXIT^BDMDR6",XBNS="BDM"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDMDR6"")"
 S XBRC="PROC^BDMDR6",XBRX="EXIT^BDMDR6",XBIOP=0 D ^XBDBQUE
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
 W !!,"This report will list patients who are not on the diabetes register ",!
 W "but who have had a visit with a diagnosis of diabetes in a date range",!
 W "specified by the user."
 W !
 Q
PROC ;EP - called from XBDBQUE
 S BDMJOB=$J,BDMBTH=$H
 K ^XTMP("BDMDR6",BDMJOB,BDMBTH)
 D XTMP^BDMOSUT("BDMDR6","DM NOT ON REGISTER")
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:$P($G(^DPT(DFN,0)),U,19)
 .Q:$D(^DPT(DFN,-9))
 .Q:$$DEMO^BDMUTL(DFN,$G(BDMDEMO))
 .Q:$$DOD^AUPNPAT(DFN)]""
 .Q:$P($G(^AUPNPAT(DFN,41,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0)),U,5)]""  ;IHS/CMI/GRL
 .Q:$P($G(^AUPNPAT(DFN,41,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0)),U,2)=""  ;IHS/CMI/GRL
 .I $D(^ACM(41,"AC",DFN,BDMREG)) Q  ;on register
 .S X=$$LASTDMDX(DFN,BDMBD,BDMED,BDMND)
 .I X S ^XTMP("BDMDR6",BDMJOB,BDMBTH,"PATIENTS",$$GET1^DIQ(2,DFN,.01),DFN)=""
 Q
PRINT ;EP - called from xbdbque
 S BDMIOSL=$S($G(BDMGUI):55,1:IOSL)
 S BDM80D="-------------------------------------------------------------------------------"
 S BDMPG=0 D HEAD
 I '$D(^XTMP("BDMDR6",BDMJOB,BDMBTH)) W !!,"NO PATIENTS TO REPORT" G DONE
 S BDMNAME="" K BDMQ
 F  S BDMNAME=$O(^XTMP("BDMDR6",BDMJOB,BDMBTH,"PATIENTS",BDMNAME)) Q:BDMNAME=""!($D(BDMQ))  D
 .S DFN="" F  S DFN=$O(^XTMP("BDMDR6",BDMJOB,BDMBTH,"PATIENTS",BDMNAME,DFN)) Q:DFN=""!($D(BDMQ))  S BDMX=^XTMP("BDMDR6",BDMJOB,BDMBTH,"PATIENTS",BDMNAME,DFN) D
 ..I $Y>(BDMIOSL-4) D HEAD Q:$D(BDMQ)
 ..W !,$E(BDMNAME,1,20),?22,$$HRN^AUPNPAT(DFN,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2))),?29,$$DATE^BDMS9B1($$DOB^AUPNPAT(DFN))
 ..W ?40,$E($$COMMRES^AUPNPAT(DFN,"E"),1,10)
 ..S V=$$LASTV(DFN)
 ..W ?53,$$DATE($P(V,U,1))
 ..W ?63,$$LBLK^BDMUTL($$NUMDXS(DFN,BDMBD,BDMED),5)
 ..W ?70,$$DATE($$LASTDMDX(DFN,$$DOB^AUPNPAT(DFN),DT))
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("BDMDR6",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
HEAD I 'BDMPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",BDMPG,!
 W ?(80-$L($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U))/2),$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),!
 W $$CTR("Patients NOT on the "_$P(^ACM(41.1,BDMREG,0),U)_" Register",80),!
 W $$CTR("with at least "_BDMND_" visits with a DX of Diabetes between ",80),!
 W $$CTR($$FMTE^XLFDT(BDMBD)_" and "_$$FMTE^XLFDT(BDMED),80),!
PIH W !,"PATIENT NAME",?22,"HRN",?29,"DOB",?40,"COMMUNITY",?53,"LAST VISIT",?64,"# DM",?70,"LAST DM",!,?64,"DXS",?70,"DX",!,BDM80D
 Q
NUMDXS(P,BD,ED) ;
 I '$G(P) Q ""
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^ALL DX [SURVEILLANCE DIABETES;DURING "_BD_"-"_ED S E=$$START1^APCLDF(X,Y)
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
LASTDMDX(P,BDATE,EDATE,N) ;
 I '$G(P) Q ""
 I '$G(N) S N=1
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^LAST "_N_" DX [SURVEILLANCE DIABETES;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(BDM(N)) Q $P(BDM(N),U)
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
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMDR6",ZTDESC="GUI DM PTS NO DX PL" D ^%ZTLOAD
 D EXIT
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"BDMDR6")
 S IOM=80
 D GUIR^XBLM("PRINT^BDMDR6","^TMP($J,""BDMDR6"",")
  S X=0,C=0 F  S X=$O(^TMP($J,"BDMDR6",X)) Q:X'=+X  D
 .S BDMDATA=^TMP($J,"BDMDR6",X)
 .I BDMDATA="ZZZZZZZ" S BDMDATA=$C(12)
 .S ^BDMGUI(BDMIEN,11,X,0)=BDMDATA,C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BDMDR6")
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
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
