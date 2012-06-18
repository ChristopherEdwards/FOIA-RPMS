CIMGAGPH ;IHS/CMI/LAB - cover page for gpra [ 03/09/00  8:53 AM ]
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("Cover Page")
 W !!,$$CTR("Aberdeen Area GPRA Report")
 W !,$$CTR("Date Report Run: "_$$FMTE^XLFDT(DT))
 W !,$$CTR("Site where Run: "_$P(^DIC(4,DUZ(2),0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(CIMBD)_" to "_$$FMTE^XLFDT(CIMED) W !,$$CTR(X,80)
 S X="Baseline Period:  "_$$FMTE^XLFDT(CIM98B)_" to "_$$FMTE^XLFDT(CIM98E) W !,$$CTR(X,80)
 W !!?10,"The following communities are included in this report:",!
 NEW CIMX
 S CIMX="" F  S CIMX=$O(CIMTAX(CIMX)) Q:CIMX=""  D
 .I $Y>(IOSL-4) D EOP W:$D(IOF) @IOF
 .W !?15,CIMX
 .Q
 K CIMX,CIMQUIT
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
