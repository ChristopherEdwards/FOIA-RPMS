AMHRC4 ; IHS/CMI/LAB - ACTIVE CLIENT LIST - OPEN NOT SEEN IN N DAYS 03 Jun 2009 12:08 PM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "*******  CLIENTS SEEN AT LEAST X TIMES WITH NO CASE OPEN DATE  *******",!!
 W "This report will produce a list of patients, in a date range specified"
 W !,"by the user, who have been seen a certain number of times but do not"
 W !,"have open cases.  The user, based on their program's standards"
 W !,"of care, specifies when a case is to be opened.  For example,"
 W !,"a case will be opened if a patient has been seen at least (3) times."
 W !
 ;
 I '$D(^AMHSITE(DUZ(2),16,DUZ)) D
 .W !,"This report will only include Cases on which you are the documented"
 .W !,"provider.",!!
 D DBHUSRP^AMHUTIL,DBHUSR^AMHUTIL,PAUSE^AMHLEA
DATES K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR G:Y<1 XIT S AMHBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR G:Y<1 XIT  S AMHED=Y
 ;
 I AMHED<AMHBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S AMHSD=$$FMADD^XLFDT(AMHBD,-1)_".9999"
PROG ;
 S AMHPROG=""
 ;S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Run the Report for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 ;G:$D(DIRUT) DATES
 ;I Y="A" G DAYS
 S DIR(0)="9002011,.02",DIR("A")="Run Report for which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) DATES
 I X="" G DATES
 S AMHPROG=Y
PROV ;
 S AMHPROV=""
 S DIR(0)="S^A:All Providers;O:One Provider",DIR("A")="Include visits to",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 I Y="A" G DAYS
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC
 K DIC,DA
 I Y=-1 G PROV
 S AMHPROV=+Y
DAYS ;
 S AMHDAYS=0
 S DIR(0)="NA^1:999:0",DIR("A")="Enter the number of visits (X number of visits with no case opened): " K DA D ^DIR K DIR
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
 S XBRC="PROC^AMHRC4",XBRP="PRINT^AMHRC4",XBNS="AMH",XBRX="XIT^AMHRC4"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("AMH")
 D KILL^AUPNPAT
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHRC4"")"
 S XBNS="AMH",XBRC="PROC^AMHRC4",XBRX="XIT^AMHRC4",XBIOP=0 D ^XBDBQUE
 Q
PROC ;EP - entry point for processing
 S AMHPCNT=0,AMHCCNT=0
 S AMHJOB=$J,AMHBTH=$H,AMHBT=$H
 D XTMP^AMHUTIL("AMHRC4","BH - REPORT - SEEN NOT OPEN")
 S AMHODAT=AMHSD F  S AMHODAT=$O(^AMHREC("B",AMHODAT)) Q:AMHODAT=""!((AMHODAT\1)>AMHED)  D PROC1
 S AMHET=$H
 K AMHCASE
 Q
PROC1 ;
 S AMHVIEN=0 F  S AMHVIEN=$O(^AMHREC("B",AMHODAT,AMHVIEN)) Q:AMHVIEN'=+AMHVIEN  D PROC2
 Q
PROC2 ;
 Q:'$D(^AMHREC(AMHVIEN,0))
 Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHVIEN)
 ;I AMHPROG]"",$P(^AMHREC(AMHVIEN,0),U,2)'=AMHPROG Q  ;not correct program visit
 S DFN=$P(^AMHREC(AMHVIEN,0),U,8)
 Q:'DFN  ;not patient record
 Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 I $D(^XTMP("AMHRC4",AMHJOB,AMHBTH,"PATIENTS PROCESSED",DFN)) Q  ;already processed this patient
 S X=$$VS(DFN,AMHBD,AMHED,AMHPROG,AMHPROV)  ;x=# of visits in date range
 Q:$P(X,U)<AMHDAYS  ;not enough visits
 ;now check for case open date
 S AMHLASTD=$P(X,U,2)
 S AMHLASTV=$P(X,U,3)
 S AMHCV=$P(X,U,1)
 S X=0,G=0 F  S X=$O(^AMHPCASE("C",DFN,X)) Q:X'=+X  D
 .Q:'$$ALLOWCD^AMHLCD(DUZ,X)
 .I $P(^AMHPCASE(X,0),U,5)]"",$P(^AMHPCASE(X,0),U,5)<AMHLASTD Q  ;closed before last visit date
 .S G=1  ;has case open
 .Q
 Q:G
 S ^XTMP("AMHRC4",AMHJOB,AMHBTH,"HITS",$P(^DPT(DFN,0),U),DFN)=AMHCV_U_AMHLASTV_U_AMHLASTD,AMHPCNT=AMHPCNT+1
 S ^XTMP("AMHRC4",AMHJOB,AMHBTH,"PATIENTS PROCESSED",DFN)=""
 Q
VS(P,BD,ED,R,W) ;
 I '$D(^AMHREC("C",P)) Q 0
 NEW S,X,Y,Z,C,A,B
 S C=0,Y="",Z=""
 S S=$$FMADD^XLFDT(BD,-1)_".9999"
 F  S S=$O(^AMHREC("AF",P,S)) Q:S=""!($P(S,".")>ED)  D
 .S X=0 F  S X=$O(^AMHREC("AF",P,S,X)) Q:X'=+X  D
 ..I $$NS(X) Q  ;don't count no shows
 ..I R]"",$P(^AMHREC(X,0),U,2)'=R Q
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,X)
 ..I W]"" D  Q:'G
 ...S G=0
 ...S A=0 F  S A=$O(^AMHRPROV("AD",X,A)) Q:A'=+A!(G)  I $P($G(^AMHRPROV(A,0)),U)=W S G=1
 ..S C=C+1,Y=S,Z=X ;Y is last date
 ..Q
 .Q
 Q C_U_Y_U_Z
NS(V) ;
 NEW H,I,J,K,DNKA
 S DNKA=0
 S H=0 F  S H=$O(^AMHRPRO("AD",V,H)) Q:H'=+H!(DNKA)  D
 .I $P(^AMHPROB($P(^AMHRPRO(H,0),U),0),U)=8 S DNKA=1 Q
 .I $P(^AMHPROB($P(^AMHRPRO(H,0),U),0),U)=8.1 S DNKA=1 Q
 .I $P(^AMHPROB($P(^AMHRPRO(H,0),U),0),U)=8.11 S DNKA=1 Q
 .I $P(^AMHPROB($P(^AMHRPRO(H,0),U),0),U)=8.2 S DNKA=1 Q
 .I $P(^AMHPROB($P(^AMHRPRO(H,0),U),0),U)=8.21 S DNKA=1 Q
 .I $P(^AMHPROB($P(^AMHRPRO(H,0),U),0),U)=8.3 S DNKA=1 Q
 .Q
 Q DNKA
PRINT ;
 S AMH80D="-------------------------------------------------------------------------------"
 S AMHPG=0 D HEAD
 I '$D(^XTMP("AMHRC4",AMHJOB,AMHBTH,"HITS")) W !!,"NO PATIENTS TO REPORT" G DONE
 S DFN="" K AMHQ
 S AMHNAME="" F  S AMHNAME=$O(^XTMP("AMHRC4",AMHJOB,AMHBTH,"HITS",AMHNAME)) Q:AMHNAME=""!($D(AMHQ))  D
 .S DFN=0 F  S DFN=$O(^XTMP("AMHRC4",AMHJOB,AMHBTH,"HITS",AMHNAME,DFN)) Q:DFN'=+DFN!($D(AMHQ))  D PRN
 G:$D(AMHQ) DONE
 W !!,"Total Number of Patients: ",AMHPCNT,!
DONE ;
 K ^XTMP("AMHRC4",AMHJOB,AMHBTH),AMHJOB,AMHBTH
 Q
PRN ;
 I $Y>(IOSL-4) D HEAD Q:$D(AMHQ)
 S AMHHRCN=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^(0),U,2),1:"<none>")
 W !,$E($P(^DPT(DFN,0),U),1,15),?18,AMHHRCN
 W ?26,$P(^DPT(DFN,0),U,2) S Y=$P(^DPT(DFN,0),U,3) W ?28,$E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 W ?38,$P(^XTMP("AMHRC4",AMHJOB,AMHBTH,"HITS",AMHNAME,DFN),U,1)
 W ?45,$$D($P(^XTMP("AMHRC4",AMHJOB,AMHBTH,"HITS",AMHNAME,DFN),U,3))
 S V=$P(^XTMP("AMHRC4",AMHJOB,AMHBTH,"HITS",AMHNAME,DFN),U,2)
 W ?56,$$LASTDX(V)
 W ?63,$E($$PPNAME^AMHUTIL(V),1,16)
 Q
LASTDX(V) ;
 ;get last pov
 NEW X
 S X=$O(^AMHRPRO("AD",V,0))
 I X="" Q ""
 Q $$VAL^XBDIQ1(9002011.01,X,.01)
HEAD I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",AMHPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 S X="PATIENTS SEEN AT LEAST "_AMHDAYS_" TIMES WITH NO CASE OPEN DATE" W $$CJ^XLFSTR(X,80),!
 S X="VISIT DATE RANGE: "_$$FMTE^XLFDT(AMHBD)_" to "_$$FMTE^XLFDT(AMHED) W $$CJ^XLFSTR(X,80),!
 I AMHPROG]"" S X="VISITS TO PROGRAM: "_$$EXTSET^XBFUNC(9002011,.02,AMHPROG) W !,$$CTR(X,80)
 W !,"PATIENT NAME",?18,"CHART",?25,"SEX",?31,"DOB",?38,"#",?45,"LAST VISIT",?56,"LAST",?63,"PROVIDER"
 W !?18,"NUMBER",?38,"VISITS",?56,"DX"
 W !,$$REPEAT^XLFSTR("-",80),!
 Q
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
