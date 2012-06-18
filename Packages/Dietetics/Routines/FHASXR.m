FHASXR ; HISC/REL - Print Screening ;5/10/93  15:10
 ;;5.0;Dietetics;**37**;Oct 11, 1995
F0 R !!,"Print by PATIENT or COMMUNICATION OFFICE or ALL or WARD? WARD// ",X:DTIME G:'$T!(X["^") KIL S:X="" X="W" D TR^FH
 I $P("PATIENT",X,1)'="",$P("WARD",X,1)'="",$P("COMMUNICATION OFFICE",X,1)'="",$P("ALL",X,1)'="" W *7,"  Answer with P or C or A or W" G F0
 G P0:X?1"P".E,W0:X?1"W".E I X?1"A".E S (DFN,ADM,WARD)="" G W1
D0 K DIC S DIC="^FH(119.73,",DIC("A")="Select COMMUNICATION OFFICE: ",DIC(0)="AEQM" W ! D ^DIC K DIC G KIL:"^"[X!$D(DTOUT),D0:Y<1 S WARD=-Y,(DFN,ADM)="" G W1
W0 K DIC S DIC("A")="Select DIETETIC WARD: ",DIC="^FH(119.6,",DIC(0)="AEQM" W ! D ^DIC K DIC G KIL:"^"[X!$D(DTOUT),W0:Y<1 S WARD=+Y,(DFN,ADM)=""
W1 R !!,"Admissions since Date/Time: ",X:DTIME G:'$T!("^"[X) KIL S %DT="EXTS",%DT(0)="-NOW" D ^%DT K %DT G:Y<1 W1 S TIM=Y
 D NOW^%DTC S X1=%\1,X2=-5 D C^%DTC I TIM<X W "  [ DATE CANNOT BE MORE THAN 5 DAYS IN PAST ]" G W1
 G P1
P0 S ALL=1 D ^FHDPA G:'DFN KIL S TIM=""
 I $P($G(^DPT(DFN,.35)),"^",1) W *7,!!?5,"  [ Patient has expired. ]" G KIL
P1 S NP=$P($G(^FH(119.9,1,3)),"^",3) I NP'="A" G P3
P2 R !!,"Include Nutrition Profiles? (Y/N): ",NP:DTIME G:'$T!(NP["^") KIL S:NP="" NP="^" S X=NP D TR^FH S NP=X I $P("YES",NP,1)'="",$P("NO",NP,1)'="" W *7,!,"  Answer YES or NO" G P2
P3 S NP=$S(NP?1"Y".E:1,1:0)
 I NP=0 S FHNUM=9999 G L0
 W ! S DIR(0)="Y",DIR("A")="Would you like to display ALL monitors"
 S DIR("B")="YES" D ^DIR
 I Y="^" Q
 I Y=1 S FHNUM=9999 G L0
 S DIR(0)="N^1:9999"
 S DIR("A")="How many monitors would you like to display?"
 S DIR("B")=20 D ^DIR
 I Y=""!(Y="^") Q
 S FHNUM=Y
L0 K IOP S %ZIS="MQ",%ZIS("B")="HOME" W ! D ^%ZIS K %ZIS,IOP G:POP KIL
 I $D(IO("Q")) S FHPGM="Q0^FHASXR",FHLST="DFN^ADM^WARD^TIM^NP^FHNUM" D EN2^FH G KIL
 U IO D Q0 D ^%ZISC K %ZIS,IOP G KIL
Q0 ; Process Screening
 I DFN D ^FHASXR1 Q
 G Q2:WARD<0,Q3:WARD=""
Q1 F DFN=0:0 S DFN=$O(^FHPT("AW",WARD,DFN)) Q:DFN=""  S ADM=^(DFN),X=$P($G(^DGPM(+ADM,0)),"^",1) I X'<TIM D ^FHASXR1 W:$E(IOST,1,2)'="C-" @IOF Q:ANS="^"
 Q
Q2 S CF=-WARD,WRD=""
 F NN=0:0 S WRD=$O(^FH(119.6,"B",WRD)) Q:WRD=""  S WARD=$O(^FH(119.6,"B",WRD,0)) I $P($G(^FH(119.6,+WARD,0)),"^",8)=CF D Q1
 Q
Q3 S WRD="" F NN=0:0 S WRD=$O(^FH(119.6,"B",WRD)) Q:WRD=""  S WARD=$O(^(WRD,0)) Q:'WARD  D Q1
 Q
KIL G KILL^XUSCLEAN
