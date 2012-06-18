BGP7DSP ; IHS/CMI/LAB - IHS summary page ;
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
 .S BGPC1=$O(^BGPSCAT("C",BGPC,0))
 .W !
 .W !,$P(^BGPSCAT(BGPC1,0),U)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I $Y>(BGPIOSL-4) D HEADER Q:BGPQUIT
 ..I $P(^BGPINDAC(BGPPC,0),U,4)["014."!($P(^BGPINDAC(BGPPC,0),U,4)["023.")!($P(^BGPINDAC(BGPPC,0),U,4)["016") D  I 1
 ...W !,$P(^BGPINDAC(BGPPC,14),U,4)
 ...I $P(^BGPINDAC(BGPPC,14),U,7)]"" W !,$P(^BGPINDAC(BGPPC,14),U,7)
 ...I $P(^BGPINDAC(BGPPC,14),U,12)]"" W !,$P(^BGPINDAC(BGPPC,14),U,12)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,0)
 ...W ?34,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,0)
 ...W ?41,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,0)
 ...W ?53,$P(^BGPINDAC(BGPPC,14),U,8),?64,$P(^BGPINDAC(BGPPC,14),U,2),?73,$P(^BGPINDAC(BGPPC,14),U,3)
 ..E  D
 ...W !,$P(^BGPINDAC(BGPPC,14),U,4)
 ...I $P(^BGPINDAC(BGPPC,14),U,7)]"" W !,$P(^BGPINDAC(BGPPC,14),U,7)
 ...I $P(^BGPINDAC(BGPPC,14),U,12)]"" W !,$P(^BGPINDAC(BGPPC,14),U,12)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?34,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?41,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?53,$TR($P(^BGPINDAC(BGPPC,14),U,8),"$","^"),?64,$TR($P(^BGPINDAC(BGPPC,14),U,2),"$","^"),?73,$P(^BGPINDAC(BGPPC,14),U,3)
 ...I $P(^BGPINDAC(BGPPC,14),U,9)]""!($P(^BGPINDAC(BGPPC,14),U,10)]"")!($P(^BGPINDAC(BGPPC,14),U,11)]"") W !?53,$TR($P(^BGPINDAC(BGPPC,14),U,9),"$","^"),?64,$TR($P(^BGPINDAC(BGPPC,14),U,10),"$","^"),?73,$P(^BGPINDAC(BGPPC,14),U,11)
 I $Y>(BGPIOSL-7) D HEADER Q:BGPQUIT
 W !!,"  * Included in the congressional justification as contextual measures."
 W !," ** Diabetes Nephropathy Assessment measure changed in 2007."
 W !,"*** 2006 rate for Childhood 4:3:1:3:3 was reported from Immunization Program;"
 W !,"    not CRS.  The CRS rate using the Immunization Package denominator was"
 W !,"    78.0%."
 W !
 Q
 ;
HEADER ;EP
 D HEADER^BGP7DPH
 D H1
 Q
H1 ;
 S X="NATIONAL GPRA MEASURES CLINICAL PERFORMANCE SUMMARY" W !,$$CTR(X,80)
 I $G(BGPAREAA) W !?26," Area",?34," Area",?43," Area",?53,"GPRA07",?64,"Nat'l",?73,"2010"
 I '$G(BGPAREAA) W !?26," Site",?34," Site",?43," Site",?53,"GPRA07",?64,"Nat'l",?73,"2010"
 W !?26,"Current",?34,"Previous",?43,"Baseline",?53,"Goal",?64,"2006",?73,"Goal"
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
