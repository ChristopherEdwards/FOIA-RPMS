AMHRC2P ; IHS/CMI/LAB - print active client list (using case open/close) ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
PRINT ;
START ;
 S AMH80D="-------------------------------------------------------------------------------"
 S AMHPG=0 D HEAD
 K AMHQ
 W !!?10,"Number of Cases Opened: ",?40,AMHOPEN
 W !!?10,"Number of Cases Admitted:",?40,AMHADMIT
 W !!?10,"Number of Cases Closed:",?40,AMHCLOSE
 W !!?10,"Tally of Dispositions:"
 S AMHX="" F  S AMHX=$O(AMHDISP(AMHX)) Q:AMHX=""!($D(AMHQ))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(AMHQ)
 .W !,?15,AMHX,?50,AMHDISP(AMHX)
 .Q
DONE D DONE^AMHLEIN,^AMHEKL
 Q
HEAD I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",AMHPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W ?20,"TALLY OF CASES OPENED/ADMITTED/CLOSED"
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011.58,.03,AMHPROG) W !,$$CTR^AMHLEIN(X,80)
 I AMHPROV S X=$P(^VA(200,AMHPROV,0),U),Y="Provider:  "_X W !?(80-$L(Y)/2),Y
 W !!,AMH80D
 Q
