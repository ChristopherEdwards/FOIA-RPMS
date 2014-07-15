BARPUC3 ; IHS/SD/LSL - UNALLOCATED COMMAND PROCESSING ; 07/16/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,21,23***;OCT 26, 2005
 ;
 ; IHS/SD/SDR - 10/18/02 - V1.7 - OEA-1002-190010
 ;       Resolve <UNDEF>PARSE+6^XBDIQ1
 ;
 ; IHS/SD/LSL - 12/24/02 - V1.7 - XJG-1202-160021
 ;      Allow new adjustment categories 21 and 22
 ;
 ; *********************************************************************
 ; ;APR 2013 CONDITIONAL DISPLAY OF TXD AND MESSSAGES 
 ;** 'Select Command' processor
 ;
EN ;EP - command processor for unallocated
 K DIR,^TEMP($J,"BARPOST"),BARTR
 S (BARADJ,BARPMT)=0
 S BARDFLT=""
 W !!
 ; -------------------------------
 ;
EN1 ;
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT,BARLIN
 S BARDSP=1
 D HIT1^BARPUC2(BARPASS)
 ; -------------------------------
 ;
EN2 ;
 W !!
 K BARCOM,BARAMT
 D:$D(BARHLP)<10 SETHLP^BARPUCU
 ; -------------------------------
 ;
ASKLIN ;
 I BARCNT=1 S (BARLIN,BARDFLT)=1 G ASKCOM1
 D ASKLIN^BARFPST3
 I $G(BARLIN)["^" G FINISH
 I $G(BARLIN)=0 G FINISH
 I BARLIN>0,BARLIN<(BARCNT+1) G ASKCOM1
 ; -------------------------------
 ;
LNHLP ;
 ;
ASKCOM ;EP - ask command
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT
 S BARDSP=1
 D HIT1^BARPUC2(BARPASS)
 W !
 ; -------------------------------
 ;
ASKCOM1 ;
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 W !,"Select Command (Line # "_BARLIN_") : "
 R BARCOM:DTIME
 ;K DIR
 ;S DIR(0)="FAO"
 ;S DIR("A")="Select Command (Line # "_BARLIN_") "
 ;S DIR("T")=DTIME
 ;D ^DIR
 ;K DIR
 ;S BARCOM=$$UPC^BARUTL(X) 
 S BARCOM=$$UPC^BARUTL(BARCOM)
 S Q=0
 F J=1:1 D  Q:Q
 .S BARCOM(J)=$P(BARCOM,",",J)
 .Q:$L(BARCOM(J))
 .K BARCOM(J)
 .S J=J-1
 .S Q=1
 I 'J!($L($G(BARCOM(1)))=0) G ASKCOM
 I '$D(BARHLP(BARCOM(1))) G COMHLP
 I J=1,BARCOM(J)="M" D  G ASKCOM
 .N DA,DIC,BARBLDA,BARACC
 .S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 .S BARACC=$$GET1^DIQ(90050.01,BARBLDA,3,"I")
 .D EN^BARPST6(BARPAT,BARBLDA,BARACC)
 .Q
 I J=1,BARCOM(J)="T" D  G ASKCOM
 .S Y=$$DSPLY^BARPUC4(BARLIN)
 .D EOP^BARUTL(1)
 I J=1,BARCOM(J)="H" D HISTORY^BARBAD3 G ASKCOM ;P.OTT
 .;S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 .;D EN^BARPST5(BARBLDA)
 ; -------------------------------
 ;
GOQ ;
 I J=1,BARCOM(J)="Q" G:BARCNT>1 EN1 G FINISH
 ; -------------------------------
 ;
GOP ;
 I J=1,BARCOM(J)="P" S BARTYP="P" G ASKAMT
 I J=1,BARCOM(J)="1" S BARTYP="P" G ASKAMT
 ; -------------------------------
 ;
GOA ;
 I J=1,BARCOM(J)="A" S BARTYP="A" G ASKAMT
 I J=1,BARCOM(J)="2" S BARTYP="A" G ASKAMT
 ; -------------------------------
 ;
GOD ;
 I J=1,BARCOM(J)="D" D  G ASKCOM
 . S DFN=BARPAT
 . D VIEWR^XBLM("START^AGFACE")
 ; -------------------------------
 ;
GOB ;
 I J=1,BARCOM(J)="B" D  G ASKCOM
 . S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 . D DIQ^XBLM(90050.01,BARBLDA)
 I J=1,BARCOM(J)="E" G ^BARPUC4
 W *7,"   Sorry.. ["_BARHLP(BARCOM(1))_"] not active!"
 G ASKCOM
 ; *********************************************************************
 ;
ASKAMT ;
 S (BARCAT,BARATYP)=""
 S BARASK=$S(BARTYP="P":"Payment ",BARTYP="A":"Adjustment ",1:"")_"Amount: "
 S BARBAL=(BARTX(2)-$G(BARPMT))
 W !,BARASK
 I BARTYP="P" W $J(BARBAL,0,2)_"// "
 R X:DTIME
 I BARTYP="P",X="" S X=+BARBAL
 I BARTYP="P" S X=$$AMT^BARPUCU(X,0,BARBAL)
 I BARTYP="A" S X=$$AMT^BARPUCU(X)
 I X="^" G ASKCOM
 I X="?" W *7,"  Must be a valid number!" G ASKAMT
 S BARAMT=X
 I BARTYP="P" D  G S1
 .S BARCAT=$O(^BAR(90052.01,"B","PAYMENT TYPE",""))
 ;
 ;** adjustment category/type dialog
 S DIC=90052.01
 S DIC(0)="AEMNQZ"
 S DIC("A")="Adjustment Category: "
 S DIC("S")="I Y=3!(Y=4)!(Y=13)!(Y=14)!(Y=15)!(Y=16)!(Y=20)!(Y=21)!(Y=22)"
 K DD,DO
 D ^DIC
 K DIC
 I +Y<0 W *7 K BARAMT W !! G ASKAMT
 S BARCAT=+Y
 S:BARCAT=16 BARAMT=-BARAMT
 S BARX=0,BARJ=0
 K BARATYP
 F  S BARX=$O(^BARTBL("D",BARCAT,BARX)) Q:'BARX  D  Q:BARJ>1
 .S BARJ=BARJ+1
 .Q:BARJ>1
 .S BARATYP=BARX
 I BARJ=1,$G(BARATYP) G S1
 S DIC=90052.02
 S DIC(0)="AEMNQZ"
 S DIC("A")="Adjustment Type: "
 S DIC("S")="I $P(^(0),U,2)=BARCAT"
 K DD,DO
 D ^DIC
 K DIC
 I +Y<0 K BARAMT W *7,!! G ASKAMT
 S BARATYP=+Y
 ; -------------------------------
 ;
S1 ;
 D SETTMP^BARPUC3A(BARTYP,BARAMT,BARLIN,BARCAT,BARATYP)
 G ASKCOM
 ; *********************************************************************
 ;
COMHLP ;
 D COMHLP^BARPUCU
 G ASKCOM1
 ; *********************************************************************
 ;
FINISH ;
 I '$G(BARPMT)&('$G(BARADJ)) D CANCEL Q
FIN S BARQ=$$POST()               ;BAR*1.8*4 DD 4.1.7.2               
 I BARQ="M" G EN1
 I BARQ="C" D CANCEL Q
 ;I BARQ="P" D  Q              ;REWRITTEN ;BAR*1.8*4 DD 4.1.7.2
 ;. D POSTTX^BARPUCU
 ;. D EN^BARROLL
 I BARQ="P" D POSTTX^BARPUCU   ;BAR*1.8*4 DD 4.1.7.2
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 I $G(BARSTOP)=1 G FIN
 D EN^BARROLL
 K ^BARTMP($J)
 Q
 ; -------------------------------
 ;
POST() ;
P1 ;
 D HIT1^BARPUC2(BARPASS)
 D EOP^BARUTL(2)
 ; -------------------------------
 ;
PDIR ;
 K DIR
 S DIR(0)="SAO^P:POST TO A/R;M:MORE;C:CANCEL"
 S DIR("A")="Select Action (P/M/C): "
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="") W *7 G PDIR
 Q Y
 ; *********************************************************************
 ;
CANCEL ;
 K ^BARTMP($J)
 K BARPMT,BARADJ,BARTR
 Q
