SROCHDD ;B'HAM ISC/MAM - CHANGE DATE OF DICTATION; [ 12/11/96  12:50 PM ]
 ;;3.0; Surgery ;**48**;24 Jun 93
 K SRNEWOP I '$D(SRTN) D SROPS^SRSTRAN I '$D(SRTN) W @IOF
 Q:'$D(SRTN)  S DFN=$P(^SRF(SRTN,0),"^"),Y=$P(^(0),"^",9) D D^DIQ S SRSDATE=Y,SROP=$P(^SRF(SRTN,"OP"),"^")
 S SRSDATE=$P(SRSDATE,"@")_" "_$P(SRSDATE,"@",2),SRNON=$S($P($G(^SRF(SRTN,"NON")),"^")="Y":1,1:0)
 I 'SRNON S Y=$G(^SRF(SRTN,.1)),SRSUR=$P(Y,"^",4),SRATT=$P(Y,"^",13)
 I SRNON S Y=$G(^SRF(SRTN,"NON")),SRSUR=$P(Y,"^",6),SRATT=$P(Y,"^",7)
 S:SRSUR SRSUR=$P(^VA(200,SRSUR,0),"^") S:SRATT SRATT=$P(^VA(200,SRATT,0),"^") D DEM^VADPT
 W @IOF,!,"Patient: ",?20,VADM(1)_" ("_VA("PID")_")",!,"Case Number: ",?20,SRTN,!,$S(SRNON:"Procedure",1:"Operation")_" Date: ",?20,SRSDATE
 I SRATT'="" W !,"Attending "_$S(SRNON:"Provider",1:"Surgeon")_": ",?20,SRATT
 I SRSUR'="" W !,$S(SRNON:"Provider",1:"Surgeon")_": ",?20,SRSUR
 W ! F LINE=1:1:80 W "-"
 W ! K DR S DIE=130,DA=SRTN,DR="15T" D ^DIE K DR
END W !!,"Press RETURN to continue  " R X:DTIME D ^SRSKILL K SRTN W @IOF
 Q
