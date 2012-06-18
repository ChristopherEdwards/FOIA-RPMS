IBINI067	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.23,"DT")
	;;=2930610
	;;^DD(356.2,.24,0)
	;;=NEXT REVIEW DATE^D^^0;24^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.2,.24,1,0)
	;;=^.1
	;;^DD(356.2,.24,1,1,0)
	;;=356.2^APEND
	;;^DD(356.2,.24,1,1,1)
	;;=S ^IBT(356.2,"APEND",$E(X,1,30),DA)=""
	;;^DD(356.2,.24,1,1,2)
	;;=K ^IBT(356.2,"APEND",$E(X,1,30),DA)
	;;^DD(356.2,.24,1,1,"%D",0)
	;;=^^1^1^2930804^
	;;^DD(356.2,.24,1,1,"%D",1,0)
	;;=This cross-refence is used to find contacts that need futher action.
	;;^DD(356.2,.24,1,1,"DT")
	;;=2930804
	;;^DD(356.2,.24,5,1,0)
	;;=356.2^.13^1
	;;^DD(356.2,.24,5,2,0)
	;;=356.2^.16^1
	;;^DD(356.2,.24,5,3,0)
	;;=356.2^.19^2
	;;^DD(356.2,.24,5,4,0)
	;;=356.2^.1^1
	;;^DD(356.2,.24,21,0)
	;;=^^9^9^2940213^^
	;;^DD(356.2,.24,21,1,0)
	;;=This is the date that this should show up on your Pending Work list.  If
	;;^DD(356.2,.24,21,2,0)
	;;=you have entered an admission review with a next review date in three
	;;^DD(356.2,.24,21,3,0)
	;;=days, you will, in three days, have either a continued stay review or
	;;^DD(356.2,.24,21,4,0)
	;;=a discharge review to do depending on the patient's status.  If this
	;;^DD(356.2,.24,21,5,0)
	;;=is a denial contact an the next review date is in three days, in three
	;;^DD(356.2,.24,21,6,0)
	;;=days you will show and appeal that needs to be done.  Etc.
	;;^DD(356.2,.24,21,7,0)
	;;= 
	;;^DD(356.2,.24,21,8,0)
	;;=If no entry is in this field then you will not be reminded of pending
	;;^DD(356.2,.24,21,9,0)
	;;=work.
	;;^DD(356.2,.24,"DT")
	;;=2930804
	;;^DD(356.2,.25,0)
	;;=NUMBER OF DAYS PENDING APPEAL^NJ3,0^^0;25^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.2,.25,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(356.2,.25,21,0)
	;;=^^3^3^2930806^
	;;^DD(356.2,.25,21,1,0)
	;;=If the insurance company denied reimbursement for days of care, either
	;;^DD(356.2,.25,21,2,0)
	;;=in part or in total, and you are appealing that denial, then enter the
	;;^DD(356.2,.25,21,3,0)
	;;=number of days being appealed.
	;;^DD(356.2,.25,"DT")
	;;=2930812
	;;^DD(356.2,.26,0)
	;;=OUTPATIENT TREATMENT^F^^0;26^K:$L(X)>20!($L(X)<3) X
	;;^DD(356.2,.26,3)
	;;=Answer must be 3-20 characters in length.
	;;^DD(356.2,.26,21,0)
	;;=^^4^4^2940213^^
	;;^DD(356.2,.26,21,1,0)
	;;=If this contact is to determine if a particular outpatient
	;;^DD(356.2,.26,21,2,0)
	;;=treatment will be authorized for reimbursement, this is the 
	;;^DD(356.2,.26,21,3,0)
	;;=outpatient treatment that is authorized.  Enter the free-text
	;;^DD(356.2,.26,21,4,0)
	;;=description of the outpatient treatment.
	;;^DD(356.2,.26,"DT")
	;;=2930610
	;;^DD(356.2,.27,0)
	;;=TREATMENT AUTHORIZED^S^1:YES;0:NO;^0;27^Q
	;;^DD(356.2,.27,21,0)
	;;=^^5^5^2940213^^^
	;;^DD(356.2,.27,21,1,0)
	;;=Entry 'YES' if this was authorized or 'NO' if it was not authorized.
	;;^DD(356.2,.27,21,2,0)
	;;= 
	;;^DD(356.2,.27,21,3,0)
	;;=If this contact is to determine if a particular outpatient 
	;;^DD(356.2,.27,21,4,0)
	;;=treatment is authorized for reimbursement, then this is
	;;^DD(356.2,.27,21,5,0)
	;;=whether or not the treatment was authorized.  
	;;^DD(356.2,.27,"DT")
	;;=2930610
	;;^DD(356.2,.28,0)
	;;=AUTHORIZATION NUMBER^F^^0;28^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>18!($L(X)<3) X
	;;^DD(356.2,.28,1,0)
	;;=^.1
	;;^DD(356.2,.28,1,1,0)
	;;=356.2^APRE1^MUMPS
	;;^DD(356.2,.28,1,1,1)
	;;=S:$P(^IBT(356.2,DA,0),U,2) ^IBT(356.2,"APRE",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.2,.28,1,1,2)
	;;=K ^IBT(356.2,"APRE",+$P(^IBT(356.2,DA,0),U,2),X,DA)
	;;^DD(356.2,.28,1,1,"%D",0)
	;;=^^1^1^2930729^
	;;^DD(356.2,.28,1,1,"%D",1,0)
	;;=Cross-reference of pre-cert numbers by tracking id.
