BGP6DSP ; IHS/CMI/LAB - IHS summary page ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
START ;
 I BGPRTYPE'=1 Q
 I $G(BGPNPL) Q  ;not on gpra pat list
 I $G(BGPCPPL) Q  ;not on comp list
 S BGPQUIT="",BGPGPG=0
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3)!(BGPC=6) D HEADER Q:BGPQUIT
 .W !
 .I BGPC=1 W !,"DIABETES"
 .I BGPC=2 W !,"DENTAL"
 .I BGPC=3 W !,"IMMUNIZATIONS"
 .I BGPC=4 W !,"CANCER-RELATED"
 .I BGPC=5 W !,"BEHAVIORAL HEALTH"
 .I BGPC=6 W !,"CVD-RELATED"
 .I BGPC=7 W !,"OTHER CLINICAL"
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I $Y>(BGPIOSL-4) D HEADER Q:BGPQUIT
 ..I $P(^BGPINDSC(BGPPC,0),U,4)["014."!($P(^BGPINDSC(BGPPC,0),U,4)["023.")!($P(^BGPINDSC(BGPPC,0),U,4)["016") D  I 1
 ...W !,$P(^BGPINDSC(BGPPC,14),U,4)
 ...I $P(^BGPINDSC(BGPPC,14),U,7)]"" W !,$P(^BGPINDSC(BGPPC,14),U,7)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,0)
 ...W ?34,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,0)
 ...W ?41,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,0)
 ...W ?53,$P(^BGPINDSC(BGPPC,14),U,8),?64,$P(^BGPINDSC(BGPPC,14),U,2),?73,$P(^BGPINDSC(BGPPC,14),U,3)
 ..E  D
 ...W !,$P(^BGPINDSC(BGPPC,14),U,4)
 ...I $P(^BGPINDSC(BGPPC,14),U,7)]"" W !,$P(^BGPINDSC(BGPPC,14),U,7)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?34,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?41,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?53,$TR($P(^BGPINDSC(BGPPC,14),U,8),"$","^"),?64,$TR($P(^BGPINDSC(BGPPC,14),U,2),"$","^"),?73,$P(^BGPINDSC(BGPPC,14),U,3)
 ...I $P(^BGPINDSC(BGPPC,14),U,9)]""!($P(^BGPINDSC(BGPPC,14),U,10)]"")!($P(^BGPINDSC(BGPPC,14),U,11)]"") W !?53,$TR($P(^BGPINDSC(BGPPC,14),U,9),"$","^"),?64,$TR($P(^BGPINDSC(BGPPC,14),U,10),"$","^"),?73,$P(^BGPINDSC(BGPPC,14),U,11)
 I $Y>(BGPIOSL-6) D HEADER Q:BGPQUIT
 W !!,"(* - Not GPRA measure for FY 2006)"
 W !,"(@ - National Retinopathy goal/rate)"
 W !,"(# - Designated site goal/rate)"
 W !,"(& - Data source other than CRS)"
 W !,"(! - Included in National GPRA report for 2005 but not GPRA measure in 2005)"
 W !,"(** - Age range for IPV/DV changed from 16-24 to 15-40 in 2005)",!
 D ^BGP6SDP
 Q
 ;
HEADER ;EP
 D HEADER^BGP6DPH
 D H1
 Q
H1 ;
 S X="CLINICAL PERFORMANCE SUMMARY" W !,$$CTR(X,80)
 I $G(BGPAREAA) W !?26," Area",?34," Area",?43," Area",?53,"GPRA06",?64,"Nat'l",?73,"2010"
 I '$G(BGPAREAA) W !?26," Site",?34," Site",?43," Site",?53,"GPRA06",?64,"Nat'l",?73,"2010"
 W !?26,"Current",?34,"Previous",?43,"Baseline",?53,"Goal",?64,"2005",?73,"Goal"
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
