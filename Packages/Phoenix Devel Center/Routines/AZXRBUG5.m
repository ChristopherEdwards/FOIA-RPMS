AZXRBUG5 ;BUGDRUG2 Report PROGRAM [ 09/23/94   9:52 AM ]
 ;Version 1
 ;"Antibiotic Sensitivities Report"
 ;09/04/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE DATA ENTRY PERSON TO RUN A REPORT
 ;GIVING INFORMATION ON THE TOTAL NUMBER OF ENTRIES
 ;IN THE DATABASE FOR A GIVEN FACILITY AND DATE
 ;RANGE FOR ALL ORGANISM SENSITIVITIES TO DIFFERENT
 ;DRUGS.
 
 ;THE ROUTINES THAT CALL AZXRBUG5:
 ;AZXRBUG3, Report Menu
 
 ;THE ROUTINES THAT AZXRBUG5 CALLS:
 ;AZXRBUG7, Report Input
 ;%ZIS=        (FILEMAN DEVICE HANDLER)
 
 ;Variable List
 ;PG=          Current page count.
 ;LN=          Current line count.
 ;FACBKUP=     Flag returned from AZXRBUG7 with data on
 ;             whether user wants to quit.
 ;FCLTY=       Internal Number of site from SITES file.
 ;BORDER1=     Special border for report.
 ;BORDER2=     Special border for report.
 ;HEADER=      Special header for report.
 ;%ZIS("B")=   Don't use HOME as default device.
 ;LDATE=       Current date used in print loop (REPORT SUB-
 ;             ROUTINE).
 ;ORG=         Current organism used in print loop (REPORT
 ;             SUB-ROUTINE).
 ;DA=          Current internal entry number used in print
 ;             loop (REPORT SUB-ROUTINE).
 ;Y=           Date used for date conversion.
 ;FDATE=       Users starting date input; this value is
 ;             exported from AZXRBUG7.
 ;TDATE=       Users ending date input; this value is
 ;             exported from AZXRBUG7.
 ;RFDATE=      Starting report date in external format.
 ;RTDATE=      Ending report date in external format.
 ;ORGCHK=      Starts as a copy of ORG but ends up in an
 ;             external form of Organism_Name.
 ;ZERONODE=    The current node of BUGDRUG2 which drug 
 ;             sensitivities are being extracted.
 ;FAC=         External form of current facility.
 ;YN=          Users input of whether to print another report.
 
 ;Variables Used for Drug Sensitivity Calculations
 ;%AK,%AM,%AUG,%C,%CAX,%CB,%CC,%CF,%CFX,%CP,%CRM,%DP
 ;%E1,%FM,%GM,%NA,%P,%PI,%SxT,%TE,%TI,%VA
 
 ;AK,AM,AUG,C,CAX,CB,CC,CF,CFX,CP,CRM,DP
 ;E1,FM,GM,NA,P,PI,SxT,TE,TI,VA
 
MAIN ;AZXRBUG5 PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE NUMBER
 S LN=0                                  ;INITIALIZE LINE COUNTER
 D INITDRG                               ;INITIALIZE DRUG VARIABLES
 
 D ^AZXRBUG7                             ;CALL INPUT ROUTINE
                                         ;FOR FACILITY & DATE RANGE
 
 I FACBKUP="Y" Q                         ;FACBKUP= RETURNED FROM
                                         ;         ^AZXRBUG7;USER WANTS
                                         ;         TO QUIT
 
 D REPORT
 D CONT
 D KILL
 Q
 
REPORT ;SETUP VALUES TO PREPARE FOR REPORT PRINT (RPTPRT)
 ;SET LOCAL VARIABLES
 S BORDER1="______________________________________________________________________________________________________________________"
 S BORDER2="_____________________________|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|"
 S HEADER="Organism                     |AK |AM |AUG|C  |CAX|CB |CC |CF |CFX|CP |CRM|DP |E  |FM |GM |NA |P  |PI |SxT|TE |TI |VA |"
 S %ZIS("B")=""                          ;DON'T USE HOME AS DEFAULT
                                         ;DEVICE
 
 D ^%ZIS U IO                            ;OPEN DEVICE
 
 I IO="" Q                               ;USER WANTS OUT
 I IO(0)=IO W !,*7,"This report must be printed.",! G REPORT
 D DTCNVRT,HEADING                       ;PRINT OUT FIRST PAGE HEADING
 
 S ORG=""                                ;INITIALIZE Organism
 F  S ORG=$O(^DIZ(1991020,"FOD",FCLTY,ORG)) Q:'ORG  S LDATE=FDATE-1 F  S LDATE=$O(^DIZ(1991020,"FOD",FCLTY,ORG,LDATE)) D:('LDATE)!(LDATE>TDATE) RPTPRT Q:('LDATE)!(LDATE>TDATE)  S DA="" F  S DA=$O(^DIZ(1991020,"FOD",FCLTY,ORG,LDATE,DA)) Q:'DA  D INCRMNT
                                         ;DO SEARCH LOOP
                                         ;CALL REPORT PRINT
 
 X ^%ZIS("C")                            ;CLOSE DEVICE
 Q
 
RPTPRT ;ACTUAL PRINTING OF REPORT DATA
 ;SETTING DRUG SENSITIVITY PERCENTAGES
 
 I (LN+4)>IOSL D HEADING                 ;CHECK IF NEW PAGE IS NEEDED
 
 D EXTORG                                ;CONVERT Organism_Name TO
                                         ;EXTERNAL FORMAT
                                         ;PRINT Organism_Name
 I AK S %AK=((%AK*100)/(AK))             ;SET DRUG SENSITIVITY
 I AM S %AM=((%AM*100)/(AM))             ;PERCENTAGES
 I AUG S %AUG=((%AUG*100)/(AUG))
 I C S %C=((%C*100)/(C))
 I CAX S %CAX=((%CAX*100)/(CAX))
 I CB S %CB=((%CB*100)/(CB))
 I CC S %CC=((%CC*100)/(CC))
 I CF S %CF=((%CF*100)/(CF))
 I CFX S %CFX=((%CFX*100)/(CFX))
 I CP S %CP=((%CP*100)/(CP))
 I CRM S %CRM=((%CRM*100)/(CRM))
 I DP S %DP=((%DP*100)/(DP))
 I E1 S %E1=((%E1*100)/(E1))
 I FM S %FM=((%FM*100)/(FM))
 I GM S %GM=((%GM*100)/(GM))
 I NA S %NA=((%NA*100)/(NA))
 I P S %P=((%P*100)/(P))
 I PI S %PI=((%PI*100)/(PI))
 I SxT S %SxT=((%SxT*100)/(SxT))
 I TE S %TE=((%TE*100)/(TE))
 I TI S %TI=((%TI*100)/(TI))
 I VA S %VA=((%VA*100)/(VA))
 
 ;PRINT DRUG SENSITIVITY PERCENTAGES
 W ?28,"%|",?30,$J(%AK,3,0),"|",?34,$J(%AM,3,0),"|"
 W ?38,$J(%AUG,3,0),"|",?42,$J(%C,3,0),"|",?46,$J(%CAX,3,0),"|"
 W ?50,$J(%CB,3,0),"|",?54,$J(%CC,3,0),"|",?58,$J(%CF,3,0),"|"
 W ?62,$J(%CFX,3,0),"|",?66,$J(%CP,3,0),"|",?70,$J(%CRM,3,0),"|"
 W ?74,$J(%DP,3,0),"|",?78,$J(%E1,3,0),"|",?82,$J(%FM,3,0),"|"
 W ?86,$J(%GM,3,0),"|",?90,$J(%NA,3,0),"|",?94,$J(%P,3,0),"|"
 W ?98,$J(%PI,3,0),"|",?102,$J(%SxT,3,0),"|",?106,$J(%TE,3,0),"|"
 W ?110,$J(%TI,3,0),"|",?114,$J(%VA,3,0),"|",!
 
 ;PRINT OUT NUMBER TESTED
 W ?28,"#|",?30,$J(AK,3,0),"|",?34,$J(AM,3,0),"|"
 W ?38,$J(AUG,3,0),"|",?42,$J(C,3,0),"|",?46,$J(CAX,3,0),"|"
 W ?50,$J(CB,3,0),"|",?54,$J(CC,3,0),"|",?58,$J(CF,3,0),"|"
 W ?62,$J(CFX,3,0),"|",?66,$J(CP,3,0),"|",?70,$J(CRM,3,0),"|"
 W ?74,$J(DP,3,0),"|",?78,$J(E1,3,0),"|",?82,$J(FM,3,0),"|"
 W ?86,$J(GM,3,0),"|",?90,$J(NA,3,0),"|",?94,$J(P,3,0),"|"
 W ?98,$J(PI,3,0),"|",?102,$J(SxT,3,0),"|",?106,$J(TE,3,0),"|"
 W ?110,$J(TI,3,0),"|",?114,$J(VA,3,0),"|",!
 
 ;INITIALIZE DRUG VARIABLES
 D INITDRG
 
 W BORDER2,!
 S LN=LN+4                               ;INCREMENT LINE COUNT
 Q
 
DTCNVRT ;CONVERT TDATE & FDATE TO EXTERNAL FORMAT (RTDATE, RFDATE)
 S Y=FDATE                              ;CONVERT TO EXTERNAL DATE
 D DD^%DT                               ;VALUE RETURNED IN Y
 S RFDATE=Y                             ;RFDATE= REPORT DATE
 
 S Y=TDATE                              ;CONVERT TO EXTERNAL DATE
 D DD^%DT                               ;VALUE RETURNED IN Y
 S RTDATE=Y                             ;RTDATE= REPORT DATE
 Q
 
EXTORG ;CONVERT Organism_Name TO EXTERNAL FORMAT FOR PRINTING
 S ORGCHK=ORG                            ;ORGCHK= Organism_Name
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
 W !,$E(ORGCHK,1,27)                     ;PRINT Organism_Name
 Q
 
INCRMNT ;INCREMENT ALL VARIABLES FOR % SENSITIVE, # TESTED
 S ZERONODE=^DIZ(1991020,DA,0)           ;ZERONODE= CURRENT ENTRY
 
 ;INCREMENT # SENSITIVE & INCREMENT # TESTED
 I $P(ZERONODE,U,6)="S" S %AK=%AK+1,AK=AK+1
 I $P(ZERONODE,U,6)="R" S AK=AK+1
 I $P(ZERONODE,U,8)="S" S %AM=%AM+1,AM=AM+1
 I $P(ZERONODE,U,8)="R" S AM=AM+1
 I $P(ZERONODE,U,7)="S" S %AUG=%AUG+1,AUG=AUG+1
 I $P(ZERONODE,U,7)="R" S AUG=AUG+1
 I $P(ZERONODE,U,14)="S" S %C=%C+1,C=C+1
 I $P(ZERONODE,U,14)="R" S C=C+1
 I $P(ZERONODE,U,11)="S" S %CAX=%CAX+1,CAX=CAX+1
 I $P(ZERONODE,U,11)="R" S CAX=CAX+1
 I $P(ZERONODE,U,9)="S" S %CB=%CB+1,CB=CB+1
 I $P(ZERONODE,U,9)="R" S CB=CB+1
 I $P(ZERONODE,U,16)="S" S %CC=%CC+1,CC=CC+1
 I $P(ZERONODE,U,16)="R" S CC=CC+1
 I $P(ZERONODE,U,13)="S" S %CF=%CF+1,CF=CF+1
 I $P(ZERONODE,U,13)="R" S CF=CF+1
 I $P(ZERONODE,U,10)="S" S %CFX=%CFX+1,CFX=CFX+1
 I $P(ZERONODE,U,10)="R" S CFX=CFX+1
 I $P(ZERONODE,U,15)="S" S %CP=%CP+1,CP=CP+1
 I $P(ZERONODE,U,15)="R" S CP=CP+1
 I $P(ZERONODE,U,12)="S" S %CRM=%CRM+1,CRM=CRM+1
 I $P(ZERONODE,U,12)="R" S CRM=CRM+1
 I $P(ZERONODE,U,19)="S" S %DP=%DP+1,DP=DP+1
 I $P(ZERONODE,U,19)="R" S DP=DP+1
 I $P(ZERONODE,U,17)="S" S %E1=%E1+1,E1=E1+1
 I $P(ZERONODE,U,17)="R" S E1=E1+1
 I $P(ZERONODE,U,21)="S" S %FM=%FM+1,FM=FM+1
 I $P(ZERONODE,U,21)="R" S FM=FM+1
 I $P(ZERONODE,U,18)="S" S %GM=%GM+1,GM=GM+1
 I $P(ZERONODE,U,18)="R" S GM=GM+1
 I $P(ZERONODE,U,20)="S" S %NA=%NA+1,NA=NA+1
 I $P(ZERONODE,U,20)="R" S NA=NA+1
 I $P(ZERONODE,U,22)="S" S %P=%P+1,P=P+1
 I $P(ZERONODE,U,22)="R" S P=P+1
 I $P(ZERONODE,U,23)="S" S %PI=%PI+1,PI=PI+1
 I $P(ZERONODE,U,23)="R" S PI=PI+1
 I $P(ZERONODE,U,24)="S" S %SxT=%SxT+1,SxT=SxT+1
 I $P(ZERONODE,U,24)="R" S SxT=SxT+1
 I $P(ZERONODE,U,25)="S" S %TE=%TE+1,TE=TE+1
 I $P(ZERONODE,U,25)="R" S TE=TE+1
 I $P(ZERONODE,U,26)="S" S %TI=%TI+1,TI=TI+1
 I $P(ZERONODE,U,26)="R" S TI=TI+1
 I $P(ZERONODE,U,27)="S" S %VA=%VA+1,VA=VA+1
 I $P(ZERONODE,U,27)="R" S VA=VA+1
 Q
 
HEADING ;PRINT OUT THE HEADING FOR EACH NEW PAGE
 
 I PG>0 W #                              ;SEND FORMFEED
 S PG=PG+1                               ;INCREMENT PAGE COUNTER
 
 W !,BORDER1,!
 W !,"BugDrug2 Antibiotic Sensitivity"
 W ?64,"From Date: ",RFDATE,?91,"--",?97,"To Date: ",RTDATE
 W !!,"Facility: ",FAC,?100,"Page: ",PG
 W !,BORDER1
 W !!,HEADER
 W !,BORDER2,!
 
 S LN=10                                 ;INITIALIZE LINE COUNTER
                                         ;HEADER USES 10 LINES
 Q
 
INITDRG ;INITIALIZE THE DRUG VARIABLES
 S %AK=0,%AM=0,%AUG=0,%C=0,%CAX=0,%CB=0,%CC=0,%CF=0,%CFX=0
 S %CP=0,%CRM=0,%DP=0,%E1=0,%FM=0,%GM=0,%NA=0,%P=0,%PI=0
 S %SxT=0,%TE=0,%TI=0,%VA=0
 S AK=0,AM=0,AUG=0,C=0,CAX=0,CB=0,CC=0,CF=0,CFX=0
 S CP=0,CRM=0,DP=0,E1=0,FM=0,GM=0,NA=0,P=0,PI=0
 S SxT=0,TE=0,TI=0,VA=0
                                         ;INITIALIZE DRUG VARIABLES
 Q
 
CONT ;ASK USER WHETHER TO CONTINUE WITH REPORT PRINT
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE COUNTER
 S LN=0                                  ;INITIALIZE LINE COUNTER
 D INITDRG                               ;INITIALIZE DRUG VARIABLES
 
 W !!!!!!!,"Do you want to print another"
 R " 'Antibiotic Sensitivity' report? N//",YN
                                         ;ASK USER WHETHER TO CONTINUE?
 
 I YN?1.3"?" W !!,"Answer with:  Y= Yes, N= No" G CONT
                                         ;USER WANTS HELP
 I (YN?1"Y")!(YN?1"y")!(YN?1"YES")!(YN?1"yes") D ^AZXRBUG7 I FACBKUP="N" D REPORT G CONT
                                         ;FACBKUP= RETURNED FROM
                                         ;         ^AZXRBUG7;USER WANTS
                                         ;         TO QUIT
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRBUG5
 K PG,LN,FACBKUP,BORDER1,BORDER2,HEADER,%ZIS
 K LDATE,FCLTY,ORG,DA,%AK,AK,%AM,AM,%AUG,AUG
 K %C,C,%CAX,CAX,%CB,CB,%CC,CC,%CF,CF
 K %CFX,CFX,%CP,CP,%CRM,CRM,%DP,DP,%E1,E1
 K %FM,FM,%GM,GM,%NA,NA,%P,P,%PI,PI
 K %SxT,SxT,%TE,TE,%TI,TI,%VA,VA,Y,FDATE,TDATE
 K RFDATE,ORGCHK,DIC,ZERONODE,FAC,YN
 Q
