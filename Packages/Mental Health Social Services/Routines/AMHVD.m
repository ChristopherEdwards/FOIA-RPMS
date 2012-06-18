AMHVD ; IHS/CMI/LAB - BROWSE VISITS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;
 NEW AMHX,AMHY,AMHR0,DFN,AUPNPAT,AUPNDOB,AUPNDOD,AUPNDAYS,AUPNSEX,AMHV,AMHBD,AMHED
 NEW D,R
 K AMHV
 W:$D(IOF) @IOF
 W $$CTR("Browse Behavioral Health Visits",80)
 D DBHUSR^AMHUTIL
PAT ;
 S DFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." Q
 S DFN=+Y
 I '$$ALLOWP^AMHUTIL(DUZ,DFN) D NALLOWP^AMHUTIL S DFN="" G PAT
 S Y=DFN D ^AUPNPAT
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
WHICH ;
 S AMHQUIT=0
 S AMHW=""
 S DIR(0)="S^L:Patient's Last Visit;N:Patient's Last N Visits;D:Visits in a Date Range;A:All of this Patient's Visits;P:Visits to one Program"
 S DIR("A")="Browse which subset of visits for "_$P(^DPT(DFN,0),U),DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S AMHW=Y
 I AMHW="S" S AMHW="SAN"
 D @AMHW Q:AMHQUIT
 ;
BROWSE ;
 K ^TMP("AMHVD",$J)
 D GATHER
 D EN^VALM("AMH BROWSE VISITS")
 K ^TMP("AMHVD",$J)
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
 W $$CTR("Browse Behavioral Health Visits",80)
 I $D(^AMHBHUSR(DUZ)),$O(^AMHBHUSR(DUZ,11,0)) D
 .W !!,$G(IORVON),"Please note:",$G(IORVOFF),"  Only visits to the following locations will"
 .W !?15,"be displayed:"
 .S X=0 F  S X=$O(^AMHBHUSR(DUZ,11,X)) Q:X'=+X  W !?15,$P(^DIC(4,X,0),U)
 .W !!
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
SAN ;san only
 S D=0,V=0
 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $P(^AMHREC(V,0),U,33)="S",$$ALLOWVI^AMHUTIL(DUZ,V) S AMHV(D,V)=""
 Q
N ;patients last N visits
 S N=""
 S DIR(0)="N^1:99:0",DIR("A")="How many visits should be displayed",DIR("B")="5" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S AMHQUIT=1 Q
 S N=Y
  S (C,D)=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!(C=N)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V!(C=N)  I $$ALLOWVI^AMHUTIL(DUZ,V) S C=C+1,AMHV(D,V)=""
 Q
P ;on program
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
PRINT ;EP - called from xbdbque
 S AMHQUIT=0
 ;gather up all visit records in ^TMP("AMHVD",$J
 D GATHER
 D PRINT1
 K ^TMP("AMHVD",$J)
 Q
 ;
PRINT1 ;
 W:$D(IOF) @IOF
 NEW AMHX
 S AMHX=0 F  S AMHX=$O(^TMP("AMHVD",$J,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 .I $Y>(IOSL-5) D FF Q:AMHQUIT
 .W !,^TMP("AMHVD",$J,AMHX,0)
 .Q
 Q
GATHER ;
 K ^TMP("AMHVD",$J)
 NEW AMHX,AMHI,AMHJ,AMHY,AMHZ,AMHC,AMHD
 S AMHC=0
 S X="Patient Name: "_$P(^DPT(DFN,0),U),$E(X,45)="DOB: "_$$FMTE^XLFDT($P(^DPT(DFN,0),U,3)) D S(X)
 S X="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X)
 I $O(^AMHPSUIC("AC",DFN,0)) D
 .S X="****** Suicide Forms on File ******" D S(X,2)
 .S AMHD=0 F  S AMHD=$O(^AMHPSUIC("AA",DFN,AMHD)) Q:AMHD'=+AMHD  S AMHY=0 F  S AMHY=$O(^AMHPSUIC("AA",DFN,AMHD,AMHY)) Q:AMHY'=+AMHY  D
 ..S X="Date of Act: "_$$VAL^XBDIQ1(9002011.65,AMHY,.06),$E(X,40)="Suicidal Behavior: "_$$VAL^XBDIQ1(9002011.65,AMHY,.13) D S(X)
 ..S X="Previous Attempts: "_$$VAL^XBDIQ1(9002011.65,AMHY,.14),$E(X,40)="Method: "
 ..S Y="",Z=0 F  S Z=$O(^AMHPSUIC(AMHY,11,Z)) Q:Z'=+Z  S Y=Y_$$EXTSET^XBFUNC(9002011.6511,.01,$P(^AMHPSUIC(AMHY,11,Z,0),U))_"  "
 ..S X=X_Y D S(X)
 S X=$TR($J("",80)," ","*") D S(X)
 S AMHV=0,AMHD=0
 F  S AMHD=$O(AMHV(AMHD)) Q:AMHD'=+AMHD  S AMHV=0 F  S AMHV=$O(AMHV(AMHD,AMHV)) Q:AMHV'=+AMHV  D
 .S AMHR0=^AMHREC(AMHV,0)
 .S X="Visit Date: "_$$FMTE^XLFDT($P(AMHR0,U)),$E(X,45)="Provider: "_$$PPNAME^AMHUTIL(AMHV) D S(X,1)
 .;I $P($P(AMHR0,U),".")<$$DATE^AMHESIG() S X="Type of Visit: "_$$VAL^XBDIQ1(9002011,AMHV,.33) D S(X)
 .S X="Activity Type: "_$S($P(AMHR0,U,6)]"":$E($P(^AMHTACT($P(AMHR0,U,6),0),U,2),1,28),1:""),$E(X,45)="Type of Contact: "_$$VAL^XBDIQ1(9002011,AMHV,.07) D S(X)
 .S X="Location of Encounter: "_$$VAL^XBDIQ1(9002011,AMHV,.04) D S(X)
 .I $P(AMHR0,U,17)]"" S X="Placement Disposition: "_$$VAL^XBDIQ1(9002011,AMHV,.17) D S(X)
 .I $P(AMHR0,U,18)]"" S X="Referred To: "_$$VAL^XBDIQ1(9002011,AMHV,.18) D S(X)
 .S X="Chief Complaint/Presenting Problem: "_$P($G(^AMHREC(AMHV,21)),U) D S(X)
 .S X="POV's:" D S(X)
 .S AMHP=0 F  S AMHP=$O(^AMHRPRO("AD",AMHV,AMHP)) Q:AMHP'=+AMHP  D
 ..S X="",$E(X,3)=$$VAL^XBDIQ1(9002011.01,AMHP,.01),$E(X,10)=$E($$VAL^XBDIQ1(9002011.01,AMHP,.04),1,65) D S(X)
 ..Q
 .;SUB/OBJ
 .I '$O(^AMHREC(AMHV,54,0)) G SUB
 .S X="" D S(X) D S("TIU DOCUMENTS") D S("-------------")
 .S AMHDOC=0 F  S AMHDOC=$O(^AMHREC(AMHV,54,"B",AMHDOC)) Q:AMHDOC'=+AMHDOC  D
 ..K AMHTIU,AMHERR
 ..K ^TMP("AMHOENPS",$J)
 ..D TIUDSP
 ..K ^TMP("AMHEONPS",$J)
 ..K AMHTIU
 ..Q
 .G SAN1
SUB .;
 .S X="",$E(X,3)="SUBJECTIVE/OBJECTIVE:  " D S(X,1)
 .S AMHX=0 F  S AMHX=$O(^AMHREC(AMHV,31,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 ..S X="",$E(X,3)=^AMHREC(AMHV,31,AMHX,0) D S(X)
 ..Q
SAN1 .;SAN
 .D SAN^AMHVD1
 .;INTAKE
 .;D INTAKE^AMHVD1
COM .;
 .S X="",$E(X,3)="COMMENT/NEXT APPOINTMENT:  " D S(X,1)
 .S AMHX=0 F  S AMHX=$O(^AMHREC(AMHV,81,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 ..S X="",$E(X,3)=^AMHREC(AMHV,81,AMHX,0) D S(X)
 ..Q
NFT .;
 .I $O(^AMHREC(AMHV,52,0)) S X="",$E(X,3)="NOTE FORWARDED TO:  " D S(X,1) D
 ..S AMHX=0 F  S AMHX=$O(^AMHREC(AMHV,52,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 ...S X=$P(^VA(200,$P(^AMHREC(AMHV,52,AMHX,0),U),0),U) D S(X)
 ..Q
 .S X="Medications Prescribed: " D S(X,1)
 .S AMHX=0 F  S AMHX=$O(^AMHREC(AMHV,41,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 ..S X="",$E(X,3)=^AMHREC(AMHV,41,AMHX,0) D S(X)
 ..Q
 .S X=$TR($J("",80)," ","*") D S(X)
 Q
TIUDSP ;
 S AMHSTR="" D S(AMHSTR)
 I '+$$CANDO^TIULP(AMHDOC,"PRINT RECORD",DUZ) Q  ;S AMHSTR="You do not have security clearance to display the TIU NOTE." D S(AMHSTR) Q
 ; Extract specified note
 S AMHGBL=$NA(^TMP("AMHOENPS",$J)),AMHHLF=IOM\2
 K @AMHGBL
 D EXTRACT^TIULQ(AMHDOC,AMHGBL,.AMHERR,".01;.02;.03;.05;.07;.08;1202;1203;1205;1208;1209;1301;1307;1402;1501:1505;1507:1513;1701","",1,"E")
 M AMHTIU=^TMP("AMHOENPS",$J,AMHDOC)
 K ^TMP("AMHOENPS",$J)
 S AMHSTR="TIU DOCUMENT:  "_AMHTIU(.01,"E") D S(AMHSTR)
 S AMHSTR="AUTHOR: "_AMHTIU(1202,"E") D S(AMHSTR)
 S AMHSTR="SIGNED BY: "_AMHTIU(1502,"E")_"               STATUS: "_AMHTIU(.05,"E") D S(AMHSTR)
 S AMHSTR="LOCATION: "_AMHTIU(1205,"E") D S(AMHSTR)
 F AMHX=0:0 S AMHX=$O(AMHTIU("TEXT",AMHX)) Q:'AMHX  S AMHSTR=AMHTIU("TEXT",AMHX,0) D S(AMHSTR)
 I $L($G(AMHTIU(1501,"E"))) D
 .S AMHSTR="/es/ "_$G(AMHTIU(1503,"E")) D S(AMHSTR)
 .S AMHSTR="Signed: "_$G(AMHTIU(1501,"E")) D S(AMHSTR)
 ;NOW GET ADDENDA USING "DAD" XREF
 I $O(^TIU(8925,"DAD",AMHDOC,0)) S AMHSTR="" D S(AMHSTR)   ;S AMHSTR="This document has addenda." D S(AMHSTR)
 S AMHX1=0 F  S AMHX1=$O(^TIU(8925,"DAD",AMHDOC,AMHX1)) Q:AMHX1'=+AMHX1  D
 .I '+$$CANDO^TIULP(AMHX1,"PRINT RECORD",DUZ) Q  ;S AMHSTR="You do not have security clearance to display the addendum." D S(AMHSTR) Q
 .S AMHGBL=$NA(^TMP("AMHOENPS",$J))
 .K @AMHGBL
 .K AMHTIU
 .D EXTRACT^TIULQ(AMHX1,AMHGBL,.AMHERR,".01;.02;.03;.05;.07;.08;1202;1203;1205;1208;1209;1301;1307;1402;1501:1505;1507:1513;1701","",1,"E")
 .M AMHTIU=^TMP("AMHOENPS",$J,AMHX1)
 .K ^TMP("AMHOENPS",$J)
 .S AMHSTR="" D S(AMHSTR)
 .S AMHSTR=AMHTIU(.01,"E") D S(AMHSTR)
 .S AMHSTR="AUTHOR: "_AMHTIU(1202,"E") D S(AMHSTR)
 .S AMHSTR="SIGNED BY: "_AMHTIU(1502,"E")_"               STATUS: "_AMHTIU(.05,"E") D S(AMHSTR)
 .S AMHSTR="LOCATION: "_AMHTIU(1205,"E") D S(AMHSTR)
 .F AMHX=0:0 S AMHX=$O(AMHTIU("TEXT",AMHX)) Q:'AMHX  S AMHSTR=AMHTIU("TEXT",AMHX,0) D S(AMHSTR)
 .I $L($G(AMHTIU(1501,"E"))) D
 ..S AMHSTR="/es/ "_$G(AMHTIU(1503,"E")) D S(AMHSTR)
 ..S AMHSTR="Signed: "_$G(AMHTIU(1501,"E")) D S(AMHSTR)
 ;
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
 S X=$TR(Y,$C(10),"")
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S AMHC=AMHC+1
 S ^TMP("AMHVD",$J,AMHC,0)=X
 Q
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHVD",$J,""),-1)
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
TEST ;
 D EXTRACT^TIULQ(3,"^TMP(""AMHLQ"",$J)",.TIUERR,"2","",1)
 Q
