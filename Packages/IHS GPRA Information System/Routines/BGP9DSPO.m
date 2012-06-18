BGP9DSPO ; IHS/CMI/LAB - IHS summary page ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
START ;
 I BGPRTYPE'=7 Q
 I $G(BGPNPL) Q  ;not on gpra pat list
 I $G(BGPCPPL) Q  ;not on comp list
 S BGPQUIT="",BGPGPG=0
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY OTHER",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 .S BGPC1=$O(^BGPSCAT("D",BGPC,0))
 .W !
 .W !,$P(^BGPSCAT(BGPC1,0),U)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY OTHER",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY OTHER",BGPC,BGPO,0))
 ..I $Y>(BGPIOSL-4) D HEADER Q:BGPQUIT
 ..I $P(^BGPINDNC(BGPPC,0),U,4)["014."!($P(^BGPINDNC(BGPPC,0),U,4)["023.")!($P(^BGPINDNC(BGPPC,0),U,4)["016")!($P($G(^BGPINDNC(BGPPC,19)),U,13)) D  I 1
 ...W !?1,$P(^BGPINDNC(BGPPC,19),U,4)
 ...I $P(^BGPINDNC(BGPPC,19),U,7)]"" W !?1,$P(^BGPINDNC(BGPPC,19),U,7)
 ...W ?26,$J($P(^TMP($J,"SUMMARY OTHER",BGPC,BGPO,BGPPC),U),7,0)
 ...W ?34,$J($P(^TMP($J,"SUMMARY OTHER",BGPC,BGPO,BGPPC),U,2),7,0)
 ...W ?41,$J($P(^TMP($J,"SUMMARY OTHER",BGPC,BGPO,BGPPC),U,3),7,0)
 ...W ?57,$P(^BGPINDNC(BGPPC,19),U,2),?68,$P(^BGPINDNC(BGPPC,19),U,3)
 ..E  D
 ...W !?1,$P(^BGPINDNC(BGPPC,19),U,4)
 ...I $P(^BGPINDNC(BGPPC,19),U,7)]"" W !?1,$P(^BGPINDNC(BGPPC,19),U,7)
 ...W ?26,$J($P(^TMP($J,"SUMMARY OTHER",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?34,$J($P(^TMP($J,"SUMMARY OTHER",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?41,$J($P(^TMP($J,"SUMMARY OTHER",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?57,$TR($P(^BGPINDNC(BGPPC,19),U,2),"$","^"),?68,$P(^BGPINDNC(BGPPC,19),U,3)
 ...I $P(^BGPINDNC(BGPPC,19),U,9)]""!($P(^BGPINDNC(BGPPC,19),U,10)]"")!($P(^BGPINDNC(BGPPC,19),U,11)]"") W !?57,$TR($P(^BGPINDNC(BGPPC,19),U,10),"$","^"),?68,$P(^BGPINDNC(BGPPC,19),U,11)
 I $Y>(BGPIOSL-2) D HEADER Q:BGPQUIT
 W !
 Q
 ;
HEADER ;EP
 D HEADER^BGP9DPH
 D H1
 Q
H1 ;
 S X="SELECTED OTHER NATIONAL MEASURES CLINICAL PERFORMANCE SUMMARY" W !,$$CTR(X,80)
 I $G(BGPAREAA) W !?26," Area",?34," Area",?43," Area",?57,"Nat'l",?68,"2010"
 I '$G(BGPAREAA) W !?26," Site",?34," Site",?43," Site",?57,"Nat'l",?68,"2010"
 W !?26,"Current",?34,"Previous",?43,"Baseline",?57,"2008",?68,"Target"
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
