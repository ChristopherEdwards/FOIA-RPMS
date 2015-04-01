BARPNP3 ; IHS/SD/LSL - POSTING SELECT COMMAND PROCESSOR ; 05/07/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,21,24**;OCT 26, 2005;Build 69
 ;** 'Select Command' processor
 ;
 ; IHS/SD/LSL - 09/23/02 - V1.6 Patch 3 - HIPAA
 ;     Allow user to select new Adjustment Categories PENDING
 ;     or GENERAL INFORMATION
 ;
 ; IHS/SD/SDR - 10/18/02 - V1.7 - OEA-1002-190010
 ;      Resolve <UNDEF> PARSE+6^XBDIQ1
 ;
 ; IHS/SD/LS - 10/17/03 - V1.7 Patch 4
 ;      Allow rollover even if previously rolled.
 ;
 ; IHS/SD/POT - NOHEAT 03/31/14 - BAR*1.8*24 LIMIT INPUT LENGTH
 ; ********************************************************************
 ;
EN ;EP - posting command handler
 K DIR,BARTR
 K ^TEMP($J,"BARPOST")
 S (BARADJ,BARPMT)=0
 S BARDFLT=""
 W !!
 ; -------------------------------
 ;
EN1 ;
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT,BARLIN
 S BARDSP=1
 D HIT1^BARPNP2(BARPASS)
 ; -------------------------------
 ;
EN2 ;
 W !!
 K BARCOM,BARAMT
 D:$D(BARHLP)<10 SETHLP^BARPNPU
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
ASKCOM ;EP - select command
 K BARCOM,BARTYP,BARCAT,BARATYP,BARAMT
 S BARDSP=1
 D HIT1^BARPNP2(BARPASS)
 W !
 ; -------------------------------
 ;
ASKCOM1 ;
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 W !,"Select Command (Line # "_BARLIN_") : "
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 R BARCOM:DTIME
 S BARCOM=$E(BARCOM,1,10) ;BAR*1.8*24
 S BARCOM=$$UPC^BARUTL(BARCOM)
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 I ("P1A2"[BARCOM) D  I $D(DIROUT)!$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!($G(Y)=0) G ASKCOM
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
 I BARCOM(1)=2 S BARCOM(1)="A" W *7,*7,*7
 I BARCOM(1)=3 S BARCOM(1)="Q" W *7,*7,*7
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
 I J=1,BARCOM(J)="H" D HISTORY^BARBAD3 G ASKCOM
 I J=1,BARCOM(J)="R" D ROLL G ASKCOM
 ;
 ;enable posting rollback
GOQ ;
 ;I J=1,BARCOM(J)="Q" G:BARCNT>1 EN1 G FINISH    ;BAR*1.8*4 DD 4.1.7.2
 I J=1,BARCOM(J)="Q" D  G:BARCNT>1 EN1 G FINISH  ;BAR*1.8*4 DD 4.1.7.2
 .D CKNEG^BARPST3(BARLIN)                        ;BAR*1.8*4 DD 4.1.7.2
 ;
GOA ;
 I J=1,BARCOM(J)="A" S BARTYP="A" G ASKAMT
 I J=1,BARCOM(J)="2" S BARTYP="A" G ASKAMT
 I J=1,BARCOM(J)="E" G ^BARPNP4
 ;
GOD ;
 I J=1,BARCOM(J)="D" D  G ASKCOM
 . S DFN=BARPAT
 . D VIEWR^XBLM("START^AGFACE")
 ;
GOB ;
 I J=1,BARCOM(J)="B" D  G ASKCOM
 . S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 . D DIQ^XBLM(90050.01,BARBLDA)
 W *7,!,"   Sorry.. ["_BARHLP(BARCOM(1))_"] not active!"
 D EOP^BARUTL(1)
 G ASKCOM
 ; *********************************************************************
 ;
ASKAMT ;
 S (BARCAT,BARATYP)=""
 S BARASK=$S(BARTYP="P":"Payment ",BARTYP="A":"Adjustment ",1:"")_"Amount: "
 W !,BARASK R X:DTIME
 S X=$$AMT^BARPNPU(X)
 I X="^" G ASKCOM
 I X="?" W *7,"  Must be a valid number!" G ASKAMT
 S BARAMT=X
 I BARTYP="P" D  G S1
 . S BARCAT=$O(^BAR(90052.01,"B","PAYMENT TYPE",""))
 . Q
 ;
 ;** adjustment category/type dialog
 S DIC=90052.01
 S DIC(0)="AEMNQZ"
 S DIC("A")="Adjustment Category: "
 S DIC("S")="I "",3,4,13,14,15,16,20,21,22,""[("",""_Y_"","")"
 D ^DIC
 K DIC
 I +Y<0 W *7 K BARAMT W !! G ASKAMT
 S BARCAT=+Y
 S:BARCAT=16 BARAMT=-BARAMT ;grouper
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
 D ^DIC
 K DIC
 I +Y<0 K BARAMT W *7,!! G ASKAMT
 S BARATYP=+Y
 ; -------------------------------
 ;
S1 ;
 ;D SETTMP^BARPST3A(BARTYP,BARAMT,BARLIN,BARCAT,BARATYP)  ;BAR*1.8*4 DD 4.1.7.2
 D SETTMP^BARPST3A(BARTYP,BARAMT,BARLIN,BARCAT,BARATYP,0)  ;BAR*1.8*4 DD 4.1.7.2
 G ASKCOM
 ; *********************************************************************
 ;
COMHLP ;
 D COMHLP^BARPNPU
 G ASKCOM1
 ; *********************************************************************
 ;
FINISH ;
 I '$G(BARPMT)&('$G(BARADJ))&'$D(BARROLL)&'$D(BARTR) D CANCEL Q
 ; enable posting rollback
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) D CANCEL Q  ;IS SESSION STILL OPEN
FIN S BARQ=$$POST()                            ;BAR*1.8*4 DD 4.1.7.2
 I BARQ="M" G EN1
 I BARQ="C" D CANCEL Q
 ;I BARQ="P" D POSTTX^BARPNPU,EN^BARROLL Q  ;BAR*1.8*4 DD 4.1.7.2
 I BARQ="P" K BARCOL D POSTTX^BARPSTU       ;BAR*1.8*4 DD 4.1.7.2 
 I $G(BARSTOP)=1 G FIN                      ;BAR*1.8*4 DD 4.1.7.2
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
PDIR K DIR
 S DIR(0)="SAO^P:POST TO A/R;M:MORE;C:CANCEL"
 S DIR("A")="Select Action (P/M/C): "
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="") W *7 G PDIR
 Q Y
 ; *********************************************************************
 ;
ROLL ;EP - tag a bill for rollback to 3P
 ; enable posting rollback
 N BARBLDA
 S BARBLDA=$O(^BARTMP($J,"B",BARLIN,""))
 S BARROLL(BARBLDA)=""
 K DIC,DIE
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBLDA
 S DR="214///@"
 D ^DIE
 K DIC,DIE,X,Y,DR
 K DIR
 S DIR("A")="TAGGED for Rolling. Enter RETURN to Continue."
 D EOP^BARUTL(0)
ROLLE ;
 Q
 ; *********************************************************************
 ;
CANCEL ;
 K ^BARTMP($J)
 K BARPMT,BARADJ,BARTR
 Q
