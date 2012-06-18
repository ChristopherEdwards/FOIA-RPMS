IBINI02Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,3.12,"DT")
	;;=2930107
	;;^DD(350.9,3.13,0)
	;;=COPAY EXEMPTION START DATE^RD^^3;13^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,3.13,9)
	;;=^
	;;^DD(350.9,3.13,21,0)
	;;=^^2^2^2930114^^
	;;^DD(350.9,3.13,21,1,0)
	;;=This is the date/time that the Medication Copayment Exemption Conversion
	;;^DD(350.9,3.13,21,2,0)
	;;=started.  It should not be edited.
	;;^DD(350.9,3.13,"DT")
	;;=2930113
	;;^DD(350.9,3.14,0)
	;;=COPAY EXEMPTION STOP DATE^RDI^^3;14^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,3.14,3)
	;;=
	;;^DD(350.9,3.14,9)
	;;=^
	;;^DD(350.9,3.14,21,0)
	;;=^^4^4^2930114^^^^
	;;^DD(350.9,3.14,21,1,0)
	;;=This is the date/time that the conversion completed.  This field
	;;^DD(350.9,3.14,21,2,0)
	;;=should not be edited.  It will be stored by the conversion routine
	;;^DD(350.9,3.14,21,3,0)
	;;=when it is finished.  
	;;^DD(350.9,3.14,21,4,0)
	;;= 
	;;^DD(350.9,3.14,23,0)
	;;=^^9^9^2930114^^^^
	;;^DD(350.9,3.14,23,1,0)
	;;=If for some reason, it is necessary to restart the conversion after
	;;^DD(350.9,3.14,23,2,0)
	;;=this field has been populated you may delete the data in this field.
	;;^DD(350.9,3.14,23,3,0)
	;;=Sites should check with their supporting ISC prior to doing this.  The
	;;^DD(350.9,3.14,23,4,0)
	;;=field, LAST DFN UPDATED (3.04) in this file may also need to be edited.
	;;^DD(350.9,3.14,23,5,0)
	;;= 
	;;^DD(350.9,3.14,23,6,0)
	;;=Normally it is not recommended that the conversion be re-run after it
	;;^DD(350.9,3.14,23,7,0)
	;;=has run once.  Re-running the conversion will not cause updating of
	;;^DD(350.9,3.14,23,8,0)
	;;=patients with current exemptions, nor will it cause re-cancellation
	;;^DD(350.9,3.14,23,9,0)
	;;=of charges cancelled previously.
	;;^DD(350.9,3.14,"DT")
	;;=2930113
	;;^DD(350.9,3.15,0)
	;;=NON-EXEMPT PATIENTS CONVERTED^NJ9,0^^3;15^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.15,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.15,9)
	;;=^
	;;^DD(350.9,3.15,21,0)
	;;=^^2^2^2930114^
	;;^DD(350.9,3.15,21,1,0)
	;;=This is the count of patients in the IB Action file that had
	;;^DD(350.9,3.15,21,2,0)
	;;=an exemption status of Non-exempt set up during the conversion.
	;;^DD(350.9,3.15,"DT")
	;;=2930114
	;;^DD(350.9,3.16,0)
	;;=TOTAL BILLS DURING CONVERSION^NJ9,0^^3;16^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.16,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.16,9)
	;;=^
	;;^DD(350.9,3.16,21,0)
	;;=^^3^3^2930114^
	;;^DD(350.9,3.16,21,1,0)
	;;=This is the total number of IB ACTION entries issued from the effective
	;;^DD(350.9,3.16,21,2,0)
	;;=date of the Income Exemption Legislation until the running of the
	;;^DD(350.9,3.16,21,3,0)
	;;=conversion that were issued to either exempt or non-exempt patients.
	;;^DD(350.9,3.16,"DT")
	;;=2930114
	;;^DD(350.9,3.17,0)
	;;=COUNT OF BILLS CANCELED^NJ9,0^^3;17^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(350.9,3.17,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(350.9,3.17,9)
	;;=^
	;;^DD(350.9,3.17,21,0)
	;;=^^2^2^2930114^^
	;;^DD(350.9,3.17,21,1,0)
	;;=This is the count of bills actually sent to be canceled in the IB
	;;^DD(350.9,3.17,21,2,0)
	;;=ACTION file during the conversion.
	;;^DD(350.9,3.17,"DT")
	;;=2930114
	;;^DD(350.9,3.18,0)
	;;=INSURANCE CONVERSION COMPLETE^RDI^^3;18^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,3.18,21,0)
	;;=^^5^5^2931108^
	;;^DD(350.9,3.18,21,1,0)
	;;=This is the date the insurance conversion completes.  It is not editable.
	;;^DD(350.9,3.18,21,2,0)
	;;=The data should not be deleted.
