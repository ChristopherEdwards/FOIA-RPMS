CIMGAGPJ ;IHS/CMI/LAB - cover page for gpra area [ 03/14/00  8:52 PM ]
 ;
 ;
 S CIMGPG=0 D HEADER
 W !!?1,"Report includes the following facility data:"
 NEW CIMX
 S CIMX="" F  S CIMX=$O(CIMSUL(CIMX)) Q:CIMX=""  D
 .I $Y>(IOSL-5) D EOP W:$D(IOF) @IOF
 .S X=$P(^CIMAGP(CIMX,0),U,5),X=$O(^AUTTLOC("C",X,0)) S X=$S(X:$P(^DIC(4,X,0),U),1:"?????")
 .W !?3,X
 .W !?5,"Communities: " S X=0,N=0,Y="" F  S X=$O(^CIMAGP(CIMX,28,X)) Q:X'=+X  S N=N+1,Y=Y_$S(N=1:"",1:";")_$P(^CIMAGP(CIMX,28,X,0),U)
 .S X=0,C=0 F X=1:3:N W !?10,$E($P(Y,";",X),1,20),?30,$E($P(Y,";",(X+1)),1,20),?60,$E($P(Y,";",(X+2)),1,20)
 .Q
 K CIMX,CIMQUIT
 Q
HEADER ;EP
 G:'CIMGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S CIMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S CIMGPG=CIMGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",CIMGPG,!
 W !,$$CTR("Aberdeen Area GPRA Report")
 W !,$$CTR("Area AGGREGATE Report")
 S X="Reporting Period: "_$$FMTE^XLFDT(CIMBD)_" to "_$$FMTE^XLFDT(CIMED) W !,$$CTR(X,80)
 S X="Baseline Period:  "_$$FMTE^XLFDT(CIM98B)_" to "_$$FMTE^XLFDT(CIM98E) W !,$$CTR(X,80)
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
