IBINI053	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.5,.1,"DT")
	;;=2931214
	;;^DD(355.5,.11,0)
	;;=MH DEDUCTIBLE (INP) MET?^S^0:NO;1:YES;^0;11^Q
	;;^DD(355.5,.11,21,0)
	;;=^^4^4^2940213^^^
	;;^DD(355.5,.11,21,1,0)
	;;=If the dollar amount of claims for inpatient mental health services
	;;^DD(355.5,.11,21,2,0)
	;;=is less than the policy's annual deductible for these services,
	;;^DD(355.5,.11,21,3,0)
	;;=enter "NO".  If it is equal to or greater than the annual 
	;;^DD(355.5,.11,21,4,0)
	;;=deductible for such services, enter "YES".
	;;^DD(355.5,.11,"DT")
	;;=2930513
	;;^DD(355.5,.12,0)
	;;=AMOUNT OF MH (INP) DED MET^NJ6,0^^0;12^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.5,.12,3)
	;;=Type a Number between 0 and 999999, 0 Decimal Digits
	;;^DD(355.5,.12,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,.12,21,1,0)
	;;=Enter the dollar amount of claims against this policy for inpatient
	;;^DD(355.5,.12,21,2,0)
	;;=mental health services.
	;;^DD(355.5,.12,"DT")
	;;=2930513
	;;^DD(355.5,.13,0)
	;;=MH DEDUCTIBLE (OPT) MET?^S^0:NO;1:YES;^0;13^Q
	;;^DD(355.5,.13,3)
	;;=
	;;^DD(355.5,.13,21,0)
	;;=^^4^4^2930713^
	;;^DD(355.5,.13,21,1,0)
	;;=If the dollar amount of claims for outpatient mental health services
	;;^DD(355.5,.13,21,2,0)
	;;=is less than the policy's annual deductible for these services,
	;;^DD(355.5,.13,21,3,0)
	;;=enter "NO".  If it is equal to or greater than the annual deductible
	;;^DD(355.5,.13,21,4,0)
	;;=for such services, enter "YES".
	;;^DD(355.5,.13,"DT")
	;;=2930513
	;;^DD(355.5,.14,0)
	;;=AMOUNT OF MH (OPT) DED MET^NJ6,0^^0;14^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.5,.14,3)
	;;=Type a Number between 0 and 999999, 0 Decimal Digits
	;;^DD(355.5,.14,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,.14,21,1,0)
	;;=Enter the dollar amount of claims against this policy for outpatient
	;;^DD(355.5,.14,21,2,0)
	;;=mental health services.
	;;^DD(355.5,.14,"DT")
	;;=2930513
	;;^DD(355.5,.15,0)
	;;=PRE-EXISTING CONDITIONS^F^^0;15^K:$L(X)>30!($L(X)<3) X
	;;^DD(355.5,.15,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(355.5,.15,21,0)
	;;=^^1^1^2930713^
	;;^DD(355.5,.15,21,1,0)
	;;=Enter the patient's pre-existing conditions.
	;;^DD(355.5,.15,"DT")
	;;=2930513
	;;^DD(355.5,.16,0)
	;;=COORDINATION OF BENEFITS DATA^F^^0;16^K:$L(X)>30!($L(X)<3) X
	;;^DD(355.5,.16,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(355.5,.16,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,.16,21,1,0)
	;;=If the patient is included in a policy held by a family member, e.g.
	;;^DD(355.5,.16,21,2,0)
	;;=spouse, enter that information here.
	;;^DD(355.5,.16,"DT")
	;;=2930513
	;;^DD(355.5,.17,0)
	;;=PATIENT POLICY POINTER^NJ6,0I^^0;17^K:+X'=X!(X>999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(355.5,.17,1,0)
	;;=^.1
	;;^DD(355.5,.17,1,1,0)
	;;=355.5^APPY3^MUMPS
	;;^DD(355.5,.17,1,1,1)
	;;=I $P(^IBA(355.5,DA,0),U,2),+^(0),-$P(^(0),U,3) S ^IBA(355.5,"APPY",+$P(^(0),U,2),+^(0),-$P(^(0),U,3),X,DA)=""
	;;^DD(355.5,.17,1,1,2)
	;;=K ^IBA(355.5,"APPY",+$P(^(0),U,2),+^(0),-$P(^(0),U,3),X,DA)
	;;^DD(355.5,.17,1,1,"%D",0)
	;;=^^1^1^2930831^^^
	;;^DD(355.5,.17,1,1,"%D",1,0)
	;;=Cross-references patients by policy by year.
	;;^DD(355.5,.17,1,1,"DT")
	;;=2930831
	;;^DD(355.5,.17,3)
	;;=Type a Number between 1 and 999999, 0 Decimal Digits
	;;^DD(355.5,.17,8.5)
	;;=^
	;;^DD(355.5,.17,9)
	;;=^
	;;^DD(355.5,.17,"DT")
	;;=2930831
	;;^DD(355.5,.18,0)
	;;=AMT. MH LIFET. MAX USED (INPT)^NJ10,2^^0;18^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.5,.18,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(355.5,.18,21,0)
	;;=^^2^2^2931214^^^^
