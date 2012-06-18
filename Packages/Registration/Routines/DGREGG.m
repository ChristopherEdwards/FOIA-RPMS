DGREGG ;ALB/MRL - CONTINUATION OF REGISTRATION PROCESS ;16 AUG 88@1303
 ;;5.3;Registration;;Aug 13, 1993
 K DEF S DEF=0 W !! I $D(^DPT(DA,.15))#10,$P(^(.15),"^",2)?7N W !,"Patient is ineligible for benefits." S DEF(1)=1,DEF=1
 I $D(^DPT(DA,.32))#10,$P(^(.32),"^",4)>1 W $S($D(DEF)\10:", He",1:"Patient") W:$X>70 ! W " did not receive an honorable discharge." S DEF(3)=1,DEF=1
 I DEF W !!
 S Y=0,A=$G(^DPT(DFN,.32)) F I=6,11,16 I $P(A,U,I) S:($P(A,U,I)'<2800908) Y=$P(A,U,I) I $P(A,U,I)<2800908 S Y=0 Q
 I Y X ^DD("DD") W !,"Entered Service ",Y,!,"Veteran Must Have Completed at Least 24 Consecutive Months of",!,"Service to be eligible for Care Or has Received a Hardship Discharge",!,"Or has a Service Connected Condition",! K A
 Q
