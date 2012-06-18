AGMSPI5 ; IHS/SD/EFG - MSP INTERVIEW PART 5 ;
 ;;7.1;PATIENT REGISTRATION;**8,10**;AUG 25, 2005;Build 7
 ;
EN ;EP -
 W !,"PART V - Disability"
 W !
QUES1 ;ASK QUESTION NUMBER 1
 S DR=".41 Are you currently employed ? (Y/N) "
 D ^DIE
 K DIR("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTV1=X
 I X="Y" D  Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".42 Name of your employer : "
 . D ^DIE
 I X="N" D  Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".43 Date of retirement : "
 . D ^DIE
QUES2 ;ASK QUESTION NUMBER 2
 S DR=".44 Is a family member currently employed ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTV2=X
 I X="Y" D  Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".45 Name of the family member's employer : "
 . D ^DIE
 I ($G(PARTV1)="N")&($G(PARTV2)="N") D  Q                                           ;AG*7.1*8
 . W !,"If the patient answers no to both questions 1 and 2, Medicare is primary"
 . W !,"unless the patient answered yes to questions in part I or II."
 . S DIR(0)="E"
 . S DIR("A")="STOP. DO NOT PROCEED. Press any key to exit."
 . D ^DIR                                                                 ;AG*7.1*8
 . K DIR
 . Q
 ;
QUES3 ;ASK QUESTION NUMBER 3
 S DR=".46 Do you have group health plan (GHP) coverage based on your own, or a family member's current employment ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTV3=X
 ; I X="N" W !,"STOP. Medicare is primary unless the patient answered yes to questions in part I or II." ;AG*7.1*8
QUES4 ;ASK QUESTION NUMBER 4
 S DR=".47 Does the employer that sponsors your GHP employ 100 or more amployees ? (Y/N)"
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTV4=X
 I X="Y" D  Q:$D(Y)
 .W !,"The GHP is primary. Obtain the following information:"
 . S DR=".48 Name of GHP : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".49 Policy identification number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".51 Group identification number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".52 Name of policy holder : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".53 Relationship to patient : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 ; E  W !,"STOP. Medicare is primary unless the patient answered yes to questions in part I and II." ;AG*7.1*8
 S DR=".05////^S X=DUZ"
 D ^DIE
 Q
