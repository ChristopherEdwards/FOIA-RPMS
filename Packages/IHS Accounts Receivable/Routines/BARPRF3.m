BARPRF3 ; IHS/SD/LSL - REFUND COMMAND PROCESSOR MAY 30,1996 ; 05/07/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,21,23***;OCT 26, 2005
 ;
 ; IHS/SD/SDR - 10/18/02 - V1.6 Patch 4 - OEA-1002-190010
 ;       Resolve <UNDEF>PARSE+6^XBDIQ1
 ;
 ; IHS/SD/LSL - 12/24/02 - V1.7 - XJG-12002-160021
 ;       Allow new adjustment categories 21 and 22
 ;
 ; *********************************************************************
 ;
 ;** 'Select Command' processor
 ;APR 2013 CONDITIONAL DISPLAY OF TXD AND MESSSAGES 
EN ;EP - refund poster
 K DIR,^TEMP($J,"BARPOST"),BARTR
 S (BARADJ,BARREF)=0
 S BARDFLT=""
 W !!
 ; -------------------------------
 ;
EN1 ;
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT,BARLIN,BARSPEC
 S BARDSP=1
 D HIT1^BARPNP2(BARPASS)
 ; -------------------------------
 ;
EN2 ;
 W !!
 K BARCOM,BARAMT
 D:$D(BARHLP)<10 SETHLP^BARPRFU
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
ASKCOM ;EP;
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT
 S BARDSP=1
 D HIT1^BARPNP2(BARPASS)
 W !
 ; -------------------------------
 ;
ASKCOM1 ;
 W !,"Select Command (Line # "_BARLIN_") : "
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 R BARCOM:DTIME
 S BARCOM=$$UPC^BARUTL(BARCOM)
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 I ("AR"[BARCOM) D  I $D(DIROUT)!$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!($G(Y)=0) G ASKCOM
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
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 S Q=0
 F J=1:1 D  Q:Q
 .S BARCOM(J)=$P(BARCOM,",",J)
 .Q:$L(BARCOM(J))
 .K BARCOM(J)
 .S J=J-1
 .S Q=1 Q
 I 'J!($L($G(BARCOM(1)))=0) G ASKCOM
 I '$D(BARHLP(BARCOM(1))) G COMHLP
 I J=1,BARCOM(J)="M" D  G ASKCOM
 .N DA,DIC,BARBLDA,BARACC
 .S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 .S BARACC=$$GET1^DIQ(90050.01,BARBLDA,3,"I")
 .D EN^BARPST6(BARPAT,BARBLDA,BARACC)
 .Q
 I J=1,BARCOM(J)="T" D  G ASKCOM
 .S Y=$$DSPLY^BARPNP4(BARLIN)
 .D EOP^BARUTL(1)
 I J=1,BARCOM(J)="H" D HISTORY^BARBAD3 G ASKCOM ;P.OTT
 ;. S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 ;. D EN^BARPST5(BARBLDA)
 ; -------------------------------
 ;
GOQ ;
 ;I J=1,BARCOM(J)="Q" G:BARCNT>1 EN1 G FINISH    ;BAR*1.8*4 DD 4.1.7.2
 I J=1,BARCOM(J)="Q" D  G:BARCNT>1 EN1 G FINISH  ;BAR*1.8*4 DD 4.1.7.2
 .D CKNEG^BARPST3(BARLIN)                        ;BAR*1.8*4 DD 4.1.7.2
 ;
 ;
GOA ;
 I J=1,BARCOM(J)="A" S BARTYP="A" G ASKAMT
 ;
GOD ;
 I J=1,BARCOM(J)="D" S DFN=BARPAT D VIEWR^XBLM("START^AGFACE") G ASKCOM
 ;
GOB ;
 I J=1,BARCOM(J)="B" D  G ASKCOM
 . S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 . D DIQ^XBLM(90050.01,BARBLDA)
 I J=1,BARCOM(J)="R" S BARTYP="R" G ASKAMT
 I J=1,BARCOM(J)="E" G ^BARPNP4
 W *7,"   Sorry.. ["_BARHLP(BARCOM(1))_"] not active!"
 G ASKCOM
 ; *********************************************************************
 ;
ASKAMT ;
 S (BARCAT,BARATYP)=""
 S BARASK=$S(BARTYP="R":"Refund ",BARTYP="A":"Adjustment ",1:"")_"Amount: "
 W !,BARASK R X:DTIME
 S X=$$AMT^BARPRFU(X)
 I X="^" G ASKCOM
 I X="?" W *7,"  Must be a valid number!" G ASKAMT
 S BARAMT=X
 I BARTYP="R" D  G RFTYPE
 .S BARCAT=19
 .S BARAMT=-BARAMT
 .Q
 ;
 ;** adjustment category/type dialog
 S DIC=90052.01
 S DIC(0)="AEMNQZ"
 S DIC("A")="Adjustment Category: "
 S:BARTYP="R" DIC("A")="Refund Category: "
 S DIC("S")="I Y=3!(Y=4)!(Y=13)!(Y=14)!(Y=15)!(Y=16)!(Y=20)!(Y=21)!(Y=22)"
 S:BARTYP="R" DIC("S")="I Y=19"
 K DD,DO
 D ^DIC
 K DIC
 I +Y<0 W *7 K BARAMT W !! G ASKAMT
 S BARCAT=+Y
 ; -------------------------------
 ;
RFTYPE ;
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
 ;--------------------------------
 ;
S1 ;
 D SETTMP^BARPRF3A(BARTYP,BARAMT,BARLIN,BARCAT,BARATYP)
 G ASKCOM
 ; *********************************************************************
 ;
COMHLP ;
 D COMHLP^BARPRFU
 G ASKCOM1
 ; *********************************************************************
 ;
FINISH ;
 I '$G(BARREF)&('$G(BARADJ)) D CANCEL Q
FIN S BARQ=$$POST()                            ;BAR*1.8*4 DD 4.1.7.2
 I BARQ="M" G EN1
 I BARQ="C" D CANCEL Q
 ;I BARQ="P" D POSTTX^BARPRFU,EN^BARROLL Q  ;BAR*1.8*4 DD 4.1.7.2
 I BARQ="P" D  I $G(BARSTOP)=1 G FIN        ;BAR*1.8*4 DD 4.1.7.2
 .K BARCOL D POSTTX^BARPSTU                 ;BAR*1.8*4 DD 4.1.7.2 
 D EN^BARROLL
 K ^BARTMP($J)                              ;BAR*1.8*4 DD 4.1.7.2
 Q
 ; -------------------------------
 ;
POST() ;
P1 ;
 D HIT1^BARPNP2(BARPASS)
 D EOP^BARUTL(2)
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
 K BARREF,BARADJ,BARTR
 Q
 ;***************************
