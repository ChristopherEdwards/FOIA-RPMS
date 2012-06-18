IBINI0AZ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.046,.02,0)
	;;=USER^P200'^VA(200,^0;2^Q
	;;^DD(399.046,.02,1,0)
	;;=^.1^^0
	;;^DD(399.046,.02,21,0)
	;;=^^1^1^2911025^
	;;^DD(399.046,.02,21,1,0)
	;;=This is the user who edited or returned the bill.
	;;^DD(399.046,.02,"DT")
	;;=2901004
	;;^DD(399.046,.03,0)
	;;=RETURNED COMMENTS^F^^0;3^K:$L(X)>80!($L(X)<3) X
	;;^DD(399.046,.03,3)
	;;=Answer must be 3-80 characters in length.
	;;^DD(399.046,.03,21,0)
	;;=^^2^2^2940214^^
	;;^DD(399.046,.03,21,1,0)
	;;=Enter any comments that you would like stored with this bill.  This may
	;;^DD(399.046,.03,21,2,0)
	;;=include documentation of any changes and why they occured.
	;;^DD(399.046,.03,"DT")
	;;=2900606
	;;^DD(399.046,.04,0)
	;;=RETURN TO A/R?^FXO^^0;4^I $D(X) D YN^IBCU
	;;^DD(399.046,.04,1,0)
	;;=^.1
	;;^DD(399.046,.04,1,1,0)
	;;=399.046^AC
	;;^DD(399.046,.04,1,1,1)
	;;=S ^DGCR(399,DA(1),"R","AC",$E(X,1,30),DA)=""
	;;^DD(399.046,.04,1,1,2)
	;;=K ^DGCR(399,DA(1),"R","AC",$E(X,1,30),DA)
	;;^DD(399.046,.04,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399.046,.04,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399.046,.04,3)
	;;=Answer must be 1 character in length.
	;;^DD(399.046,.04,21,0)
	;;=^^2^2^2911025^^
	;;^DD(399.046,.04,21,1,0)
	;;=Enter 'Yes' if you are returning this bill to Accounts Receivable at
	;;^DD(399.046,.04,21,2,0)
	;;=this time.  Enter 'No' if you do not wish to return this bill at this time.
	;;^DD(399.046,.04,"DT")
	;;=2920921
	;;^DD(399.047,0)
	;;=VALUE CODE SUB-FIELD^^.02^2
	;;^DD(399.047,0,"DIK")
	;;=IBXX
	;;^DD(399.047,0,"DT")
	;;=2931222
	;;^DD(399.047,0,"IX","B",399.047,.01)
	;;=
	;;^DD(399.047,0,"NM","VALUE CODE")
	;;=
	;;^DD(399.047,0,"UP")
	;;=399
	;;^DD(399.047,.01,0)
	;;=VALUE CODE^M*P399.1'^DGCR(399.1,^0;1^S DIC("S")="I +$P($G(^DGCR(399.1,+Y,0)),U,11)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.047,.01,1,0)
	;;=^.1
	;;^DD(399.047,.01,1,1,0)
	;;=399.047^B
	;;^DD(399.047,.01,1,1,1)
	;;=S ^DGCR(399,DA(1),"CV","B",$E(X,1,30),DA)=""
	;;^DD(399.047,.01,1,1,2)
	;;=K ^DGCR(399,DA(1),"CV","B",$E(X,1,30),DA)
	;;^DD(399.047,.01,3)
	;;=Enter a Value Code that applies to this bill.
	;;^DD(399.047,.01,12)
	;;=Value Codes Only!
	;;^DD(399.047,.01,12.1)
	;;=S DIC("S")="I +$P($G(^DGCR(399.1,+Y,0)),U,11)"
	;;^DD(399.047,.01,21,0)
	;;=^^2^2^2931230^^
	;;^DD(399.047,.01,21,1,0)
	;;=This code relates amounts or values to identified data elements necessary
	;;^DD(399.047,.01,21,2,0)
	;;=to process this claim as qualified by the payer.
	;;^DD(399.047,.01,"DT")
	;;=2931222
	;;^DD(399.047,.02,0)
	;;=VALUE^F^^0;2^K:$L(X)>9!($L(X)<1) X
	;;^DD(399.047,.02,3)
	;;=Answer must be 1-9 characters in length.
	;;^DD(399.047,.02,21,0)
	;;=^^1^1^2931222^^
	;;^DD(399.047,.02,21,1,0)
	;;=Enter the amount or value that corresponds to this value code.
	;;^DD(399.047,.02,"DT")
	;;=2931222
