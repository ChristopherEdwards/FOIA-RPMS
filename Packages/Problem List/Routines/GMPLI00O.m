GMPLI00O	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(9000011)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(9000011,.05,21,0)
	;;=^^2^2^2930406^^
	;;^DD(9000011,.05,21,1,0)
	;;=This contains the actual text used by the provider to describe this
	;;^DD(9000011,.05,21,2,0)
	;;=problem.
	;;^DD(9000011,.05,"DT")
	;;=2881128
	;;^DD(9000011,.06,0)
	;;=FACILITY^RP9999999.06'I^AUTTLOC(^0;6^Q
	;;^DD(9000011,.06,1,0)
	;;=^.1
	;;^DD(9000011,.06,1,1,0)
	;;=9000011^AV1^MUMPS
	;;^DD(9000011,.06,1,1,1)
	;;=Q
	;;^DD(9000011,.06,1,1,2)
	;;=Q
	;;^DD(9000011,.06,1,1,"%D",0)
	;;=^^1^1^2940110^
	;;^DD(9000011,.06,1,1,"%D",1,0)
	;;=No longer in use.
	;;^DD(9000011,.06,1,1,"DT")
	;;=2940110
	;;^DD(9000011,.06,1,2,0)
	;;=9000011^AATOO2^MUMPS
	;;^DD(9000011,.06,1,2,1)
	;;=I $P(^AUPNPROB(DA,0),U,2)]"",$P(^(0),U,7)]"" S X1=$P($P(^(0),U,7),"."),X2=$P($P(^(0),U,7),".",2),^AUPNPROB("AA",$P(^(0),U,2),X," "_$E("000",1,4-$L(X1)-1)_X1_"."_X2_$E("00",1,3-$L(X2)-1),DA)="" K X1,X2
	;;^DD(9000011,.06,1,2,2)
	;;=I $P(^AUPNPROB(DA,0),U,2)]"",$P(^(0),U,7)]"" S X1=$P($P(^(0),U,7),"."),X2=$P($P(^(0),U,7),".",2) K ^AUPNPROB("AA",$P(^(0),U,2),X," "_$E("000",1,4-$L(X1)-1)_X1_"."_X2_$E("00",1,3-$L(X2)-1),DA),X1,X2
	;;^DD(9000011,.06,1,2,"%D",0)
	;;=^^3^3^2930825^
	;;^DD(9000011,.06,1,2,"%D",1,0)
	;;=Allows problem retrieval by patient, facility, and problem number (Nmbr);
	;;^DD(9000011,.06,1,2,"%D",2,0)
	;;=the number is used as a string in " 000.00" format to assure a consistent
	;;^DD(9000011,.06,1,2,"%D",3,0)
	;;=ordering.
	;;^DD(9000011,.06,3)
	;;=Enter the location at which this problem was first observed and recorded.
	;;^DD(9000011,.06,21,0)
	;;=^^2^2^2930908^^^^
	;;^DD(9000011,.06,21,1,0)
	;;=This is the facility at which this problem was originally observed and
	;;^DD(9000011,.06,21,2,0)
	;;=documented.
	;;^DD(9000011,.06,"DT")
	;;=2940110
	;;^DD(9000011,.07,0)
	;;=NMBR^RNJ6,2X^^0;7^K:+X'=X!(X>999.99)!(X<1)!(X?.E1"."3N.N) X Q:'$D(X)  K:$D(^AUPNPROB("AA",$P(^AUPNPROB(DA,0),U,2),$P(^(0),U,6)," "_$E("000",1,4-$L($P(X,".",1))-1)_$P(X,".",1)_"."_$P(X,".",2)_$E("00",1,3-$L($P(X,".",2))-1))) X
	;;^DD(9000011,.07,1,0)
	;;=^.1
	;;^DD(9000011,.07,1,1,0)
	;;=9000011^AA^MUMPS
	;;^DD(9000011,.07,1,1,1)
	;;=S ^AUPNPROB("AA",$P(^AUPNPROB(DA,0),U,2),$P(^(0),U,6)," "_$E("000",1,4-$L($P(X,".",1))-1)_$P(X,".",1)_"."_$P(X,".",2)_$E("00",1,3-$L($P(X,".",2))-1),DA)=""
	;;^DD(9000011,.07,1,1,2)
	;;=K ^AUPNPROB("AA",$P(^AUPNPROB(DA,0),U,2),$P(^(0),U,6)," "_$E("000",1,4-$L($P(X,".",1))-1)_$P(X,".",1)_"."_$P(X,".",2)_$E("00",1,3-$L($P(X,".",2))-1),DA)
	;;^DD(9000011,.07,1,1,"%D",0)
	;;=^^3^3^2930825^
	;;^DD(9000011,.07,1,1,"%D",1,0)
	;;=Allows problem retrieval by patient, facility, and problem number (Nmbr);
	;;^DD(9000011,.07,1,1,"%D",2,0)
	;;=the number is used as a string in " 000.00" format to assure a consistent
	;;^DD(9000011,.07,1,1,"%D",3,0)
	;;=ordering.
	;;^DD(9000011,.07,3)
	;;=TYPE A NUMBER BETWEEN 1 AND 999.99
	;;^DD(9000011,.07,10)
	;;=018/PRNUMB
	;;^DD(9000011,.07,21,0)
	;;=^^4^4^2930726^
	;;^DD(9000011,.07,21,1,0)
	;;=This is a number which, together with the Patient (#.02) and Facility (#.06)
	;;^DD(9000011,.07,21,2,0)
	;;=fields, serves as a unique identifier for this problem.  Up to 2 decimal
	;;^DD(9000011,.07,21,3,0)
	;;=places may be used to indicate that a problem is a result of, or related
	;;^DD(9000011,.07,21,4,0)
	;;=to, another problem.
	;;^DD(9000011,.07,"DT")
	;;=2930726
	;;^DD(9000011,.08,0)
	;;=DATE ENTERED^RDI^^0;8^S %DT="EX" D ^%DT S X=Y K:DT<X!(2000000>X) X
	;;^DD(9000011,.08,3)
	;;=TYPE A DATE BETWEEN 1900 AND TODAY
	;;^DD(9000011,.08,10)
	;;=018/PREDAT
	;;^DD(9000011,.08,12)
	;;=VISIT MUST BE FOR CURRENT PATIENT
