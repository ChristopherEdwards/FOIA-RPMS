SROAPRE ;BIR/MAM - PREOPERATIVE INFO ; [ 05/26/99 11:51 AM ]
 ;;3.0; Surgery ;**38,47,55,88**;24 Jun 93
 I '$D(SRTN) W !!,"A Surgery Risk Assessment must be selected prior to using this option.",!!,"Press <RET> to continue  " R X:DTIME G END
 S (SRSOUT,SRACLR)=0 D ^SROAUTL,DUP^SROAUTL G:SRSOUT END
START D:SRACLR RET G:SRSOUT END S SRACLR=0 K SRA,SRAO D ^SROAPS1
ASK W !!,"Select Preoperative Information to Edit: " R X:DTIME I '$T!(X["^") D CONCC G END
 S:X="" X="+1" S:X="a" X="A" I '$D(SRAO(X)),(X'?.N1":".N),(X'="A"),(X'="+1") D HELP G:SRSOUT END G START
 I X="+1" D CONCC,^SROAPR2 G START
 I X="A" S X="1:5"
 I X?.N1":".N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>5)!(Y>Z) D HELP G:SRSOUT END G START
 S SRPAGE="" D HDR^SROAUTL
 I X?.N1":".N D RANGE G START
 I $D(SRAO(X)),+X=X S EMILY=X W ! D:EMILY<4 ^SROAPRE1 D:EMILY>3 ^SROAPR1A G START
 I $D(SRAO(X)) S SRX=X W ! K DR,DIE S DA=SRTN,DR=$P(SRAO(X),"^",2)_"T",DIE=130 D ^DIE K DR
 G START
END I '$D(SREQST) W @IOF D ^SRSKILL
 Q
HELP W @IOF,!!!!,"Enter the number, number/letter combination, or range of numbers you want to",!,"edit.  Examples of proper responses are listed below."
 W !!,"1. Enter 'A' to update all information.",!!,"2. Enter a number (1-5) to update the information in that group.  (For",!,"   example, enter '4' to update all cardiac information)"
 W !!,"3. Enter a number/letter combination to update a specific occurrence. (To ",!,"   update Current Pneumonia, enter '2C'.)"
 W !!,"4. Enter a range of numbers (1-5) separated by a ':' to enter a range of",!,"   occurrences.  (For example, enter '2:4' to enter all pulmonary,",!,"   hepatobiliary, and cardiac information)"
 W !!,"5. Press <RET> to continue to page 2 of this option."
 W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
RANGE ; range of numbers
 S SHEMP=$P(X,":"),CURLEY=$P(X,":",2) W:SHEMP<9 ! F EMILY=SHEMP:1:CURLEY Q:SRSOUT  D:EMILY<4 ^SROAPRE1 D:EMILY>3 ^SROAPR1A
 Q
RET Q:SRSOUT  W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 Q
CONCC ; check for concurrent case and update if one exists
 S SRCON=$P($G(^SRF(SRTN,"CON")),"^") Q:'SRCON
 Q:$P($G(^SRF(SRCON,"RA")),"^",2)="C"
 S SRI="" F  S SRI=$O(SRAO(SRI)) Q:SRI=""  S SRZ=$P(SRAO(SRI),"^",2) K DA,DIC,DIQ,DR,SRY D
 .S DA=SRTN,DR=SRZ,DIC="^SRF(",DIQ="SRY",DIQ(0)="I" D EN^DIQ1 S SRX=SRY(130,SRTN,SRZ,"I") S:SRX="" SRX="@"
 .K DA,DIE,DR S DA=SRCON,DIE=130,DR=SRZ_"////"_SRX D ^DIE K DR
 Q
