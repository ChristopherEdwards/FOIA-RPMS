BARMPAS ; IHS/SD/LSL - Patient Account Statement ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**2,4,5,19,20**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/22/03 - V1.7 Patch 2
 ; IHS/SD/LSL - 12/04/04 - V17 Patch 4 - IM11692
 ;      Modify code to allow tasked option to catch all facilities.
 ; IHS/SD/LSL - 02/11/04 - V1.7 Patch 5 - IM12222
 ;      Modify MARKACC to allow marking of patient's registered
 ;      at the parents satellite. 
 ;
 ; ********************************************************************
 Q
TASK ; EP
 ; Called from SCHEDULED OPTION BAR MAN ACCOUNT STATEMENT
 ; Start with last run date and go to Today.
 ; Find BAR ACCOUNT STATEMENT in Option Scheduling File
 D INIT^BARUTL
 K DIC,DR,DIE,DA
 S DIC=19.2                                    ; Option Scheduling File
 S X="BAR ACCOUNT STATEMENT"
 S DIC(0)="ZM"
 D ^DIC
 Q:Y<1
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
 K ^XTMP("BARPAS"_BARRUNDT)
 S ^XTMP("BARPAS"_BARRUNDT,0)=X_"^"_DT_"^"_"BAR ACCOUNT STATEMENT"
 S ^XTMP("BARPAS"_BARRUNDT,0,"DT")=BARDTB_"^"_BARDTE
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARAC(DUZ(2))) Q:'+DUZ(2)  D
 . S BARACDA=0
 . F  S BARACDA=$O(^BARAC(DUZ(2),"PAS","Y",BARACDA)) Q:'BARACDA  D ACCOUNT
 S DUZ(2)=BARHOLD
 D MAIL^XBMAIL("BARZ MANAGER","MAIL^BARMPAS")
 Q
 ; ********************************************************************
 ;
ACCOUNT ;
 ; Find Bills where the AR Account is marked for
 ; Patient Account Statement
 ;D INIT^BARUTL  ; this keeps it from printing to a slave printer
 S (BARBL,BARTOT,BARVISL,BARDOSV)=0
 F  S BARBL=$O(^BARBL(DUZ(2),"ABAL",BARACDA,BARBL)) Q:'+BARBL  D
 . ; IHS/SD/PKD 1.8*19 9/10/10
 . ; Add sorts:  VisitLocation and DOS
 . S BARBAL=$$GET1^DIQ(90050.01,BARBL,15)  ;CURRENT BILL AMOUNT
 . Q:BARBAL'>0
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS - VA format
 . S BARTOT=BARTOT+BARBAL
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,"OB",BARBL)=""
 . ; IHS/SD/PKD 9/13/10 add in case needed later - location & dos
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,BARVISL,BARDOSV,"OB",BARBL)=""
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,BARVISL,BARDOSV,BARBL,"A")=""
 S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,"OB")=BARTOT
 ;
 ; Line below for when 0 gets into the ix
 ; IHS/SD/PKD 1.8*19 asked Adrian about the line below
 ;   waiting for testing to see if it should stay, go or be changed
 ;   It currently kills all previous entries if the Balance = 0
 I BARTOT=0 K ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA)
 ;
 ; Find bills by patient balance
 S BARPAT=$$GET1^DIQ(90050.02,BARACDA,1.001)
 S BARBL=0
 F  S BARBL=$O(^BARBL(DUZ(2),"APBAL",BARPAT,BARBL)) Q:'+BARBL  D
 . ; IHS/SD/PKD 1.8*19 9/10/10
 . ; Add sorts:  VisitLocation and DOS
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,BARVISL,BARDOSV,BARBL,"P")=""
 ;
 ; Find bills by patient
 F  S BARBL=$O(^BARBL(DUZ(2),"C",BARPAT,BARBL)) Q:'+BARBL  D
 . S BARBAL=$$GET1^DIQ(90050.01,BARBL,15)
 . Q:BARBAL'>0
 . ; IHS/SD/PKD 1.8*19 9/10/10
 . ; Add sorts:  VisitLocation and DOS
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,BARVISL,BARDOSV,BARBL,"P")=""
 ;
 S BARTR=BARDTB
 F  S BARTR=$O(^BARTR(DUZ(2),"AE",BARACDA,BARTR)) Q:BARTR\1>BARDTE  Q:'+BARTR  D
 . S BARBL=$$GET1^DIQ(90050.03,BARTR,4,"I")
 . Q:'+BARBL                                   ; No bill on transaction
 . ; IHS/SD/PKD 1.8*19 9/10/10
 . ; Add sorts:  VisitLocation and DOS
 . S BARVISL=$$GET1^DIQ(90050.01,BARBL,108)  ; VisitLoc
 . I BARVISL="" S BARVISL=BARPSAT(DUZ(2),.01)  ; if not listed, default to DUZ(2)
 . S BARDOSV=$P(^BARBL(DUZ(2),BARBL,1),U,2)  ; DOS
 . S ^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,BARVISL,BARDOSV,BARBL,"T")=""
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
 D ASKACCT                                     ; Ask AR Account
 Q:'$D(BARACDA)                                ; No acct selected
 D DATE                                        ; Ask date range
 I +BARDTB<1 Q                                 ; Dates answered wrong
 D GETHDR^BARMPAS3
 Q:'$D(BARHDRDA)
 S BARQ("RC")="LOOP^BARMPAS"         ; Build tmp global with data
 ; IHS/SD/PKD Moved code to BARMPAS3 for size
 ;S BARQ("RP")="PRINT^BARMPAS2"       ; Print reports from tmp global
 S BARQ("RP")="PRINT^BARMPAS3"
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 ;IHS/SD/AR PATCH 19 06/01/2010
 D GETMSG
 D ^BARDBQUE                         ; Double queuing
 K ^XTMP("BARPAS"_BARRUNDT)  ; cleanup scratch global
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; ********************************************************************
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
DATE ;
 ; Select date range
 S BARDTB=$$DATE^BARDUTL(1)
 I BARDTB<1 Q
 S BARDTE=$$DATE^BARDUTL(2)
 I BARDTE<1 W ! G DATE
 I BARDTE<BARDTB D  G DATE
 . W *7
 . W !!,"The END date must not be before the START date.",!
 D NOW^%DTC
 S BARRUNDT=%
 S X1=DT
 S X2=+15
 D C^%DTC
 K ^XTMP("BARPAS"_BARRUNDT)
 S ^XTMP("BARPAS"_BARRUNDT,0)=Y_"^"_DT_"^"_"BAR ACCOUNT STATEMENT"
 S ^XTMP("BARPAS"_BARRUNDT,0,"DT")=BARDTB_"^"_BARDTE
 Q
 ; ********************************************************************
 ;
LOOP ; EP
 ; Part of manual process
 ; IHS/SD/PKD 1.8*20 2/24/11 Set XTMP date headers
 ; If Device definition calls for Start Time, this will capture
 ; Run Dates rather than having them blank
 I $G(BARDTB)=""!($G(BARDTE)="") Q  ;Need dates
 S ^XTMP("BARPAS"_BARRUNDT,0,"DT")=BARDTB_U_BARDTE
 S ^XTMP("BARPAS"_BARRUNDT,0)=BARDTB_"^"_BARDTE_"^"_"BAR ACCOUNT STATEMENT"
 D ACCOUNT
 S BARKILL=0
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
