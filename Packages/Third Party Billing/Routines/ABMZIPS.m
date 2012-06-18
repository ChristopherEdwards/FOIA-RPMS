ABMZIPS ;IHS/DSD/DMJ - GENERATE CLAIMS FOR AHCCCS PHYSICIAN IP SVCS. [ 05/01/98  11:11 AM ]
 ;;2.0;IHS 3P BILLING SYSTEM;**1**;1 APRIL 98
START ;START
 K ABMQUIT
 W $$^ABMVDF("IOF")
 W !!,"This option will generate 3P Bills"
 W !,"for inpatient physician services.",!
 W !,$$^ABMVDF("RVN"),"NOTE:",$$^ABMVDF("RVF"),"To use this option an inpatient bill must already exist"
 W !,"in 3P Bill File.",!!
PAY ;enter payer     
 K DIC
 S DIC("B")="ARIZONA MEDICAID"
 S DIC="^AUTNINS(",DIC(0)="AEMQ"
 D ^DIC Q:+Y<0
 S ABMINS=+Y
 S ABMITYP=$P($G(^AUTNINS(ABMINS,2)),"^",1)
 S ABMINAME=$P(^AUTNINS(ABMINS,0),"^",1)
CODE ;enter procedure code
 K DIC
 S DIC="^ICPT(",DIC(0)="AEMQ"
 S DIC("B")="W0087"
 D ^DIC Q:+Y<0
 S ABMCODE=+Y
RATE ;get rate
 F ABMI=13,27 D
 .S ABMDA=$O(^ABMDFEE(1,ABMI,"B",ABMCODE,0))
 .Q:'ABMDA
 .S ABMRATE=$P(^ABMDFEE(1,ABMI,ABMDA,0),"^",2)
 S DIR("A")="Enter Charge"
 S DIR("B")=$G(ABMRATE)
 S DIR(0)="N" D ^DIR K DIR
 S ABMRATE=Y
ASK ;ask look-up method
 S DIR(0)="S^1:INDIVIDUAL;2:LOOP"
 S DIR("A")="Select Method of Bill Look-up"
 S DIR("B")="INDIVIDUAL"
 D ^DIR K DIR
 Q:'Y
 S ABM(1)="IND"
 S ABM(2)="LOOP"
 D @ABM(Y)
 K ABMDUP,ABMPHY,ABMCODE,ABMPAT,ABMBATCH,ABMQUIT,ABMINS,ABMDTF,ABMDTT,ABMUNIT,ABMDICSV,ABMBNAME,ABM
 Q
LOOP ;LOOP HERE
 W !!,"Begin Loop",!
 S %DT("A")="Go Back to Date: "
 S %DT("B")="01/01/97"
 S %DT="AEP"
 D ^%DT
 Q:Y<0  S ABMSDT=+Y
 S ABMP("BDFN")=+$G(^ABMDTMP("IPSVC",ABMINAME,"LAST"))
BY ;bypass with different ien
 F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AJ",ABMINS,ABMP("BDFN"))) Q:'ABMP("BDFN")  D  Q:$G(ABMQUIT)
 .Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),"^",1)<ABMSDT
 .D SET
 .Q:$P(ABMZERO,"^",7)'=111
 .D ONE
 .S ^ABMDTMP("IPSVC",ABMINAME,"LAST")=ABMP("BDFN")
 .W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue Looping, ""^"" to Quit"
 .D ^DIR K DIR
 .K:Y ABMQUIT
 Q
IND ;process one at a time
 F  D  Q:'$G(ABMP("BDFN"))
 .D ^ABMZBDIC
 .Q:'$G(ABMP("BDFN"))
 .D SET
 .D ONE
 .K ABMQUIT
 Q
ONE ;process one bill
 S ABMCNT=0
 D:$Y+IOSL>24 HDR
 W !,$P(ABMZERO,"^",1),?10,$P(^DPT(ABMPAT,0),"^",1)
 W ?40,$$SDT^ABMDUTL($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),"^",1))
 W ?55,$$SDT^ABMDUTL($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),"^",2))
 F  D  Q:$G(ABMQUIT)
 .S ABMCNT=ABMCNT+1
 .D PHY Q:$G(ABMQUIT)
 .D UNIT Q:$G(ABMQUIT)
 .I '$G(ABMBATCH) D NB Q:$G(ABMQUIT)
 .D NBILL
 .Q:'$G(DA)
 .D BFILE
 Q
PHY ;enter physician
 W !
 K DIC,ABMPHY
 S:ABMCNT=1 ABMPHY=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 S:ABMCNT=2 ABMPHY=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","O",0))
 S:$G(ABMPHY) ABMPHY=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMPHY,0),"^",1)
 S:$G(ABMPHY) DIC("B")=$P($G(^VA(200,+$G(ABMPHY),0)),"^",1)
 S DIC="^VA(200,",DIC(0)="AEMQ"
 S DIC("A")="Enter Physician: "
 D ^DIC
 I +Y<0 S ABMQUIT=1 Q
 S ABMPHY=+Y
 Q
UNIT ;enter units
 S X1=ABMDTT,X2=ABMDTF D ^%DTC S DIR("B")=X+1
 S DIR(0)="N^1:99"
 S DIR("A")="Enter # of Units: "
 D ^DIR K DIR
 S ABMUNIT=Y
 I ABMUNIT'>0 S ABMQUIT=1
 Q
NB ;enter new batch in file 9002274.6
 K DIC
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="LX"
 D NOW^%DTC S X=%
 D ^DIC
 I +Y<0 S ABMQUIT=1 Q
 S ABMBATCH=+Y
 S DA=ABMBATCH
 S DIE=DIC
 S DR=".02////3;.05////"_DUZ_";.04////"_ABMINS_";.03////"_ABMITYP
 D ^DIE
 Q
NBILL ;create bill in bill file
 K DA
 D DUP I $G(ABMDUP) D  I Y'=1 Q
 .W !
 .W !,"A physician IP services bill already exists for this provider"
 .W !,"for this visit date and patient."
 .W !,"Bill # ",$P(^ABMDBILL(DUZ(2),ABMDUP,0),"^",1)
 .S DIR("A")="Continue"
 .S DIR("B")="NO"
 .S DIR(0)="Y" D ^DIR K DIR
 S ABM1(.02)=131
 S ABM1(.03)=$P(ABMZERO,"^",3)
 S ABM1(.05)=$P(ABMZERO,"^",5)
 S ABM1(.06)=3
 S ABM1(.07)=141
 S ABM1(.08)=ABMINS
 S ABM1(.09)="C"
 S ABM1(.1)=$P(ABMZERO,"^",10)
 S ABM1(.14)=DUZ
 S ABM1(.15)=DT
 S ABM1(.16)="A"
 S ABM1(.17)=ABMBATCH
 S ABM1(.21)=ABMRATE*ABMUNIT
 S ABM1(.23)=ABMRATE*ABMUNIT
 S ABMBDFN=$$ADD^ABMDBAD1(.ABM1)
 I 'DA W !!,"Bill NOT created." Q
 S ABMBNAME=$P(^ABMDBILL(DUZ(2),DA,0),"^",1)
 W !!,"Bill # ",ABMBNAME," created"
 N I F I=5,6,7,8,9,11,13,17 D
 .Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),I))
 .M ^ABMDBILL(DUZ(2),DA,I)=^ABMDBILL(DUZ(2),ABMP("BDFN"),I)
 S:$P($G(^ABMDBILL(DUZ(2),DA,8)),"^",10) $P(^(8),"^",10)=""
 S ^ABMDBILL(DUZ(2),DA,41,0)="^9002274.4041P^1^1"
 S ^ABMDBILL(DUZ(2),DA,41,1,0)=ABMPHY_"^A"
MED ;file entry under misc svcs
 S ^ABMDBILL(DUZ(2),DA,43,0)="^9002274.4043P^1^1"
 S ^ABMDBILL(DUZ(2),DA,43,1,0)=ABMCODE_"^^"_ABMUNIT_"^"_ABMRATE_"^^"_1
 S $P(^ABMDBILL(DUZ(2),DA,0),"^",4)="B"
 S DIK="^ABMDBILL(DUZ(2)," D IX1^DIK
 Q
BFILE ;file in 3P TX STATUS file
 K DIC
 S DIC(0)="LX"
 S X=ABMBNAME
 S DA(1)=ABMBATCH
 S DIC="^ABMDTXST(DUZ(2),DA(1),2,"
 S:'$D(^ABMDTXST(DUZ(2),DA(1),2,0)) ^(0)="^9002274.61P^^"
 D ^DIC
 I +Y<0 W !!,*7,"Bill NOT added to 3P TX STATUS FILE",! Q 
 W " - added to batch # ",ABMBATCH,!
 Q
SET ;set some variables
 S ABMZERO=^ABMDBILL(DUZ(2),ABMP("BDFN"),0)
 S ABMPAT=$P(ABMZERO,"^",5)
 S ABMDTF=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),"^",1),ABMDTT=$P(^(7),"^",2)
 Q
HDR ;screen header
 W $$^ABMVDF("IOF")
 S:'$D(ABM("EQ")) $P(ABM("EQ"),"=",80)=""
 W !,"BILL #"
 W ?10,"PATIENT"
 W ?40,"ADMIT DATE"
 W ?55,"DISCHARGE DATE"
 W !,ABM("EQ"),!
 Q
DUP ;check for duplicate bill
 K ABMDUP
 N I S I=0 F  S I=$O(^ABMDBILL(DUZ(2),"D",ABMPAT,I)) Q:'I!($G(ABMDUP))  D
 .Q:$P(^ABMDBILL(DUZ(2),I,0),"^",7)'=141
 .Q:$P(^ABMDBILL(DUZ(2),I,7),"^",1)'=ABMDTF
 .S ABMDPV=$P($G(^ABMDBILL(DUZ(2),I,41,1,0)),"^",1)
 .Q:ABMDPV'=ABMPHY
 .Q:$P(^ABMDBILL(DUZ(2),I,0),"^",8)'=ABMINS
 .S ABMDUP=I
 Q
