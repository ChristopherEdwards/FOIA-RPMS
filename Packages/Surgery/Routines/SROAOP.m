SROAOP ;B'HAM ISC/MAM - ENTER OPERATION INFO ; [ 01/12/99  6:54 AM ]
 ;;3.0; Surgery ;**19,38,47,63,67,81,86,97**;24 Jun 93
 I '$D(SRTN) W !!,"A Surgery Risk Assessment must be selected prior to using this option.",!!,"Press <RET> to continue  " R X:DTIME G END
 S SRSOUT=0 D ^SROAUTL
START G:SRSOUT END K SRAOTH,SRACON D ^SROAOP1
ASK W !!,"Select Operative Information to Edit: " R SRASEL:DTIME I '$T!(SRASEL["^") S SRSOUT=1 G END
 I SRASEL="" G END
 S:SRASEL="a" SRASEL="A" I '$D(SRAO(SRASEL)),(SRASEL'?.N1":".N),(SRASEL'="A") D HELP G:SRSOUT END G START
 I SRASEL="A" S SRASEL="1:13"
 I SRASEL?.N1":".N S Y=$E(SRASEL),Z=$P(SRASEL,":",2) I Y<1!(Z>13)!(Y>Z) D HELP G:SRSOUT END G START
 S MM=$E(SRASEL) I MM'=4,(MM'=5) S SRHDR(.5)=SRDOC D HDR^SROAUTL
 I SRASEL?.N1":".N D RANGE G START
 Q:'$D(SRAO(SRASEL))
 S EMILY=SRASEL D ONE G START
END I 'SRSOUT D ^SROAOP2
 I $D(SRTN) S SROERR=SRTN D ^SROERR0
 W @IOF D ^SRSKILL
 Q
HELP W @IOF,!!!!,"Enter the number or range of numbers you want to edit.  Examples of proper",!,"responses are listed below."
 W !!,"1. Enter 'A' to update all information.",!!,"2. Enter a number (1-13) to update the information in that field.  (For",!,"   example, enter '2' to update Principal Operation.)"
 W !!,"3. Enter a range of numbers (1-13) separated by a ':' to enter a range of",!,"   information.  (For example, enter '1:3' to update Surgical Specialty,",!,"   Principal Operation, and Principal CPT Code.)"
 W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
RANGE ; range of numbers
 S SHEMP=$P(SRASEL,":"),CURLEY=$P(SRASEL,":",2) F EMILY=SHEMP:1:CURLEY Q:SRSOUT  D ONE
 Q
ONE ; edit one item
 I EMILY=10 D ANES Q
 I EMILY=4!(EMILY=5) D:EMILY=4 ^SROTHER D:EMILY=5 CONCUR Q
 I EMILY=6,SRASEL[":",($P(SRASEL,":")'=6) S SRPAGE="" S SRHDR(.5)=SRDOC D HDR^SROAUTL
 K DR,DIE S DA=SRTN,DR=$P(SRAO(EMILY),"^",2)_"T",DIE=130 D ^DIE K DR I $D(Y) S SRSOUT=1
 I EMILY=2!(EMILY=3) D ^SROAUTL
 Q
RET Q:SRSOUT  W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 Q
CONCUR ; concurrent case information
 S SRLINE="" F I=1:1:80 S SRLINE=SRLINE_"-"
 S CON=$P($G(^SRF(SRTN,"CON")),"^") I CON,($P($G(^SRF(CON,30)),"^")!($P($G(^SRF(CON,31)),"^",8))) S CON=""
 S SRPAGE="" D HDR^SROAUTL
 W !,"Concurrent case information cannot be updated using the Risk Assessment",!,"Module.  To update the CPT code of a concurrent case, please use an option",!,"contained within the Operation Menu."
 I CON D CC W !!,"Concurrent Procedure: ",?25,SROPS(1) I $D(SROPS(2)) W !,?25,SROPS(2) I $D(SROPS(3)) W !,?25,SROPS(3) I $D(SROPS(4)) W !,?25,SROPS(4)
 W !!,"Press RETURN to continue " R X:DTIME
 Q
CC ; list concurrent procedure
 S SROPER=$P(^SRF(CON,"OP"),"^") I $P(^("OP"),"^",2) S SROPER=SROPER_" ("_$P(^("OP"),"^",2)_")"
 K SROPS,MM,MMM S:$L(SROPER)<50 SROPS(1)=SROPER
 I $L(SROPER)>49 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 Q
LOOP ; break procedures
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<50  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
ANES K DR,DIE,DA S DA=SRTN,DR=.37,DR(2,130.06)=".01T;.05T;42T",DIE=130 D ^DIE K DR
 Q
