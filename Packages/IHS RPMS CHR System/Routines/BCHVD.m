BCHVD ; IHS/CMI/LAB - BROWSE VISITS ; [ 10/24/03  8:34 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**15**;OCT 28, 1996
 ;
 ;
START ;
 NEW BCHX,BCHY,BCHR0,DFN,AUPNPAT,AUPNDOB,AUPNDOD,AUPNDAYS,AUPNSEX,BCHV,BCHBD,BCHED
 NEW D,R
 K BCHV
 W:$D(IOF) @IOF
 W $$CTR("Browse CHR Visits",80)
PAT ;
 S DFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." Q
 S DFN=+Y
 S Y=DFN D ^AUPNPAT
WHICH ;
 S BCHQUIT=0
 S BCHW=""
 S DIR(0)="S^L:Patient's Last Visit;N:Patient's Last N Visits;D:Visits in a Date Range;A:All of this Patient's Visits"
 S DIR("A")="Browse which subset of visits for "_$P(^DPT(DFN,0),U),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BCHW=Y
 D @BCHW Q:BCHQUIT
 ;
BROWSE ;
 K ^TMP("BCHVD",$J)
 D GATHER
 D EN^VALM("BCH BROWSE VISITS")
 K ^TMP("BCHVD",$J)
 D CLEAR^VALM1
 D FULL^VALM1
END ;
 K BCHP,BCHQUIT,BCHW
 Q
 ;
EP(DFN) ;EP to list for one patient
 NEW BCHX,BCHY,BCHR0,AUPNPAT,AUPNDOB,AUPNDOD,AUPNDAYS,AUPNSEX,BCHV,BCHBD,BCHED
 D FULL^VALM1
 NEW D,R
 K BCHV
 I '$G(DFN) D PAT Q
 W:$D(IOF) @IOF
 W $$CTR("Browse CHR Visits",80)
 S Y=DFN D ^AUPNPAT
 D WHICH
 Q
L ;get patients last visit
 ;BCHV array
 I '$D(^BCHR("AE",DFN)) W !!,"No visits on file for this patient.",! S BCHQUIT=1 Q
 S D=$O(^BCHR("AE",DFN,"")),R=$O(^BCHR("AE",DFN,D,""))
 I R S BCHV(D,R)=""
 Q
N ;patients last N visits
 S N=""
 S DIR(0)="N^1:99:0",DIR("A")="How many visits should be displayed",DIR("B")="5" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BCHQUIT=1 Q
 S N=Y
 S (C,D)=0 F  S D=$O(^BCHR("AE",DFN,D)) Q:D'=+D!(C=N)  S V=0 F  S V=$O(^BCHR("AE",DFN,D,V)) Q:V'=+V!(C=N)  S C=C+1,BCHV(D,V)=""
 Q
A ;all visits
 S D=0,V=0
 F  S D=$O(^BCHR("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^BCHR("AE",DFN,D,V)) Q:V'=+V  S BCHV(D,V)=""
 Q
D ;date rante
 K BCHED,BCHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date of Visit"
 D ^DIR S:Y<1 BCHQUIT=1 Q:Y<1  S BCHBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Date of Visit"
 D ^DIR S:Y<1 BCHQUIT=1 Q:Y<1  S BCHED=Y
 ;
 I BCHED<BCHBD D  G D
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S E=9999999-BCHBD,D=9999999-BCHED-1_".99" F  S D=$O(^BCHR("AE",DFN,D)) Q:D'=+D!($P(D,".")>E)  S V=0 F  S V=$O(^BCHR("AE",DFN,D,V)) Q:V'=+V  S BCHV(D,V)=""
 Q
PRINT ;EP - called from xbdbque
 S BCHQUIT=0
 ;gather up all visit records in ^TMP("BCHVD",$J
 D GATHER
 D PRINT1
 K ^TMP("BCHVD",$J)
 Q
 ;
PRINT1 ;
 W:$D(IOF) @IOF
 NEW BCHX
 S BCHX=0 F  S BCHX=$O(^TMP("BCHVD",$J,BCHX)) Q:BCHX'=+BCHX!(BCHQUIT)  D
 .I $Y>(IOSL-5) D FF Q:BCHQUIT
 .W !,^TMP("BCHVD",$J,BCHX,0)
 .Q
 Q
GATHER ;
 K ^TMP("BCHVD",$J)
 NEW BCHX,BCHI,BCHJ,BCHY,BCHZ,BCHC,BCHD
 S BCHC=0
 S X="Patient Name: "_$P(^DPT(DFN,0),U),$E(X,45)="DOB: "_$$FMTE^XLFDT($P(^DPT(DFN,0),U,3)) D S(X)
 S X="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X)
 S X=$TR($J("",80)," ","*") D S(X)
 S BCHV=0,BCHD=0
 F  S BCHD=$O(BCHV(BCHD)) Q:BCHD'=+BCHD  S BCHV=0 F  S BCHV=$O(BCHV(BCHD,BCHV)) Q:BCHV'=+BCHV  D
 .S BCHR0=^BCHR(BCHV,0)
 .S X="Visit Date: "_$$FMTE^XLFDT($P(BCHR0,U)),$E(X,45)="Provider: "_$$PPNAME^BCHUTIL(BCHV) D S(X,1)
 .S X="Program: "_$$VAL^XBDIQ1(90002,BCHV,.02) D S(X)
 .S X="Activity Location: "_$$VAL^XBDIQ1(90002,BCHV,.06),$E(X,45)="Travel Time: "_$$VAL^XBDIQ1(90002,BCHV,.11) D S(X)
 .I $P(BCHR0,U,7)]""!($P(BCHR0,U,8)]"") S X="Referred BY: "_$$VAL^XBDIQ1(90002,BCHV,.07),$E(X,45)="Referred TO: "_$$VAL^XBDIQ1(90002,BCHV,.08) D S(X)
 .I $P(BCHR0,U,13)]""!($P(BCHR0,U,14)]"") S X="LMP: "_$$VAL^XBDIQ1(90002,BCHV,.13),$E(X,45)="Fam Plan Method: "_$$VAL^XBDIQ1(90002,BCHV,.14) D S(X)
 .F BCHF=1201:1:1210 S BCH1=+$E(BCHF,3,4) I $P($G(^BCHR(BCHV,12)),U,BCH1)]"" S X=$P(^DD(90002,BCHF,0),U,1)_": "_$$VAL^XBDIQ1(90002,BCHV,BCHF) D S(X)
 .F BCHF=1301:1:1308 S BCH1=+$E(BCHF,3,4) I $P($G(^BCHR(BCHV,13)),U,BCH1)]"" S X=$P(^DD(90002,BCHF,0),U,1)_": "_$$VAL^XBDIQ1(90002,BCHV,BCHF) D S(X)
 .S X="POV's:" D S(X)
 .S BCHP=0 F  S BCHP=$O(^BCHRPROB("AD",BCHV,BCHP)) Q:BCHP'=+BCHP  D
 ..S X="",$E(X,3)=$$VAL^XBDIQ1(90002.01,BCHP,.01),$E(X,30)=$E($$VAL^XBDIQ1(90002.01,BCHP,.06),1,65) D S(X)
 ..S X="",$E(X,3)=$$VAL^XBDIQ1(90002.01,BCHP,.04),$E(X,30)=$$VAL^XBDIQ1(90002.01,BCHP,.05) D S(X)
 ..Q
 .;SUB/OBJ
 .S X="",$E(X,3)="SUBJECTIVE:  " D S(X,1)
 .S BCHX=0 F  S BCHX=$O(^BCHR(BCHV,51,BCHX)) Q:BCHX'=+BCHX!(BCHQUIT)  D
 ..S X="",$E(X,3)=^BCHR(BCHV,51,BCHX,0) D S(X)
 ..Q
 .S X="",$E(X,3)="OBJECTIVE:  " D S(X,1)
 .S BCHX=0 F  S BCHX=$O(^BCHR(BCHV,61,BCHX)) Q:BCHX'=+BCHX!(BCHQUIT)  D
 ..S X="",$E(X,3)=^BCHR(BCHV,61,BCHX,0) D S(X)
 ..Q
 .S X="",$E(X,3)="PLAN:  " D S(X,1)
 .S BCHX=0 F  S BCHX=$O(^BCHR(BCHV,71,BCHX)) Q:BCHX'=+BCHX!(BCHQUIT)  D
 ..S X="",$E(X,3)=^BCHR(BCHV,71,BCHX,0) D S(X)
 ..Q
 .S X=$TR($J("",80)," ","*") D S(X)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
FF ;EP
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BCHQUIT=1 Q
 I $E(IOST)'="C" Q:'$P(BCHR0,U,8)  W !!,$TR($J(" ",79)," ","*"),!,$P(^DPT($P(BCHR0,U,8),0),U),?32,"HRN: " D
 .S H=$P($G(^AUPNPAT($P(BCHR0,U,8),41,DUZ(2),0)),U,2)
 .W H,?46,"DOB: ",$$FMTE^XLFDT($P(^DPT($P(BCHR0,U,8),0),U,3),"2D"),?59,"SSN: ",$P(^DPT($P(BCHR0,U,8),0),U,9),!
 W:$D(IOF) @IOF
 Q
HDR ; -- header code
 Q
 ;
S(Y,F,C,T) ;EP - set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S BCHC=BCHC+1
 S ^TMP("BCHVD",$J,BCHC,0)=X
 Q
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("BCHVD",$J,""),-1)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
