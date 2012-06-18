SROALEN ;B'HAM ISC/MAM - LAB INFO ; 13 APR 1992  2:30 pm
 ;;3.0; Surgery ;**38**;24 Jun 93
 I '$D(SRTN) W !!,"A Surgery Risk Assessment must be selected prior to using this option.",!!,"Press <RET> to continue  " R X:DTIME G END
 S SRSOUT=0 D ^SROAUTL
START G:SRSOUT END K SRA,SRAO D ^SROALN1,^SROALDP
ASK W !!,"Select Preoperative Laboratory Information to Edit: " R X:DTIME I '$T!(X["^") S SRSOUT=1 D CONCC G END
 I X="" D CONCC,^SROALN2 G END
 S:X="a" X="A" I '$D(SRAO(X)),(X'?.N1":".N),(X'="A") D HELP G:SRSOUT END G START
 I X="A" S X="1:12"
 I X?.N1":".N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>12)!(Y>Z) D HELP G:SRSOUT END G START
 S SRPAGE="" D HDR^SROAUTL
 I X?.N1":".N D RANGE G START
 I $D(SRAO(X)) S EMILY=X D ONE G START
END W @IOF
 Q
HELP W @IOF,!!!!,"Enter the number or range of numbers you want to edit.  Examples of proper",!,"responses are listed below."
 W !!,"1. Enter 'A' to update all information.",!!,"2. Enter a number (1-12) to update the information in that field.  (For",!,"   example, enter '2' to update Preoperative BUN)"
 W !!,"3. Enter a range of numbers (1-12) separated by a ':' to enter a range of",!,"   information.  (For example, enter '1:3' to update Serum Sodium,",!,"   BUN, and Serum Creatinine)"
 W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
RANGE ; range of numbers
 S SRNOMORE=0,SHEMP=$P(X,":"),CURLEY=$P(X,":",2) F EMILY=SHEMP:1:CURLEY Q:SRNOMORE  D ONE
 Q
ONE ; edit one item
 I EMILY>12 K DR,DIE S DA=SRTN,DR=$P(SRAO(EMILY),"^",4)_"T;"_$P(SRAO(EMILY),"^",5)_"T;"_$P(SRAO(EMILY),"^",6)_"T",DIE=130 D ^DIE S:$D(Y) SRNOMORE=1 K DR Q
 K DR,DIE S DA=SRTN,DR=$P(SRAO(EMILY),"^",3)_"T;"_$P(SRAO(EMILY),"^",4)_"T",DIE=130 D ^DIE S:$D(Y) SRNOMORE=1 K DR
 Q
RET Q:SRSOUT  W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 Q
CONCC ; check for concurrent case and update if one exists
 S SRCON=$P($G(^SRF(SRTN,"CON")),"^") Q:'SRCON
 S SRI="" F  S SRI=$O(SRAO(SRI)) Q:SRI=""  S S1=$P(SRAO(SRI),"^",3),S2=$P(SRAO(SRI),"^",4) K DA,DIC,DIQ,DR,SRY D
 .S DA=SRTN,DR=S1_";"_S2,DIC="^SRF(",DIQ="SRY",DIQ(0)="I" D EN^DIQ1 S P1=SRY(130,SRTN,S1,"I") S:P1="" P1="@" S P2=SRY(130,SRTN,S2,"I") S:P2="" P2="@"
 .K DA,DIE,DR S DA=SRCON,DIE=130,DR=S1_"////"_P1_";"_S2_"////"_P2 D ^DIE K DR
 Q
