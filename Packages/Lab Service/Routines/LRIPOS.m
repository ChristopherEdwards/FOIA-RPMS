LRIPOS ;SLC/FHS - POST INIT V 5.2  
 ;;5.2;LR;;NOV 01, 1997
 ;;5.2;LAB SERVICE;;Sep 27, 1994
EN ;
 Q:'$D(DIFQ)
 I $D(^XTMP634) S GLO="^XTMP634",GLO1="^DD(63.04",CM="," K ^DD(63.04) D ENT^LRIGCOPY D VA200 K ^XTMP634
 K ^LAH("LR5XTIME"),^("LR52TIME"),^LAB(60,"PREINIT"),DIK,DA,^LR("TMP")
 D
 . N LRDA,LRDAI S LRDA=$P($T(+2),";",3,99),^LAM("VR")=LRDA
 . F LRDAI=64.2,64.21,64.22,64.3 S ^LAB(LRDAI,"VR")=LRDA
 S DA=4,DA(1)=.01,DA(2)=62.061
 S DIK="^DD(62.061,.01,1," D ^DIK S:$D(^LAB(64.2,2804,0))#2 $P(^(0),U,15)=7
 K DIK,DA S DIK="^DD(60.12,2,21,",DA=6,DA(1)=2,DA(3)=60.12 D ^DIK K DIK,DA
 D ^LRIPOS4
 S $P(^LAM(0),U,3)=99999,$P(^LAB(69.9,1,0),U,2)=1
 S I=0 F  S I=$O(^LAB(60,I)) Q:I<1!(I>4999)  S CNT=I
 S $P(^LAB(60,0),U,3)=$G(CNT) K I,CNT
 W !?3,"The ASK PROVIDER field (#10) in the Laboratory Site file (#69.9)"
 W !,"is set to Yes to comply with OERR Alert requirements",!
 I $D(^LS(95)),'$O(^LAB(95,0))  D
 . W !,"^LS(95) global is obsolete, it is replaced by ^LAB(95)",!
 . W !?10,"Moving LAB JOURNAL Data from ^LS(95) to ^LAB(95) ",!
 . S %X="^LS(95,",%Y="^LAB(95," D %XY^%RCR
 . W !,"Transfer complete",!
 . W !!?15,"The global ^LS(95) will be deleted in a later version.",!!
BXREF ; Setting B Xref for 65.54,.01
 I $O(^LAB(64.5,1,2,0)) D
 . N DA,DIK
 . S DIK="^LAB(64.5,1,2,",DIK(1)=".01",DA=2,DA(1)=1 D IXALL^DIK
 . Q
 W !!?5,"Updating LR Menu Items ",! D ^LRIPOS3 W !?10,"Done",!
 G:$G(LRFIRST) 1
 I $G(LRVR)>5.11 G VER
 D ENQUE
EXC W !!," Moving excepted location x-ref to the 2 node.",!
 S AC=0 F  S AC=$O(^LAB(69.9,AC)) Q:'AC  D  K ^LAB(69.9,AC,7)
 . I $D(^LAB(69.9,AC,7,0)) S SX=$P($G(^(0)),U,4),%X="^LAB(69.9,"_AC_",7,",%Y="^LAB(69.9,"_AC_",2," D %XY^%RCR S ^LAB(69.9,AC,2,0)="^69.9004^"_SX_"^"_SX
1 K SX,LRLLOC
 W !!,"Removing other obsolete fields ",!
 K DA,DIK S DIK="^DD(68.2,",DA(1)=68.2 F DA=.13,.17,.18 D ^DIK W "."
 W ! K DA S DIK="^DD(68,",DA(1)=68 F DA=4,6 D ^DIK W "."
 W ! K DA S DA(1)=64,DIK="^DD(64," F DA=3,3.1,3.2 D ^DIK W "."
 W ! K DA S DA(1)=69.9,DA=610,DIK="^DD(69.9," D ^DIK
LAM ;
 K DA S DA(1)=62.4,DIK="^DD(62.4,",DA=50 D ^DIK
 K DA S DA=62.47,DIK="^DD(62.47," D ^DIK
 W ! K DA S DA(1)=64.2 F DA=221,131 S DIK="^LAB(64.2," D ^DIK W "."
END ;
 S ^DIC(67.9,0,"DD")="@" F I="DEL","LAYGO","WR" S ^DIC(67.9,0,I)="l" W "."
 S ^DD(62.1,10,9)="@"
 S ^DD(62.07,1,9)="@"
 S ^DD(62.43,.7,9)="@"
 S ^DD(62.1,20,9)="@"
 S ^DD(62.4,20,9)="@"
 S ^DD(62.4,25,9)="@"
 S ^DD(62.4,26,9)="@"
 S ^DD(62.46,2,9)="@"
 S ^DD(68,.051,9)="@"
 S ^DD(68,.061,9)="@"
 K ^DD(60.12,0,"NM","AMIS/CAP CODE")
 K ^DD(68.14,0,"NM","CAP CODE")
VER K ^LR("VERSION"),^LAM("VERSION"),^LAR("VERSION"),^LAM("VERSION"),^LAC("VERSION"),^LRD("VERSION"),^LRE("VERSION"),^LRT("VERSION"),^LAB("VERSION"),^LRO("VERSION")
WKL ;
 I '$D(^LAB(62.05,50,0))#2 S ^LAB(62.05,50,0)="WKL^^1",^LAB(62.05,"B","WKL",50)="",$P(^LAB(62.05,0),U,4)=1+$P(^LAB(62.05,0),U,4) D
 . W !,"Adding new Workload urgencies to file 62.05 ",!
 S LRURG=0 F  S LRURG=$O(^LAB(62.05,LRURG)) Q:LRURG<1!(LRURG>49)  I $D(^(LRURG,0))#2 S LRURGN=$E($P(^(0),U),1,20),LRURGI=LRURG+50 D
 . I '$D(^LAB(62.05,LRURGI,0))#2 S ^LAB(62.05,LRURGI,0)="WKL - "_LRURGN_"^^1",^LAB(62.05,"B","WKL - "_LRURGN,LRURGI)="",$P(^LAB(62.05,0),U,4)=1+$P(^LAB(62.05,0),U,4)
 . Q
 G:$G(LRVR)>5.11 ALPHA
 I $G(LRVR) K DA S DA(1)=62.61,DA=6,DIK="^DD(62.61," D ^DIK W !!,"Removing can be ordered STAT field for Accession Test Group file",!
 K DA S DA(1)=66,DA=3.1,DIK="^LAB(66," D ^DIK
 S DA=55,DA(1)=62.4,DIK="^DD(62.4," D ^DIK
ALPHA ;
 W !,?5,"Sending Mailman message " D ^LRIPOSXM G:$G(LRVR)>5.11 APGRP
 I $G(LRFIRST) W !!?10,"I see you are installing Lab for the first time.",! D
 .W !!,"AFTER THE INITS HAVE FINISHED YOU SHOULD RUN THE ",!!?20," 'POST^LRSETUP' ROUTINE",!!
 .W "This will set your data base to day 1 state (No Laboratory Data)",!!
APGRP ;Checking for LR as an application group for New Person file
 I '$D(^DIC("AC","LR",200)) D
 . F  L +^VA(200):1 Q:$T  W !!?7,"Not able to LOCK the ^VA(200) global ",!,"Please release the LOCK on this global",! H 30
 . W !,"Adding 'LR' as an application group to the New Person File",!!
 . K DIE,DIC,DA,DR S DIE="^DIC(",DIC=DIE,(DA,DLAYGO)=200,DIC(0)="L"
 . S DR=".01///^S X=""NEW PERSON"";10///^S X=""LR"""
 . S DR(1,1)=".01///^S X=""NEW PERSON"";10///^S X=""LR"""
 . S DR(2,1.005)=".01///^S X=""LR""" D ^DIE K DLAYGO L -^VA(200)
FIN W !!?10,"Removing Obsolete ^LAB('X') Global",!! K ^LAB("X")
 W !,"Post Init Complete",!!
 Q
ENQUE W !!?10,$C(7),"Adjusting your Accession file",!!
 ;Remove AB XREF and dinum entries
 F LRAA=0:0 S LRAA=+$O(^LRO(68,LRAA)) Q:LRAA<1  W "." F LRDT=1:0 S LRDT=+$O(^LRO(68,LRAA,1,LRDT)) Q:LRDT<1  F LRSN=0:0 S LRSN=+$O(^LRO(68,LRAA,1,LRDT,1,LRSN)) Q:LRSN<1  D
 .F LRTEST=0:0 S LRTEST=+$O(^LRO(68,LRAA,1,LRDT,1,LRSN,4,LRTEST)) Q:LRTEST<.5  K ^LRO(68,LRAA,1,LRDT,1,LRSN,4,LRTEST,1),^LRO(68,LRAA,1,LRDT,1,LRSN,4,"AB")
 I $G(LRVR)<5.11 D ^LRIPOS2
 Q
VA200 S ^DD(63.04,.04,0)="VERIFY PERSON^RP200^VA(200,^0;4^Q"
 S ^DD(63.04,.1,0)="REQUESTING PERSON^P200'^VA(200,^0;10^Q"
 Q
