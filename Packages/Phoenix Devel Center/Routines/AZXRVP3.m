AZXRVP3 ;PAO/IHS/JHL;VISITS BY PROVIDERS[ 08/31/93  11:22 AM ]
 ;Version 1;VISITS BY PROVIDERS;;****;DATE OF RELEASE HERE
 ;JOHN H. LYNCH
 ;
 ;THIS ROUTINE WILL PRODUCE THE ACTUAL REPORT OUTPUT.
 ;THIS OUTPUT WAS CREATED USING THE CRITERIA INPUT
 ;FROM THE USER IN AZXRVP1, AZXRVP1B, AZXRVP1C, AZXRVP1D,
 ;AND AZXRVP2.
 
 ;THE ROUTINES THAT CALL AZXRVP3
 ;AZXRVP2, Report Input Routine
 
 ;THE ROUTINES THAT AZXRVP3 CALLS:
 ;NONE
 
 ;Variable List
 ;PG=          Current page count.
 ;LN=          Current line count.
 ;AZXRNAME=    Current name subscript to print.
 ;AZXRCOVS=    Current coverage type to print.
 ;AZXRDATE=    Current date to print.
 ;AZXRENT=     Current DFN to print.
 ;J,K=         Counter variables.
 
 
MAIN ;AZXRVP3 PROGRAM CONTROL    
 S PG=0                                  ;INIT PAGE COUNT
 D HEADING1,HEADING2,HEADING3            ;DO INITIAL HEADINGS
 I $O(^AZXRTMP1("AAAAAA"))="" W !,"No data found for given criteria." D KILL K ^AZXRTMP1(0,0) Q                               ;NO DATA, UNLOCK TEMP GLOBAL
                                         ;AND QUIT
 D DOPRINT                               ;DO PRINT LOOP
 D:$D(^AZXRTMP1(1))!$D(^AZXRTMP1(2))!$D(^AZXRTMP1(3))!$D(^AZXRTMP1(4)) ERRPRINT
                                         ;DO ERROR PRINT?
 K ^AZXRTMP1(0,0)                        ;UNLOCK TEMP GLOBAL
 D KILL                                  ;KILL OFF ALL LOCAL VARIABLES
 Q
 
HEADING1 ;MAIN REPORT HEADING
 W #                                     ;DO A FORMFEED
 S PG=PG+1                               ;INCR PG COUNT
 W "_______________________________________________________________________________________________",!!
 W "Visits by Providers",?31,"-CONFIDENTIAL-",?59,"From: ",^AZXRTMP1(0,"FDT",1),?79,"To: ",^AZXRTMP1(0,"TDT",1),!
 W "for ",?4,^AZXRTMP1(0,"FAC",1),?79,"Pg: ",PG,!
 W "_______________________________________________________________________________________________",!!
 S LN=6                                  ;RESET LN COUNT
 Q
 
HEADING2 ;REPORT CRITERIA HEADING
 W ?30,"-SEARCH CRITERIA-",!
 W "Primary Providers:",?59,"Affiliations:",!!
 F J=1:1:10 W:$D(^AZXRTMP1(0,"PROV",J)) ?5,^AZXRTMP1(0,"PROV",J) W:$D(^AZXRTMP1(0,"AFF",J)) ?65,^AZXRTMP1(0,"AFF",J) W !
 W !,"Clinic Stops:",?59,"Coverage Types:",!!
 F J=1:1:5 W:$D(^AZXRTMP1(0,"CLNC",J)) ?5,^AZXRTMP1(0,"CLNC",J) W:$D(^AZXRTMP1(0,"COV",J)) ?65,^AZXRTMP1(0,"COV",J) W !
 W "_______________________________________________________________________________________________",!!
 S LN=LN+23                              ;INCR LN COUNT FOR LABELS
 Q
 
HEADING3 ;REPORT LABEL HEADING
 W "Patient Name",?31,"HRN",?50,"Date",?65,"Clinic Stop",!
 W "Primary Provider",?65,"Affiliation",!
 W "Coverage Types",!
 W "_______________________________________________________________________________________________",!!
 S LN=LN+5                               ;INCR LN COUNT
 Q
 
HEADING4 ;ERROR REPORT HEADING
 W #                                     ;FORM FEED
 S PG=PG+1                               ;INCR PAGE COUNT
 W "_______________________________________________________________________________________________",!!
 W "Visits by Providers",?31,"-ERROR REPORT-",?59,"From: ",^AZXRTMP1(0,"FDT",1),?79,"To: ",^AZXRTMP1(0,"TDT",1),!
 W "for ",?4,^AZXRTMP1(0,"FAC",1),?79,"Pg: ",PG,!
 W "_______________________________________________________________________________________________",!!
 S LN=6                                  ;RESET LINE COUNT
 Q
 
DOPRINT ;DO PRINT LOOP
 S AZXRNAME="AAAAAA"                     ;START POINT
 F  S AZXRNAME=$O(^AZXRTMP1(AZXRNAME)) Q:AZXRNAME=""  S AZXRDATE=0 F  S AZXRDATE=$O(^AZXRTMP1(AZXRNAME,AZXRDATE)) Q:AZXRDATE=""  S AZXRENT=0 F  S AZXRENT=$O(^AZXRTMP1(AZXRNAME,AZXRDATE,AZXRENT)) Q:AZXRENT=""  D PRNTDATA
 Q
 
PRNTDATA ;PRINT DATA FOR EACH ENTRY
 I LN+8>IOSL D HEADING1                  ;NEED PAGE BREAK
 W AZXRNAME,?31,$P(^AZXRTMP1(AZXRNAME,AZXRDATE,AZXRENT),U,1)
                                         ;PAT. & HRN
 W ?50,AZXRDATE,?65,$P(^AZXRTMP1(AZXRNAME,AZXRDATE,AZXRENT),U,2),!
                                         ;DATE & CLINIC STOP
 W $P(^AZXRTMP1(AZXRNAME,AZXRDATE,AZXRENT),U,3)
                                         ;PRIMARY PROVIDER
 W ?65,$P(^AZXRTMP1(AZXRNAME,AZXRDATE,AZXRENT),U,4),!
                                         ;AFFILIATION 
 S LN=LN+2                               ;INCR LINE COUNT
 F J=5:1:10 S AZXRCOVS=$P(^AZXRTMP1(AZXRNAME,AZXRDATE,AZXRENT),U,J) Q:AZXRCOVS=""  W AZXRCOVS,! S LN=LN+1
 W ! S LN=LN+1                           ;SKIP LINE
 Q
 
ERRPRINT ;PRINT OUT ALL ERRORS
 D HEADING4                              ;DO ERROR RPT HEADING
 I $D(^AZXRTMP1(1)) D
 .W "Error 1  -No data found for these visits,",!
 .W "         -Please call Phoenix Area Office:",!!
 .S LN=LN+3                               ;INCR LINE COUNT
 .S J=0,K=9
 .F  S J=$O(^AZXRTMP1(1,"ERROR1",J)) Q:J=""  D:LN+3>IOSL HEADING4 W ?K,^AZXRTMP1(1,"ERROR1",J) S K=K+41 I K>50 W ! S K=9,LN=LN+1
 .W !! S LN=LN+2
 I $D(^AZXRTMP1(2)) D
 .W "Error 2  -The following patients need to be registered at ",^AZXRTMP1(0,"FAC",1),":",!!
 .S LN=LN+2                               ;INCR LINE COUNT
 .S J=0,K=9
 .F  S J=$O(^AZXRTMP1(2,"ERROR2",J)) Q:J=""  D:LN+3>IOSL HEADING4 W ?K,$P(^DPT(^AZXRTMP1(2,"ERROR2",J),0),U,1) S K=K+41 I K>50 W ! S K=9,LN=LN+1
 .W !! S LN=LN+2
 I $D(^AZXRTMP1(3)) D
 .W "Error 3  -Use Patient Registration to add a state for Medicaid for these patients:",!!
 .S LN=LN+2                               ;INCR LINE COUNT
 .S J=0,K=9
 .F  S J=$O(^AZXRTMP1(3,"ERROR3",J)) Q:J=""  D:LN+3>IOSL HEADING4 W ?K,$P(^DPT(^AZXRTMP1(3,"ERROR3",J),0),U,1) S K=K+41 I K>50 W ! S K=9,LN=LN+1
 .W !! S LN=LN+2
 I $D(^AZXRTMP1(4)) D
 .W "Error 4  -No dependent entries found for these visits,",!
 .W "         -Please call Phoenix Area Office:",!!
 .S LN=LN+3                               ;INCR LINE COUNT
 .S J=0,K=9
 .F  S J=$O(^AZXRTMP1(4,"ERROR4",J)) Q:J=""  D:LN+3>IOSL HEADING4 W ?K,$P(^AZXRTMP1(4,"ERROR4",J),U,1) S K=K+8 I K>86 W ! S K=9,LN=LN+1
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRVP3
 K PG,LN,AZXRNAME,AZXRCOVS,AZXRDATE,AZXRENT,J,K
 Q
