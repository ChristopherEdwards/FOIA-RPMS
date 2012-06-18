AZXRCHS1 ;CHS Dollars Spent Report Input PROGRAM [ 06/10/93  8:41 AM ]
 ;09/04/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE USER TO INPUT THE FACILITY AND THE
 ;DATE RANGES FOR THE CHS Dollars Spent REPORT.
 
 ;THE ROUTINES THAT AZXRCHS1 CALLS:
 ;^DIC, Fileman Lookup.
 ;^%DT, Fileman Date Conversion.
 
 ;THE ROUTINES THAT CALL AZXRCHS1:
 ;AZXRCHS, CHS Dollars Spent Report.
 
 ;Variable List
 ;DIC=         Global root of file for Fileman Lookup.
 ;DIC(0)=      Fileman Lookup parameters.
 ;DIC("A")=    Fileman Lookup default prompt.
 ;BACKUP=      Flags whether user wants to back up one prompt.
 ;%DT=         Fileman Date Conversion parameters.
 ;%DT("A")=    Fileman Date Conversion default prompt.
 
 ;Variables which are sent to AZXRCHS:
 ;FACBKUP=     Flag returned to AZXRCHS with data on
 ;             whether user wants to quit.
 ;FAC=         Facility in external form.
 ;FCLTY=       Internal Number of site from INSTITUTION file.
 ;COMNAME=     External form of community.
 ;COMMUN=      Internal entry number for community.
 ;FDATE=       Fileman From Date is returned in FDATE.
 ;TDATE=       Fileman To Date is return in TDATE.
 
 
MAIN ;AZXRCHS PROGRAM CONTROL    
 
 D INPUT
 Q
 
INPUT ;ASK USER FOR THE FACILITY TO USE FOR REPORT
 ;THEN CALL FDATE ROUTINE
 
 W @IOF                                  ;CLEAR SCREEN
 
 W !!!,"'CHS Dollars Spent Report'...",!!
 
FACILITY ;CALL FILEMAN LOOKUP FOR FACILITY
 ;SET LOCAL VARIABLES
 S DIC="^DIC(4,"                         ;GLOBAL ROOT OF INSTITUTION
                                         ;FILE USED FOR LOOKUP
 
 S DIC(0)="AEQZ"                         ;DIC(0)= LOOKUP VALUES
                                         ;  A= ASK USER FOR INPUT
                                         ;  E= ECHO ANSWER
                                         ;  Q= QUESTION ERRONEOUS INPUT
                                         ;  Z= ZERO NODE RETURNED IN
                                         ;     Y(0) AND EXTERNAL FORM
                                         ;     IN Y(0,0)
 
 S DIC("A")="Enter Facility: "           ;DIC("A")= DEFAULT PROMPT FOR
                                         ;          LOOKUP
 
 D ^DIC
 
 I (X="^")!(X="") S FACBKUP="Y" Q        ;X= USER INPUT VALUE FROM ^DIC
                                         ;FACBKUP= RETURNED VARIABLE
                                         ;         WHICH TELLS WHETHER
                                         ;         USER WANTS TO BACKUP
                                         ;         A PROMPT
 S FACBKUP="N"                           ;--USER DOESN'T WANT TO BACKUP
 
 S FAC=Y(0,0)                            ;FAC= FACLITY IN EXTERNAL FORM
 
 S FCLTY=$P(Y,U,1)                       ;FCLTY= INTRNAL NUMBER OF SITE
 
 D COMMUN 
 
 I BACKUP="Y" G FACILITY
 Q
 
COMMUN ;CALL FILEMAN LOOKUP FOR COMMUNITY 
 S DIC="^AUTTCOM("                       ;GLOBAL ROOT OF COMMUNITY
                                         ;FILE USED FOR LOOKUP
 
 S DIC("A")="Enter Location: "           ;DIC("A")= DEFAULT PROMPT FOR
                                         ;          LOOKUP
 
 D ^DIC
 
 I (X="^")!(X="") S BACKUP="Y" Q         ;X= USER INPUT VALUE FROM ^DIC
                                         ;BACKUP=  RETURNED VARIABLE
                                         ;         WHICH TELLS WHETHER
                                         ;         USER WANTS TO BACKUP
                                         ;         A PROMPT
 S BACKUP="N"                            ;--USER DOESN'T WANT TO BACKUP
 
 
 S COMMUN=$P(Y,U,1)                      ;COMMUN= INTERNAL # OF COM.
 
 S COMNAME=$P(^AUTTCOM(COMMUN,0),U,1)    ;COMNAME=  NAME OF COMMUNITY 
 
 D FDATE
 
 I BACKUP="Y" G COMMUN
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
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRCHS1
 K DIC,BACKUP,%DT
 Q
