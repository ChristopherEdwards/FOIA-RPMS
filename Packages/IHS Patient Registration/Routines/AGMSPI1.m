AGMSPI1 ; IHS/SD/EFG - MSP INTERVIEW PART 1 ;
 ;;7.1;PATIENT REGISTRATION;**8**;AUG 25, 2005
 ;
EN ;EP -
 W !,"PART I"
 W !
 K DIC,DIE,DA,DR
 S DIE="^AUPNMSP("
 S DA=AG("DA")
 S DR=".02////^S X=DFN"
 D ^DIE
QUES1 ;ASK QUESTION NUMBER 1
 S DR=".06 Are you receiving Black Lung (BL) Benefits ? (Y/N) "
 D ^DIE K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTI1=X
 I X="Y" D
 . K AG("MCRCHK")
 . S DIE="^AUPNMSP("
 . S DR=".07 Date primary benefits begin ? "
 . D ^DIE
 . W !?5,"BL is primary only for claims related to BL"
 . W !
QUES2 ;ASK QUESTION NUMBER 2
 S DR=".08 Are the services to be paid by a government program such as a research grant ? (Y/N) "
 D ^DIE K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTI2=X
 I X="Y" K AG("MCRCHK")
QUES3 ;ASK QUESTION NUMBER 3
 S DR=".09 Has the Department of Veteran Affairs (DVA) authorized and agreed to pay for care at this facility ? (Y/N) "
 D ^DIE K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTI3=X
 I X="Y" K AG("MCRCHK") W !?5,"VA is primary for these services."
QUES4 ;ASK QUESTION NUMBER 4
 S DR=".11 Was the illness/injury due to a work-related accident/condition ? (Y/N) "
 D ^DIE K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTI4=X
 I X="Y" D  Q:$D(Y)
 . K AG("MCRCHK")
 . S DR=".12 Date of injury/illness : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".13 Name of Workman's Comp (WC) plan: "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".14 Patient's policy or identification number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".15 Name of your employer : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . W !,"WC is primary payer only form those claims related to work-related"
 . W !,"injuries or illness. GO TO PART III"
 E  W "  GO TO PART II." D EN^AGMSPI2 Q
 D EN^AGMSPI3
 Q
