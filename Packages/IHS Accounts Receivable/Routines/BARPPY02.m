BARPPY02 ; IHS/SD/TMM - PREPAYMENT RECEIPTS MAY 11,2010 ; 05/11/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/TMM 06/18/10 1.8*19 Add Prepayment functionality.
 ; *********************************************************************
 Q
 ;
RECEIPT(BARRIEN) ;  Print Receipt Y/N?
R1 ; Print Receipt.  Prompt for number of copies and device.
 D RESETDIR^BARPPY01
 S DIR("A")="Print Receipt?  YES/NO   "
 ;S DIR("B")="YES"
 S DIR(0)="YA"
 D ^DIR
 I Y=0 Q
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 ;
 Q:BARSTOP
 W !!
 D PRINT(BARPPIEN)
 D PRTDATE       ;update the print date
 D CLEAN
 Q
 ;
RCPT(BARPPIEN) ;  Receipt data to print
 K BARHDR
 K BARLINE
 ;
 ;Receipt Header
 I '$D(BARPSAT(DUZ(2),.01)) D BARPSAT^BARUTL0
 D BARPPAY^BARCLU1(BARPPIEN)    ;builds BARPPAY array
 S BARFAC=$G(BARPSAT(DUZ(2),.01))            ;Facility Name (BARFAC)
 S BARHDR2="RECEIPT OF PAYMENT"
 S BARHDR3=$G(BARPPAY(.11))                ;Department
 D NOW^%DTC
 S BARCPTDT=$P(%,".")                ;Receipt print date (current date)
 S BARCPTDT=$$MDY(BARCPTDT)
 ;
 ;Receipt Detail
 S BARPAT=$G(BARPPAY(.08))               ;Patient Name
 S BARPATI=$G(BARPPAY(.08,"I"))          ;Patient IEN
 ;
 S BARIENS=DUZ(2)_","_BARPATI_","
 S BARHRN=$$GET1^DIQ(9000001.41,BARIENS,.02)   ; Patient Chart number (HRN)
 ;
 S BARCPT=$G(BARPPAY(.01))               ;Receipt #
 S BARPMTDI=$G(BARPPAY(.02,"I"))         ;Premayment date (FM format)
 S BARPMTDT=$$MDY(BARPMTDI)
 ;
 S BARPMTY1=$G(BARPPAY(.03))             ;Payment Type   ;PAYMENT TYPE line 1
 S BARPMTYP=$G(BARPPAY(.03,"I"))         ;Payment Type (internal)
 S BARCK=$G(BARPPAY(.04))                ;Check #
 S BARCARD=$G(BARPPAY(.06))              ;Credit Card Type
 S BARPPAMT=$G(BARPPAY(.07))               ;Credit - Amount paid
 ;
 S BARPMTDI=$G(BARPPAY(.13,"I"))         ;Payment for DOS, DOS the payment is intended for
 S BARPPDOS=$$MDY(BARPMTDI)
 ;
 S BARPMTY2=$S(BARPMTYP="CK":BARCK,1:BARCARD)      ;Payment TYPE line 2 (check # or Card Type)
 S BARTMP=""
 S I="" F  S I=$O(BARPPAY(101,I)) Q:I=""  D
 . S BARTMP=$G(BARTMP)_$G(BARPPAY(101,I))
 K BARCMT M BARCMT=BARPPAY(.2)
 Q
 ;
PRTRECPT ; Receipt output
 F I=1:1:19 W !                              ;start receipt on line 20
 W !,?(80-$L(BARFAC)/2),BARFAC               ;receipt line 1
 W !,?(80-$L(BARHDR2)/2),BARHDR2             ;receipt line 2
 W !,?(80-$L(BARHDR3)/2),BARHDR3             ;receipt line 3
 S BARTMP="RECEIPT DATE:  "_BARCPTDT
 W !,?(80-$L(BARTMP)/2),BARTMP               ;receipt line 4
 I $G(BARREPRT)=1 W "  *REPRINT*"
 W !                                         ;receipt line 5
 W !,"PATIENT:  ",BARPAT,?39,"HRN:  ",BARHRN   ;receipt line 6
 W !                                         ;receipt line 7
 W !,"RECEIPT NO:  ",BARCPT,?39,"PAYMENT RECEIVE DATE:  "_BARPMTDT     ;receipt line 8
 W !,"PAYMENT TYPE:  ",BARPMTY1               ;receipt line 9
 S BARTMP=$S(BARPMTYP="CK":"CHECK NUMBER :  ",BARPMTYP="CA":"",1:"CARD TYPE:  ")
 W !,BARTMP_BARPMTY2,?39,"AMOUNT: $  ",$FN(BARPPAMT,",",2)  ;receipt line 10
 W !,"PAYMENT FOR DOS:  ",BARPPDOS            ;receipt line 11
 W !                                         ;receipt line 12
 N CT F CT=1:1:4 I $D(BARCMT(CT)) W !,BARCMT(CT)  ;receipt line 13
 W !                                         ;receipt line 14
 Q
 ;
REPRINT ;  Re-print receipt
 ;-------------------------------------------
 ;Ask for receipt #
 I '$D(BARUSR) D INIT^BARUTL
 K DIC
 S DIC("B")="Enter Receipt Number, Patient, DOS, Receipt Date:  "
 S DIC="^BARPPAY(DUZ(2),"
 S DIC(0)="AEZQM"
 D ^DIC
 Q:Y'>0
 S BARPPIEN=+Y
 ;-------------------------------------------
 ;Redisplay the receipt data
 K BARPPAY
 D BARPPAY^BARCLU1(BARPPIEN) ;setup Prepayment array (BARPPAY)
 S BARSTOP=0
 D RECAPDAT           ;get RECAP data
 D RECAPDSP           ;display RECAP data
 ;-------------------------------------------
 ;Print the recap
 D CLEAN1             ;clear all but BARPPIEN and BARPPAY array
 S BARREPRT=1         ;reprint flag
 D RECEIPT(BARPPIEN)  ;print the receipt
 K BARREPRT
 Q
 ;
RECAPDAT ; Get recap receipt data (reprints)
 D CLEAN1
 S BARECPT=BARPPAY(.01)                  ;Receipt #
 S BARPMTDI=BARPPAY(.13)                 ;Payment for DOS, DOS the payment is intended for
 S BARPPAMT=BARPPAY(.07)                 ;Credit - Amount paid
 S BARHDR3=$G(BARPPAY(.11))              ;Department 
 S BARPMTYP=BARPPAY(.03,"I")             ;Payment Type (internal code)
 S BARCK=BARPPAY(.04)                    ;check number
 S BARCTYPN=BARPPAY(.06)                 ;Credit Card Type
 S BARCNAME=BARPPAY(.05)                 ;account owner name (re: credit card or checking acct)
 S BARBL=BARPPAY(.09)                    ;A/R Bill
 S BARBLIEN=BARPPAY(.09,"I")             ;A/R Bill IEN
 S BARBL=BARPPAY(.09)                    ;A/R Bill (ext)
 S BARPAT=$$GET1^DIQ(90050.01,BARBLIEN_",",101)  ;Patient Name from A/R Bill
 S BARDOSB=BARPPAY(.12)                  ;A/R BILL Begin DOS
 S BARPTNM1=BARPPAY(.08)                 ;patient name (from select patient prompt, not from A/R Bill)
 K BARCMT M BARCMT=BARPPAY(.2)  ; Get full comment
 ;S BARCMT=$G(BARPPAY(.2,1))                 ;prepayment comments
 Q
 ;
RECAPDSP ;  Display re-print data for user to review before select print
 Q:BARSTOP
 W $$EN^BARVDF("IOF"),!        ;Form Feed/Clear screen
 W $$EN^BARVDF("CLR")          ;Clear screen
 W !,"Receipt Number:  ",BARECPT,!!
 W !,"1)",?4,"PAYMENT FOR DOS:",?22,BARPMTDI
 W !!,"2)",?4,"CREDIT:",?22,"$ ",$FN(BARPPAMT,",",2)
 W !!,"3)",?4,"DEPARTMENT:",?22,BARHDR3
 I BARPMTYP="CA" S BARTMP="CASH^^"
 I BARPMTYP="CK" S BARTMP="CHECK^CHECK NUMBER:^NAME ON CK ACCOUNT:"
 I BARPMTYP="CC" S BARTMP="CREDIT CARD^CARD TYPE:^NAME ON CARD:"
 I BARPMTYP="DB" S BARTMP="DEBIT CARD^CARD TYPE:^NAME ON CARD:"
 W !!,"4)",?4,"PAYMENT TYPE:",?22,$P(BARTMP,U)  ;PAYMENT TYPE line 1
 S BARTMP1=$S(BARPMTYP="CK":BARCK,BARPMTYP="CC":BARCTYPN,BARPMTYP="DB":BARCTYPN,1:"")
 I $P(BARTMP,U)'="CASH" D
 . W !,?4,$P(BARTMP,U,2),?22,BARTMP1  ;PAYMENT TYPE line 2
 . S BARTMP1=$S("^CK^CC^DB^"[BARPMTYP:BARCNAME,1:"")
 . W !,?4,$P(BARTMP,U,3),?22,BARCNAME  ;PAYMENT TYPE line 3
 W !!,"5)",?4,"A/R BILL NUMBER:",?22,BARPPAY(.09)
 W !,?4,"PATIENT NAME:",?22,BARPAT
 W !,?4,"BILL DOS:",?22,BARDOSB
 W !!,"6)",?4,"PATIENT:",?22,BARPTNM1
 ; display / print full comment
 W !!,"7)",?4,"COMMENTS:"
 N CT F CT=1:1:4 I $D(BARCMT(CT)) D
 . S BARCMT(5)=BARCMT(CT)
 . I CT=1 W "  "  ; 2 SPACES AFTER COLON
 . ; And then let it wrap around
 . E  I $E(BARCMT(5),$L(BARCMT(5)))'=" "&($E(BARCMT(CT))'=" ") W " "
 . W BARCMT(CT)  ;receipt line 13
 W !                                         ;receipt line 14
 Q
 ;
PRINT(BARPPIEN) ; Test print logic
 ; Print report to device.  Queuing allowed.
 ; prompt user for number of copies to print
 S BARCOPY=0
 S BARCOPY=$$ASKCOPY^BARDBQ01()
 I $D(DUOUT)!$D(DUOUT)=1 Q
 I $D(DIROUT) S BARSTOP=1 Q
 I BARCOPY>0 S BAR("MULTI")=BARCOPY
 S XBNS="BAR"
 S XBRC="RCPT^BARPPY02(BARPPIEN)"   ; Build tmp global with data
 S XBRP="PRTRECPT^BARPPY02"         ; Print reports from tmp global
 ;S XBRX="CLEAN0^BARPPY02"          ; Clean-up routine
 S XBRX=""                          ; Clean-up routine
 S BAR("NOQUE")=1                   ;don't allow queing receipts
 D ^BARDBQ02
 Q
 ;
CLEAN ; Clean up after print/re-print receipt
 ;If update this list, consider updating CLEAN1 tag as well
 K BARFMDT,BARFMMM,BARFMDD,BARFMYY
 K BARPPAMT,BARCNTPP,BARECPT,BARNOPP,BARPAYDT,BARPAYTY,BARPMTDD,BARPMTDI,BARPMTDT
 K BARPMTMM,BARPMTYP,BARPMTYY,BARPP,BARPPAY,BARPPCMT,BARPPDTM,BARPPIEN,BARPTNM
 K BARQ,BARREPRT,BARSELPP
 Q
 ;
CLEAN1 ; Clear variables before print receipt
 ;clear all but BARPPIEN, BARPPAY, and BARREPRT
 K BARFMDT,BARFMMM,BARFMDD,BARFMYY
 K BARPPAMT,BARCNTPP,BARECPT,BARNOPP,BARPAYDT,BARPAYTY,BARPMTDD,BARPMTDI,BARPMTDT
 K BARPMTMM,BARPMTYP,BARPMTYY,BARPP,BARPPCMT,BARPPDTM,BARPTNM
 K BARQ,BARSELPP
 Q
 ;
CLEAN0 ; Fake cleanup for multi copy printing.  Routine needed for ^BARDBQ01.
 ;Routine calling BARDBQ1 must do cleanup.
 Q
 ;
PRTDATE ;Update Receipt Print date in A/R Prepayment file
 ;Update Receipt Print Date
 K DIE,DR,DA
 ; IHS/SD/PKD First Printed Date - Not Last Reprint Date
 S BARPRTDT=$P($G(^BARPPAY(DUZ(2),BARPPIEN,0)),U,19)
 I BARPRTDT="" D
 . D NOW^%DTC
 . S BARPRTDT=$P(%,".")
 S DR=".19////^S X=BARPRTDT"      ;RECEIPT PRINT DATE
 ; Update Pre-Payment file
 S DA=BARPPIEN
 S DIE=$$DIC^XBDIQ1(90050.06)
 D ^DIE
 ;
PRTDT ;
 ;Update Receipt Print Date (multiple)
 K DIC,DR,DA,DD,DO
 S DA(1)=BARPPIEN
 S DIC=$$DIC^XBDIQ1(90050.06201)
 S DIC(0)="L"
 S DIC("P")=$P(^DD(90050.06,201,0),U,2)
 D NOW^%DTC
 S PRTDAT=%
 ;S X=$P(%,".")
 S X=%_U_DUZ  ; Date.Time ^ Cashier
 D FILE^DICN
 Q
 ;
MDY(BARFMDT) ;  format Date from FM to MM/DD/YYYY
 S BARFMMM=$E(BARFMDT,4,5)
 S BARFMDD=$E(BARFMDT,6,7)
 S BARFMYY=$E(BARFMDT,1,3)+1700
 S BARFMDT=BARFMMM_"/"_BARFMDD_"/"_BARFMYY ;DOS for Prepayment
 Q BARFMDT
 ;
