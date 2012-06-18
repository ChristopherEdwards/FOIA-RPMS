AZXRBUG7 ;BUGDRUG2 Report Input PROGRAM [ 06/29/93  9:42 AM ]
 ;Version 1
 ;09/04/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE USER TO INPUT THE FACILITY AND THE
 ;DATE RANGES FOR THE BUGDRUG2 REPORTS, 'Cultured
 ;Organisms by Source' AND 'Antibiotic Sensitivity'.
 
 ;THE ROUTINES THAT CALL AZXRBUG7:
 ;AZXRBUG5, Sensitivity Report.
 ;AZXRBUG6, Organisms by Source Report.
 
 ;THE ROUTINES THAT AZXRBUG7 CALLS:
 ;^DIC, Fileman Lookup.
 ;^%DT, Fileman Date Conversion.
 
 ;Variable List
 ;DIC=         Global root of file for Fileman Lookup.
 ;DIC(0)=      Fileman Lookup parameters.
 ;DIC("A")=    Fileman Lookup default prompt.
 ;OPTION=      Sent from AZXRBUG5 or AZXRBUG6 (specifies report type).
 ;BACKUP=      Flags whether user wants to back up one prompt.
 ;%DT=         Fileman Date Conversion parameters.
 ;%DT("A")=    Fileman Date Conversion default prompt.
 
 ;Variables which are sent to either, AZXRBUG5 or AZXRBUG6:
 ;FACBKUP=     Flag returned to AZXRBUG5 or AZXRBUG6 with data on
 ;             whether user wants to quit.
 ;FAC=         Facility in external form.
 ;FCLTY=       Internal Number of site from SITES file.
 ;FDATE=       Fileman From Date is returned in FDATE.
 ;TDATE=       Fileman To Date is return in TDATE.
 
 
MAIN ;AZXRBUG7 PROGRAM CONTROL    
 
 D INPUT
 D KILL
 Q
 
INPUT ;ASK USER FOR THE FACILITY TO USE FOR REPORT
 ;THEN CALL FDATE ROUTINE
 ;SET LOCAL VARIABLES
 S DIC="^DIZ(1991010,"                   ;GLOBAL ROOT OF SITES FILE
                                         ;USED FOR LOOKUP
 
 S DIC(0)="AEQZ"                         ;DIC(0)= LOOKUP VALUES
                                         ;  A= ASK USER FOR INPUT
                                         ;  E= ECHO ANSWER
                                         ;  Q= QUESTION ERRONEOUS INPUT
                                         ;  Z= ZERO NODE RETURNED IN
                                         ;     Y(0) AND EXTERNAL FORM
                                         ;     IN Y(0,0)
 
 S DIC("A")="Enter Facility: "           ;DIC("A")= DEFAULT PROMPT FOR
                                         ;          LOOKUP
 
 W @IOF                                  ;CLEAR SCREEN
 
 I OPTION=2 W !!!,"BugDrug2 'Antibiotic Sensitivity Report'...",!!
 I OPTION=3 W !!!,"BugDrug2 'Cultured Organisms by Source Report'...",!!
 
FACILITY ;CALL FILEMAN LOOKUP FOR FACILITY
 D ^DIC
 
 I (X="^")!(X="") S FACBKUP="Y" Q        ;X= USER INPUT VALUE FROM ^DIC
                                         ;FACBKUP= RETURNED VARIABLE
                                         ;         WHICH TELLS WHETHER
                                         ;         USER WANTS TO BACKUP
                                         ;         A PROMPT
 S FACBKUP="N"                           ;--USER DOESN'T WANT TO BACKOR
 
 S FAC=Y(0,0)                            ;FAC= FACILITY IN EXTERNAL FROM
 
 S FCLTY=$P(Y,U,1)                       ;FCLTY= INTERNAL NUMBER OF SITE
 
 D FDATE
 
 I BACKUP="Y" G FACILITY
 Q
 
FDATE ;ASK USER FOR THE FROM DATE TO USE FOR REPORT
 ;SET LOCAL VARIABLES
 S BACKUP="N"                            ;BACKUP= VARIABLE USED FOR
                                         ;        CHECKING WHETHER USER
                                         ;        WANTS TO BACK UP "^"
 
 S %DT="AEX"                             ;VALIDATES DATE INPUT AND
                                         ;CONVERTS IT FOR STORAGE
                                         ;  A= ASK FOR DATE INPUT
                                         ;  E= ECHO ANSWER
                                         ;  X= EXACT DATE REQUIRED
 
 S %DT("A")="From Date:      "           ;%DT("A")= DEFAULT PROMPT;FDATE
 
 D ^%DT                                  ;CALL FILEMAN DATE CONVERSION
 
 I (X="^")!(X="") S BACKUP="Y" Q         ;USER WANTS TO BACK UP
 I X?1.3"?" G FDATE                      ;INQUIRY TO HELP; GOTO FDATE
 I Y=-1 W !!,*7,"Invalid Date:  Press a '?' for help." G FDATE
                                         ;INVALID ENTRY; GOTO FDATE
 
 S FDATE=Y                               ;FDATE= FILEMAN DATE RETURNED
                                         ;       IN Y
 
 D TDATE                                 ;SET TO DATE
 I BACKUP="Y" G FDATE                    ;USER WANTS TO BACK UP "^"
 Q
 
TDATE ;ASK USER FOR THE TO DATE TO USE FOR REPORT
 ;SET LOCAL VARIABLE
 S BACKUP="N"                            ;BACKUP= VARIABLE USED FOR
                                         ;        CHECKING WHETHER USER
                                         ;        WANTS TO BACK UP "^"
 
 S %DT="AEX"                             ;VALIDATES DATE INPUT AND
                                         ;CONVERTS IT FOR STORAGE
                                         ;  A= ASK FOR DATE INPUT
                                         ;  E= ECHO ANSWER
                                         ;  X= EXACT DATE REQUIRED
 
 S %DT("A")="To Date:        "           ;%DT("A")= DEFAULT PROMPT;TDATE
 
 D ^%DT                                  ;CALL FILEMAN
 
 I (X="^")!(X="") S BACKUP="Y" Q         ;USER WANTS TO BACK UP
 I X?1.3"?" G TDATE                      ;INQUIRY TO HELP; GOTO TDATE
 I Y=-1 W !!,*7,"Invalid Date:  Press a '?' for help." G TDATE
                                         ;INVALID ENTRY; GOTO TDATE
 
 S TDATE=Y                               ;TDATE= FILEMAN DATE RETURNED
                                         ;       IN Y
 I TDATE<FDATE W !!,"'To Date' must be greater than or equal to 'From Date'",! G TDATE
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRBUG7
 K DIC,BACKUP,%DT
 Q
