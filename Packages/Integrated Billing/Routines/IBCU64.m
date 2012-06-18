IBCU64	;ALB/ARH - AUTOMATED BILLER (INPT CONT) ; 8/6/93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
LOS1(IFN)	; returns length of stay for a  bill's date range
	N X,Y,DFN,DGADM,DGPMCA S (X,DGPMCA)=0,Y=$G(^DGCR(399,+$G(IFN),0)) G:Y="" LOS1Q I $P(Y,U,8)'="" D
	. ; find patient movement, based on admit date and DFN from PTF
	. S DFN=+$P(Y,U,2),DGADM=$P($G(^DGPT(+$P(Y,U,8),0)),U,2) I 'DGADM Q
	. S DGADM=$O(^DGPM("AMV1",+$P(DGADM,"."))),DGPMCA=$O(^DGPM("AMV1",+DGADM,+DFN,0))
	S X=$G(^DGCR(399,+IFN,"U"))
	S X=$$LOS($P(X,U,1),$P(X,U,2),$P(Y,U,6),DGPMCA)
LOS1Q	Q X
	;
AD(DGPMCA)	; returns inpatient admit and discharge date, DFN, PTF, Facility Treating Specialty, if one/both don't exist "0^0"
	N X,Y S X="0^0" I '$G(DGPMCA) G ADQ
	S Y=$G(^DGPM(+DGPMCA,0)) ; get patient movement data
	S X=+Y_"^"_+$G(^DGPM(+$P(Y,U,17),0))_"^"_$P(Y,U,3)_"^"_$P(Y,U,16)_"^"_$P(Y,U,9)
ADQ	Q X
	;
LOS(DGBDT,DGEDT,BTF,DGPMCA)	; calculate the inpatient length of stay for a given time period
	;parameters are input variables into DGUTL2, which calculates days absent or on pass
	;if the pat movment IFN is not available then can't check of absence or pass days
	;LOS: discharge date is not added except for inpt interim first and continuous where discharge date is added,
	;    absent or pass days not added,
	;    admission and discharge on same day has LOS=1, discharge date=admission date+1 also has an LOS=1
	N X,IBX,IBY,DGREC,IBDISDT,DGMVTP,DGADM,DFN,DGA S IBX=0 I '$G(DGBDT)!'$G(DGEDT) G LOSQ
	I DGBDT=DGEDT!($G(BTF)=2)!($G(BTF)=3) S DGEDT=$$FMADD^XLFDT(DGEDT,1) ; inclusive if interim continuous or first
	S IBX=$$FMDIFF^XLFDT(DGEDT,DGBDT,1) ; difference between begin and end date
	I +$G(DGPMCA) S IBY=$$AD(DGPMCA) I +IBY S DGADM=+IBY\1,IBDISDT=$P(IBY,U,2)\1,DFN=$P(IBY,U,3) D
	. ; maximum date range is the admit thru discharge range
	. S:DGBDT<DGADM DGBDT=DGADM I +IBDISDT&(DGEDT>IBDISDT) S DGEDT=IBDISDT
	. S IBX=$$FMDIFF^XLFDT(DGEDT,DGBDT,1) I (DGBDT\1)=(DGEDT\1) S IBX=1
	. D PLASIH^DGUTL2 S IBX=IBX-DGREC ; subtract days absent or on pass
LOSQ	Q $S(IBX>0:IBX,1:0)
	;
DUPCHKI(DT1,DT2,PTF,RTG,DISP,IFN)	;Check for duplicate billing of inpt admission - checks for overlapping date range on other
	;bills with the same rate type and that have not been cancelled
	;input:   DT1 - beginning of date range to check
	;         DT2 - ending of date range to check
	;         PTF - ptr to PTF record
	;         DISP - true if error message should be printed before exit, if any
	;         RTG - rate group to check for, if no rate group (0 passed and/or no IFN) then any bill found for
	;          visit date will cause error message
	;         IFN - existing bill to check against, if passed will use variables from this bill if they are not passed in
	;returns: 0 - if another bill was not found for this admission with this date range, patient, and rate type
	;         (dup IFN)_"^error message" - if duplicate date found, same rate group then IFN of bill
	N IFN2,Y,X,X1 S Y=0,(X,X1)="",IFN=+$G(IFN) I +IFN S X=$G(^DGCR(399,IFN,0)),X1=$G(^DGCR(399,IFN,"U"))
	S RTG=$S($G(RTG)'="":+RTG,1:+$P(X,U,7)),PTF=$S(+$G(PTF):+PTF,1:+$P(X,U,8)) G:'PTF DCIQ
	S DT1=$S(+$G(DT1):+DT1,1:$P(X1,U,1)),DT2=$S(+$G(DT2):+DT2,1:$P(X1,U,2)) G:'DT1!'DT2 DCIQ
	S DT1=DT1\1,DT2=DT2\1 I (DT1>DT2)!('$D(^DGCR(399,"APTF",PTF))) G DCIQ
	S IFN2=0 F  S IFN2=$O(^DGCR(399,"APTF",PTF,IFN2)) Q:'IFN2  I IFN'=IFN2 D  Q:+Y
	. S X1=$G(^DGCR(399,IFN2,0)) I $P(X1,U,13)=7 Q  ; bill cancelled
	. I +RTG,$P(X1,U,7)'=RTG Q  ; different rate group
	. S X=$G(^DGCR(399,IFN2,"U")) I (DT2<+X)!(DT1>+$P(X,U,2)) Q
	. S Y=IFN2_"^A "_$P($G(^DGCR(399.3,+$P(X1,U,7),0)),U,1)_" bill ("_$P(X1,U,1)_") exists overlapping this date range."
DCIQ	I +$G(DISP),+Y W !,?10,$P(Y,U,2)
	Q Y
	;
ADM(DFN,IBDT)	; -- send back adm dt for dfn on vaindt (or now) if any, 0 otherwise
	;returns adm if patient was admitted at any time during IBDT or before dischrge date and time
	N IBNDT,IBINPT,IBADM,IBADT1,IBADT2,IBDIS,IBNOW,%,X,Y D NOW^%DTC S IBNOW=%
	S IBINPT=0,IBDT=$G(IBDT) G:'$D(^DPT(+$G(DFN),0)) ADME I 'IBDT S IBDT=IBNOW
	S IBNDT=9999999.999999-((IBDT\1)+.99999),IBADT2=IBNOW
	F  S IBNDT=$O(^DGPM("ATID1",DFN,IBNDT)) Q:'IBNDT  D  Q:+IBINPT
	. S IBADM=+$O(^DGPM("ATID1",DFN,IBNDT,0)),IBADT1=$G(^DGPM(+IBADM,0)) Q:IBADT1=""
	. S IBDIS=$P(IBADT1,U,17) I +IBDIS S IBADT2=+$G(^DGPM(+IBDIS,0))
	. I $P(IBADT2,".",2)="" S $P(IBADT2,".",2)=999999
	. I (+IBADT1\1)'>(IBDT\1),(IBADT2'<IBDT!((+IBADT1\1)=(+IBDT\1))) S IBINPT=+IBADT1
ADME	Q IBINPT
