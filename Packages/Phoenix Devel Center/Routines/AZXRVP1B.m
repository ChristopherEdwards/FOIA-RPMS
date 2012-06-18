AZXRVP1B ;PAO/IHS/JHL;VISITS BY PROVIDERS[ 08/30/93  11:00 AM ]
 ;Version 1;VISITS BY PROVIDERS;;****;DATE OF RELEASE HERE
 ;JOHN H. LYNCH
 ;
 ;AZXRVP1B, INPUT PROGRAM 2 OF 4.
 
 ;THE ROUTINES THAT CALL AZXRVP1:
 ;AZXRVP1, 1st input program.
 
 ;THE ROUTINES THAT AZXRVP1 CALLS:
 ;AZXRVP1C, 3rd input program.
 ;^DIC, Fileman Lookup.
 ;^%DT, Fileman Date Conversion.
 
 ;Variable List
 ;DIC=         Global root of file for Fileman Lookup.
 ;DIC(0)=      Fileman Lookup parameters.
 ;DIC("A")=    Fileman Lookup default prompt.
 ;%DT=         Fileman Date Conversion parameters.
 ;%DT("A")=    Fileman Date Conversion default prompt.
 ;DTOUT=       Used for checking timeout.
 ;AZXRBCK=     Flags whether user wants to back up one prompt.
 ;AZXRCLNC(#)= Clinic stops from AZXRVP1.
 ;AZXRFAC=     Facility in external form^DFN from LOCATION file.
 ;AZXRFDT=     Fileman From Date is returned in AZXRFDT.
 ;AZXRTDT=     Fileman To Date is return in AZXRTDT.
 ;AZXROK=      Check flag for validating all prompt entries.
 ;J,L=         Counter variables.
 ;X=           Lookup value from user input.
 ;Y=           Returned lookup value from ^DIC.
 
FDATE ;ASK USER FOR THE FROM DATE TO USE FOR REPORT
 ;SET LOCAL VARIABLES
 S AZXRBCK="N"                           ;AZXRBCK= VARIABLE USED FOR
                                         ;        CHECKING WHETHER USER
                                         ;        WANTS TO BACK UP "^"
 
 S %DT="AEX"                             ;VALIDATES DATE INPUT AND
                                         ;CONVERTS IT FOR STORAGE
                                         ;  A= ASK FOR DATE INPUT
                                         ;  E= ECHO ANSWER
                                         ;  X= EXACT DATE REQUIRED
 
 S %DT("A")="From Date:      "           ;%DT("A")= DEFAULT PROMPT
 
 D ^%DT                                  ;CALL FILEMAN DATE CONVERSION
 
 I (X="^")!(X="")!($D(DTOUT)) K DTOUT S AZXRBCK="Y" Q
                                         ;USER WANTS TO BACK UP
                                         ;OR TIMEOUT
 I X?1.3"?" G FDATE                      ;INQUIRY TO HELP; GOTO FDATE
 I Y=-1 W !!,*7,"Invalid Date:  Press a '?' for help." G FDATE
                                         ;INVALID ENTRY; GOTO FDATE
 
 S AZXRFDT=Y                             ;AZXRFDT= FILEMAN DT RETURNED
                                         ;         IN Y
 
 D TDATE                                 ;SET TO DATE
 G:AZXRBCK="Y" FDATE                     ;USER WANTS TO BACK UP "^"
 Q
 
TDATE ;ASK USER FOR THE TO DATE TO USE FOR REPORT
 ;SET LOCAL VARIABLES
 S AZXRBCK="N"                           ;AZXRBCK= VARIABLE USED FOR
                                         ;         CHECKING WHETHER USR
                                         ;         WANTS TO BACK UP "^"
 
 S %DT="AEX"                             ;VALIDATES DATE INPUT AND
                                         ;CONVERTS IT FOR STORAGE
                                         ;  A= ASK FOR DATE INPUT
                                         ;  E= ECHO ANSWER
                                         ;  X= EXACT DATE REQUIRED
 
 S %DT("A")="To Date:        "           ;%DT("A")= DEFAULT PROMPT
 
 D ^%DT                                  ;CALL FILEMAN
 
 I (X="^")!(X="")!($D(DTOUT)) K DTOUT S AZXRBCK="Y" Q        
                                         ;USER WANTS TO BACK UP
                                         ;OR TIMEOUT
 I X?1.3"?" G TDATE                      ;INQUIRY TO HELP; GOTO TDATE
 I Y=-1 W !!,*7,"Invalid Date:  Press a '?' for help." G TDATE
                                         ;INVALID ENTRY; GOTO TDATE
 
 S AZXRTDT=Y                             ;AZXRTDT= FILEMAN DT RETURNED
                                         ;         IN Y
 I AZXRTDT<AZXRFDT W !!,"'To Date' must be greater than or equal to 'From Date'",! G TDATE
 D CLINICS                               ;ASK USER FOR CLINIC STOPS
 G:AZXRBCK="Y" TDATE                     ;USER WANTS TO BACKUP "^"
 Q
 
CLINICS ;ASK USER FOR ALL CLINIC STOPS
 ;SET LOCAL VARIABLES
 S AZXRBCK="N"                           ;AZXRBCK= VARIABLE USED FOR
                                         ;        CHECKING WHETHER USER
                                         ;        WANTS TO BACK UP "^"
 S DIC="^DIC(40.7,"                      ;USE ^DIC(40.7, FOR LOOKUP
                                         ;CLINIC STOP FILE
 S DIC(0)="AEOQZ"                        ;DIC(0)= LOOKUP VALUES
                                         ;  A= ASK THE ENTRY
                                         ;  E= ECHO BACK ANSWER
                                         ;  O= ONLY FIND ONE ANSWER
                                         ;  Q= QUESTION ERROR INPUT
                                         ;  Z= OUTPUT IN Y(0),Y(0,0)
 
 S DIC("A")="Enter Clinic Stop: "        ;DIC("A")= DEFAULT PROMPT
 
 S L=1                                   ;L= FIRST CLINIC STOP SUBSCRPT
 F  Q:AZXRBCK="Y"  S AZXROK="Y" Q:L>5  D ^DIC Q:(X="")&(L>1)  D
 .I (X="^")!((X="")&(L=1))!($D(DTOUT)) K DTOUT S AZXRBCK="Y" Q
 .I L>1 F J=1:1:(L-1) I Y(0,0)=$P(AZXRCLNC(J),U,2) S AZXROK="N" Q
 .I AZXROK="Y" S $P(AZXRCLNC(L),U,2)=Y(0,0),$P(AZXRCLNC(L),U)=$P(Y,U,1),L=L+1 Q
 .W !!,*7,"All clinic stops must be unique, please try again.",!
                                         ;DO LOOKUP FOR CLINIC STOPS
                                         ;CHECK IF USER WANTS TO BACK 
                                         ;UP OR TIMEOUT
                                         ;MAKE SURE ALL CLINIC STOPS
                                         ;ARE UNIQUE
                                         ;AZXRCLNC(L)= 1) INTERNAL # OF
                                         ;                CLINIC STOPS
                                         ;             2) EXTERNAL FORM
 
 Q:AZXRBCK="Y"                           ;GO BACK TO FACILITY PROMPT
 D AFFIL^AZXRVP1C                        ;GET AFFILIATIONS
 G:AZXRBCK="Y" CLINICS                   ;USER WANTS TO BACKUP "^"
 Q
