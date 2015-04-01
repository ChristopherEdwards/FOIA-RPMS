BARMPAS ; IHS/SD/LSL - Patient Account Statement ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**2,4,5,19,20,23,24**;OCT 26, 2005;Build 69
 ;
 ; IHS/SD/LSL - 04/22/03 - V1.7 Patch 2
 ; IHS/SD/LSL - 12/04/04 - V17 Patch 4 - IM11692
 ;      Modify code to allow tasked option to catch all facilities.
 ; IHS/SD/LSL - 02/11/04 - V1.7 Patch 5 - IM12222
 ;      Modify MARKACC to allow marking of patient's registered
 ;      at the parents satellite. 
 ; IHS/SD/POTT HEAT80718 ADDED SORTING OPTION BY PATNAME ;BAR1.8*23
 ; IHS/SD/POTT HEAT95153 BAR1.8*23
 ; IHS/SD/POTT HEAT63286 added call to populate array BARPSAT ;BAR1.8*23
 ; IHS/SD/POTT HEAT91646 added OPTION 'PUR' & 'REB' ;BAR1.8*23
 ; IHS/SD/POTT HEAT106730 BAR1.8*23
 ; IHS/SD/POTT HEAT152220 2/11/2014 FIX PRO PRINT AND CLEANUP ;BAR1.8*24
 ; IHS/SD/POTT HEAT100207 FIXED AGE 2/18/2014 ;BAR1.8*24
 ; ********************************************************************
 Q
TASK ; EP
 ; Called from SCHEDULED OPTION BAR MAN ACCOUNT STATEMENT
 ; Start with last run date and go to Today.
 ; Find BAR ACCOUNT STATEMENT in Option Scheduling File
 N BARXXX
 D INIT^BARUTL
 S BARXXX=$$GETX() ;
 I BARXXX<0 QUIT
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY
 D INITXTMP(BARXXX,BARDTB,BARDTE,BARSRTBY,BARRUNDT) ;;BAR1.8*23
 D BARPSAT^BARUTL0 ;;BAR1.8*23 HEAT #63286  added call to populate array BARPSAT
 S BARHOLD=DUZ(2)
 S DUZ(2)=0 F  S DUZ(2)=$O(^BARAC(DUZ(2))) Q:'+DUZ(2)  D
 . S BARACDA=0 F  S BARACDA=$O(^BARAC(DUZ(2),"PAS","Y",BARACDA)) Q:'BARACDA  D ACCOUNT(BARACDA)
 S DUZ(2)=BARHOLD
 D MAIL^XBMAIL("BARZ MANAGER","MAIL^BARMPAS")
 Q
 ; ********************************************************************
 ;
GETX() ;
 K DIC,DR,DIE,DA
 S DIC=19.2                                    ; Option Scheduling File
 S X="BAR ACCOUNT STATEMENT"
 S DIC(0)="ZM"
 D ^DIC
 I Y<1 Q -1  ;NO SETUP
 S BARSCHED=+Y                                 ; Option IEN
 S BARFREQ=$$GET1^DIQ(19.2,BARSCHED,6)         ; Option schedule freq
 S X1=DT
 S X2=-90
 D C^%DTC
 F  S X=$$SCH^XLFDT(BARFREQ,X) Q:X>DT  S BARDTB=X  ;Last run date
 S BARDTE=DT                                    ; Today
 D NOW^%DTC
 S BARRUNDT=%
 S X1=DT
 S X2=+15
 D C^%DTC
 Q X
ACCOUNT(BARACDA) ;
 ; Find Bills where the AR Account is marked for
 ; Patient Account Statement
 ;D INIT^BARUTL  ; this keeps it from printing to a slave printer
 S (BARBL,BARTOT,BARVISL,BARDOSV)=0
 D BARPSAT^BARUTL0 ;;BAR1.8*23 HEAT63286 16-MAR-2012 added call to populate array BARPSAT
 S BARPATNM=$$PATNAME(BARACDA)   ;BAR1.8*23
 I BARSRTBY=0 S BARPATNM="X" ;NOT SORTED BY NAMES - CREATE DUMMY NAME BAR1.8*23
 F  S BARBL=$O(^BARBL(DUZ(2),"ABAL",BARACDA,BARBL)) Q:'+BARBL  D
 . S BARBAL=$$GET1^DIQ(90050.01,BARBL,15)  ;CURRENT BILL AMOUNT
 . Q:BARBAL'>0
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS - VA format
 . I BARVISL="" S BARVISL="??"
 . I BARDOSV="" S BARDOSV="??"
 . S BARTOT=BARTOT+BARBAL
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),1,BARPATNM,BARACDA,"OB",BARBL)="" ;NODE 1 FOR 'OB'
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),1,BARPATNM,BARACDA,BARVISL,BARDOSV,"OB",BARBL)="" ;NODE 1 FOR 'OB'
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),0,BARPATNM,BARACDA,BARVISL,BARDOSV,BARBL,"A")=""
 ; 
 S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),1,BARPATNM,BARACDA,"OB")=BARTOT
 ;
 ;   It currently kills all previous entries if the Balance = 0
 I BARTOT=0 K ^XTMP("BARPAS"_BARRUNDT,DUZ(2),0,BARPATNM,BARACDA)
 ; -------------------------------------------------------------------------
 ; Find bills by patient balance
 ; -------------------------------------------------------------------------
 S BARPAT=$$GET1^DIQ(90050.02,BARACDA,1.001)
 S BARBL=0 F  S BARBL=$O(^BARBL(DUZ(2),"APBAL",BARPAT,BARBL)) Q:'+BARBL  D
 . ; Add sorts:  VisitLocation and DOS
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),0,BARPATNM,BARACDA,BARVISL,BARDOSV,BARBL,"P")=""
 . Q
 ; -------------------------------------------------------------------------
 ; Find bills by patient
 ; -------------------------------------------------------------------------
 S BARBL=0 F  S BARBL=$O(^BARBL(DUZ(2),"C",BARPAT,BARBL)) Q:'+BARBL  D
 . S BARBAL=$$GET1^DIQ(90050.01,BARBL,15)
 . Q:BARBAL'>0
 . ; IHS/SD/PKD 1.8*19 9/10/10
 . ; Add sorts:  VisitLocation and DOS
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS
 . ;STANDARD SORTING (NO PATNAME)
 . I BARVISL="" S BARVISL="??"
 . I BARDOSV="" S BARDOSV="??"
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),0,BARPATNM,BARACDA,BARVISL,BARDOSV,BARBL,"P")=""
 . D ABAL(BARBL)
 ;
 ; -------------------------------------------------------------------------
 ; Find bills by transaction
 ; -------------------------------------------------------------------------
 S BARTR=BARDTB
 F  S BARTR=$O(^BARTR(DUZ(2),"AE",BARACDA,BARTR)) Q:BARTR\1>BARDTE  Q:'+BARTR  D
 . S BARBL=$$GET1^DIQ(90050.03,BARTR,4,"I")
 . Q:'+BARBL                                   ; No bill on transaction
 . ; IHS/SD/PKD 1.8*19 9/10/10
 . ; Add sorts:  VisitLocation and DOS
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS
 . ;STANDARD SORTING (NO PATNAME)
 . I BARVISL="" S BARVISL="??"
 . I BARDOSV="" S BARDOSV="??"
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),0,BARPATNM,BARACDA,BARVISL,BARDOSV,BARBL,"T")=""
 . D ABAL(BARBL)
 Q
 ; ********************************************************************
 ;
MAIL ; EP - MAIL MESSAGE TEXT
 ;;A/R ACCOUNTS (PATIENTS) MONTHLY STATEMENTS
 ;;This is to notify you that an automatic generation
 ;;of statements for A/R Patient Accounts has completed.
 ;;..
 ;;Please use the Print Patient Account Statement option
 ;;to print the statements to a printer.
 Q
 ; ********************************************************************
 ;
MANUAL ; EP
 ; Called from Print Adhoc Patient Account Statement AR Menu Option
 ; Ask user to select AR Account marked for Patient Account Statement
 D ASKACCT                     ; Ask AR Account
 Q:Y'>0
 Q:'$D(BARACDA)                ; No acct selected
 D DATE(1)                     ; Ask date range AND init ^XTMP
 I +BARDTB<1 Q                 ; Dates answered wrong
 D GETHDR^BARMPAS3             ; MOVED INTO LOOP
 Q:'$D(BARHDRDA)
 S BARQ("RC")="LOOP^BARMPAS"   ; Build tmp global with data
 S BARQ("RP")="PRINT^BARMPAS3,CLEANUP^BARMPAS" ;HEAT#152220 BAR1.8*24
 S BARQ("NS")="BAR"            ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"   ; HEAT#152220 BAR1.8*24
 D GETMSG
 D ^BARDBQUE                   ; Double queuing
 ;D CLEANUP^BARMPAS            ; Clean-up routine 11/05/2013 LINE COMMENTED OUT: HEAT#152220 BAR1.8*24
 D PAZ^BARRUTL                 ; Press return to continue
 Q
CLEANUP K ^XTMP("BARPAS"_BARRUNDT)   ; cleanup scratch global for option PRO 10/10/2013
 Q
 ; ********************************************************************
 ;^XTMP("BARPAS3130904.070754",0,"DT")="2991227^3130904"
 ;                           "SCOPE")="PRO"
 ;                           "SORTBY")=1
 ;
 ;IHS/SD/AR PATCH 19 06/01/2010
GETMSG ;
 ; ASK USER TO INCLUDE A MESSAGE WITH REPORTS
 K BARPTMSG
 S BARPTMSG=""
 W !!
 K DIR
 S DIR("A")="Add a patient statement message"
 S DIR("?")="Enter up to 80 characters as a message appended to statement."
 S DIR(0)="FO^0:80^"
 D ^DIR
 Q:Y=""
 S BARPTMSG=X
 Q
ASKACCT ;
 ; Ask user to select AR Account marked for Patient Account Statement
 W !!
 K DIC
 S DIC("A")="Select Patient-Account: "
 S DIC=90050.02
 S DIC(0)="AEQM"
 S DIC("S")="I $D(^BARAC(DUZ(2),""PAS"",""Y"",+Y))"
 D ^DIC
 Q:Y'>0
 S BARACDA=+Y
 Q
 ; ********************************************************************
 ;
DATE(BARMODE) ;
 ; Select date range
DT1 ;
 S BARDTB=$$DATE^BARDUTL(1)
 I BARDTB<1 Q
 S BARDTE=$$DATE^BARDUTL(2)
 I BARDTE<1 W ! G DT1
 I BARDTE<BARDTB D  G DT1
 . W *7
 . W !!,"The END date must not be before the START date.",!
 I BARMODE>1 QUIT  ;CALL W/O INIT
 ;--------------------MANUAL (PRO) STATEMET --------------
 D NOW^%DTC
 S BARRUNDT=%
 S X1=DT
 S X2=+15
 D C^%DTC
 K ^XTMP("BARPAS"_BARRUNDT)
 S ^XTMP("BARPAS"_BARRUNDT,0)=X_"^"_DT_"^"_"BAR ACCOUNT STATEMENT"
 S ^XTMP("BARPAS"_BARRUNDT,0,"DT")=BARDTB_"^"_BARDTE
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY
 S ^XTMP("BARPAS"_BARRUNDT,0,"SORTBY")=BARSRTBY ;P.OTT
 S ^XTMP("BARPAS"_BARRUNDT,0,"SCOPE")="PRO"
 Q
 ; ********************************************************************
 ;
LOOP ; EP
 ; Part of manual process
 ; IHS/SD/PKD 1.8*20 2/24/11 Set XTMP date headers
 ; If Device definition calls for Start Time, this will capture
 ; Run Dates rather than having them blank
 I $G(BARDTB)=""!($G(BARDTE)="") Q  ;Need dates
 D ACCOUNT(BARACDA)
 Q
 ; ********************************************************************
 ;
MARKACC ; EP
 ; Called from Patient Accounts for Statements AR Menu option
 W !
 F  D  Q:BARAC'>0
 . W !
 . K DIC,DIE,DA,DR,X,Y
 . S DIC=90050.02
 . S DIC(0)="AEQZM"
 . S DIC("S")="I $$GET1^DIQ(90050.02,+Y,1)=9000001"
 . S DIC("W")="W ?50,$$GET1^DIQ(90050.02,+Y,101)"
 . D ^DIC
 . S BARAC=+Y
 . Q:Y'>0
 . S DIE=DIC
 . S DA=+Y
 . S DR="101"
 . D ^DIE
 Q
REBUILD ;EP P.OTT
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY
 W !!!,"NOTE: This procedure will *collect* statements for printing."
 W !,"Statements will be sorted by ",$P("Billing location, Account Number;Billing location, Patient name",";",BARSRTBY+1)
 W !,"When done use the PAS>PRA menu option to print the collected statements."
 W !
RBLD D NOW^%DTC
 S BARRUNDT=%
 D DATE(2)                                     ; Ask date range AND *do not* init ^XTMP
 I +BARDTB<1 Q                                 ; Dates answered wrong
 I BARDTE>(BARRUNDT\1) D  G RBLD
 . W !!,"END date cannot be a future day",!
 W !
 S DIR("A")="OK to start the re-build process"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 Q
 ;---------------------
 S BARTMPD1=BARDTB
 S BARTMPD2=BARDTE
 S BARXXX=$$GETX() I BARXXX<0 D  QUIT
 . W !,"**WARNING: The Option Scheduling File for BAR ACCOUNT STATEMENT has not been set up."
 . W !,"Cannot proceed."
 . W !! H 2
 S BARSRTBY=$$GETSRTBY() ;GET SORT-BY
 S BARDTB=BARTMPD1
 S BARDTE=BARTMPD2
 D INITXTMP(BARXXX,BARDTB,BARDTE,BARSRTBY,BARRUNDT) ;P.OTT
 D GETHDR^BARMPAS3
 Q:'$D(BARHDRDA)
 S BARHOLD=DUZ(2)
 S DUZ(2)=0 F  S DUZ(2)=$O(^BARAC(DUZ(2))) Q:'+DUZ(2)  D
 . S BARACDA=0 F  S BARACDA=$O(^BARAC(DUZ(2),"PAS","Y",BARACDA)) Q:'BARACDA  D ACCOUNT(BARACDA)
 S DUZ(2)=BARHOLD
 W !,"--- Statements collected."
 S DIR("A")="Do you want to send e-mail notification"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y=1 D MAIL^XBMAIL("BARZ MANAGER","MAIL^BARMPAS")
 D PAZ^BARRUTL                       ; Press return to continue
 Q
ASKMODE() ;         
 K DIRUT,DIR,Y
 S Y=$$DIR^XBDIR("S^1:Print Statement for Individual Patient;2:Collect Statements for ALL Flagged Patients","Select Statement Type ","","","","",1)
 K DA
 Q Y
PURGE ;
 NEW BARTMP,BARTMP0,BARARR
 S BARCNT=0,(BARTMP,BARTMP0)="BARPAS" F  S BARTMP=$O(^XTMP(BARTMP)) Q:BARTMP=""  Q:BARTMP'[BARTMP0  S BARCNT=BARCNT+1,BARARR(BARCNT)=BARTMP
 I 'BARCNT W !!,"NO ENTRIES TO PURGE",!! QUIT
 D LISTRUNS
 I BARCNT=1 W !!,"CANNOT PURGE THE ONLY PAS RUN ON FILE.",!! QUIT
 I BARCNT>2 W !,"Entries 1-",BARCNT-1," can be purged."
 I BARCNT=2 W !,"Entry 1 can be purged."
 S DIR("A")="OK to purge?"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 Q
 F I=1:1:BARCNT-1 D
 . W !,"PURGING ",BARARR(I)
 . K ^XTMP(BARARR(I))
 . Q
 W !,"LAST ENTRY ",BARARR(BARCNT)," NOT PURGED."
 D PAZ^BARRUTL                       ; Press return to continue
 Q
PATNAME(BARACDA) ;P.OTT
 NEW BARDFN,BARRET,BARNAM
 S BARDFN=$$GET1^DIQ(90050.02,BARACDA,1.001)   ; IEN to Patient file
 S BARNAM=$$GET1^DIQ(9000001,BARDFN,.01)
 I BARNAM="" S BARNAM="UNKN"
 Q BARNAM_"^"_BARDFN ;TO SEPARATE BILLS FOR 2 PATIENTS WITH THE SAME NAME
 ;
 ;LIST EXISTING STATEENTS IN XTMP
LIST S X="BARPAS" F  S X=$O(^XTMP(X)) Q:X=""  Q:X'["BARPAS"  W !,X
 Q
GETSRTBY() ;P.OTT
 NEW BARSRT,X
 ;BARSRTBY=0 - NO ALPHA SORTING
 ;BARSRTBY=1 - ALPHA SORTING (PATNAME^PATEIN)
 ;INTERNAL VALUES
 ; 1        BILLING LOC, ACCOUNT NUMBER
 ; 2        BILLING LOC, PATIENT NAME
 S BARSRT=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),20)),U,4)
 I +BARSRT=0 Q 0  ;IF NOT SET: 0
 I BARSRT S BARSRT=BARSRT-1 ;1,2->0,1
 Q BARSRT
 ;
INITXTMP(X,BARDTB,BARDTE,BARSRTBY,BARRUNDT) ;P.OTT
 K ^XTMP("BARPAS"_BARRUNDT)
 S ^XTMP("BARPAS"_BARRUNDT,0,"DT")=BARDTB_U_BARDTE
 S ^XTMP("BARPAS"_BARRUNDT,0)=X_"^"_BARDTE_"^"_"BAR ACCOUNT STATEMENT"
 S ^XTMP("BARPAS"_BARRUNDT,0,"SORTBY")=BARSRTBY ;P.OTT
 S ^XTMP("BARPAS"_BARRUNDT,0,"SCOPE")="PRA"
 Q
LISTRUNS ;
 S BARCNT=0
 S BAR1="BARPAS"
 F  S BAR1=$O(^XTMP(BAR1)) Q:BAR1'["BARPAS"  D
 . S BARCNT=BARCNT+1                           ; Line counter
 . S BARDT=$P(BAR1,"BARPAS",2,99)              ; Date of Run
 . S BARRUN(BARCNT)=BARDT                      ; Array of runs
 . S Y=BARDT
 . D DD^%DT
 . W !,$J(BARCNT,2),?5,Y                       ; Line count,date run
 . I $G(^XTMP(BAR1,0,"SCOPE"))]"" W " (",$G(^XTMP(BAR1,0,"SCOPE")),") "
 . S BARSRTBY=$G(^XTMP("BARPAS"_BARDT,0,"SORTBY"))+1
 . I BARSRTBY W "  sorted by ",$P("Billing location, Account Number;Billing location, Patient name",";",BARSRTBY)
 Q
HELP ;
 W !,"This parameter will allow you to choose how patient statements"
 W !,"are sorted for printing.  Statements will first be sorted by "
 W !,"(1) billing location and then by account number, or by"
 W !,"(2) billing location and then alphabetically by the patient's last name"
 W !,"based on which option is selected."
 W !,"If nothing is selected, the print order will default to option 1."
 Q
ABAL(BARBL) ;P.OTT COLLECT BILLS WITH NONZERO BALANCE
 N BARBAL
 S BARBAL=$$GET1^DIQ(90050.01,BARBL,15)  ;CURRENT BILL AMOUNT
 Q:BARBAL'>0
 I '$D(^BARBL(DUZ(2),"ABAL",BARACDA,BARBL)) Q  ;HEAT#100207
 S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),1,BARACDA,"OB",BARBL)=""
 Q
LISTALL S BARCNT=0,(BARTMP,BARTMP0)="BARPAS" F  S BARTMP=$O(^XTMP(BARTMP)) Q:BARTMP=""  Q:BARTMP'[BARTMP0  D
 . S BARCNT=BARCNT+1
 . W !,BARCNT,".",?10,BARTMP," ",$G(^XTMP(BARTMP,0))
  . F X="DT","SCOPE","SORTBY","REINDEXED" W !?10,X,": ",$G(^XTMP(BARTMP,0,X))
 . Q
 Q
CLNUP ;
 Q  ;--EOR-
