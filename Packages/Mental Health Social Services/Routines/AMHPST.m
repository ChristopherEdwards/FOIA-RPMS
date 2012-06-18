AMHPST ; IHS/CMI/LAB - STAGING TOOL DISPLAY ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;
 NEW AMHX,AMHY,AMHP,AUPNPAT,AUPNDOB,AUPNDOD,AUPNDAYS,AUPNSEX,AMHV,AMHBD,AMHED
 NEW D,R
 K AMHV
 W:$D(IOF) @IOF
 W $$CTR("Staging Report",80)
 D DBHUSR^AMHUTIL
PAT ;
 S AMHP=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." Q
 S AMHP=+Y
 I AMHP,'$$ALLOWP^AMHUTIL(DUZ,AMHP) D NALLOWP^AMHUTIL D PAUSE^AMHLEA G PAT
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 ;
D ;
 K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date of Visit"
 D ^DIR S:Y<1 AMHQUIT=1 G:Y<1 EOJ  S AMHBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Date of Visit"
 D ^DIR S:Y<1 AMHQUIT=1 Q:Y<1  S AMHED=Y
 ;
 I AMHED<AMHBD D  G D
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
ZIS ;
 G BROWSE
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G EOJ
 I $G(Y)="B" D BROWSE,EOJ Q
 W !! S XBRP="PRINT^AMHPST",XBRC="",XBNS="AMH",XBRX="EOJ^AMHPST"
 D ^XBDBQUE
 D EOJ
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHPST"")"
 S XBNS="AMH",XBRC="",XBRX="EOJ^AMHPST",XBIOP=0 D ^XBDBQUE
 Q
 ;
EOJ ;
 K AMHP,AMHPG,AMHQUIT,AMHX,AMHY,AMHR0,AMHBD,AMHED,AMHD,AMHV,AMHB
 Q
 ;
EP(AMHP) ;EP to list for one patient
 NEW AMHX,AMHY,AMHR0,AUPNPAT,AUPNDOB,AUPNDOD,AUPNDAYS,AUPNSEX,AMHV,AMHBD,AMHED,AMHD,X,Y,DIC,DIE
 D FULL^VALM1
 W:$D(IOF) @IOF
 D DBHUSR^AMHUTIL
 W $$CTR("Staging Report",80)
 I '$G(AMHP) D PAT,EOJ Q
 D D
 D EOJ
 Q
PRINT ;EP - called from xbdbque
 S AMHQUIT=0,AMHPG=0
 ;gather up all staging tool records in ^TMP("AMHPST",$J
 K ^TMP("AMHPST",$J)
 D HEADING
 I '$O(^AMHRCDST("AC",AMHP,0)) W !,"No Staging Data has been entered for this patient." K ^TMP("AMHPST",$J) D PAUSE Q
 D GATHER
 D PRINT1
 K ^TMP("AMHPST",$J) D PAUSE
 Q
 ;
PRINT1 ;
 I '$D(^TMP("AMHPST",$J)) W !,"No Staging Data in that time period." D PAUSE Q
 S AMHD=0 F  S AMHD=$O(^TMP("AMHPST",$J,AMHD)) Q:AMHD'=+AMHD!(AMHQUIT)  D
 .S AMHX=0 F  S AMHX=$O(^TMP("AMHPST",$J,AMHD,AMHX)) Q:AMHX'=+AMHX!(AMHQUIT)  D
 ..I $Y>(IOSL-8) D HEADING Q:AMHQUIT
 ..S AMHV=$P(^AMHRCDST(AMHX,0),U),AMHR0=^AMHRCDST(AMHX,0)
 ..W !,"Date of Encounter: ",$$FMTE^XLFDT(AMHD),?50,"Days Used Alcohol:",?70,$P(AMHR0,U,6)
 ..W !,"Provider: ",$$PPNAME^AMHUTIL(AMHV),?50,"Days Used Drugs:",?70,$P(AMHR0,U,7)
 ..W !,"Type of Contact: ",$$VAL^XBDIQ1(9002011,AMHV,.32),?50,"Days Hospitalized:",?70,$P(AMHR0,U,8)
 ..W !,"Component Code: ",$$VAL^XBDIQ1(9002011,AMHV,1101),?50,"Alch/Drug Arrests:",?70,$P(AMHR0,U,9)
 ..W !,"Tobacco Use: ",$$VAL^XBDIQ1(9002011.06,AMHX,.11)
 ..W !,$$CTR("STAGES",80)
 ..W !,"Alc/Sub",?10,"Physical",?20,"Emotional",?30,"Social",?40,"Cul/Spir",?50,"Behav",?60,"Voc/Educ",?70,"Average"
 ..W ! S T=3 F X=12:1:18 W ?T,$P(AMHR0,U,X) S T=T+10
 ..W ?70,$$VAL^XBDIQ1(9002011.06,AMHX,.018),!
 ..Q
 .Q
 Q
HEADING ;EP
 G:'AMHPG HEADING1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT="" Q
HEADING1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !,$$LOC,?35,$$FMTE^XLFDT(DT),?70,"Page ",AMHPG,!
 S X="STAGING REPORT for "_$P(^DPT(AMHP,0),U) W !,$$CTR(X,80),!
 S X="Date Range: "_$$FMTE^XLFDT(AMHBD)_" - "_$$FMTE^XLFDT(AMHED) W $$CTR(X),!
 W $TR($J("",80)," ","-"),!
 Q
GATHER ;
 S AMHX=0 F  S AMHX=$O(^AMHRCDST("AC",AMHP,AMHX)) Q:AMHX'=+AMHX  D
 .S Y=$P(^AMHRCDST(AMHX,0),U)
 .Q:'$D(^AMHREC(Y,0))
 .Q:'$$ALLOWVI^AMHUTIL(DUZ,Y)
 .S D=$P($P(^AMHREC(Y,0),U),".")
 .Q:D<AMHBD
 .Q:D>AMHED
 .S ^TMP("AMHPST",$J,D,AMHX)=""
 .Q
 Q
PAUSE ; 
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) AMHQUIT=1
 W:$D(IOF) @IOF
 Q
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
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
 S ^TMP("AMHPST",$J,AMHC,0)=X
 Q
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHPST",$J,""),-1)
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
