BARFPST3 ; IHS/SD/LSL - A/R FLAT RATE POSTING #3 ; 01/09/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,6,10,21**;OCT 26, 2005
 ;
 Q
 ; *********************************************************************
DISP ; EP
 ; Display Accumulated posted amount and posting balance from
 ; A/R FLAT RATE POSTING File before making entries
 ; BARBIEN = IEN to A/R BILLS mult in VISIT LOCATION mult in FRP File
 ;       J = Bill Counter
 S (J,BARBIEN)=0
 F  S BARBIEN=$O(^BARFRP(DUZ(2),BARIEN,2,BARFIEN,3,BARBIEN)) Q:'+BARBIEN  S J=J+1
 S BARAPST=+$G(BARPAY)*J       ; Amount To Post
 S BARBAL=BARPAMT-BARAPST      ; Remaining Balance
 W !!,"Amount To Post: ",BARAPST,?30,"Remaining Balance: ",BARBAL
 Q
 ; *********************************************************************
FRPBILL ; EP
 ; EP - Continue top-level loop logic 
 S BARFLAG=0                   ; Review flag (no posting)
 S BARPDBY=$$VALI^XBDIQ1(90051.1101,"BARCOL,BARITM",7)  ; Payor on item
 F  D BILLS Q:'+BARBIL         ; Ask A/R bills loop
 Q
 ; *********************************************************************
BILLS ;
 ; Loop through and enter/edit A/R Bills multiple in
 ; A/R FLAT RATE POSTING File
 ; BARFPASS = Patient^DOS Start^DOS End^A/R BILL IEN^FRP BILL IEN
 K BARPAT,BARZ
 S BARBIL=1                    ; Bill Entry Loop Flag
 S BARFPASS=$$GETBIL^BARFPST3  ; Get bills by bill, patient, or DOS
 I BARFPASS=0 S BARBIL=0 Q     ; No bill selected; End loop
 S BARPASS=$P(BARFPASS,U,1,3)  ; Patient^DOS Start^DOS End
 ; If no A/R Bill IEN
 I '+$P(BARFPASS,U,4) D FINDBIL Q:'BARCNT  Q:'+BARASK
 ; The user selected a bill from ^BARFRP; Ask delete
 ; (Can only be done through EDIT)
 I $P(BARFPASS,U,5)]"" D DELBIL Q
 S BARBLHLD=+$P(BARFPASS,U,4)
 ; Bill entered already in ^BARFRP. don't add again
 I $D(^BARFRP(DUZ(2),BARIEN,2,BARFIEN,3,"B",BARBLHLD)) D  Q
 . W !,$$VAL^XBDIQ1(90050.01,BARBLHLD,.01)
 . W " has already been entered."
 D PAYOR Q:'+BARPAYOR          ; If payors differ, notify user
 D BILEXIST Q:'+BARBILE        ; Check for bill in different FRP batch
 ;D NEGBILL Q:'+BARBILB         ; Check for neg balance on bill  ;MRS:BAR*1.8*10 H632
 I $$IHS^BARUFUT(DUZ(2)) D NEGBILL Q:'+BARBILB  ;MRS:BAR*1.8*10 H632
 ; Display amount posted (accumulated) and remaining balance
 S BARAPST=BARAPST+$G(BARPAY)  ; Amount To Post
 S BARBAL=BARPAMT-BARAPST      ; Remaining Balance 
 W !,"Amount To Post: ",BARAPST,?30,"Remaining Balance: ",BARBAL
 ; If posting results in negative balance, stop and send to review
 ;I BARBAL<0 D  Q                       ;MRS:BAR*1.8*10 H632
 I $$IHS^BARUFUT(DUZ(2)),BARBAL<0 D  Q  ;MRS:BAR*1.8*10 H632
 . W !,"Posting this payment will result in a negative balance."
 . S BARAPST=BARAPST-$G(BARPAY)
 . S BARBAL=BARPAMT-BARAPST
 . S BARBIL=0
 D SAVEBIL                     ; Save Bill to A/R FLAT RATE POSTING file
 Q
 ; *********************************************************************
GETBIL() ; EP
 ; EP - Flat Rate Posting - Bill Entry
 ; If Editing, ask Flat Rate Posting Bill
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q 0 ;IS SESSION STILL OPEN
 G CONT
GETBIL2()  ;EP for Calls that don't need open Cashiering Sessions
CONT ; Remarks entry:  BARPRMKP
 ; End 1.8*21
 I $G(BARRECPQ)="E" D SELFRBIL^BARFPST3 I $G(BARZ) Q BARZ
 D SELBILL^BARPUTL             ; Ask A/R BILL
 I $G(BARZ) D  Q BARZ
 . S BARBL=+Y                  ; IEN to A/R IHS BILL File
 . S $P(BARZ,U,4)=BARBL
 D ASKPAT^BARPUTL              ; If bill not answered, ask patient
 I $G(BARZ) Q BARZ
 D GETBIL^BARPUTL              ; If patient not answered, ask DOS
 I $G(BARZ) Q BARZ
 Q 0                           ; No bills entered
 ; *********************************************************************
SELFRBIL ; EP
 ; EP - look up into A/R FLAT RATE POSTING File if EDIT
 K DIC
 S DA(1)=BARFIEN               ; IEN to VISIT LOC mult in A/R FRP File
 S DA(2)=BARIEN                ; IEN to A/R FLAT RATE POSTING File
 S DIC="^BARFRP(DUZ(2),DA(2),2,DA(1),3,"
 S DIC("A")="Select Flat Rate Post BILL: "
 S DIC(0)="AEZMQ"
 ; Write patient name next to Bill number
 S DIC("W")="D SELFRID^BARFPST3"
 D ^DIC
 Q:+Y<1
 S BARPAT=$P(^BARBL(DUZ(2),+Y(0),1),U)      ; A/R patient
 S BARSTART=$P(^BARBL(DUZ(2),+Y(0),1),U,2)  ; DOS Start date
 S BAREND=$P(^BARBL(DUZ(2),+Y(0),1),U,3)    ; DOS End date
 S:BAREND="" BAREND=BARSTART
 S BARZ=BARPAT_U_BARSTART_U_BAREND_U_+Y(0)_U_+Y
 Q
 ; *********************************************************************
SELFRID ;
 ; Identifier on "Select Flate Rate Post BILL"
 ; Patient name from A/R bill file
 S BARID1=$$VALI^XBDIQ1(90054.0103,"BARIEN,BARFIEN,Y",.01)
 S BARID2=$$VAL^XBDIQ1(90050.01,BARID1,101)
 W ?30,$E(BARID2,1,30)
 Q
 ; *********************************************************************
FINDBIL ; EP
 S BARASK=1
 S BARCNT=$$EN^BARPST2(BARPASS)  ; Count bills for DOS range
 I 'BARCNT D  Q                  ; No bills found  
 . W *7
 . W !,"No bills found in this date range!"
 I BARCNT=1 D  Q                 ; One bill found for DOS range
 . S $P(BARFPASS,U,4)=$O(^BARTMP($J,"B",BARCNT,""))
 ; More than one bill found for DOS range, ask user to select
 D HIT^BARFPST3(BARPASS)         ; List bills for DOS range
 D ASKLIN Q:'+BARASK             ; Ask user to select one 
 S $P(BARFPASS,U,4)=$O(^BARTMP($J,"B",BARLIN,""))  ; A/R Bill IEN
 Q
 ; *********************************************************************
HIT(BARPASS)       ; EP
 ; EP - Display A/R bills found
 N BARBDA,BARLIN,BARREC,BARBLO
 S (BARBDA,BARPG,BARSTOP)=0
 ;
 ; header
 W $$EN^BARVDF("IOF"),!        ; Clear screen
 N BARPTNAM                    ; A/R Patient Name
 S BARPG=BARPG+1               ; Page number
 S BARPTNAM=$P(^DPT(+BARPASS,0),U)  ; A/R Patient Name
 ; If A/R Patient cross-reference on A/R TRANSACTION/IHS File
 I $D(^BARTR(DUZ(2),"AM5",+BARPASS)) S BARPTNAM="(msg) "_BARPTNAM
 W "Claims for "_BARPTNAM
 W " from "_$$SDT^BARDUTL($P(BARPASS,U,2))
 W " to "_$$SDT^BARDUTL($P(BARPASS,U,3))
 W ?(IOM-15),"Page: "_BARPG
 W !!
 W "Line #",?8,"DOS",?18,"Claim #",?32,"Amount",?44,"Billed To",?70,"Balance"
 S BARDSH=""
 S $P(BARDSH,"-",IOM)=""       ; Line of dashes
 W !,BARDSH
 F  S BARBDA=$O(^BARTMP($J,BARBDA)) Q:'BARBDA  D  Q:BARSTOP
 . S BARLIN=$O(^BARTMP($J,BARBDA,""))
 . S BARREC=^BARTMP($J,BARBDA,BARLIN)
 . S BARBLO=$P(BARREC,U,2)
 . I $O(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m "_BARBLO
 . S BARSTOP=$$CHKLINE(0)
 . Q:BARSTOP
 . S BARCMSG="      "
 . S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 . W !,$J(BARLIN,3)
 . W ?6,$$SDT^BARDUTL($P(BARREC,U))
 . W ?18,BARBLO
 . W ?25,BARCMSG
 . W ?32,$J($P(BARREC,U,3),8,2)
 . W ?44,$E($P(BARREC,U,4),1,23)
 . W ?70,$J($P(BARREC,U,5),8,2)
 Q
 ; *********************************************************************
CHKLINE(BARHD)     ;
 ; Q 0 = continue
 ; Q 1 = stop
 N X
 I ($Y+5)<IOSL Q 0
 W !?(IOM-15),"continued==>"
 D EOP^BARUTL(0)
 I 'Y Q 1
 Q 0
 ; *********************************************************************
ASKLIN ; EP
 ; If entering bills by Patient or DOS, ask user to choose one
 W !
 K DIR
 S DIR(0)="NAO^^K:X>BARCNT X"
 S DIR("A")="Line #: "
 S DIR("?")="Enter a number between 1 and "_BARCNT
 D ^DIR
 I +Y<0 S BARASK=0 Q
 S BARLIN=+Y
 Q
 ; *********************************************************************
DELBIL ;
 ; Ask if user wants to delete bill from A/R FLAT RATE POSTING File
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Delete"
 S DIR("B")="No"
 D ^DIR
 K DIR
 Q:Y'=1
 ; If the answer is yes, delete bill from A/R FLAT RATE POSTING File
 K DIK
 S DA(2)=BARIEN                ; IEN to A/R FLAT RATE POSTING File 
 S DA(1)=BARFIEN               ; IEN to VISIT LOC mult of A/R FRP File
 S DA=$P(BARFPASS,U,5)         ; IEN to A/R BILL mult of A/R FRP File 
 S DIK="^BARFRP(DUZ(2),DA(2),2,DA(1),3,"
 D ^DIK                        ; Kill bill entry
 S BARAPST=BARAPST-$G(BARPAY)  ; Amount To Post
 S BARBAL=BARPAMT-BARAPST      ; Remaining Balance
 W ?20,"Deleted."
 W !,"Amount To Post: ",BARAPST,?30,"Remaining Balance: ",BARBAL
 Q
 ; *********************************************************************
PAYOR ;
 ; If payor on bill differs from payor on account, notify user
 S BARPAYOR=1
 I $P(BARFPASS,U,4)="" S BARBTO="UNKNOWN"  ; Payor billed
 E  S BARBTO=$$VALI^XBDIQ1(90050.01,$P(BARFPASS,U,4),3)
 I BARBTO'=BARPDBY D  Q:'+Y  ; if billed to '= paid by payor
 . K DIR
 . ;BEGIN CODE CHANGE FOR IM14057 - LSL 07/07/04
 . ;S DIR("A",2)="The Payor ("_$$VAL^XBDIQ1(90050.02,BARBTO,.01)_") on the bill"
 . ;S DIR("A",3)="does not match the Payor ("_$$VAL^XBDIQ1(90050.02,BARPDBY,.01)_") on the item."
 . S DIR("A",2)="The payor ("
 . S DIR("A",2)=DIR("A",2)_$S(BARBTO="UNKNOWN":"UNKNOWN",1:$$GET1^DIQ(90050.02,BARBTO,.01))
 . S DIR("A",2)=DIR("A",2)_") on the bill"
 . S DIR("A",3)="does not match the Payor ("_$$GET1^DIQ(90050.02,BARPDBY,.01)_") on the item."
 . ;END CODING CHANGE IM14057
 . S DIR("A")="Continue"
 . S DIR("B")="No"
 . S DIR(0)="Y"
 . D ^DIR
 . S:'+Y BARPAYOR=0
 Q
 ; *********************************************************************
BILEXIST ;
 ; Check for bill in existing FRP Batch
 N BARSTAT,BARNAME
 S BARBILE=1
 Q:'$D(^BARFRP(DUZ(2),"C",BARBLHLD))   ; not in file
 S BARIEN2=$O(^BARFRP(DUZ(2),"C",BARBLHLD,""))
 S BARSTAT=$$VALI^XBDIQ1(90054.01,BARIEN2,.13)
 S BARSTAT=$S(BARSTAT="P":"POSTED",1:"UNPOSTED")
 S BARNAME=$$VAL^XBDIQ1(90054.01,BARIEN2,.01)
 K DIR
 S DIR(0)="Y"
 S DIR("A",2)="This bill already exists in the "_BARSTAT_" FRP Batch "_BARNAME
 S DIR("A")="Continue"
 S DIR("B")="No"
 D ^DIR
 S:'+Y BARBILE=0
 Q
 ; *********************************************************************
NEGBILL ;
 ; If negative balance on bill
 S BARBILB=1
 S BARBLBAL=$$VAL^XBDIQ1(90050.01,BARBLHLD,15)    ; Current balances
 S BARBALH=BARBLBAL-$G(BARPAY)-$G(BARADJT)
 I BARBALH<0 D                      ;HEAVILY MODIFIED;MRS:BAR*1.8*6 DD 4.2.5
 .S BARBILB=0
 .D STOP^BARFPST5("BILL",BARBALH)
 .; K DIR
 .; S DIR("A",2)="Posting this bill will result in a negative balance on the bill."
 .; S DIR("A")="Continue"
 .; S DIR("B")="No"
 .; S DIR(0)="Y"
 .; D ^DIR
 .; S:'+Y BARBILB=0
 Q
 ; *********************************************************************
SAVEBIL ;
 ; Save Bill to A/R FLAT RATE POSTING File
 K DIC
 S DA(2)=BARIEN
 S DA(1)=BARFIEN
 S DIC="^BARFRP(DUZ(2),DA(2),2,DA(1),3,"
 S DIC(0)="L"
 S DIC("P")=$P(^DD(90054.0102,30,0),U,2)
 S X=$P(BARFPASS,U,4)
 K DD,DO
 D FILE^DICN
 K DIC
 Q
