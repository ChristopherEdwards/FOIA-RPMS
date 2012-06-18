BGP4DSP ; IHS/CMI/LAB - IHS summary page ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
START ;
 I BGPRTYPE=3 Q
 I BGPRTYPE=4 Q
 S BGPQUIT="",BGPGPG=0
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 .W !
 .I BGPC=1 W !,"DIABETES (for Active Diabetic patients)"
 .I BGPC=2 W !,"DENTAL"
 .I BGPC=3 W !,"IMMUNIZATIONS"
 .I BGPC=4 W !,"PREVENTION"
 .I BGPC=5 W !,"PREGNANT WOMEN"
 .I BGPC=6 W !
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I BGPRTYPE=1,$P(^BGPINDFC(BGPPC,0),U,5)'=1 Q  ;gpra and not gpra item
 ..I BGPRTYPE=2,$P(^BGPINDFC(BGPPC,0),U,6)'=1 Q
 ..I $P(^BGPINDFC(BGPPC,12),U,4)["10.1"!($P(^BGPINDFC(BGPPC,12),U,4)["40.") D
 ...W !,$P(^BGPINDFC(BGPPC,14),U,4),?27,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,0)
 ...W ?37,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,0)
 ...W ?48,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,0)
 ...W ?60,$P(^BGPINDFC(BGPPC,14),U,2),?71,$P(^BGPINDFC(BGPPC,14),U,3)
 ..E  D
 ...W !,$P(^BGPINDFC(BGPPC,14),U,4),?27,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?37,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?48,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?60,$P(^BGPINDFC(BGPPC,14),U,2),?71,$P(^BGPINDFC(BGPPC,14),U,3)
 W !,"(* = Not GPRA indicator for FY 2004)",!
 Q
 ;
HEADER ;EP
 D HEADER^BGP4DPH
 D H1
 Q
H1 ;
 I BGPRTYPE=1 S X="GPRA PERFORMANCE SUMMARY PAGE" W !,$$CTR(X,80)
 I BGPRTYPE=2 S X="CLINICAL PERFORMANCE SUMMARY PAGE" W !,$$CTR(X,80)
 W !?27," Site",?37," Site",?48," Site",?60,"National",?71,"National"
 W !?27,"Current",?37,"Previous",?48,"Baseline",?60,"FY 2003",?71,"FY 2002"
 W !,$TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
