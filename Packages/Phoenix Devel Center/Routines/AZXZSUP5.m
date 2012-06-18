AZXZSUP5 ;SUPPORT DATABASE PROGRAM[ 08/25/92  8:56 AM ]
 ;05/07/92  JOHN H. LYNCH
 ;
 ;THIS ROUTINE WILL ALLOW A USER TO PRINT OUT
 ;A LIST OF PROBLEM CODES CURRENTLY BEING USED
 ;WITH THE SUPPORT LOG DATABASE.  A KEY IS GIVEN
 ;FOR AN EASY UNDERSTANDING OF HOW THE PROBLEM CODES
 ;ARE USED, THEN A LIST OF THE PROBLEM CODES IN
 ;THEIR CATAGORIES ARE GIVEN.
 
MAIN ;AZXZSUP5 PROGRAM CONTROL
 ;INITIALIZE LOCAL VARIABLES
 S FILE="1991011"          ;FILE NUMBER (PROBCODE)
 
 W @IOF                    ;CLEAR SCREEN
 W !!!,"Problem Code Print..."
KEYPRNT ;SUB-ROUTINE OF MAIN
 W !!,"Would you like to print out a Key"
 R !,"for the Problem Code Print: Y// ",KEY
 I KEY="^" G KILLVARS
 I KEY="?" W !!,"The ""Problem Code Key Print"" gives a brief description",!,"of the current types of problem codes and their sub-classes." G KEYPRNT
 I KEY="" S KEY="Y"
 D SETDATE                 ;CALL SETDATE SUB-ROUTINE
 D ^%ZIS U IO              ;CALL DEVICE
 I KEY="Y" D PRNTKEY       ;CALL PRINTKEY SUB-ROUTINE
 D PRNTCODE                ;CALL PRINTOUT SUB-ROUTINE
 X ^%ZIS("C")              ;CLOSE DEVICE
 
 R !!,"Do you want to print another Problem Code List? Y// ",YN
 I YN="" S YN="Y"
 I YN="Y" G MAIN
KILLVARS ;SUB-ROUTINE OF MAIN
 ;K 
 Q
 
SETDATE ;SET DATE = CURRENT DATE FOR REPORT
 S Y=DT                ;SET Y TO CURRENT DATE FOR REPORT OUTPUT
 D DD^%DT              ;CONVERT CURRENT DATE
 S DATE=Y              ;REPORT DATE
 Q
 
PRNTKEY ;PRINT OUT KEY FOR PROBLEM CODE PRINT
 
 W !,"________________________________________________________________________________",!
 W !,"Problem Code Key Print",?63,DATE
 W !,"________________________________________________________________________________",!
 W !!,"A   = ADMINISTRATIVE PROBLEM"
 W !!,"F   = FTS SUPPORT CALL"
 W !!,"H   = HARDWARE PROBLEM"
 W !!,"HP  = HARDWARE PROCUREMENT"
 W !!,"M   = MUMPS SUPPORT CALL"
 W !!,"ME  = MUMPS ERROR"
 W !!,"MSW = MUMPS SOFTWARE ADDED"
 W !!,"O   = OPERATING SYSTEM PROBLEM"
 W !!,"S   = SOFTWARE PACKAGE PROBLEM"
 W !!,"U   = UNIX SUPPORT CALL"
 W !!,"UE  = UNIX ERROR"
 W !!!,"The ""Problem Code Key Print"" helps in identifying a sub-class"
 W !,"of the current problem codes.  Every problem begins with a prefix"
 W !,"of up to three letters that helps identify its sub-class.  As an"
 W !,"example, any problem code that starts with, ME, would be identified"
 W !,"with the sub-class for a problem which involved an error in mumps"
 W !,"(M=Mumps, E=Error)."
 H 2
 W @IOF     ;CLEAR SCREEN (ADVANCE A PAGE)
 Q
 
PRNTCODE ;PRINT OUT PROBLEM CODE PRINT
 ;INITIALIZE LOCAL VARIABLES
 S COUNT=1             ;COUNT = CURRENT LABEL NUMBER TO PRINT
 S INUM=0              ;INTERNAL ENTRY NUMBER
 S CODE=0              ;START CODE AT BEGINNING OF PROBCODES
 
 W @IOF                ;CLEAR SCREEN WHEN OUTPUT TO TERMINAL
 W !,"________________________________________________________________________________",!
 W !,"Problem Code Print",?63,DATE
 W !,"Code",?13,"Description"
 W !,"________________________________________________________________________________",!
 F  S INUM=0,CODE=$O(^DIZ(FILE,"B",CODE)) Q:CODE=""  D SETINUM D CHKHEAD D PRNTOUT
 Q
 
SETINUM ;SET THE INTERNAL NUMBER FOR EACH ENTRY  
 S INUM=$O(^DIZ(FILE,"B",CODE,INUM))
 Q
 
CHKHEAD ;CHECK TO SEE IF A NEW HEADING IS NEEDED
 ;FOR EACH PROBCODE TYPE (SEE KEY)
 I ($F(CODE,"A",1)=2)&(COUNT=1) S COUNT=COUNT+1 W !!,"Administrative Problem Codes...",!
 I ($F(CODE,"F",1)=2)&(COUNT=2) S COUNT=COUNT+1 W !!,"FTS Problem Codes...",!
 I ($F(CODE,"H",1)=2)&(COUNT=3) S COUNT=COUNT+1   W !!,"Hardware Problem Codes...",!
 I ($F(CODE,"M",1)=2)&(COUNT=4) S COUNT=COUNT+1   W !!,"Mumps Problem Codes...",!
 I ($F(CODE,"O",1)=2)&(COUNT=5) S COUNT=COUNT+1   W !!,"Operating System Problem Codes...",!
 I ($F(CODE,"S",1)=2)&(COUNT=6) S COUNT=COUNT+1   W !!,"Software Problem Codes...",!
 I ($F(CODE,"U",1)=2)&(COUNT=7) S COUNT=COUNT+1   W !!,"Unix Problem Codes...",!
 Q
 
PRNTOUT ;PRINT OUT ACTUAL DATA 
 W !,$P(^DIZ(FILE,INUM,0),U),?13,$P(^DIZ(FILE,INUM,0),U,2)
 Q
