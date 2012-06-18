IBERSI	;ALB/ARH - LIST/DELETE INACTIVE CODES FROM COS; 5/27/92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;determine option from user
EN	S DIR("?")="List and/or delete CPT codes on Check-Off Sheets that are AMA inactive or that are Nationally, Locally, and Billing inactive."
	S DIR(0)="SO^1:LIST INACTIVE CODES ON CHECK-OFF SHEETS;2:DELETE INACTIVE CODES FROM CHECK-OFF SHEET;"
	D ^DIR K DIR G:$D(DIRUT)!'Y EXIT S IBOPT=Y
	D ^IBOCOSI:IBOPT=1,EN1:IBOPT=2 S IBOPT=0 G EN
	;
EXIT	K X,Y,DIRUT,DTOUT,DUOUT,DIROUT,IBOPT
	Q
	;
EN1	;delete CPTs from COS
	;***
	;S XRTL=$ZU(0),XRTN="IBERSI-1" D T0^%ZOSV ;start rt clock
	;
	S DIR("?")="Delete CPT codes on Check-Off Sheets that are AMA inactive"
	S DIR(0)="Y",DIR("A")="DELETE AMA INACTIVE CODES",DIR("B")="No"
	D ^DIR K DIR G:$D(DIRUT) END1 I Y=1 S IBAMA=1
	S DIR("?")="Delete CPT codes on Check-Off Sheets that are Nationally, Locally, and Billing inactive."
	S DIR(0)="Y",DIR("A")="DELETE OTHER INACTIVE CODES",DIR("B")="No"
	D ^DIR K DIR G:$D(DIRUT) END1 I Y=1 S IBNLB=1
	I $D(IBAMA)!($D(IBNLB)) W !,"Deleting" D DEL
END1	K X,Y,DIRUT,DTOUT,DUOUT,DIROUT,IBAMA,IBNLB
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBERSI" D T1^%ZOSV ;stop rt clock
	Q
	;
DEL	;delete inactive codes from check-off sheets
	S IBCPT="" F  S IBCPT=$O(^IBE(350.71,"P",IBCPT)) Q:IBCPT=""  S IBX="" F  S IBX=$O(^IBE(350.71,"P",IBCPT,IBX)) Q:IBX=""  D
	. S IBLN=$G(^IBE(350.71,IBX,0)),IBSTAT=+$$CPTSTAT^IBEFUNC2(+$P(IBLN,"^",6)) Q:IBSTAT>1
	. I ($D(IBAMA)&('IBSTAT))!($D(IBNLB)&(IBSTAT)) S DIK="^IBE(350.71,",DA=IBX D ^DIK K DIK,DA
	K IBSTAT,IBCPT,IBX,IBLN
	Q
