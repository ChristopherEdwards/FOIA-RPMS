ABMDIPS ; IHS/ASDST/DMJ - GENERATE BILLS FOR PHYSICIAN IP SVCS. ;  
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;
 ;IHS/DSD/MRS - 8/3/1999 NOIS XAA-0899-200005 Patch 3 #7
 ;      Changed variable name from ABMIO to ABMI0
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ;
START ;START
 K ABMQUIT
 W $$EN^ABMVDF("IOF")
 W !!,"This option will generate 3P Bills"
 W !,"for inpatient physician services.",!
 W !,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF"),"To use this option an inpatient bill must already exist"
 W !,"in 3P Bill File.",!!
PAY ;enter payer     
 K DIC
 S DIC("B")="ARIZONA MEDICAID"
 S DIC="^AUTNINS(",DIC(0)="AEMQ"
 D ^DIC Q:+Y<0
 S ABMINS=+Y
 S ABMITYP=$P($G(^AUTNINS(ABMINS,2)),U)
 S ABMINAME=$P(^AUTNINS(ABMINS,0),U)
 ; Check for proper insurer file setup
 S ABMI0=$G(^ABMNINS(DUZ(2),ABMINS,1,141,0))
 I ABMI0="" D  Q
 .W *7,!,"Inpatient Physician Services not authorized for ",ABMINAME
 .W !,"Need to add Visit Type 141 for insurer in Table Maintenance."
 .D EOP^ABMDUTL(1)
CODE ;enter procedure code
 S ABMCODE=$P(ABMI0,"^",16)
 S:ABMCODE ABMCODE=$P($$CPT^ABMCVAPI(ABMCODE,ABMP("VDT")),U,2)  ;CSV-c
 K DIC
 S DIC="^ICPT(",DIC(0)="AEMQ"
 S DIC("A")="Enter HCPCS Code: "
 S DIC("B")=$G(ABMCODE)
 D ^DIC Q:+Y<0
 S ABMCODE=+Y
RATE ;get rate
 F ABMI=13,27 D
 .S ABMDA=$O(^ABMDFEE(1,ABMI,"B",ABMCODE,0))
 .Q:'ABMDA
 .;S ABMRATE=$P(^ABMDFEE(1,ABMI,ABMDA,0),"^",2)  ;abm*2.6*2 3PMS10003A
 .S ABMRATE=$P($$ONE^ABMFEAPI(1,ABMI,ABMDA,$S($G(ABMP("VDT")):ABMP("VDT"),1:DT)),U)  ;abm*2.6*2 3PMS10003A
 S DIR("A")="Enter Charge"
 S DIR("B")=$G(ABMRATE)
 S DIR(0)="N" D ^DIR K DIR
 S ABMRATE=Y
EXP ;mode of export
 S ABMMOE=$P(ABMI0,"^",4)
 I 'ABMMOE D
 .W !
 .K DIC S DIC="^ABMDEXP(",DIC(0)="AEMQ"
 .D ^DIC S ABMMOE=+Y
 Q:ABMMOE<0
 S:^ABMDEXP(ABMMOE,0)["UB" ABMUB=1
REV ;revenue code
 I $G(ABMUB) D
 .S ABMRVCD=$P(ABMI0,"^",3)
 .Q:ABMRVCD
 .W !
 .K DIC S DIC="^AUTTREVN(",DIC(0)="AEMQ"
 .S DIC("A")="Enter Revenue Code: "
 .D ^DIC S ABMRVCD=+Y
ASK ;ask look-up method
 S DIR(0)="S^1:LOOP;2:INDIVIDUAL BILL"
 S DIR("A")="Select Method of Bill Look-up"
 S DIR("B")="LOOP"
 D ^DIR K DIR
 Q:'Y
 S ABM(1)="LOOP"
 S ABM(2)="IND"
 D @ABM(Y)
 S DIR("A")="Done - enter RETURN to continue" D EOP^ABMDUTL(0)
 K ABMDUP,ABMPHY,ABMCODE,ABMPAT,ABMBATCH,ABMQUIT,ABMINS,ABMDTF,ABMDTT,ABMUNIT,ABMDICSV,ABMBNAME,ABM,ABMMOE,ABMI0,ABMRVCD,DIC
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
 .Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U)<ABMSDT
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
 .D ^ABMDBLK
 .Q:'$G(ABMP("BDFN"))
 .D SET
 .D ONE
 .K ABMQUIT
 Q
ONE ;process one bill
 S ABMCNT=0
 D:$Y+IOSL>24 HDR
 W !,$P(ABMZERO,U),?10,$P(^DPT(ABMPAT,0),U)
 W ?40,$$SDT^ABMDUTL($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U))
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
 S:$G(ABMPHY) ABMPHY=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMPHY,0),U)
 S:$G(ABMPHY) DIC("B")=$P($G(^VA(200,+$G(ABMPHY),0)),U)
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
 S DR=".02////"_ABMMOE_";.05////"_DUZ_";.04////"_ABMINS_";.03////"_ABMITYP
 S:$P($G(^ABMDEXP(ABMMOE,1)),"^",5)="E" DR=DR_";.14////IPPHYS.NUL"
 D ^DIE
 Q
NBILL ;create bill in bill file
 K DA
 D DUP I $G(ABMDUP) D  I Y'=1 Q
 .W !
 .W !,"A physician IP services bill already exists for this provider"
 .W !,"for this visit date and patient."
 .S DIR("A")="Continue"
 .S DIR("B")="NO"
 .S DIR(0)="Y" D ^DIR K DIR
 S ABM1(.02)=131
 S ABM1(.03)=$P(ABMZERO,"^",3)
 S ABM1(.05)=$P(ABMZERO,"^",5)
 S ABM1(.06)=ABMMOE
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
 S ABMBNAME=$P(^ABMDBILL(DUZ(2),DA,0),U)
 W !!,"Bill # ",ABMBNAME," created"
 N I F I=5,6,7,8,9,11,13,17 D
 .Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),I))
 .M ^ABMDBILL(DUZ(2),DA,I)=^ABMDBILL(DUZ(2),ABMP("BDFN"),I)
 S ^ABMDBILL(DUZ(2),DA,41,0)="^9002274.4041P^1^1"
 S ^ABMDBILL(DUZ(2),DA,41,1,0)=ABMPHY_"^A"
MED ;file entry under misc svcs
 S ^ABMDBILL(DUZ(2),DA,43,0)="^9002274.4043P^1^1"
 S ^ABMDBILL(DUZ(2),DA,43,1,0)=ABMCODE_"^"_$G(ABMRVCD)_"^"_ABMUNIT_"^"_ABMRATE_"^^"_1
 S $P(^ABMDBILL(DUZ(2),DA,0),"^",4)="B",ABMAPOK=1
 S DIK="^ABMDBILL(DUZ(2)," D IX1^DIK
 Q
BFILE ;file in 3P TX STATUS file
 K DIC
 S DIC(0)="LXE"
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
 S ABMDTF=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U),ABMDTT=$P(^(7),"^",2)
 Q
HDR ;screen header
 W $$EN^ABMVDF("IOF")
 S:'$D(ABM("EQ")) $P(ABM("EQ"),"=",80)=""
 W !,"BILL #"
 W ?10,"PATIENT"
 W ?40,"ADMIT DATE"
 W ?55,"DISCHARGE DATE"
 W !,ABM("EQ"),!
 Q
DUP ;check for duplicate bill
 K ABMDUP
 N I S I=0 F  S I=$O(^ABMDBILL(DUZ(2),"D",ABMPAT,I)) Q:'I  D
 .Q:$P(^ABMDBILL(DUZ(2),I,0),"^",7)'=141
 .Q:$P(^ABMDBILL(DUZ(2),I,7),U)'=ABMDTF
 .S ABMDPV=$P($G(^ABMDBILL(DUZ(2),I,41,1,0)),U)
 .Q:ABMDPV'=ABMPHY
 .Q:$P(^ABMDBILL(DUZ(2),I,0),"^",8)'=ABMINS
 .S ABMDUP=1
 Q
