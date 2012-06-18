IBINI04T	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,.02,1,1,1)
	;;=S ^IBA(355.4,"C",$E(X,1,30),DA)=""
	;;^DD(355.4,.02,1,1,2)
	;;=K ^IBA(355.4,"C",$E(X,1,30),DA)
	;;^DD(355.4,.02,1,1,"DT")
	;;=2930525
	;;^DD(355.4,.02,1,2,0)
	;;=355.4^APY^MUMPS
	;;^DD(355.4,.02,1,2,1)
	;;=S:+^IBA(355.4,DA,0) ^IBA(355.4,"APY",X,-^(0),DA)=""
	;;^DD(355.4,.02,1,2,2)
	;;=K ^IBA(355.4,"APY",X,-^IBA(355.4,DA,0),DA)
	;;^DD(355.4,.02,1,2,3)
	;;=DO NOT DELETE
	;;^DD(355.4,.02,1,2,"%D",0)
	;;=^^1^1^2930831^^^^
	;;^DD(355.4,.02,1,2,"%D",1,0)
	;;=Cross-reference of all policies by calendar year.
	;;^DD(355.4,.02,1,2,"DT")
	;;=2930831
	;;^DD(355.4,.02,21,0)
	;;=^^3^3^2930604^^
	;;^DD(355.4,.02,21,1,0)
	;;=This is the particular health insurance policy that provides some 
	;;^DD(355.4,.02,21,2,0)
	;;=subset of all of the possible benefits for the year selected.
	;;^DD(355.4,.02,21,3,0)
	;;=Enter the name of the health insurance policy.
	;;^DD(355.4,.02,"DT")
	;;=2930831
	;;^DD(355.4,.05,0)
	;;=MAX. OUT OF POCKET^NJ9,2^^0;5^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,.05,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,.05,21,0)
	;;=^^3^3^2930825^^
	;;^DD(355.4,.05,21,1,0)
	;;=This is the dollar amount that this policy does not cover in claims.
	;;^DD(355.4,.05,21,2,0)
	;;=This information will be used in calculating whether reimbursement
	;;^DD(355.4,.05,21,3,0)
	;;=for claims against this policy are appropriate.
	;;^DD(355.4,.05,"DT")
	;;=2930825
	;;^DD(355.4,.06,0)
	;;=AMBULANCE COVERAGE (%)^NJ3,0^^0;6^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,.06,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,.06,21,0)
	;;=^^2^2^2930604^
	;;^DD(355.4,.06,21,1,0)
	;;=If this policy provides an ambulance coverage benefit, then this is 
	;;^DD(355.4,.06,21,2,0)
	;;=the amount of that benefit.
	;;^DD(355.4,.06,"DT")
	;;=2930513
	;;^DD(355.4,1.01,0)
	;;=DATE ENTERED^D^^1;1^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.4,1.01,3)
	;;=
	;;^DD(355.4,1.01,5,1,0)
	;;=355.4^.01^3
	;;^DD(355.4,1.01,9)
	;;=^
	;;^DD(355.4,1.01,21,0)
	;;=^^2^2^2930604^^
	;;^DD(355.4,1.01,21,1,0)
	;;=This is the date that the information was first entered.  It is
	;;^DD(355.4,1.01,21,2,0)
	;;=necessary to supply a time as well as date, for example "12/12/93@1300".
	;;^DD(355.4,1.01,"DT")
	;;=2940228
	;;^DD(355.4,1.02,0)
	;;=ENTERED BY^P200'^VA(200,^1;2^Q
	;;^DD(355.4,1.02,3)
	;;=
	;;^DD(355.4,1.02,5,1,0)
	;;=355.4^.01^4
	;;^DD(355.4,1.02,9)
	;;=^
	;;^DD(355.4,1.02,21,0)
	;;=^^1^1^2930607^^
	;;^DD(355.4,1.02,21,1,0)
	;;=This is the name of the person who entered the information.
	;;^DD(355.4,1.02,"DT")
	;;=2930520
	;;^DD(355.4,1.03,0)
	;;=DATE LAST VERIFIED^D^^1;3^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.4,1.03,3)
	;;=
	;;^DD(355.4,1.03,21,0)
	;;=^^2^2^2930604^
	;;^DD(355.4,1.03,21,1,0)
	;;=This is the date that the information was last verified.  It is 
	;;^DD(355.4,1.03,21,2,0)
	;;=necessary to supply a time as well as date, for example "12/12/93@1300".
	;;^DD(355.4,1.03,"DT")
	;;=2930707
	;;^DD(355.4,1.04,0)
	;;=VERIFIED BY^P200'^VA(200,^1;4^Q
	;;^DD(355.4,1.04,3)
	;;=
	;;^DD(355.4,1.04,21,0)
	;;=^^2^2^2930604^
	;;^DD(355.4,1.04,21,1,0)
	;;=This is the name of the person who verified the information on
	;;^DD(355.4,1.04,21,2,0)
	;;="DATE LAST VERIFIED".
	;;^DD(355.4,1.04,"DT")
	;;=2930520
	;;^DD(355.4,1.05,0)
	;;=DATE LAST EDITED^D^^1;5^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.4,1.05,3)
	;;=
	;;^DD(355.4,1.05,9)
	;;=^
	;;^DD(355.4,1.05,21,0)
	;;=^^2^2^2930604^^
	;;^DD(355.4,1.05,21,1,0)
	;;=This is the date that the information was last edited.  The time must be
