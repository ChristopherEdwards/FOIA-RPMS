IBINI00P	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.13,21,11,0)
	;;=entering policy or benefit information.
	;;^DD(36,.13,"DT")
	;;=2930603
	;;^DD(36,.131,0)
	;;=PHONE NUMBER^FX^^.13;1^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.131,3)
	;;=Enter the telephone number of the company with 7 - 20 characters, ex. 777-8888, 415 111 2222 x123.
	;;^DD(36,.131,21,0)
	;;=^^1^1^2911222^
	;;^DD(36,.131,21,1,0)
	;;=Enter the phone number at which this insurance carrier can be reached.
	;;^DD(36,.131,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,.131,"DT")
	;;=2930226
	;;^DD(36,.1311,0)
	;;=CLAIMS (RX) PHONE NUMBER^F^^.13;11^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.1311,3)
	;;=Enter the telephone number of the prescription claims office with 7 - 20 characters, ex. 777-8888, 415 111 2222x123.
	;;^DD(36,.1311,21,0)
	;;=^^1^1^2940104^^
	;;^DD(36,.1311,21,1,0)
	;;=Enter the phone number at which the prescription claims office of this insurance carrier can be reached.
	;;^DD(36,.1311,"DT")
	;;=2940104
	;;^DD(36,.132,0)
	;;=BILLING PHONE NUMBER^F^^.13;2^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.132,3)
	;;=Enter the telephone number of the billing office for this company.  Answer must be 7-20 characters in length.
	;;^DD(36,.132,21,0)
	;;=^^2^2^2911222^
	;;^DD(36,.132,21,1,0)
	;;=Enter the phone number of the insurance carrier where inquiries about
	;;^DD(36,.132,21,2,0)
	;;=patient billing should be made.
	;;^DD(36,.132,"DT")
	;;=2900504
	;;^DD(36,.133,0)
	;;=PRECERTIFICATION PHONE NUMBER^F^^.13;3^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.133,3)
	;;=Enter the phone number for getting Precertification of insurance if this company requires it.  Answer must be 7-20 characters in length.
	;;^DD(36,.133,21,0)
	;;=^^2^2^2911222^
	;;^DD(36,.133,21,1,0)
	;;=If precertification is required prior to a patient being treated, enter
	;;^DD(36,.133,21,2,0)
	;;=the number of the insurance carrier to which this request can be made.
	;;^DD(36,.133,"DT")
	;;=2900504
	;;^DD(36,.134,0)
	;;=VERIFICATION PHONE NUMBER^F^^.13;4^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.134,3)
	;;=Enter the phone number for getting verification of insurance.  Answer must be 7-20 characters in length.
	;;^DD(36,.134,21,0)
	;;=^^2^2^2930715^^
	;;^DD(36,.134,21,1,0)
	;;=Enter the phone number of the insurance carrier to which a Verification
	;;^DD(36,.134,21,2,0)
	;;=request can be made.
	;;^DD(36,.134,"DT")
	;;=2930329
	;;^DD(36,.135,0)
	;;=CLAIMS (INPT) PHONE NUMBER^F^^.13;5^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.135,3)
	;;=Enter the telephone number of the inpatient claims office with 7-20 characters, e.g. 777-8888, 415 111 2222 x123.
	;;^DD(36,.135,21,0)
	;;=^^2^2^2930715^^^^
	;;^DD(36,.135,21,1,0)
	;;=Enter the telephone number at which this insurance carrier's 
	;;^DD(36,.135,21,2,0)
	;;=inpatient claims office can be reached.
	;;^DD(36,.135,"DT")
	;;=2930715
	;;^DD(36,.136,0)
	;;=CLAIMS (OPT) PHONE NUMBER^F^^.13;6^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.136,3)
	;;=Enter the telephone number of the outpatient claims office with 7 - 20 characters, ex. 777-8888, 415 111 2222 x123.
	;;^DD(36,.136,21,0)
	;;=2
	;;^DD(36,.136,21,1,0)
	;;=Enter the phone number at which the outpatient claims office 
	;;^DD(36,.136,21,2,0)
	;;=of this insurance carrier can be reached.
	;;^DD(36,.136,"DT")
	;;=2930715
	;;^DD(36,.137,0)
	;;=APPEALS PHONE NUMBER^F^^.13;7^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.137,3)
	;;=Enter the telephone number of the appeals office with 7 - 20 characters, ex. 777-8888, 415 111 2222 x123.
	;;^DD(36,.137,21,0)
	;;=^^2^2^2930823^^^^
	;;^DD(36,.137,21,1,0)
	;;=Enter the telephone number at which the appeals office of this insurance
