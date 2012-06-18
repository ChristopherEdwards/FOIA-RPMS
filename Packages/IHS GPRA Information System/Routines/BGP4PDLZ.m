BGP4PDLZ ; IHS/CMI/LAB - ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
START ;
 I BGPRTYPE=3 Q
 I BGPRTYPE=4 Q
 S BGPQUIT="",BGPGPG=0
 D HEADER
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARY",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 .S X=" " D S(X,1,1)
 .I BGPC=1 S X="DIABETES" D S(X,1,1)
 .I BGPC=2 S X="DENTAL" D S(X,1,1)
 .I BGPC=3 S X="IMMUNIZATIONS" D S(X,1,1)
 .I BGPC=4 S X="PREVENTION" D S(X,1,1)
 .I BGPC=5 S X="PUBLIC HEALTH NURSING" D S(X,1,1)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARY",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARY",BGPC,BGPO,0))
 ..I BGPRTYPE=1,$P(^BGPINDFC(BGPPC,0),U,5)'=1 Q  ;gpra and not gpra item
 ..I BGPRTYPE=2,$P(^BGPINDFC(BGPPC,0),U,6)'=1 Q
 ..S X="",X=$P(^BGPINDFC(BGPPC,14),U,4),$E(X,27)=$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U),7,1)_"%",$E(X,37)=$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,2),7,1)_"%",$E(X,48)=$J($P(^TMP($J,"SUMMARY",BGPC,BGPO,BGPPC),U,3),7,1)_"%"
 ..S $E(X,60)=$P(^BGPINDFC(BGPPC,14),U,2),$E(X,71)=$P(^BGPINDFC(BGPPC,14),U,3) D S(X,1,1)
 Q
 ;
HEADER ;EP
 D HEADER^BGP4PDL
 D H1
 Q
H1 ;
 I BGPRTYPE=1 S X="GPRA PERFORMANCE SUMMARY PAGE" D S(X,1,1)
 I BGPRTYPE=2 S X="CLINICAL PERFORMANCE SUMMARY PAGE" D S(X,1,1)
 S X="",$E(X,27)=" Site",$E(X,37)=" Site",$E(X,48)=" Site",$E(X,60)="National",$E(X,71)="National" D S(X,1,1)
 S X="",$E(X,27)="Current",$E(X,37)="Previous",$E(X,48)="Baseline",$E(X,60)="Current",$E(X,71)="Previous"
 S X=$TR($J("",80)," ","-") D S(X,1,1)
 Q
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
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
