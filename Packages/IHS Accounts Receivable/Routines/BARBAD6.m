BARBAD6 ; IHS/SD/LSL - MESSAGE PROCESSOR ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 11/26/02 - V1.7 - QAA-1200-130051
 ;     Modified to quit if error in creating an A/R Transaction
 ;
 ; ********************************************************************
 ;** Message processor for accounts,patients and bills
 ;
EN(BARPAT,BARBIL,BARACC)     ;EP - message processor
1 ;
 S:'$D(BARPAT) BARPAT=""
 S:'$D(BARBIL) BARBIL=""
 S:'$D(BARACC) BARACC=""
 ;
 N BARMTYP,BARM,BAR1,BAR2,BAR3,BAR4
EN1 ;
 D CENTER("Message Processor")
 F J=4:1:6 S BARM(J)=""
EN2 ;
 W !
 I BARPAT S BARM(5)=$$GET1^DIQ(2,BARPAT,.01)
 I BARBIL  S BARM(4)=$$GET1^DIQ(90050.01,BARBIL,.01)
 I BARACC S BARM(6)=$$GET1^DIQ(90050.02,BARACC,.01)
 S BAR1=$S($L(BARM(4)):"1:BILL MESSAGE for bill "_BARM(4),1:"1:No Bill defined.")
 S BAR2=$S($L(BARM(5)):"2:PATIENT MESSAGE for patient "_BARM(5),1:"2:No patient defined.")
 S BAR3=$S($L(BARM(6)):"3:ACCOUNT MESSAGE for account "_BARM(6),1:"3:No account defined.")
 S BAR4="4:EXIT"
 S DIR(0)="SO^"_BAR1_";"_BAR2_";"_BAR3_";"_BAR4
 S DIR("A")="Select Message Level"
 S DIR("?")="^W *7 D CENTER^BARBAD6(""Message Processor"")"
 D ^DIR
 K DIR
 Q:$D(DUOUT)!(+Y=0)!(Y=4)
 S BARMTYP=Y
 S BARY=BARMTYP+3
 I '$L(BARM(BARY)) W *7,"??" H 5 G EN1
 D VIEW
 D TX
 G EN1
 ; *********************************************************************
 ;
VIEW ;
 N BARCNT,BARXRF,BARBX,BARTRDA,BARTRD1
 S BARBX=$S(BARMTYP=1:BARBIL,BARMTYP=2:BARPAT,BARMTYP=3:BARACC,1:"")
 S BARXRF="AM"_BARY
 W !!
 I '$D(^BARTR(DUZ(2),BARXRF,BARBX)) D  Q
 .W *7,!!!,"No Messages on file!"
 .D EOP^BARUTL(1)
 .Q
 S DIR("A")="View existing Messages (Y/N): "
 S DIR("B")="NO"
 S DIR(0)="YOA"
 D ^DIR
 K DIR
 I Y=0!($D(DUOUT)) Q
 D VIEWR^XBLM("VIEW2^BARBAD6","Message Display for  "_BARM(BARY))
 G VIEW3
 ; *********************************************************************
 ;
VIEW2 ;
 W $$EN^BARVDF("IOF"),!
 K ^UTILITY($J,"W")
 S DIWL=15,DIWR=77,DIWF="W"
 S (BARSTOP,BARCNT)=0
 S BARTRDA="A"
 F  S BARTRDA=$O(^BARTR(DUZ(2),BARXRF,BARBX,BARTRDA),-1) Q:'BARTRDA  D  Q:BARSTOP
 . W !,$$GET1^DIQ(90050.03,BARTRDA,12)
 . S BARTRD1=0
 . F  S BARTRD1=$O(^BARTR(DUZ(2),BARTRDA,10,BARTRD1)) Q:'BARTRD1  D  Q:BARSTOP
 .. S BARCNT=BARCNT+1
 .. S X=^BARTR(DUZ(2),BARTRDA,10,BARTRD1,0)
 .. D ^DIWP
 .. S BARSTOP=0
 . D ^DIWW
 K ^UTILITY($J,"W")
 I 'BARCNT W *7,!!!,"No Messages on File!"
 Q:BARSTOP
 Q
 ; *********************************************************************
 ;
VIEW3 ;
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
TX ;
 W $$EN^BARVDF("IOF"),!
 D CENTER("Create NEW Message for "_BARM(BARY))
 W !!
 S DIR("A")="Create a NEW Message (Y/N): "
 S DIR("B")="YES"
 S DIR(0)="YOA"
 D ^DIR
 K DIR
 I Y=0!($D(DUOUT)) Q
 ; -------------------------------
 ;
T1 ;
 S X=$$NEW^BARTR
 Q:X<1
 S DA=X
 S DIE="^BARTR(DUZ(2),"
 S DR="12////^S X=DT"
 S DR=DR_";13////^S X=DUZ"
 S DR=DR_";7////^S X=1;QUIT;S Y=BARY"
 S DR=DR_";4////^S X=BARBIL;S Y=1001"
 S DR=DR_";5////^S X=BARPAT;S Y=1001"
 S DR=DR_";6////^S X=BARACC;1001"
 S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
CENTER(X)          ;
 W $$EN^BARVDF("IOF"),!
 W ?IOM-$L(X)\2,X,!
 W ?IOM-$L(X)\2 F J=1:1:$L(X) W "-"
 W !
 Q
 ; *********************************************************************
 ;
CHKLINE() ;
 ; Q 0 = CONTINUE
 ; Q 1 = STOP
 N X
 I ($Y+4)<IOSL Q 0
 W !?(IOM-15),"continued==>"
 D EOP^BARUTL(0)
 I 'Y Q 1
 D CENTER("Message Display for "_BARM(BARY)_" (continued)")
 W !!
 Q 0
