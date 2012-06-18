AGMSPI2 ; IHS/SD/EFG - MSP INTERVIEW PART 2 ;
 ;;7.1;PATIENT REGISTRATION;**8**;AUG 25, 2005
 ;
EN ;EP -
 W !,"PART II"
 W !
QUES1 ;ASK QUESTION NUMBER 1
 S DR=".16 Was illness/injury due to a non-work related accident ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTII1=X
 I X="Y" D  Q:$D(Y)                                               ;AG*7.1*8
 . K AG("MCRCHK")
 . S DR=".17 Date of accident : "
 . D ^DIE
 E  W "  GO TO PART III." D EN^AGMSPI3 Q
QUES2 ;ASK QUESTION NUMBER 2
 S DR=".18 What type of accident caused the illness/injury ? (A)utomobile, (N)on_automobile, (O)ther "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTII2=X
 I X="A"!X="N" D  Q:$D(Y)
 . S DR=".19 Name of no-fault or liability insurer : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".21 Insurance claim number : "
 I X="N" W !,"No-fault insurer is primary payer only for those claims related to the accident. GO TO PART III."
QUES3 ;ASK QUESTION NUMBER 3
 S DR=".22 Was another party responsible for this accident ? (Y/N) "
 D ^DIE
 K DIE("NO^")
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTII3=X
 I X="Y" D  Q:$D(Y)
 . S DR=".23 Name of any liability insurer : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . S DR=".24 Insurance claim number : "
 . D ^DIE
 . Q:$D(Y)                                               ;AG*7.1*8
 . W !,"The liability insurer is primary only for those claims related to the"
 . W !,"accident. GO TO PART III."
 W !,"GO TO PART III." D EN^AGMSPI3
 Q
