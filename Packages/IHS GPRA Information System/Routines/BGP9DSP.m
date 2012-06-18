BGP9DSP ; IHS/CMI/LAB - IHS summary page ;
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
START ;
 I BGPRTYPE'=1 Q
 I $G(BGPNPL) Q  ;not on gpra pat list
 I $G(BGPCPPL) Q  ;not on comp list
 S BGPQUIT="",BGPGPG=0
 D HEADER
 NEW P8,P4,P7,P12
 S P8=$S('$G(BGPNGR09):8,1:13)
 S P4=$S('$G(BGPNGR09):4,1:14)
 S P7=$S('$G(BGPNGR09):7,1:15)
 S P12=$S('$G(BGPNGR09):12,1:16)
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 .S BGPC1=$O(^BGPSCAT("C",BGPC,0))
 .W !
 .W !,$P(^BGPSCAT(BGPC1,0),U)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I $Y>(BGPIOSL-4) D HEADER Q:BGPQUIT
 ..I $P(^BGPINDNC(BGPPC,0),U,4)["014."!($P(^BGPINDNC(BGPPC,0),U,4)["023.")!($P(^BGPINDNC(BGPPC,0),U,4)["016")!($P($G(^BGPINDNC(BGPPC,19)),U,13)) D  I 1
 ...W !,$P(^BGPINDNC(BGPPC,14),U,P4)
 ...I $P(^BGPINDNC(BGPPC,14),U,P7)]"" W !,$P(^BGPINDNC(BGPPC,14),U,P7)
 ...I $P(^BGPINDNC(BGPPC,14),U,P12)]"" W !,$P(^BGPINDNC(BGPPC,14),U,P12)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,0)
 ...W ?34,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,0)
 ...W ?41,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,0)
 ...W ?53,$P(^BGPINDNC(BGPPC,14),U,P8),?64,$P(^BGPINDNC(BGPPC,14),U,2),?73,$P(^BGPINDNC(BGPPC,14),U,3)
 ..E  D
 ...W !,$P(^BGPINDNC(BGPPC,14),U,P4)
 ...I $P(^BGPINDNC(BGPPC,14),U,P7)]"" W !,$P(^BGPINDNC(BGPPC,14),U,P7)
 ...I $P(^BGPINDNC(BGPPC,14),U,P12)]"" W !,$P(^BGPINDNC(BGPPC,14),U,P12)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?34,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?41,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?53,$TR($P(^BGPINDNC(BGPPC,14),U,P8),"$","^"),?64,$TR($P(^BGPINDNC(BGPPC,14),U,2),"$","^"),?73,$P(^BGPINDNC(BGPPC,14),U,3)
 ...I $P(^BGPINDNC(BGPPC,14),U,9)]""!($P(^BGPINDNC(BGPPC,14),U,10)]"")!($P(^BGPINDNC(BGPPC,14),U,11)]"") W !?53,$TR($P(^BGPINDNC(BGPPC,14),U,9),"$","^"),?64,$TR($P(^BGPINDNC(BGPPC,14),U,10),"$","^"),?73,$P(^BGPINDNC(BGPPC,14),U,11)
 I $Y>(BGPIOSL-9) D HEADER Q:BGPQUIT
 I $G(BGPNGR09) D FOOTER10 Q
 W !," * Measure definition changed in 2007."
 W !,"** Not official GPRA measure but included to show percentage of refusals with",!,"respect to GPRA measure."
 W !," + Site Previous and Site Baseline values are not applicable for this measure."
 W !
 Q
FOOTER10 ;EP
 W !,"  * GPRA 2010 targets represented here are preliminary targets since they will"
 W !,"be adjusted for FY 2009 actual results and FY 2010 appropriations."
 W !," ** Measure definition changed in 2007."
 W !,"*** Not official GPRA measure but included to show percentage of refusals with",!,"respect to GPRA measure."
 W !,"  + Site Previous and Site Baseline values are not applicable for this measure."
 W !
 Q
 ;
HEADER ;EP
 D HEADER^BGP9DPH
 D H1
 Q
H1 ;
 S X="OFFICIAL GPRA MEASURES CLINICAL PERFORMANCE SUMMARY" W !,$$CTR(X,80)
 I $G(BGPAREAA) W !?26," Area",?34," Area",?43," Area",?53,$S('$G(BGPNGR09):"GPRA09",1:"GPRA10"),?64,"Nat'l",?73,"2010"
 I '$G(BGPAREAA) W !?26," Site",?34," Site",?43," Site",?53,$S('$G(BGPNGR09):"GPRA09",1:"GPRA10"),?64,"Nat'l",?73,"2010"
 W !?26,"Current",?34,"Previous",?43,"Baseline",?53,"Target"_$S($G(BGPNGR09):"*",1:""),?64,"2008",?73,"Target"
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
