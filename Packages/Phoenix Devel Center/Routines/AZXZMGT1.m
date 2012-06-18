AZXZMGT1 ;SUPPORT DATABASE MANAGEMENT PROGRAM[ 05/31/95  11:35 AM ]
 ;04/28/92  JOHN H. LYNCH
 ;
 ;THIS ROUTINE WILL ALLOW A USER TO PRINT OUT
 ;A MONTHLY REPORT SHOWING ALL SERVICE UNITS,
 ;THE NUMBER OF SUPPORT CALLS IN A GIVEN PERIOD
 ;AND THE TOTAL NUMBER OF MAN HOURS SPENT ON CALLS
 ;FOR THAT SERVICE UNIT DURING THE GIVEN PERIOD.
 
MAIN ;AZXZMGT1 PROGRAM CONTROL
 ;INITIALIZE LOCAL VARIABLES
 S FILE="1991012"          ;FILE NUMBER (SUPPDB)
 
 D MGMTPRNT
ANOTHER I LDATE'="^" R !!,"Do you want to print another Management Report? Y// ",YN
 I LDATE="^" S YN="N"
 I YN="" S YN="Y"
 I YN="Y" G MAIN
 K FILE,YN,LDATE,UDATE,X,SNUM,TIME,TTIME,CALLS
 K TCALLS,SITE,Y,LDATE1,UDATE1,SITE,SITENAME
 Q
 
MGMTPRNT ;PRINTOUT MANAGEMENT REPORT
 
 ;CLEAR SCREEN
 W @IOF
 
 W !!!,"Management Time Report Print..."
 W !!!! H 1
 
LBDATE R !,"Select Lower Boundary Date :",LDATE
 
 ;IF "^" QUIT AND RETURN TO MAINMENU
 I LDATE="^" G ANOTHER
 ;IF "" SET LDATE = LOWEST DATE POSSIBLE & UDATE = CURRENT DATE
 ;GO RIGHT TO PRINTOUT; THEN QUIT
 I LDATE="" D DEFAULT D PRINTOUT Q  
 
 ;IF "?" GIVE HELP AND RETURN TO LDATE PROMPT
 I LDATE="?" W !!,"Give the lower boundary date for Management Report Printout",!,"OR press return to receive a report on total database [mm/dd/yy].",! G LBDATE
 
 ;CHECK TO SEE IF A VALID DATE HAS BEEN ENTERED
 I LDATE'?2N1"/"2N1"/"2N W !!,"Illegal date; check format and re-enter lower boundary date.",!,*7 G LBDATE
 
 ;CONVERT DATE (CONVERT)
 S X=LDATE     ;X = DATE TO CONVERT USING ^%DT
 D CONVERT
 ;DATE FORMAT WAS ILLEGAL
 I Y<1 W !!,"Illegal date; check format and re-enter upper boundary date.",!,*7 G LBDATE
 S LDATE=Y
 
UBDATE R !,"Select Upper Boundary Date :",UDATE
 
 ;IF "^" RETURN TO PREVIOUS PROMPT (LBDATE)
 I UDATE="^" G LBDATE
 
 ;IF "" WRITE "UPPER BOUNDARY MUST BE ENTERED"
 I UDATE="" W !!,"An upper boundary date must be entered when a lower limit has been given.",!,*7 G UBDATE
 
 ;IF "?" GIVE HELP AND RETURN TO LDATE PROMPT
 I UDATE="?" W !!,"Give the upper boundary date for Management Report Printout [mm/dd/yy].",! G UBDATE
 
 ;CHECK TO SEE IF A VALID DATE HAS BEEN ENTERED
 I UDATE'?2N1"/"2N1"/"2N W !!,"Illegal date; check format and re-enter upper boundary date.",!,*7 G UBDATE
 
 ;CONVERT DATE (CONVERT)
 S X=UDATE       ;X = DATE TO CONVERT USING ^%DT
 D CONVERT
 ;DATE FORMAT WAS ILLEGAL
 I Y<1 W !!,"Illegal date; check format and re-enter upper boundary date.",!,*7 G UBDATE
 S UDATE=Y
 
 ;CHECK TO SEE IF UDATE >= LDATE
 I UDATE'>LDATE!UDATE=LDATE W !!,"Upper boundary date must be greater than or equal to lower boundary date.",!,*7 G UBDATE
 
 ;DO PRINTOUT; THEN QUIT
 D ^%ZIS U IO
 D PRINTOUT
 Q
 
PRINTOUT ;PRINTOUT MANAGEMENT REPORT
 ;SUB-ROUTINES:  PRINT2,PRINT3
 S SNUM=0             ;SNUM = SUPPORT NUMBER
 S TIME=0             ;AVERAGE TIME PER CALL PER SITE
 S TTIME=0            ;AVERAGE TIME PER CALL FOR ALL SITES
 S CALLS=0            ;NUMBER OF CALLS PER SITE
 S TCALLS=0           ;NUMBER OF CALLS FOR ALL SITES
 S SITE=1             ;INITIALIZE SITE TO FIRST IN DATABASE
 
 ;CALL DEVICE
 ;D ^%ZIS U IO
 
 S Y=LDATE             ;SET Y TO LOWER DATE FOR REPORT OUTPUT
 D DD^%DT              ;CONVERT CURRENT DATE
 S LDATE1=Y            ;REPORT LOWER DATE
 S Y=UDATE             ;SET Y TO UPPER DATE FOR REPORT OUTPUT
 D DD^%DT              ;CONVERT CURRENT DATE
 S UDATE1=Y            ;REPORT UPPER DATE
 W @IOF                ;CLEAR SCREEN WHEN OUTPUT TO TERMINAL
 W !,"________________________________________________________________________________",!
 W !,"Management Time Report",?35,"For Period:",?48,LDATE1," - ",?63,UDATE1
 W !!,"Service Unit",?31,"Number of Calls",?57,"Call Time in Hours"
 W !,"________________________________________________________________________________",!
 
PRINT2 ;SET UP TOTALS AND SITENAME
 ;SUB-ROUTINE OF PRINTOUT 
 S SNUM=$O(^DIZ(FILE,"D",SITE,SNUM))
 I SNUM'="" I ($P(^DIZ(FILE,SNUM,0),U,4)'<LDATE)&($J($P(^DIZ(FILE,SNUM,0),U,4),7,0)'>UDATE) S CALLS=CALLS+1,TIME=TIME+$P(^DIZ(FILE,SNUM,5),U,2) G PRINT2
 I SNUM'="" G PRINT2
 D SITELKUP                     ;SET SITENAME USING SITE (NUMERIC)
 D PRINT3                       ;PRINT SUB-TOTALS PER SITE
 S SITE=$O(^DIZ(FILE,"D",SITE)) ;GO TO NEXT SITE
 I SITE'="" S TTIME=TTIME+TIME,TCALLS=TCALLS+CALLS,SNUM=0,TIME=0,CALLS=0 G PRINT2
 
 W !!,"________________________________________________________________________________"
 ;******************HERE************         
 S TTIME=TTIME+TIME
 W !!,?27,"Total Calls= ",$J(TCALLS,6),?56," Total Time= ",$J(TTIME/60,6,2)
 W !!,"________________________________________________________________________________"
 W:$E(IOST)="P" @IOF
 D ^%ZISC
 Q
        
PRINT3 ;PRINTOUT EACH INDIVIDUAL SITES SUB-TOTALS IN HOURS
 ;SUB-ROUTINE OF PRINTOUT
 W !!,SITENAME,?40,$J(CALLS,6),?69,$J(TIME/60,6,2)
 Q
 
DEFAULT ;SET DEFAULT DATES TO INCLUDE ALL CURRENT LOGS
 S LDATE="2920401"    ;SET TO EARLIER THAN EARLIEST POSSIBLE LOG DATE
 S UDATE=DT           ;SET TO CURRENT DATE
 Q
 
CONVERT ;CONVERT USER DATES TO FILEMAN DATE FORMAT
 ;SET LOCAL VARIABLES
 S %DT="EXT"  ;E=ECHO ANSWER;X=EXACT DATE;T=TIME ALLOWED, NOT REQUIRED
 D ^%DT        ;VALUE RETURNED IN Y
 Q
 
SITELKUP ;SET SITENAME USING A LOOKUP IN SITES FILE
 ;SITENAME = 1ST PIECE IN SITES FILE DFN
 S SITENAME=$P(^DIZ(1991010,SITE,0),U,1)
 Q
