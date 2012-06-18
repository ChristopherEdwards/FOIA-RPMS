AGMSPI4 ; IHS/SD/EFG - MSP INTERVIEW PART 4 ;
 ;;7.1;PATIENT REGISTRATION;**8,10**;AUG 25, 2005;Build 7
 ;
EN ;EP -
 W !,"PART IV - Age"
 W !
QUES1 ;ASK QUESTION NUMBER 1
 S DR=".26 1. Are you currently employed ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTIV1=X
 I X="Y" D  Q:$D(Y)                                               ;AG*7.1*8
 . K AG("MCRCHK")
 . S DR=".27 Name of your employer : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 I X="N" D  Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".28 Date of retirement : "
 . D ^DIE
 ;
QUES2 ;ASK QUESTION NUMBER 2
 S DR=".29 Is your spouse currently employed ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTIV2=X
 I X="Y" D  Q:$D(Y)
 . K AG("MCRCHK")
 . S DR=".31 Name of spouse's employer : "
 . D ^DIE
 I X="N" D  Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".32 Date of retirement : "
 . D ^DIE
 ;I $D(AG("MCRCHK")) W !!,"**BASED ON THE PATIENT'S RESPONSE, MEDICARE IS PRIMARY. DO NOT PROCEED FURTHER**"  H 2 Q
 S COND1=(($G(PARTI1)="Y")!($G(PARTI2)="Y")!($G(PARTI3)="Y")!($G(PARTI4)="Y")!($G(PARTII1)="Y")!($G(PARTII2)="Y")!($G(PARTII3)="Y"))
 I ($G(PARTIV1)="N")&($G(PARTIV2)="N") D  Q
 . W !,"If the patient answered no to both questions 1 and 2, Medicare is primary"
 . W !,"unless the patient answered yes to questions in part I and II."
 . S DIR(0)="E"
 . S DIR("A")="STOP. DO NOT PROCEED. Press any key to exit."
 . D ^DIR                                                                 ;AG*7.1*8
 . K DIR
 . Q
 ;
QUES3 ;ASK QUESTION NUMBER 3
 S DR=".33 Do you have group health plan (GHP) coverage based on your own, or a spouse's current employer ? (Y/N) "
 S DIE("NO^")=""
 D ^DIE
 K DIE("NO^")
 S PARTIV3=X
 I X="N" D  Q
 . S DIR(0)="E"
 . S DIR("A")="STOP. Medicare is primary unless the patient answered yes to the question in part I or II."
 . D ^DIR
 . K DIR
QUES4 ;ASK QUESTION NUMBER 4
 S DR=".34 Does the employer that sponsors your GHP employ 20 or more employees ? (Y/N)"
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTIV4=X
 I X="Y" D  Q:$D(Y)
 . W !,"STOP. The GHP is primary. Obtain the following information:"
 . S DR=".35 Name of GHP : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".36 Policy identification number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".37 Group identification number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".38 Name of policy holder : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".39 Relationship to patient : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 E  W !,"STOP. Medicare is primary payer unless the patient answered yes to questions in part I or II."
 S DR=".05////^S X=DUZ"
 D ^DIE
 Q:$D(Y)                                               ;AG*7.1*8
 Q
