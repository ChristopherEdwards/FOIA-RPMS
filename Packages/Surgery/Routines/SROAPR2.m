SROAPR2 ;B'HAM ISC/MAM - PAGE 2 PREOP SCREEN ; 25 MAR 1992  8:15 am
 ;;3.0; Surgery ;**38**;24 Jun 93
 K SRA,SRAO
START Q:SRSOUT  D:SRACLR RET S SRACLR=0 K SRA,SRAO D ^SROAPS2
ASK W !!,"Select Preoperative Information to Edit: " R X:DTIME I '$T!("^"[X) D CONCC^SROAPRE S SRSOUT=1 Q
 S:X="a" X="A" I '$D(SRAO(X)),(X'?1N1":"1N),(X'="A") D HELP Q:SRSOUT  G START
 I X="A" S X="1:2"
 I X?1N1":"1N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>2)!(Y>Z) D HELP Q:SRSOUT  G START
 S SRPAGE="" D HDR^SROAUTL
 I X?1N1":"1N D RANGE G START
 I $D(SRAO(X)),+X=X S EMILY=X D ^SROAPRE2 G START
 I $D(SRAO(X)) W !! S DA=SRTN,DIE=130,DR=$P(SRAO(X),"^",2)_"T" D ^DIE K DA,DIE,DR G START
 S SRSOUT=1 Q
HELP W @IOF,!!!!,"Enter the number, number/letter combination, or range of numbers you want to",!,"edit.  Examples of proper responses are listed below."
 W !!,"1. Enter 'A' to update all information.",!!,"2. Enter a number (1-2) to update the information in that group.  (For",!,"   example, enter '1' to update all Central Nervous System information)"
 W !!,"3. Enter a number/letter combination to update a specific occurrence. (To ",!,"   update Impaired Sensorium, enter '1A')"
 W !!,"4. Enter a range of numbers (1-2) separated by a ':' to enter all",!,"   Central Nervous System and Nutritional/Immune/Other information."
 W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
RANGE ; range of numbers
 F EMILY=1,2 D ^SROAPRE2 Q:SRSOUT
 Q
RET Q:SRSOUT  W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 Q
