BGP4PDL ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
DEL ;
 K ^TMP($J)
 S ^TMP($J,"BGPDEL",0)=0
 D ^BGP4PDLH
 D DEL1
 D SUMMARY
 D ^BGP4PDLS ;print lists to delimited file
 ;if screen selected do screen
 I BGPDELT="S" D SCREEN,EXIT Q
 ;call xbgsave to create output file
 S XBGL="TMP("_$J_",""BGPDEL"","
 K ^TMP($J,"SUMMARYDEL")
 S XBFLT=1,XBFN=BGPDELF_".txt",XBMED="F",XBTLE="GPRA 04 DELIMITED OUTPUT",XBQ="N",XBE=$J
 D ^XBGSAVE
 K XBFLT,XBFN,XBMED,XBTLE,XBE,XBF
 D EXIT
 Q
 ;
SCREEN ;
 S X=0 F  S X=$O(^TMP($J,"BGPDEL",X)) Q:X'=+X  W !,^TMP($J,"BGPDEL",X)
 Q
DEL1 ;EP
 S BGPIC=0 F  S BGPIC=$O(BGPIND(BGPIC)) Q:BGPIC=""  D
 .;now print individual indicator
 .S X=" " D S(X,1,1),S(X,1,1)
 .S X=$P(^BGPINDF(BGPIC,0),U,3) D S(X,1,1)
 .S X=" " D S(X,1,1)
 .S X="Denominator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPINDF(BGPIC,61,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPINDF(BGPIC,61,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...I $P(^BGPINDF(BGPIC,61,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...S BGPZ=0 F  S BGPZ=$O(^BGPINDF(BGPIC,61,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S Y=^BGPINDF(BGPIC,61,BGPY,1,BGPZ,0) D S(Y,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .S X="Numerator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPINDF(BGPIC,62,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPINDF(BGPIC,62,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...I $P(^BGPINDF(BGPIC,62,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...S BGPZ=0 F  S BGPZ=$O(^BGPINDF(BGPIC,62,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S X=^BGPINDF(BGPIC,62,BGPY,1,BGPZ,0) D S(X,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPINDF(BGPIC,11,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPINDF(BGPIC,11,BGPX,0) D S(X,1,1)
 .S X=" " D S(X,1,1) S BGPX=0 F  S BGPX=$O(^BGPINDF(BGPIC,51,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPINDF(BGPIC,51,BGPX,0) D S(X,1,1)
 .S X=" " D S(X,1,1) S BGPX=0 F  S BGPX=$O(^BGPINDF(BGPIC,52,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPINDF(BGPIC,52,BGPX,0) D S(X,1,1)
 .X ^BGPINDF(BGPIC,4)
 Q
HEADER ;EP
 S Y=$P(^VA(200,DUZ,0),U,2),$E(Y,35)=$$FMTE^XLFDT(DT) D S(Y,1,1)
 I BGPRTYPE=4 S Y="*** IHS FY04 Clinical Performance Report ***" D S(Y,1,1)
 I BGPRTYPE=1 S Y="*** IHS FY04 GPRA Clinical Performance Indicators ***" D S(Y,1,1)
 I BGPRTYPE=2 S Y="*** IHS FY04 Area Director's Clinical Performance Indicators ***" D S(Y,1,1)
 I BGPRTYPE=3 S Y="*** IHS FY04 HEDIS Clinical Performace ***" D S(Y,1,1)
 I $G(BGPAREAA) S Y=$S(BGPSUCNT=1:BGPSUNM,1:"AREA AGGREGATE") D S(Y,1,1)
 I '$G(BGPAREAA) S Y=$P(^DIC(4,DUZ(2),0),U) D S(Y,1,1)
 S X="Report Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) D S(X,1,1)
 S X="Previous Year Period:  "_$$FMTE^XLFDT(BGPPBD)_" to "_$$FMTE^XLFDT(BGPPED) D S(X,1,1)
 S X="Baseline Period:  "_$$FMTE^XLFDT(BGPBBD)_" to "_$$FMTE^XLFDT(BGPBED) D S(X,1,1)
 S X=$TR($J(""," ","-"),80) D S(X,1,1)
 Q
EXIT ;
 K ^TMP($J)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
SUMMARY ;
 I BGPRTYPE=3 Q
 I BGPRTYPE=4 Q
 S BGPQUIT="",BGPGPG=0
 D HEADER,H1
 S BGPC=0 F  S BGPC=$O(^TMP($J,"SUMMARYDEL",BGPC)) Q:BGPC'=+BGPC!(BGPQUIT)  D
 .S X=" " D S(X,1,1)
 .I BGPC=1 S X="DIABETES" D S(X,1,1)
 .I BGPC=2 S X="DENTAL" D S(X,1,1)
 .I BGPC=3 S X="IMMUNIZATIONS" D S(X,1,1)
 .I BGPC=4 S X="PREVENTION" D S(X,1,1)
 .I BGPC=5 S X="Pregnant Women" D S(X,1,1)
 .S BGPO="" F  S BGPO=$O(^TMP($J,"SUMMARYDEL",BGPC,BGPO)) Q:BGPO=""!(BGPQUIT)  D
 ..S BGPPC=$O(^TMP($J,"SUMMARYDEL",BGPC,BGPO,0))
 ..I BGPRTYPE=1,$P(^BGPINDFC(BGPPC,0),U,5)'=1 Q  ;gpra and not gpra item
 ..I BGPRTYPE=2,$P(^BGPINDFC(BGPPC,0),U,6)'=1 Q
 ..S X=""
 ..I $P(^BGPINDFC(BGPPC,12),U,4)["10.1"!($P(^BGPINDFC(BGPPC,12),U,4)["40.") D
 ...S X=$P(^BGPINDFC(BGPPC,14),U,4),$P(X,U,2)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U)
 ...S $P(X,U,3)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U,2)
 ...S $P(X,U,4)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U,3)
 ...S $P(X,U,5)=$P(^BGPINDFC(BGPPC,14),U,2),$P(X,U,6)=$P(^BGPINDFC(BGPPC,14),U,3)
 ..E  D
 ...S X=$P(^BGPINDFC(BGPPC,14),U,4),$P(X,U,2)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U)_"%"
 ...S $P(X,U,3)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U,2)_"%"
 ...S $P(X,U,4)=$P(^TMP($J,"SUMMARYDEL",BGPC,BGPO,BGPPC),U,3)_"%"
 ...S $P(X,U,5)=$P(^BGPINDFC(BGPPC,14),U,2),$P(X,U,6)=$P(^BGPINDFC(BGPPC,14),U,3)
 ..D S(X,1,1)
 S X=" " D S(X,1,1)
 S X="(* = Not GPRA indicator for FY 2004)" D S(X,1,1)
 Q
 ;
H1 ;
 I BGPRTYPE=1 S X="GPRA PERFORMANCE SUMMARY PAGE" D S(X,1,1)
 I BGPRTYPE=2 S X="CLINICAL PERFORMANCE SUMMARY PAGE" D S(X,1,1)
 S X="",$P(X,U,2)=" Site",$P(X,U,3)=" Site",$P(X,U,4)=" Site",$P(X,U,5)="National",$P(X,U,6)="National" D S(X,1,1)
 S X="",$P(X,U,2)="Current",$P(X,U,3)="Previous",$P(X,U,4)="Baseline",$P(X,U,5)="FY 2003",$P(X,U,6)="FY 2002" D S(X,1,1)
 S X=$TR($J("",80)," ","-") D S(X,1,1)
 Q
