BGP4HEL ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
DEL ;
 K ^TMP($J)
 S ^TMP($J,"BGPDEL",0)=0
 D ^BGP4HEHH
 D DEL1
 D ^BGP4HESL ;print lists to delimited file
 ;if screen selected do screen
 I BGPDELT="S" D SCREEN,EXIT Q
 ;call xbgsave to create output file
 S XBGL="TMP("_$J_",""BGPDEL"","
 K ^TMP($J,"SUMMARYDEL")
 S XBFLT=1,XBFN=BGPDELF_".txt",XBMED="F",XBTLE="GPRA 04 HEDIS DELIMITED OUTPUT",XBQ="N",XBE=$J
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
 .S X=$P(^BGPHEIF(BGPIC,0),U,3) D S(X,1,1)
 .S X=" " D S(X,1,1)
 .S X="Denominator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPHEIF(BGPIC,61,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPHEIF(BGPIC,61,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...I $P(^BGPHEIF(BGPIC,61,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...S BGPZ=0 F  S BGPZ=$O(^BGPHEIF(BGPIC,61,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S Y=^BGPHEIF(BGPIC,61,BGPY,1,BGPZ,0) D S(Y,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .S X="Numerator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPHEIF(BGPIC,62,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPHEIF(BGPIC,62,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...I $P(^BGPHEIF(BGPIC,62,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...S BGPZ=0 F  S BGPZ=$O(^BGPHEIF(BGPIC,62,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S X=^BGPHEIF(BGPIC,62,BGPY,1,BGPZ,0) D S(X,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPHEIF(BGPIC,11,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPHEIF(BGPIC,11,BGPX,0) D S(X,1,1)
 .S X=" " D S(X,1,1) S BGPX=0 F  S BGPX=$O(^BGPHEIF(BGPIC,51,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPHEIF(BGPIC,51,BGPX,0) D S(X,1,1)
 .S X=" " D S(X,1,1) S BGPX=0 F  S BGPX=$O(^BGPHEIF(BGPIC,52,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPHEIF(BGPIC,52,BGPX,0) D S(X,1,1)
 .X ^BGPHEIF(BGPIC,4)
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
