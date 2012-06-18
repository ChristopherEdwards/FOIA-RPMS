IBINI09Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(362.4,.02,1,1,"%D",2,0)
	;;=all it's rx refills for easy look-up.
	;;^DD(362.4,.02,1,1,"DT")
	;;=2931229
	;;^DD(362.4,.02,1,2,0)
	;;=362.4^C
	;;^DD(362.4,.02,1,2,1)
	;;=S ^IBA(362.4,"C",$E(X,1,30),DA)=""
	;;^DD(362.4,.02,1,2,2)
	;;=K ^IBA(362.4,"C",$E(X,1,30),DA)
	;;^DD(362.4,.02,1,2,"DT")
	;;=2940110
	;;^DD(362.4,.02,3)
	;;=Enter a bill number.
	;;^DD(362.4,.02,12)
	;;=Only open bills may be modified.
	;;^DD(362.4,.02,12.1)
	;;=S DIC("S")="I $P(^(0),U,13)<3"
	;;^DD(362.4,.02,21,0)
	;;=^^1^1^2931229^
	;;^DD(362.4,.02,21,1,0)
	;;=The bill this rx refill is associated with.
	;;^DD(362.4,.02,"DT")
	;;=2940110
	;;^DD(362.4,.03,0)
	;;=DATE^D^^0;3^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(362.4,.03,3)
	;;=Enter the refill date.
	;;^DD(362.4,.03,21,0)
	;;=^^1^1^2940208^
	;;^DD(362.4,.03,21,1,0)
	;;=The date of the refill that is being billed.
	;;^DD(362.4,.03,"DT")
	;;=2940208
	;;^DD(362.4,.04,0)
	;;=DRUG^RP50'^PSDRUG(^0;4^Q
	;;^DD(362.4,.04,3)
	;;=Enter the drug for this prescription.
	;;^DD(362.4,.04,21,0)
	;;=^^1^1^2931223^
	;;^DD(362.4,.04,21,1,0)
	;;=The drug prescribed.
	;;^DD(362.4,.04,"DT")
	;;=2931223
	;;^DD(362.4,.05,0)
	;;=RECORD^P52'^PSRX(^0;5^Q
	;;^DD(362.4,.05,3)
	;;=This is the Prescription record for this refill.
	;;^DD(362.4,.05,5,1,0)
	;;=362.4^.01^3
	;;^DD(362.4,.05,21,0)
	;;=^^1^1^2931229^
	;;^DD(362.4,.05,21,1,0)
	;;=Enter the Prescription record for this refill.
	;;^DD(362.4,.05,23,0)
	;;=^^4^4^2931229^
	;;^DD(362.4,.05,23,1,0)
	;;=This should be automatically set by the system if a Prescription (52) 
	;;^DD(362.4,.05,23,2,0)
	;;=refill is chosen.  This is not required because not all items may be
	;;^DD(362.4,.05,23,3,0)
	;;=outpatient prescriptions, such as fee basis charges.
	;;^DD(362.4,.05,23,4,0)
	;;=Also, note that the Prescription (52) is not a permanent file.
	;;^DD(362.4,.05,"DT")
	;;=2931229
	;;^DD(362.4,.06,0)
	;;=DAYS SUPPLY^NJ2,0^^0;6^K:+X'=X!(X>90)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(362.4,.06,3)
	;;=Type a Number between 1 and 90, 0 Decimal Digits
	;;^DD(362.4,.06,21,0)
	;;=^^1^1^2940110^^^^
	;;^DD(362.4,.06,21,1,0)
	;;=This should be the number of days supplied of the drug dispensed in this refill.
	;;^DD(362.4,.06,23,0)
	;;=^^1^1^2940110^^^
	;;^DD(362.4,.06,23,1,0)
	;;=Passed from (52,8) 
	;;^DD(362.4,.06,"DT")
	;;=2940110
	;;^DD(362.4,.07,0)
	;;=QTY^NJ3,0^^0;7^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(362.4,.07,3)
	;;=Type a Number between 0 and 999, 0 Decimal Digits
	;;^DD(362.4,.07,21,0)
	;;=^^2^2^2940110^^^
	;;^DD(362.4,.07,21,1,0)
	;;=This should be the quantity (# of tablets, pills, items, etc.) of the drug 
	;;^DD(362.4,.07,21,2,0)
	;;=dispensed in this refill.
	;;^DD(362.4,.07,23,0)
	;;=^^1^1^2940110^^
	;;^DD(362.4,.07,23,1,0)
	;;=Loaded from (52,52,1)
	;;^DD(362.4,.07,"DT")
	;;=2940110
	;;^DD(362.4,.08,0)
	;;=NDC #^F^^0;8^K:$L(X)>20!($L(X)<1) X
	;;^DD(362.4,.08,3)
	;;=Answer must be 1-20 characters in length.
	;;^DD(362.4,.08,21,0)
	;;=^^1^1^2940112^^^
	;;^DD(362.4,.08,21,1,0)
	;;=Enter the NDC number for this drug, if it should be printed on the bill.
	;;^DD(362.4,.08,23,0)
	;;=^^1^1^2940112^^
	;;^DD(362.4,.08,23,1,0)
	;;=Not loaded from pharmacy.
	;;^DD(362.4,.08,"DT")
	;;=2940112
