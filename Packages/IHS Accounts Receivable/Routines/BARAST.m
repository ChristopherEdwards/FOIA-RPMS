BARAST ; IHS/SD/LSL - ACCOUNT STATEMENT ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 W !
 I '$D(^BAR(90052.03,"B","ACCOUNT STATEMENT HEADER")) D ALTR
 I '$D(^BARAC(DUZ(2),"AC")) D  Q
 .W !!,"Accounts must be flagged first. Use the 'Flag Accounts option"
 .W !,"to identifiy accounts to print statements for.",!
 S ZTRTN="LOOP^BARAST"
 ; -------------------------------
 ;
DEV ;
 ; ask for printer device
 S %ZIS="NQ"
 S %ZIS("A")="Print Statements to Device: "
 D ^%ZIS
 Q:POP
 I IO'=IO(0) D  Q
 .S ZTDESC="PRINT A/R ACCOUNT STATEMENTS"
 .K ZTSK
 .D ^%ZTLOAD
 .Q:'$G(ZTSK)
 .W !,"Task # ",ZTSK," queued.",!
 I $D(IO("S")) D
 . S IOP=ION
 . D ^%ZIS
 Q:$G(BARFL1)
 ; -------------------------------
 ;
LOOP ;EP
 ; loop though ac x-ref
 S BAREDT=$$FMADD^XLFDT(DT,-1)
 S BARBDT=$$FMADD^XLFDT(DT,-31)
 S BARLDT=0
 F  S BARLDT=$O(^BARAC(DUZ(2),"AC",BARLDT)) Q:'BARLDT!(BARLDT>BARBDT)  D
 .S BARAC=0
 .F  S BARAC=$O(^BARAC(DUZ(2),"AC",BARLDT,BARAC)) Q:'BARAC  D
 ..D ONE
 ..D FDT
 ; -------------------------------
 ;
KILL ;
 ; clean up
 K BARAC,BARLDT,BAREDT,BARC,BARFL1
 D:$D(IO("S")) ^%ZISC
 Q
 ; *********************************************************************
 ;
RPR ; EP
 ; re-print one statement
 W !
 K DIC
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AEMQ"
 D ^DIC
 Q:+Y<0
 S DA(1)=+Y
 S BARAC=+Y
 S DIC="^BARAC(DUZ(2),DA(1),12,"
 S DIC("S")="I '$P(^(0),""^"",2)"
 D ^DIC
 K DIC
 Q:+Y<0
 S DA=+Y
 S ZTRTN="ONE^BARAST"
 S BAREDT=$$FMADD^XLFDT(+Y,-1)
 S BARFL1=1
 N I
 F I="BAREDT","BARLDT","BARFL1","BARAC" S ZTSAVE(I)=""
 K ZTSK
 D DEV
 Q:$G(ZTSK)
 D ONE
 D KILL
 Q
 ; *********************************************************************
 ;
ONE ;
 ; ONE ACCOUNT
 K BARC
 K DIQ
 S DIC="^BARAC(DUZ(2),"
 S DA=BARAC
 S DIQ="BARC("
 S DR=".01;1.01:1.06;301"
 D EN^DIQ1
 S BARLDT=$O(^BARAC(DUZ(2),BARAC,12,"B",BAREDT),-1)
 S BARSBAL=$$BAL^BARUTL(BARAC,BARLDT-1)
 S BAREBAL=BARSBAL
 S BARPG=0
 D HDR
 S BARTOT=0,DA=0
 F  S DA=$O(^BARTR(DUZ(2),"AE",BARAC,DA)) Q:'DA  D
 .I $Y+6>IOSL D
 ..W !,?18,"CONT'D"
 ..D HDR
 .S BARTDT=$P(^BARTR(DUZ(2),DA,0),"^",1)
 .S BARDAY=$P(BARTDT,".",1)
 .Q:BARDAY<BARLDT
 .Q:BARDAY>BAREDT
 .D TPRT
 S BAREBAL=BARSBAL+BARTOT
 D FTR
 Q
 ; *********************************************************************
 ;
FDT ;file date in statement sub-file
 S DA(1)=BARAC
 S X=DT
 S DIC="^BARAC(DUZ(2),DA(1),12,"
 S DIC(0)="LX"
 D ^DIC
 Q:+Y<0
 S DA=+Y
 K ^BARAC(DUZ(2),"AC",BARLDT,BARAC)
 Q
 ; *********************************************************************
 ;
TPRT ;LIST ONE TRANSACTION
 K DIQ
 S DIC="^BARTR(DUZ(2),"
 S DIQ="BART("
 S DR=".01;3.5;4;101"
 D EN^DIQ1
 S BART(90050.03,DA,3.5)=BART(90050.03,DA,3.5)*-1
 S BARTOT=BARTOT+BART(90050.03,DA,3.5)
 W !,$P(BART(90050.03,DA,.01),"@",1)
 W ?15,$P(BART(90050.03,DA,4),"-",1,2)
 W ?27,$E(BART(90050.03,DA,101),1,30)
 W:BART(90050.03,DA,101)["PAYMENT" " - THANK YOU"
 W ?65,$J($FN(BART(90050.03,DA,3.5),"P,",2),12)
 Q
 ; *********************************************************************
 ;
HDR ;STATEMENT HEADER
 S:'$D(BARDASH) $P(BARDASH,"-",80)=""
 N DA
 W $$EN^BARVDF("IOF")
 S BARPG=BARPG+1
 W !!,$$FMTE^XLFDT(DT),?20,"S T A T E M E N T   O F   A C C O U N T",?70,"Page: ",BARPG
 S DA=$O(^BAR(90052.03,"B","ACCOUNT STATEMENT HEADER",0))
 I DA W ! F I=1:1:10 D
 .W:$D(^BAR(90052.03,DA,1,I,0)) !,^(0)
 W !!,"FOR ACCOUNT: ",BARC(90050.02,BARAC,.01)
 N I
 F I=1.01,1.02,1.03,1.04,1.05,1.06 D
 .Q:BARC(90050.02,BARAC,I)=""
 .I I<1.05 W !,?13
 .I I=1.05 W ", "
 .I I=1.06 W "  "
 .W BARC(90050.02,BARAC,I)
 W !!,"Statement Covers Period From: ",$$CDT^BARDUTL(BARLDT)," To: ",$$CDT^BARDUTL(BAREDT)
 W !!,?40,"BEGINNING BALANCE: ",?65,$J($FN(BARSBAL,",P",2),12)
 W !!,BARDASH
 W !,?26,"T R A N S A C T I O N S "
 W !,"Trans Date",?15,"Bill#",?27,"Description",?70,"Amount",!
 Q
 ; *********************************************************************
 ;
FTR ;
 ; STATEMENT FOOTER
 W !!,?18,"TOTAL:"
 W ?65,$J($FN(BARTOT,",P",2),12)
 W !,BARDASH
 W !!,?46,"BALANCE DUE: ",?65,$J($FN(BAREBAL,",P",2),12)
 W !!
 Q
 ; *********************************************************************
 ;
ALTR ;EP - add the statement header text
 S DIC="^BAR(90052.03,"
 S DIC(0)="LX"
 S X="ACCOUNT STATEMENT HEADER"
 D ^DIC
 Q:+Y<0
 S DA=+Y
 W $$EN^BARVDF("IOF")
 W !!,"You may enter text that will appear at the top of the account"
 W !,"statements. Typically this will be facility name and address,"
 W !,"business office phone number, point of contact, and special"
 W !,"messages. The statements will print up to 10 lines of text.",!
 S DIE="^BAR(90052.03,"
 S DR=100
 D ^DIE
 Q
 ; *********************************************************************
 ;
FLAG ;EP - flag accounts for statements
 K DIR
 S DIR("A")="Flag an individual account or loop? "
 S DIR("B")=1
 S DIR(0)="S^1:INDIVIDUAL;2:LOOP"
 D ^DIR
 K DIR
 S BARANS=Y
 I BARANS=1 F  D  Q:+$G(Y)<0
 .K DIC
 .S DIC="^BARAC(DUZ(2),"
 .S DIC(0)="AEMQ"
 .D ^DIC
 .Q:+Y<0
 .S BARAC=+Y
 .S BARBDT=$$FMADD^XLFDT(DT,-31)
 .S BARCNT=0
 .D OFL
 .W !!,"Account",$S(BARCNT=0:" already ",1:" "),"flagged.",!
 I BARANS=2 D
 .S DIC="^BARTBL("
 .S DIC(0)="AEMQ"
 .S DIC("S")="I $P(^(0),""^"",3)=""ACTY"""
 .S DIC("A")="Select Type of Account: "
 .S DIC("B")="PATIENT"
 .D ^DIC
 .K DIC
 .Q:+Y<0
 .S BARTYP=$P(Y,"^",2)
 .S BARBDT=$$FMADD^XLFDT(DT,-31)
 .S BARCNT=0,BARAC=0
 .F  S BARAC=$O(^BARAC(DUZ(2),"ATYP",BARTYP,BARAC)) Q:'BARAC  D OFL
 .W !!,BARCNT," accounts flagged."
 .F  W ! Q:$Y+4>IOSL
 .D EOP^BARUTL(0)
 K BARBDT,BARANS,BARAC,BARTYP,BARCNT
 Q
 ; *********************************************************************
 ;
OFL ;set one
 Q:$O(^BARAC(DUZ(2),BARAC,12,0))
 S ^BARAC(DUZ(2),BARAC,12,0)="^90050.0212D^^"
 S DA(1)=BARAC
 S DIC="^BARAC(DUZ(2),DA(1),12,"
 S DIC(0)="LX",X=BARBDT
 D ^DIC
 Q:+Y<0
 S DA=+Y
 S DIE=DIC
 S DR=".02///1"
 D ^DIE
 S BARCNT=BARCNT+1
 Q
