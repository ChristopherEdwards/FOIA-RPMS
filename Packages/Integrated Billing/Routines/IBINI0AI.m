IBINI0AI	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,155,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,155,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,155,3)
	;;=Enter 'Yes' or '1' if this record contains sensitive information pertaining  to, but not limited to, drugs, alcohol, and/or sickle cell anemia, 'No' or '0'  if it does not.
	;;^DD(399,155,21,0)
	;;=^^3^3^2880921^^
	;;^DD(399,155,21,1,0)
	;;=This indicates whether or not this record contains information pertaining
	;;^DD(399,155,21,2,0)
	;;=to, but not limited to, drugs, alcohol, or sickle cell anemia, and if so,
	;;^DD(399,155,21,3,0)
	;;=allows the user to identify this record as "sensitive".
	;;^DD(399,155,"DT")
	;;=2880607
	;;^DD(399,156,0)
	;;=ASSIGNMENT OF BENEFITS^RFOX^^U;6^I $D(X) D YN^IBCU I $D(X) X:X=0 ^DD(399,156,9.3) K IBRATY
	;;^DD(399,156,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,156,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,156,3)
	;;=Enter the code which indicates whether or not a third party is authorized to pay the provider for services covered by this bill.
	;;^DD(399,156,5,1,0)
	;;=399^.07^1
	;;^DD(399,156,9.3)
	;;=S IBRATY=$P(^DGCR(399,DA,0),"^",7) I $D(^DGCR(399.3,IBRATY,0)),$P(^(0),"^",5)=1 K X W !?4,"Answer must be YES for this 'Third Party' billing episode!",*7
	;;^DD(399,156,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,156,21,1,0)
	;;=This indicates whether or not a third party is authorized to pay the 
	;;^DD(399,156,21,2,0)
	;;=provider for services covered by this bill.
	;;^DD(399,156,"DT")
	;;=2881025
	;;^DD(399,157,0)
	;;=R.O.I. FORM(S) COMPLETED?^FOX^^U;7^I $D(X) D YN^IBCU
	;;^DD(399,157,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,157,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,157,3)
	;;=Enter 'Yes' or '1' if Release Of Information form(s) are completed, 'No' or '0' if Release Of Information form(s) are not completed.
	;;^DD(399,157,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,157,21,1,0)
	;;=This allows the user to indicate if the Release of Information forms (if
	;;^DD(399,157,21,2,0)
	;;=necessary) have been signed.
	;;^DD(399,157,"DT")
	;;=2880607
	;;^DD(399,158,0)
	;;=TYPE OF ADMISSION^S^1:EMERGENCY;2:URGENT;3:ELECTIVE;^U;8^Q
	;;^DD(399,158,3)
	;;=Enter a code indicating the priority of this admission.
	;;^DD(399,158,5,1,0)
	;;=399^.08^2
	;;^DD(399,158,21,0)
	;;=^^1^1^2880901^
	;;^DD(399,158,21,1,0)
	;;=This indicates the priority of this admission.
	;;^DD(399,158,"DT")
	;;=2880523
	;;^DD(399,159,0)
	;;~SOURCE OF ADMISSION^S^1:PHYSICIAN REFERRAL;2:CLINIC REFERRAL;3:HMO REFERRAL;4:TRANSFER FROM HOSPITAL;5:TRANSFER FROM SKILLED NURSING FAC.;6:TRANSFER FROM OTHER 
	;;=HEALTH CARE FAC.;7:EMERGENCY ROOM;8:COURT/LAW ENFORCEMENT;9:INFO NOT AVAILABLE;^U;9^Q
	;;^DD(399,159,3)
	;;=Enter the code which indicates the source of this admission.
	;;^DD(399,159,5,1,0)
	;;=399^.08^1
	;;^DD(399,159,21,0)
	;;=^^1^1^2890405^^^
	;;^DD(399,159,21,1,0)
	;;=This indicates the source of this admission.
	;;^DD(399,159,"DT")
	;;=2890403
	;;^DD(399,160,0)
	;;=ACCIDENT HOUR^F^^U;10^K:$L(X)>3!($L(X)<1) X
	;;^DD(399,160,3)
	;;=Enter the time at which an accident took place if this bill is related to an accident.
	;;^DD(399,160,5,1,0)
	;;=399^.08^3
	;;^DD(399,160,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,160,21,1,0)
	;;=This indicates the time at which an accident occurred if this episode
	;;^DD(399,160,21,2,0)
	;;=of care is related to an accident.
	;;^DD(399,160,"DT")
	;;=2880523
	;;^DD(399,161,0)
	;;=DISCHARGE BEDSECTION^*P399.1'^DGCR(399.1,^U;11^S DIC("S")="I $P(^DGCR(399.1,+Y,0),""^"",5)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
