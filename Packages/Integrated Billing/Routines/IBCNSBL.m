IBCNSBL	;ALB/AAS - NEW INSURANCE POLICY BULLETIN ; 29-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	N IBP,START,END,X,Y,I,J,VAIN,VAINDT,VA,DA,DR,DIE,DIC,INPT,OPT,DGPM,IBINS,IBX,IBTADD
	;  
	Q:'$D(IBEVTA)!('$D(IBEVT1))!('$D(IBCDFN))
	;
	S IBP=$$PT^IBEFUNC(DFN),(OPT,INPT)=0
	;
	; -- set starting date = latest of jan 1 of prior year, or effective date,
	S START=$E(DT,1,3)-1,START=START_"0101"
	I $P(IBEVTA,"^",8),$P(IBEVTA,"^",8)>START S START=$P(IBEVTA,"^",8)
	;
	S END=DT+.9
	;
	S X=$O(^DPT(DFN,"S",START)) I X,(X'>(END+.24)) S OPT=1
	S X=$O(^DGPM("APTT1",DFN,START)) I X,(X'>(END+.24)) S INPT=1
	I $G(^DPT(DFN,.1))'="" D  S INPT=1
	.;
	.;see if current admission is in claims tracking
	.S VAINDT=DT+.24 D INP^VADPT
	.N IBMVAD,IBTRKR,IBRANDOM,DGPMA
	.S IBMVAD=+VAIN(1),DGPMA=$G(^DGPM(+IBMVAD,0))
	.I DFN=$P($G(^IBT(356,+$O(^IBT(356,"AD",+IBMVAD,0)),0)),"^",2) Q  ; quit if already in claims tracking
	.S IBTRKR=$G(^IBE(350.9,1,6))
	.I $P(IBTRKR,"^",2)=2 D ADM^IBTUTL(IBMVAD,$E(+DGPMA,1,12),0,$P(DGPMA,"^",27)) S IBTADD=1
	.I $P(IBTRKR,"^",2)=1,$$INSURED^IBCNS1(DFN,+DGPMA) D ADM^IBTUTL(IBMVAD,$E(+DGPMA,1,12),0,$P(DGPMA,"^",27)) S IBTADD=1
	.Q
	;
	S VAINDT=START+.24 D INP^VADPT I $G(VAIN(1)) S INPT=1
	I 'OPT,'INPT G BQ
	;
	D BULL^IBCNSBL1
BQ	Q
