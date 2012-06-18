GMPLIPST	; SLC/MKB -- Problem List post-init rtn ;5/18/94  10:30
	;;2.0;Problem List;;Aug 25, 1994
EN	; entry point
	D ^GMPLONIT ; install protocols
	W !!,">>>  Installing List Templates ... " D ^GMPLIL
	I '$D(^GMT(142)) W !!,$C(7),">>>  HEALTH SUMMARY is not installed on this system!",!,"     After installing Health Summary, D HS^GMPLIPST to set up",!,"     Problem List components."
	E  D HS
	D CKPARAM ; ck Verify parameter w/PL menu for Verify action
	I +$O(^AUPNPROB(0)),'$D(^AUPNPROB("C")) D  ; set new Xrefs for PCE sites
	. W !!,">>>  Setting new 'ACTIVE' and 'C' cross-references ..."
	. S DIK="^AUPNPROB(",DIK(1)=".12^ACTIVE" D ENALL^DIK W "."
	. S DIK="^AUPNPROB(",DIK(1)="1.01^C" D ENALL^DIK W "."
	S XQORM=$O(^ORD(101,"B","GMPL HIDDEN MENU",0))_";ORD(101,"
	D XREF^XQORM K XQORM ; recompile menu in ^XUTL
EN1	; Populate fld 1.7 in Service file, set new Xref
	I '$D(^DIC(49,"ACHLD")) S DIK="^DIC(49,",DIK(1)="1.6^ACHLD" D ENALL^DIK
	W !!!,">>>  Please update your Service file (#49) at this time ..."
	D ^GMPLISRV
	D TIME
	Q
HS	; install Health Summary components
	N DIE,DIF,XCNP,XCN,DIC,DLAYGO,DINUM,X,Y,HSVER,INCLUDE
	W !!,">>>  Installing Health Summary components ... "
	S HSVER=$G(^DD(142,0,"VR"))
	W !,"'GMTSPLST' Routine..."
	S X="GMPLHSPL",XCNP=0,DIF="^UTILITY(""GMPLHSPL""," X ^%ZOSF("LOAD")
	S X="GMTSPLST",XCN=2,DIE="^UTILITY(""GMPLHSPL""," X ^%ZOSF("SAVE")
	W "Filed." K ^UTILITY("GMPLHSPL")
HS1	; filing components in HEALTH SUMMARY COMPONENT FILE
	W !,"'PROBLEM LIST ACTIVE' Component..."
	S (DIC,DLAYGO)=142.1,DIC(0)="NXL",X="PROBLEM LIST ACTIVE",DINUM=59
	D ^DIC I +Y'>0 W $C(7),"Could not install." G HS2
	S DIE=DIC,DA=+Y,DR="1///^S X=""ACTIVE""_$C(59)_""GMTSPLST"";3///PLA"
	I HSVER>1.2 S DR=DR_";9///Active Problems"
	D ^DIE
	S ^GMT(142.1,+DA,3.5,0)="^^1^1^"_DT_"^"
	S ^GMT(142.1,+DA,3.5,1,0)="This component lists all known active problems for a patient."
	W "Filed."
HS2	W !,"'PROBLEM LIST INACTIVE' Component..."
	S (DIC,DLAYGO)=142.1,DIC(0)="NXL",X="PROBLEM LIST INACTIVE",DINUM=60
	D ^DIC I +Y'>0 W $C(7),"Could not install." G HS3
	S DIE=DIC,DA=+Y,DR="1///^S X=""INACT""_$C(59)_""GMTSPLST"";3///PLI"
	I HSVER>1.2 S DR=DR_";9///Inactive Problems"
	D ^DIE
	S ^GMT(142.1,+DA,3.5,0)="^^1^1^"_DT_"^"
	S ^GMT(142.1,+DA,3.5,1,0)="This component lists all known inactive problems for a patient."
	W "Filed."
HS3	W !,"'PROBLEM LIST ALL' Component..."
	S (DIC,DLAYGO)=142.1,DIC(0)="NXL",X="PROBLEM LIST ALL",DINUM=61
	D ^DIC I +Y'>0 W $C(7),"Could not install." G HSADH
	S DIE=DIC,DA=+Y,DR="1///^S X=""ALL""_$C(59)_""GMTSPLST"";3///PLL"
	I HSVER>1.2 S DR=DR_";9///All Problems"
	D ^DIE
	S ^GMT(142.1,+DA,3.5,0)="^^2^2^"_DT_"^"
	S ^GMT(142.1,+DA,3.5,1,0)="This component lists all known problems, both active and inactive,",^GMT(142.1,+DA,3.5,2,0)="for a patient."
	W "Filed."
HSADH	; add components to Ad Hoc HS
	W !!,">>>  Installing new components in Ad Hoc Health Summary ..."
	S INCLUDE=0 D ENPOST^GMTSLOAD
	Q
	;
TIME	; Write start and stop times for inits
	N %,%H,%I,X,Y D NOW^%DTC,YX^%DTC S GMPLSTOP=Y
	W !!!,"Initialization started:   "_$G(GMPLSTRT)
	W !,"Initialization finished:  "_GMPLSTOP,!
	K GMPLSTOP,GMPLSTRT
	Q
	;
CKPARAM	; Ck PL menu for Verify action based on parameter
	N PARAM,MENU,VERFY,BLANK,DIE,DR,DA
	S PARAM=$P($G(^GMPL(125.99,1,0)),U,2)
	S DA(1)=$O(^ORD(101,"B","GMPL PROBLEM LIST",0))
	S VERFY=$O(^ORD(101,"B","GMPL VERIFY",0)),DA=$O(^ORD(101,DA(1),10,"B",+VERFY,0))
	S MNEM=$P($G(^ORD(101,DA(1),10,DA,0)),U,2),BLANK="       "
	Q:PARAM&(MNEM="$")  Q:'PARAM&(MNEM="")  ; ok
	S DR=$S(PARAM:"2////$;6///@",1:"2///@;6///^S X=BLANK")
	S DIE="^ORD(101,"_DA(1)_",10," D ^DIE
	Q
