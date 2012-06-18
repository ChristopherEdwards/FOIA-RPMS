IBINI0AJ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,161,1,0)
	;;=^.1
	;;^DD(399,161,1,1,0)
	;;=^^TRIGGER^399^162
	;;^DD(399,161,1,1,1)
	;;=X ^DD(399,161,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X=DIV D DIS^IBCU S X=X X ^DD(399,161,1,1,1.4)
	;;^DD(399,161,1,1,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$S('$D(^DGCR(399.1,+$P(Y(1),U,12),0)):"",1:$P(^(0),U,1))=""
	;;^DD(399,161,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,12)=DIV,DIH=399,DIG=162 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,161,1,1,2)
	;;=Q
	;;^DD(399,161,1,1,"%D",0)
	;;=^^2^2^2920212^
	;;^DD(399,161,1,1,"%D",1,0)
	;;=Sets the Discharge Status field to the correct status based upon the
	;;^DD(399,161,1,1,"%D",2,0)
	;;=Disposition Type field in the PTF Record.
	;;^DD(399,161,1,1,"CREATE CONDITION")
	;;=#162=""
	;;^DD(399,161,1,1,"CREATE VALUE")
	;;=D DIS^IBCU S X=X
	;;^DD(399,161,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,161,1,1,"DT")
	;;=2920212
	;;^DD(399,161,1,1,"FIELD")
	;;=#162
	;;^DD(399,161,3)
	;;=Enter the bedsection from which this patient was discharged.
	;;^DD(399,161,12)
	;;=Valid MCCR Bedsections only!
	;;^DD(399,161,12.1)
	;;=S DIC("S")="I $P(^DGCR(399.1,+Y,0),""^"",5)=1"
	;;^DD(399,161,21,0)
	;;=^^1^1^2880901^
	;;^DD(399,161,21,1,0)
	;;=This is the bedsection from which this patient was discharged.
	;;^DD(399,161,"DT")
	;;=2920212
	;;^DD(399,162,0)
	;;=DISCHARGE STATUS^*P399.1'^DGCR(399.1,^U;12^S DIC("S")="I $P(^DGCR(399.1,+Y,0),""^"",6)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,162,3)
	;;=Enter the code which indicates patient status as of statement covers through date.
	;;^DD(399,162,5,1,0)
	;;=399^161^1
	;;^DD(399,162,5,2,0)
	;;=399^.08^4
	;;^DD(399,162,12)
	;;=Valid MCCR Discharge Statuses only!
	;;^DD(399,162,12.1)
	;;=S DIC("S")="I $P(^DGCR(399.1,+Y,0),""^"",6)=1"
	;;^DD(399,162,21,0)
	;;=^^1^1^2880901^
	;;^DD(399,162,21,1,0)
	;;=This is the patient status as of the statement covers through date.
	;;^DD(399,162,"DT")
	;;=2880831
	;;^DD(399,163,0)
	;;=TREATMENT AUTHORIZATION CODE^F^^U;13^K:$L(X)>18!($L(X)<1) X
	;;^DD(399,163,3)
	;;=Answer must be 1-18 characters in length.
	;;^DD(399,163,21,0)
	;;=^^4^4^2931220^^^^
	;;^DD(399,163,21,1,0)
	;;=This indicates that the treatment covered by this bill has been authorized
	;;^DD(399,163,21,2,0)
	;;=by the payer.
	;;^DD(399,163,21,3,0)
	;;= 
	;;^DD(399,163,21,4,0)
	;;=On the HCFA 1500 this is block 23, PRIOR AUTHORIZATION NUMBER.
	;;^DD(399,163,"DT")
	;;=2931220
	;;^DD(399,164,0)
	;;=BC/BS PROVIDER #^RFX^^U;14^K:$L(X)>13!($L(X)<3)!'(X?.ANP) X
	;;^DD(399,164,3)
	;;=Enter the Blue Cross/Shield provider number for this particular billing episode.
	;;^DD(399,164,5,1,0)
	;;=399^.01^5
	;;^DD(399,164,21,0)
	;;=^^1^1^2880901^
	;;^DD(399,164,21,1,0)
	;;=This is the Blue Cross/Blue Shield Provider Number for this billing episode.
	;;^DD(399,164,"DT")
	;;=2910819
	;;^DD(399,165,0)
	;;=LENGTH OF STAY^F^^U;15^K:$L(X)>6!($L(X)<1)!'(X?.N) X
	;;^DD(399,165,3)
	;;=Enter the length of stay for this inpatient episode excluding pass, AA and UA days.
	;;^DD(399,165,5,1,0)
	;;=399^.08^6
	;;^DD(399,165,5,2,0)
	;;=399^151^1
	;;^DD(399,165,5,3,0)
	;;=399^152^1
	;;^DD(399,165,21,0)
	;;=^^2^2^2931018^^^^
	;;^DD(399,165,21,1,0)
	;;=This defines the length of stay in days for this inpatient episode excluding
	;;^DD(399,165,21,2,0)
	;;=pass, AA, and UA days.
	;;^DD(399,165,23,0)
	;;=^^12^12^2931018^^^^
	;;^DD(399,165,23,1,0)
	;;=If no PTF defined then uses the Statement From and To dates for LOS.
