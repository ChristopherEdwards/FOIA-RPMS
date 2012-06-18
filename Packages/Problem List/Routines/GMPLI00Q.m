GMPLI00Q	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(9000011)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(9000011,1.03,"DT")
	;;=2930726
	;;^DD(9000011,1.04,0)
	;;=RECORDING PROVIDER^P200'^VA(200,^1;4^Q
	;;^DD(9000011,1.04,3)
	;;=Enter the name of the provider who first recorded this data.
	;;^DD(9000011,1.04,21,0)
	;;=^^2^2^2940324^^
	;;^DD(9000011,1.04,21,1,0)
	;;=This is the provider who first recorded this problem, either on the
	;;^DD(9000011,1.04,21,2,0)
	;;=paper chart or online.
	;;^DD(9000011,1.04,"DT")
	;;=2930726
	;;^DD(9000011,1.05,0)
	;;=RESPONSIBLE PROVIDER^P200'^VA(200,^1;5^Q
	;;^DD(9000011,1.05,3)
	;;=Enter the name of the local provider treating this problem.
	;;^DD(9000011,1.05,21,0)
	;;=^^1^1^2930726^
	;;^DD(9000011,1.05,21,1,0)
	;;=This is the provider currently responsible for treating this problem.
	;;^DD(9000011,1.05,"DT")
	;;=2930726
	;;^DD(9000011,1.06,0)
	;;=SERVICE^P49'^DIC(49,^1;6^Q
	;;^DD(9000011,1.06,3)
	;;=Enter the service to be associated with this problem.
	;;^DD(9000011,1.06,21,0)
	;;=^^5^5^2931223^^^
	;;^DD(9000011,1.06,21,1,0)
	;;=This is the service primarily involved in the treatment of this problem;
	;;^DD(9000011,1.06,21,2,0)
	;;=the DHCP Problem List defaults this field to the service defined in
	;;^DD(9000011,1.06,21,3,0)
	;;=File #200 for the Recording Provider of this problem, upon entry of the
	;;^DD(9000011,1.06,21,4,0)
	;;=problem.  It may later be used to categorize problems for screening and
	;;^DD(9000011,1.06,21,5,0)
	;;=sorting.
	;;^DD(9000011,1.06,"DT")
	;;=2930726
	;;^DD(9000011,1.07,0)
	;;=DATE RESOLVED^D^^1;7^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(9000011,1.07,3)
	;;=Enter the date this problem became resolved or inactive, as precisely as known.
	;;^DD(9000011,1.07,21,0)
	;;=^^2^2^2930726^
	;;^DD(9000011,1.07,21,1,0)
	;;=This is the date this problem was resolved or inactivated, as precisely
	;;^DD(9000011,1.07,21,2,0)
	;;=as known.
	;;^DD(9000011,1.07,"DT")
	;;=2930726
	;;^DD(9000011,1.08,0)
	;;=CLINIC^*P44'^SC(^1;8^S DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(9000011,1.08,3)
	;;=Enter the clinic in which the patient is being seen for this problem.
	;;^DD(9000011,1.08,12)
	;;=Only clinics are allowed here.
	;;^DD(9000011,1.08,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)=""C"""
	;;^DD(9000011,1.08,21,0)
	;;=^^3^3^2931223^
	;;^DD(9000011,1.08,21,1,0)
	;;=This is the clinic in which this patient is being seen for this problem.
	;;^DD(9000011,1.08,21,2,0)
	;;=The problem list may be screened based on this value, to change one's
	;;^DD(9000011,1.08,21,3,0)
	;;=view of the list.
	;;^DD(9000011,1.08,"DT")
	;;=2940412
	;;^DD(9000011,1.09,0)
	;;=DATE RECORDED^D^^1;9^S %DT="E" D ^%DT S X=Y K:DT<X!(2000000>X) X
	;;^DD(9000011,1.09,3)
	;;=Enter the date this problem was first recorded, as precisely as known.
	;;^DD(9000011,1.09,21,0)
	;;=^^3^3^2940118^
	;;^DD(9000011,1.09,21,1,0)
	;;=This is the date this problem was originally recorded, either online or
	;;^DD(9000011,1.09,21,2,0)
	;;=in the paper chart; it may be the same as, or earlier than, the Date
	;;^DD(9000011,1.09,21,3,0)
	;;=Entered.
	;;^DD(9000011,1.09,"DT")
	;;=2940111
	;;^DD(9000011,1.1,0)
	;;=SERVICE CONNECTED^S^1:YES;0:NO;^1;10^Q
	;;^DD(9000011,1.1,3)
	;;=If this problem is service connected, enter YES here.
	;;^DD(9000011,1.1,21,0)
	;;=^^2^2^2930726^^^
	;;^DD(9000011,1.1,21,1,0)
	;;=If the patient has service connection on file in the DHCP Patient file #2,
	;;^DD(9000011,1.1,21,2,0)
	;;=this problem specifically may be flagged as being service connected.
	;;^DD(9000011,1.1,23,0)
	;;=^^3^3^2930726^^
	;;^DD(9000011,1.1,23,1,0)
	;;=This data will be prompted for in the DHCP Problem List only if the
