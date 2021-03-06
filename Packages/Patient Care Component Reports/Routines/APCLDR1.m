APCLDR1 ; IHS/CMI/LAB - patients w/o dm on problem list ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
 D INFORM
 D EXIT
 D GETINFO
 I $D(APCLQUIT) D EXIT Q
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will list patients who do not have Diabetes on their Problem List ",!,"but who are on a Diabetes Register or who have had at least N diagnoses of ",!,"diabetes.",!!
 Q
 ;
GETINFO ;
 S (APCLTR,APCLREG,APCLSTAT,APCLND)=""
 S DIR(0)="S^R:Those who are members of a Register;D:Those with at least N Diabetes Diagnoses",DIR("A")="List which subset of patients",DIR("B")="R" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLQUIT="" Q
 S APCLTR=Y
 D @Y
 I $D(APCLQUIT) D EXIT Q
 D ZIS
 Q
R ;
 S APCLREG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S APCLQUIT="" Q
 S APCLREG=+Y
 ;get status
 S APCLSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G R
 I Y=0 S APCLSTAT="" Q
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G R
 S APCLSTAT=Y
 Q
D ;
 ;how many
 S APCLND=""
 S DIR(0)="N^1:999:0",DIR("A")="How many diagnoses must the patient have had",DIR("B")="3" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLQUIT="" Q
 S APCLND=Y
DATE ;
 W !!,"If you are interested in restricting your list to only those patients",!,"whose most recent Diabetes diagnosis is since a certain date, enter that date.",!
 W "If not, press enter or return to list all patients with at least ",APCLND," diagnoses.",!
 S DIR(0)="DO^::EP",DIR("A")="Enter Date" KILL DA D ^DIR KILL DIR
 I $D(DUOUT) G D
 I X="^" G D
 S APCLLDAT=Y
 Q
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G DATE
 S XBRP="PRINT^APCLDR1",XBRC="PROC^APCLDR1",XBRX="EXIT^APCLDR1",XBNS="APCL"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;clean up and exit
 D EN^XBVK("APCL")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
PROC ;EP - called from XBDBQUE
 S APCLJOB=$J,APCLBTH=$H
 K ^XTMP("APCLDR1",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLDR1","DM NOT ON PROBLEM LIST")
 I APCLTR="R" D REGPROC Q
 I APCLTR="D" D DXPROC Q
 Q
DXPROC ;
 ;get last dm dx, if less than last date, Q
 ;if null Q
 ;get # of dxs, if less than apclnd q
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D CHK1SET
 Q
CHK1SET ;
 Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 Q:$$DOD^AUPNPAT(DFN)]""
 Q:$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,5)]""  ;IHS/CMI/GRL
 Q:$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)=""  ;IHS/CMI/GRL
 I $$DMPROB(DFN) Q
 S APCLN=$$LASTDMDX(DFN)
 I APCLN="" Q
 I APCLN<APCLLDAT Q
 S APCLN1=$$NUMDXS(DFN)
 I APCLN1<APCLND Q
 S ^XTMP("APCLDR1",APCLJOB,APCLBTH,"PATIENTS",$P(^DPT(DFN,0),U),DFN)=APCLN_U_APCLN1
 Q
LASTDMDX(P) ;
 I '$G(P) Q ""
 NEW X,E,APCL,Y
 S Y="APCL("
 S X=P_"^LAST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y)
 I $D(APCL(1)) Q $P(APCL(1),U)
 Q ""
 ;
NUMDXS(P) ;
 I '$G(P) Q ""
 NEW X,E,APCL,Y
 S Y="APCL("
 S X=P_"^ALL DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y)
 S (X,Y)=0
 F  S X=$O(APCL(X)) Q:X'=+X  S Y=Y+1
 Q Y
 ;
REGPROC ;
 ;$o through register, check status, if no DM on problem list
 ;set xtmp
 ;gather up patients from register in ^XTMP
 S X=0 F  S X=$O(^ACM(41,"B",APCLREG,X)) Q:X'=+X  D
 .I APCLSTAT]"",$P($G(^ACM(41,X,"DT")),U,1)=APCLSTAT S DFN=$P(^ACM(41,X,0),U,2) D CHKSET Q
 .I APCLSTAT="" S DFN=$P(^ACM(41,X,0),U,2) D CHKSET Q
 .Q
 Q
CHKSET ;
 Q:$$DOD^AUPNPAT(DFN)]""
 Q:$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,5)]""   ;IHS/CMI/GRL
 Q:$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)=""   ;IHS/CMI/GRL
 I $$DMPROB(DFN) Q
 S ^XTMP("APCLDR1",APCLJOB,APCLBTH,"PATIENTS",$P(^DPT(DFN,0),U),DFN)=$$LASTDMDX(DFN)_U_$$NUMDXS(DFN)
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
 S APCLIOSL=$S($G(APCLGUI):55,1:IOSL)
 S APCL80D="-------------------------------------------------------------------------------"
 S APCLPG=0 D HEAD
 I '$D(^XTMP("APCLDR1",APCLJOB,APCLBTH)) W !!,"NO PATIENTS TO REPORT" G DONE
 S APCLNAME="" K APCLQ
 F  S APCLNAME=$O(^XTMP("APCLDR1",APCLJOB,APCLBTH,"PATIENTS",APCLNAME)) Q:APCLNAME=""!($D(APCLQ))  D
 .S DFN="" F  S DFN=$O(^XTMP("APCLDR1",APCLJOB,APCLBTH,"PATIENTS",APCLNAME,DFN)) Q:DFN=""!($D(APCLQ))  S APCLX=^XTMP("APCLDR1",APCLJOB,APCLBTH,"PATIENTS",APCLNAME,DFN) D
 ..I $Y>(APCLIOSL-4) D HEAD Q:$D(APCLQ)
 ..W !,$E(APCLNAME,1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?29,$$DOB^AUPNPAT(DFN,"E"),?43,$P(^DPT(DFN,0),U,2),?47,$$FMTE^XLFDT($P(APCLX,U)),?63,$P(APCLX,U,2)
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("APCLDR1",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 I $G(APCLGUI),APCLPG'=1 W !,"ZZZZZZZ"
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",APCLPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("PATIENTS WITH NO DIAGNOSIS OF DIABETES ON PROBLEM LIST",80),!
 I APCLTR="R" W $$CTR("Patients on the "_$P(^ACM(41.1,APCLREG,0),U)_" Register",80),!
 I APCLTR="D" W $$CTR("Patients w/at least "_APCLND_" diabetes diagnoses",80),!
PIH W !,"PATIENT NAME",?22,"HRN",?29,"DOB",?47,"LAST DM DX",?63,"# OF DM DXS",!,APCL80D
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
TEST ;
 D BDMG("R",1,"A")
 Q
BDMG(APCLTR,APCLREG,APCLSTAT,APCLND,APCLLDAT) ;EP - GUI DMS Entry Point
 S APCLND=$G(APCLND)
 S APCLGUI=1
 S APCLLDAT=$G(APCLLDAT)
 NEW APCLNOW,APCLOPT,APCLIEN
 S APCLOPT="Patients w/no Diagnosis of DM on Problem Lis"
 D NOW^%DTC
 S APCLNOW=$G(%)
 K DD,DO,DIC
 S X=DUZ_APCLNOW
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
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^APCLDR1",ZTDESC="GUI DM PTS NO DX PL" D ^%ZTLOAD
 D EXIT
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"APCLDR1")
 S IOM=80
 D GUIR^XBLM("PRINT^APCLDR1","^TMP($J,""APCLDR1"",")
  S X=0,C=0 F  S X=$O(^TMP($J,"APCLDR1",X)) Q:X'=+X  D
 .S APCLDATA=^TMP($J,"APCLDR1",X)
 .I APCLDATA="ZZZZZZZ" S APCLDATA=$C(12)
 .S ^APCLGUIR(APCLIEN,11,X,0)=APCLDATA,C=C+1
 S ^APCLGUIR(APCLIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=APCLIEN,DIK="^APCLGUIR(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"APCLDR1")
 D EXIT
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
