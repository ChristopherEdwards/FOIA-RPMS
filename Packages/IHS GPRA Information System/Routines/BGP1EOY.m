BGP1EOY ; IHS/CMI/LAB - IHS summary page 17 Jun 2010 11:57 AM 04 Jun 2011 2:01 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;EXECUTIVE ORDER SUMMARY SHEET FOR LOCAL REPORT
 ;
START ;
 ;
 S BGPQUIT="",BGPGPG=0
 I BGPPTYPE="D" G DEL
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HEADER Q:BGPQUIT
 .S BGPC1=$O(^BGPSCAT("E",BGPC,0))
 .W !
 .W !,$P(^BGPSCAT(BGPC1,0),U)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I $Y>(BGPIOSL-4) D HEADER Q:BGPQUIT
 ..D
 ...W !?2,$P(^BGPEOMIB(BGPPC,14),U,4)
 ...I $P(^BGPEOMIB(BGPPC,14),U,7)]"" W !,$P(^BGPEOMIB(BGPPC,14),U,7)
 ...I $P(^BGPEOMIB(BGPPC,14),U,12)]"" W !,$P(^BGPEOMIB(BGPPC,14),U,12)
 ...W ?26,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1),"%"
 ...W ?34,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1),"%"
 ...W ?41,$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1),"%"
 ...W ?56,$TR($P(^BGPEOMIB(BGPPC,14),U,2),"$","^"),?67,$TR($P(^BGPEOMIB(BGPPC,14),U,8),"$","^")
 ...I $P(^BGPEOMIB(BGPPC,14),U,9)]""!($P(^BGPEOMIB(BGPPC,14),U,10)]"")!($P(^BGPEOMIB(BGPPC,14),U,11)]"") W !?56,$TR($P(^BGPEOMIB(BGPPC,14),U,9),"$","^"),?67,$TR($P(^BGPEOMIB(BGPPC,14),U,10),"$","^")
 W !!,"* Represents national rates as of November 12, 2009 for all federal, one Navajo"
 W !,"tribal facility, six Oklahoma tribal facilities, and four Portland tribal"
 W !,"facilities."
 W !!,"**The rates shown in the ""HEDIS or JCAHO"" column represent the most recent"
 W !,"rate available, which may be different from the CRS report period.  The "
 W !,"abbreviations after the rate represent:  HMCD-HEDIS Medicaid, HCOM-HEDIS "
 W !,"Commercial, HMCR-HEDIS Medicare, and JCO-JCAHO."
 D AREASUMP
 Q
 ;
HEADER ;EP
 D HEADER^BGP1EOP
 D H1
 Q
 ;
H1 ;
 S X="EO QUALITY TRANSPARENCY MEASURES CLINICAL PERFORMANCE SUMMARY" W !,$$CTR(X,80)
 I $G(BGPAREAA) W !?26," Area",?34," Area",?43," Area",?56,"Nat'l",?67,"HEDIS or"
 I '$G(BGPAREAA) W !?26," Site",?34," Site",?43," Site",?56,"Nat'l",?67,"HEDIS or"
 W !?26,"Current",?34,"Previous",?43,"Baseline",?56,"2009*",?67,"JCAHO**"
 W !,$TR($J("",80)," ","-")
 ;W !
 Q
AREASUMP ;
 I '$G(BGPAREAA) Q
 S BGPQUIT="",BGPGPG=0
 D HEADERAS
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HEADERAS Q:BGPQUIT
 .S BGPC1=$O(^BGPSCAT("E",BGPC,0))
 .W !
 .W !,$P(^BGPSCAT(BGPC1,0),U)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,0))
 ..I $Y>(BGPIOSL-3) D HEADERAS Q:BGPQUIT
 ..W !!,$P(^BGPEOMIB(BGPPC,14),U,4)
 ..I $P(^BGPEOMIB(BGPPC,14),U,7)]"" W !,$P(^BGPEOMIB(BGPPC,14),U,7)
 ..I $P(^BGPEOMIB(BGPPC,14),U,12)]"" W !,$P(^BGPEOMIB(BGPPC,14),U,12)
 ..S F=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,0))
 ..S F=$P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,F),U,4)
 ..W ?46,F,$S($P(^BGPEOMIB(BGPPC,0),U,4)["014.A"!($P(^BGPEOMIB(BGPPC,0),U,4)["023.")!($P(^BGPEOMIB(BGPPC,0),U,4)="016.A.1"):"",1:"%"),?56,$P(^BGPEOMIB(BGPPC,14),U,2),?67,$P(^BGPEOMIB(BGPPC,14),U,8)
 ..I $P(^BGPEOMIB(BGPPC,14),U,9)]""!($P(^BGPEOMIB(BGPPC,14),U,10)]"")!($P(^BGPEOMIB(BGPPC,14),U,11)]"") W !?55,$TR($P(^BGPEOMIB(BGPPC,14),U,9),"$","^"),?64,$TR($P(^BGPEOMIB(BGPPC,14),U,10),"$","^"),?73,$P(^BGPEOMIB(BGPPC,14),U,11)
 ..S BGPSN=0 F  S BGPSN=$O(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN)) Q:BGPSN'=+BGPSN!(BGPQUIT)  D
 ...S BGPSASU=$P(^BGPEOCB(BGPSN,0),U,9),X=$O(^AUTTLOC("C",BGPSASU,0)) S BGPSNAM=$S(X:$P(^DIC(4,X,0),U),1:"?????"),BGPSNAM=$S($P(^BGPEOCB(BGPSN,0),U,17):"+"_BGPSNAM,1:BGPSNAM)
 ...D
 ....I $Y>(BGPIOSL-3) D HEADERAS Q:BGPQUIT  W !
 ....W !?1,BGPSASU,?8,$E(BGPSNAM,1,12)
 ....W ?20,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U),7,1),"%"
 ....W ?29,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,2),7,1),"%"
 ....W ?38,$J($P(^TMP($J,"SUMMARY DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,3),7,1),"%"
 W !!,"* Represents national rates as of November 12, 2009 for all federal, one Navajo"
 W !,"tribal facility, six Oklahoma tribal facilities, and four Portland tribal"
 W !,"facilities." W !!,"**The rates shown in the ""HEDIS or JCAHO"" column represent the most recent"
 W !,"rate available, which may be different from the CRS report period.  The "
 W !,"abbreviations after the rate represent:  HMCD-HEDIS Medicaid, HCOM-HEDIS "
 W !,"Commercial, HMCR-HEDIS Medicare, and JCO-JCAHO."
 Q
 ;
HEADERAS ;EP
 D HEADER^BGP1EOP
 D H1AS
 Q
 ;
H1AS ;
 S X="EO QUALITY TRANSPARENCY MEASURES CLINICAL PERFORMANCE DETAIL" W !,$$CTR(X,80)
 W !?26," Site",?34," Site",?43," Site",?56,"Nat'l",?67,"HEDIS or"
 W !?26,"Current",?34,"Previous",?43,"Baseline",?56,"2009*",?67,"JCAHO**"
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
 ;
DEL ;
 D DELH1
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARYDEL",BGPC)) Q:BGPC'=+BGPC  D
 .S X=" " D W^BGP1EOH(X,0,1,BGPPTYPE)
 .S BGPC1=$O(^BGPSCAT("E",BGPC,0))
 .S X=$P(^BGPSCAT(BGPC1,0),U,1) D W^BGP1EOH(X,0,1,BGPPTYPE)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARYDEL",BGPC,BGPO)) Q:BGPO=""  D
 ..S BGPPC=$O(^TMP($J,"SUMMARYDEL",BGPC,BGPO,0))
 ..S X=""
 ..D
 ...S X=$P(^BGPEOMIB(BGPPC,14),U,4)
 ...I $P(^BGPEOMIB(BGPPC,14),U,7)]"" D W^BGP1EOH(X,0,1,BGPPTYPE) S X=$P(^BGPEOMIB(BGPPC,14),U,7)
 ...I $P(^BGPEOMIB(BGPPC,14),U,12)]"" D W^BGP1EOH(X,0,1,BGPPTYPE) S X=$P(^BGPEOMIB(BGPPC,14),U,12)
 ...S $P(X,U,2)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U)_"%"
 ...S $P(X,U,3)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U,2)_"%"
 ...S $P(X,U,4)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U,3)_"%"
 ...S $P(X,U,5)=$TR($P(^BGPEOMIB(BGPPC,14),U,2),"$","^")
 ...S $P(X,U,6)=$TR($P(^BGPEOMIB(BGPPC,14),U,8),"$","^")
 ...D W^BGP1EOH(X,0,1,BGPPTYPE)
 ...S X="" I $P(^BGPEOMIB(BGPPC,14),U,9)]""!($P(^BGPEOMIB(BGPPC,14),U,10)]"")!($P(^BGPEOMIB(BGPPC,14),U,11)]"") S $P(X,U,5)=$TR($P(^BGPEOMIB(BGPPC,14),U,9),"$","^"),$P(X,U,6)=$TR($P(^BGPEOMIB(BGPPC,14),U,10),"$","^") D
 ...I X]"" D W^BGP1EOH(X,0,1,BGPPTYPE)
 ;S X=" " D W^BGP1EOH(X,0,1,BGPPTYPE)
 D W^BGP1EOH("* Represents national rates as of November 12, 2009 for all federal, one Navajo",0,2,BGPPTYPE)
 D W^BGP1EOH("tribal facility, six Oklahoma tribal facilities, and four Portland tribal",0,1,BGPPTYPE)
 D W^BGP1EOH("facilities.",0,1,BGPPTYPE)
 D W^BGP1EOH("**The rates shown in the ""HEDIS or JCAHO"" column represent the most recent",0,2,BGPPTYPE)
 D W^BGP1EOH("rate available, which may be different from the CRS report period.  The ",0,1,BGPPTYPE)
 D W^BGP1EOH("abbreviations after the rate represent:  HMCD-HEDIS Medicaid, HCOM-HEDIS ",0,1,BGPPTYPE)
 D W^BGP1EOH("Commercial, HMCR-HEDIS Medicare, and JCO-JCAHO.",0,1,BGPPTYPE)
 I $G(BGPAREAA) D AREASUMD
 Q
 ;
DELH1 ;
 ;
 S X="EO QUALITY TRANSPARENCY MEASURES CLINICAL PERFORMANCE SUMMARY" D W^BGP1EOH(X,0,2,BGPPTYPE)
 I $G(BGPAREAA) S X="",$P(X,U,2)=" Area",$P(X,U,3)=" Area",$P(X,U,4)=" Area",$P(X,U,5)="Nat'l",$P(X,U,6)="HEDIS or" D W^BGP1EOH(X,0,1,BGPPTYPE)
 I '$G(BGPAREAA) S X="",$P(X,U,2)=" Site",$P(X,U,3)=" Site",$P(X,U,4)=" Site",$P(X,U,5)="Nat'l",$P(X,U,6)="HEDIS or" D W^BGP1EOH(X,0,1,BGPPTYPE)
 S X="",$P(X,U,2)="Current",$P(X,U,3)="Previous",$P(X,U,4)="Baseline",$P(X,U,5)="2009*",$P(X,U,6)="JCAHO**" D W^BGP1EOH(X,0,1,BGPPTYPE)
 S X=$TR($J("",80)," ","-") D W^BGP1EOH(X,0,1,BGPPTYPE)
 Q
 ;
H2 ;
 S X=" " D W^BGP1EOH(X,0,2,BGPPTYPE)
 S X="EXECUTIVE ORDER QUALITY TRANSPARENCY MEASURES CLINICAL PERFORMANCE DETAIL" D W^BGP1EOH(X,0,1,BGPPTYPE)
 S X="",$P(X,U,2)=" Site",$P(X,U,3)=" Site",$P(X,U,4)=" Site",$P(X,U,5)="Area",$P(X,U,6)="Nat'l",$P(X,U,7)="HEDIS or" D W^BGP1EOH(X,0,1,BGPPTYPE)
 S X="",$P(X,U,2)="Current",$P(X,U,3)="Previous",$P(X,U,4)="Baseline",$P(X,U,5)="Current",$P(X,U,6)="2009*",$P(X,U,7)="JCAHO**" D W^BGP1EOH(X,0,1,BGPPTYPE)
 S X=$TR($J("",80)," ","-") D W^BGP1EOH(X,0,1,BGPPTYPE)
 Q
AREASUMD ;
SDP ;
 I '$G(BGPAREAA) Q  ;area only
 S BGPQUIT="",BGPGPG=0
 S BGPSUMP=1
 ;S X=" " D W^BGP1EOH(X,0,2,BGPPTYPE)
 D HEADER^BGP1EOP
 D H2
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC)) Q:BGPC'=+BGPC  D
 .S X=" " D W^BGP1EOH(X,0,1,BGPPTYPE)
 .S BGPC1=$O(^BGPSCAT("E",BGPC,0))
 .S X=$P(^BGPSCAT(BGPC1,0),U,1) D W^BGP1EOH(X,0,1,BGPPTYPE)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO)) Q:BGPO=""  D
 ..S BGPPC=$O(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO,0))
 ..S X=" " D W^BGP1EOH(X,0,1,BGPPTYPE)
 ..S XX=" "_$P(^BGPEOMIB(BGPPC,14),U,4)
 ..I $P(^BGPEOMIB(BGPPC,14),U,7)]"" D W^BGP1EOH(XX,0,1,BGPPTYPE) S XX=" "_$P(^BGPEOMIB(BGPPC,14),U,7)
 ..I $P(^BGPEOMIB(BGPPC,14),U,12)]"" D W^BGP1EOH(XX,0,1,BGPPTYPE) S XX=" "_$P(^BGPEOMIB(BGPPC,14),U,12)
 ..S F=$O(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO,BGPPC,0))
 ..S F=$P(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO,BGPPC,F),U,4)
 ..S $P(XX,U,5)=F_$S($P(^BGPEOMIB(BGPPC,0),U,4)["014.A"!($P(^BGPEOMIB(BGPPC,0),U,4)["023.")!($P(^BGPEOMIB(BGPPC,0),U,4)="016.A.1"):"",1:"%")
 ..S $P(XX,U,6)=$P(^BGPEOMIB(BGPPC,14),U,2),$P(XX,U,7)=$P(^BGPEOMIB(BGPPC,14),U,8)
 ..S BGPSN=0,BGPCNT=0 F  S BGPSN=$O(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN)) Q:BGPSN'=+BGPSN  S BGPCNT=BGPCNT+1 D
 ...S BGPSASU=$P(^BGPEOCB(BGPSN,0),U,9),X=$O(^AUTTLOC("C",BGPSASU,0)),BGPSNAM=$S(X:$P(^DIC(4,X,0),U),1:"?????"),BGPSNAM=$S($P(^BGPEOCB(BGPSN,0),U,17):"+"_BGPSNAM,1:BGPSNAM)
 ...D
 ....S $P(X,U,1)=BGPSASU_" "_BGPSNAM
 ....S $P(X,U,2)=$P(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U)_"%"
 ....S $P(X,U,3)=$P(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,2)_"%"
 ....S $P(X,U,4)=$P(^TMP($J,"SUMMARYDEL DETAIL PAGE",BGPC,BGPO,BGPPC,BGPSN),U,3)_"%"
 ...I BGPCNT=1 D W^BGP1EOH(XX,0,1,BGPPTYPE) D
 ....S Y="" I $P(^BGPEOMIB(BGPPC,14),U,9)]""!($P(^BGPEOMIB(BGPPC,14),U,10)]"")!($P(^BGPEOMIB(BGPPC,14),U,11)]"") S $P(Y,U,6)=$TR($P(^BGPEOMIB(BGPPC,14),U,9),"$","^"),$P(Y,U,7)=$TR($P(^BGPEOMIB(BGPPC,14),U,10),"$","^") D
 .....S $P(Y,U,8)=$P(^BGPEOMIB(BGPPC,14),U,11)
 ....I Y]"" D W^BGP1EOH(Y,0,1,BGPPTYPE)
 ...D W^BGP1EOH(X,0,1,BGPPTYPE)
 D W^BGP1EOH("* Represents national rates as of November 12, 2009 for all federal, one Navajo",0,2,BGPPTYPE)
 D W^BGP1EOH("tribal facility, six Oklahoma tribal facilities, and four Portland tribal",0,1,BGPPTYPE)
 D W^BGP1EOH("facilities.",0,1,BGPPTYPE)
 D W^BGP1EOH("**The rates shown in the ""HEDIS or JCAHO"" column represent the most recent",0,2,BGPPTYPE)
 D W^BGP1EOH("rate available, which may be different from the CRS report period.  The ",0,1,BGPPTYPE)
 D W^BGP1EOH("abbreviations after the rate represent:  HMCD-HEDIS Medicaid, HCOM-HEDIS ",0,1,BGPPTYPE)
 D W^BGP1EOH("Commercial, HMCR-HEDIS Medicare, and JCO-JCAHO.",0,1,BGPPTYPE)
 Q
