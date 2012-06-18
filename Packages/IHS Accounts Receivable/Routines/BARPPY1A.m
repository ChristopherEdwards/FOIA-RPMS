BARPPY1A ; IHS/SD/TMM - PREPAYMENT ENTRY - CONT'D ; 05/11/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/TMM 06/18/10 1.8*19 Add Prepayment functionality.
 ; *********************************************************************
 ;	
NEW() ;EP - extrensic call to establish a new prepayment record
 ; returns 0-lock on file, fm-dt/sec -IEN ; -1 not added
 F I=1:1:5 L +^BARPPAY(DUZ(2)):2 S X=$T Q:X
 I 'X D  Q X
 . W *7,!!,"A/R PREPAYMENT FILE LOCKED, try again",!!
 ;---- Create Pre-Payment record
 K DIC,DR,DA
 S DIC="^BARPPAY(DUZ(2),"
 S DIC(0)="E"
 K DD,DO
 D FILE^DICN
 K DR,DA,DIE
 L -^BARPPAY(DUZ(2))
 Q +Y
 ;
PAD(BARVAR,BARLNG) ; EP
 ; BARVAR = data
 ; BARLNG = length
 ; Right justify, zero fill value BARVAR for length BARLNG
 K BARZERO
 S $P(BARZERO,"0",BARLNG+1)=""
 S BARVAR=BARZERO_BARVAR
 S BARVAR=$E(BARVAR,$L(BARVAR)-(BARLNG-1),$L(BARVAR))
 Q BARVAR
 ;
CARDTYPE(CARD) ;  
 S CARDTYPE=$S(CARD="A":"AMERICAN EXPRESS",CARD="C":"DINERS CLUB",CARD="D":"DISCOVER",CARD="M":"MASTERCARD",CARD="V":"VISA",1:"")
 Q CARDTYPE
 ;
PAYTYPE(PMTYP) ;
 S PAYTYPE=$S(PMTYP="CA":"CASH",PMTYP="CK":"CHECK",PMTYP="CC":"CREDIT CARD",PMTYP="DB":"DEBIT CARD",1:"")
 Q PAYTYPE
 ;
CKOUT() ;  Check DIR values
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$G(BARSTOP) Q 1
 Q 0
 ;
 ; *********************************************************************
HINPTON ;   Hilight when PT NAME field
 I $G(BARPAT)'="",BARPAT'=BARPTI1 D
 . W $$EN^BARVDF("HIN")
 . S HINPTON=1
 Q
 ;
HINPTOFF ;   Turn off Hilight when PT NAME field
 W $$EN^BARVDF("HIF")
 S HINPTON=0
 Q
 ;
HINBLON ;  Hilight DOS fields
 I BARDOSB'="",BARDOSB'=BARPDOS D
 . W $$EN^BARVDF("HIN")
 . S HINBLON=1
 Q
 ;
HINBLOFF ;  Turn off hilight for DOS fields
 W "**",$$EN^BARVDF("HIF")
 S HINBLON=0
 Q
 ;
RECAP ;  Display data for user to review and select next step
 Q:BARSTOP
 W $$EN^BARVDF("IOF"),!        ;Form Feed/Clear screen
 W $$EN^BARVDF("CLR")          ;Clear screen
 S Y=BARPDOS
 D D^DIQ       ;get external date
 D HINBLON
 W !,"1)",?4,"PAYMENT FOR DOS:",?22,Y
 I HINBLON D HINBLOFF
 W !,"2)",?4,"CREDIT: ",?22,"$",$FN(BARAMT,",",2)
 W !!,"3)",?4,"DEPARTMENT:",?22,BARDEPTE
 I BARPMTYP="CA" S BARTMP="CASH^^"
 I BARPMTYP="CK" S BARTMP="CHECK^CHECK NUMBER:^NAME ON CK ACCOUNT:"
 I BARPMTYP="CC" S BARTMP="CREDIT CARD^CARD TYPE:^NAME ON CARD:"
 I BARPMTYP="DB" S BARTMP="DEBIT CARD^CARD TYPE:^NAME ON CARD:"
 W !!,"4)",?4,"PAYMENT TYPE:",?22,$P(BARTMP,U)  ;PAYMENT TYPE line 1
 S BARTMP1=$S(BARPMTYP="CK":BARCK,BARPMTYP="CC":BARCTYPN,BARPMTYP="DB":BARCTYPN,1:"")
 I $P(BARTMP,U)'="CASH" D
 . W !,?4,$P(BARTMP,U,2),?22,BARTMP1  ;PAYMENT TYPE line 2
 . S BARTMP1=$S("^CK^CC^DB^"[BARPMTYP:BARCNAME,1:"")
 . W !,?4,$P(BARTMP,U,3),?22,BARTMP1  ;PAYMENT TYPE line 3
 W !!,"5)",?4,"A/R BILL NUMBER:",?22,$$GET1^DIQ(90050.01,BARBLIEN_",",.01,"E")
 I BARBLIEN'="" D HINPTON      ;hilight patient name when applicable
 W !,?4,"PATIENT NAME:",?22,$S(+BARPAT:$P(^DPT(BARPAT,0),U),1:"")
 I HINPTON D HINPTOFF     ;hilight patient name when applicable
 I BARBLIEN'="" D HINBLON
 S Y=$G(BARDOSB)
 D D^DIQ       ;converts internal FM date to external
 W !,?4,"BILL DOS:",?22,Y
 I HINBLON D HINBLOFF
 D HINPTON
 W !!,"6)",?4,"PATIENT:",?22,BARPTNM1
 I HINPTON D HINPTOFF
CMT  ;Comments
 K BARCMT  ; comments array
 S BARCMT=$L(BARCMTS)
 N SP,W,L,WORD S SP=" ",L=1  ;SP-space; W- WordCtr; L-LINE#
 S BARCMT(1)=""
 F W=1:1 S WORD=$P(BARCMTS,SP,W) Q:WORD=""  D
 . I W>1 S WORD=SP_WORD  ; space betw words
 . I ($L(BARCMT(L))+$L(WORD))'>70 S BARCMT(L)=BARCMT(L)_WORD
 . E  S L=L+1,BARCMT(L)=$E(WORD,2,99)  ; remove leading space
 I BARCMT(1)="" K BARCMT
 W !!,"7)",?4,"COMMENTS:"
 F I=1:1:4 S BARCMT=$O(BARCMT(I)) Q:$G(BARCMT(I))=""  D
 . S BARCMT(5)=BARCMT(I)
 . I BARCMT(I)=1 W "  "
 . E  I $E(BARCMT(5),$L(BARCMT(5)))'=" "&($E(BARCMT(I))'=" ") W " "
 . W BARCMT(I)
 K BARCMT(5)
 ;
FMQ ;  Prompt F/M/Q
 I $G(BARDOSB)'="",BARDOSB'=BARPDOS W !!,?4,$$EN^BARVDF("HIN"),BARNOTE1,$$EN^BARVDF("HIF")
 I $G(BARPAT)'="",BARPAT'=BARPTI1  W $$EN^BARVDF("HIN"),!!,?4,BARNOTE2,$$EN^BARVDF("HIF")
 S BARFILE=""
 W !!
 D RESETDIR^BARPPY01
 S DIR(0)="SA^F:FILE;M:MODIFY;Q:QUIT"
 S DIR("A")="FILE PREPAYMENT?   SELECT (F)ILE, (M)ODIFY, (Q)UIT:  "
 K DA
 D ^DIR
 I $D(DUOUT)!$D(DIROUT) G FMQ
 I $D(DTOUT) Q
 S BARFILE=X
 ;
 ; ---FILE---
 I "Ff"[BARFILE D
 . S BARTMPF="OK"   ;OK to file (No A/R Bill Selected, or A/R Bill selected and matches item 6 PATIENT)
 . I +$G(BARPTI1)=0,(+$G(BARBLIEN)=0) S BARTMPF="NOB"  ;bar*1.8*19 SDR
 . I $G(BARPAT)'="",BARPAT'=BARPTI1 S BARTMPF="NOK"  ;A/R Bill selected and does not match item 6 PATIENT)
 ;start new code bar*1.8*19 SDR
 I "Ff"[BARFILE,($G(BARTMPF)="NOB") D  G RECAP
 .W !!,"A PATIENT or a BILL NUMBER is required!" H 1
 ;end new SDR
 I "Ff"[BARFILE,BARTMPF="NOK" D
 . W !!
 . S DIR("A",1)="Patient in Item 5 does not match Patient in Item 6"
 . S DIR("A",2)="Do you still want to file this data?"
 . S DIR("A",3)="   Enter 'YES' to File data"
 . S DIR("A",4)="   Enter 'NO' to Modify data"
 . S DIR("A",5)=" "
 . S DIR("A")= "Enter YES/NO:   "
 . S DIR("B")="NO"
 . S DIR(0)="YA"
 . D ^DIR
 . I Y=1 S BARTMPF="OK" Q
 I "Ff"[BARFILE,BARTMPF="OK" Q
 I "Ff"[BARFILE,BARTMPF="NOK" G RECAP
 I "Qq"[BARFILE,Y=1 S BARQUIT=1 Q
 I "Qq"[BARFILE,Y=0 G FMQ
 ;
 I "Qq"[BARFILE D
 . W !!
 . S DIR("A",1)="Are you sure you want to quit?"
 . S DIR("A",2)="The data you have entered will not be saved."
 . S DIR("A")="Proceed with quit?  YES/NO   "
 . S DIR("B")="NO"
 . S DIR(0)="YA"
 . D ^DIR
 I "Qq"[BARFILE,Y=1 S BARQUIT=1 Q   ;M819*ADD*TMM*20100826
 I "Qq"[BARFILE,Y=0 G FMQ
 S BARDONE=0
 F I=1:1 D  Q:BARDONE
 . S BARUPDT=1
 . D UPDT
 . S BARUPDT=0
 Q
 ;
FILE ;File prepayment
 ; Get new IEN for ^BARPPAY
 S BARPPIEN=$$NEW^BARPPY1A()
FDATA ;  Add Pre-Payment data
 K DIE,DR,DA
 ; Receipt #
 I '$D(BARPSAT(DUZ(2),2)) D BARPSAT^BARUTL0
 S BARSUFX=$G(BARPSAT(DUZ(2),2))
 S BARCPT=BARSUFX_$$PAD^BARPPY1A(BARPPIEN,10)
 S DR=".01////^S X=BARCPT"
 ; Other data
 D NOW^%DTC
 S BARPDOSE=$P(%,".")
 S DR=DR_";.02////^S X=BARPDOSE"      ;PAYMENT DATE
 S DR=DR_";.03////^S X=BARPMTYP"      ;PAYMENT TYPE 
 S DR=DR_";.04////^S X=$G(BARCK)"      ;CHECK #
 S DR=DR_";.05////^S X=$G(BARCNAME)"      ;BANK ACCOUNT OWNER NAME
 S DR=DR_";.06////^S X=$G(BARCTYPE)"      ;CARD TYPE
 S DR=DR_";.07////^S X=$G(BARAMT)"      ;CREDIT
 S DR=DR_";.08////^S X=$G(BARPTI1)"      ;PATIENT (IEN) (selected patient, not A/R BILL patient)
 S DR=DR_";.09////^S X=$G(BARBLIEN)"      ;A/R BILL
 S DR=DR_";.1////^S X=DUZ"      ;ENTERED BY
 S DR=DR_";.11////^S X=BARDEPTI"      ;DEPARTMENT
 S DR=DR_";.12////^S X=$G(BARDOSB)"      ;BILL DOS
 S DR=DR_";.13////^S X=BARPDOS"      ;PAYMENT FOR DOS
 S DR=DR_";.18////^S X=""N"""      ;BATCH FLAG
 ; Add to Pre-Payment file
 S DA=BARPPIEN
 S DIE=$$DIC^XBDIQ1(90050.06)
 D ^DIE
CMTFILE ;EP
 S BARIENS=BARPPIEN_","
 D WP^DIE(90050.06,BARIENS,101,"","BARCMT","MSG")
  D WP^DIE(90050.06,BARIENS,.2,"","BARCMT","MSG")
 W !!!,?9,"RECEIPT #:",?22,BARCPT
 Q
 ;
UPDT ;   Allow user to modify data entered
 Q:BARSTOP
 S (BARITEM,BARLIST)=""
 W !!
 D RESETDIR^BARPPY01
 S BARLIST="SAO^1:PAYMENT FOR DOS;2:CREDIT;3:DEPARTMENT"
 S BARLIST=BARLIST_";4:PAYMENT TYPE INFO"
 S BARLIST=BARLIST_";5:A/R BILL INFO"
 S BARLIST=BARLIST_";6:PATIENT"
 S BARLIST=BARLIST_";7:COMMENTS"
 S DIR(0)=BARLIST
 S DIR("A")="SELECT ITEM TO MODIFY: (?? for list) "
 K DA
 D ^DIR
 I $D(DIROUT) S BARSTOP=1 Q
 I $D(DTOUT)!$D(DUOUT) S BARDONE=1 Q
 K DIRUT
 S BARITEM=X
 I BARITEM=1 F I=1:1 D  Q:(+BARPDOS)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(BARSTOP)
 . ; Get DOS for this payment
 . S BARPDOS=""
 . D PAYDOS1^BARPPY01
 . I $D(DIROUT) S BARSTOP=1
 I BARITEM=2 F I=1:1 D  Q:(+BARAMT>0)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(BARSTOP)
 . ; Enter Credit amount
 . D AMOUNT1^BARPPY01
 . I $D(DIROUT) S BARSTOP=1
 I BARITEM=3 F I=1:1 D  Q:(BARDEPTI'="")!$D(DTOUT)!($D(DUOUT))!$D(DIROUT)!(BARSTOP)
 . D SELDEPT^BARPPY01
 . I $D(DIROUT) S BARSTOP=1
 I BARITEM=4 F I=1:1 D  Q:($G(BARDAT))!$D(DTOUT)!($D(DUOUT))!$D(DIROUT)!(BARSTOP)
 . S BARDAT=0       ;required data collected flag
 . D SELPMT^BARPPY01
 . I $D(DIROUT) S BARSTOP=1
 I BARITEM=5 F I=1:1 D  Q:($D(BARFPASS))!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(BARSTOP)
 . ; Get A/R Bill, Patient, A/R Bill DOS
 . K BARFPASS
 . D ARBILL1^BARPPY01
 . I $D(DIROUT) S BARSTOP=1
 I BARITEM=6 F I=1:1 D  Q:($D(BARPTNM1))!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(BARSTOP)
 . ; Get Patient Name
 . D GETPAT1^BARPPY01
 . I $D(DIROUT) S BARSTOP=1
 I BARITEM=7 D CMTS^BARPPY01
 D RECAP
 S BARDONE=1
 Q
