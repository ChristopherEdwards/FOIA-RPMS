AZXRBUG2 ;BUGDRUG2 Purge PROGRAM [ 09/23/94   9:52 AM ]
 ;Version 1
 ;08/20/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE DATA ENTRY PERSON TO PURGE A
 ;RANGE OF DATA FROM THE BUGDRUG2 DATABASE.
 
 ;THE ROUTINE THAT CALLS AZXRBUG2:
 ;AZXRBUG, Main
 
 ;THE ROUTINES THAT AZXRBUG2 CALLS:
 ;DD^%DT,%DT     (FILEMAN DATE CONVERSION)
 ;^DIK           (FILEMAN DELETE ROUTINE)
 
 ;Variable List
 ;FLE=              BUGDRUG2 (Database Global).
 ;%DT=              Validates date input from user and converts it.
 ;%DT("A")=         Default prompt for date conversion routine.
 ;FROM=             Users input for starting date.
 ;TO=               Users input for ending date.
 ;PURGEIT=          A check variable used to make sure user wants
 ;                  to purge data.
 ;DIK=              Global root of file to purge records from.
 ;DATE=             Used for making sure the FROM date is included
 ;                  in date range.
 ;RET=              Used when waiting for user, "Press return..."
 ;Y=                Used for date conversion; date to convert.
 ;DA=               Internal entry number current up for purging.
 ;YN=               Users input on whether to print another report.
 
MAIN ;AZXRBUG2 PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 S FLE="1991012"                         ;BUGDRUG2 (DATABASE GLOBAL)
 S %DT="AEX"                             ;VALIDATES DATE INPUT AND
                                         ;CONVERTS IT FOR STORAGE
                                         ;  A= ASK FOR DATE INPUT
                                         ;  E= ECHO ANSWER
                                         ;  X= EXACT DATE REQUIRED
 
 D RANGE                                 ;GET DATE RANGE TO PURGE
 D CONT                                  ;CONTINUE WITH PURGE?
 D KILL                                  ;KILL LOCAL VARIABLES & QUIT
 
 Q
 
RANGE ;ASK USER FOR A RANGE OF DATES TO PURGE
 ;SET LOCAL VARIABLES
 W @IOF                                  ;CLEAR SCREEN
 
 W !!!,"BugDrug2 Purge..."
 W !!,"Enter the range of dates to purge:"
 W !!,?5,"NOTE:  ""From Date"" must be less than or"
 W !,?12,"equal to ""To Date""."
 
FROM W !!                                    ;SKIP TWO LINES
 S %DT("A")="     From Date: "           ;%DT("A")= DEFAULT PROMPT
 D ^%DT                                  ;CALL FILEMAN DATE CONVERSION
                                         ;TO GET THE LOWER BOUND DATE
 
 I X="^" Q                               ;USER WANTS OUT / QUIT RANGE
 I X="?" G FROM                          ;INQUIRY TO HELP; GOTO FROM
 I Y=-1 W !!,*7,"Invalid Date:  Press a '?' for help." G FROM
                                         ;INVALID ENTRY; GOTO FROM
 
 S FROM=Y                                ;FROM= FILEMAN DATE RETURNED
                                         ;      IN Y (LOWER BOUND DATE)
 
TO S %DT("A")="     To Date:   "           ;%DT("A")= DEFAULT PROMPT
 D ^%DT                                  ;CALL FILEMAN DATE CONVERSION
                                         ;TO GET THE UPPER BOUND DATE
 
 I X="^" G FROM                          ;USER WANTS OUT / QUIT RANGE
 I X="?" G TO                            ;INQUIRY TO HELP; GOTO TO
 I Y=-1 W !!,*7,"Invalid Date:  Press a '?' for help." G TO 
                                         ;INVALID ENTRY; GOTO TO
 
 S TO=Y                                  ;TO= FILEMAN DATE RETURNED
                                         ;    IN Y (UPPER BOUND DATE)
 
 I FROM>TO W !!,*7,"Invalid input: ""From DATE"" must be less than or equal to ""To DATE""." R !!,"Press return to continue...",RET G RANGE
                                         ;VALID DATE INPUT:
                                         ;  YES= RE-ENTER RANGE DATES
                                         ;  NO=  DO PURGE
 
 H 2 D CHECK                             ;HANG 2 SEC. 1ST
                                         ;CHECK TO MAKE SURE USER WANTS
                                         ;TO PURGE THESE DATES
                                         ;LAST CHANCE!!!
 
 I PURGEIT="Y" D PURGE1                  ;PURGE DATA USING FROM/TO DATES
 I PURGEIT="N" G RANGE                   ;RE-ENTER FROM/TO DATES
 Q
 
CHECK ;GIVE USER ONE LAST CHANCE TO EXIT AND NOT PURGE
 ;SET LOCAL VARIABLES
 S PURGEIT="N"                           ;PURGEIT= FLAG TO SEE IF USER
                                         ;IS SURE THEY WANT TO PURGE
                                         ;BETWEEN FROM/TO DATES
 
 W @IOF                                  ;CLEAR SCREEN
 W !!!,"Last chance..."
 
 S Y=FROM
 D DD^%DT                                ;CONVERT TO EXTERNAL DATE
                                         ;  VALUE RETURNED IN Y
 W !!,"Date to purge from:  ",Y
 
 S Y=TO
 D DD^%DT                                ;CONVERT TO EXTERNAL DATE
                                         ;  VALUE RETURNED IN Y
 W !,"Date to purge to:    ",Y
 
SURE R !!,"Are you sure these dates are correct? N//",YN
 
 I YN?1.3"?" W !!,"Answer with:  Y= Yes, N= No" G SURE
 I (YN?1"Y")!(YN?1"y")!(YN?1"YES")!(Y?1"yes") S PURGEIT="Y"
 Q
 
PURGE1 ;PURGE ALL RECORDS WITHIN AND INCLUDING
 ;THE DATES INPUT BY USER (FROM/TO)
 ;SET LOCAL VARIABLES
 S DIK="^DIZ(1991020,"                   ;GLOBAL ROOT OF FILE (BUGDRUG2)
                                         ;TO PURGE RECORDS FROM
 
 W @IOF                                  ;CLEAR SCREEN
 W !!,"PURGING DATA...."
 
 S DATE=FROM-1                           ;DATE= START DATE BACK ONE
                                         ;      DAY TO INCLUDE THE
                                         ;      'FROM' DAY
 
 F  S DATE=$O(^DIZ(1991020,"D",DATE)) Q:DATE>TO  Q:'DATE  D PURGE2
                                         ;FIND ALL "D" CROSS-REFERENCES
                                         ;FOR DATE RANGE TO DELETE
                                         ;CALL PURGE2 FOR ACTUAL PURGE
 
 W !!,"PURGE COMPLETE."
 Q
 
PURGE2 ;FIND INTERNAL ENTRY NUMBER (DA) TO PURGE AND
 ;CALL FILEMAN DELETE (^DIK)
 S DA=0                                  ;DA= INTERNAL ENTRY (DEFAULT)
 F  S DA=$O(^DIZ(1991020,"D",DATE,DA)) Q:'DA  D ^DIK
                                         ;FIND ALL INTERNAL NUMBERS
                                         ;AND DELETE THEM THROUGH ^DIK
 Q
 
CONT ;ASK USER WHETHER TO CONTINUE WITH PURGE
 ;SET LOCAL VARIABLES
 
 R !!!!!!!,"Do you want to continue purging data? N//",YN
                                         ;ASK USER WHETHER TO CONTINUE?
 
 I YN?1.3"?" W !!,"Answer with:  Y= Yes, N= No" G CONT
                                         ;USER WANTS HELP
 I (YN?1"Y")!(YN?1"y")!(YN?1"YES")!(YN?1"yes") D RANGE G CONT
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRBUG2
 K FLE,%DT,FROM,TO,RET,PURGEIT,Y,DIK,DATE,DA,YN
 Q
