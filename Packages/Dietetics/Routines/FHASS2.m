FHASS2 ; GLRISC/REL - Extended Assessment ; 24-Jul-85  2:26 pm [ 06/07/90  12:32 PM ]
 ;;3.16;NUTRITION & DIETETICS;;*;;1NOV90
 S SXC=SEX?1"F",AGC=$S(AGE<25:1,AGE<35:2,AGE<45:3,AGE<55:4,AGE<65:5,1:6)
 F J=1:1:9 S Y(J)=""
F1 R !!,"Albumin (g/dl): ",X(1):DTIME G KIL:'$T!(X(1)["^"),F2:X(1)=""
 I X(1)'?.N.1".".N!(X(1)<0)!(X(1)>5) W !?5,"Normal = 3.0-3.5; Values must be 0-5.0" G F1
 S Y(1)=$S(X(1)<2.5:4,X(1)<3.0:3,X(1)<3.5:2,1:1)
F2 R !,"Pre-albumin (mg/dl): ",X(10):DTIME G KIL:'$T!(X(10)["^"),F31:X(10)=""
 I X(10)'?1N.N!(X(10)<0)!(X(10)>25) W !?5,"Enter a whole number between 0 and 25; see User Manual" G F2
F31 R !,"Total Lymphocyte Count: ",X(2):DTIME G KIL:'$T!(X(2)["^"),F3:X(2)=""
 I X(2)'?1N.N!(X(2)<200)!(X(2)>2500) W !?5,"Enter a number 200-2500; see User Manual" G F31
 G F41
F3 R !,"Lymphs (%): ",X(2):DTIME G KIL:'$T!(X(2)["^"),F49:X(2)=""
 I X(2)'?.N.1".".N!(X(2)<0)!(X(2)>100) W !?5,"Enter a percentage between 0 and 100; total will be calculated" G F3
F4 R !,"WBC (cmm): ",X(3):DTIME G KIL:'$T!(X(3)["^") I X(3)="" S X(2)="" G F49
 I X(3)'?1N.N!(X(3)<500)!(X(3)>15000) W !?5,"Enter number between 500-15000; normal = 4800-10800;",!?5,"values outside this range should not be used." G F4
 S X(2)=X(2)*X(3)/100
F41 S Y(2)=$S(X(2)<900:4,X(2)<1500:3,X(2)<1800:2,1:1)
F49 R !,"Transferrin (mg/dl): ",X(4):DTIME G KIL:'$T!(X(4)["^"),F5:X(4)=""
 I X(4)'?.N.1".".N!(X(4)<50)!(X(4)>450) W !?5,"Enter 50-450; see User Manual" G F49
 G F55
F5 R !,"TIBC (mcg/dl): ",X(4):DTIME G KIL:'$T!(X(4)["^"),F6:X(4)=""
 I X(4)'?.N.1".".N!(X(4)<50)!(X(4)>550) W !?5,"Enter 50-550; Normal = 250-410; Transferrin will be evaluated." G F5
 S X(4)=X(4)*0.76+18
F55 S Y(4)=$S(X(4)<160:4,X(4)<180:3,X(4)<200:2,1:1)
F6 R !,"TSF (mm): ",X(5):DTIME G KIL:'$T!(X(5)["^"),F7:X(5)=""
 I X(5)'?.N.1".".N!(X(5)<1)!(X(5)>35) W !?5,"Enter value between 1 and 35; outside values should be assessed manually" G F6
 S K=5,TAB="T1" D GET
F7 R !,"Arm Circumference (cm): ",X(6):DTIME G KIL:'$T!(X(6)["^"),F8:X(6)=""
 I X(6)'?.N.1".".N!(X(6)<15)!(X(6)>35) W !?5,"Enter number between 15 and 35; outside values should be assessed manually" G F7
 S K=6,TAB="T2" D GET
F8 R !,"S. Creatinine (mg/dl) for Creat. Clr.: ",X(11):DTIME G KIL:'$T!(X(11)["^"),F9:X(11)=""
 I X(11)'?.N.1".".N!(X(11)<0)!(X(11)>2.5) W !?5,"Enter 0-2.5; Normal = .7-1.4; creatine clearance will be calculated" G F8
F9 R !,"Protein Intake (g) for Nit. Bal.: ",X(7):DTIME G KIL:'$T!(X(7)["^"),F11:X(7)=""
 I X(7)'?.N.1".".N!(X(7)<0)!(X(7)>200) W !?5,"Enter 0-200 grams of protein intake" G F9
F10 R !,"24 Hour UUN: ",X(8):DTIME G KIL:'$T!(X(8)["^"),F11:X(8)=""
 I X(8)'?.N.1".".N!(X(8)<0)!(X(8)>20) W !?5,"Enter 0-20; nitrogen balance will be calculated" G F10
 S Y(7)=X(7)/6.25-(X(8)+3)
F11 S X(9)="" I X(6)'="",X(5)'="" S X(9)=X(6)-(.314*X(5))
 S K=9,TAB="T3" D GET W ! Q
KIL S EXT="K" Q
GET S Y(K)="" Q:X(K)=""  S Q=$P($T(@TAB+SXC),";",AGC*3,AGC*3+2)
 S A1=$P(Q,";",1),A2=$P(Q,";",2),A3=$P(Q,";",3)
 S Y(K)=$S(X(K)<A1:4,X(K)<A2:3,X(K)<A3:2,1:1) Q
T1 ;;4.0;5.1;7.1;4.5;5.6;8.1;5.0;6.1;8.6;5.0;6.1;8.1;5.0;6.1;8.1;4.5;5.6;8.1
 ;;9.4;11.1;14.1;10.5;12.1;16.1;12.0;14.1;18.1;13.0;15.1;20.1;11.0;14.1;19.1;11.5;14.1;18.1
T2 ;;25.7;27.2;28.8;27.0;28.3;30.1;27.8;28.8;30.8;26.7;27.9;30.1;25.6;27.4;29.7;25.3;26.6;28.6
 ;;22.1;23.1;24.6;23.3;24.3;25.8;24.1;25.3;26.9;24.3;25.8;27.6;23.9;25.2;27.8;23.8;25.3;27.5
T3 ;;23.5;24.5;25.6;24.2;25.4;26.6;25.0;25.7;27.2;24.0;25.0;26.6;22.8;24.5;26.3;22.5;23.8;25.4
 ;;17.7;18.6;19.5;18.3;19.0;20.1;18.5;19.3;20.7;18.8;19.6;20.8;18.6;19.6;20.9;18.6;19.6;20.9
