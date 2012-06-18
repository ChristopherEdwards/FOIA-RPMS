IBCD5	;ALB/ARH - AUTOMATED BILLER (INPT DT RANGE) ; 8/6/93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
	;continuation of IBCD1
INP	;Inpatient Admissions   (IBTRN,IBTYP,IBDFN,IBEVDT)
	;get statement from and to dates based on previous non-final bills or event date and billing cycle, check that range is within admit-discharge, not previously billed, and BC + DD is not greater than current date, PTF status
	;^TMP("IBC1",$J, PATIENT , START DT ^ TO DT , EVENT IFN)= TIMEFRAME
	;
	S IBX=$P($G(^IBT(356,IBTRN,0)),U,5),IBAD=$$AD^IBCU64(IBX),IBDIS=+$P(IBAD,U,2)\1 I 'IBAD!('$P(IBAD,U,4))  D  G INPQ
	. I 'IBAD D TERR(IBTRN,0,"Patient Admission Movement Data not found.")
	. D TERR(IBTRN,0,"Admission movement missing PTF number.")
	;
	S IBX=$G(^DGPT(+$P(IBAD,U,4),0)) I 'IBX D TERR(IBTRN,0,"PTF record for Admission movement was not found.") G INPQ
	I '$P(IBX,U,6)!(+$P(IBPAR7,U,3)>+$P(IBX,U,6)) G INPQ ; check PTF status, PTF record must be at least closed or status entered by site before and auto bill can be created
	;
	; find latest bill dates for record, if a final bill or a non riemb. ins bill exit
	S IBLBDT=$$BILLED^IBCU3($P(IBAD,U,4)) I +IBLBDT,('$P(IBLBDT,U,2)!($P(IBLBDT,U,3)'=8)) D  G INPQ
	. S IBX=$P($G(^DGCR(399,+IBLBDT,0)),U,1)
	. I '$P(IBLBDT,U,2) D TBILL(IBTRN,+IBLBDT),TERR(IBTRN,0,"Event already has a final bill ("_IBX_").")
	. I $P(IBLBDT,U,3)'=8 S IBX=$P($G(^DGCR(399.3,+$P(IBLBDT,U,3),0)),U,1) D TERR(IBTRN,0,"May not be Reimbursable Ins.: A "_IBX_" bill already exists for this event.")
	;
	; begin calculation of bill dates, begin date based on end of last bill, otherwise event date (admission dt)
	S IBSTDT=$P(IBLBDT,U,2)\1,IBTF=3 I +IBSTDT S IBSTDT=$$FMADD^XLFDT(+IBSTDT,1)
	I 'IBSTDT S IBSTDT=IBEVDT\1,IBTF=2
	S $P(IBSTDT,U,2)=$$BCDT^IBCU8(+IBSTDT,IBTYP) ; end date based on pre^defined length of bill cycle
	;
	; force date range to within admit-discharge dates
	S:+IBSTDT<+IBAD $P(IBSTDT,U,1)=+IBAD\1 I +IBDIS,$P(IBSTDT,U,2)>+IBDIS S $P(IBSTDT,U,2)=+IBDIS
	I $P(IBSTDT,U,2)=IBDIS S IBTF=4 I +IBSTDT=(+IBAD\1) S IBTF=1
	;
	S IBX=$$DUPCHKI^IBCU64(+IBSTDT,$P(IBSTDT,U,2),$P(IBAD,U,4),0,0) I +IBX D TEABD(IBTRN,0),TERR(IBTRN,0,$P(IBX,U,2)) G INPQ
	S IBX=$$EABD^IBCU81(IBTYP,$P(IBSTDT,U,2)) I +IBX>DT D TEABD(IBTRN,+IBX) G INPQ
	S ^TMP(IBS,$J,IBDFN,IBSTDT,IBTRN)=IBTF
INPQ	K IBSTDT,IBAD,IBLBDT,IBDIS,IBX,IBTF
	Q
	;
INPT	;
	N PTF S IBADMT=$P(IBTRND,U,5),IBAD=$$AD^IBCU64(IBADMT),IB(.03)=+IBAD,IB(.05)=1
	;check ptf movements for service connected care, see enddis^ibca0
	S IB(.08)=$P(IBAD,U,4),PTF=IB(.08)
	S IB(.04)=1,IBX=$P($G(^DIC(45.7,+$P(IBAD,U,5),0)),U,2) I $P($G(^DIC(42.4,+IBX,0)),U,3)="NH" S IB(.04)=2 ; treating specialty NHCU
	S IBDISDT=$P(IBAD,U,2) ; discharge date
	S IB(151)=+IBSTDT,IB(152)=$P(IBSTDT,U,2)
	S IBIDS(.08)=IB(.08) D SPEC^IBCU4 S IB(161)=$G(IBIDS(161)) K IBIDS ; discharge bedsection
	I +IBDISDT,'IB(161) D TERR(IBTRN,IBIFN,"Non-Billable Discharge Bedsection.")
	S IB(165)=$$LOS^IBCU64(IB(151),IB(152),IB(.06),IBADMT) I IB(165)'>0 D TERR(IBTRN,IBIFN,"No billable Days.")
	S IB(.09)=9 D IDX^IBCD4(+IB(.08),+IB(151),+IB(152)) I $D(IBMSG)>2 D
	. S IBX=0 F  S IBX=$O(IBMSG(IBX)) Q:'IBX  D TERR(IBTRN,IBIFN,IBMSG(IBX))
INPTE	K IBADMT,IBADMTD,IBDISDT,IBLBDT,IBSCM,IBM,IBAD,IBX
	Q
	;
TEABD(TRN,IBDT)	;array contains the list of claims tracking events that need EABD updated, and the new date
	S IBDT=+$G(IBDT),^TMP("IBEABD",$J,TRN,+IBDT)=""
	Q
TERR(TRN,IFN,ER)	;array contains events or bills that need entries created in the comments file, and the comment
	N X S TRN=+$G(TRN),IFN=+$G(IFN),X=+$G(^TMP("IBCE",$J,DT,TRN,IFN))+1
	S ^TMP("IBCE",$J,DT,TRN,IFN,X)=$G(ER),^TMP("IBCE",$J,DT,TRN,IFN)=X
	Q
TBILL(TRN,IFN)	;array contains list of events and bills to be inserted into 356.399
	I '$D(^IBT(356,+$G(TRN),0))!('$D(^DGCR(399,+$G(IFN),0))) Q
	S ^TMP("IBILL",$J,TRN,IFN)=""
	Q
