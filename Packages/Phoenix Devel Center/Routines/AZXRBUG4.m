AZXRBUG4 ;BUGDRUG2 Verfication PROGRAM [ 09/23/94   9:52 AM ]
 ;Version 1
 ;08/04/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE DATA ENTRY PERSON TO VERIFY DATA INPUT
 ;FOR A PARTICULAR FACILITY AND FOR A PARTICULAR DATE.
 ;ALL DATA WILL BE DISPLAYED IN THE ORDER IT WAS
 ;ENTERED INTO THE BUGDRUG2 DATABASE.
 
 ;THE ROUTINES THAT CALL AZXRBUG4:
 ;AZXRBUG3, Reports Menu
 
 ;THE ROUTINES THAT AZXRBUG4 CALLS:
 ;DIC          (FILEMAN LOOKUP ROUTINE)
 ;%DT          (FILEMAN DATE CONVERSION ROUTINE)
 ;%ZIS         (KERNAL DEVICE HANDLER)
 
 ;Variable List
 ;PG=          Current page count.
 ;LN=          Current line count.
 ;DIC=         Global root of file for lookup.
 ;DIC(0)=      Parameters for lookup.
 ;DIC("A")=    Default prompt for lookup.
 ;FAC=         External form for facility.
 ;FCLTY=       Internal number for facility.
 ;BACKUP=      Flag used for user wanting to back up a prompt.
 ;%DT=         Parameters for date conversion.
 ;%DT("A")=    Default prompt for date input.
 ;DATE=        Fileman converted date to external form.
 ;LDATE=       Starting point date for print loop (REPORT
 ;             SUB-ROUTINE).
 ;%ZIS("B")=   Don't use HOME as default device.
 ;BORDER=      Special border for printout.
 ;BORDER2=     Special border for printout.
 ;BORDER3=     Special border for printout.
 ;BORDER4=     Special border for printout.
 ;HEADER=      Special header for printout.
 ;HEADER1=     Special header for printout.
 ;Y=           Date value used for conversion.
 ;DA=          Internal entry number used in print loop (REPORT
 ;             SUB-ROUTINE).
 ;NODE=        Current entry to be printed.
 ;ORG=         Current Organism_Code.
 ;SPEC=        Current Specimen_Code.
 ;X=           Current lookup value.
 ;YN=          User input on whether to print another report.
 
MAIN ;AZXRBUG4 PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE NUMBER
 S LN=0                                  ;INITIALIZE LINE COUNTER
 
 D INPUT
 D KILL
 
 Q
 
INPUT ;ASK USER FOR THE FACILITY TO USE FOR VERIFICATION
 ;THEN CALL ROUTINE, DATE.
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
 W !!!,"BugDrug2 Verification...",!!
FACILITY ;CALL FILEMAN LOOKUP FOR FACILITY
 D ^DIC
        
 I (X="^")!(X="") Q                      ;X= USER INPUT VALUE FROM ^DIC
 
 S FAC=Y(0,0)                            ;FAC= FACILITY IN EXTERNAL FORM
 S FCLTY=$P(Y,U,1)                       ;FCLTY= INTERNAL NUMBER OF SITE
 
 D DATE
 I BACKUP="Y" G FACILITY
 Q
 
DATE ;ASK USER FOR THE DATE TO USE FOR VERIFICATION
 ;SET LOCAL VARIABLES
 S BACKUP="N"                            ;BACKUP= VARIABLE USED FOR
                                         ;        CHECKING WHETHER USER
                                         ;        WANTS TO BACK UP "^"
 
 S %DT="AEX"                             ;VALIDATES DATE INPUT AND
                                         ;CONVERTS IT FOR STORAGE
                                         ;  A= ASK FOR DATE INPUT
                                         ;  E= ECHO ANSWER
                                         ;  X= EXACT DATE REQUIRED
 
 S %DT("A")="Enter Date:     "           ;%DT= DEFAULT PROMPT FOR DATE
 
 D ^%DT                                  ;CALL FILEMAN DATE CONVERSION
 
 I X="^" S BACKUP="Y" Q                  ;USER WANTS TO BACK UP
 I X?1.3"?" G DATE                       ;INQUIRY TO HELP; GOTO DATE
 I Y=-1 W !!,*7,"Invalid Date:  Press a '?' for help." G DATE
                                         ;INVALID ENTRY; GOTO DATE
 
 S DATE=Y                                ;DATE= FILEMAN DATE RETURNED
                                         ;      IN Y
 
 D REPORT                                ;PRINT VERIFICATION REPORT
 Q
 
REPORT ;OPEN DEVICE AND PRINT OUT VERIFICATION REPORT
 ;SET LOCAL VARIABLES
 S LDATE=DATE-1                          ;STARTING POINT FOR PRINT
                                         ;LOOP
 
 S %ZIS("B")=""                          ;DON'T USE HOME AS DEFAULT
                                         ;DEVICE
 
 S BORDER="____________________________________________________________________________________________________________________________"
 
 S BORDER2="___________________________________|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|"
 
 S BORDER3="|   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |"
 S BORDER4="|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|"
 
 S HEADER="       Organism_Name"
 
 S HEADER1="Rec_#  Specimen_Name               |CC |E  |DP |P  |AM |CF |C  |FM |GM |SxT|TE |CB |NA |CP |CAX|VA |AUG|CRM|TI |PI |AK |CFX|"
                                         ;VERIFICATION HEADER LINE2 
 
 W !
 
 D ^%ZIS U IO                            ;OPEN DEVICE
 
 I IO="" Q                               ;USER WANTS OUT
 I IO(0)=IO W !,*7,"The Verification must be printed.",! X ^%ZIS("C") G REPORT
 
 S Y=DATE                                ;CONVERT TO EXTERNAL DATE
 D DD^%DT                                ;VALUE RETURNED IN Y
 S RDATE=Y                               ;DATE= REPORT DATE
 
 F  S LDATE=$O(^DIZ(1991020,"DF",LDATE)) Q:LDATE>DATE  Q:'LDATE  S DA=0 F  S DA=$O(^DIZ(1991020,"DF",LDATE,FCLTY,DA)) Q:'DA  D:(LN>(IOSL-2)) HEADING D PRTINFO
 
 X ^%ZIS("C")                            ;CLOSE DEVICE
 D CONT
 Q
 
PRTINFO ;PRINT THE INFORMATION LINE OUT TO PRINTER  
 ;SET LOCAL VARIABLES
 S DIC(0)="NXZ"                          ;N= INTERNAL NUMBER LOOKUP
                                         ;X= EXACT MATCH REQUIRED
                                         ;Z= VALUES RETURNED IN Y=N^S
                                         ;   N= INTERNAL ENTRY NUMBER
                                         ;   S= VALUE OF .01 FIELD
 
 I PG=0 D HEADING                        ;PRINT FIRST HEADING
 
 S LN=LN+3                               ;ADD 3 TO LINE COUNTER
 
 I LN=13 W !
 I LN>13 W !,?35,BORDER4,!
 
 S NODE=^DIZ(1991020,DA,0)               ;NODE= CURRENT ENTRY
 
 S ORG=$P(NODE,U,4)                      ;SET Organism_Code
 S DIC="^DIZ(1991018,"                   ;DIC= ORGANISM FILE
 S X=ORG                                 ;X= LOOKUP VALUE (ORG)
 D ^DIC                                  ;DO FILEMAN LOOKUP
 S ORG=$P(^DIZ(1991018,$P(Y,U,1),0),U,1)
                                         ;ORG= Organism_Name
 W ?7,$E(ORG,1,27)                       ;PRINT Organism_Name
 
 W ?35,BORDER3
 
 W !,$J($P(NODE,U,1),5)                  ;PRINT Record Number
 
 S SPEC=$P(NODE,U,5)                     ;SET Specimen_Code
 S DIC="^DIZ(1991019,"                   ;DIC= SPECIMEN FILE
 S X=SPEC                                ;X= LOOKUP VALUE (SPEC)
 D ^DIC                                  ;DO FILEMAN LOOKUP
 S SPEC=$P(^DIZ(1991019,$P(Y,U,1),0),U,1)
                                         ;SPEC= Specimen_Name
 W ?7,$E(SPEC,1,27)                      ;PRINT Specimen_Name
 
 W ?35,"|" 
 W ?36,$P(NODE,U,16)                     ;PRINT CC 
 W ?39,"|"
 W ?40,$P(NODE,U,17)                     ;PRINT E
 W ?43,"|"
 W ?44,$P(NODE,U,19)                     ;PRINT DP
 W ?47,"|"
 W ?48,$P(NODE,U,22)                     ;PRINT P
 W ?51,"|"
 W ?52,$P(NODE,U,8)                      ;PRINT AM
 W ?55,"|"
 W ?56,$P(NODE,U,13)                     ;PRINT CF
 W ?59,"|"
 W ?60,$P(NODE,U,14)                     ;PRINT C
 W ?63,"|"
 W ?64,$P(NODE,U,21)                     ;PRINT FM
 W ?67,"|"
 W ?68,$P(NODE,U,18)                     ;PRINT GM
 W ?71,"|"
 W ?72,$P(NODE,U,24)                     ;PRINT SxT
 W ?75,"|"
 W ?76,$P(NODE,U,25)                     ;PRINT TE
 W ?79,"|"
 W ?80,$P(NODE,U,9)                      ;PRINT CB
 W ?83,"|"
 W ?84,$P(NODE,U,20)                     ;PRINT NA
 W ?87,"|"
 W ?88,$P(NODE,U,15)                     ;PRINT CP
 W ?91,"|"
 W ?92,$P(NODE,U,11)                     ;PRINT CAX
 W ?95,"|"
 W ?96,$P(NODE,U,27)                     ;PRINT VA
 W ?99,"|"
 W ?100,$P(NODE,U,7)                     ;PRINT AUG
 W ?103,"|"
 W ?104,$P(NODE,U,12)                    ;PRINT CRM
 W ?107,"|"
 W ?108,$P(NODE,U,26)                    ;PRINT TI
 W ?111,"|"
 W ?112,$P(NODE,U,23)                    ;PRINT PI
 W ?115,"|"
 W ?116,$P(NODE,U,6)                     ;PRINT AK
 W ?119,"|"
 W ?120,$P(NODE,U,10)                    ;PRINT CFX
 W ?123,"|"
 Q
 
HEADING ;HEADING TO EACH PAGE OF THE VERIFICATION
 
 I PG>0 W #                              ;SEND FORMFEED
 S PG=PG+1                               ;INCREMENT PAGE NUMBER
 
 W !,BORDER,!
 W !,"BugDrug2 Verification Report",?106,"Date: ",RDATE
 W !!,"Facility: ",FAC,?106,"Page: ",PG
 W !,BORDER
 W !!,HEADER
 W !,HEADER1
 W !,BORDER2
 S LN=10                                 ;INITIALIZE LINE COUNTER
                                         ;HEADER USES 10 LINES
 Q
 
CONT ;ASK USER WHETHER TO CONTINUE WITH VERIFICATION PRINT
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE COUNTER
 S LN=0                                  ;INITIALIZE LINE COUNTER
 
 R !!!!!!!,"Do you want to print another Verification? N//",YN
                                         ;ASK USER WHETHER TO CONTINUE?
 
 I YN?1.3"?" W !!,"Answer with:  Y= Yes, N= No" G CONT
                                         ;USER WANTS HELP
 
 I (YN?1"Y")!(YN?1"y")!(YN?1"YES")!(YN?1"yes") D INPUT
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRBUG4
 K PG,LN,DIC,FAC,FCLTY,BACKUP,%DT,DATE
 K LDATE,%ZIS,BORDER,BORDER2,BORDER3,BORDER4
 K HEADER,HEADER1,Y,RDATE,DA,NODE,ORG,DIC
 K SPEC,X,YN
 Q
