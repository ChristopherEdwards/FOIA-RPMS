SROACOP ;BIR/MAM - CARDIAC OPERATIVE RISK SUMMARY ; [ 01/23/01  1:31 PM ]
 ;;3.0; Surgery ;**38,47,71,88,95,107**;24 Jun 93
 I '$D(SRTN) W !!,"A Surgery Risk Assessment must be selected prior to using this option.",!!,"Press <RET> to continue  " R X:DTIME G END
 S SRACLR=0,SRSOUT=0 D ^SROAUTL
START D:SRACLR RET G:SRSOUT END S SRACLR=0 K SRA,SRAO
 F I=206,206.1,208 S SRA(I)=$G(^SRF(SRTN,I))
 I $P(SRA(206),"^",41)="" K DA,DIE,DR S DA=SRTN,DIE=130,DR="472////N" D ^DIE K DA,DIE,DR S SRA(206)=$G(^SRF(SRTN,206))
 S Y=$P($G(^SRF(SRTN,1.1)),"^",3),C=$P(^DD(130,1.13,0),"^",2) D:Y'="" Y^DIQ S SRAO(2)=Y_"^1.13"
 S SRAO(1)=$P(SRA(206),"^",31)_"^364",SRAO(3)=$P(SRA(208),"^",12)_"^414"
 S Y=$P(SRA(206),"^",32) D DT S SRAO("1A")=X_"^364.1"
 S X=$P(SRA(208),"^"),SRAO(4)=$S(X="Y":"YES",X="N":"NO",1:"")_"^384"
 S Y=$P(SRAO(3),"^") I Y'="" S C=$P(^DD(130,414,0),"^",2) D Y^DIQ S $P(SRAO(3),"^")=Y
 S Y=$P(SRA(208),"^",13) D DT S SRAO("3A")=X_"^414.1"
 S Y=$P($G(^SRF(SRTN,.2)),"^",2) D DT S SRAO(5)=X_"^.22"
 S Y=$P($G(^SRF(SRTN,.2)),"^",3) D DT S SRAO(6)=X_"^.23"
 S SRAO(8)="",SRAO(9)=SRA(206.1)_"^430"
 S NYUK=$P(SRA(206),"^",41) D YN S SRAO(10)=SHEMP_"^472"
 S SRPAGE="PAGE: 1" D HDR^SROAUTL
 S X=$P(SRAO(1),"^"),X=$S(X?1.3N:X_"%",1:X) W !," 1. Physician's Preoperative Estimate of Operative Mortality: "_X
 S X=$P(SRAO("1A"),"^") I X'="" W !,?3," A. Date/Time Collected:    "_X
 W !," 2. ASA Classification:",?31,$P(SRAO(2),"^"),!," 3. Surgical Priority:",?31,$P(SRAO(3),"^")
 S X=$P(SRAO("3A"),"^") I X'="" W !,?3," A. Date/Time Collected:    "_X
 S X=$P(^SRF(SRTN,"OP"),"^",2) I X S Y=$P($$CPT^ICPTCOD(X),"^",2) D SSPRIN^SROCPT S X=Y
 S SRAO(7)=X_"^27"
 W !," 4. Operative Death:",?31,$P(SRAO(4),"^"),!," 5. Date/Time Operation Began:",?31,$P(SRAO(5),"^"),!," 6. Date/Time Operation Ended:",?31,$P(SRAO(6),"^")
 W !," 7. Principal CPT Code: ",?31,$P(SRAO(7),"^"),!," 8. Other Procedures CPT Code:" W:$O(^SRF(SRTN,13,0)) ?31,"***INFORMATION ENTERED***"
 W !," 9. Preoperative Risk Factors: "
 I $P(SRAO(9),"^")'="" S SRQ=0 S X=$P(SRAO(9),"^") W:$L(X)<49 X,! I $L(X)>48 S Z=$L(X) D
 .I X'[" " W ?25,X Q
 .S I=0,LINE=1 F  S SRL=$S(LINE=1:48,1:80) D  Q:SRQ
 ..I $E(X,1,SRL)'[" " W X,! S SRQ=1 Q
 ..S J=SRL-I,Y=$E(X,J),I=I+1 I Y=" " W $E(X,1,J-1),! S X=$E(X,J+1,Z),Z=$L(X),I=0,LINE=LINE+1 I Z<SRL W X S SRQ=1 Q
 W !,"10. Cardiac Surgery to Non-VA Facility: ",?40,$P(SRAO(10),"^")
 W !! F MOE=1:1:80 W "-"
ASK W !,"Select Operative Risk Summary Information to Edit: " R X:DTIME I '$T!("^"[X) G END
 S:X="a" X="A" I '$D(SRAO(X)),(X'?.N1":".N),(X'="A") D HELP G:SRSOUT END G START
 I X="A" S X="1:10"
 I X?.N1":".N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>10)!(Y>Z) D HELP G:SRSOUT END G START
 I X'=8 D HDR^SROAUTL
 I X?.N1":".N D RANGE S SROERR=SRTN D ^SROERR0 G START
 I $D(SRAO(X))!(X=9) S EMILY=X W !! D ONE S SROERR=SRTN D ^SROERR0 G START
END I '$D(SREQST) W @IOF D ^SRSKILL
 Q
DT I 'Y S X="" Q
 X ^DD("DD") S X=$P(Y,"@")_" "_$P(Y,"@",2)
 Q
HELP W @IOF,!!!!,"Enter the number or range of numbers you want to edit.  Examples of proper",!,"responses are listed below."
 W !!,"1. Enter 'A' to update all information.",!!,"2. Enter the corresponding number to update the information in a particular",!,"   field.  (For example, enter '3' to update Surgical Priority)"
 W !!,"3. Enter two numbers separated by a ':' to enter a range of information.",!,"   (For example, enter '1:2' to update Physician's Preoperative Estimate of",!,"   Mortality and ASA Classification.)"
 W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
RANGE ; range of numbers
 W !! S SHEMP=$P(X,":"),CURLEY=$P(X,":",2) F EMILY=SHEMP:1:CURLEY Q:SRSOUT  D ONE
 Q
ONE ; edit one item
 I EMILY=8 D ^SROTHER Q
 K DR,DIE S DA=SRTN,DIE=130,DR=$P(SRAO(EMILY),"^",2)
 I EMILY=10!(EMILY=11) S DR=DR_"T//^S X=""N""" D ^DIE K DR S:$D(Y) SRSOUT=1 Q
 S DR=DR_"T",DIE=130 S DR=DR_$S(EMILY=1:";364.1T",EMILY=3:";414.1T",1:"") D ^DIE K DR I $D(Y) S SRSOUT=1
 I EMILY=7 D ^SROAUTL
 Q
RET Q:SRSOUT  W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 Q
NOW ; update date/time of estimate of mortality
 N X D NOW^%DTC S $P(^SRF(DA,206),"^",32)=$E(%,1,12)
 Q
KNOW ; delete date/time of estimate of mortality
 S $P(^SRF(DA,206),"^",32)=""
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"Unknown",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
