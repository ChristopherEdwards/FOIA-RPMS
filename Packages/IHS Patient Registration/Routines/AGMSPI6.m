AGMSPI6 ; IHS/SD/EFG - MSP INTERVIEW PART 6 ;
 ;;7.1;PATIENT REGISTRATION;**8**;AUG 25, 2005
 ;
EN ;EP -
 W !,"PART VI - ESRD"
 W !
QUES1 ;ASK QUESTION NUMBER 1
 S DR=".54 Do you have group health plan (GHP) coverage ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTVI1=X
 I X="Y" D  Q:$D(Y)
 . S DR=".55 Name of GHP : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".56 Policy identification number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".57 Group identification number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".58 Name of policy holder : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".59 Relationship to patient : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".61 Name of employer, if any, from which you receive GHP coverage : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 E  D  Q                                                                       ;AG*7.1*8
 . S DIR(0)="E"
 . S DIR("A")="STOP. Medicare is primary. Press any key to exit."
 . D ^DIR                                                                 ;AG*7.1*8
 . K DIR
 . Q
 ;
QUES2 ;ASK QUESTION NUMBER 2
 S DR=".62 Have you received a kidney transplant ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTVI2=X
 I X="Y" D  Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".63 Date of transplant : "
 . D ^DIE
QUES3 ;ASK QUESTION NUMBER 3
 S DR=".64 Have you received maintenance dialysis treatments ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTVI3=X
 I X="Y" D  Q:$D(Y)
 . S DR=".65 Date dialysis began : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".66 If you participated in a self dialysis training program, provide date training started : "
 . D ^DIE
QUES4 ;ASK QUESTION NUMBER 4
 S DR=".67 Are you within the 30 month coordination period ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTVI4=X
 I X="N" D  Q                                                                ;AG*7.1*8
 . S DIR(0)="E"
 . S DIR("A")="STOP. Medicare is primary.ENTER <RETURN> TO CONTINUE"
 . D ^DIR
 . K DIR
 . Q
 ;
QUES5 ;ASK QUESTION NUMBER 5
 S DR=".68 Are you entitled to Medicare on the basis of either ESRD and age or ESRD and disability ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTVI5=X
 I X="N" D  Q                                                                ;AG*7.1*8
 . S DIR(0)="E"
 . S DIR("A")="STOP. The group health plan (GHP) is primary during the 30-month coordinator period. Press <ENTER> to continue."
 . D ^DIR
 . K DIR
 . Q
 ;
QUES6 ;ASK QUESTION NUMBER 6
 S DR=".69 Was your initial entitlement to Medicare (insluding simultaneous entitlement) based on ESRD ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTVI6=X
 I X="Y" D  Q                                                                ;AG*7.1*8
 . S DIR(0)="E"
 . S DIR("A")="STOP. The GHP continues to pay primary during the 30-month coordination period. ENTER <RETURN> TO CONTINUE"
 . D ^DIR
 . K DIR
 . Q
 W !,"Initial entitlement is based on age or disability."
QUES7 ;ASK QUESTION NUMBER 7
 S DR=".71 Does the working aged or disability MSP provision apply (i.e., is the GHP primary based on age or disability entitlement ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTVI7=X
 I X="Y" W !,"The GHP continues to pay primary during the 30-month coordination period."
 E  W !,"Medicare continues to pay primary."
 S DR=".05////^S X=DUZ"
 D ^DIE
 Q
