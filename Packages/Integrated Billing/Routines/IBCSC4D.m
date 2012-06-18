IBCSC4D	;ALB/ARH - ADD/ENTER DIAGNOSIS  ; 11/9/93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
EN	;add/edit diagnosis for a bill, IBIFN required
	S IBX=$G(^DGCR(399,+IBIFN,0)) D SET(IBIFN,.IBDXA,"")
	I $P(IBX,U,5)<3 D PTFASK^IBCSC4E I $D(IBLIST) D PTFADD^IBCSC4E(IBIFN,IBLIST)
	I $P(IBX,U,5)>2 S DFN=$P(IBX,U,2),IBX=$G(^DGCR(399,+IBIFN,"U")) D OPTDX(DFN,$P(IBX,U,1),$P(IBX,U,2),.IBOEDX,.IBDXA),DISPOE(.IBOEDX,.IBDXA)
	I +$P($G(IBOEDX),U,2) D NEWDX^IBCSC4E(+IBOEDX) I $D(IBLIST) D ADDNEW^IBCSC4E(IBIFN,IBLIST,.IBOEDX)
	S IBDIFN=0 D SET(IBIFN,.IBDXA,.IBPOA) D:+IBDXA DISP(.IBPOA)
E1	S IBDX=$$ASKDX I +IBDX>0 S IBDIFN=+$G(IBDXA(+IBDX)) S:'IBDIFN IBDIFN=$$ADD(+IBDX,IBIFN) I +IBDIFN>0 D EDIT(+IBDIFN) D SET(IBIFN,.IBDXA,.IBPOA) G E1
	;
EXIT	K IBDIFN,IBDXA,IBPOA,IBDX,IBX,IBOEDX,IBLIST
	Q
	;
ASKDX()	;
	N X,Y
	;S DIR("A")="Select ICD DIAGNOSIS",DIR(0)="362.3,.01O" D ^DIR K DIR
AD	S DIR("??")="^D HELP^IBCSC4D",DIR("?",1)="Enter a diagnosis for this bill.  Duplicates are not allowed.",DIR("?")="Only active diagnosis, no duplicates for a bill, and bill must not be authorized or cancelled."
	S DIR(0)="PO^80:EAMQ" D ^DIR K DIR I Y>0,'$D(IBDXA(+Y)),+$P($G(^ICD9(+Y,0)),U,9) W " ... dx inactive." G AD
	Q Y
	;
ADD(DX,IFN)	;
	S DIC="^IBA(362.3,",DIC(0)="AQL",DIC("DR")=".02////"_IFN,X=DX K DA,DO D FILE^DICN K DA,DO,DIC,X
	Q Y
	;
EDIT(DIFN)	;
	S DIDEL=362.3,DIE="^IBA(362.3,",DR=".01;.03",DA=DIFN D ^DIE K DIE,DR,DA,DIC,DIDEL
	Q
	;
SET(IFN,DXARR,POARR)	;setup arrays of all dx's for bill, array names should be passed by reference
	;returns: DXARR(DX)=DX IFN, POARR(ORDER)=DX ^ PRINT ORDER,  (DXARR,POARR)=IFN ^ dx count
	;if a dx does not have a print order then PRINT ORDER=(999+count of dx) so will be in order of entry if no print order
	N CNT,IBX,IBY,IBZ,DIFN,IBC,ARR K DXARR,POARR S IBC="AIFN"_$G(IFN)
	S (CNT,IBX)=0 F  S IBX=$O(^IBA(362.3,IBC,IBX)) Q:'IBX  D
	. S DIFN=$O(^IBA(362.3,IBC,IBX,0)),IBY=$G(^IBA(362.3,DIFN,0)) Q:'IBY
	. S CNT=CNT+1,IBZ=+$P(IBY,U,3) I 'IBZ S IBZ=999+CNT
	. S DXARR(+IBY)=DIFN,ARR(IBZ)=+IBY_"^"_$P(IBY,U,3)
	S (IBX,IBY)=0 F  S IBY=$O(ARR(IBY)) Q:'IBY  S IBX=IBX+1,POARR(IBX)=ARR(IBY)
	S (DXARR,POARR)=$G(IFN)_"^"_CNT
	Q
	;
DISP(POARR)	;screen display of existing dx's for a bill,
	;input should be print order array returned by SET^IBCSC4D: POARR(PRINT ORDER)=DX, passed by reference
	N IBX,IBY,IBZ
	W !!,?5,"-----------------  Existing Diagnoses for Bill  -----------------",!
	S IBX=0 F  S IBX=$O(POARR(IBX)) Q:'IBX  S IBZ=POARR(IBX),IBY=$G(^ICD9(+IBZ,0)) D
	. W !,?12,$P(IBY,U,1),?26,$P(IBY,U,3),?60,$S($P(IBZ,U,2)<1000:"("_$P(IBZ,U,2)_")",1:"")
	W !
	Q
	;
DISP1(IFN)	;
	I +$G(IFN) N POARR D SET(IFN,"",.POARR),DISP(.POARR)
	Q
HELP	;called for help from dx enter to display existing dx's
	Q:'$G(IBIFN)  N IBX
	D SET(IBIFN,.IBDXA,"") S IBX=$G(^DGCR(399,+IBIFN,0)) I IBX="" Q
	I $P(IBX,U,5)>2 S DFN=$P(IBX,U,2),IBX=$G(^DGCR(399,+IBIFN,"U")) D OPTDX(DFN,$P(IBX,U,1),$P(IBX,U,2),.IBOEDX,.IBDXA),DISPOE(.IBOEDX,.IBDXA)
	D SET(IBIFN,.IBDXA,.IBPOA) D:+IBDXA DISP(.IBPOA)
	Q
	;
ADD1(IFN)	;does not work, but it should replace ask add, and edit
	;S DIC="^IBA(362.3,",DIC(0)="EMAQ",D="AIFN"_$G(IFN) D IX^DIC K DA,DO,DIC,D
	Q
	;
OPTDX(DFN,DT1,DT2,ARRAY,IBDXA)	;
	N IBDT,IBOE,IBDX,IBCNT,IBCNT1,ARR K ARRAY S (IBCNT,IBCNT1)=0,DT1=$G(DT1)-.0001,DT2=$S(+$G(DT2):DT2,1:9999999)+.7999
	S IBDT=DT1 F  S IBDT=$O(^SCE("ADFN",DFN,IBDT)) Q:'IBDT!(IBDT>DT2)  D
	. S IBOE=0 F  S IBOE=$O(^SCE("ADFN",DFN,IBDT,IBOE)) Q:'IBOE  D
	.. S IBDX=0 F  S IBDX=$O(^SDD(409.43,"AO",IBOE,IBDX)) Q:'IBDX  D
	... I '$D(ARR(IBDX)) S IBCNT=IBCNT+1,ARRAY(IBCNT)=IBDX,ARR(IBDX)="" I '$D(IBDXA(IBDX)) S IBCNT1=IBCNT1+1
	S ARRAY=IBCNT_"^"_IBCNT1
	Q
	;
DISPOE(OEARR,EXARR)	;
	N IBCNT,IBDX,IBX  W @IOF,!,"============================= DIAGNOSIS SCREEN ==============================",!
	S IBCNT=0 F  S IBCNT=$O(OEARR(IBCNT)) Q:'IBCNT  S IBDX=$G(^ICD9(+OEARR(IBCNT),0)) D
	. S IBX="" I $D(EXARR(+OEARR(IBCNT))) S IBX="*"
	. W !,$J(IBCNT,2),")",?11,IBX,?12,$P(IBDX,U,1),?26,$P(IBDX,U,3)
	Q
