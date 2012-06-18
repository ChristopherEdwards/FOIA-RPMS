BGP5DSP ; IHS/CMI/LAB - IHS summary page ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
START ;
 I BGPRTYPE'=1 Q
 I $G(BGPNPL) Q
 S BGPQUIT="",BGPGPG=0
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 .W !
 .I BGPC=1 W !,"DIABETES GROUP"
 .I BGPC=2 W !,"DENTAL GROUP"
 .I BGPC=3 W !,"IMMUNIZATIONS"
 .I BGPC=4 W !,"CANCER-RELATED"
 .I BGPC=5 W !,"BEHAVIORAL HEALTH"
 .I BGPC=6 W !,"CVD-RELATED"
 .;I BGPC>6 W !
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I $P(^BGPINDVC(BGPPC,0),U,4)["014."!($P(^BGPINDVC(BGPPC,0),U,4)["023.")!($P(^BGPINDVC(BGPPC,0),U,4)["016") D  I 1
 ...W !,$P(^BGPINDVC(BGPPC,14),U,4)
 ...I $P(^BGPINDVC(BGPPC,14),U,7)]"" W !,$P(^BGPINDVC(BGPPC,14),U,7)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,0)
 ...W ?36,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,0)
 ...W ?45,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,0)
 ...W ?55,$P(^BGPINDVC(BGPPC,14),U,8),?64,$P(^BGPINDVC(BGPPC,14),U,2),?73,$P(^BGPINDVC(BGPPC,14),U,3)
 ..E  D
 ...W !,$P(^BGPINDVC(BGPPC,14),U,4)
 ...I $P(^BGPINDVC(BGPPC,14),U,7)]"" W !,$P(^BGPINDVC(BGPPC,14),U,7)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?36,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?45,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?55,$TR($P(^BGPINDVC(BGPPC,14),U,8),"$","^"),?64,$TR($P(^BGPINDVC(BGPPC,14),U,2),"$","^"),?73,$P(^BGPINDVC(BGPPC,14),U,3)
 ...I $P(^BGPINDVC(BGPPC,14),U,9)]""!($P(^BGPINDVC(BGPPC,14),U,10)]"") W !?55,$TR($P(^BGPINDVC(BGPPC,14),U,9),"$","^"),?64,$TR($P(^BGPINDVC(BGPPC,14),U,10),"$","^")
 I $Y>(BGPIOSL-6) D HEADER Q:BGPQUIT
 W !!,"(* - Not GPRA indicator for FY 2005)"
 W !,"(@ - National Retinopathy goal/rate)"
 W !,"(# - Designated site goal/rate)"
 W !,"(& - Data source other than GPRA+)"
 W !,"(** - Age range for IPV/DV changed from 16-24 to 15-40 in 2005)",!
 D ^BGP5SDP
 Q
 ;
HEADER ;EP
 D HEADER^BGP5DPH
 D H1
 Q
H1 ;
 S X="CLINICAL PERFORMANCE SUMMARY PAGE" W !,$$CTR(X,80)
 I $G(BGPAREAA) W !?26," Area",?36," Area",?45," Area",?55,"GPRA05",?64,"Nat'l",?73,"2010"
 I '$G(BGPAREAA) W !?26," Site",?36," Site",?45," Site",?55,"GPRA05",?64,"Nat'l",?73,"2010"
 W !?26,"Current",?36,"Previous",?45,"Baseline",?55,"Goal",?64,"2004",?73,"Goal"
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
