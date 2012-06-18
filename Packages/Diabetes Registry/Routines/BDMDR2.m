BDMDR2 ; IHS/CMI/LAB - patients w/o dm on problem list ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2,3**;JUN 14, 2007
 ;
 ;
START ;
 D INFORM
 D EXIT
 D GETINFO
 I $D(BDMQUIT) D EXIT Q
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will list patients who are on the Diabetes Register who do not",!,"have a date of diagnosis recorded in either the Register or on the problem list.",!!
 Q
 ;
GETINFO ;
 S (BDMTR,BDMREG,BDMSTAT,BDMND)=""
 D R
 S BDMTR="R" I $D(BDMQUIT) D EXIT Q
 D ZIS
 Q
R ;
 S BDMREG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S BDMQUIT="" Q
 S BDMREG=+Y
 ;get status
 S BDMSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G R
 I Y=0 S BDMSTAT="" Q
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G R
 S BDMSTAT=Y
 Q
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^BDMUTL(.BDMDEMO)
 I BDMDEMO=-1 G R
 S XBRP="PRINT^BDMDR2",XBRC="PROC^BDMDR2",XBRX="EXIT^BDMDR2",XBNS="BDM"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;clean up and exit
 I '$D(BDMGUI) D EN^XBVK("BDM")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
PROC ;EP - called from XBDBQUE
 S BDMJOB=$J,BDMBTH=$H
 K ^XTMP("BDMDR2",BDMJOB,BDMBTH)
 D XTMP^BDMOSUT("BDMDR2","DM NOT ON PROBLEM LIST")
 I BDMTR="R" D REGPROC Q
 Q
LASTDMDX(P) ;
 I '$G(P) Q ""
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^LAST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) Q $P(BDM(1),U)
 Q ""
 ;
NUMDXS(P) ;
 I '$G(P) Q ""
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^ALL DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y)
 S (X,Y)=0
 F  S X=$O(BDM(X)) Q:X'=+X  S Y=Y+1
 Q Y
 ;
REGPROC ;
 ;$o through register, check status, if no DM on problem list
 ;set xtmp
 ;gather up patients from register in ^XTMP
 S X=0 F  S X=$O(^ACM(41,"B",BDMREG,X)) Q:X'=+X  D
 .I BDMSTAT]"",$P($G(^ACM(41,X,"DT")),U,1)=BDMSTAT S DFN=$P(^ACM(41,X,0),U,2) D CHKSET Q
 .I BDMSTAT="" S DFN=$P(^ACM(41,X,0),U,2) D CHKSET Q
 .Q
 Q
CHKSET ;
 Q:$$DEMO^BDMUTL(DFN,$G(BDMDEMO))
 I $$DODX^BDMD206(DFN,BDMREG,"E")]"" Q
 Q:$$DOD^AUPNPAT(DFN)]""
 Q:$P($G(^AUPNPAT(DFN,41,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0)),U,5)]""  ;IHS/CMI/GRL
 Q:$P($G(^AUPNPAT(DFN,41,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0)),U,2)=""  ;IHS/CMI/GRL
 S BDMPLDX=$$DMPROB(DFN)
 S ^XTMP("BDMDR2",BDMJOB,BDMBTH,"PATIENTS",$P(^DPT(DFN,0),U),DFN)=$$LASTDMDX(DFN)_U_$$NUMDXS(DFN)_U_BDMPLDX
 Q
DMPROB(P) ;is DM on problem list 1=yes 0=no
 I '$G(P) Q 0
 I '$D(^AUPNPROB("AC",P)) Q 0
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW G,D,Y,I S D="",(Y,G)=0 F  S Y=$O(^AUPNPROB("AC",P,Y)) Q:Y'=+Y!(G)  D
 .S I=$P(^AUPNPROB(Y,0),U)
 .I $$ICD^ATXCHK(I,T,9) S G=1
 .Q
 Q G
PRINT ;EP - called from xbdbque
 S BDM80D="-------------------------------------------------------------------------------"
 S BDMPG=0,BDMIOSL=$S($G(BDMGUI):55,1:IOSL)
 D HEAD
 I '$D(^XTMP("BDMDR2",BDMJOB,BDMBTH)) W !!,"NO PATIENTS TO REPORT" G DONE
 S BDMNAME="" K BDMQ
 F  S BDMNAME=$O(^XTMP("BDMDR2",BDMJOB,BDMBTH,"PATIENTS",BDMNAME)) Q:BDMNAME=""!($D(BDMQ))  D
 .S DFN="" F  S DFN=$O(^XTMP("BDMDR2",BDMJOB,BDMBTH,"PATIENTS",BDMNAME,DFN)) Q:DFN=""!($D(BDMQ))  S BDMX=^XTMP("BDMDR2",BDMJOB,BDMBTH,"PATIENTS",BDMNAME,DFN) D
 ..I $Y>(BDMIOSL-4) D HEAD Q:$D(BDMQ)
 ..W !,$E(BDMNAME,1,20),?22,$$HRN^AUPNPAT(DFN,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2))),?29,$$DOB^AUPNPAT(DFN,"E"),?43,$P(^DPT(DFN,0),U,2),?47,$$FMTE^XLFDT($P(BDMX,U)),?63,$P(BDMX,U,2),?73,$S($P(BDMX,U,3):"YES",1:"NO")
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("BDMDR2",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
HEAD I 'BDMPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",BDMPG,!
 W ?(80-$L($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U))/2),$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),!
 W $$CTR("DIABETES REGISTER PATIENTS WITH NO RECORDED DATE OF ONSET OF DIABETES",80),!
 I BDMTR="R" W $$CTR("Patients on the "_$P(^ACM(41.1,BDMREG,0),U)_" Register",80),!
 I BDMTR="D" W $$CTR("Patients w/at least "_BDMND_" diabetes diagnoses",80),!
PIH W !,"PATIENT NAME",?22,"HRN",?29,"DOB",?47,"LAST DM DX",?63,"#DM DXS",?71,"DM ON PL",!,BDM80D
 Q
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
BDMGO(BDMTR,BDMREG,BDMSTAT) ;EP - GUI DMS Entry Point
 ;cmi/anch/maw added 10/19/2004
 S BDMGUI=1
 D PROC
 D GUIR^XBLM("PRINT^BDMDR2","^TMP($J,""BDMDR2"",")
 D EXIT
 Q
 ;
TEST ;
 D BDMG("R",1,"A")
 Q
BDMG(BDMTR,BDMREG,BDMSTAT) ;EP - GUI DMS Entry Point
 S BDMTR="R",BDMGUI=1
 NEW BDMNOW,BDMOPT,BDMIEN
 S BDMOPT="DM Register Pts w/no recorded DM Date of Onset"
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
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMDR2",ZTDESC="GUI DM PTS NO DX PL" D ^%ZTLOAD
 D EXIT
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"BDMDR2")
 S IOM=80
 D GUIR^XBLM("PRINT^BDMDR2","^TMP($J,""BDMDR2"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BDMDR2",X)) Q:X'=+X  D
 .S BDMDATA=^TMP($J,"BDMDR2",X)
 .I BDMDATA="ZZZZZZZ" S BDMDATA=$C(12)
 .S ^BDMGUI(BDMIEN,11,X,0)=BDMDATA,C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BDMDR2")
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
