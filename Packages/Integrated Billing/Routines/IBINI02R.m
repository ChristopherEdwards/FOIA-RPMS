IBINI02R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,3.18,21,3,0)
	;;= 
	;;^DD(350.9,3.18,21,4,0)
	;;=The v2.0 insurance conversion will automatically set this field to the
	;;^DD(350.9,3.18,21,5,0)
	;;=date it completes.
	;;^DD(350.9,3.18,"DT")
	;;=2931108
	;;^DD(350.9,3.19,0)
	;;=BILL/CLAIMS CONV. COMPLETE^RDI^^3;19^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,3.19,21,0)
	;;=^^3^3^2931108^
	;;^DD(350.9,3.19,21,1,0)
	;;=This is the date that the v2 post-init conversion of the bill/claims file
	;;^DD(350.9,3.19,21,2,0)
	;;=completed.  It will automatically be updated by the conversion routine
	;;^DD(350.9,3.19,21,3,0)
	;;=when it completes.
	;;^DD(350.9,3.19,"DT")
	;;=2931108
	;;^DD(350.9,3.2,0)
	;;=CURRENT INPATIENTS LOADED^RDI^^3;20^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,3.2,21,0)
	;;=^^3^3^2931108^
	;;^DD(350.9,3.2,21,1,0)
	;;=This is the date that the current inpatients were loaded into claims
	;;^DD(350.9,3.2,21,2,0)
	;;=tracking as part of the IB v2 post init.  This date will automatically
	;;^DD(350.9,3.2,21,3,0)
	;;=be entered upon completion.
	;;^DD(350.9,3.2,"DT")
	;;=2931108
	;;^DD(350.9,4.01,0)
	;;=INSURANCE EXTENDED HELP^S^0:OFF;1:ON;^4;1^Q
	;;^DD(350.9,4.01,21,0)
	;;=^^7^7^2940131^^
	;;^DD(350.9,4.01,21,1,0)
	;;=Should the extended help display be always on in the Insurance Management
	;;^DD(350.9,4.01,21,2,0)
	;;=options.  Answer 'ON' if you always want it to display automatically
	;;^DD(350.9,4.01,21,3,0)
	;;=or answer 'OFF' if you do not want to see it.
	;;^DD(350.9,4.01,21,4,0)
	;;= 
	;;^DD(350.9,4.01,21,5,0)
	;;=It is recommended that the extended help be turned on initially
	;;^DD(350.9,4.01,21,6,0)
	;;=after v2 is installed.  As users become more familiar with the
	;;^DD(350.9,4.01,21,7,0)
	;;=new functionality the parameter can be turned off.
	;;^DD(350.9,4.01,"DT")
	;;=2930813
	;;^DD(350.9,4.02,0)
	;;=PATIENT OR INSURANCE COMPANY^V^^4;2^Q
	;;^DD(350.9,4.02,21,0)
	;;=^^1^1^2940209^
	;;^DD(350.9,4.02,21,1,0)
	;;=Enter the patient or insurance company you wish to access.
	;;^DD(350.9,4.02,23,0)
	;;=^^3^3^2940209^
	;;^DD(350.9,4.02,23,1,0)
	;;=This field does not contain data.  It is used as a file definition by
	;;^DD(350.9,4.02,23,2,0)
	;;=the reader to do a variable pointer look up that is not tied to any
	;;^DD(350.9,4.02,23,3,0)
	;;=data base element.
	;;^DD(350.9,4.02,"DT")
	;;=2930303
	;;^DD(350.9,4.02,"V",0)
	;;=^.12P^2^2
	;;^DD(350.9,4.02,"V",1,0)
	;;=2^Patient^1^2^n^n
	;;^DD(350.9,4.02,"V",2,0)
	;;=36^Insurance company^10^36^n^n
	;;^DD(350.9,4.03,0)
	;;=HEALTH INSURANCE POLICY^F^^4;3^K:$L(X)>20!($L(X)<1) X
	;;^DD(350.9,4.03,3)
	;;=Answer must be 1-20 characters in length.
	;;^DD(350.9,4.03,21,0)
	;;=^^1^1^2940209^
	;;^DD(350.9,4.03,21,1,0)
	;;=Enter the name of the patient's health insurance policy.
	;;^DD(350.9,4.03,23,0)
	;;=^^3^3^2940209^
	;;^DD(350.9,4.03,23,1,0)
	;;=This field does not contain data.  It is used by the reader to
	;;^DD(350.9,4.03,23,2,0)
	;;=provide a definition to do a lookup that is not tied to a
	;;^DD(350.9,4.03,23,3,0)
	;;=particular data base element.
	;;^DD(350.9,4.03,"DT")
	;;=2930829
	;;^DD(350.9,4.04,0)
	;;=NEW INSURANCE MAIL GROUP^P3.8'^XMB(3.8,^4;4^Q
	;;^DD(350.9,4.04,21,0)
	;;=^^3^3^2940209^^
	;;^DD(350.9,4.04,21,1,0)
	;;=Enter the mail group that should receive a bulletin every time an
	;;^DD(350.9,4.04,21,2,0)
	;;=insurance policy is added for a patient that has potential billings
	;;^DD(350.9,4.04,21,3,0)
	;;=associated with it.
	;;^DD(350.9,4.04,"DT")
	;;=2930829
	;;^DD(350.9,4.05,0)
	;;=CENTRAL COLLECTION MAIL GROUP^F^^4;5^K:$L(X)>45!($L(X)<3) X
