AZXRBUG6 ;BUGDRUG2 Report PROGRAM [ 09/23/94   9:52 AM ]
 ;Version 1
 ;"Cultured Organisms by Source"
 ;09/04/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE DATA ENTRY PERSON TO RUN A REPORT
 ;GIVING INFORMATION ON THE TOTAL NUMBER OF ENTRIES
 ;IN THE DATABASE FOR A GIVEN FACILITY AND DATE
 ;RANGE, BY SPECIMEN, ORGANISM AND THE COUNT FOR 
 ;EACH SET.
 
 ;THE ROUTINES THAT CALL AZXRBUG6:
 ;AZXRBUG3, Reports
 
 ;THE ROUTINES THAT AZXRBUG6 CALLS:
 ;AZXRBUG7, Reports Input
 ;%ZIS, Fileman Device Handler
 ;DD^%DT, Fileman Date Conversion
 ;^DIC, Fileman Lookup
 
 ;Variable List
 ;PG=          Current page count.
 ;LN=          Current line count.
 ;COUNT=       Organism count.
 ;TCOUNT=      Total Organism count.
 ;FACBKUP=     Flag returned from AZXRBUG7 with data on
 ;             whether user wants to quit.
 ;BORDER=      Special border for report.
 ;HEADER=      Special header for report.
 ;%ZIS(B)=     Don't use HOME as default device.   
 ;LDATE=       Current date used in print loop (REPORT SUB-
 ;             ROUTINE).
 ;FCLTY=       Current Facility in START LOOP.
 ;FDATE=       Users starting date input; this value is
 ;             exported from AZXRBUG7.
 ;TDATE=       Users ending date input; this value is
 ;             exported from AZXRBUG7.
 ;SPEC=        Current Specimen in START LOOP.
 ;ORG=         Current Organism in START LOOP.
 ;DA=          Current Internal Entry Number in START LOOP.
 ;Y=           Date used for date conversion.
 ;RFDATE=      Starting report date in external format.
 ;RTDATE=      Ending report date in external format.
 ;SPECCHK=     Holds current Specimen Name.
 ;DIC(0)=      
 ;DIC=         Holds the file used during lookup.
 ;X=           Lookup value for Specimen.
 ;ORGCHK=      Holds current Organism Name.
 ;YN=          Users input of whether to printer another report.
 
MAIN ;AZXRBUG6 PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE NUMBER
 S LN=0                                  ;INITIALIZE LINE COUNTER
 S COUNT=0                               ;INITIALIZE COUNT
 S TCOUNT=0                              ;INITIALIZE TCOUNT
 
 D ^AZXRBUG7                             ;CALL INPUT ROUTINE
                                         ;FOR FACILITY & DATE RANGE
 
 I FACBKUP="Y" Q                         ;FACBKUP= RETURNED FROM
                                         ;         ^AZXRBUG7;USER WANTS
                                         ;         TO QUIT
 
 D REPORT
 D CONT
 D KILL
 Q
 
REPORT ;SETUP VALUES TO PREPARE FOR REPORT PRINT
 ;SET LOCAL VARIABLES
 S BORDER="_______________________________________________________________________________________________"
 S HEADER="Specimen                                 Organism                                         Count"
 S %ZIS("B")=""                          ;DON'T USE HOME AS DEFAULT
                                         ;DEVICE
 
 D ^%ZIS U IO                            ;OPEN DEVICE
 
 I IO="" Q                               ;USER WANTS OUT
 I IO(0)=IO W !,*7,"This report must be printed.",! G REPORT
 D DTCNVRT,HEADING                       ;PRINT OUT FIRST PAGE HEADING
 
 S SPEC=""                               ;INITIALIZE SPECIMEN
 
                                         ;START START LOOP
                                         ;SPECPRT= FLAG CHECK TO SEE
                                         ;         IF SPECIMEN HAS
                                         ;         ALREADY BEEN PRINTED
                                         ;GET SPECIMEN, ORGANISM
                                         ;GET ALL VALID DATES
                                         ;PRINT OUT ALL WHEN ALL
                                         ;DATES ARE EXHAUSTED FOR THIS
                                         ;FCLTY,SPEC,ORG,LDATE COMB.
                                         ;INCREMENT THE COUNT & TCOUNT
 D 
 .F  S SPEC=$O(^DIZ(1991020,"FSOD",FCLTY,SPEC)) Q:'SPEC  S CONT="N",SPECPRT=1 D
 ..S ORG="" F  S ORG=$O(^DIZ(1991020,"FSOD",FCLTY,SPEC,ORG)) D:('ORG)&(CONT="N") NXTSPEC Q:'ORG  D
 ...S LDATE=FDATE-1 F  S LDATE=$O(^DIZ(1991020,"FSOD",FCLTY,SPEC,ORG,LDATE)) D:(('LDATE)!(LDATE>TDATE))&COUNT PRTALL Q:('LDATE)!(LDATE>TDATE)  D
 ....S DA="" F  S DA=$O(^DIZ(1991020,"FSOD",FCLTY,SPEC,ORG,LDATE,DA)) Q:'DA  D INCRMNT
 I LN>(IOSL-4) D HEADING                 ;PRINT TCOUNT ON NEXT PAGE
 W "Total Count",?90,$J(TCOUNT,5,0),!,BORDER,!
 
 
 X ^%ZIS("C")                            ;CLOSE DEVICE
 Q
 
NXTSPEC ;PREPARE FOR NEXT SPECIMEN
 W BORDER,!!
 S LN=LN+2
 Q
 
PRTALL ;PRINT OUT THE CURRENT SPECIMEN, ORGANISM
 ;AND CURRENT COUNT
 I SPECPRT S SPECPRT=0 D EXTSPEC         ;CHECK SPECPRT TO SEE IF
                                         ;SPECIMEN HAS ALREADY BEEN
                                         ;PRINTED
 D EXTORG                                ;PRINT OUT ORGANISM
 W ?90,$J(COUNT,5,0),!                   ;PRINT COUNT
 S LN=LN+1                               ;INCREMENT LINE COUNT
 S COUNT=0                               ;INITIALIZE COUNT
 D NEWPAGE                               ;CHECK IF NEW PAGE NEEDED
 Q
 
DTCNVRT ;CONVERT TDATE & FDATE TO EXTERNAL FORMAT (RTDATE, RFDATE)
 S Y=FDATE                               ;CONVERT TO EXTERNAL DATE
 D DD^%DT                                ;VALUE RETURNED IN Y
 S RFDATE=Y                              ;RFDATE= REPORT DATE
 
 S Y=TDATE                               ;CONVERT TO EXTERNAL DATE
 D DD^%DT                                ;VALUE RETURNED IN Y
 S RTDATE=Y                              ;RTDATE= REPORT DATE
 Q
 
NEWPAGE ;CHECK FOR WHETHER A NEW PAGE IS NEEDED
 I LN>(IOSL-2) S LN=0 D HEADING S CONT="Y"
                                         ;RESET LINE COUNT
                                         ;PRINT HEADING
                                         ;INCRMNT LINE COUNT
                                         ;RE-WRITE SPECIMEN
 Q
 
EXTSPEC ;CONVERT Specimen_Name TO EXTERNAL FORMAT
 S SPECCHK=SPEC                          ;SPECCHK= HOLDS CURRENT
                                         ;         Specimen_Name
 S DIC(0)="NXZ"                          ;N= INTERNAL NUMBER LOOKUP
                                         ;X= EXACT MATCH REQUIRED
                                         ;Z= VALUES RETURNED IN Y=N^S
                                         ;   N= INTERNAL ENTRY NUMBER
                                         ;   S= VALUE OF .01 FIELD
 
 S DIC="^DIZ(1991019,"                   ;DIC= ORGANISM FILE
 S X=SPECCHK                             ;X= LOOKUP VALUE (SPEC)
 D ^DIC                                  ;DO FILEMAN LOOKUP
 S SPECCHK=$P(^DIZ(1991019,$P(Y,U,1),0),U,1)
                                         ;SPECCHK= Specimen_Name
 
 W SPECCHK                               ;PRINT Specimen_Name
 Q
 
EXTORG ;CONVERT Organism_Name TO EXTERNAL FORMAT
 I CONT="Y" W SPECCHK,?41,"**Continued**",! S LN=LN+3,CONT="N"
                                         ;CONT
 
 S ORGCHK=ORG                            ;ORGCHK= HOLDS CURRENT
                                         ;        Organism_Name
 S DIC(0)="NXZ"                          ;N= INTERNAL NUMBER LOOKUP
                                         ;X= EXACT MATCH REQUIRED
                                         ;Z= VALUES RETURNED IN Y=N^S
                                         ;   N= INTERNAL ENTRY NUMBER
                                         ;   S= VALUE OF .01 FIELD
 
 S DIC="^DIZ(1991018,"                   ;DIC= ORGANISM FILE
 S X=ORGCHK                              ;X= LOOKUP VALUE (ORG)
 D ^DIC                                  ;DO FILEMAN LOOKUP
 S ORGCHK=$P(^DIZ(1991018,$P(Y,U,1),0),U,1)
                                         ;ORGCHK= Organism_Name
 
 W ?41,ORGCHK                            ;PRINT OUT ORGANISM AND COUNT
 Q
 
INCRMNT ;INCREMENT COUNT VARIABLE
 S TCOUNT=TCOUNT+1                       ;INCREMENT TOTAL COUNT
 S COUNT=COUNT+1                         ;INCREMENT CURR. ORG COUNT
 Q
 
HEADING ;PRINT OUT THE HEADING FOR EACH NEW PAGE
 
 I PG>0 W #                              ;SEND FORMFEED
 S PG=PG+1                               ;INCREMENT PAGE COUNTER
 
 W !,BORDER,!
 W !,"BugDrug2 Cultured Organisms by Source"
 W ?41,"From Date: ",RFDATE,?68,"--",?74,"To Date: ",RTDATE
 W !!,"Facility: ",FAC,?77,"Page: ",PG
 W !,BORDER
 W !!,HEADER
 W !,BORDER,!!
 
 S LN=10                                 ;INITIALIZE LINE COUNTER
                                         ;HEADER USES 10 LINES
 Q
 
CONT ;ASK USER WHETHER TO CONTINUE WITH REPORT PRINT
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE COUNTER
 S LN=0                                  ;INITIALIZE LINE COUNTER
 S COUNT=0                               ;INITIALIZE COUNT
 S TCOUNT=0                              ;INITIALIZE TCOUNT
 
 W !!!!!!!,"Do you want to print another"
 R " 'Cultured Organisms by Source' report? N//",YN
                                         ;ASK USER WHETHER TO CONTINUE?
 
 I YN?1.3"?" W !!,"Answer with:  Y= Yes, N= No" G CONT
                                         ;USER WANTS HELP
 I (YN?1"Y")!(YN?1"y")!(YN?1"YES")!(YN?1"yes") D ^AZXRBUG7 I FACBKUP="N" D REPORT G CONT
                                         ;FACBKUP= RETURNED FROM
                                         ;         ^AZXRBUG7;USER WANTS
                                         ;         TO BACK UP A PROMPT
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRBUG6
 K PG,LN,COUNT,TCOUNT,FACBKUP,BORDER,HEADER,%ZIS
 K LDATE,FCLTY,SPEC,ORG,DA,FDATE,TDATE,Y,RFDATE,RTDATE
 K FAC,SPECCHK,DIC,X,CONT,ORGCHK,YN
 Q
