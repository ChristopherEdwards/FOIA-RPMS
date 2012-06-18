IBCF33	;ALB/ARH - UB92 HCFA-1450 (GATHER CODES) ;25-AUG-1993
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;IBIFN,IBCBILL,IBSTATE required
	;find statements to print on bill
	S IBSTATE=$G(^DGCR(399,IBIFN,"U")),IBCBCOMM=$G(^DGCR(399,IBIFN,"U1")),IBCBILL=$G(^DGCR(399,IBIFN,0)),IBINPAT=$S($P(IBCBILL,U,5)<3:1,1:0),IBCOL=1
	D ^IBCF34
	;
	I +IBINPAT S IBX=$P(IBSTATE,U,15),IBZ=+IBX_" DAY"_$S(IBX'=1:"S",1:"")_" INPATIENT CARE",IBCOL=0 D SET2 S IBZ="" D SET2
	;
RV	;rev codes sorted by bedsection
	S IBBSN=0,IBBS=0 F  S IBBS=$O(^DGCR(399,IBIFN,"RC","ABS",IBBS)) Q:'IBBS  D
	. S IBRV=0 F  S IBRV=$O(^DGCR(399,IBIFN,"RC","ABS",IBBS,IBRV)) Q:'IBRV  D
	.. S IBDA=0 F  S IBDA=$O(^DGCR(399,IBIFN,"RC","ABS",IBBS,IBRV,IBDA)) Q:'IBDA  D
	... S IBX=$G(^DGCR(399,IBIFN,"RC",IBDA,0))
	... S IBZ=$P($G(^DGCR(399.1,+$P(IBX,U,5),0)),U,1) D:IBZ'=IBBSN SET2 S IBBSN=IBZ,IBZ=IBX D SET1
	;
	;loop through all rev codes, print those with no bedsection
	S IBDA=0 F  S IBDA=$O(^DGCR(399,IBIFN,"RC",IBDA)) Q:'IBDA  S IBZ=$G(^(IBDA,0)) I +IBZ,$P(IBZ,U,5)="" D SET1
	;
TOTAL	;add totals (print subtotal only if there is an offset)
	I +$P(IBCBCOMM,U,2) S IBZ="",$P(IBZ,U,2)="SUBTOTAL",$P(IBZ,U,4)=+$P(IBCBCOMM,U,1) D SET1
	;
	S IBX=$S(+$P(IBCBCOMM,U,2):4,1:2) D SPACE
	S IBZ="" D SET2
	I +$P(IBCBCOMM,U,2) S IBZ="",$P(IBZ,U,2)="LESS "_$P(IBCBCOMM,U,3),$P(IBZ,U,4)=+$P(IBCBCOMM,U,2) D SET1 S IBZ="" D SET2
	;
	S IBZ="001",$P(IBZ,U,2)="TOTAL",$P(IBZ,U,4)=+($P(IBCBCOMM,U,1)-$P(IBCBCOMM,U,2)) D SET1
	;
	;
CPT	;add addtional procedures
	G:$G(IBFL(80))'>6 OPV S IBX=+IBFL(80)-4 D SPACE
	S IBZ="" D SET2
	S IBZ="ADDITIONAL PROCEDURE CODES:" D SET2
	S IBI=6 F  S IBI=$O(IBFL(80,IBI)) Q:'IBI  D
	. S IBX=$P(IBFL(80,IBI),U,2),IBZ=$E(IBX,1,2)_"/"_$E(IBX,3,4)_"/"_$E(IBX,5,6)_$J(" ",5)_$P(IBFL(80,IBI),U,1) D SET2
	;
OPV	;add outpatient visit dates
	G:'$O(^DGCR(399,IBIFN,"OP",0)) CONT S (IBX,IBY)=0 F  S IBX=$O(^DGCR(399,IBIFN,"OP",IBX)) Q:'IBX  S IBY=IBY+1
	S IBX=IBY/3,IBX=IBX\1+$S(+$P(IBX,".",2):1,1:0)+1 D SPACE
	S IBZ="" D SET2 S IBZ="OP VISIT DATE(S) BILLED:"_$J(" ",34-24)
	S (IBI,IBJ)=0 F  S IBI=$O(^DGCR(399,IBIFN,"OP",IBI)) Q:'IBI  D
	. S Y=$G(^DGCR(399,IBIFN,"OP",IBI,0)) X ^DD("DD") S IBZ=IBZ_Y_$S($O(^DGCR(399,IBIFN,"OP",IBI)):", ",1:"")
	. S IBJ=IBJ+1 I IBJ>2 D SET2 S IBZ=$J(" ",34),IBJ=0
	I $L(IBZ)>34 D SET2
	;
CONT	D ^IBCF331
	;
	; fill in rest of page
END	D FILLPG S $P(^TMP($J,"IBC-RC"),U,2)=0 S IBPG=+$G(^TMP($J,"IBC-RC")),IBX=IBPG/23,IBPG=IBX\1+$S(+$P(IBX,".",2):1,1:0)
	K IBZ,IBBSN,IBBS,IBRV,IBDA,IBLN,IBCOL,IBLINES,IBARRAY
	Q
	;
SPACE	;checks to see if X can fit on page, if not starts new page
	Q:'IBX  N IBLN,IBY S IBLN=+$G(^TMP($J,"IBC-RC")),IBY=IBLN#23 S:IBY=0&(IBLN'=0) IBY=23 I IBX>(IBLINES-IBY) D FILLPG
	Q
	;
FILLPG	;fill reast of page with blank lines
	N IBI,IBLN,IBZ S IBFILL=1 F IBI=1:1:23 S IBLN=+$G(^TMP($J,"IBC-RC")) Q:'(IBLN#23)  S IBZ="" D SET2 Q:IBFILL=2
	K IBFILL Q
	;
SET1	; add rev codes to array: rev cd ^ rev cd st abbrev. ^ CPT CODE ^ unit charge ^ units ^ total
	;formats for output into specific column blocks 42-48 
	N IBX,IBY,IBLN D NEXTLN S IBY=""
	;set up rev cd item with approprite output values, non-rev cd entries should already be in external form
	I +IBZ S IBX=$G(^DGCR(399.2,+IBZ,0)) Q:IBX=""  S IBY=$P(IBX,U,1)_U_$P(IBX,U,2)_U_$P($G(^ICPT(+$P(IBZ,U,6),0)),U,1)_U_$P(IBZ,U,2)_U_$P(IBZ,U,3)_U_$P(IBZ,U,4)
	I IBY="" S IBY=$P(IBZ,U,1)_U_$P(IBZ,U,2)_U_U_U_$P(IBZ,U,3)_U_$P(IBZ,U,4)
	S IBLN=+$G(^TMP($J,"IBC-RC"))+1,^TMP($J,"IBC-RC",IBLN)=1_U_IBY,^TMP($J,"IBC-RC")=IBLN I '(IBLN#23) S IBLINES=23
	Q
	;
SET2	;set free text into block 42 array
	N IBLN D NEXTLN S IBCOL=$S('IBCOL:2,1:3)
	S IBLN=+$G(^TMP($J,"IBC-RC"))+1 I IBLN#23=1,$G(IBFILL) S IBFILL=2 Q
	S ^TMP($J,"IBC-RC",IBLN)=IBCOL_U_IBZ,^TMP($J,"IBC-RC")=IBLN I '(IBLN#23) S IBLINES=23
	Q
	;
NEXTLN	;checks counter for next line, resets if necessary,
	;ie. if the line # indicated by the next line # var. has already been used then this increments the next line # var.
	S IBLN=+$G(^TMP($J,"IBC-RC"))+1 I $D(^TMP($J,"IBC-RC",IBLN)) S ^TMP($J,"IBC-RC")=IBLN S:'(IBLN#23) IBLINES=23 G NEXTLN
	Q
