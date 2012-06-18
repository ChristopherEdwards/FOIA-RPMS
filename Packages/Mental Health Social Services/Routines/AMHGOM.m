AMHGOM ; IHS/CMI/MAW - BROWSE VISITS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
START ;
 W:$D(IOF) @IOF
 D EN^XBVK("AMH")
 W !,$$CTR("GAF OUTCOME MEASURE - GAF Scores for One Patient",80),!!
 W !,"This option is used to list GAF Scores for a patient in date order.",!!
 D DBHUSR^AMHUTIL
PAT ;
 S DFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." Q
 S DFN=+Y
 S Y=DFN D ^AUPNPAT
 I DFN,'$$ALLOWP^AMHUTIL(DUZ,DFN) D NALLOWP^AMHUTIL D PAUSE^AMHLEA G PAT
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
WHICH ;
 W !!,"Please note:  Only visits with GAF scores recorded will display on this",!,"list.",!
 S AMHQUIT=0
 S AMHW=""
 K DIR S DIR(0)="S^N:Patient's Last N Visits;D:Visits in a Date Range;A:All of this Patient's Visits;R:Visits to One Program;P:Visits to One Provider"
 S DIR("A")="Browse which subset of visits for "_$P(^DPT(DFN,0),U),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S AMHW=Y
 ;I AMHW="P" S AMHW="PROV"
 D @AMHW Q:AMHQUIT
 ;
BROWSE ;
 K ^TMP("AMHGOM",$J)
 D GATHER
 D EN^VALM("AMH GAF SCORE VISITS")
 K ^TMP("AMHGOM",$J)
 D CLEAR^VALM1
 D FULL^VALM1
END ;
 K AMHP,AMHQUIT,AMHW
 Q
 ;
EP(DFN) ;EP to list for one patient
 NEW AMHX,AMHY,AMHR0,AUPNPAT,AUPNDOB,AUPNDOD,AUPNDAYS,AUPNSEX,AMHV,AMHBD,AMHED
 D FULL^VALM1
 NEW D,R
 K AMHV
 I '$G(DFN) D PAT Q
 W:$D(IOF) @IOF
 W $$CTR("GAF Scores",80)
 S Y=DFN D ^AUPNPAT
 D WHICH
 Q
L ;get patients last visit
 ;AMHV array
 ;I '$D(^AMHREC("AE",DFN)) W !!,"No visits on file for this patient.",! S AMHQUIT=1 Q
 ;S D=$O(^AMHREC("AE",DFN,"")),R=$O(^AMHREC("AE",DFN,D,""))
 S (C,D)=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!(C>0)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V!(C>0)  I $$ALLOWVI^AMHUTIL(DUZ,V) S C=C+1,AMHV(D,V)=""
 ;I R S AMHV(D,R)=""
 Q
N ;patients last N visits
 S N=""
 S DIR(0)="N^1:99:0",DIR("A")="How many visits should be displayed",DIR("B")="5" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S AMHQUIT=1 Q
 S N=Y
 S (C,D)=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!(C=N)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V!(C=N)  I $$ALLOWVI^AMHUTIL(DUZ,V) S C=C+1,AMHV(D,V)=""
 Q
R ;on program
 S N=""
 S DIR(0)="9002011,.02",DIR("A")="Visits to Which Program",DIR("B")="M" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S AMHQUIT=1 Q
 S N=Y
 S D=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $P(^AMHREC(V,0),U,2)=N,$$ALLOWVI^AMHUTIL(DUZ,V) S AMHV(D,V)=""
 Q
A ;all visits
 S D=0,V=0
 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $$ALLOWVI^AMHUTIL(DUZ,V) S AMHV(D,V)=""
 Q
D ;date range
 K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date of Visit"
 D ^DIR S:Y<1 AMHQUIT=1 Q:Y<1  S AMHBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Date of Visit"
 D ^DIR S:Y<1 AMHQUIT=1 Q:Y<1  S AMHED=Y
 ;
 I AMHED<AMHBD D  G D
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S E=9999999-AMHBD,D=9999999-AMHED-1_".99" F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $$ALLOWVI^AMHUTIL(DUZ,V) S AMHV(D,V)=""
 Q
P ;
 S N=""
 S DIR(0)="9002011.02,.01",DIR("A")="Visits to Which Provider",DIR("B")=$P(^VA(200,DUZ,0),U) KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S AMHQUIT=1 Q
 S N=+Y
 S D=0 F  S D=$O(^AMHREC("AF",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AF",DFN,D,V)) Q:V'=+V  I $$ALLOWVI^AMHUTIL(DUZ,V),$P(^AMHREC(V,0),U,14)]"",$$PPINT^AMHUTIL(V)=N S AMHV(D,V)=""
 Q
PRINT ;EP - called from xbdbque
 S AMHQUIT=0
 ;gather up all visit records in ^TMP("AMHGOM",$J
 D GATHER
 D PRINT1
 K ^TMP("AMHGOM",$J)
 Q
 ;
PRINT1 ;
 W:$D(IOF) @IOF
 NEW AMHX
 S AMHX=0 F  S AMHX=$O(^TMP("AMHGOM",$J,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 .I $Y>(IOSL-5) D FF Q:AMHQUIT
 .W !,^TMP("AMHGOM",$J,AMHX,0)
 .Q
 Q
GATHER ;
 K ^TMP("AMHGOM",$J)
 NEW AMHX,AMHI,AMHJ,AMHY,AMHZ,AMHC,AMHD,AMHGAFT
 S AMHGAFT=0
 S AMHC=0
 S X="Patient Name: "_$P(^DPT(DFN,0),U),$E(X,45)="DOB: "_$$FMTE^XLFDT($P(^DPT(DFN,0),U,3)) D S(X)
 S X="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X)
 S X=$TR($J("",80)," ","*") D S(X)
 S X="  Date",$E(X,14)="GAF",$E(X,19)="TYPE",$E(X,29)="PROVIDER",$E(X,45)="PG",$E(X,49)="Diagnosis/POV" D S(X)
 S X="",$E(X,3)=$$REPEAT^XLFSTR("-",77) D S(X)
 S AMHV=0,AMHD=0
 F  S AMHD=$O(AMHV(AMHD)) Q:AMHD'=+AMHD  S AMHV=0 F  S AMHV=$O(AMHV(AMHD,AMHV)) Q:AMHV'=+AMHV  D
 .S AMHR0=^AMHREC(AMHV,0)
 .Q:$P(AMHR0,U,14)=""
 .S AMHX="  "_$$D^AMHRPEC($P(AMHR0,U))
 .S $E(AMHX,14)=$P(AMHR0,U,14)
 .S $E(AMHX,19)=$E($P($G(^AMHREC(AMHV,11)),U,15),1,8)
 .S $E(AMHX,29)=$E($$PPNAME^AMHUTIL(AMHV),1,15)
 .S M=$P(^AMHREC(AMHV,0),U,2),M=$S(M="M":"MH",M="S":"SS",M="O":"OT",M="C":"CD",1:"")
 .S $E(AMHX,45)=M
 .S X=$O(^AMHRPRO("AD",AMHV,0))
 .I X S $E(AMHX,49)=$$VAL^XBDIQ1(9002011.01,X,.01)_" - "_$E($$VAL^XBDIQ1(9002011.01,X,.04),1,23)
 .D S(AMHX)
 .S AMHGAFT=AMHGAFT+1
 I 'AMHGAFT D S("No GAF scores to report.")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
FF ;EP
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
 I $E(IOST)'="C" Q:'$P(AMHR0,U,8)  W !!,$TR($J(" ",79)," ","*"),!,$P(^DPT($P(AMHR0,U,8),0),U),?32,"HRN: " D
 .S H=$P($G(^AUPNPAT($P(AMHR0,U,8),41,DUZ(2),0)),U,2)
 .W H,?46,"DOB: ",$$FMTE^XLFDT($P(^DPT($P(AMHR0,U,8),0),U,3),"2D"),?59,"SSN: ",$$SSN^AMHUTIL($P(AMHR0,U,8)),!
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
 S AMHC=AMHC+1
 S ^TMP("AMHGOM",$J,AMHC,0)=X
 Q
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHGOM",$J,""),-1)
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
