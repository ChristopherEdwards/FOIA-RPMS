GMPLI002	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(49)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(49,1.6,"DT")
	;;=2860906
	;;^DD(49,1.7,0)
	;;=TYPE OF SERVICE^S^C:PATIENT CARE;A:ADMINISTRATIVE;^0;9^Q
	;;^DD(49,1.7,1,0)
	;;=^.1
	;;^DD(49,1.7,1,1,0)
	;;=49^F
	;;^DD(49,1.7,1,1,1)
	;;=S ^DIC(49,"F",$E(X,1,30),DA)=""
	;;^DD(49,1.7,1,1,2)
	;;=K ^DIC(49,"F",$E(X,1,30),DA)
	;;^DD(49,1.7,1,1,"DT")
	;;=2930504
	;;^DD(49,1.7,3)
	;;=Enter C if this is a clinical service, providing direct patient care; if this service is primarily administrative, enter A.
	;;^DD(49,1.7,21,0)
	;;=^^2^2^2940208^^
	;;^DD(49,1.7,21,1,0)
	;;=This flag indicates the type of each entry in this file.  Services or
	;;^DD(49,1.7,21,2,0)
	;;=sub-services may be marked as Administrative or for Patient Care.
	;;^DD(49,1.7,"DT")
	;;=2930504
