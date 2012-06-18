ABMDPAY1 ; IHS/ASDST/DMJ - Payment of Bill - Part 2 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/SDH - 08/14/01 - V2.4 Patch 9 - NOIS NDA-1199-180065
 ;     Modified to accept negative numbers and take out range
 ;
 ; *********************************************************************
 ;
V ;EP for Viewing Payments
 G ^ABMDPAYV
 ;
D ;EP for Deleting a Payment
 I +$E(Y,2,3)>0&(+$E(Y,2,3)<(ABM("I")+1)) S Y=+$E(Y,2,3) G D2
 I ABM("I")=1 S Y=1 G D2
 K DIR S DIR(0)="NO^1:"_ABM("I")_":0"
 S DIR("?")="Enter the Sequence Number of the PAYMENT to DELETE",DIR("A")="Sequence Number to DELETE"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(Y'>0)
D2 W ! S ABM("ANS")=+Y K DIR S DIR(0)="YO",DIR("A")="Do you wish PAYMENT Number "_ABM("ANS")_" DELETED" D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
D3 I Y=1 S DA(1)=ABMP("BDFN"),DA=ABM("I",ABM("ANS")),DIK="^ABMDBILL(DUZ(2),"_DA(1)_",3," D ^DIK
 Q
 ;
A ;EP for Adding a Payment
 K DIR S DIR(0)="DAO^"_ABMP("VDT")_":"_DT,DIR("A")="Enter NEW PAYMENT Date: " D ^DIR
 K DIR Q:$D(DIRUT)!$D(DIROUT)
 ;
ADT ;EP for Adding Payment with known Payment Date (Y)
 I '$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),3,0)) S ^ABMDBILL(DUZ(2),ABMP("BDFN"),3,0)="^9002274.403D^^"
 S ABM("PDT")=+Y,X=+Y
 K DIC,DD,DO,DINUM
 S DA(1)=ABMP("BDFN"),DIC="^ABMDBILL(DUZ(2),"_DA(1)_",3,",DIC(0)="LE"
 D FILE^DICN K DIC
 Q:+Y<1!$D(DTOUT)!$D(DUOUT)  S ABM("PAYM")=+Y
 I $P(Y,U,3)=1,"ABT"[$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,4) S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".04////P" D ^DIE
 G EDIT
 ;
E ;EP for Editing a Payment
 I ABM("I")=0 W *7,!!,"There are no entries to edit, you must first ADD an entry.",! K DIR S DIR(0)="E" D ^DIR K DIR Q
 I $E(Y,2)>0&($E(Y,2)<(ABM("I")+1)) S Y=$E(Y,2) G E2
 I ABM("I")=1 S Y=1 G E2
 K DIR S DIR(0)="NO^1:"_ABM("I")_":0"
 S DIR("?")="Enter the Sequence Number of the PAYMENT to Edit",DIR("A")="Sequence Number to EDIT"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
E2 S ABM("PAYM")=+Y W !!,"[",+Y,"]  ",$$HDT^ABMDUTL($P(ABM(+Y),U)),!,"==================="
 S ABM("PAYM")=ABM("I",ABM("PAYM"))
 ;
 ; var def: ABM(TOT) = paid amt ^ deductible amt ^ write-off amt
 ;
EDIT S ABM("P0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),3,ABM("PAYM"),0)
 S ABM("OB")=ABM("OB")+$P(ABM("P0"),U,2)+$P(ABM("P0"),U,3)+$P(ABM("P0"),U,4)
 S $P(ABM("TOT"),U)=$P(ABM("TOT"),U)-$P(ABM("P0"),U,2)
 S $P(ABM("TOT"),U,2)=$P(ABM("TOT"),U,2)-$P(ABM("P0"),U,3)-$P(ABM("P0"),U,4)
 S DA(1)=ABMP("BDFN"),DIE="^ABMDBILL(DUZ(2),"_DA(1)_",3,",DA=ABM("PAYM"),DR=".02R~Payment Amount.....: ;.03Deductible Amount..: ;S:X Y=""@1"";.04Co-Insurance Amount: ;@1" D ^DIE K DR Q:$D(Y)
 S ABM("P0")=^ABMDBILL(DUZ(2),DA(1),3,DA,0)
 S $P(ABM("TOT"),U)=$P(ABM("TOT"),U)+$P(ABM("P0"),U,2)
 S $P(ABM("TOT"),U,2)=$P(ABM("TOT"),U,2)+$P(ABM("P0"),U,3)+$P(ABM("P0"),U,4)
 S ABM("OB")=ABM("OB")-$P(ABM("P0"),U,2)-$P(ABM("P0"),U,3)-$P(ABM("P0"),U,4)
 I $P(ABM("P0"),U,6)<0,ABM("OB") D
 .S $P(ABM("P0"),U,6)=ABM("OB")+$P(ABM("P0"),U,6),ABM("OB")=0
 .S DA(1)=ABMP("BDFN"),DIE="^ABMDBILL(DUZ(2),"_DA(1)_",3,",DA=ABM("PAYM")
 .S DR=".06////"_$P(ABM("P0"),U,6) D ^DIE
 I ABM("OB")<0,$P($G(^AUTNINS(ABMP("INS"),2)),U,2)="Y" D  G E3
 .S DA(1)=ABMP("BDFN"),DIE="^ABMDBILL(DUZ(2),"_DA(1)_",3,",DA=ABM("PAYM")
 .S DR=".06////"_($P(^ABMDBILL(DUZ(2),DA(1),3,DA,0),U,6)+ABM("OB")) D ^DIE
 .S ABM("OB")=0
 W !!?16,"(Unobligated Balance: ",$FN(ABM("OB"),",",2),")",!
 I ABM("OB")<1,'$P(ABM("P0"),U,6) G E3
 G E3:$P(ABM("P0"),U,6)<0
 K DIR S (ABM("WO"),DIR("B"))=$P(ABM("P0"),U,6)
 S ABM("WW")=ABM("OB")+ABM("WO") S:ABM("WW")<ABM("WO") ABM("WW")=ABM("WO")
 S ABM="-99999:99999:3"
 K:DIR("B")="" DIR("B")
 S DIR(0)="NOA^"_ABM
 S:ABM("WW")<50 DIR("B")=ABM("WW")
 S DIR("A")="Write-off Amount: " D ^DIR
 S ABM("OB")=ABM("OB")+ABM("WO")-Y,$P(ABM("TOT"),U,3)=+Y
 S DA(1)=ABMP("BDFN"),DIE="^ABMDBILL(DUZ(2),"_DA(1)_",3,",DA=ABM("PAYM"),DR=".06////"_+Y D ^DIE
 ;
E3 S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".25////"_ABM("OB") D ^DIE
 Q:$D(ABMP("PRE-PAY"))
 G CHK^ABMDPAY2
