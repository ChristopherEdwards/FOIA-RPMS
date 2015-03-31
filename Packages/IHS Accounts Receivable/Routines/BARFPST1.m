BARFPST1 ; IHS/SD/LSL - FLAT RATE POSTING (CONT) ; 12/22/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,10,21,23**;OCT 26, 2005
 ;; P.OTT Aug 2013 HEAT#126384 FIXED <undef> @ FDIH
 ;
 Q
 ; *********************************************************************
PAYADJD ; EP
 ; EP - Display payment/adjustment in FRP file
 S BARACNT=0               ; Adjustment array counter
 I $D(BARIEN) D            ; If existing Flat Rate Posting entry
 . S BARPAY=$$VAL^XBDIQ1(90054.01,BARIEN,.09)  ; Payment
 . D PAYADJA               ; Build Adjustment Array 
 . D PAYADJQ               ; Display array
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 Q
 ; *********************************************************************
PAYADJA ;
 ; Build Adjustment array from FRP file
 N BARTMP
 F  S BARACNT=$O(^BARFRP(DUZ(2),BARIEN,1,BARACNT)) Q:'+BARACNT  D
 . S BARTMP=BARACNT
 . S BARFR0=$G(^BARFRP(DUZ(2),BARIEN,1,BARACNT,0))
 . S $P(BARADJ(BARACNT),U)=$P(BARFR0,U,3)   ; Adjustment amount
 . S $P(BARADJ(BARACNT),U,2)=$P(BARFR0,U)   ; IEN to A/R TABLE TYPE/IHS
 . ; Adjustment Category
 . S $P(BARADJ(BARACNT),U,3)=$$VAL^XBDIQ1(90052.01,$P(BARFR0,U),.01)
 . S $P(BARADJ(BARACNT),U,4)=$P(BARFR0,U,2) ; IEN to A/R TABLE ENTRY/IHS
 . ; Adjustment Type
 . S $P(BARADJ(BARACNT),U,5)=$$VAL^XBDIQ1(90052.02,$P(BARFR0,U,2),.01)
 S BARACNT=$G(BARTMP)                       ; Last entry in array
 Q
 ; *********************************************************************
PAYADJQ ;
 ; Display Payments and Adjustments
 S BARADJT=0
 I $D(BARPAY) W !!?4,"PAYMENT:",?15,BARPAY
 E  W !!,"No Payments entered."
 I $D(BARADJ) D
 . W !!,"ADJUSTMENTS:"
 . S J=0
 . F  S J=$O(BARADJ(J)) Q:'+J  D
 . . W ?15,+BARADJ(J),?30,$P(BARADJ(J),U,3),?50,$P(BARADJ(J),U,5),!
 . . S BARADJT=BARADJT+$P(BARADJ(J),U)
 E  W !!,"No Adjustments entered."
 Q
 ; *********************************************************************
PAYADJ ; EP
 ; EP - Ask user for Payment and/or Adjustments.
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 K BARSCAT,BARSCAT2,BARSAMT,BARSTYP,BARSTYP2
 D PACOM                            ; Select Command
 I '+BARCOM W !!,"This is a required response.",! G PAYADJ
 D:BARPA="Q" PAYADJQ                ; Q from "Select Command: P/A/Q"
 I BARPA="P" D PAYMNT Q:'+BARPY     ; Enter payment amount
 I BARPA="A" D  Q:'+BARAD  Q:'+BARACAT  Q:'+BARATYP  ; Enter adjustments
 . F  D  Q:'+BARAD  Q:'+BARACAT  Q:'+BARATYP
 . . K BARSAMT,BARSCAT,BARSCAT2,BARSTYP,BARSTYP2
 . . D ADJAMT Q:'+BARAD             ; Ask Adjustment Amount
 . . D ADJCAT Q:'+BARACAT           ; Ask Adjustment Category
 . . ; If only one type for this category, don't ask TYPE
 . . S (BARX,BARJ)=0
 . . F  S BARX=$O(^BARTBL("D",BARSCAT,BARX)) Q:'+BARX  D  Q:BARJ>1
 . . . S BARJ=BARJ+1
 . . . Q:BARJ>1
 . . . S BARATYP=1                  ; Adjustment Type Entry Flag
 . . . S BARSTYP=BARX               ; IEN to A/R TABLE ENTRY/IHS
 . . . S BARSTYP2=$P($G(^BARTBL(BARSTYP,0)),U)  ; Adjustment Type P.OTT HEAT#126384
 . . I BARJ>1 D ADJTYP Q:'+BARATYP  ; Ask Adjustment Type
 . . S BARTMP=BARSCAT_BARSTYP       ; Adj cat and typ used for dup chk
 . . ; Check to make sure category and type doesn't already exist
 . . S I=0
 . . F  S I=$O(BARADJ(I)) Q:'+I  D
 . . . S BARTMP2=$P(BARADJ(I),U,2)_$P(BARADJ(I),U,4)
 . . . I BARTMP=BARTMP2 D  Q
 . . . . W !?+5,$J($P(BARADJ(I),U),9,2),?20,$P(BARADJ(I),U,3),?40,$P(BARADJ(I),U,5)_" already exists."
 . . . . K DIR
 . . . . S DIR(0)="Y"
 . . . . S DIR("A")="Replace"
 . . . . S DIR("B")="No"
 . . . . D ^DIR
 . . . . Q:Y'=1
 . . . . K BARADJ(I)
 . . ; Enter category and type in array
 . . S BARACNT=BARACNT+1            ; Counter for entry into Adj array
 . . S BARADJ(BARACNT)=BARSAMT_U_BARSCAT_U_BARSCAT2_U_BARSTYP_U_BARSTYP2
 Q
 ; *********************************************************************
PACOM ;   
 ; Select Command for Payment and/or Adjustments.
 W !
 S BARCOM=1                         ; "Select Command: P/A/Q" Entry Flag
 K DIR
 S DIR(0)="F^1:1"
 S DIR("A")="Select Command (P/A/Q)"
 S DIR("?")="^D PACOMHLP^BARFPST1"
 S DIR("??")="^D PACOMHLP^BARFPST1"
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="") S BARCOM=0 Q    ; "Select Command: P/A/Q" Entry Flag
 S BARPA=$S(Y=1:"P",Y="P":"P",Y="p":"P",Y=2:"A",Y="A":"A",Y="y":"Y",Y=3:"Q",Y="Q":"Q",Y="q":"Q",1:"")               ; User response to prompt
 I BARPA="" D  Q                    ; Invalid user response
 . W !
 . D PACOMHLP                       ; Help routine for payment/adjust
 . S BARCOM=0                       ; "Select Command: P/A/Q" Entry Flag
 Q
 ; *********************************************************************
PACOMHLP ;
 ; Help for "Select command (P/A/Q)"
 W !,"Enter a code from the list."
 W !!?5,"Select one of the following:"
 W !!?10,"P or 1",?20,"PAYMENT"
 W !?10,"A or 2",?20,"ADJUSTMENT"
 W !?10,"Q or 3",?20,"QUIT"
 Q
 ; *********************************************************************
PAYMNT ;
 ; Enter Flat Rate Posting Payment
 S BARPY=1
 W !
 K DIR
 S DIR(0)="NAO^-999999999:999999999:2"
 S DIR("A")="PAYMENT AMOUNT: "
 S:$D(BARPAY) DIR("B")=BARPAY
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="") S BARPY=0 Q
 I Y<0,$$IHS^BARUFUT(DUZ(2)) D STOP S BARPY=0 Q     ;MRS:BAR*1.8*10 D158-3 
 ;;;I Y<0,$$IHSERA^BARUFUT(DUZ(2)) D STOP S BARPY=0 Q     ;MRS:BAR*1.8*10 D158-3 P.OTT
 S BARNPAY=+Y
 I '$D(BARIEN) D          ;MRS:BAR*1.8*6 DD 4.2.5 Check balance when creating
 .I BARNPAY>BARCLIT(19) D WARN("ITEM") Q
 .I BARNPAY>BARCL(17) D WARN("BATCH")
 I $D(BARIEN) D PAYGNEG              ; Check for negative balance
 I '$D(BARNPAY) G PAYMNT
 S BARPAY=BARNPAY                    ; Canonic value of payment
 Q
 ; *********************************************************************
PAYGNEG ;
 ; Check to see that changing payment won't result in negative balance
 N BARAPST,BARBAL,BARPAMT
 Q:'+$D(^BARFRP(DUZ(2),BARIEN,2,"B",BAREOB))  ; No data
 S BARFACT=$O(^BARFRP(DUZ(2),BARIEN,2,"B",BAREOB,""))
 S (J,BARBIEN)=0
 F  S BARBIEN=$O(^BARFRP(DUZ(2),BARIEN,2,BARFACT,3,BARBIEN)) Q:'+BARBIEN  S J=J+1
 S BARPAMT=$$VAL^XBDIQ1(90054.01,BARIEN,.1)
 S:J=0 J=1                           ;NO BILLS;MRS:BAR*1.8*6 DD 4.2.5
 S BARAPST=J*BARNPAY
 S BARBAL=BARPAMT-BARAPST
 I BARBAL<0 D WARN("ITEM")           ;MRS:BAR*1.8*6 DD 4.2.5
 ;W !,"Changing the PAYMENT will cause a negative balance for this FRP batch."
 ;K BARNPAY
 Q
 ; ********************************************************************
ADJAMT ;
 ; Enter Flat Rate Posting Adjustments
 S BARAD=1                          ; Adjustment Amount Entry Flag
 W !
 K DIR
 S DIR(0)="NAO^-999999999:999999999:2"
 S DIR("A")="ADJUSTMENT AMOUNT: "
 ; If ??, display Adjustment array w/ Category and Type.
 S DIR("??")="^D ADJLIST^BARFPST1"
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="") S BARAD=0 Q     ; Adjustment Amount Entry Flag
 S BARSAMT=Y                        ; Canonic value of Adjustment
 Q
 ; *********************************************************************
ADJLIST ;
 ; Help for "ADJUSTMENT AMOUNT:"
 ; List Adjustment array of Amount, Category, Type
 I '$D(BARADJ) W !,"No adjustments entered,  Please enter a dollar amount." Q
 W !,"Adjustments already entered follows:  ",!
 S J=0
 F  S J=$O(BARADJ(J)) Q:'+J  D
 . W !?5,+BARADJ(J),?20,$P(BARADJ(J),U,3),?40,$P(BARADJ(J),U,5)
 W !!,"Please enter a dollar amount."
 Q
 ; *********************************************************************
ADJCAT ;  
 ; Select Adjustment Category from 90052.01
 N I
 S BARACAT=1                        ; Adjustment Category Entry Flag
 K DIC
 S DIC=90052.01                     ; A/R TABLE TYPE /IHS File
 S DIC(0)="AEQMNZ"
 S DIC("A")="Adjustment Category: "
 ; Screen for only those A/R tables related to Adjustments
 S DIC("S")="I "",3,4,13,14,15,16,20,21,22""[("",""_Y_"","")"
 D ^DIC
 K DIC
 I +Y<0 D  Q
 . W *7
 . S BARACAT=0                      ; Adjustment Category Entry Flag
 . K BARSCAT,BARSCAT2
 S BARSCAT=+Y                       ; IEN to A/R TABLE TYPE
 S BARSCAT2=$P(Y,U,2)               ; Adjustment Category
 Q
 ; *********************************************************************
ADJTYP ;
 ; Select Adjustment Tye from 90052.02
 S BARATYP=1                        ; Adjustment Type Entry Flag
 N I
 K DIC
 S DIC=90052.02                     ; A/R TABLE ENTRY /IHS File
 S DIC(0)="AEQMNZ"
 S DIC("A")="Adjustment Type: "
 ; Screen for entries that have Category selected above
 S DIC("S")="I $P(^(0),U,2)=BARSCAT"
 D ^DIC
 K DIC
 I +Y<0 D  Q
 . W *7
 . K BARSTYP,BARSTYP2
 . S BARATYP=0                      ; Adjustment Type Entry Flag
 S BARSTYP=+Y                       ; IEN to A/R TABLE ENTRY /IHS file
 S BARSTYP2=$P(Y,U,2)               ; Adjustment type
 Q
WARN(MSG) ;EP; NEW NEGATIVE BALANCE MESSAGE ;MRS:BAR*1.8*6 DD 4.2.5
 Q:'$$IHS^BARUFUT(DUZ(2))
 ;;;Q:'$$IHSERA^BARUFUT(DUZ(2)) ;IS P.OTT NEG PAYMENT OK?
 ; FALL THRU: ALL IHS FACILITIES
 ;            TRIBAL WITH FLAG SET
 W !?10,"WARNING: PAYMENT AMOUNT EXCEEDS "_MSG_" BALANCE AMOUNT"
 W !?24,"PLEASE ENTER A VALID VALUE"
 K BARNPAY
 Q
STOP ;EP;NEW FUNCTIONALITY TO PREVENT PAYMENT REVERSALS ;MRS:BAR*1.8*10 D158-3
 ;
 W !?10,"PAYMENT REVERSALS ARE NO LONGER ALLOWED"
 W !?24,"PLEASE USE PAYMENT CREDIT ADJUSTMENTS"
 K BARNPAY
 Q
