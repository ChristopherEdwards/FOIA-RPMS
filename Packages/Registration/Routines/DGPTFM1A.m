DGPTFM1A ;ALB/JDS - MASTER DIAG/OP/PRO CODE HELP ; 09 AUG 8  14:32
 ;;5.3;Registration;;Aug 13, 1993
 ;
HELP W !!,"Enter ",?10,"'D'-To delete an ICD diagnosis",!?10,"'A'-To add an ICD diagnosis",!?10 W:DGPTFE "'M'-To add a new patient movement",!?10,"'X'-To delete a patient movement"
 W:'DGPTFE "'M'-To edit treating specialty transfers which generate",!,?14,"patient movements"
 W !?10,"'C'-To delete a ICD op code",!?10,"'O'-To add an ICD op code",!?10,"'S'-To add a new surgery record",!?10,"'Z'-To delete a surgery record"
 W !?10,"'Q'-To delete a ICD procedure code",!?10,"'P'-To add a new ICD procedure code",!?10,"'T'-To add a new procedure record",!?10,"'R'-To delete a procedure record",!?10,"'E'-To review all procedure segments"
 W !?10,"'V'-To review all patient movements",!?10,"'J'-To review all surgery segments"
 W !?10,"'^' to abort",!?10,"<RET> to continue on to the next screen",!
 W !,"The delete codes (D,C,Q) may be followed by the numbers that are before the",!,"ICD codes, separated by commas. ('D1,2,8' to delete ICD diagnoses 1,2 and 8",!,"if they were on the screen above)"
 R !!,"Enter <RET> to continue: ",ANS:DTIME G ^DGPTFM
