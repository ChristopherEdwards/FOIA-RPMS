IBINI03N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354,.03,1,1,"DT")
	;;=2930121
	;;^DD(354,.03,3)
	;;=Enter the date of the current income exemption.
	;;^DD(354,.03,5,1,0)
	;;=354^.04^2
	;;^DD(354,.03,9)
	;;=^
	;;^DD(354,.03,21,0)
	;;=^^5^5^2940213^^^^
	;;^DD(354,.03,21,1,0)
	;;=DO NOT EDIT THIS FIELD.  It is maintained by the Copay Exemption Software.
	;;^DD(354,.03,21,2,0)
	;;= 
	;;^DD(354,.03,21,3,0)
	;;=This is the date that this patients Medication Copay Income Exemption 
	;;^DD(354,.03,21,4,0)
	;;=Status was last updated.  If this date is not in the current calendar 
	;;^DD(354,.03,21,5,0)
	;;=year this patient will be flagged as needing to have his status updated.
	;;^DD(354,.03,23,0)
	;;=^^5^5^2940213^^^^
	;;^DD(354,.03,23,1,0)
	;;=This field will be updated by the Copay Exemption software every time
	;;^DD(354,.03,23,2,0)
	;;=a new current exemption is added.  It should not be edited.
	;;^DD(354,.03,23,3,0)
	;;= 
	;;^DD(354,.03,23,4,0)
	;;=Programmers must 4 slash stuff data into this field to bypass the input
	;;^DD(354,.03,23,5,0)
	;;=transform.
	;;^DD(354,.03,"DT")
	;;=2930210
	;;^DD(354,.04,0)
	;;=COPAY INCOME EXEMPTION STATUS^R*S^1:EXEMPT;0:NON-EXEMPT;^0;4^Q
	;;^DD(354,.04,.1)
	;;=RX COPAY CURRENT INCOME EXEMPTION STATUS
	;;^DD(354,.04,1,0)
	;;=^.1^^-1
	;;^DD(354,.04,1,1,0)
	;;=354^AEX
	;;^DD(354,.04,1,1,1)
	;;=S ^IBA(354,"AEX",$E(X,1,30),DA)=""
	;;^DD(354,.04,1,1,2)
	;;=K ^IBA(354,"AEX",$E(X,1,30),DA)
	;;^DD(354,.04,1,1,"%D",0)
	;;=^^2^2^2930429^^^
	;;^DD(354,.04,1,1,"%D",1,0)
	;;=This is a regular cross-reference of the Pharmacy Copay Income Exemption
	;;^DD(354,.04,1,1,"%D",2,0)
	;;=Status of patients for their most recent status.
	;;^DD(354,.04,1,1,"DT")
	;;=2921109
	;;^DD(354,.04,1,2,0)
	;;=^^TRIGGER^354^.03
	;;^DD(354,.04,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBA(354,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(354,.04,1,2,1.4)
	;;^DD(354,.04,1,2,1.4)
	;;=S DIH=$S($D(^IBA(354,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=354,DIG=.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(354,.04,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBA(354,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" S DIH=$S($D(^IBA(354,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=354,DIG=.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(354,.04,1,2,"CREATE VALUE")
	;;=S X=DT
	;;^DD(354,.04,1,2,"DELETE VALUE")
	;;=@
	;;^DD(354,.04,1,2,"DT")
	;;=2921109
	;;^DD(354,.04,1,2,"FIELD")
	;;=#.03
	;;^DD(354,.04,3)
	;;=Enter whether this patient is currently exempt from pharmacy copay due to the income exemption.
	;;^DD(354,.04,9)
	;;=^
	;;^DD(354,.04,12)
	;;=This field can only be edited/updated by the Copay Exemption software.
	;;^DD(354,.04,12.1)
	;;=S DIC("S")="I $P(^IBA(354,DA,0),U,4)=Y!($G(IBJOB)>10)"
	;;^DD(354,.04,21,0)
	;;=^^10^10^2930429^^^^
	;;^DD(354,.04,21,1,0)
	;;=DO NOT EDIT THIS FIELD.  It is maintained by the Copay Exemption Software.
	;;^DD(354,.04,21,2,0)
	;;= 
	;;^DD(354,.04,21,3,0)
	;;=This is the patients current Medication Copay Income Exemption Status.  It
	;;^DD(354,.04,21,4,0)
	;;=is updated whenever an entry in the Billing Exemptions file is made.
	;;^DD(354,.04,21,5,0)
	;;= 
	;;^DD(354,.04,21,6,0)
	;;=If a patient's income is less than the pension level, effective 10/29/92
	;;^DD(354,.04,21,7,0)
	;;=the patient is exempt from paying the Medication Copayment.  If a patient
	;;^DD(354,.04,21,8,0)
	;;=is receiving a VA Pension, or is receiving Aid and Attendence or House
	;;^DD(354,.04,21,9,0)
	;;=Bound benefits, or his income for the previous year is less than the
