IBINI0AB	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,101,1,2,1)
	;;=S DGRVRCAL=1
	;;^DD(399,101,1,2,2)
	;;=S DGRVRCAL=2
	;;^DD(399,101,1,2,"%D",0)
	;;=^^3^3^2940214^^
	;;^DD(399,101,1,2,"%D",1,0)
	;;=This variable DGRVRCAL being defined causes the revenue codes to be
	;;^DD(399,101,1,2,"%D",2,0)
	;;=recalculated (results in ^IBCU6 being called).  Checked at various places
	;;^DD(399,101,1,2,"%D",3,0)
	;;=within the billing screens (ex. EN+2^IBCSC4).
	;;^DD(399,101,1,3,0)
	;;=399^AE^MUMPS
	;;^DD(399,101,1,3,1)
	;;=S:$P(^DGCR(399,DA,0),"^",2) ^DGCR(399,"AE",$P(^(0),U,2),X,DA)=""
	;;^DD(399,101,1,3,2)
	;;=K:$P(^DGCR(399,DA,0),"^",2) ^DGCR(399,"AE",$P(^(0),U,2),X,DA)
	;;^DD(399,101,1,3,"%D",0)
	;;=^^3^3^2930802^^
	;;^DD(399,101,1,3,"%D",1,0)
	;;=Cross reference of patients and bills to primary insurers.  This will
	;;^DD(399,101,1,3,"%D",2,0)
	;;=be used to prevent deletion of insurance policy entries from the
	;;^DD(399,101,1,3,"%D",3,0)
	;;=patient file if a bill has been created to this insurance company.
	;;^DD(399,101,1,3,"DT")
	;;=2930802
	;;^DD(399,101,1,4,0)
	;;=^^TRIGGER^399^.19
	;;^DD(399,101,1,4,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,19),X=X S DIU=X K Y S X=DIV S X=$$FT^IBCU3(DA) X ^DD(399,101,1,4,1.4)
	;;^DD(399,101,1,4,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,19)=DIV,DIH=399,DIG=.19 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,101,1,4,2)
	;;=Q
	;;^DD(399,101,1,4,"%D",0)
	;;=^^1^1^2940214^^
	;;^DD(399,101,1,4,"%D",1,0)
	;;=Sets form type depending on ins co. parameter and site default.
	;;^DD(399,101,1,4,"CREATE VALUE")
	;;=S X=$$FT^IBCU3(DA)
	;;^DD(399,101,1,4,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,101,1,4,"DT")
	;;=2931110
	;;^DD(399,101,1,4,"FIELD")
	;;=FORM TYPE
	;;^DD(399,101,1,5,0)
	;;=^^TRIGGER^399^122
	;;^DD(399,101,1,5,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y X ^DD(399,101,1,5,1.1) X ^DD(399,101,1,5,1.4)
	;;^DD(399,101,1,5,1.1)
	;;=S X=DIV S I(0,0)=$S($D(D0):D0,1:""),D0=DIV S:'$D(^DIC(36,+D0,0)) D0=-1 S Y(101)=$S($D(^DIC(36,D0,0)):^(0),1:"") S X=$P(Y(101),U,11) S D0=I(0,0)
	;;^DD(399,101,1,5,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M1")):^("M1"),1:""),DIV=X S $P(^("M1"),U,2)=DIV,DIH=399,DIG=122 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,101,1,5,2)
	;;=Q
	;;^DD(399,101,1,5,"%D",0)
	;;=^^2^2^2940201^
	;;^DD(399,101,1,5,"%D",1,0)
	;;=Loads the Primary Provider # with the Hospital Provider Number of the
	;;^DD(399,101,1,5,"%D",2,0)
	;;=Primary Insurance Carrier.
	;;^DD(399,101,1,5,"CREATE VALUE")
	;;=PRIMARY INSURANCE CARRIER:HOSPITAL PROVIDER NUMBER
	;;^DD(399,101,1,5,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,101,1,5,"DT")
	;;=2940201
	;;^DD(399,101,1,5,"FIELD")
	;;=PRIMARY PROVIDER #
	;;^DD(399,101,3)
	;;=Enter name of insurance carrier to which this bill is to be sent.
	;;^DD(399,101,5,1,0)
	;;=399^112^1
	;;^DD(399,101,12)
	;;=Only valid insurance companies for this date of care.
	;;^DD(399,101,12.1)
	;;=S DIC("S")="I $D(IBDD(+Y)),'$D(^DGCR(399,DA,""AIC"",+Y))"
	;;^DD(399,101,21,0)
	;;=^^2^2^2940214^^^^
	;;^DD(399,101,21,1,0)
	;;=This is the name of the insurance carrier to which this bill is to be sent.
	;;^DD(399,101,21,2,0)
	;;=This is from the entries in this patients file of insurance companies. 
	;;^DD(399,101,23,0)
	;;=^^3^3^2940214^^
	;;^DD(399,101,23,1,0)
	;;=Only valid/active insurance companies for this patient can be choosen,
	;;^DD(399,101,23,2,0)
	;;=as defined by DD^IBCNS.  Company must not already be defined as a carrier 
	;;^DD(399,101,23,3,0)
	;;=(399,102-103) for this bill.
