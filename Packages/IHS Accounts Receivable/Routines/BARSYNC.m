BARSYNC ; IHS/SD/LSL - File Synchronization ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 05/21/02 - V1.6 Patch 2
 ;     Called by A/R V1.6 Patch 2 post init (BARPOST2)
 ;     Routine created
 ;
 ; IHS/SD/LSL - 01/13/03 - V1.7
 ;     Called by A/R V1.7 post init routine (BARPT17) since V1.7
 ;     includes a modification that should resolve the issue of the
 ;     Transaction History being out of sync with the balance on the
 ;     bill.  Routine modified to restructure global by date AUTO SYNC
 ;     was run in order to contain historical data.
 ;
 ; *********************************************************************
 ;
 ;     This routine will compare the Current Bill Amount of the A/R Bill
 ;     File to the A/R Transaction history balance.  If they are not
 ;     equal, it will create a transaction (AUTO SYNC) that will make
 ;     them equal.  This transaction will not be reflected on the
 ;     A/R Current Bill amount.  Nor will it be reflected on the current
 ;     Period Summary Report.  The bills that were touched will be
 ;     stored in 
 ;
 ;     ^BARSYNC(BARSTART,DUZ(2),BARVISOU,BARAC,BARDOS,BARBILL)=BARBAMT^BARTAMT
 ;     
 ;     Where:   BARSTART = Date AUTO SYNC was run
 ;              DUZ(2)   = Billing location
 ;              BARVIS   = Visit type on A/R Bill
 ;              BARAC    = A/R Account on A/R Bill
 ;              BARDOS   = DOS Begin on A/R Bill
 ;              BARBILL  = A/R Bill
 ;              BARBAMT  = Current Bill Amount from A/R Bill File
 ;              BARTAMT  = Transaction History Balance
 ;
 ;     This global will be used when printing the Auto Sync Report
 ;     from the Manager Reports Menu.
 ;
 ; *********************************************************************
 Q
 ; *********************************************************************
ENPOST ; EP - Entry point for Post init process to allow tasking.
 D START
 Q
 ; *********************************************************************
 ;
EN ; EP - Entry point for processing other than post init.
 S BARAGAIN=1                              ; Default, run auto sync
 I $D(^BARSYNC) D ASKAGAIN                 ; Already run, ask again?
 Q:'+BARAGAIN                              ; No, don't run again.
 W !,"Auto Sync in Progress...",!
 D START
 W !,"Auto Sync Complete.",!!
 Q
 ; *********************************************************************
 ;
ASKAGAIN ;
 S BARLASTB=$O(^BARSYNC(9999999),-1)
 S BARLASTE=$G(^BARSYNC(BARLASTB,"STOP"))
 S Y=BARLASTB
 D DD^%DT
 S BARLASTB=Y
 I +$G(BARLASTE) D
 . S Y=BARLASTE
 . D DD^%DT
 . S BARLASTE=Y
 W !!,$$CJ^XLFSTR("Auto Sync was last run on "_BARLASTB,IOM)
 I $G(BARLASTE)="" W !,$$CJ^XLFSTR(" and did NOT complete.",IOM),!
 E  W !,$$CJ^XLFSTR(" and completed on "_BARLASTE_".",IOM),!
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Do you wish to execute Auto Sync again"
 S DIR("B")="N"
 D ^DIR
 I Y'=1 S BARAGAIN=0 Q
 S BARAGAIN=1
 Q
 ; *********************************************************************
 ;
START ;
 I $O(^BARSYNC(""))'["." D MERGE
 D NOW^%DTC
 S BARSTART=%
 S ^BARSYNC(BARSTART,"START")=BARSTART
 S BARJOURN=$$NOJOURN^ZIBGCHAR("BARSYNC")
 S BARDUZ=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'+DUZ(2)  D
 . S BARBILL=0
 . F  S BARBILL=$O(^BARBL(DUZ(2),BARBILL)) Q:'+BARBILL  D
 . . Q:'$D(^BARBL(DUZ(2),BARBILL,0))        ; No data on bill
 . . D BILLDATA
 . . D TRDATA
 . . Q:+BARBAMT=BARTAMT                     ; Files are in sync
 . . S BARDIF=BARBAMT-BARTAMT
 . . D TRANS
 . . Q:BARTRIEN<1                           ; Trans not created
 . . D SETSYNC
 S DUZ(2)=BARDUZ
 D NOW^%DTC
 S ^BARSYNC(BARSTART,"STOP")=%
 Q
 ; *********************************************************************
 ;
MERGE ;
 ; Convert GLOBAL to accomodate multiple executions of Auto Sync
 N BARDATE
 S BARDATE=+$G(^BARSYNC("START"))
 Q:'+BARDATE
 M ^BARTMP($J,BARDATE)=^BARSYNC
 S BARX=""
 F  S BARX=$O(^BARSYNC(BARX)) Q:BARX=""  D
 . K ^BARSYNC(BARX)
 M ^BARSYNC=^BARTMP($J)
 K ^BARTMP($J)
 Q
 ; *********************************************************************
 ;
BILLDATA ;
 ; Gather data from A/R Bill file.
 F I=0:1:1 S BARBL(I)=$G(^BARBL(DUZ(2),BARBILL,I))
 S BARBAMT=$P(BARBL(0),U,15)              ; Current bill amount
 S BARAC=$$GET1^DIQ(90050.01,BARBILL,3)   ; A/R Account (external)
 S:BARAC="" BARAC="NO A/R ACCOUNT"
 S BARDOS=$P(BARBL(1),U,2)                ; DOS Begin
 I BARDOS="" S BARDOS=99
 S BARVIS=$P(BARBL(1),U,8)                ; Visit location
 I +BARVIS S BARVISOU=$$GET1^DIQ(4,BARVIS,.01)
 E  S BARVISOU="NO VISIT LOCATION"
 Q
 ; *********************************************************************
TRDATA ;
 ; Gather data for A/R Bill from A/R Transaction File via "AC" x-ref
 ; Find PSR transactions and do math to find balance
 S (BARTR,BARTAMT)=0
 F  S BARTR=$O(^BARTR(DUZ(2),"AC",BARBILL,BARTR)) Q:'+BARTR  D
 . Q:'$D(^BARTR(DUZ(2),BARTR,0))          ; No transaction data
 . F I=0:1:1 S BARTR(I)=$G(^BARTR(DUZ(2),BARTR,I))
 . S BARTRTYP=$P(BARTR(1),U)              ; Trans type (pointer)
 . S BARADCAT=$P(BARTR(1),U,2)            ; Adjust cat (pointer)
 . S BARCDT=$P(BARTR(0),U,2)
 . S BARDBT=$P(BARTR(0),U,3)
 . I ",3,4,13,14,15,16,19,20,"'[(","_BARADCAT_",")&(",40,49,39,108,503,504,"'[(","_BARTRTYP_",")) Q
 . S BARTAMT=BARTAMT+BARDBT-BARCDT
 Q
 ; *********************************************************************
 ;
TRANS ;
 ; Create Auto Sync Transaction
 ;
 S BARTRIEN=$$NEW^BARTR
 Q:BARTRIEN<1
 ;
 I BARDIF>0 S DR="3////^S X=$FN(BARDIF,""-"")"   ; Debit
 E  S DR="2////^S X=$FN(BARDIF,""-"")"           ; Credit
 S DR=DR_";4////^S X=BARBILL"                    ; A/R bill
 S DR=DR_";5////^S X=$P(BARBL(1),U)"             ; Patient
 S DR=DR_";6////^S X=$P(BARBL(0),U,3)"           ; A/R acct
 S DR=DR_";8////^S X=$P(BARBL(0),U,8)"           ; Parent location
 S DR=DR_";9////^S X=DUZ(2)"                     ; Parent ASUFAC
 S DR=DR_";10////8"                              ; Service/section
 S DR=DR_";11////^S X=BARVIS"                    ; visit location
 S DR=DR_";12////^S X=DT"                        ; Date
 S DR=DR_";13////^S X=DUZ"                       ; Entry By
 S DR=DR_";101////504"                           ; Transaction type
 ;
 S DA=BARTRIEN
 S DIE=90050.03
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE,DA,DR
 Q
 ; *********************************************************************
SETSYNC ; 
 ; Set data into ^BARSYNC
 S ^BARSYNC(BARSTART,DUZ(2),BARVISOU,BARAC,BARDOS,BARBILL)=BARBAMT_U_BARTAMT
 Q
