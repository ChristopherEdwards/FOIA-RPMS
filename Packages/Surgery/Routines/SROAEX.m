SROAEX ;BIR/MAM - EXCLUSION CRITERIA ; [ 11/22/99  11:49 AM ]
 ;;3.0; Surgery ;**38,47,63,88**;24 Jun 93
 I '$D(SRTN) W !!,"A Surgery Risk Assessment must be selected prior to using this option.",!!,"Press <RET> to continue  " R X:DTIME G END
 S SRACLR=0,SRSOUT=0 D ^SROAUTL
START D:SRACLR RET G:SRSOUT END S SRACLR=0 K SRA,SRAO
 S SR(0)=^SRF(SRTN,0),Y=$P($G(^SRF(SRTN,"RA")),"^",7) D CRITERIA S SRAO(1)=NYUK_"^102"
 S SRAO(2)=$P(SR(0),"^",10)_"^.035",X=$P(SRAO(2),"^") I X'="" S $P(SRAO(2),"^")=$S(X="EL":"ELECTIVE",X="EM":"EMERGENT",X="U":"URGENT",X="A":"ADD ON TODAY (NONEMERGENT)",X="S":"STANDBY",1:"")
 S SHEMP=$P(SR(0),"^",4) S:SHEMP SHEMP=$P(^SRO(137.45,SHEMP,0),"^"),SRAO(3)=SHEMP_"^.04"
 S X=$P(^SRF(SRTN,"OP"),"^",2) I X S Y=$P($$CPT^ICPTCOD(X),"^",2) D SSPRIN^SROCPT S X=Y
 S SRAO(4)=X_"^27"
 D TECH^SROPRIN S:SRTECH="NOT ENTERED" SRTECH="" S SRAO(5)=SRTECH
 S X=$P(SR(0),"^",3),X=$S(X="J":"MAJOR",X="N":"MINOR",1:""),SRAO(6)=X_"^.03"
 D TSTAT^SRO1L1,HDR^SROAUTL
 W !,"1. Exclusion Criteria: ",?35,$P(SRAO(1),"^"),!,"2. Surgical Priority:",?35,$P(SRAO(2),"^"),!,"3. Surgical Specialty:",?35,$P(SRAO(3),"^"),!,"4. Principal Operation (CPT):",?35,$P(SRAO(4),"^")
 W !,"5. Principal Anesthesia Technique: "_$P(SRAO(5),"^"),!,"6. Major or Minor:",?35,$P(SRAO(6),"^"),!! F LINE=1:1:80 W "-"
ASK W !!,"Select Excluded Case Information to Edit: " R X:DTIME I '$T!("^"[X) G END
 S:X="a" X="A" I '$D(SRAO(X)),(X'?.N1":".N),(X'="A") D HELP G:SRSOUT END G START
 I X="A" S X="1:6"
 I X?.N1":".N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>6)!(Y>Z) D HELP G:SRSOUT END G START
 D TSTAT^SRO1L1,HDR^SROAUTL
 I X?.N1":".N D RANGE,AQ G START
 I $D(SRAO(X)) S EMILY=X W !! D ONE,AQ G START
END W @IOF D ^SRSKILL
 Q
HELP W @IOF,!!!!,"Enter the number or range of numbers you want to edit.  Examples of proper",!,"responses are listed below."
 W !!,"1. Enter 'A' to update all information.",!!,"2. Enter a number (1-6) to update the information in that field.  (For",!,"   example, enter '2' to update Surgical Priority)"
 W !!,"3. Enter a range of numbers (1-6) separated by a ':' to enter a range of",!,"   information.  (For example, enter '1:2' to update the Exclusion Criteria ",!,"   and Surgical Priority)"
 W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
AQ ; update transmission status
 K DA,DIK S DIK="^SRF(",DIK(1)=".232^AQ",DA=SRTN D EN1^DIK K DA,DIK
 Q
RANGE ; range of numbers
 W !! S SHEMP=$P(X,":"),CURLEY=$P(X,":",2) F EMILY=SHEMP:1:CURLEY Q:SRSOUT  D ONE
 Q
ONE ; edit one item
 I EMILY=1 D REASON Q
 I EMILY=5 D UPANES Q
 K DR,DIE S DA=SRTN,DR=$P(SRAO(EMILY),"^",2)_"T",DIE=130 D ^DIE K DR I $D(Y) S SRSOUT=1
 I EMILY=4 D ^SROAUTL
 Q
RET Q:SRSOUT  W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 Q
CRITERIA ; expand set of codes for exclusion criteria
 S C=$P(^DD(130,102,0),"^",2) D Y^DIQ S NYUK=Y
 S SHEMP=$P(^SRF(SRTN,0),"^",10),MOE=$S(SHEMP="E":"ELECTIVE",SHEMP="M":"EMERGENCY",SHEMP="U":"URGENT",1:"")
 Q
UPANES K DR,DIE,DA S DA=SRTN,DR=.37,DR(2,130.06)=".01T;.05T;42T",DIE=130 D ^DIE K DR
 Q
REASON W ! K DIR S DIR(0)="130,102",DIR("A")="Reason for not Creating an Assessment",DIR("B")=$P(SRAO(1),"^") D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 I X="@" D DELETE^SRONASS S SRSOUT=1 Q
 I Y K DR,DIE,DA S DA=SRTN,DIE=130,DR="102////"_Y D ^DIE K DA,DIE,DR
 Q
