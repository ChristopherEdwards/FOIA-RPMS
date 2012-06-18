IBINI09Y	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.08,1,4,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,12)=DIV,DIH=399,DIG=162 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.08,1,4,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X="" X ^DD(399,.08,1,4,2.4)
	;;^DD(399,.08,1,4,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,12)=DIV,DIH=399,DIG=162 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.08,1,4,"%D",0)
	;;=^^2^2^2920212^
	;;^DD(399,.08,1,4,"%D",1,0)
	;;=This sets the discharge status to the correct entry based upon the
	;;^DD(399,.08,1,4,"%D",2,0)
	;;=Disposition Field type in the PTF record.
	;;^DD(399,.08,1,4,"CREATE CONDITION")
	;;=#162=""
	;;^DD(399,.08,1,4,"CREATE VALUE")
	;;=D DIS^IBCU S X=X
	;;^DD(399,.08,1,4,"DELETE VALUE")
	;;=@
	;;^DD(399,.08,1,4,"DT")
	;;=2920212
	;;^DD(399,.08,1,4,"FIELD")
	;;=#162
	;;^DD(399,.08,1,5,0)
	;;=399^APTF
	;;^DD(399,.08,1,5,1)
	;;=S ^DGCR(399,"APTF",$E(X,1,30),DA)=""
	;;^DD(399,.08,1,5,2)
	;;=K ^DGCR(399,"APTF",$E(X,1,30),DA)
	;;^DD(399,.08,1,5,"%D",0)
	;;=^^2^2^2920406^
	;;^DD(399,.08,1,5,"%D",1,0)
	;;=Cross reference of all PTF records with associated bills.  To be used
	;;^DD(399,.08,1,5,"%D",2,0)
	;;=by PTF purge utilities.
	;;^DD(399,.08,1,5,"DT")
	;;=2920406
	;;^DD(399,.08,1,6,0)
	;;=^^TRIGGER^399^165
	;;^DD(399,.08,1,6,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^DGCR(399,DA,0),U,5)<3 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X=DIV S X=+$$LOS1^IBCU64(DA) X ^DD(399,.08,1,6,1.4)
	;;^DD(399,.08,1,6,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,15)=DIV,DIH=399,DIG=165 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.08,1,6,2)
	;;=Q
	;;^DD(399,.08,1,6,"%D",0)
	;;=^^1^1^2931018^^^
	;;^DD(399,.08,1,6,"%D",1,0)
	;;=Sets Length of Stay based on PTF record and date range of bill.  Inpatients only.
	;;^DD(399,.08,1,6,"CREATE CONDITION")
	;;=I $P(^DGCR(399,DA,0),U,5)<3
	;;^DD(399,.08,1,6,"CREATE VALUE")
	;;=S X=+$$LOS1^IBCU64(DA)
	;;^DD(399,.08,1,6,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.08,1,6,"DT")
	;;=2931018
	;;^DD(399,.08,1,6,"FIELD")
	;;=LENGTH OF STAY
	;;^DD(399,.08,3)
	;;=ENTER A PTF RECORD BELONGING TO THIS PATIENT ONLY!
	;;^DD(399,.08,12.1)
	;;=S DIC("S")="I $D(IBDD1(+Y))"
	;;^DD(399,.08,21,0)
	;;=^^1^1^2880831^^
	;;^DD(399,.08,21,1,0)
	;;=This identifies PTF records belonging to this patient only.
	;;^DD(399,.08,"DT")
	;;=2931018
	;;^DD(399,.09,0)
	;;=PROCEDURE CODING METHOD^S^4:CPT-4;5:HCPCS (HCFA COMMON PROCEDURE CODING SYSTEM);9:ICD-9-CM;^0;9^Q
	;;^DD(399,.09,3)
	;;=Enter the code which identifies the method for procedure coding on this bill.
	;;^DD(399,.09,5,1,0)
	;;=399^.19^1
	;;^DD(399,.09,21,0)
	;;=^^1^1^2900809^^
	;;^DD(399,.09,21,1,0)
	;;=This defines the outpatient procedure coding method utilized on this bill.
	;;^DD(399,.11,0)
	;;=WHO'S RESPONSIBLE FOR BILL?^RSI^p:PATIENT;i:INSURER;o:OTHER;^0;11^Q
	;;^DD(399,.11,1,0)
	;;=^.1
	;;^DD(399,.11,1,1,0)
	;;=^^TRIGGER^399^112
	;;^DD(399,.11,1,1,1)
	;;=X ^DD(399,.11,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X=DIV D EN1^IBCU5 X ^DD(399,.11,1,1,1.4)
	;;^DD(399,.11,1,1,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=(X="i"&($S('$D(^DGCR(399,DA,"M")):1,'+^("M"):1,'$D(^DIC(36,+^("M"),0)):1,1:0)))
	;;^DD(399,.11,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"M")):^("M"),1:""),DIV=X S $P(^("M"),U,12)=DIV,DIH=399,DIG=112 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
