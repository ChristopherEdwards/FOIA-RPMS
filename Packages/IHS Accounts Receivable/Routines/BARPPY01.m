BARPPY01 ; IHS/SD/TMM - PREPAYMENT ENTRY MAY 11,2010 ; 05/11/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/TMM 06/18/10 1.8*19  Add Prepayment functionality.
 ;      See work order 3PMS10001
 ;      ------------------------
 ;      1. Display prepayments not assigned to a batch (^BARCLU)
 ;      2. Remove prompt: AUTO PRINT RECEIPT (^BARCLU01)
 ;      3. Prepayment entry ^BARPPY01 (new routine),^BARCLU1,^BARPUTL
 ;      4. Display prepayments matching payment type selected (^BARCLU)
 ;      5. Allow user to assign prepayment to batch (^BARCLU,^BARCLU01,^BARPUTL,^BARPST1,^BARBLLK)
 ;      6. Print Prepayment Receipt (^BARPPY02) (new routine)
 ;      7. Allow user to look up registered patient with no bills in system
 ; *********************************************************************
 ;
 ;  BARDONE - All data has been collected, ready to review and file/modify
 ;  BARSTOP - Exit processing
 ;
 Q
 ;
EN ;EP - Prepayment Collections
 S BARESIG=""
 D SIG^XUSESIG              ;electronic signature test
 Q:X1=""  ;elec signature test
 S BARESIG=1
 F I=1:1 D EN1 Q:($D(DUOUT)!$D(DTOUT)!$D(DIROUT))!$G(BARSTOP)
XIT ;
 D CLEAN
 Q
 ;
EN1 ;  Loop
 D GETDATA
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DUOUT)!$D(DTOUT) Q
 I 'BARDONE G EN1
 D RECAP^BARPPY1A
 I $G(BARQUIT)=1 Q    ;user opted to quit, not file receipt ;
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) Q
 I BARFILE="Q" G EN1
 D FILE^BARPPY1A
 D RECEIPT^BARPPY02(BARPPIEN)          ;prompt to print receipt
 Q
 ;
GETDATA ;  Get Pre-payment data
 ; Select Department (Clinic Stop)
 Q:$G(BARSTOP)
 D INIT
 D SELDEPT
 Q:BARSTOP
 I $D(DTOUT)!$D(DUOUT) Q
 I $G(BARDEPTI)="" S BARSTOP=1 Q
SELPMT ;  Select Payment Type
 D SELPMT1
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) G GETDATA
 I $G(BARUPDT),$D(DUOUT) Q
 I $D(DTOUT) Q
 ; Get additional payment data for selected payment type
 S BARDAT=0             ;identifies if required data for this payment type was collected 0/1
 S BARTAG=$P(Y(0)," ",1)
PMTDATA ;  
 Q:BARSTOP
 I '$G(BARAMTUP) D @BARTAG   ;get additional data for the selected payment type
 I $G(BARAMTUP) D
 . K BARAMTUP
 . S BARTAG1=$S(BARTAG="CHECK":"CHECKNM","^CREDIT^DEBIT^"[BARTAG:"CARDNM",1:"CASH")
 . D @BARTAG1
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) G SELPMT
 I $G(BARUPDT),$D(DUOUT) G SELPMT
 I $D(DTOUT) Q
 I '$G(BARUPDT),'BARDAT G SELPMT
 I $G(BARUPDT) Q            ;edit payment data only for updates
 ;
AMOUNT ;  Enter Credit amount
 K BARAMTUP
 D AMOUNT1
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) S BARAMTUP=1 G PMTDATA
 I $G(BARUPDT),$D(DUOUT) Q
 I $D(DTOUT) Q
ARBILL ;  Get A/R Bill, Patient, A/R Bill DOS
 D ARBILL1
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) G AMOUNT
 I $G(BARUPDT),$D(DUOUT) Q
 I $D(DTOUT) Q
PAYDOS ;  Get DOS for this payment
 D PAYDOS1
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) G ARBILL
 I $G(BARUPDT),$D(DUOUT) Q
 I $D(DTOUT) Q
 ; Select patient if not selected during A/R Bill entry
GETPAT ;
 D GETPAT1
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) G PAYDOS
 I $G(BARUPDT),$D(DUOUT) Q
 I $D(DTOUT) Q
 ; Enter comments
 D CMTS
 Q:BARSTOP
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) G PAYDOS
 I $G(BARUPDT),$D(DUOUT) Q
 I $D(DTOUT) Q
 ; Data entry complete
 S BARDONE=1
 Q
 ;
SELDEPT ;
 K DIC,DR,DA,X,Y
 S DIC="^DIC(40.7,"
 W !
 S DIC(0)="AEZQM"
 S DIC("A")="Enter your Department:  "
 S BARTMP=$G(BARDEPTE)
 I BARTMP'="" S DIR("B")=BARTMP
 K DD,DO
 D ^DIC
 I X="^^" S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 ;I 'Y G SELDEPT
 I Y'>0 S (BARDEPTI,BARDEPTE)="" Q
 S BARDEPTI=$P(Y,U)    ;CLINIC STOP IEN
 S BARDEPTE=$P(Y,U,2)   ;CLINIC STOP NAME
 K DIC
 Q
 ; *********************************************************************
SELPMT1 ;  Select Payment Type
 Q:BARSTOP
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 S DIR(0)="SA^CA:CASH;CK:CHECK;CC:CREDIT CARD;DB:DEBIT CARD"
 S DIR("A")="PAYMENT TYPE:  "
 S BARTMP=$$PAYTYPE^BARPPY1A($G(BARPMTYP))
 I BARTMP'="" S DIR("B")=BARTMP
 K DA
 D ^DIR
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 S BARPMTYP=Y
 Q
 ;
CASH ;  Collect additional data related to CASH payment
 ; Account name/account number not needed for cash payments
 Q:BARSTOP
 S BARDAT=1
 ; Reset 'payment type' fields in case payment type was modified from other to 'cash'
 I BARPMTYP="CA" S (BARCK,BARCNAME,BARCTYPE,BARCTYPN)=""
 Q
 ;
CHECK ;  data related to CHECK payment
 Q:BARSTOP
 ; Get check number
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 S DIR(0)="FA"
 S DIR("A")="CHECK NUMBER:  "
 S BARTMP=$G(BARCK)
 I BARTMP'="" S DIR("B")=BARTMP
 S DIR("?")="Enter the check number, (i.e. number in the top right corner of the check)"
 D ^DIR
 I X="" D  G CHECK
 . W !,?5,"Check Number is required",!!
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DUOUT)!$D(DTOUT) Q
 S BARCK=X
CHECKNM ;Checking account name
 Q:BARSTOP
 ;prompt for name on checking account or name of person making the payment
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 S DIR(0)="FA"
 S DIR("A")="NAME ON CHECKING ACCOUNT:  "
 S DIR("?")="Enter the name for this checking account, i.e. JOHN DOE"
 D ^DIR
 I X="" D  G CHECKNM
 . W !,?5,"Checking Account Name is required",!!
 I $D(DIROUT) S BARSTOP=1 Q
 I '$G(BARUPDT),$D(DUOUT) G CHECK
 I $G(BARUPDT),$D(DUOUT) Q
 I $D(DTOUT) Q
 S BARCNAME=X
 S BARDAT=1          ;required data collected
 ; Reset 'payment type' fields in case payment type was modified from other to 'check'
 I BARPMTYP="CK" S (BARCTYPE,BARCTYPN)=""
 Q
 ;
DEBIT ;data related to DEBIT CARD payment
CREDIT ;data related to CREDIT CARD payment
 Q:BARSTOP
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 S DIR(0)="SA^A:AMERICAN EXPRESS;C:DINERS CLUB;D:DISCOVER;M:MASTERCARD;V:VISA"
 S DIR("A")="CARD TYPE:  "
 S BARTMP=$$CARDTYPE^BARPPY1A($G(BARCTYPE))
 I BARTMP'="" S DIR("B")=BARTMP
 S DIR("?")="Enter type of credit card, i.e. Visa, Mastercard, etc...)"
 K DA
 D ^DIR
 I X="" D  G CREDIT
 . W !,?5,"Card type is required",!!
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 S BARCTYPE=Y           ;card type code (i.e. "M")
 S BARCTYPN=Y(0)        ;card type name (i.e. "MASTERCARD")
CARDNM ;prompt for name on credit card
 Q:BARSTOP
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 S DIR(0)="FA"
 S DIR("A")="NAME ON CARD:  "
 S DIR("?")="Enter the card holder name shown on the card, i.e. JOHN X DOE"
 D ^DIR
 I X="" D  G CARDNM
 . W !,?5,"Card holder name is required",!!
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DUOUT) G CREDIT
 I $D(DTOUT) Q
 S BARCNAME=X
 S BARDAT=1          ;required data collected
 ; Reset 'payment type' field in case payment type was modified from other to CR/DB
 I "^CC^DB^"[BARPMTYP S BARCK=""
 Q
 ;
AMOUNT1 ;prompt for payment
 Q:BARSTOP
 S BARAMT=$G(BARAMT)
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 S DIR(0)="NA^.01:999999.99:2"
 S DIR("A")="CREDIT:  "
 K DA
 D ^DIR
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 S BARAMT=X
 Q
 ;
ARBILL1 ;  Prompt for A/R bill #, Patient Name, Bill DOS
 Q:BARSTOP
 K BARFPASS
 S BARNEWPT=0
 W !
 ; IHS/SD/PKD 1/6/11
 K BARBL,BARBLIEN,BARDOSB,BARDOSE,BAREND,BARSTART
 K BARFPASS,BARPASS
 K BARPAT,BARTMPB,BARTMPE,BARZ  ; omit K BARPDOS
 S BARBIL=0,BARBLIEN=""  ;No bill selected yet
 F  D  Q:('+BARBIL)!(BARSTOP)!$D(DUOUT)!$D(DTOUT)!$G(BARNEWPT)=1  ;Ask A/R bills loop
 . I $G(BARNEWPT)=1 S BARFPASS=BARZ Q
 . K BARPAT,BARZ
 . S BARBIL=1                    ; Bill Entry Loop Flag
 . S BARFPASS=$$GETBIL  ; Get bills by bill, patient, or DOS
 . Q:BARSTOP!$D(DTOUT)
 . I (BARFPASS=0)!($P(BARFPASS,U,4)=""),+$G(BARPAT)>0 K BARPAT
 . I BARFPASS=0 S BARBIL=0 Q       ; No bill selected
 . I $G(BARNEWPT)=1 Q       ;Registered patient with no A/R Bills
 . S BARPASS=$P(BARFPASS,U,1,3)    ; needed for FINDBIL^BARFPST3
 . ; If no A/R Bill IEN
 . I '+$P(BARFPASS,U,4) D FINDBIL^BARFPST3 Q:'BARCNT  Q:'+BARASK
 . I $D(DIROUT) S BARSTOP=1 Q
 . Q:$D(DTOUT)
 . ; Update BARFPASS with A/R Bill DOS info from FINDBIL call
 . I BARFPASS'=0 D
 .. S BARBLIEN=$P(BARFPASS,U,4)   ; A/R BILL IEN
 .. S BARTMPB=$$GET1^DIQ(90050.01,BARBLIEN_",",102,"I")    ;DOS begin
 .. S BARTMPE=$$GET1^DIQ(90050.01,BARBLIEN_",",103,"I")    ;DOS end
 .. S $P(BARFPASS,U,2)=BARTMPB
 .. S $P(BARFPASS,U,3)=BARTMPE
 .. ; try this IHS/SD/PKD 1/6/11
 .. S (BARPDOS,BARDOSB)=BARTMPB  ;DOS defaults to BILL DOS
 .. S BARBIL=0
 S BARDOSB=$P(BARFPASS,U,2)    ; DOS begin
 S BARDOSE=$P(BARFPASS,U,3)    ; DOS end
 S BARBLIEN=$P(BARFPASS,U,4)   ; A/R BILL IEN
 I BARBLIEN'="" S (BARPAT,BARPTI1)=+($P(BARFPASS,U,1))  ; Patient IEN  override any previous if bill change
 I +$G(BARPAT)=0 S (BARPAT,BARPTI1,BARPTNM1)=""  ;if Bill Entered, keep Patient in sync  IHS/SD/PKD 1/6/11
 I +$G(BARPAT)>0 D  Q      ;Patient (BARPAT) selected in ARBILL1
 . ; Set patient IEN and NAME to what was selected when selecting A/R Bill data
 . S BARPTI1=BARPAT
 . S BARPTNM1=$$GET1^DIQ(9000001,BARPTI1,.01)      ; Patient Name
 Q
 ;
PAYDOS1 ; Enter DOS for the Payment
 Q:BARSTOP
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 ; If BILL DOS captured set that as the default for this entry
 S DIR(0)="DA^::E"
 S DIR("A")="PAYMENT FOR DOS:  "
 I $G(BARPDOS)="" S BARPDOS=$G(BARDOSB)
 S Y=BARPDOS
 D D^DIQ       ;converts internal FM date to external, returns  external dt Y
 S BARTMP=Y
 I BARTMP'="" S DIR("B")=BARTMP
 D ^DIR
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 I Y="" G PAYDOS1
 S BARPDOS=Y
 Q
 ;
GETPAT1 ; Select Patient if not selected in ARBILL1
 Q:BARSTOP
 W !
 I 'BARUPDT,+$G(BARPAT)>0 D  Q      ;Patient (BARPAT) selected in ARBILL1
 . ; Set patient IEN and NAME to what was selected when selecting A/R Bill data
 . S BARPTI1=BARPAT
 . S BARPTNM1=$$GET1^DIQ(9000001,BARPTI1,.01)      ; Patient Name
 K DIC,BARZ
 S BARTMP=$S($D(BARPTI1):BARPTI1,+$G(BARPAT)>0:BARPAT,1:"")
 I BARTMP S DIC("B")=$$GET1^DIQ(9000001,BARTMP,.01)
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMZ"
 S DIC("A")="Select Patient:  "
 D ^DIC
 K DIC
 S BARPTI1=X
 I X="" D  G GETPAT1
 . W !,?5,"Patient Name is required",!!
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 Q:+Y<0
 S BARPTI1=+Y         ;patient IEN (select patient prompt)
 S BARPAT1(0)=Y(0)     ;patient name (select patient prompt)
 S BARPTNM1=$P($G(^DPT(+BARPTI1,0)),"^",1)   ;patient name (select patient prompt)
 I '$D(^BARBL(DUZ(2),"ABC",+Y)) D
 . K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 . S DIR(0)="SO^Y:YES  Continue;N:NO   Select a different patient"
 . S DIR("A")="This is a registered patient with no bills.  Continue Y/N:  "
 . ;S DIR("B")="N"
 . K DA
 . D ^DIR
 . I $D(DIROUT) S BARSTOP=1 Q
 . I $D(DTOUT)!$D(DUOUT) Q
 . I "Nn"[Y D  G GETPAT1
 .. K BARPTI1,BARPAT1(0),BARPTNM1
 . S BARNEWPT=2            ;Registered patient only, no bills (2nd Select Patient Prompt)
 Q
 ;
CMTS ;  Enter Pre-payment Comments
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 S BARCMTS=$G(BARCMTS)
 S DIR(0)="FAOU^:255"
 S DIR("A")="COMMENTS:  "
 D ^DIR
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) Q
 S BARCMTS=X
 Q
 ;***********
 ; COPIED FROM GETBIL^BARFPST3 
 ;     modified to allow user to "^" back to prior prompt or "^^" to
 ;      exit completely
 ;       
GETBIL() ; EP
GB1 ;   Return point when user enters "^" in ASKPAT tag
 ; EP - Flat Rate Posting - Bill Entry
 ; If Editing, ask Flat Rate Posting Bill
 ; Kill identifying Vars if chg'g BILL
 ; IHS/SD/PKD 1/5/11
 ;K BARBLIEN,BARPDOS,BARDOSB,BARDOSE,BAREND,BARPASS,BARPATI
 ;K BARBLIEN,BARDOSB,BARDOSE,BAREND,BARPASS,BARPATI
 ;K BARPAT
 ;K BARPTI1,BARPTNM1,BARSTART,BARTMPB,BARTMPE,BARPPDOS,BARZ
 ;K AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX
 I $G(BARRECPQ)="E" D SELFRBIL^BARFPST3 I $G(BARZ) Q BARZ  ; Flat Rate bill select
 D SELBILL^BARPUTL             ; Ask A/R BILL
 I X="^^" S BARSTOP=1 Q 0
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$G(BARSTOP) Q 0
 I $G(BARZ) D  Q BARZ
 . S BARBL=+Y                  ; IEN to A/R IHS BILL File
 . S $P(BARZ,U,4)=BARBL
 ;
ASKPAT ; EP
 W !
 S DICB=$S($D(BARPAT):BARPAT,1:"")
 D ASKPATB^BARPUTL(DICB)            ; If bill not answered, ask patient
 I X="^^" S BARSTOP=1 Q 0
 I BARSTOP Q 0
 I $D(DUOUT) G GB1
 I $D(DTOUT) Q 0
 I $G(BARZ) Q BARZ
 D GETBIL^BARPUTL              ; If patient not answered, ask DOS
 I X="^^" S BARSTOP=1 Q 0
 I BARSTOP Q 0
 I $D(DUOUT) G ASKPAT
 I $D(DTOUT) Q 0
 I $G(BARZ) Q BARZ
 Q 0                           ; No bills entered
 ;
RESETDIR ;  Clear variables for DIR  no longer used
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 Q
 ;
ASKPATB ;EP - select patient
 ; Same functionality as ASKPAT^BARPUTL but and allows user select a patient
 ; with A/R Bills and passes default value for DIC("B"))
 K DIC,BARZ,BARPAT
 S BARNEWPT=0
 S DIC("B")=$G(DICB)
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"
 D ^DIC
 K DIC
 Q:+Y<0
 S BARPAT=+Y
 S BARPAT(0)=Y(0)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 I '$D(^BARBL(DUZ(2),"ABC",+Y)) D
 . K DIR,DTOUT,DUOUT,DIROUT,DIRUT W !
 . S DIR(0)="SO^Y:YES  Continue this patient without an A/R Bill;N:NO   Do not continue this patient, select a different one"
 . S DIR("A")="The selected patient does not have an A/R Bill. Continue Y/N:  "
 . ;S DIR("B")="N"
 . K DA
 . D ^DIR
 . I $D(DIROUT) S BARSTOP=1 Q
 . I $D(DTOUT)!$D(DUOUT) Q
 . I "Nn"[Y D  G ASKPATB
 .. K BARPAT,BARPAT(0)
 . S BARNEWPT=1
 I BARNEWPT=0 D GETDOS^BARPUTL
 I BARNEWPT=0,'$G(BAROK) K BARPAT,BARPAT(0) Q
 S BARZ=BARPAT_"^"_$G(BARSTART)_"^"_$G(BAREND)
 Q
 ;
INIT ;
 D CLEARVAR
 S (BARDONE,BARSTOP,BARUPDT,HINBLON,HINPTON)=0
 S BARNOTE="**"
 S BARNOTE1="** Indicates Bill DOS does not match payment date for service."
 S BARNOTE2="Patient in Item 6 must match patient in item 5 when A/R Bill is selected"
 Q
 ;
CLEARVAR ; kill variables
 K BARAMT,BARAMTUP,BARASK
 K BARBIL,BARBL,BARBLIEN
 K BARCK,BARCMT,BARCMTS,BARCNAME,BARCNT,BARCPT,BARCTYPE,BARCTYPN
 K BARDAT,BARDEPTE,BARDEPTI,BARDOSB,BARDOSE
 K BAREND,BARESIG
 K BARFILE,BARFPASS
 K BARIENS,BARITEM
 K BARLIST,BARLNG,BARNEWPT,BAROK
 K BARPAT,BARPATNM,BARPDOS,BARPMTYP,BARPPIEN,BARPTI1,BARPTNM1
 K BARQUIT,BARRECPQ,BARSTART,BARSUFX
 K BARTAG,BARTAG1,BARTMP,BARTMP1,BARTMPB,BARTMPE,BARTMPF
 K BARVAR,BARZERO
 K BARZ
 K CARD,CARDTYPE
 K DIC,DICB,DICB2,DICB3,DIE,DIROUT,DIRUT,DR,DTOUT,DUOUT
 K HINBLON,HINPTON
 K PAYTYPE,PMTYP
 K X,X1,Y
 Q
 ;
CLEAN ;  Clean up
 D CLEARVAR
 ;stuff not cleared in CLEARVAR
 K BARDONE,BARNOTE,BARNOTE1,BARNOTE2,BARSTOP,BARUPDT,HINBLON,HINPTON
 K X,X1,Y
 Q
 ;
