IBINI02P	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,3.07,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.07,9)
	;;=^
	;;^DD(350.9,3.07,21,0)
	;;=^^1^1^2930114^
	;;^DD(350.9,3.07,21,1,0)
	;;=This is the number of patients converted to a non-exempt status.
	;;^DD(350.9,3.07,"DT")
	;;=2930107
	;;^DD(350.9,3.08,0)
	;;=COUNT OF EXEMPT BILLS^NJ9,0^^3;8^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.08,.1)
	;;=COPAY EXEMPTION TOTAL COUNT OF CANCELED RX CHARGES
	;;^DD(350.9,3.08,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.08,9)
	;;=^
	;;^DD(350.9,3.08,21,0)
	;;=^^3^3^2930114^^^
	;;^DD(350.9,3.08,21,1,0)
	;;=This is the number of Medication Copayment IB Actions that were 
	;;^DD(350.9,3.08,21,2,0)
	;;=issued to patients who's status is exempt from the start of the 
	;;^DD(350.9,3.08,21,3,0)
	;;=exemption legislation to the running of the conversion.
	;;^DD(350.9,3.08,"DT")
	;;=2930114
	;;^DD(350.9,3.09,0)
	;;=AMOUNT OF CHARGES CHECKED^NJ9,0^^3;9^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.09,.1)
	;;=COPAY EXEMPTION CONVERSION TOTAL CHARGES CHECKED
	;;^DD(350.9,3.09,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.09,9)
	;;=^
	;;^DD(350.9,3.09,21,0)
	;;=^^3^3^2930114^^^
	;;^DD(350.9,3.09,21,1,0)
	;;=This is the total dollar amount of charges checked during the Medication
	;;^DD(350.9,3.09,21,2,0)
	;;=Copayment Exemption Conversion issued to patients from the start
	;;^DD(350.9,3.09,21,3,0)
	;;=date of the exemption legislation to the running of the conversion.
	;;^DD(350.9,3.09,"DT")
	;;=2930107
	;;^DD(350.9,3.1,0)
	;;=TOTAL EXEMPT DOLLAR AMOUNT^NJ9,0^^3;10^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.1,.1)
	;;=COPAY EXEMPTION CONVERSION TOTAL EXEMPTED CHARGES
	;;^DD(350.9,3.1,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.1,9)
	;;=^
	;;^DD(350.9,3.1,21,0)
	;;=^^3^3^2930114^
	;;^DD(350.9,3.1,21,1,0)
	;;=This is the total dollar amount of charges checked during the Medication
	;;^DD(350.9,3.1,21,2,0)
	;;=Copayment Exemption Conversion issued to Exempt patients from the start
	;;^DD(350.9,3.1,21,3,0)
	;;=date of the exemption legislation to the running of the conversion.
	;;^DD(350.9,3.1,"DT")
	;;=2930114
	;;^DD(350.9,3.11,0)
	;;=AMOUNT OF NON-EXEMPT CHARGES^NJ9,0^^3;11^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.11,.1)
	;;=COPAY EXEMPTION CONVERSION TOTAL NON-EXEMPT CHARGES
	;;^DD(350.9,3.11,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.11,9)
	;;=^
	;;^DD(350.9,3.11,21,0)
	;;=^^3^3^2930114^
	;;^DD(350.9,3.11,21,1,0)
	;;=This is the total dollar amount of charges checked during the Medication
	;;^DD(350.9,3.11,21,2,0)
	;;=Copayment Exemption Conversion issued to Non-Exempt patients from the start
	;;^DD(350.9,3.11,21,3,0)
	;;=date of the exemption legislation to the running of the conversion.
	;;^DD(350.9,3.11,"DT")
	;;=2930107
	;;^DD(350.9,3.12,0)
	;;=AMOUNT OF CANCELED CHARGES^NJ9,0^^3;12^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.12,.1)
	;;=COPAY EXEMPTION CONVERSION TOTAL AMOUNT OF CANCELED CHARGES
	;;^DD(350.9,3.12,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.12,9)
	;;=^
	;;^DD(350.9,3.12,21,0)
	;;=^^3^3^2930114^
	;;^DD(350.9,3.12,21,1,0)
	;;=This is the total dollar amount of charges actually canceled during the Medication
	;;^DD(350.9,3.12,21,2,0)
	;;=Copayment Exemption Conversion issued to Exempt patients from the start
	;;^DD(350.9,3.12,21,3,0)
	;;=date of the exemption legislation to the running of the conversion.
