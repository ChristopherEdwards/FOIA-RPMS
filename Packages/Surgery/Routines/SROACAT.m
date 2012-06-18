SROACAT ;B'HAM ISC/MAM - CARDIAC CATH INFO ; 5 MAR 1992  8:00 am
 ;;3.0; Surgery ;**38,47**;24 Jun 93
 I '$D(SRTN) W !!,"A Surgery Risk Assessment must be selected prior to using this option.",!!,"Press <RET> to continue  " R X:DTIME G END
 S SRACLR=0,SRSOUT=0 D ^SROAUTL
START D:SRACLR RET G:SRSOUT END S SRACLR=0 D ^SROACTH
ASK W !!,"Select Cardiac Catheterization and Angiographic Information to Edit: " R X:DTIME I '$T!("^"[X) G END
 S:X="a" X="A" I '$D(SRAO(X)),(X'?.N1":".N),(X'="A") D HELP G:SRSOUT END G START
 I X="A" S X="1:10"
 I X?.N1":".N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>10)!(Y>Z) D HELP G:SRSOUT END G START
 D HDR^SROAUTL
 I X?.N1":".N D RANGE G START
 I $D(SRAO(X)) S EMILY=X W !! D ONE G START
END I '$D(SREQST) W @IOF D ^SRSKILL
 Q
HELP W @IOF,!!!!,"Enter the number or range of numbers you want to edit.  Examples of proper",!,"responses are listed below."
 W !!,"1. Enter 'A' to update all information.",!!,"2. Enter a number (1-10) to update the information in that field.  (For",!,"   example, enter '3' to update *PA Systolic Pressure)"
 W !!,"3. Enter a range of numbers (1-10) separated by a ':' to enter a range of",!,"   information.  (For example, enter '1:3' to update LVEDP, Aortic",!,"   Systolic Pressure, and *PA Systolic Pressure)"
 W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
RANGE ; range of numbers
 W !! S SHEMP=$P(X,":"),CURLEY=$P(X,":",2) F EMILY=SHEMP:1:CURLEY Q:SRSOUT  D ONE
 Q
ONE ; edit one item
 K DR,DIE S DA=SRTN,DR=$P(SRAO(EMILY),"^",2)_"T",DIE=130 D ^DIE K DR I $D(Y)!$D(DTOUT) S SRSOUT=1
 Q
RET Q:SRSOUT  W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 Q
