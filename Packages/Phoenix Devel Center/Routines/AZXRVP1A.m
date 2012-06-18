AZXRVP1A ;PAO/IHS/JHL;VISITS BY PROVIDERS[ 08/31/93  11:22 AM ]
 ;Version 1;VISITS BY PROVIDERS;;****;DATE OF RELEASE HERE
 ;JOHN H. LYNCH
 ;
 ;ALLOWS THE USER TO INPUT THE FACILITY, DATE RANGES, 
 ;CLINIC STOPS, AFFILIATIONS, PRIMARY PROVIDERS, AND
 ;COVERAGE TYPES TO RECEIVE BACK ALL VISITS BY PROVIDERS.
 ;
 ;AZXRVP1A, INPUT PROGRAM 1 OF 4.
 
 ;THE ROUTINES THAT CALL AZXRVP1A:
 ;NONE
 
 ;THE ROUTINES THAT AZXRVP1A CALLS:
 ;AZXRVP1B, 2nd input program.
 ;^DIC, Fileman Lookup.
 
 ;Variable List
 ;DTIME=       Default timeout on all prompts.
 ;DIC=         Global root of file for Fileman Lookup.
 ;DIC(0)=      Fileman Lookup parameters.
 ;DIC("A")=    Fileman Lookup default prompt.
 ;AZXRBCK=     Flags whether user wants to back up one prompt.
 ;AZXRFAC=     [1]Facility in external form^[2]DFN from LOCATION file.
 ;AZXRQUIT=    Flag to check if ^AZXRTMP1 is locked.
 ;X=           Lookup value from user input.
 ;Y=           Returned lookup value from ^DIC.
 
 
MAIN ;AZXRVP1A PROGRAM CONTROL    
 S DTIME="60"                            ;DEFAULT TIMEOUT ON PROMPTS
 D VPCHK                                 ;ONLY ONE REPORT CAN RUN
 I AZXRQUIT="Y" K DTIME,AZXRQUIT Q       ;KILL LOCAL VARS AND QUIT
 
 D INPUT                                 ;GET USER INPUTS
 D KILL                                  ;KILL OFF ALL LOCAL VARIABLES
 Q
 
VPCHK ;ONLY ONE REPORT CAN RUN AT A TIME
 S AZXRQUIT="N"                          ;INIT AZXRQUIT
 I $D(^AZXRTMP1(0,0)) W !!,?21,"This report is already being run.",!,?21,"Please try again later." S AZXRQUIT="Y" H 3 Q
                                         ;CHK IF TEMP GLOBAL LOCKED
 S ^AZXRTMP1(0,0)="GLOBAL LOCKED^KILL THIS NODE IF NEEDED TO BE UNLOCKED"
                                         ;LOCK GLOBAL
 Q
 
INPUT ;ASK USER FOR THE FACILITY TO USE FOR REPORT
 ;THEN CALL AZXRFDT ROUTINE
 
 W @IOF                                  ;CLEAR SCREEN
 
 W !!!,"Visits by Providers...",!!
 
FACILITY ;CALL FILEMAN LOOKUP FOR FACILITY
 ;SET LOCAL VARIABLES
 S DIC="^AUTTLOC("                       ;GLOBAL ROOT OF LOCATION FILE
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
 D ^DIC
 
 I (X="^")!(X="")!($D(DTOUT)) K DTOUT,^AZXRTMP1(0,0) Q  
                                         ;X= USER INPUT VALUE FROM ^DIC
                                         ;   OR A TIMEOUT HAS OCCURRED
                                         ;   TIME TO QUIT PROGRAM
                                         ;   CLEAR LOCK ON TEMP GLOBAL
 
 S $P(AZXRFAC,U,2)=Y(0,0)                ;AZXRFAC= FACILITY IN EXTERNAL
                                         ;         FORM
 
 S $P(AZXRFAC,U)=$P(Y,U,1)               ;AZXRFAC= INTERNAL NUMBER IN 
                                         ;         LOCATION FILE
 
 D FDATE^AZXRVP1B                        ;CALL INPUT ROUTINE 2,
                                         ;AZXRVP1B
 
 G:AZXRBCK="Y" FACILITY                  ;USER WANTS TO BACKUP "^"
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRVP1A
 K DTIME,DIC,X,AZXRFAC,Y,AZXRBCK,%DT,AZXRFDT,AZXRTDT
 K J,K,L,AZXROK,AZXRCLNC,AZXRAFF,AZXRAFFN,AZXRAFOK
 K AZXRPROV,AZXRCOV,%ZIS,%IS,AZXRAFFS,DINUM
 Q
