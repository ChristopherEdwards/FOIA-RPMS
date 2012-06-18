BGP7SDP ; IHS/CMI/LAB - IHS summary page ; 11 Dec 2006  1:24 PM
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
START ;
 I '$G(BGPAREAA) Q
 I BGPRTYPE'=1 Q
 S BGPQUIT="",BGPGPG=0
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 .S BGPC1=$O(^BGPSCAT("C",BGPC,0))
 .W !
 .W !,$P(^BGPSCAT(BGPC1,0),U)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,0))
 ..I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 ..W !!,$P(^BGPINDAC(BGPPC,14),U,4)
 ..I $P(^BGPINDAC(BGPPC,14),U,7)]"" W !,$P(^BGPINDAC(BGPPC,14),U,7)
 ..I $P(^BGPINDAC(BGPPC,14),U,12)]"" W !,$P(^BGPINDAC(BGPPC,14),U,12)
 ..S F=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,0))
 ..S F=$P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,F),U,4)
 ..W ?46,F,$S($P(^BGPINDAC(BGPPC,0),U,4)["014."!($P(^BGPINDAC(BGPPC,0),U,4)["023.")!($P(^BGPINDAC(BGPPC,0),U,4)["016."):"",1:"%"),?55,$P(^BGPINDAC(BGPPC,14),U,8),?65,$P(^BGPINDAC(BGPPC,14),U,2),?74,$P(^BGPINDAC(BGPPC,14),U,3)
 ..I $P(^BGPINDAC(BGPPC,14),U,9)]""!($P(^BGPINDAC(BGPPC,14),U,10)]"")!($P(^BGPINDAC(BGPPC,14),U,11)]"") W !?55,$TR($P(^BGPINDAC(BGPPC,14),U,9),"$","^"),?64,$TR($P(^BGPINDAC(BGPPC,14),U,10),"$","^"),?73,$P(^BGPINDAC(BGPPC,14),U,11)
 ..S BGPSN=0 F  S BGPSN=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN)) Q:BGPSN'=+BGPSN!(BGPQUIT)  D
 ...S BGPSASU=$P(^BGPGPDCA(BGPSN,0),U,9),X=$O(^AUTTLOC("C",BGPSASU,0)) S BGPSNAM=$S(X:$P(^DIC(4,X,0),U),1:"?????"),BGPSNAM=$S($P(^BGPGPDCA(BGPSN,0),U,17):"+"_BGPSNAM,1:BGPSNAM)
 ...I $P(^BGPINDAC(BGPPC,0),U,4)["014."!($P(^BGPINDAC(BGPPC,0),U,4)["023.")!($P(^BGPINDAC(BGPPC,0),U,4)["016.") D  I 1
 ....I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 ....W !?1,BGPSASU,?8,$E(BGPSNAM,1,12)
 ....W ?20,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U),7,0)
 ....W ?29,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,2),7,0)
 ....W ?38,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,3),7,0)
 ...E  D
 ....I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 ....W !?1,BGPSASU,?8,$E(BGPSNAM,1,12)
 ....W ?20,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U),7,1),"%"
 ....W ?29,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,2),7,1),"%"
 ....W ?38,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,3),7,1),"%"
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
 I BGPRTYPE=1 S X="NATIONAL GPRA MEASURES CLINICAL PERFORMANCE DETAIL" W !,$$CTR(X,80)
 W !?22," Site",?32,"Site",?40,"Site",?46,"Area",?55,"GPRA07",?64,"National",?74,"2010"
 W !?22,"Current",?32,"Prev",?40,"Base",?46,"Current",?55,"Goal",?65,"2006",?74,"Goal"
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
