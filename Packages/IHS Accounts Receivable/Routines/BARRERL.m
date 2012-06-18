BARRERL ; IHS/SD/LSL - Bill File Error Checker ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 09/11/01 - Version 1.5 Patch 2 - NOIS CGA-0701-110093
 ;     Modified to set 0 node of A/R Bill Error File if it doesn't
 ;     already exist.  This allows the BES to work for all facilities on
 ;     one machine.
 ;
 ; IHS/SD/LSL - 12/06/02 - Version 1.7 - NOIS NHA-0601-180049
 ;     Modified to look for 3P bill properly.
 ;
 ; *********************************************************************
 ;
 W !!,"This option will scan the A/R Bill file for problems and must be"
 W !,"run before printing any of the synchronization reports",!
 I $G(^BARBLER(DUZ(2),"LASTRUN")) D  Q:Y'=1
 .W !,"A/R Bill File error check was last run on "
 .W $$MDT^BARDUTL(^BARBLER(DUZ(2),"LASTRUN")),".",!
 .K DIR
 .S DIR(0)="Y"
 .S DIR("A")="Re-run"
 .S DIR("B")="NO"
 .D ^DIR
 .K DIR
 I '$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),"^",14) D
 .W !!,"Enter Small Balance Amount."
 .S DIE="^BAR(90052.06,DUZ(2),"
 .S DA=DUZ(2)
 .S DR="14//5.00"
 .D ^DIE
 ; -------------------------------
 ;
ADT ;ask for date range
 W !!,"Select A/R Bills by DOS Date Range."
 F  D  Q:$G(BARDTOK)
 .K BARSDT,BAREDT,BARDTOK
 .S BARSDT=$$DATE^BARDUTL(1)
 .I BARSDT'>0 S BARDTOK=-1 Q
 .S BAREDT=$$DATE^BARDUTL(2)+.9
 .I BAREDT'>0 S BARDTOK=-1 Q
 .I BAREDT>BARSDT S BARDTOK=1 Q
 .W " ??",*7
 I BARDTOK'>0 K BARSDT,BAREDT,BARDTOK Q
 ; -------------------------------
 ;
QUE ;que to taskman
 S ZTRTN="EN^BARRERL"
 S ZTSAVE("BARSDT")=""
 S ZTSAVE("BAREDT")=""
 S ZTDESC="A/R Re-Roll"
 S ZTIO=""
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task# ",ZTSK," queued.",!
 D EOP^BARUTL(1)
 K BAREDT,BARSDT,BARDTOK
 Q
 ; *********************************************************************
 ;
EN ;EP - looking for A/R Bills that have problems
 D KILL
 D LOOP
 S ^BARBLER(DUZ(2),"LASTRUN")=DT
 K ^BARBLER(DUZ(2),"RUNNING")
 K BARSDT,BAREDT,BARIDT
 Q
 ; *********************************************************************
 ;
KILL ;delete existing entries
 S DIK="^BARBLER(DUZ(2),"
 S DA=0
 F  S DA=$O(^BARBLER(DUZ(2),DA)) Q:'DA  D ^DIK
 K ^BARBLER(DUZ(2),"LASTRUN")
 I '$D(^BARBLER(DUZ(2),0)) S ^BARBLER(DUZ(2),0)="A/R BILL ERROR^90050.04P"
 S ^BARBLER(DUZ(2),"RUNNING")=1
 Q
 ; *********************************************************************
 ;
LOOP ; go thru A/R Bill file
 S BARIDT=BARSDT-.1
 F  S BARIDT=$O(^BARBL(DUZ(2),"E",BARIDT)) Q:'BARIDT!(BARIDT>BAREDT)  D
 .S BARBLDA=0
 .F  S BARBLDA=$O(^BARBL(DUZ(2),"E",BARIDT,BARBLDA)) Q:'BARBLDA  D ONE
 Q
 ; *********************************************************************
 ;
ONE ;examine one a/r bill for errors
 K BARNO3P
 S DIE="^BARBLER(DUZ(2),"
 N I
 F I=0,1,2 S BAR(I)=$G(^BARBL(DUZ(2),BARBLDA,I))
 S BAR3PNM=$P(BAR(0),"^",1)
 S BAR3PNM=$P(BAR3PNM,"-")
 S BARBAL=$P(BAR(0),"^",15)
 D SBL
 D NEG
 S BARDOS=$P(BAR(1),U,2)
 S BARPAT=$P(BAR(1),U)
 S BAR("3P LOC")=$$FIND3PB^BARUTL(DUZ(2),BARBLDA)
 I BAR("3P LOC")="" D  Q
 . S DA=BARBLDA
 . S DR=".05///1"
 . D ^DIE
 S BAR3PDUZ=$P(BAR("3P LOC"),",")
 S BAR3PDA=$P(BAR("3P LOC"),",",2)
 S BARDUZ2=BAR3PDUZ
 S DA=BARBLDA
 S DIC="^BARBL(DUZ(2),"
 S DIQ="BAR("
 S DIQ(0)="IE"
 S DR="3;101"
 D EN^DIQ1
 D MM
 D RR
 K BAR,BAR3P,BARDUZ2,BAR3PNM,BAR3PNMB,BARMM,BARNO3P,BAR3PDA
 Q
 ; *********************************************************************
 ;
FIXIEN ;attempt to find missing 3p bill
 Q
 ; *********************************************************************
 ;
MM ;check for 3p/ar mis-matches
 N I
 F I=0,2,7 S BAR3P(I)=$G(^ABMDBILL(BARDUZ2,BAR3PDA,I))
 S BAR3PNMB=$P(BAR3P(0),"^",1)
 K BARMM
 S:BAR3PNM'=BAR3PNMB BARMM=1                         ;bill names
 S:$P(BAR3P(0),"^",5)'=$P(BAR(1),"^",1) BARMM=1      ;patient
 S:(($P(BAR3P(2),"^",1)+.005)\.01/100)'=(($P(BAR(0),"^",13)+.005)\.01/100) BARMM=1     ;amt billed
 S:$P(BAR3P(7),"^",1)'=$P(BAR(1),"^",2) BARMM=1      ;dos from
 ;insurer
 S BARITYP=$P($G(^AUTNINS(+$P(BAR3P(0),"^",8),2)),"^",1)
 S BARINAME=$P($G(^AUTNINS(+$P(BAR3P(0),U,8),0)),"^",1)
 I BARITYP'="N" D
 .Q:BARINAME=$G(BAR(90050.01,BARBLDA,3,"E"))
 .S BARMM=1
 I BARITYP="N" D
 .Q:$P(^BARAC(DUZ(2),BAR(90050.01,BARBLDA,3,"I"),0),U)'["DPT("
 .Q:BAR(90050.01,BARBLDA,3,"E")=BAR(90050.01,BARBLDA,101,"E")
 .S BARMM=1
 Q:'$G(BARMM)
 D ADD
 S DR=".04///1"
 D ^DIE
 Q
 ; *********************************************************************
 ;
SBL ;check for small balance
 Q:BARBAL'>0
 S BARSBL=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),"^",14)
 S:'BARSBL BARSBL=5
 Q:BARBAL>BARSBL
 D ADD
 S DR=".03///1"
 D ^DIE
 Q
 ; *********************************************************************
 ;
NEG ;check for negative balance
 Q:BARBAL'<0
 D ADD
 S DR=".02///1"
 D ^DIE
 Q
 ; *********************************************************************
 ;
RR ;check if re-roll is needed
 Q:BARBAL'=0
 Q:$P(BAR3P(0),"^",4)="C"
 Q:$P(BAR3P(0),"^",4)="X"
 Q:$P(BAR(2),"^",8)'="R"
 Q:'+$P(BAR(0),"^",13)
 Q:$G(BARMM)
 D ADD
 S DR=".06///1"
 D ^DIE
 Q
 ; *********************************************************************
 ;
ADD ;add to a/r bill error file
 S DA=BARBLDA
 Q:+$G(^BARBLER(DUZ(2),DA,0))
 S DIC="^BARBLER(DUZ(2),"
 S DIC(0)="LX"
 S X="`"_DA
 K DD,DO
 D ^DIC
 Q
 ; *********************************************************************
 ;
DEV ;select device
 S %ZIS="NQ"
 D ^%ZIS
 Q:POP
 I IO'=IO(0) D QUE,HOME^%ZIS Q
 I $D(IO("S")) D
 .S IOP=ION
 .D ^%ZIS
 Q
