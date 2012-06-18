IBINI0A0	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.15,3)
	;;=Enter the bill that this bill was copied from.
	;;^DD(399,.15,12)
	;;=BILL MUST BE CANCELLED TO COPY
	;;^DD(399,.15,12.1)
	;;=S DIC("S")="I $P(^(0),U,13)=7"
	;;^DD(399,.15,21,0)
	;;=^^3^3^2920211^^
	;;^DD(399,.15,21,1,0)
	;;=If this bill was copied from another bill, then this will be the bill
	;;^DD(399,.15,21,2,0)
	;;=it was copied from.  This field is automatically completed by the
	;;^DD(399,.15,21,3,0)
	;;=Copy and Cancel option.
	;;^DD(399,.15,"DT")
	;;=2900126
	;;^DD(399,.16,0)
	;;=NON-VA DISCHARGE DATE^D^^0;16^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,.16,3)
	;;=Enter the discharge date for this admission.  It must be since the admission    date and not in the future.
	;;^DD(399,.16,21,0)
	;;=^^3^3^2900420^
	;;^DD(399,.16,21,1,0)
	;;=This is the discharge date for NON-VA Admissions when no associated PTF
	;;^DD(399,.16,21,2,0)
	;;=record exists.  The date entered must be after the admission date and
	;;^DD(399,.16,21,3,0)
	;;=not into the future.
	;;^DD(399,.16,"DT")
	;;=2900420
	;;^DD(399,.17,0)
	;;=PRIMARY BILL^P399'^DGCR(399,^0;17^Q
	;;^DD(399,.17,1,0)
	;;=^.1
	;;^DD(399,.17,1,1,0)
	;;=399^AC
	;;^DD(399,.17,1,1,1)
	;;=S ^DGCR(399,"AC",$E(X,1,30),DA)=""
	;;^DD(399,.17,1,1,2)
	;;=K ^DGCR(399,"AC",$E(X,1,30),DA)
	;;^DD(399,.17,21,0)
	;;=^^3^3^2920211^^
	;;^DD(399,.17,21,1,0)
	;;=This is the initial bill that this episode is associated with.
	;;^DD(399,.17,21,2,0)
	;;=If an episode of care has more than one bill but multiple event dates, then
	;;^DD(399,.17,21,3,0)
	;;=this field can be used.
	;;^DD(399,.17,"DT")
	;;=2900524
	;;^DD(399,.18,0)
	;;=SC AT TIME OF CARE^FXO^^0;18^I $D(X) D YN^IBCU
	;;^DD(399,.18,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,.18,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,.18,3)
	;;=Was this patient Service Connected for any condition during the timeframe of this bill?  Answer 'Yes' or 'No'.
	;;^DD(399,.18,21,0)
	;;=^^8^8^2920610^^^^
	;;^DD(399,.18,21,1,0)
	;;=Was this patient Service Connected for any condition at the time the
	;;^DD(399,.18,21,2,0)
	;;=care in the bill was rendered.  This field is used to correctly assign
	;;^DD(399,.18,21,3,0)
	;;=Accounts Receivable AMIS segments to this bill if it is a Reimbursable
	;;^DD(399,.18,21,4,0)
	;;=Insurance bill.  Answer 'Yes' or 'No'.
	;;^DD(399,.18,21,5,0)
	;;= 
	;;^DD(399,.18,21,6,0)
	;;=The default for this field is the current value in the SC PATIENT field
	;;^DD(399,.18,21,7,0)
	;;=of the patient file.  If this field is left blank, the default value
	;;^DD(399,.18,21,8,0)
	;;=will be used to determine the AMIS segment.
	;;^DD(399,.18,"DT")
	;;=2910913
	;;^DD(399,.19,0)
	;;=FORM TYPE^RP353'^IBE(353,^0;19^Q
	;;^DD(399,.19,1,0)
	;;=^.1
	;;^DD(399,.19,1,1,0)
	;;=^^TRIGGER^399^.09
	;;^DD(399,.19,1,1,1)
	;;=X ^DD(399,.19,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV S X=4 X ^DD(399,.19,1,1,1.4)
	;;^DD(399,.19,1,1,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X X ^DD(399,.19,1,1,69.2) S Y(1)=X S X=$P($P(Y(3),$C(59)_$P(Y(2),U,9)_":",2),$C(59),1)="",Y=X,X=Y(1),X=X&Y
	;;^DD(399,.19,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,9)=DIV,DIH=399,DIG=.09 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.19,1,1,2)
	;;=Q
	;;^DD(399,.19,1,1,69.2)
	;;=S Y(3)=$C(59)_$S($D(^DD(399,.09,0)):$P(^(0),U,3),1:""),Y(2)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$S('$D(^IBE(353,+Y(0),0)):"",1:$P(^(0),U,1))="HCFA 1500"
	;;^DD(399,.19,1,1,"%D",0)
	;;=^^2^2^2920430^
	;;^DD(399,.19,1,1,"%D",1,0)
	;;=If the HCFA 1500 claim form is used and no coding method defined, then
