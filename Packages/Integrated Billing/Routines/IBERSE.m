IBERSE	;ALB/ARH - BUILD CHECK-OFF SHEET  (350.7&350.71); 11/18/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	S IBERSCE=1 D HOME^%ZIS W @IOF,?22,"Build Check-Off Sheets",!!!!!!!
ENTG	;enter/edit group information (350.7)
	S DIC("A")="Select Check-Off Sheet: "
	S DIC="^IBE(350.7,",DIC(0)="AELQ" D ^DIC K DIC G:Y<0 ENDG S IBGRP=+Y
	I '$P(Y,"^",3) S DIR(0)="Y",DIR("A")="Edit this CHECK-OFF SHEET",DIR("B")="NO" D ^DIR K DIR G G4:$D(DIRUT),G3:'Y
G1	S DA=IBGRP,DIE="^IBE(350.7,",DR=".01:.04",DIE("NO^")="BACK" D ^DIE K DIE,DIC,DR,Y I '$D(DA) D DELGRP G G4
	K DA S IBX=$$FORMAT^IBEFUNC2(IBGRP,"") I $L($P($G(^IBE(350.7,IBGRP,0)),"^",1))>$P(IBX,"^",2) W !!,"Name too long, will not fit format entered.",!! G G1
G2	S DIC("A")="Select CLINIC: ",DIC="^SC(",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC
	I Y'<0 S DA=+Y,DIE="^SC(",DR="25//"_$P(^IBE(350.7,+IBGRP,0),"^") D ^DIE K DIE,DIC,DR,DA,Y G G2
G3	D GDISP,CAT,PRINT
G4	W ! G ENTG
ENDG	K DA,DR,Y,X,IBGRP,IBPFN,IBX,IBERSCE,DTOUT,DUOUT,DIRUT,DIROUT
	Q
	;
CAT	;enter/edit sub-header information (350.71)
	S DIC("A")="Select SUB-HEADER: ",DIC("S")="I $D(^(0)),$P(^(0),U,3)=""S"",$P(^(0),U,4)="_IBGRP
	S DIC="^IBE(350.71,",DIC(0)="AEQL" D ^DIC K DIC G ENDC:Y<0 S IBCFN=+Y
	I '$P(Y,"^",3) S DIR(0)="Y",DIR("A")="    Edit SUB-HEADER",DIR("B")="NO" D ^DIR K DIR G C2:$D(DIRUT),C1:'Y
	S DA=IBCFN,DIE="^IBE(350.71,",DR=".03///S;.04////"_IBGRP_";.01;.02",DIE("NO^")="BACK" D ^DIE K DIE,DIC,DR,Y I '$D(DA) D DELCAT G C2
C1	D CDISP,PROC,GDISP
C2	G CAT
ENDC	K X,Y,IBCFN,DA,DUOUT,DTOUT
	Q
	;
PROC	;enter/edit procedure information (350.71)
	S DIR("A")="        Select a PROCEDURE",DIR("?")="^D CDISP^IBERSE"
	S DIR(0)="409.71,.01O" D ^DIR K DIR,DINUM G ENDP:Y<1 S IBCODE=+Y
	I $$CPTSTAT^IBEFUNC2(IBCODE,DT)'>1 W !!,?5,"CPT not active Nationally, Locally, or in Billing!",!! G PROC
	S IBNM=$P($G(^ICPT(IBCODE,0)),"^",2),IBPFN=$O(^IBE(350.71,"AP",IBCFN,IBCODE,0))
	I 'IBPFN K DD,DO S DIC(0)="",DIC="^IBE(350.71,",X=IBNM D FILE^DICN K DIC S IBPFN=+Y
	S DA=IBPFN,DIE="^IBE(350.71,",DR=".03///P;.05////"_IBCFN_";.06////"_IBCODE_";.01;.02",DIE("NO^")="BACK" D ^DIE K DIE,DIC,DR,DA,Y
	G PROC
ENDP	K X,Y,IBPFN,IBCODE,IBNM,DA,DUOUT,DTOUT,DIRUT,DIROUT
	Q
	;
GDISP	;display the groups data (350.7)
	S X="IBXCPTG" X ^%ZOSF("TEST") Q:'$T
	W:$D(IOF) @IOF,?25,"Ambulatory Surgery Check-Off Sheet Profile"
	S D0=IBGRP D ^IBXCPTG K X,DXS,D0
	Q
CDISP	;display the field data (350.71)
	S X="IBXCPTC" X ^%ZOSF("TEST") Q:'$T
	W:$D(IOF) @IOF,?25,"Ambulatory Surgery Sub-header Profile"
	S D0=IBCFN D ^IBXCPTC K X,DXS,D0
	Q
	;
DELGRP	;delete a sheets members - including the sheets sub-header members, and the entry in 44
	W !!,"Deleting SHEET members, please wait....",!!
	S IBPO="" F IBI=1:1 S IBPO=$O(^IBE(350.71,"AG",IBGRP,IBPO)) Q:IBPO=""  S IBCFN=$O(^(IBPO,"")) D DC1 S DIK="^IBE(350.71,",DA=IBCFN D ^DIK K DIK
	I $D(^SC("AF",IBGRP)) S IBCLN="" F  S IBCLN=$O(^SC("AF",IBGRP,IBCLN)) Q:IBCLN=""  S DA=IBCLN,DIE="^SC(",DR="25////@" D ^DIE K DIE,DIC,DR,DA,Y
ENDGP	K IBI,IBPO,IBCLN,DA
	Q
	;
DELCAT	;delete a sub-header's members
	W !!,"Deleting SUB-HEADER members, please wait...",!!
DC1	S IBPPO="" F IBJ=1:1 S IBPPO=$O(^IBE(350.71,"AS",IBCFN,IBPPO)) Q:IBPPO=""  S IBPFN=$O(^(IBPPO,"")) S DIK="^IBE(350.71,",DA=IBPFN D ^DIK K DIK
ENDCT	K IBJ,IBPPO,DA
	Q
	;
PRINT	;print the check-off sheet
	S DIR(0)="Y",DIR("A")="Print this SHEET",DIR("B")="NO" D ^DIR K DIR Q:'Y
	W !,"This report requires a 132 column printer."
	S %ZIS="QM" D ^%ZIS Q:POP
	I $D(IO("Q")) S ZTRTN="RQT^IBERSP",ZTSAVE("IBG("_IBGRP_")")="1",ZTDESC="A.S. Check-Off Sheet" D ^%ZTLOAD K IO("Q") D HOME^%ZIS Q
	U IO D CPT^IBERSP(IBGRP,"",0,DT,1) D ^%ZISC
	K ^TMP("IBRSC",$J),DTOUT,DUOUT,DIRUT,DIROUT,X,Y
	Q
