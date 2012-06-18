BARFPST4 ; IHS/SD/LSL - A/R FLAT RATE POSTING #3 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
DOC ;
 ; LSL - 01/01/2000 - Created routine
 ;       Contains code for Reviewing bills in A/R FLAT RATE POSTING File
 ;       May be called from FBL View Flat Rate Bills Option or
 ;       by choosing REVIEW from Select Command Prompt in the 
 ;       FRP Flat Rate Posting Option.
 ;;
 Q
 ; *********************************************************************
 ;
EN ; EP
 ; EP - View flate rate posting entries
 D FRPENTRY                    ; Get Flat Rate Posting Entry to view
 I Y<1 D EXIT^BARFPST Q        ; Quit if don't select FRP Batch
 D REVIEW                      ; View entry using XBLM
 Q
 ; *********************************************************************
 ;
FRPENTRY ;
 ;Look up Flate Rate Posting entry
 W !
 K DIC
 S DIC="^BARFRP(DUZ(2),"
 S DIC(0)="AEMQZ"
 S DIC("A")="Select FRP batch: "
 D ^DIC
 I Y<1 Q
 S BARIEN=+Y                   ; IEN to A/R FLAT RATE POSTING File
 S BARNAME=Y(0,0)              ; Name of FRP batch
 Q
 ; *********************************************************************
 ;
REVIEW ; EP 
 ; EP - Review entries
 D VIEWR^XBLM("REVIEW2^BARFPST4","A/R Flat Rate Posting Summary")
 S BARFLAG=1
 Q
 ; *********************************************************************
 ;
REVIEW2 ;
 ; Print Report code used in XBLM call
 ; Get batch, item, payment, item amount from FRP file
 K DA,DIC,DR,DIQ,BARREV
 S DIC=90054.01
 S DA=BARIEN                   ; IEN to A/R FLAT RATE POSTING File
 S DR=".04;.05;.09;.1"
 S DIQ="BARREV("
 S DIQ(0)="2I"
 D ENP^XBDIQ1(DIC,DA,DR,DIQ,DIQ(0))
 ; Count all bills (all visit locations)
 S (BARA,BARC)=0
 F  S BARA=$O(^BARFRP(DUZ(2),BARIEN,2,BARA)) Q:'+BARA  D
 . S BARB=0
 . F  S BARB=$O(^BARFRP(DUZ(2),BARIEN,2,BARA,3,BARB)) Q:'+BARB  D
 . . S BARC=BARC+1             ; Bill counter
 S BARIN1=BARREV(BARIEN,.04,"I") ; IEN to A/R COLLECTION BATCH File   
 S BARIN2=BARREV(BARIEN,.05,"I") ; IEN to ITEM mult of A/R COLL BATCH
 S BARBEG=$$VAL^XBDIQ1(90051.1101,"BARIN1,BARIN2",19) ; Beginning balan
 S BAREND=BARBEG-(BARC*BARREV(BARIEN,.09))            ; Ending balance
 ; Write header
 W !?7,"Batch Name: ",BARREV(BARIEN,.04)
 W ?50,"Starting Balance: ",$J(BARBEG,9,2)
 K DA,DIC,DR,DIQ
 S DA(1)=BARIN1,DA=BARIN2
 W !?6,"Item Number: ",$$VAL^XBDIQ1(90051.1101,"BARIN1,BARIN2",.01)
 W ?52,"Ending Balance: ",$J(BAREND,9,2)
 W !?5,"Check Number: ",$$VAL^XBDIQ1(90051.1101,"BARIN1,BARIN2",11)
 W ?48,"# of Bills to Post: ",$J(BARC,9)
 W !?12,"Payor: ",$$VAL^XBDIQ1(90051.1101,"BARIN1,BARIN2",201)
 W !?3,"Payment Amount: ",$J(BARREV(BARIEN,.09),9,2)
 ; Write Adjustment data in header portion
 S BARA=0
 F  S BARA=$O(^BARFRP(DUZ(2),BARIEN,1,BARA)) Q:'+BARA  D ADJHDR
 W !!,"Bill #",?21,"Patient Name",?41,"Billed Amt",?56,"DOS",?67,"Payor Billed"
 W !
 ; Loop facilities to get data lines and print data
 S BARA=0
 F  S BARA=$O(^BARFRP(DUZ(2),BARIEN,2,BARA)) Q:'+BARA  D FACLINE
 Q
 ; *********************************************************************
 ;
ADJHDR ;
 ; Get and print data for Adjustments in header portion of view
 K DIC,DA,DIQ,DR,BARREV2
 S DIC=90054.0101
 S DA(1)=BARIEN               ; IEN to A/R FLAT RATE POSTING File
 S DA=BARA                    ; IEN to ADJUSTMENTS mult in FRP File
 S DR=".01;.02;.03"           ; Category, Type, Amount
 S DIQ="BARREV2("
 S DIQ(0)="2I"
 D ENP^XBDIQ1(DIC,"BARIEN,BARA",DR,DIQ,DIQ(0))
 W !,"Adjustment Amount: ",$J(BARREV2(BARIEN,BARA,.03),9,2)
 W ?35,"Category: ",BARREV2(BARIEN,BARA,.01)
 W ?60,"Type: ",BARREV2(BARIEN,BARA,.02)
 Q
 ; *********************************************************************
 ;
FACLINE ;
 ; Get facility, if bills under facility, write facility 
 K DIC,DA,DIQ,DR
 S DA(1)=BARIEN               ; IEN to A/R FLAT RATE POSTING File
 S DA=BARA                    ; IEN to VISIT LOCATION mult in FRP file
 S BARRF=$$VAL^XBDIQ1(90054.0102,"BARIEN,BARA",.01) ; Facility name
 I $D(^BARFRP(DUZ(2),BARIEN,2,BARA,3,"B")) W !?10,BARRF,!
 S BARB=0
 ; Loop bills and print data line
 F  S BARB=$O(^BARFRP(DUZ(2),BARIEN,2,BARA,3,BARB)) Q:'+BARB  D BILLINE
 Q
 ; *********************************************************************
 ;
BILLINE ;
 ; Get bill data and print data line
 K DIC,DA,DIQ,DR,BARREV3
 S DA(2)=BARIEN        ; IEN to A/R FLAT RATE POSTING File
 S DA(1)=BARA          ; IEN to VISIT LOCATION mut if FRP File 
 S DA=BARB             ; IEN to A/R BILLS mult of VISIT mult of FRP File
 S BARVBL=$$VALI^XBDIQ1(90054.0103,"BARIEN,BARA,BARB",.01)
 K DIC,DA,DR,DIQ
 S DIC=90050.01
 S DA=BARVBL           ; IEN to A/R BILL File 
 ; DR = Bill Number, Patient, Amount Billed, DOS Begin, A/R Account
 S DR=".01;101;13;102;3"
 S DIQ="BARREV3("
 S DIQ(0)="2I"
 D ENP^XBDIQ1(DIC,DA,DR,DIQ,DIQ(0))
 W !,BARREV3(BARVBL,.01)                       ; Bill Number
 W ?21,BARREV3(BARVBL,101)                     ; Patient
 W ?43,$J(BARREV3(BARVBL,13),8,2)              ; Amount Billed 
 W ?53,$$SDT^BARDUTL(BARREV3(BARVBL,102,"I"))  ; DOS Begin
 W ?66,BARREV3(BARVBL,3)                       ; A/R Account
 Q
