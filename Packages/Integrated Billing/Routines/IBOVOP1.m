IBOVOP1	;ALB/RLW - Report of Visits for NSC Outpatients ; 12-JUN-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
MAIN	; perform report for day(s)
	D HDR^IBOVOP2
	I $$STOP^IBOUTL("Outpatient/Registration Events Report") S IBQUIT=1 G END
	D APPT,STOPCD,REGS,PRINT^IBOVOP2
END	K DFN,^TMP("IBOVOP",$J),IBAPPT,IBJ,IB
	Q
	;
APPT	; scan visits for NSC patients
	;            field 2="CLINIC APPT"
	;            field 4=clinic
	;            field 5=appt type
	;            field 6=status
	S IBCL="",IBSEQ=0
	F  S IBCL=$O(^SC("AC","C",IBCL)) Q:IBCL=""  S IBFLD4=$P($G(^SC(IBCL,0)),"^") I IBFLD4]"" S:+$G(^("AT"))=6 IBFLD4=$E(IBFLD4,1,13)_" [R]" D
	.S IBJ=IBDATE F  S IBJ=$O(^SC(IBCL,"S",IBJ)) Q:$E(IBJ,1,7)'=IBDATE  D
	..S IBIEN=0 F  S IBIEN=$O(^SC(IBCL,"S",IBJ,1,IBIEN)) Q:IBIEN=""  S DFN=+$G(^(IBIEN,0)) D
	...Q:'$$BIL^DGMTUB(DFN,IBJ)
	...Q:'$D(^DPT(DFN,"S",IBJ,0))  S IBSDATA=^(0)
	...S ^TMP("IBOVOP",$J,$$FLD1(DFN),"CLINIC APPT",$$FLD3(IBJ),IBSEQ)=$E(IBFLD4,1,17)_"^"_$$FLD5($P(IBSDATA,"^",16))_"^"_$E($P($$STATUS^SDAM1(DFN,IBJ,IBCL,IBSDATA),";",3),1,17)_"^"_DFN_"^"_+$P(IBSDATA,"^",20)
	Q
	;
STOPCD	; scan ADD/EDIT STOP CODES for day
	;           field 2="STOP CODE"
	;           field 4=stop code
	;           field 5=appt type
	S IBJ=IBDATE,IBSEQ=0
	F  S IBJ=$O(^SDV(IBJ)) Q:$E(IBJ,1,7)'=IBDATE  S DFN=+$P($G(^SDV(IBJ,0)),"^",2) I $$BIL^DGMTUB(DFN,IBJ) D
	.S IB="" F  S IB=$O(^SDV(IBJ,"CS","B",IB)) Q:IB=""  S I=$O(^(IB,0)) Q:I=""  D:I
	..S IBDATA=$G(^SDV(IBJ,"CS",I,0)) Q:'IBDATA
	..S ^TMP("IBOVOP",$J,$$FLD1(DFN),"STOP CODE",$$FLD3(IBJ),IBSEQ)=$E($P($G(^DIC(40.7,+IBDATA,0)),"^"),1,16)_"^"_$$FLD5($P(IBDATA,"^",5))_"^^"_DFN_"^"_+$P(IBDATA,"^",8),IBSEQ=IBSEQ+1
	Q
	;
REGS	; registrations for day
	S IBJ=IBDATE F  S IBJ=$O(^DPT("ADIS",IBJ)) Q:$E(IBJ,1,7)'=IBDATE  D
	.S DFN="" F  S DFN=$O(^DPT("ADIS",IBJ,DFN)) Q:DFN=""  D
	..S IBAIEN=$O(^DPT("ADIS",IBJ,DFN,0)) Q:IBAIEN=""
	..S IBDATA=$G(^DPT(DFN,"DIS",IBAIEN,0)) Q:$P(IBDATA,"^",2)=2!('$$BIL^DGMTUB(DFN,$P(IBDATA,"^",6)))
	..S Y=$P(IBDATA,"^",3) I Y'="" S C=$P(^DD(2.101,2,0),"^",2) D Y^DIQ
	..S IBFLD4=Y
	..S Y=$P(IBDATA,"^",7) I Y'="" S C=$P(^DD(2.101,6,0),"^",2) D Y^DIQ
	..S ^TMP("IBOVOP",$J,$$FLD1(DFN),"REGISTRATION",$$FLD3(IBJ),IBSEQ)=$E(IBFLD4,1,16)_"^"_$E(Y,1,30)_"^^"_DFN_"^"_+$P(IBDATA,"^",18)
	Q
	;
FLD1(DFN)	; get patient name, l-4 ssn id, classification, insured?
	I '$G(DFN) Q ""
	N IBX,IBY,IBZ S IBX=$$PT^IBEFUNC(DFN),IBZ=""
	D CL^SDCO21(DFN,IBDATE,"",.IBY)
	I $D(IBY(1)) S IBZ="AO"
	I $D(IBY(2)) S IBZ=IBZ_$S(IBZ]"":"/",1:"")_"IR"
	I $D(IBY(4)) S IBZ=IBZ_$S(IBZ]"":"/",1:"")_"EC"
	Q $E($P(IBX,"^"),1,20)_" "_$E(IBX)_$P(IBX,"^",3)_$S(IBZ]"":"    ["_IBZ_"]",1:"")_$S($$INSURED^IBCNS1(DFN,IBDATE):"    **Insured**",1:"")
	;
FLD3(Y)	; time - convert date/time to time only, no seconds
	I '$G(Y) Q ""
	X ^DD("DD") Q $P($P(Y,"@",2),":",1,2)
	;
FLD5(I)	; get appointment type name
	Q $E($P($G(^SD(409.1,+$G(I),0)),"^",1),1,17)
