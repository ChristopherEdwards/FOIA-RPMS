IBCSC4E	;ALB/ARH - ADD/ENTER PTF/OE DIAGNOSIS  ; 3/2/94
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
	;
PTFASK	;
	D PTF Q:$G(IBPTFDX)'>0  N X,Y K IBLIST W !
PTFASK1	S DIR("A")="SELECT DIAGNOSIS FROM THE PTF RECORD TO INCLUDE ON THE BILL"
	S DIR("?",1)="Enter the alphanumeric preceding the diagnosis you want added to the bill.",DIR("?",2)=""
	S DIR("?",3)="To enter more than one separate them by a comma or within a movement use a range separated by a dash.",DIR("?")="The print order for each diagnosis will be determined by the order in this list."
	S DIR(0)="FO^^D ITPTF^IBCSC4E" D ^DIR K DIR Q:$D(DIRUT)!(Y="")
	;
	S X=Y D ITPTF S IBLIST=X,DIR("A",1)="YOU HAVE SELECTED "_X_" TO BE ADDED TO THE BILL",DIR("A")="IS THIS CORRECT",DIR("B")="YES"
	S DIR(0)="YO" D ^DIR K DIR I $D(DIRUT) K IBLIST Q
	I 'Y G PTFASK1
	Q
	;
PTF	;
	Q:'$D(^UTILITY($J,"IBDX"))  N IBX,IBY,IBZ,IBORD K IBPTFDX S IBORD="",IBPTFDX=0
	S IBX=0 F  S IBX=$O(^UTILITY($J,"IBDX",IBX)) Q:'IBX  S IBY=0 F  S IBY=$O(^UTILITY($J,"IBDX",IBX,IBY)) Q:'IBY  D
	. S IBZ=^UTILITY($J,"IBDX",IBX,IBY) I IBY=1 S IBORD=$P(IBZ,U,3)
	. I IBORD'="" S IBPTFDX(IBORD)=IBY I '$D(^IBA(362.3,"AIFN"_+$G(IBIFN),+IBZ)) S IBPTFDX=IBPTFDX+1
	Q
	;
ITPTF	;
	N IBI,IB1,IB2,IBJ,IBX,IBY,IBZ,IBA
	S IBA="",IBX=X
	F IBI=1:1 S IBY=$P(IBX,",",IBI) Q:IBY=""  D  Q:'$D(X)  S X=IBA
	. I IBY["-" S IBZ=$P(IBY,"-",1),IB2=$P(IBY,"-",2) D  Q:'$D(X)
	.. I $E(IBZ,1)'=$E(IB2,1) K X Q
	.. S IBY="",IB1=$E(IBZ,2,999),IB2=$E(IB2,2,999),IBZ=$E(IBZ,1) I +IB2'>+IB1 K X Q
	.. F IBJ=IB1:1:IB2 S IBY=IBY_IBZ_IBJ_"-" I IBJ>$G(IBPTFDX(IBZ)) Q
	. F IBJ=1:1 S IB1=$P(IBY,"-",IBJ) Q:IB1=""  S IB2=$E(IB1,1),IB3=$E(IB1,2,99) D  Q:'$D(X)
	.. I IB2=""!'IB3 K X Q
	.. I '$D(IBPTFDX(IB2)) K X Q
	.. I IB3>+$G(IBPTFDX(IB2)) K X Q
	.. S IBA=IBA_IB2_IB3_","
	Q
	;
PTFADD(IBIFN,LIST)	;
	Q:'$D(^UTILITY($J,"IBDX"))!($G(LIST)="")!('$G(IBIFN))  N IBX,IBY,IBI,IBCD,IB1,IB2
	F IBI=1:1 S IBCD=$P(LIST,",",IBI) Q:IBCD=""  D
	. S IB1=$E(IBCD,1),IB2=$E(IBCD,2,999) Q:IB1=""!'IB2
	. S IBX=0 F  S IBX=$O(^UTILITY($J,"IBDX",IBX)) Q:'IBX  D
	.. I $P($G(^UTILITY($J,"IBDX",IBX,1)),U,3)=IB1 S IBDX=$P($G(^UTILITY($J,"IBDX",IBX,IB2)),U,1) I '$D(^IBA(362.3,"AIFN"_IBIFN,IBDX)) I $$ADD^IBCSC4D(IBDX,IBIFN) W "."
	Q
	;
NEWDX(IBX)	;
	Q:'$G(IBX)  N X,Y K IBLIST W !
NEWDX1	S DIR("?",1)="Enter the number preceding the Diagnosis you want added to the bill.",DIR("?",2)="Multiple entries may be added separated by commas or ranges separated by a dash."
	S DIR("?")="The diagnosis will be added to the bill with a print order corresponding to its position in this list."
	S DIR("A")="SELECT NEW DIAGNOSES TO ADD THE BILL"
	S DIR(0)="LO^1:"_+IBX D ^DIR K DIR G:'Y!$D(DIRUT) NEWDXE
	S IBLIST=Y
	;
	S DIR("A")="YOU HAVE SELECTED "_IBLIST_" TO BE ADDED TO THE BILL IS THIS CORRECT",DIR("B")="YES"
	S DIR(0)="YO" D ^DIR K DIR I $D(DIRUT) K IBLIST G NEWDXE
	I 'Y G NEWDX1
NEWDXE	Q
	;
ADDNEW(IBIFN,LIST,IBOEA)	;
	Q:'LIST  N IBI,IBX,IBDX,IBDT,IBQ,IBY,IBPIFN,IBZ
	F IBI=1:1 S IBX=$P(LIST,",",IBI) Q:'IBX  I $D(IBOEA(IBX)) D
	. S IBDX=+IBOEA(IBX) I $D(^IBA(362.3,"AIFN"_IBIFN,IBDX)) Q
	. I $$ADD^IBCSC4D(IBDX,IBIFN) W "."
	Q
