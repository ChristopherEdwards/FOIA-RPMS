IBINI00Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.137,21,2,0)
	;;=carrier can be reached.
	;;^DD(36,.137,22)
	;;=
	;;^DD(36,.137,"DT")
	;;=2930715
	;;^DD(36,.138,0)
	;;=INQUIRY PHONE NUMBER^F^^.13;8^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.138,3)
	;;=Enter the telephone number of the inquiry office with 7 - 20 characters, ex. 777-8888, 415 111 222 x123.
	;;^DD(36,.138,21,0)
	;;=^^1^1^2930715^
	;;^DD(36,.138,21,1,0)
	;;=Enter the telephone number at which the inquiry office of this insurance carrier can be reached.
	;;^DD(36,.138,"DT")
	;;=2930715
	;;^DD(36,.139,0)
	;;=PRECERT COMPANY NAME^*P36'X^DIC(36,^.13;9^S DIC(0)=DIC(0)_"F",DIC("S")="I '$P(^(0),U,5),'$P($G(^(.13)),U,9),(Y'=DA)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.139,5,1,0)
	;;=36^.178^1
	;;^DD(36,.139,12)
	;;=Select a company that processes precerts for this company.  Must be active, not this company, and process its own precerts.
	;;^DD(36,.139,12.1)
	;;=S DIC("S")="I '$P(^(0),U,5),'$P($G(^(.13)),U,9),(Y'=DA)"
	;;^DD(36,.139,21,0)
	;;=^^3^3^2931006^^^^
	;;^DD(36,.139,21,1,0)
	;;=You can only select a company that processes Precerts.  The company
	;;^DD(36,.139,21,2,0)
	;;=specified in this field must be an active insurance company, not the
	;;^DD(36,.139,21,3,0)
	;;=same company specified as handling Precerts for it.
	;;^DD(36,.139,"DT")
	;;=2931006
	;;^DD(36,.14,0)
	;;=FORM TYPE^P353'^IBE(353,^0;14^Q
	;;^DD(36,.14,3)
	;;=Enter the primary Form Type desired by this Insurance Company.
	;;^DD(36,.14,21,0)
	;;=^^7^7^2940209^^^^
	;;^DD(36,.14,21,1,0)
	;;=This is the primary form type for the insurance company.  An entry is
	;;^DD(36,.14,21,2,0)
	;;=needed only if the primary form type for this insurance company is
	;;^DD(36,.14,21,3,0)
	;;=different than the Default Form Type site parameter.
	;;^DD(36,.14,21,4,0)
	;;= 
	;;^DD(36,.14,21,5,0)
	;;=Used for the conversion from the UB-82 to the UB-92.  If this is set to
	;;^DD(36,.14,21,6,0)
	;;=either of those form types then all UB bills for this insurance
	;;^DD(36,.14,21,7,0)
	;;=company will be printed on that form.
	;;^DD(36,.14,23,0)
	;;=^^2^2^2940209^^
	;;^DD(36,.14,23,1,0)
	;;=Set up initially because companies are converting to the UB-92 at
	;;^DD(36,.14,23,2,0)
	;;=different times and once they do they will no longer accept the UB-82.
	;;^DD(36,.14,"DT")
	;;=2930826
	;;^DD(36,.141,0)
	;;=APPEALS ADDRESS ST. [LINE 1]^F^^.14;1^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.141,1,0)
	;;=^.1
	;;^DD(36,.141,1,1,0)
	;;=^^TRIGGER^36^.142
	;;^DD(36,.141,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.14)):^(.14),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.141,1,1,1.4)
	;;^DD(36,.141,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.14)):^(.14),1:""),DIV=X S $P(^(.14),U,2)=DIV,DIH=36,DIG=.142 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.141,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.14)):^(.14),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.141,1,1,2.4)
	;;^DD(36,.141,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.14)):^(.14),1:""),DIV=X S $P(^(.14),U,2)=DIV,DIH=36,DIG=.142 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.141,1,1,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.141,1,1,"%D",1,0)
	;;=When changing or deleting APPEALS ADDRESS ST. [LINE 1] delete
	;;^DD(36,.141,1,1,"%D",2,0)
	;;=APPEALS ADDRESS ST. [LINE 2].
	;;^DD(36,.141,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.141,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.141,1,1,"DT")
	;;=2930401
	;;^DD(36,.141,1,1,"FIELD")
	;;=APPEALS ADDRESS ST. [LINE 2]
	;;^DD(36,.141,1,2,0)
	;;=^^TRIGGER^36^.143
	;;^DD(36,.141,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.14)):^(.14),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.141,1,2,1.4)
