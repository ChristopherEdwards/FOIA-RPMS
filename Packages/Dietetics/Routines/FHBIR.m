FHBIR ; HISC/REL - Birthday List ;1/23/98  16:06
 ;;5.0;Dietetics;**13,30**;Oct 11, 1995
 S FHP=$O(^FH(119.73,0)) I FHP'<1,$O(^FH(119.73,FHP))<1 S FHP=0 G R1
R0 R !!,"Select COMMUNICATION OFFICE (or ALL): ",X:DTIME G:'$T!("^"[X) KIL D:X="all" TR^FH I X="ALL" S FHP=0
 E  K DIC S DIC="^FH(119.73,",DIC(0)="EMQ" D ^DIC G:Y<1 R0 S FHP=+Y
R1 S %DT="AEP",%DT("A")="Birthday DATE: " W ! D ^%DT G:Y<1 KIL S DAT=Y
 W ! K IOP,%ZIS S %ZIS("A")="Select LIST Printer: ",%ZIS="MQ" D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q1^FHBIR",FHLST="DAT^FHP" D EN2^FH G KIL
 U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1 ; Process Printing Birthday List
 K ^TMP($J) S PG=0,TYP=$E(DAT,6,7)="00" D NOW^%DTC S NOW=% K %,%H,%I
 F FHWRD=0:0 S FHWRD=$O(^FH(119.6,FHWRD)) Q:FHWRD'>0  S DP=$P(^(FHWRD,0),"^",8) I 'FHP!(DP=FHP) S WRD=$P(^(0),"^",1) F DFN=0:0 S DFN=$O(^FHPT("AW",FHWRD,DFN)) Q:DFN<1  D Q2
 D HDR S NAM="" F K=0:0 S NAM=$O(^TMP($J,NAM)) Q:NAM=""  F DFN=0:0 S DFN=$O(^TMP($J,NAM,DFN)) Q:DFN<1  D Q3
 W ! Q
Q2 S Y0=$G(^DPT(DFN,0)),X=$P(Y0,"^",3) Q:'X
 I 'TYP Q:$E(X,4,7)'=$E(DAT,4,7)
 Q:$E(X,4,5)'=$E(DAT,4,5)
 S BD=$E(X,4,7)_$E($P(Y0,"^",1),1,26),^TMP($J,BD,DFN)=X_"^"_WRD Q
Q3 S X1=^TMP($J,NAM,DFN),DTP=$P(X1,"^",1),WRD=$P(X1,"^",2)
 S RM=$G(^DPT(DFN,.101))
 S DTP=$J(+$E(DTP,6,7),2)_"-"_$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",+$E(DTP,4,5))_"-"_(1700+$E(DTP,1,3))
 D:$Y>(IOSL-10) HDR
 W !,$E(NAM,5,30),?32,$E(WRD,1,10),?44,$E(RM,1,10),?56,DTP Q
HDR N DTP
 W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1,DTP=NOW D DTP^FH W !,DTP,?27,"B I R T H D A Y   L I S T",?74,"Page ",PG
 S DTP=DAT D DTP^FH S DTP=$P(DTP,"-",$S(TYP:2,1:1),2) S:FHP DTP=$P(^FH(119.73,FHP,0),"^",1)_"  "_DTP W !!?(79-$L(DTP)\2),DTP
 W !!,"Name",?32,"Ward",?44,"Room",?57,"Birthday",! Q
KIL K ^TMP($J) G KILL^XUSCLEAN
