BARBAD3 ; IHS/SD/LSL - PAYMENT COMMAND PROCESSOR ; 12/29/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,6,7,10,19,21**;OCT 26, 2005
 ;** 'Select Command' processor
 ; ********************************************************************
 ;
EN ;EP - command processor
 K DIR,^TEMP($J,"BARPOST"),BARTR
 S (BARADJ,BARPMT)=0
 S BARDFLT=""
 W !!
 ; -------------------------------
EN1 ;
 ;K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT,BARLIN
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT,BARLIN,REVERSAL,REVSCHED  ;BAR*1.8*4
 S BARDSP=1
 D HIT1^BARBAD2(BARPASS)
 ; -------------------------------
EN2 ;
 W !!
 K BARCOM,BARAMT
 D:$D(BARHLP)<10 SETHLP^BARBADU
 ; -------------------------------
ASKLIN ;
 I $D(BARCOM(1)) D
 . Q:BARCOM(1)="Q"
 I BARCNT=1 S (BARLIN,BARDFLT)=1 G ASKCOM1
 D ASKLIN^BARFPST3
 I $G(BARLIN)["^" G FINISH
 I $G(BARLIN)=0 G FINISH
 I BARLIN>0,BARLIN<(BARCNT+1) G ASKCOM1
 ;
LNHLP ;
ASKCOM ;EP - select command
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT
 S BARDSP=1
 D HIT1^BARBAD2(BARPASS)
 W !
 ; -------------------------------
ASKCOM1 ;
 N BARCAM,BARCOAM
 K REVERSAL,REVSCHED
 W !,"Select Command (Line # "_BARLIN_") : "
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 R BARCOM:DTIME
 S BARCOM=$$UPC^BARUTL(BARCOM)
 S:'$D(BARCOM) BARCOM="Q"
 I $D(BARTR(BARLIN,1))&(($G(BARCOM)="S")!($G(BARCOM)="V")!($G(BARCOM)="1")!($G(BARCOM)="2")) D
 . W !,"A transaction already exists on this bill.  You can cancel it."
 . W !,"You can also edit the amount or adjustment type."
 . D EOP^BARUTL(1)
 . ;S BARCOM="Q"
 . G ASKCOM1
 I ("S1V2"[BARCOM) D  I $D(DIROUT)!$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!($G(Y)=0) G ASKCOM
 .S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 .S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARBLDA)
 .K DIROUT,DIRUT,DTOUT,DUOUT
 .K DIR,DIE,DIC,X,Y,DA,DR
 .Q:$G(BARTPB)=""
 .S BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 .Q:BARSTAT'="X"
 .W !!,"STOP!  3P BILL ",$P($P($G(^BARBL(DUZ(2),BARBLDA,0)),U),"-")," has been cancelled."
 .S DIR(0)="Y"
 .S DIR("A")="Are you sure you want to post to this invoice"
 .S DIR("B")="N"
 .D ^DIR K DIR
 S Q=0
 F J=1:1 D  Q:Q
 .S BARCOM(J)=$P(BARCOM,",",J)
 .Q:$L(BARCOM(J))
 .K BARCOM(J)
 .S J=J-1
 .S Q=1 Q
 I 'J!($L($G(BARCOM(1)))=0) G ASKCOM
 I BARCOM(1)="1" S BARCOM(1)="S" W *7,*7,*7
 I BARCOM(1)="2" S BARCOM(1)="V" W *7,*7,*7
 I BARCOM(1)="3" S BARCOM(1)="Q" W *7,*7,*7
 I BARCOM(1)="4" S BARCOM(1)="H" W *7,*7,*7
 I BARCOM(1)="5" S BARCOM(1)="M" W *7,*7,*7
 I BARCOM(1)="6" S BARCOM(1)="T" W *7,*7,*7
 I BARCOM(1)="7" S BARCOM(1)="B" W *7,*7,*7
 I BARCOM(1)="8" S BARCOM(1)="E" W *7,*7,*7
 G:'("SVBHMTQE"[BARCOM(1)) COMHLP
 I "SV"[BARCOM(1) D
 . S BARCAM=0,BARCOAM=0
 . S BARCAM=$$GET1^DIQ(90050.01,BARBLDA,15)
 . S BARCOAM=$O(^BARBL(DUZ(2),BARBLDA,9,"AAA"),-1)
 . S:$G(BARCOAM) BARCOAM=$P(^BARBL(DUZ(2),BARBLDA,9,BARCOAM,0),U,4)
 . S:'$G(BARCOAM) BARCOAM=0
 I ($G(BARCOM(1))="S")&($G(BARCAM)'>0) D
 . W !,"The current balance on this bill 0.  There is nothing to put into collections."
 . D EOP^BARUTL(1)
 . S BARCOM(1)="Q"
 I ($G(BARCOM(1))="V")&($G(BARCOAM)'>0) D
 . W !,"There isn't an amount in collections to take out of collections."
 . D EOP^BARUTL(1)
 . S BARCOM(1)="Q"
 I J=1,BARCOM(1)="T" D  G ASKCOM
 .S Y=$$DSPLY^BARBAD4(BARLIN)
 .D EOP^BARUTL(1)
 I J=1,BARCOM(1)="M" D  G ASKCOM
 .N DA,DIC,BARBLDA,BARACC
 .S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 .S BARACC=$$GET1^DIQ(90050.01,BARBLDA,3,"I")
 .D EN^BARBAD6(BARPAT,BARBLDA,BARACC)
 .Q
 I J=1,BARCOM(1)="H" D  G ASKCOM
 .S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 .D EN^BARBAD5(BARBLDA)
 G:"SV"[BARCOM(1) GOSR
 ; -------------------------------
GOQ  ;
 I J=1,BARCOM(J)="Q" D  G:BARCNT>1 EN1 G FINISH
 .D CKNEG(BARLIN)
GOSR ;
 I (J=1)&((BARCOM(J)="S")!(BARCOM(J)="V")) S BARTYP="A" G ASKAMT
 I J=1,BARCOM(J)="E" G ^BARBAD4
GOB ;
 I (J=1)&(BARCOM(1)="B") D  G ASKCOM
 . S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 . D DIQ^XBLM(90050.01,BARBLDA)
 W *7,!,"   Sorry.. ["_BARHLP(BARCOM(1))_"] not active!"
 D EOP^BARUTL(1)
 G ASKCOM
 ; *********************************************************************
COMHLP ;
 D COMHLP^BARBADU
 G ASKCOM1
 ; *********************************************************************
CKNEG(LIN) ;EP; CHECK FOR NEGATIVE BALANCE  ;BAR*1.8*4 DD 4.1.7.2
 Q:'$$IHS^BARUFUT(DUZ(2))              ;IGNORE NON-IHS
 N BARDA,BARB
REDO S BARDA=$O(^BARTMP($J,"B",LIN,""))
 S BARB=$P(^BARTMP($J,BARDA,LIN),U,5)
 Q
FINISH ;
 I '$G(BARPMT)&('$G(BARADJ))&('$D(BARROLL))&'$D(BARTR) D CANCEL Q
 ; enable posting rollback
FIN ;
 S BARQ=$$POST()
 I BARQ="M" G EN1
 I BARQ="C" D CANCEL Q
 I BARQ="P" D POSTTX^BARBADU
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 I $G(BARSTOP)=1 G FIN
 K ^BARTMP($J)
 Q
 ;--------------------------------
ASKAMT ;
 S (BARCAT,BARATYP)=""
 W:BARCOM(1)="S" !,"Amount is added to Sent to Collections amount and deducted from Current Balance."
 W:BARCOM(1)="V" !,"Amount is added to Current Balance and deducted from Sent to Collections amount."
 S BARASK=$S(BARCOM(1)="S":"STATUS ",BARCOM(1)="V":"REVERSE STATUS ",1:"")_"Amount: "
 W !,BARASK R X:DTIME
 S X=$$AMT^BARPSTU(X)
 I X="^" G ASKCOM
 I X="?" W *7,"  Must be a valid number!" G ASKAMT
 S BARAMT=X
 I (BARAMT'>0) D  G:BARAMT'>0 ASKAMT
 . W !,"You must enter a value larger than 0."
 . D EOP^BARUTL(1)
 . Q
 I ($G(BARCOM(1))="S")&(BARAMT>BARCAM) D  G:($G(BARCOM(1))="S")&(BARAMT>BARCAM) ASKAMT
 . W !,"You can't place more than the current bill amount in collections."
 . D EOP^BARUTL(1)
 . Q
 I ($G(BARCOM(1))="V")&(BARAMT>BARCOAM) D  G:($G(BARCOM(1))="V")&(BARAMT>BARCOAM) ASKAMT
 . W !,"You can't reverse from collections more than what's in there."
 . D EOP^BARUTL(1)
 . Q
 S BARCAT=$O(^BAR(90052.01,"B","SENT TO COLLECTIONS",""))
 ;
 ;** adjustment category/type dialog
 S BARX=0,BARJ=0
 K BARATYP
 F  S BARX=$O(^BARTBL("D",BARCAT,BARX)) Q:'BARX  D  Q:BARJ>1
 .S BARJ=BARJ+1
 .Q:BARJ>1
 .S BARATYP=BARX
 S DIC=90052.02
 S DIC(0)="AEMNQZ"
 S DIC("A")="Select Adjustment Type: "
 S DIC("S")="I $P(^(0),U,2)=BARCAT"
 K DD,DO
 D ^DIC
 K DIC
 I +Y<0 K BARAMT W *7,!! G ASKAMT
 S BARATYP=+Y
 ;--------------------------------
S1 ;
 D SETTMP^BARBAD3A(BARTYP,BARAMT,BARLIN,BARCAT,BARATYP,0,BARCOM(1))
 G ASKCOM
CANCEL ;
 K ^BARTMP($J)
 K BARPMT,BARADJ,BARTR,BARROLL
 Q
 ;
POST() ;
P1 ;
 D HIT1^BARBAD2(BARPASS)
 D EOP^BARUTL(2)
PDIR ;
 ;ENTER CODE TO SHOW USER WHAT IS ABOUT TO HAPPEN
 K DIR
 S DIR(0)="SAO^P:POST TO A/R;M:MORE;C:CANCEL"
 S DIR("A")="Select Action (P/M/C): "
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="") W *7 G PDIR
 Q Y
