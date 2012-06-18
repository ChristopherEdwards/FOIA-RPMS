FHASS ; GLRISC/REL - Nutritional Assessment ; 22-May-88  11:45 am ;  [ 10/18/94  12:17 PM ]
 ;;3.16;DIETETICS;**1**;NOV 01, 1990
 ;
 ;IHS/ORDC/LJF 10/17/94 start of code for PATCH #1
 I '$D(FHZRVN) D
 .S FHNULL="",(FHZRVN,FHZRVF)="FHNULL"
 .I $D(^%ZIS(2,IOST(0),5)) S FHZRVN=$P(^(5),U,4),FHZRVF=$P(^(5),U,5)
 ;IHS/ORDC/LJF 10/17/94 end of code for PATCH #1
 ;
 W @IOF,@FHZRVN,!!?18,"N U T R I T I O N A L   A S S E S S M E N T",?78,"",@FHZRVF,!! S X="T" D ^%DT S DT=Y  ;IHS/ANMC/LJF 9/25/89 added reverse video
F1 ; Select Patient
 S ALL=1,AUPNLK("ALL")="" D ^FHDPA K AUPNLK("ALL") G PAT:X="*",KIL:'DFN S NAM=$P(Y(0),U,1),SEX=$P(Y(0),U,2),AGE=$P(Y(0),U,3) G:SEX=""!(AGE="") P1  ;IHS/ANMC/LJF 5/22/90 added set of AUPNLK("ALL") for universal lookup
 S AGE=$E(DT,1,3)-$E(AGE,1,3)-($E(DT,4,7)<$E(AGE,4,7))
 I AGE<18 W *7,!!?5,"Calories may be inaccurate for ages less than 18!"
F4 R !!,"Height in Inches: ",HGT:DTIME G:"^"[HGT KIL I HGT'?.N.1".".N!(HGT<30)!(HGT>90) W *7,"  Valid range is 30-90" G F4
F5 R !,"Weight in Pounds: ",WGT:DTIME G:"^"[WGT KIL I WGT'?.N.1".".N!(WGT<60)!(WGT>400) W *7,"  Valid range is 60-400" G F5
F50 W !,"Usual Weight in Pounds: ",WGT," // " R UWGT:DTIME G:'$T KIL S:UWGT="" UWGT=WGT G:UWGT="^" KIL I UWGT'?.N.1".".N!(UWGT<60)!(UWGT>400) W *7," ??" G F50
F51 R !,"Frame Size (SMALL, MEDIUM, LARGE) MED// ",FRM:DTIME G:'$T!(FRM="^") KIL S:FRM="" FRM="M" I $P("SMALL",FRM,1)'="",$P("MEDIUM",FRM,1)'="",$P("LARGE",FRM,1)'="" W *7," ??" G F51
 S FRM=$E(FRM,1) S A1=$S(FRM="S":0.9,FRM="L":1.1,1:1)
 I SEX="M" S IBW=HGT-60*6+106*A1
 I SEX="F" S IBW=HGT-60*5+100*A1
TYP R !,"Is Patient an In-Patient? (Y/N): ",TYP:DTIME G:'$T!("^"[TYP) KIL I $P("YES",TYP,1)'="",$P("NO",TYP,1)'="" W *7," ??" G TYP
 S TYP=$E(TYP,1)
F7 R !,"Does Patient have an Amputation? NO// ",AMP:DTIME G:'$T!(AMP="^") KIL S:AMP="" AMP="N" I $P("YES",AMP,1)'="",$P("NO",AMP,1)'="" G F7
 S AMP=$E(AMP,1),AMP=AMP="Y" G:'AMP F9
F71 W !!,"Amputee Types: (may be multiple, e.g: 2,2,5)",!!?2,"1  Upper Leg (11.6%)",?40,"5  Hand (0.8%)",!?2,"2  Below Knee (5.8%)",?40,"6  Forearm (2.3%)"
 W !?2,"3  Above Knee (8.4%)",?40,"7  Upper Arm (3.6%)",!?2,"4  Foot (1.8%)"
F8 S AMP=1 R !!?2,"Type: ",X:DTIME F K=1:1 S Y=$P(X,",",K) Q:Y=""  G:Y'?1N!(Y<1)!(Y>7) F81 S AMP=AMP-$P(".116,.058,.084,.018,.008,.023,.036",",",Y)
 S IBW=$J(AMP*IBW,0,0) G F9
F81 W *7," ?? Enter digits 1-7 separated by commas" G F71
F9 S OPT=$S(.9*IBW'<WGT:"G",1.1*IBW<WGT:"L",1:"M")
 W !!,"Comparison with IBW indicates need for ",$S(OPT="M":"MAINTENANCE",OPT="L":"WEIGHT LOSS",1:"WEIGHT GAIN")
F10 W !!,"Select Option (GAIN WT, LOSE WT, MAINTAIN WT): ",$S(OPT="M":"MAINTAIN",OPT="G":"GAIN",1:"LOSE"),"// " R XX:DTIME G:'$T!(XX="^") KIL
 I $P("GAIN WT",XX,1)'="",$P("LOSE WT",XX,1)'="",$P("MAINTAIN WT",XX,1)'="" W *7,"  Enter G, L, or M" G F10
 S XX=$E(XX,1) S:XX'="" OPT=XX
F11 R !!,"Do you wish Lab/Skinfold Assessment? NO// ",EXT:DTIME G:'$T KIL S:EXT="" EXT="N" G:EXT="^" KIL I $P("YES",EXT,1)'="",$P("NO",EXT,1)'="" W *7," ??" G F11
 S EXT=$E(EXT,1) D:EXT="Y" ^FHASS2 G KIL:EXT="K",^FHASS1
KIL ; Final variable kill
 K %IS,A1,A2,A3,ACT,AF,AGC,AGE,ALL,AMP,BEE,DFN,EXT,DTP,FF,FRM,HGT,IBW,IF,J,K,KCAL,NAM,NIT,OPT,Q,POP,PRO,RTE,SEX,SXC,TAB,TYP,UWGT,WGT,X,XX,Y Q
PAT R !!,"Enter Patient's Name: ",NAM:DTIME G:"^"[NAM KIL
 I NAM["?"!(NAM'?.ANP)!(NAM["^") W *7,!?5,"Enter Patient's Name to be printed on the report." G PAT
P1 R !,"Sex: ",SEX:DTIME G:"^"[SEX KIL I $P("FEMALE",SEX,1)'="",$P("MALE",SEX,1)'="" W *7,"  Enter M or F" G P1
 S SEX=$E(SEX,1)
P2 R !,"Age: ",AGE:DTIME G:"^"[AGE KIL I AGE'?1N.N!(AGE<18)!(AGE>124) W !?5,"Enter Age in years between 18 and 124" G P2
 G F4
