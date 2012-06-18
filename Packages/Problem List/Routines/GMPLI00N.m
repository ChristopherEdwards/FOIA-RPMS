GMPLI00N	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(9000011)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(9000011,.01,23,4,0)
	;;="Other Unknown or Unspecified Cause, NEC" will be used here in order
	;;^DD(9000011,.01,23,5,0)
	;;=to be able to create a new entry.  This field may later be edited.
	;;^DD(9000011,.01,"DT")
	;;=2940412
	;;^DD(9000011,.02,0)
	;;=PATIENT NAME^RP9000001'I^AUPNPAT(^0;2^Q
	;;^DD(9000011,.02,1,0)
	;;=^.1
	;;^DD(9000011,.02,1,1,0)
	;;=9000011^AC
	;;^DD(9000011,.02,1,1,1)
	;;=S ^AUPNPROB("AC",$E(X,1,30),DA)=""
	;;^DD(9000011,.02,1,1,2)
	;;=K ^AUPNPROB("AC",$E(X,1,30),DA)
	;;^DD(9000011,.02,1,2,0)
	;;=9000011^AATOO^MUMPS
	;;^DD(9000011,.02,1,2,1)
	;;=I $P(^AUPNPROB(DA,0),U,6)]"",$P(^(0),U,7)]"" S X1=$P($P(^(0),U,7),"."),X2=$P($P(^(0),U,7),".",2),^AUPNPROB("AA",X,$P(^(0),U,6)," "_$E("000",1,4-$L(X1)-1)_X1_"."_X2_$E("00",1,3-$L(X2)-1),DA)="" K X1,X2
	;;^DD(9000011,.02,1,2,2)
	;;=I $P(^AUPNPROB(DA,0),U,6)]"",$P(^(0),U,7)]"" S X1=$P($P(^(0),U,7),"."),X2=$P($P(^(0),U,7),".",2) K ^AUPNPROB("AA",X,$P(^(0),U,6)," "_$E("000",1,4-$L(X1)-1)_X1_"."_X2_$E("00",1,3-$L(X2)-1),DA),X1,X2
	;;^DD(9000011,.02,1,2,"%D",0)
	;;=^^3^3^2930825^
	;;^DD(9000011,.02,1,2,"%D",1,0)
	;;=Allows problem retrieval by patient, facility, and problem number (Nmbr);
	;;^DD(9000011,.02,1,2,"%D",2,0)
	;;=the number is used as a string in " 000.00" format to assure a consistent
	;;^DD(9000011,.02,1,2,"%D",3,0)
	;;=ordering.
	;;^DD(9000011,.02,1,3,0)
	;;=9000011^ACTIVE1^MUMPS
	;;^DD(9000011,.02,1,3,1)
	;;=S:$L($P(^AUPNPROB(DA,0),U,12)) ^AUPNPROB("ACTIVE",X,$P(^(0),U,12),DA)=""
	;;^DD(9000011,.02,1,3,2)
	;;=K:$L($P(^AUPNPROB(DA,0),U,12)) ^AUPNPROB("ACTIVE",X,$P(^(0),U,12),DA)
	;;^DD(9000011,.02,1,3,"%D",0)
	;;=^^1^1^2930706^^^
	;;^DD(9000011,.02,1,3,"%D",1,0)
	;;=Allows problem retrieval by patient and status, in order of entry.
	;;^DD(9000011,.02,1,3,"DT")
	;;=2930706
	;;^DD(9000011,.02,3)
	;;=Enter the name of the patient for whom this problem has been observed.
	;;^DD(9000011,.02,21,0)
	;;=^^1^1^2930908^^^^
	;;^DD(9000011,.02,21,1,0)
	;;=This is the patient for whom this problem has been observed and recorded.
	;;^DD(9000011,.02,"DT")
	;;=2930909
	;;^DD(9000011,.03,0)
	;;=DATE LAST MODIFIED^RD^^0;3^S %DT="EX" D ^%DT S X=Y K:DT<X!(2000000>X) X
	;;^DD(9000011,.03,1,0)
	;;=^.1^^0
	;;^DD(9000011,.03,3)
	;;=TYPE A DATE BETWEEN 1900 AND TODAY
	;;^DD(9000011,.03,10)
	;;=018/PRCOND
	;;^DD(9000011,.03,12)
	;;=VISIT MUST BE FOR CURRENT PATIENT
	;;^DD(9000011,.03,12.1)
	;;=S DIC("S")="I $P(^(0),U,5)=$P(^AUPNPROB(DA,0),U,2)"
	;;^DD(9000011,.03,21,0)
	;;=^^1^1^2930908^^^^
	;;^DD(9000011,.03,21,1,0)
	;;=This is the last date/time this problem was changed.
	;;^DD(9000011,.03,"DT")
	;;=2930706
	;;^DD(9000011,.04,0)
	;;=CLASS^S^P:PERSONAL HISTORY;F:FAMILY HISTORY;^0;4^Q
	;;^DD(9000011,.04,3)
	;;=If this problem is historical, indicate if it is Personal or Family history.
	;;^DD(9000011,.04,21,0)
	;;=^^2^2^2930726^
	;;^DD(9000011,.04,21,1,0)
	;;=This flag is used by the IHS Problem List to indicate if this problem
	;;^DD(9000011,.04,21,2,0)
	;;=is documented for historical purposes.
	;;^DD(9000011,.04,23,0)
	;;=^^2^2^2930726^
	;;^DD(9000011,.04,23,1,0)
	;;=VA sites using the DHCP Problem List application will not be prompted
	;;^DD(9000011,.04,23,2,0)
	;;=for this information.
	;;^DD(9000011,.04,"DT")
	;;=2871007
	;;^DD(9000011,.05,0)
	;;=PROVIDER NARRATIVE^R*P9999999.27^AUTNPOV(^0;5^S DIC(0)=$S($D(APCDALVR):"LO",1:"EMQLO") D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(9000011,.05,3)
	;;=Enter a description of this patient's problem.
	;;^DD(9000011,.05,12)
	;;=OLD LOOKUP
	;;^DD(9000011,.05,12.1)
	;;=S DIC(0)=$S($D(APCDALVR):"LO",1:"EMQLO")
