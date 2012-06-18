ABMDTFEE ; IHS/ASDST/DMJ - Table Maintenance of 3P CODES ;
 ;;2.6;IHS Third Party Billing;**1,2**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - NO HEAT - Populate owner of table
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - populate new effective dates multiple
 ;
 S U="^" W !
FEE K DIC
 S DIC="^ABMDFEE(",DIC(0)="QEAML"
 S DIC("A")="Select FEE SCHEDULE: "
 S:$P($G(^ABMDPARM(DUZ(2),1,0)),U,9)]"" DIC("B")=$P(^(0),U,9)
 S DIC("S")="I DUZ(2)=$P($G(^ABMDFEE(X,0)),""^"",4)"
 S DIC("DR")=".02;.04////"_DUZ(2)  ;abm*2.6*1 NO HEAT
 D ^DIC
 G XIT:$D(DUOUT)!$D(DTOUT)
 I +Y<1 G FEE
 S ABM("FEE")=+Y
SEL W !!,"----- FEE SCHEDULE CATEGORIES -----",!
 S DIR(0)="SO^1:MEDICAL FEES;2:SURGICAL FEES;3:RADIOLOGY FEES;4:LABORATORY FEES;5:ANESTHESIA FEES;6:DENTAL FEES;7:REVENUE CODE;8:HCPCS FEES;9:DRUG FEES;10:CHARGE MASTER"
 S DIR("A")="Select Desired CATEGORY"
 D ^DIR K DIR
 G XIT:$D(DIROUT)!$D(DIRUT)
 S ABM=+Y
 ;
 S ABM("SUB")=$S(ABM=1:19,ABM=2:11,ABM=3:15,ABM=4:17,ABM=5:23,ABM=6:21,ABM=7:31,ABM=8:13,ABM=9:25,ABM=10:32)
EDIT K DIC  ;abm*2.6*2 3PMS10003A moved EDIT tag to here
 S DA(1)=ABM("FEE")
 ;S (DIC,DIE)="^ABMDFEE("_DA(1)_","_ABM("SUB")_","  ;abm*2.6*2 3PMS10003A
 S DIC="^ABMDFEE("_DA(1)_","_ABM("SUB")_","  ;abm*2.6*2 3PMS10003A
 S:'$D(@(DIC_"0)")) @(DIC_"0)")="^9002274.01"_ABM("SUB")_"P"
 S ABM("DICS")=9002274.01_ABM("SUB") X:$D(^DD(ABM("DICS"),.01,12.1)) ^DD(ABM("DICS"),.01,12.1)
 ;start old code abm*2.6*2 3PMS10003A
 ;I ABM=7 S DIC("W")="W "" - "",$P($G(^AUTTREVN(Y,0)),U,2),?65,$J($FN($P($G(^ABMDFEE(DA(1),31,Y,0)),U,2),"","",2),9)"
 ;I ABM=6 S DIC("W")="W "" - "",$P($G(^AUTTADA(Y,0)),U,2),?65,$J($FN($P($G(^ABMDFEE(DA(1),21,Y,0)),U,2),"","",2),9)"
 ;I "123458"[ABM S DIC("W")="W "" - "",$P($$CPT^ABMCVAPI(Y,DT),U,3),?65,$J($FN($P($G(^ABMDFEE(DA(1),ABM(""SUB""),Y,0)),U,2),"","",2),9)"  ;CSV-c
 ;S DR=".02"
 ;end old code start new code 3PMS10003A
 I ABM=7 S DIC("W")="W "" - "",$P($G(^AUTTREVN(Y,0)),U,2),?65,$J($FN($P($$ONE^ABMFEAPI(DA(1),31,Y,DT),U),"","",2),9)"
 I ABM=6 S DIC("W")="W "" - "",$P($G(^AUTTADA(Y,0)),U,2),?65,$J($FN($P($$ONE^ABMFEAPI(DA(1),21,Y,DT),U),"","",2),9)"
 I "123458"[ABM S DIC("W")="W "" - "",$P($$CPT^ABMCVAPI(Y,DT),U,3),?65,$J($FN($P($$ONE^ABMFEAPI(DA(1),ABM(""SUB""),Y,DT),U),"","",2),9)"  ;CSV-c
 ;end new code 3PMS10003A
 ;
 W !!  ;abm*2.6*2 3PMS10003A removed EDIT tag from here
 S DIC(0)="QLEAM"
 D ^DIC K DIC
 G SEL:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G EDIT
 ;start old code 3PMS10003A
 ;S DA=+Y
 ;S ABM("LDATE")=$P(^ABMDFEE(DA(1),ABM("SUB"),DA,0),U,3)
 ;S:ABM("SUB")=21 ABM("LDATE")=$P(^(0),U,4)
 ;I ABM("LDATE") W !,"Last Updated: ",$$SDT^ABMDUTL(ABM("LDATE"))
 ;end old code start new code 3PMS10003A
EFFDT ;
 S ABMCODE=+Y
 D ^XBFMK
 S DA(2)=ABM("FEE")
 S DA(1)=ABMCODE
 S DIC="^ABMDFEE("_DA(2)_","_ABM("SUB")_","_DA(1)_",1,"
 S DIC(0)="AELQ"
 S DIC("P")=$P(^DD(9002274.01_ABM("SUB"),1,0),U,2)
 D ^DIC
 I $D(DTOUT)!$D(DUOUT) G EDIT  ;abm*2.6*2
 I Y<0 W "??  EFFECTIVE DATE REQUIRED" G EFFDT  ;abm*2.6*2
 S ABMENTRY=+Y
 D ^XBFMK
 S DA(2)=ABM("FEE")
 S DA(1)=ABMCODE
 S DIE="^ABMDFEE("_DA(2)_","_ABM("SUB")_","_DA(1)_",1,"
 S DA=ABMENTRY
 S DR=".02//"_$P($$ONE^ABMFEAPI(DA(2),ABM("SUB"),ABMCODE,DT),U)
 S DR=DR_";.03//"_$P($$ONE^ABMFEAPI(DA(2),ABM("SUB"),ABMCODE,DT),U,2)
 S DR=DR_";.04//"_$P($$ONE^ABMFEAPI(DA(2),ABM("SUB"),ABMCODE,DT),U,3)
 S DR=DR_";.05////"_DT_";.06////"_DUZ
 ;end new code 3PMS10003A
 W !
 D ^ABMDDIE
 ;start new code abm*2.6*2 3PMS10003A
 D ^XBFMK
 S DA(1)=ABM("FEE")
 S DIE="^ABMDFEE("_DA(1)_","_ABM("SUB")_","
 S DA=ABMCODE
 S DR=".02////"_$P($$ONE^ABMFEAPI(ABM("FEE"),ABM("SUB"),ABMCODE,DT),U)
 D ^DIE
 ;this next part populates the UPDATE multiple
 D ^XBFMK
 S DA(1)=ABM("FEE")
 S DIC="^ABMDFEE("_DA(1)_",1,"
 S DIC(0)="MQL"
 S DIC("P")=$P(^DD(9002274.01,1,0),U,2)
 D NOW^%DTC
 S X=%
 S DIC("DR")=".02////"_DUZ
 D ^DIC
 ;end new code 3PMS10003A
 G EDIT
 ;
XIT K ABM,DIR,DIC,DIE
 Q
