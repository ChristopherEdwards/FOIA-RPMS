AMHPHQO ; IHS/CMI/LAB - BROWSE VISITS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;
 W:$D(IOF) @IOF
 D EN^XBVK("AMH")
 W !,$$CTR("PHQ2 and PHQ-9 Depression Outcomes - Scores for One Patient",80),!!
 W !,"This option is used to list PHQ2 and PHQ9 Scores for one patient within",!,"a date range specified by the user.",!
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
 W !!,"Please note:  Only visits with PHQ2 and PHQ9 scores recorded will display",!,"on this list.",!
 S AMHQUIT=0
 S AMHW=""
 S (AMHBD,AMHED,AMHNUM)=""
 K DIR S DIR(0)="S^N:Patient's Last N Visits;D:Visits in a Date Range;A:All of this Patient's Visits"
 S DIR("A")="Browse which subset of visits for "_$P(^DPT(DFN,0),U),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S AMHW=Y
 D @AMHW Q:AMHQUIT
 ;
CP ;
 S AMHCP=""
 S DIR(0)="S^C:Visits to Selected Clinics;P:Visits to Selected Providers;A:Include All Visits regardless of Clinic/Provider",DIR("A")="Limit by Clinic/Provider"
 S DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G WHICH
 S AMHCP=Y
 I AMHCP="A" K AMHPROV,AMHCLN G BROWSE
 I AMHCP="C" D CLIN I '$D(AMHCLN) G CP
 I AMHCP="P" D PROV I '$D(AMHPROV) G CP
BROWSE ;
 K ^TMP("AMHPHQO",$J)
 D GATHER
 D EN^VALM("AMH PHQ SCORES ONE PATIENT")
 K ^TMP("AMHPHQO",$J)
 D CLEAR^VALM1
 D FULL^VALM1
END ;
 K AMHP,AMHQUIT,AMHW,AMHV
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
 S AMHNUM=""
 S DIR(0)="N^1:99:0",DIR("A")="How many visits should be displayed",DIR("B")="5" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S AMHQUIT=1 Q
 S AMHNUM=Y,AMHBD=0,AMHED=DT
 Q
R ;on program
 S N=""
 S DIR(0)="9002011,.02",DIR("A")="Visits to Which Program",DIR("B")="M" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S AMHQUIT=1 Q
 S N=Y
 S D=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $P(^AMHREC(V,0),U,2)=N,$$ALLOWVI^AMHUTIL(DUZ,V) S AMHV(D,V)=""
 Q
A ;all visits
 S AMHNUM=9999999
 S AMHBD=""
 S AMHED=DT
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
 S AMHNUM=99999999
 Q
P ;
 S N=""
 S DIR(0)="9002011.02,.01",DIR("A")="Visits to Which Provider",DIR("B")=$P(^VA(200,DUZ,0),U) KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S AMHQUIT=1 Q
 S N=+Y
 S D=0 F  S D=$O(^AMHREC("AF",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AF",DFN,D,V)) Q:V'=+V  I $$ALLOWVI^AMHUTIL(DUZ,V),$P(^AMHREC(V,0),U,14)]"",$$PPINT^AMHUTIL(V)=N S AMHV(D,V)=""
 Q
CLIN ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 D PEP^AMQQGTX0(+Y,"AMHCLN(")
 I '$D(AMHCLN) Q
 I $D(AMHCLN("*")) K AMHCLN
 Q
PROV ;
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 D PEP^AMQQGTX0(+Y,"AMHPROV(")
 I '$D(AMHPROV) Q
 I $D(AMHPROV("*")) K AMHPROV
 Q
HASPHQ(V) ;EP - does this visit have a phq measurement
 NEW X,Y,Z
 S (X,Z)=0
 F  S X=$O(^AMHRMSR("AD",V,X)) Q:X'=+X  S Y=$$VAL^XBDIQ1(9002011.12,X,.01) I Y="PHQ2"!(Y="PHQ9") S Z=1
 Q Z
HASPHQV(V) ;EP
 NEW X,Y,Z
 S (X,Z)=0
 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  S Y=$$VAL^XBDIQ1(9000010.01,X,.01) I Y="PHQ2"!(Y="PHQ9") S Z=1
 Q Z
PRINT ;EP - called from xbdbque
 S AMHQUIT=0
 ;gather up all visit records in ^TMP("AMHPHQO",$J
 D GATHER
 D PRINT1
 K ^TMP("AMHPHQO",$J)
 Q
 ;
PRINT1 ;
 W:$D(IOF) @IOF
 NEW AMHX
 S AMHX=0 F  S AMHX=$O(^TMP("AMHPHQO",$J,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 .I $Y>(IOSL-5) D FF Q:AMHQUIT
 .W !,^TMP("AMHPHQO",$J,AMHX,0)
 .Q
 Q
GATHER ;
 K ^TMP("AMHPHQO",$J)
 NEW AMHX,AMHI,AMHJ,AMHY,AMHZ,AMHC,AMHD
 S AMHC=0
 S X="Patient Name: "_$P(^DPT(DFN,0),U),$E(X,45)="DOB: "_$$FMTE^XLFDT($P(^DPT(DFN,0),U,3)) D S(X)
 S X="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X)
 S X=$TR($J("",80)," ","*") D S(X)
 S X=" Date",$E(X,12)="PHQ-2",$E(X,18)="PHQ-9",$E(X,24)="PROVIDER",$E(X,41)="CLINIC",$E(X,55)="Diagnosis/POV" D S(X)
 S X="",$E(X,2)=$$REPEAT^XLFSTR("-",77) D S(X)
 S AMHV=0,AMHD=0,AMHRCNT=0
 F  S AMHV=$O(^AMHREC("C",DFN,AMHV)) Q:AMHV'=+AMHV  D
 .Q:'$$HASPHQ(AMHV)
 .Q:AMHBD>$P($P(^AMHREC(AMHV,0),U),".")
 .Q:AMHED<$P($P(^AMHREC(AMHV,0),U),".")
 .I $D(AMHCLN) Q:$P(^AMHREC(AMHV,0),U,25)=""
 .I $D(AMHCLN),'$D(AMHCLN($P(^AMHREC(AMHV,0),U,25))) Q
 .I $D(AMHPROV) S G=0 D  Q:'G
 ..S X=0 F  S X=$O(^AMHRPROV("AD",AMHV,X)) Q:X'=+X  D
 ...S Y=$P($G(^AMHRPROV(X,0)),U)
 ...Q:Y=""
 ...Q:'$D(AMHPROV(Y))
 ...S G=1,AMHRCNT=AMHRCNT+1
 .S AMHV((9999999-$P($P(^AMHREC(AMHV,0),U),".")),"BH",AMHV)="",AMHRCNT=AMHRCNT+1
 ;
 ;NOW get pcc visits
 S AMHV=0 F  S AMHV=$O(^AUPNVSIT("AC",DFN,AMHV)) Q:AMHV'=+AMHV  D
 .Q:'$$HASPHQV(AMHV)
 .Q:$D(^AMHREC("AVISIT",AMHV))  ;already in BH
 .Q:AMHBD>$P($P(^AUPNVSIT(AMHV,0),U),".")
 .Q:AMHED<$P($P(^AUPNVSIT(AMHV,0),U),".")
 .I $D(AMHCLN) Q:$P(^AUPNVSIT(AMHV,0),U,8)=""
 .I $D(AMHCLN),'$D(AMHCLN($P(^AUPNVSIT(AMHV,0),U,8))) Q
 .I $D(AMHPROV) S G=0 D  Q:'G
 ..S X=0 F  S X=$O(^AUPNVPRV("AD",AMHV,X)) Q:X'=+X  D
 ...S Y=$P($G(^AUPNVPRV(X,0)),U)
 ...Q:Y=""
 ...Q:'$D(AMHPROV(Y))
 ...S G=1
 .S AMHV((9999999-$P($P(^AUPNVSIT(AMHV,0),U),".")),"PCC",AMHV)="",AMHRCNT=AMHRCNT+1
 S AMHD=0,AMHCNT=0 F  S AMHD=$O(AMHV(AMHD)) Q:AMHD=""!(AMHCNT>AMHNUM)  D
 .S AMHT="" F  S AMHT=$O(AMHV(AMHD,AMHT)) Q:AMHT=""!(AMHCNT>AMHNUM)  D
 ..S AMHV=0 F  S AMHV=$O(AMHV(AMHD,AMHT,AMHV)) Q:AMHV'=+AMHV!(AMHCNT>AMHNUM)  D
 ...S AMHCNT=AMHCNT+1
 ...Q:AMHCNT>AMHNUM
 ...I AMHT="BH" D
 ....S AMHR0=^AMHREC(AMHV,0)
 ....S AMHX=" "_$$D^AMHRPEC($P(AMHR0,U))
 ....S (X,Z)=0 S (Z,N)=""
 ....F  S X=$O(^AMHRMSR("AD",AMHV,X)) Q:X'=+X  S Y=$$VAL^XBDIQ1(9002011.12,X,.01) D
 .....I Y="PHQ2" S Z=Z_$P(^AMHRMSR(X,0),U,4)_" "
 .....I Y="PHQ9" S N=N_$P(^AMHRMSR(X,0),U,4)_" "
 ....S $E(AMHX,12)=Z
 ....S $E(AMHX,18)=N
 ....S $E(AMHX,24)=$E($$PPNAME^AMHUTIL(AMHV),1,15)
 ....S $E(AMHX,41)=$E($$VAL^XBDIQ1(9002011,AMHV,.25),1,13)
 ....S X=$O(^AMHRPRO("AD",AMHV,0))
 ....I X S $E(AMHX,55)=$$VAL^XBDIQ1(9002011.01,X,.01)_" - "_$E($$VAL^XBDIQ1(9002011.01,X,.04),1,25)
 ....D S(AMHX)
 ...I AMHT="PCC" D
 ....S AMHX=" "_$$D^AMHRPEC($P(^AUPNVSIT(AMHV,0),U))
 ....S (X,Z)=0 S (Z,N)=""
 ....F  S X=$O(^AUPNVMSR("AD",AMHV,X)) Q:X'=+X  S Y=$$VAL^XBDIQ1(9000010.01,X,.01) D
 .....I Y="PHQ2" S Z=Z_$P(^AUPNVMSR(X,0),U,4)_" "
 .....I Y="PHQ9" S N=N_$P(^AUPNVMSR(X,0),U,4)_" "
 ....S $E(AMHX,12)=Z
 ....S $E(AMHX,18)=N
 ....S $E(AMHX,24)=$E($$PRIMPROV^APCLV(AMHV,"N"),1,15)
 ....S $E(AMHX,41)=$E($$VAL^XBDIQ1(9000010,AMHV,.08),1,13)
 ....S X=$O(^AUPNVPOV("AD",AMHV,0))
 ....I X S $E(AMHX,55)=$$VAL^XBDIQ1(9000010.07,X,.01)_" - "_$E($$VAL^XBDIQ1(9000010.07,X,.04),1,25)
 ....D S(AMHX)
 I AMHCNT=0 S X="No Visits with PHQ2/PHQ9 measurements in the specified time frame." D S(X,1)
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
 S ^TMP("AMHPHQO",$J,AMHC,0)=X
 Q
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHPHQO",$J,""),-1)
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
