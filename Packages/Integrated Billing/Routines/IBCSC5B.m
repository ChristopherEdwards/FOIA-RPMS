IBCSC5B	;ALB/ARH - ADD/ENTER PROSTHETIC ITEMS ; 12/28/93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
EN	;add/edit prosthetic items for a bill, IBIFN required
	S IBX=$$BILL(IBIFN) Q:'IBIFN  S DFN=+IBX,IBDT1=$P(IBX,U,2),IBDT2=$P(IBX,U,3)
	D SET(IBIFN,.IBPDA),PIDISP(DFN,IBDT1,IBDT2,.IBPDE,.IBPDA),DISP(.IBPDA)
E1	S IBPIFN=0,IBDT=$$ASKDT(IBDT1,IBDT2) G:'IBDT EXIT
	S IBPD=$O(IBPDA(IBDT,0)) S:'IBPD IBPD=$O(IBPDE(IBDT,0)) S IBPD=$$ASKPD(IBPD) G:'IBPD E1
	S IBPIFN=$G(IBPDA(IBDT,+IBPD)) I 'IBPIFN S IBPIFN=$$ADD(IBDT,IBIFN,+IBPD,+$G(IBPDE(IBDT,+IBPD))) I 'IBPIFN W " ??" G E1
	I '$D(IBPDE(IBDT,+IBPD)) W !,"This prosthetic item does not exist in this patients prosthetics record.",!
	D EDIT(+IBPIFN) D SET(IBIFN,.IBPDA) W ! G E1
	;
EXIT	K IBPIFN,IBX,IBDT1,IBDT2,IBPDA,IBPDE,IBPD,IBDT
	Q
	;
ASKDT(IBDT1,IBDT2,IBDT)	;
	I +$G(IBIFN) S DIR("?")="Enter the date the item was dilivered to the patient",DIR("??")="^D HELP^IBCSC5B("_IBIFN_")"
	S DIR("A")="Select ITEM DELIVERY DATE",DIR(0)="DO^"_IBDT1_":"_IBDT2_":EX" D ^DIR K DIR,DTOUT,DIRUT
	Q $S(Y?7N:Y,1:0)
	;
ASKPD(PD)	;
	N X,Y
	S DIR("A")="Select PROSTHETIC ITEM",DIR(0)="660,4O" S:+$G(PD) DIR("B")=+$G(^RMPR(661,+$G(PD),0)) D ^DIR S:$D(DIRUT)!(Y'>0) Y="" K DIR,DIRUT
	Q Y
	;
ADD(IBDT,IFN,IBPD,PIFN)	;
	N IBX S IBX=0,DIC="^IBA(362.5,",DIC(0)="AQL",X=IBDT K DA,DO D FILE^DICN K DA,DO,X
	I Y>0 S DIE=DIC,(IBX,DA)=+Y,DR=".02////"_IFN_";.03////"_IBPD_";.04////"_PIFN D ^DIE K DIE,DIC,DA,DR W "... ADDED"
	Q IBX
	;
EDIT(PIFN)	;
	S DIDEL=362.5,DIE="^IBA(362.5,",DR=".01;.03",DA=PIFN D ^DIE K DIE,DR,DA,DIC,DIDEL
	Q
	;
SET(IFN,PDARR)	;setup array of all prosthetic devices for bill, array name should be passed by reference
	;returns: PDARR(PD DELIV DATE, PD ITEM (661 ptr))=PD IFN (362.5 ptr),  PDARR=BILL IFN ^ PD count
	N CNT,IBX,IBY,PIFN,IBC K PDARR S IBC="AIFN"_$G(IFN)
	S (CNT,IBX)=0 F  S IBX=$O(^IBA(362.5,IBC,IBX)) Q:'IBX  S PIFN=0 F  S PIFN=$O(^IBA(362.5,IBC,IBX,PIFN)) Q:'PIFN  D
	. S IBY=$G(^IBA(362.5,PIFN,0)) Q:IBY=""  S CNT=CNT+1,PDARR(+IBY,$P(IBY,U,3))=PIFN
	S PDARR=$G(IFN)_"^"_CNT
	Q
	;
DISP(PDARR)	;screen display of existing prosthetic devices for a bill,
	;input should be array returned by SET^IBCSC5B: PDARR(PD DT, PD ITEM)=PD IFN (362.5), pass by reference
	N IBX,IBY,IBZ
	W !!,?5,"-----------------  Existing Prosthetic Items for Bill  -----------------",!
	S IBX=0 F  S IBX=$O(PDARR(IBX)) Q:IBX=""  S IBY=0 F  S IBY=$O(PDARR(IBX,IBY)) Q:'IBY  D
	. S IBZ=$$PIN(IBY) W !,$$DATE(IBX),?12,$P(IBZ,U,1),?20,$P(IBZ,U,2)
	W !
	Q
	;
HELP(IFN)	;called for help from prosthetics enter to display existing devices, displays devices from 660 and 399
	I +$G(IFN) N IBX,IBPDA S IBX=$$BILL(IFN) I +IBX D SET(IFN,.IBPDA),PIDISP($P(IBX,U,1),$P(IBX,U,2),$P(IBX,U,3),"",.IBPDA),DISP(.IBPDA)
	Q
	;
PIDISP(DFN,DT1,DT2,ARRAY,PDARR)	; display all prosthetic items (660) for a patient and date range
	;PDARR (as defined by SET^IBCSC5B) passed by ref. only to check if pros. item is on the bill, not necessary, not changed
	;returns ARRAY(PD DEL DATE (660,10), PD ITEM (660,4=661 ptr))=RECORD (660 ptr), should pass by ref. if desired
	N PIFN,IBX,IBY,PNAME,DDT,PI K ARRAY S DT1=$G(DT1)-.0001,DT2=$G(DT2) S:'DT2 DT2=9999999 Q:'$G(DFN)
	S PIFN=0 F  S PIFN=$O(^RMPR(660,"C",DFN,PIFN)) Q:'PIFN  D
	. S IBX=$G(^RMPR(660,PIFN,0)),DDT=+$P(IBX,U,12)\1 I (DDT<DT1)!(DDT>DT2) Q
	. S ARRAY(DDT,+$P(IBX,U,6))=PIFN
	;
	W @IOF,?33,"PROSTHETICS SCREEN",!,"================================================================================",!
	S DDT=0 F  S DDT=$O(ARRAY(DDT)) Q:'DDT  S PI=0 F  S PI=$O(ARRAY(DDT,PI)) Q:'PI  D
	. S PIFN=ARRAY(DDT,PI),PNAME=$$PIN(PI),IBY=$G(^RMPR(660,PIFN,"AM")),IBX=$G(^RMPR(660,PIFN,0))
	. W !,$S($D(PDARR(+DDT,PI)):"*",1:"")
	. W ?2,$$DATE(DDT),?12,$P(PNAME,U,1),?20,$E($P(PNAME,U,2),1,30),?55,$E($$EXSET^IBEFUNC($P(IBX,U,14),660,12),1,4),?62,$$EXSET^IBEFUNC($P(IBY,U,3),660,62),?70,$J(+$P(IBX,U,16),9,2)
	Q
	;
PIN(PITEM)	;given the pros item IFN (661 ptr) returns name for printing (661,.01^441,.05)
	N IBX,IBY S IBY="" I +$G(PITEM) S IBX=+$G(^RMPR(661,+PITEM,0)) I +IBX S IBY=IBX_U_$$DESCR^PRCPUX1(0,+IBX)
	Q IBY
	;
BILL(IBIFN)	; display all existing prescription refills (52) for a patient and date range
	; (call is a short cut to calling rxdisp if have bill number)
	N IBX,IBY S IBX=$G(^DGCR(399,+$G(IBIFN),0)),IBY=$P(IBX,U,2)
	S IBX=$G(^DGCR(399,+IBIFN,"U")),$P(IBY,U,2)=+IBX,$P(IBY,U,3)=+$P(IBX,U,2)
	Q IBY
	;
DATE(X)	;
	Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
