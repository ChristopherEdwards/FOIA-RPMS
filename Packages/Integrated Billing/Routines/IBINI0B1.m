IBINI0B1	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.1,.11,"DT")
	;;=2901003
	;;^DD(399.1,.12,0)
	;;=BEDSECTION^S^1:YES;0:NO;^0;5^Q
	;;^DD(399.1,.12,1,0)
	;;=^.1^^0
	;;^DD(399.1,.12,3)
	;;=Enter the code which indicates whether or not this is a Bedsection.
	;;^DD(399.1,.12,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.1,.12,21,1,0)
	;;=This indicates whether or not this entry is a Bedsection.
	;;^DD(399.1,.12,"DT")
	;;=2901003
	;;^DD(399.1,.13,0)
	;;=DISCHARGE STATUS^S^1:YES;0:NO;^0;6^Q
	;;^DD(399.1,.13,3)
	;;=Enter the code which indicates whether or not this is a Discharge Status.
	;;^DD(399.1,.13,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.1,.13,21,1,0)
	;;=This indicates whether or not this entry is a Discharge Status.
	;;^DD(399.1,.13,"DT")
	;;=2901003
	;;^DD(399.1,.14,0)
	;;=IB ACTION TYPE (COPAYMENT)^P350.1'^IBE(350.1,^0;7^Q
	;;^DD(399.1,.14,1,0)
	;;=^.1
	;;^DD(399.1,.14,1,1,0)
	;;=399.1^AC
	;;^DD(399.1,.14,1,1,1)
	;;=S ^DGCR(399.1,"AC",$E(X,1,30),DA)=""
	;;^DD(399.1,.14,1,1,2)
	;;=K ^DGCR(399.1,"AC",$E(X,1,30),DA)
	;;^DD(399.1,.14,1,1,"%D",0)
	;;=^^5^5^2920407^^^
	;;^DD(399.1,.14,1,1,"%D",1,0)
	;;=This cross-reference is used to determine the billable bedsection for
	;;^DD(399.1,.14,1,1,"%D",2,0)
	;;=an Integrated Billing ACTION TYPE (file #350.2) for Means Test Inpatient
	;;^DD(399.1,.14,1,1,"%D",3,0)
	;;=or Nursing Home Care co-payment charges.  The actual charge for the action
	;;^DD(399.1,.14,1,1,"%D",4,0)
	;;=type is then found in the BILLING RATES file (#399.5), based on the
	;;^DD(399.1,.14,1,1,"%D",5,0)
	;;=bedsection and date of care.
	;;^DD(399.1,.14,1,1,"DT")
	;;=2920407
	;;^DD(399.1,.14,21,0)
	;;=^^6^6^2920415^^^
	;;^DD(399.1,.14,21,1,0)
	;;=This field will only be used for those bedsections which are included
	;;^DD(399.1,.14,21,2,0)
	;;=in the billing of Means Test/Category C charges.
	;;^DD(399.1,.14,21,3,0)
	;;= 
	;;^DD(399.1,.14,21,4,0)
	;;=The field is a pointer to the IB ACTION TYPE file.  Once the bedsection
	;;^DD(399.1,.14,21,5,0)
	;;=is derived from the patient's treating specialty, the IB ACTION TYPE
	;;^DD(399.1,.14,21,6,0)
	;;=for the Category C Inpatient/NHC co-payment charge can be determined.
	;;^DD(399.1,.14,"DT")
	;;=2920407
	;;^DD(399.1,.15,0)
	;;=IB ACTION TYPE (PER DIEM)^P350.1'^IBE(350.1,^0;8^Q
	;;^DD(399.1,.15,1,0)
	;;=^.1^^0
	;;^DD(399.1,.15,21,0)
	;;=^^6^6^2920415^^
	;;^DD(399.1,.15,21,1,0)
	;;=This field will only be used for those bedsections which are included
	;;^DD(399.1,.15,21,2,0)
	;;=in the billing of Means Test/Category C charges.
	;;^DD(399.1,.15,21,3,0)
	;;= 
	;;^DD(399.1,.15,21,4,0)
	;;=The field is a pointer to the IB ACTION TYPE file.  Once the bedsection
	;;^DD(399.1,.15,21,5,0)
	;;=is derived from the patient's treating specialty, the IB ACTION TYPE
	;;^DD(399.1,.15,21,6,0)
	;;=for the Category C Inpatient/NHC per diem charge can be determined.
	;;^DD(399.1,.15,"DT")
	;;=2920408
	;;^DD(399.1,.16,0)
	;;=OCC RELATED TO^*S^1:EMPLOYMENT;2:AUTO ACCIDENT;3:OTHER ACCIDENT;^0;9^Q
	;;^DD(399.1,.16,3)
	;;=Enter the code that most accurately relates to the Occurence Code.
	;;^DD(399.1,.16,12)
	;;=Valid MCCR Occurrence Codes only!
	;;^DD(399.1,.16,12.1)
	;;=S DIC("S")="I $P(^DGCR(399.1,+DA,0),U,4)=1"
	;;^DD(399.1,.16,21,0)
	;;=^^2^2^2920428^
	;;^DD(399.1,.16,21,1,0)
	;;=Relates the Occurrence Codes to the 'Condition Related To' question on the
	;;^DD(399.1,.16,21,2,0)
	;;=HCFA 1500, block 10.
	;;^DD(399.1,.16,"DT")
	;;=2920428
	;;^DD(399.1,.17,0)
	;;=OCCURRENCE SPAN^*S^1:YES;0:NO;^0;10^Q
	;;^DD(399.1,.17,3)
	;;=Enter Yes if this Occurrence code has two related dates associated with it.
	;;^DD(399.1,.17,12)
	;;=Only Valid Occurrence Codes!
