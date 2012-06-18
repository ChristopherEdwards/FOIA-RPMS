IBPU2	;ALB/BGA - IB PURGE FILE CLEAN UP ; 17-FEB-94
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	; This routine requires IBN from routine IBPP
	; and deletes entries in FILE #399
	;
	; The following procedures remove references which
	; point to the IBN about to be deleted. This routine is 
	; invoked by IBPU.
	;
	Q:'$G(IBN)
	D CLBCOM ;     deletes Rec from file 362.1
	D CLPSTE ;     deletes Rec from file 362.5
	D CLCTBI ;     deletes Rec from file 356.399
	D CLCTRK ;     deletes ptr from file 356  field .11
	D IBPBIL ;     sets the ptr in fld .17 to its self
	D IBCYTO ;     checks the ptr in fld .15
	Q
	;
CLBCOM	; uses "D" xref to find all recs to be deleted
	N IBA,DIK,DA
	S IBA="" F  S IBA=$O(^IBA(362.1,"D",IBN,IBA)) Q:'IBA  S DIK="^IBA(362.1,",DA=IBA D ^DIK
	Q
	;
CLPSTE	; uses "AIFN_IBN" to find all recs pointing to the rec to be deleted
	N IBA,IBB,REF,DIK,DA
	S REF="AIFN"_IBN
	F IBI=362.5,362.3,362.4 S (IBA,IBB)="" F  S IBA=$O(^IBA(IBI,REF,IBA)) Q:'IBA  F  S IBB=$O(^IBA(IBI,REF,IBA,IBB)) Q:'IBB  S DIK="^IBA("_IBI_",",DA=IBB D ^DIK
	Q
CLCTBI	; uses "C" xref to find all recs pointing to 399 then deletes
	N IBA,IBB,DIK,DA
	S IBA="" F  S IBA=$O(^IBT(356.399,"C",IBN,IBA)) Q:'IBA  S DIK="^IBT(356.399,",DA=IBA D ^DIK
	Q
CLCTRK	; uses "E" xref to find all recs ptr to 399 then sets them to null
	N IBA,DIE,DA,DR
	S IBA="" F  S IBA=$O(^IBT(356,"E",IBN,IBA)) Q:'IBA  S DIE="^IBT(356,",DA=IBA,DR=".11///@" D ^DIE
	Q
IBPBIL	; uses "AC" xref to find all recs ptr to 399 then sets to the bill #
	N IBA,DIE,DA,DR
	S IBA="" F  S IBA=$O(^DGCR(399,"AC",IBN,IBA)) Q:'IBA  I IBN'=IBA S DIE="^DGCR(399,",DA=IBA,DR=".17///"_IBA D ^DIE
	Q
IBCYTO	; uses "C" xref to find all recs ptr to 399 then sets the recs to null
	N IBA,IBB,DFN,DIE,DA,DR
	S (IBA,IBB)="",DFN=+$P($G(^DGCR(399,IBN,0)),U,2)
	F  S IBA=$O(^DGCR(399,"C",DFN,IBA)) Q:'IBA  I +$P($G(^DGCR(399,IBA,0)),U,15)=IBN S DIE="^DGCR(399,",DA=IBA,DR=".15///@"
	Q
