IBINI027	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.8,.03,"DT")
	;;=2920219
	;;^DD(350.8,.04,0)
	;;=PACKAGE REPORTING ERROR^S^1:INTEGRATED BILLING;2:ACCOUNTS RECEIVABLE;3:PHARMACY;^0;4^Q
	;;^DD(350.8,.04,21,0)
	;;=^^2^2^2920415^^^
	;;^DD(350.8,.04,21,1,0)
	;;=This is the package that requested this entry in this file and will
	;;^DD(350.8,.04,21,2,0)
	;;=report it to IB as an error if the conditions are detected.
	;;^DD(350.8,.05,0)
	;;=ERROR ACTION^S^1:DISPLAY MESSAGE;2:SEND BULLETIN;3:EDIT FILE;^0;5^Q
	;;^DD(350.8,.05,21,0)
	;;=^^6^6^2910227^
	;;^DD(350.8,.05,21,1,0)
	;;=This is the type of action that should be taken when this error is
	;;^DD(350.8,.05,21,2,0)
	;;=reported to IB.  If action other than displaying a message is indicated
	;;^DD(350.8,.05,21,3,0)
	;;=then the MUMPS code in the ERROR ACTION field will be executed.
	;;^DD(350.8,.05,21,4,0)
	;;= 
	;;^DD(350.8,.05,21,5,0)
	;;=Currently only display actions are implemented.  Please contact the 
	;;^DD(350.8,.05,21,6,0)
	;;=developing ISC if other action types are desired.
	;;^DD(350.8,.06,0)
	;;=CORRESPONDING ALERT^P354.5'^IBE(354.5,^0;6^Q
	;;^DD(350.8,.06,21,0)
	;;=^^1^1^2940209^
	;;^DD(350.8,.06,21,1,0)
	;;=This is the type of alert that should be sent when this error occurs.
	;;^DD(350.8,.06,"DT")
	;;=2930322
	;;^DD(350.8,10,0)
	;;=EXECUTABLE LOGIC^K^^10;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(350.8,10,3)
	;;=This is Standard MUMPS code.
	;;^DD(350.8,10,21,0)
	;;=^^2^2^2910227^
	;;^DD(350.8,10,21,1,0)
	;;=This is the MUMPS code that will be executed if an error is reported
	;;^DD(350.8,10,21,2,0)
	;;=with an ERROR ACTION of other than to display a message.
