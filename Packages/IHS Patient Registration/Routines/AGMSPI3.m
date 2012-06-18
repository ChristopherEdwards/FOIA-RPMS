AGMSPI3 ; IHS/SD/EFG - MSP INTERVIEW PART 3 ;
 ;;7.1;PATIENT REGISTRATION;**8**;AUG 25, 2005
 ;
EN ;EP -
 W !,"PART III"
 W !
QUES1 ;ASK QUESTION NUMBER 1
 S DR=".25 Are you entitled to Medicare based on (A)ge, (D)isability, or (E)SRD ?"
 D ^DIE
 Q:$D(Y)                                               ;AG*7.1*8
 S PARTIII1=X
 I X="A" D EN^AGMSPI4 Q
 I X="D" D EN^AGMSPI5 Q
 I X="E" D EN^AGMSPI6 Q
 Q
