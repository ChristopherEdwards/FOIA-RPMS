BGP1HEL ; IHS/CMI/LAB - IHS gpra print 01 Jul 2010 8:00 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
DEL ;
 K ^TMP($J)
 S ^TMP($J,"BGPDEL",0)=0
 D ^BGP1HEHH
 D DEL1
 D ^BGP1HESL ;print lists to delimited file
 ;if screen selected do screen
 I BGPDELT="S" D SCREEN,EXIT Q
 ;call xbgsave to create output file
 K ^TMP($J,"SUMMARYDEL")
 S XBGL="BGPDATA"
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 K ^BGPDATA ;global for saving.  NOTE: Kill of unscripted global.  Export to area, using standard name per SAC.
 S X=0 F  S X=$O(^TMP($J,"BGPDEL",X)) Q:X'=+X  S ^BGPDATA(X)=^TMP($J,"BGPDEL",X)
 I '$D(BGPGUI) D
 .S XBFLT=1,XBFN=BGPDELF_".txt",XBMED="F",XBTLE="CRS 2011 HEDIS DELIMITED OUTPUT",XBQ="N"
 .S XBUF=BGPUF D ^XBGSAVE
 .K XBFLT,XBFN,XBMED,XBTLE,XBE,XBF
 I $D(BGPGUI) D
 .S (C,X)=0 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S C=C+1,^BGPGUIB(BGPGIEN,12,C,0)=^BGPDATA(X)
 .S ^BGPGUIB(BGPGIEN,12,0)="^90546.0812^"_C_"^"_C_"^"_DT
 L -^BGPDATA
 K ^BGPDATA
 D EXIT
 Q
 ;
SCREEN ;
 S X=0 F  S X=$O(^TMP($J,"BGPDEL",X)) Q:X'=+X  W !,^TMP($J,"BGPDEL",X)
 Q
DEL1 ;EP
 S BGPIC=0 F  S BGPIC=$O(BGPIND(BGPIC)) Q:BGPIC=""  D
 .;now print individual measure
 .S X=" " D S(X,1,1),S(X,1,1)
 .S X=$P(^BGPHEIB(BGPIC,0),U,3) D S(X,1,1)
 .S X=" " D S(X,1,1)
 .S X="Denominator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPHEIB(BGPIC,61,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPHEIB(BGPIC,61,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...I $P(^BGPHEIB(BGPIC,61,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...S BGPZ=0 F  S BGPZ=$O(^BGPHEIB(BGPIC,61,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S Y=^BGPHEIB(BGPIC,61,BGPY,1,BGPZ,0) S:BGPZ=1 Y=" - "_Y D S(Y,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .S X="Numerator(s):" D S(X,1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPHEIB(BGPIC,62,"B",BGPX)) Q:BGPX'=+BGPX  D
 ..S BGPY=0 F  S BGPY=$O(^BGPHEIB(BGPIC,62,"B",BGPX,BGPY)) Q:BGPY'=+BGPY  D
 ...I $P(^BGPHEIB(BGPIC,62,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...S BGPZ=0 F  S BGPZ=$O(^BGPHEIB(BGPIC,62,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 ....S X=^BGPHEIB(BGPIC,62,BGPY,1,BGPZ,0) S:BGPZ=1 X=" - "_X D S(X,1,1)
 ....Q
 ...Q
 ..Q
 .S X=" " D S(X,1,1)
 .I $O(^BGPHEIB(BGPIC,11,0)) D S("Logic:",1,1) S BGPX=0 F  S BGPX=$O(^BGPHEIB(BGPIC,11,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPHEIB(BGPIC,11,BGPX,0) D S(X,1,1)
 .I $O(^BGPHEIB(BGPIC,51,0)) D S(" ",1,1) S X="Performance Measure Description :" D S(X,1,1) S BGPX=0 F  S BGPX=$O(^BGPHEIB(BGPIC,51,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPHEIB(BGPIC,51,BGPX,0) D S(X,1,1)
 .S X=" " D S(X,1,1) D S("HEDIS Rates:",1,1)
 .D:'$O(^BGPHEIB(BGPIC,52,0)) S("Not Reported",1,1)
 .S BGPX=0 F  S BGPX=$O(^BGPHEIB(BGPIC,52,BGPX)) Q:BGPX'=+BGPX  D
 ..S X=^BGPHEIB(BGPIC,52,BGPX,0) D S(X,1,1)
 .X ^BGPHEIB(BGPIC,4)
 Q
HEADER ;EP
 S Y=$P(^VA(200,DUZ,0),U,2),$E(Y,35)=$$FMTE^XLFDT(DT) D S(Y,1,1)
 I BGPRTYPE=3 S Y="*** IHS 2011 HEDIS Clinical Performance Report***" D S(Y,1,1)
 I $G(BGPAREAA) S Y="AREA AGGREGATE" D S(Y,1,1)
 I '$G(BGPAREAA) S Y=$P(^DIC(4,DUZ(2),0),U) D S(Y,1,1)
 S X="Date Report Run: "_$$FMTE^XLFDT(DT) D S(X,1,1)
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
