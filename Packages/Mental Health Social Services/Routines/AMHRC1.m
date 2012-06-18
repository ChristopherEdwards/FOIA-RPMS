AMHRC1 ; IHS/CMI/LAB - ACTIVE CLIENT LIST - OPEN NOT SEEN IN N DAYS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "*******  CLIENTS WITH CASE OPEN DATE BUT NOT SEEN IN N DAYS)  *******",!!
 W "This report will produce a list of patients who have a case open date,",!,"no closed date, and have not been seen in N days.",!
 W "The user will determine the number of days to use.",!
 I '$D(^AMHSITE(DUZ(2),16,DUZ)) D
 .W !,"This report will only include Cases on which you are the documented"
 .W !,"provider.",!!
 D DBHUSRP^AMHUTIL,DBHUSR^AMHUTIL,PAUSE^AMHLEA
 ;
PROG ;
 D XIT
 S AMHPROG=""
 S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Run the Report for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) XIT
 I Y="A" G PROV
 S DIR(0)="9002011.58,.03",DIR("A")="Which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROG
 I X="" G PROG
 S AMHPROG=Y
PROV ;
 S AMHPROV=""
 S DIR(0)="S^A:Any Provider;O:One Provider",DIR("A")="Include cases opened by",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 I Y="A" G DAYS
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC
 K DIC,DA
 I Y=-1 G PROV
 S AMHPROV=+Y
DAYS ;
 S AMHDAYS=0
 S DIR(0)="N^1:99999:0",DIR("A")="Enter the number of days since the patient has been seen" K DA D ^DIR K DIR
 I $D(DIRUT) W !,"Bye..." D XIT Q
 I Y="" D XIT Q
 S AMHDAYS=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G DAYS
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="PROC^AMHRC1",XBRP="^AMHRC1P",XBNS="AMH",XBRX="XIT^AMHRC1"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("AMH")
 D KILL^AUPNPAT
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""^AMHRC1P"")"
 S XBNS="AMH",XBRC="PROC^AMHRC1",XBRX="XIT^AMHRC1",XBIOP=0 D ^XBDBQUE
 Q
PROC ;EP - entry point for processing
 S AMHPCNT=0,AMHCCNT=0
 S AMHJOB=$J,AMHBTH=$H,AMHCASE=0,AMHBT=$H,AMHCASE=0
 D XTMP^AMHUTIL("AMHRC1","BH - REPORT - OPEN NOT SEEN")
 F  S AMHCASE=$O(^AMHPCASE(AMHCASE)) Q:AMHCASE'=+AMHCASE  D PROC1
 S AMHET=$H
 K AMHCASE
 Q
PROC1 ;
 Q:'$$ALLOWCD^AMHLCD(DUZ,AMHCASE)
 Q:$P(^AMHPCASE(AMHCASE,0),U)=""
 I $P(^AMHPCASE(AMHCASE,0),U,2)="" Q
 I AMHPROG]"",$P(^AMHPCASE(AMHCASE,0),U,3)'=AMHPROG Q  ;not right program
 Q:$P(^AMHPCASE(AMHCASE,0),U,5)]""  ;closed date
 S DFN=$P(^AMHPCASE(AMHCASE,0),U,2)
 Q:'DFN
 Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 I AMHPROV,AMHPROV'=$P(^AMHPCASE(AMHCASE,0),U,8) Q
 S AMHSEEN=0 D CHKVISIT Q:AMHSEEN
 I '$D(^XTMP("AMHRP4",AMHJOB,AMHBTH,"PATIENTS",DFN)) S AMHPCNT=AMHPCNT+1,^XTMP("AMHRP4",AMHJOB,AMHBTH,"PATIENTS",DFN)=""
 S ^XTMP("AMHRC1",AMHJOB,AMHBTH,"CASES",$P(^DPT(DFN,0),U),DFN,AMHCASE)=AMHD,AMHCCNT=AMHCCNT+1
 Q
 ;
CHKVISIT ;chk for last visit date less than amhdays - set amhseen if seen
 S AMHD=""
 S AMHD=$$GETV(DFN)
 Q:AMHD=""
 I $$FMDIFF^XLFDT(DT,AMHD)>(AMHDAYS-1) Q
 S AMHSEEN=1
 Q
GETV(P) ;return null or patients last visit date
 NEW AMHR,D S AMHR="",G=""
 I '$D(^AMHREC("AE",P)) Q AMHR
 ;S D=$O(^AMHREC("AE",P,"")),AMHR=$O(^AMHREC("AE",P,D,"")) I AMHR]"" S AMHR=$P($P(^AMHREC(AMHR,0),U),".")
 S D=0 F  S D=$O(^AMHREC("AE",P,D)) Q:'D!(G)  D
 .S AMHR=0 F  S AMHR=$O(^AMHREC("AE",P,D,AMHR)) Q:AMHR'=+AMHR!(G)  D
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHR)
 ..S G=$P($P(^AMHREC(AMHR,0),U),".")
 Q G
