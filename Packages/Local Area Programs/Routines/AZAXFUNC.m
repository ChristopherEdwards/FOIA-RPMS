AZAXFUNC ;IHS/PHXAO/AEF - INSTALL AZAXHRN FUNCTION
 ;;1.0;ANNE'S SPECIAL ROUTINES;;AUG 19, 2004
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine installs the AZAXHRN function into the FUNCTION
 ;;file #.5.
 ;;
 ;;$$END
 ;
 N I,X
 F I=1:1 S X=$T(DESC+I) Q:X["$$END"  W !,$P(X,";;",2)
 Q
EN ;EP -- MAIN ENTRY POINT
 ;
 N Y
 ;
 D LOOKUP("AZAXHRN",.Y)
 I +Y>0 D  Q
 . W !,"LOOKS LIKE YOU ALREADY HAVE THE 'AZAXHRN' FUNCTION..."
 . W !,"NOTHING ADDED"
 ;
 D ADD("AZAXHRN")
 Q
LOOKUP(X,Y) ;
 ;
 N DIC
 ;
 S DIC="^DD(""FUNC"""_","
 S DIC(0)=""
 D ^DIC
 Q
ADD(X) ;
 ;----- ADD NEW ENTRY INTO FUNCTION FILE
 ;
 N DA,DATA,DD,DIC,DIE,DO,DR,I,Y
 ;
 S DIC="^DD(""FUNC"""_","
 S DIC(0)=""
 D FILE^DICN
 ;
 Q:+Y'>0
 ;
 S DA=+Y
 S DIE=DIC
 S DR=""
 F I=1:1 S DATA=$T(DATA+I) Q:DATA["$$END"  D
 . S DR=DR_";"_$P(DATA,";",3)_"////"_$P(DATA,";",5)
 I $E(DR)=";" S DR=$E(DR,2,$L(DR))
 ;
 D ^DIE
 ;
 W !,"'AZAXHRN' FUNCTION ADDED"
 Q
DATA ;----- FIELD DATA TO BE INSERTED
 ;;.02;MUMPS CODE;N ZZZ S X="" S ZZZ=$O(I(99999),-1),ZZZ=$G(I(ZZZ)) I "^DPT(^AUPNPAT("[ZZZ S X=$P($G(^AUPNPAT($G(D0),41,+$G(DUZ(2)),0)),U,2)
 ;;1;EXPLANATION;Gets patient's HRN of signed onto facility.  Must use from VA PATIENT or PATIENT file.
 ;;9;NUMBER OF ARGUMENTS;0
 ;;$$END
