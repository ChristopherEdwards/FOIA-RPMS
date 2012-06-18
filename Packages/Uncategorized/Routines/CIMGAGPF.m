CIMGAGPF ; CMI/TUCSON/LAB - aberdeen gpra print ;   [ 03/14/00  9:47 AM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
INJ ;tally injuries
 D TALLY
 D PRINTJ
 Q
TALLY ;
 D HEADER Q:CIMQUIT
 K ^TMP($J,"INJ")
 S CIMBLTOT=0
 S CIMRPTOT=0
 S CIMXX=0 F  S CIMXX=$O(CIMSUL(CIMXX)) Q:CIMXX'=+CIMXX  D
 .S CIMBLTOT=CIMBLTOT+$P($G(^CIMAGP(CIMXX,23)),U,11),T=$P($G(^CIMAGP(CIMXX,23)),U,11)
 .I T S X=0 F  S X=$O(^CIMAGP(CIMXX,25,X)) Q:X'=+X  S I=$P(^CIMAGP(CIMXX,25,X,0),U),J="Z"_I,C=$P(^(0),U,2),D=$P(^(0),U,3),$P(^TMP($J,"INJ",J),U)=D,$P(^(J),U,2)=$P(^(J),U,2)+C,$P(^(J),U,3)=(($P(^(J),U,2)/CIMBLTOT)*100) D
 ..F Y=5:1:9 S A=$P(^CIMAGP(CIMXX,25,X,0),U,Y) S P=$S(Y=5:6,Y=6:8,Y=7:10,Y=8:12,Y=9:14),P1=$S(Y=5:7,Y=6:9,Y=7:11,Y=8:13,Y=9:15) D
 ...S $P(^TMP($J,"INJ",J),U,P)=$P(^TMP($J,"INJ",J),U,P)+A,$P(^TMP($J,"INJ",J),U,P1)=(($P(^(J),U,P)/$P(^TMP($J,"INJ",J),U,2)*100))
 ..S Y=0 F  S Y=$O(^CIMAGP(CIMXX,25,X,25,Y)) Q:Y'=+Y  S E=$P(^CIMAGP(CIMXX,25,X,25,Y,0),U),Z=$P(^(0),U,2),D=$P(^(0),U,3) D
 ...S $P(^TMP($J,"INJ",J,E),U)=D,$P(^TMP($J,"INJ",J,E),U,2)=$P(^TMP($J,"INJ",J,E),U,2)+Z,$P(^TMP($J,"INJ",J,E),U,3)=(($P(^TMP($J,"INJ",J,E),U,2)/$P(^TMP($J,"INJ",J),U,2)*100))
 .S T=$P($G(^CIMAGP(CIMXX,22)),U,11),CIMRPTOT=CIMRPTOT+T
 .I T S X=0 F  S X=$O(^CIMAGP(CIMXX,24,X)) Q:X'=+X  S I=$P(^CIMAGP(CIMXX,24,X,0),U),J="Z"_I,C=$P(^(0),U,2),D=$P(^(0),U,3),$P(^TMP($J,"INJ",J),U)=D,$P(^(J),U,4)=$P(^(J),U,4)+C,$P(^(J),U,5)=(($P(^(J),U,4)/CIMRPTOT)*100) D
 ..F Y=5:1:9 S A=$P(^CIMAGP(CIMXX,24,X,0),U,Y) S P=$S(Y=5:16,Y=6:18,Y=7:20,Y=8:22,Y=9:24),P1=$S(Y=5:17,Y=6:19,Y=7:21,Y=8:23,Y=9:25) D
 ...S $P(^TMP($J,"INJ",J),U,P)=$P(^TMP($J,"INJ",J),U,P)+A,$P(^TMP($J,"INJ",J),U,P1)=(($P(^(J),U,P)/$P(^TMP($J,"INJ",J),U,4)*100))
 ..S Y=0 F  S Y=$O(^CIMAGP(CIMXX,24,X,24,Y)) Q:Y'=+Y  S E=$P(^CIMAGP(CIMXX,24,X,24,Y,0),U),Z=$P(^(0),U,2),D=$P(^(0),U,3) D
 ...S $P(^TMP($J,"INJ",J,E),U)=D,$P(^TMP($J,"INJ",J,E),U,4)=$P(^TMP($J,"INJ",J,E),U,4)+Z,$P(^TMP($J,"INJ",J,E),U,5)=(($P(^TMP($J,"INJ",J,E),U,4)/$P(^TMP($J,"INJ",J),U,4)*100))
 Q
PRINTJ ;
 S CIMX=0 F  S CIMX=$O(^TMP($J,"INJ",CIMX)) Q:CIMX=""!(CIMQUIT)  D
 .S D=^TMP($J,"INJ",CIMX)
 .I $Y>(IOSL-5) D HEADER Q:CIMQUIT
 .W !!?1,$E(CIMX,2,99),?8,$E($P(D,U),1,28)
 .W ?36,$$C($P(D,U,2),0,9),?44,$J($P(D,U,3),6,1),?54,$$C($P(D,U,4),0,9),?62,$J($P(D,U,5),6,1)
 .W ?72,$J($$CALC($P(D,U,5),$P(D,U,3)),7)
 .W !?5,"# Direct Inpatient",?36,$$C($P(D,U,6),0,9),?44,$J($P(D,U,7),6,1),?54,$$C($P(D,U,16),0,9),?62,$J($P(D,U,17),6,1),?72,$J($$CALC($P(D,U,17),$P(D,U,7)),7)
 .W !?5,"# Direct Outpatient",?36,$$C($P(D,U,8),0,9),?44,$J($P(D,U,9),6,1),?54,$$C($P(D,U,18),0,9),?62,$J($P(D,U,19),6,1),?72,$J($$CALC($P(D,U,19),$P(D,U,9)),7)
 .W !?5,"# Contract Inpatient",?36,$$C($P(D,U,10),0,9),?44,$J($P(D,U,11),6,1),?54,$$C($P(D,U,20),0,9),?62,$J($P(D,U,21),6,1),?72,$J($$CALC($P(D,U,21),$P(D,U,11)),7)
 .W !?5,"# Contract Outpatient",?36,$$C($P(D,U,12),0,9),?44,$J($P(D,U,13),6,1),?54,$$C($P(D,U,22),0,9),?62,$J($P(D,U,23),6,1),?72,$J($$CALC($P(D,U,23),$P(D,U,13)),7)
 .W !?5,"Alcohol Related",?36,$$C($P(D,U,14),0,9),?44,$J($P(D,U,15),6,1),?54,$$C($P(D,U,24),0,9),?62,$J($P(D,U,25),6,1),?72,$J($$CALC($P(D,U,25),$P(D,U,15)),7)
 .;ecode tally
 .S CIMY="" F  S CIMY=$O(^TMP($J,"INJ",CIMX,CIMY)) Q:CIMY=""!(CIMQUIT)  D
 ..S CIMD=^TMP($J,"INJ",CIMX,CIMY)
 ..W !?5,CIMY,?12,$E($P(CIMD,U),1,24)
 ..W ?36,$$C($P(CIMD,U,2),0,9),?44,$J($P(CIMD,U,3),6,1),?54,$$C($P(CIMD,U,4),0,9),?62,$J($P(CIMD,U,5),6,1)
 ..W ?72,$J($$CALC($P(CIMD,U,5),$P(CIMD,U,3)),7)
 ..Q
 Q
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0)!(O="")!(N="") Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 I +O=0 Q "**"
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
HEADER ;EP
 G:'CIMGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S CIMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S CIMGPG=CIMGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",CIMGPG,!
 W !,$$CTR("***  ABERDEEN AREA GPRA INDICATORS  ***",80),!
 W $S(CIMSUCNT=1:$$CTR(CIMSUNM),1:$$CTR("AREA AGGREGATE")),!
 S X="Reporting Period: "_$$FMTE^XLFDT(CIMBD)_" to "_$$FMTE^XLFDT(CIMED) W $$CTR(X,80),!
 S X="Baseline Period:  "_$$FMTE^XLFDT(CIM98B)_" to "_$$FMTE^XLFDT(CIM98E) W $$CTR(X,80),!
 W !,$TR($J("",80)," ","-")
 W !?38,"BASELINE",?45,"   %",?56,"REPORT",?64,"  %",?71,"% CHANGE",!?38,"PERIOD",?56,"PERIOD"
 W !,"Injury Diagnoses and E Codes"
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
