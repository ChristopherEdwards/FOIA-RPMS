BCHVDO ; IHS/CMI/LAB - BROWSE VISITS ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
 ;
START ;
 NEW BCHX,BCHY,BCHR0,DFN,AUPNPAT,AUPNDOB,AUPNDOD,AUPNDAYS,AUPNSEX,BCHV,BCHBD,BCHED
 NEW D,R
 K BCHV
 W:$D(IOF) @IOF
 W $$CTR^BCHRLU("List One Patient's Visits",80)
PAT ;
 D GETPAT^BCHULV
 I 'BCHPAT,'BCHNRPAT D XIT Q
WHICH ;
 S BCHQUIT=0
 S BCHW=""
 S DIR(0)="S^L:Patient's Last Visit;N:Patient's Last N Visits;D:Visits in a Date Range;A:All of this Patient's Visits"
 S DIR("A")="Browse which subset of visits for "_$S(BCHPAT:$P(^DPT(BCHPAT,0),U,1),1:$P(^BCHRPAT(BCHNRPAT,0),U,1)),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BCHW=Y
 D @BCHW Q:BCHQUIT
ZIS ;call to XBDBQUE
 S XBRP="PRINT^BCHVDO",XBRC="",XBRX="XIT^BCHVDO",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
PRINT ;
 S BCHPG=0
 K BCHQUIT
 I '$D(BCHV) D HEADER W !!,"Patient had no CHR visits in the time period." D XIT Q
 D HEADER
 S BCHD=0 F  S BCHD=$O(BCHV(BCHD)) Q:BCHD=""!($D(BCHQUIT))  D
 .S BCHR=0 F  S BCHR=$O(BCHV(BCHD,BCHR)) Q:BCHR=""!($D(BCHQUIT))  D
 ..S BCHR0=^BCHR(BCHR,0)
 ..D PRINT1
 ..Q
 .Q
 Q
PRINT1 ;
 I $Y>(IOSL-3) D HEADER Q:$D(BCHQUIT)
 W !,$E($P(BCHR0,U),4,5),"/",$E($P(BCHR0,U),6,7),"/",(1700+($E($P(BCHR0,U),1,3)))
 W ?11,$E($$PPNAME^BCHUTIL(BCHR),1,20)
 S BCHACTL=$P(BCHR0,U,6) I BCHACTL]"" S BCHACTL=$E($P(^BCHTACTL(BCHACTL,0),U),1,10)
 S BCHSFAC=$P(BCHR0,U,5) I BCHSFAC]"" S BCHSFAC=$E($P(^AUTTLOC(BCHSFAC,0),U,2),1,10)
 I BCHSFAC="" S BCHSFAC=BCHACTL
 W ?32,BCHSFAC
 I '$D(^BCHRPROB("AD",BCHR)) W ?45,"           --"
 E  S BCHP=0,BCHC=0 F  S BCHP=$O(^BCHRPROB("AD",BCHR,BCHP)) Q:BCHP'=+BCHP  S BCHPREC=^BCHRPROB(BCHP,0) D GETPROB  W:BCHC ! W ?45,BCHX S BCHC=BCHC+1
 Q
GETPROB ;
 S BCHX=""
 S X=$P(^BCHTPROB($P(BCHPREC,U),0),U,2)_" "
 S X=X_$S($P(BCHPREC,U,4)]"":$P(^BCHTSERV($P(BCHPREC,U,4),0),U,3),1:" ")_" "
 S X=X_$J($P(BCHPREC,U,5),3)_" "
 S N=$P(BCHPREC,U,6) I N,$D(^AUTNPOV(N,0)) S N=$P(^AUTNPOV(N,0),U)
 S X=X_$S(N]"":$E(N,1,25),1:"  ")
 S BCHX=BCHX_X
 Q
HEADER ;EP
 I 'BCHPG G HEADER1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BCHQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S BCHPG=BCHPG+1
 S X="**********  CONFIDENTIAL PATIENT INFORMATION  **********" W !,$$CTR^BCHRLU(X,80),!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",BCHPG
 S BCHTEXT="VISITS by CHR's"
 W !?(80-$L(BCHTEXT)/2),BCHTEXT
 I BCHPAT D
 .S X="Patient Name: "_$P(^DPT(BCHPAT,0),U,1)
 .W !!,$$CTR^BCHRLU(X,80)
 .S X="Health Record Number: "_$$HRN^AUPNPAT(BCHPAT,DUZ(2))
 .W !,$$CTR^BCHRLU(X,80)
 .S X="DOB: "_$$FMTE^XLFDT($$DOB^AUPNPAT(BCHPAT))
 .W !,$$CTR^BCHRLU(X,80)
 ;S BCHTEXT="Visit Dates:  "_$$FMTE^XLFDT(BCHBD)_" and "_$$FMTE^XLFDT(BCHED)
 ;W !!,$$CTR^BCHRUL(X,80)
 I BCHNRPAT D
 .S X="Patient Name: "_$P(^BCHRPAT(BCHNRPAT,0),U,1)
 .W !!,$$CTR^BCHRLU(X,80)
 .S X="CHR ID: "_$P(^BCHRPAT(BCHNRPAT,0),U,9)
 .W !,$$CTR^BCHRLU(X,80)
 .S X="DOB: "_$$VAL^XBDIQ1(90002.11,BCHNRPAT,.02)
 .W !,$$CTR^BCHRLU(X,80)
 W !,$TR($J(" ",80)," ","=")
 W !," DATE",?11,"CHR",?32,"LOCATION",?45,"ASSESSMENTS - POVS"
 W !,$TR($J(" ",80)," ","-")
 Q
 ;
L ;get patients last visit
 ;BCHV array
 I BCHPAT S X="AE",P=BCHPAT
 I BCHNRPAT S X="ANRE",P=BCHNRPAT
 I '$D(^BCHR(X,P)) W !!,"No visits on file for this patient.",! S BCHQUIT=1 Q
 S D=$O(^BCHR(X,P,"")),R=$O(^BCHR("AE",P,D,""))
 I R S BCHV(D,R)=""
 Q
N ;patients last N visits
 S N=""
 S DIR(0)="N^1:99:0",DIR("A")="How many visits should be displayed",DIR("B")="5" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BCHQUIT=1 Q
 S N=Y
 I BCHPAT S X="AE",P=BCHPAT
 I BCHNRPAT S X="ANRE",P=BCHNRPAT
 S (C,D)=0 F  S D=$O(^BCHR(X,P,D)) Q:D'=+D!(C=N)  S V=0 F  S V=$O(^BCHR(X,P,D,V)) Q:V'=+V!(C=N)  S C=C+1,BCHV(D,V)=""
 Q
A ;all visits
 S D=0,V=0
 I BCHPAT S X="AE",P=BCHPAT
 I BCHNRPAT S X="ANRE",P=BCHNRPAT
 F  S D=$O(^BCHR(X,P,D)) Q:D'=+D  S V=0 F  S V=$O(^BCHR(X,P,D,V)) Q:V'=+V  S BCHV(D,V)=""
 Q
D ;date range
 K BCHED,BCHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date of Visit"
 D ^DIR S:Y<1 BCHQUIT=1 Q:Y<1  S BCHBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Date of Visit"
 D ^DIR S:Y<1 BCHQUIT=1 Q:Y<1  S BCHED=Y
 ;
 I BCHED<BCHBD D  G D
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 I BCHPAT S X="AE",P=BCHPAT
 I BCHNRPAT S X="ANRE",P=BCHNRPAT
 S E=9999999-BCHBD,D=9999999-BCHED-1_".99" F  S D=$O(^BCHR(X,P,D)) Q:D'=+D!($P(D,".")>E)  S V=0 F  S V=$O(^BCHR(X,P,D,V)) Q:V'=+V  S BCHV(D,V)=""
 Q
XIT ;
 D EN^XBVK("BCH")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
