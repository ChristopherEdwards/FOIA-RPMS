APSPCO1 ; IHS/MSC/PLS - List Manager Complete Orders, CON'T ;24-Jul-2013 08:46;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1013**;Sep 23, 2004;Build 74
 ;=================================================================
 Q
 ; Input: EFLG - Edit flag
PMTLLST(EFLG) ;EP- Prompt user for location restriction list
 N DIC,Y
 S DIC=9009033.6,DIC(0)="AEMQZ"_$S($G(EFLG):"L",1:"")
 I $G(EFLG) D
 .S DIC("A")="Select/Create location restriction list: "
 E  S DIC("A")="Select location restriction list('^' to ignore): "
 D ^DIC
 Q $S(Y>0:+Y,1:0)
 ;
EDTLLST ;EP- Create/Edit a location restriction list
 N DA,DIE,DR,DIDEL,DUOUT,DLAYGO
 S DLAYGO=9009033.6
 S DA=$$PMTLLST(1)
 Q:DA<1
 S DR=".01;1",DIE=9009033.6 D ^DIE
 Q
CHGCOM ;EP- Change comment associated with order
 N DA,DUOUT,Y,VAL,ITM,DTOUT,DIRUT,DIE,DR,LST,APSPCOQF,COM
 S DIR("A")="Select Orders by number",DIR(0)="LO^1:"_VALMCNT D ^DIR
 I $D(DUOUT) S VALMBCK="R" Q
 I +Y D FULL^VALM1 S LST=Y
 F ITM=1:1:$L(LST,",") Q:$P(LST,",",ITM)']""!($G(APSPCOQF))  S VAL=$P(LST,",",ITM) D
 .S DA=$P(@VALMAR@(VAL,"POFIEN"),U,2)
 .I '$$GET1^DIQ(52.41,DA,.01) D  Q
 ..W !,"This order has already been processed and removed from the Pending Order File!"
 .W !,"Comment for order number: "_$$GET1^DIQ(52.41,DA,.01)," on patient: "_$$GET1^DIQ(52.41,DA,1)
 .S DIE=52.41,DR="23" D ^DIE
 .S COM=$$GET1^DIQ(52.41,DA,23)
 .S COM=$S($L(COM)>30:$E(COM,1,27)_"...",1:COM)
 .D FLDTEXT^VALM10(VAL,"COMMENT",COM)
 .S APSPCO("QFLG")='+$$DIRYN^APSPUTIL("Continue: ","N",,.APSPPOP)
 S VALMBCK="R"
 Q
