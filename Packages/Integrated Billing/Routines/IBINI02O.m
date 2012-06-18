IBINI02O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,3.02,21,17,0)
	;;=This field will be deleted in the version of IB which follows v2.0.
	;;^DD(350.9,3.02,"DT")
	;;=2940127
	;;^DD(350.9,3.03,0)
	;;=COPAY EXEMPTION CONV. STARTED^NJ7,0^^3;3^K:+X'=X!(X>9999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.03,3)
	;;=Type a Number between 1 and 9999999, 0 Decimal Digits
	;;^DD(350.9,3.03,21,0)
	;;=^^2^2^2930114^^
	;;^DD(350.9,3.03,21,1,0)
	;;=This is the number of times the Medication Copayment Exemption Conversion
	;;^DD(350.9,3.03,21,2,0)
	;;=has been started.  It is used to tell if the conversion has been restarted.
	;;^DD(350.9,3.03,23,0)
	;;=^^11^11^2930114^
	;;^DD(350.9,3.03,23,1,0)
	;;=The Medication Copayment Exemption Conversion can be stopped by
	;;^DD(350.9,3.03,23,2,0)
	;;=editing this field to a number different that its current value.
	;;^DD(350.9,3.03,23,3,0)
	;;=This is NOT a recommended procedure but should only be used in
	;;^DD(350.9,3.03,23,4,0)
	;;=exception cases.  It will cause an orderly shut down on the 
	;;^DD(350.9,3.03,23,5,0)
	;;=completion of a single patient.  After the conversion shuts down,
	;;^DD(350.9,3.03,23,6,0)
	;;=the value of this field should be returned to its original value.
	;;^DD(350.9,3.03,23,7,0)
	;;= 
	;;^DD(350.9,3.03,23,8,0)
	;;=If a second conversion is started this field will be updated causing
	;;^DD(350.9,3.03,23,9,0)
	;;=the first conversion to stop.  At that point it is possible that
	;;^DD(350.9,3.03,23,10,0)
	;;=a patient may be double processed, possible causing the double
	;;^DD(350.9,3.03,23,11,0)
	;;=decreasing of charges in AR for that patient.
	;;^DD(350.9,3.03,"DT")
	;;=2930114
	;;^DD(350.9,3.04,0)
	;;=COPAY EXEMPTION LAST DFN^NJ9,0^^3;4^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.04,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.04,9)
	;;=^
	;;^DD(350.9,3.04,21,0)
	;;=^^5^5^2930114^
	;;^DD(350.9,3.04,21,1,0)
	;;=This is the internal entry number of the last patient completely
	;;^DD(350.9,3.04,21,2,0)
	;;=converted by the Medication Copayment Exemption Conversion.  The
	;;^DD(350.9,3.04,21,3,0)
	;;=Conversion processes patients in order of internal entry number.
	;;^DD(350.9,3.04,21,4,0)
	;;=If the conversion stops for any reason it will start with the next
	;;^DD(350.9,3.04,21,5,0)
	;;=internal number after this one.
	;;^DD(350.9,3.04,"DT")
	;;=2921124
	;;^DD(350.9,3.05,0)
	;;=TOTAL PATIENTS CONVERTED^NJ9,0^^3;5^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.05,.1)
	;;=COPAY EXEMPTION TOTAL PATIENT CONVERTED
	;;^DD(350.9,3.05,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.05,9)
	;;=^
	;;^DD(350.9,3.05,21,0)
	;;=^^2^2^2930114^^
	;;^DD(350.9,3.05,21,1,0)
	;;=This is the total number of patients in the IB file that were set
	;;^DD(350.9,3.05,21,2,0)
	;;=up with an exemption status during the conversion.
	;;^DD(350.9,3.05,"DT")
	;;=2930107
	;;^DD(350.9,3.06,0)
	;;=TOTAL PATIENTS EXEMPT^NJ9,0^^3;6^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.06,.1)
	;;=COPAY EXEMPTION TOTAL PATIENTS CONVERTED EXEMPT
	;;^DD(350.9,3.06,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.06,9)
	;;=^
	;;^DD(350.9,3.06,21,0)
	;;=^^1^1^2930114^
	;;^DD(350.9,3.06,21,1,0)
	;;=This is the number of patients that were converted to an exempt status.
	;;^DD(350.9,3.06,"DT")
	;;=2930107
	;;^DD(350.9,3.07,0)
	;;=TOTAL PATIENT NON-EXEMPT^NJ9,0^^3;7^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.07,.1)
	;;=COPAY EXEMPTION TOTAL PATIENTS CONVERTED NON-EXEMPT
