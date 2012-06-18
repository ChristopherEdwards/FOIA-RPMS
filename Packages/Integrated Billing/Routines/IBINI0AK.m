IBINI0AK	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,165,23,2,0)
	;;=Excludes pass, AA, UA days but includes days in non-billable bedsections.
	;;^DD(399,165,23,3,0)
	;;=Notice that the number of units of service under revenue code only
	;;^DD(399,165,23,4,0)
	;;=includes billable bedsections so the number of units may not add
	;;^DD(399,165,23,5,0)
	;;=up to the length of stay if the patient was in a non-billable bedsection
	;;^DD(399,165,23,6,0)
	;;=for awhile.
	;;^DD(399,165,23,7,0)
	;;=LOS of a stay where admit day=discharge day is 1.  LOS of a stay where
	;;^DD(399,165,23,8,0)
	;;=admit date+1=discharge date also has an LOS of 1.
	;;^DD(399,165,23,9,0)
	;;=The discharge date is not charged.  Therefore, on continuous first
	;;^DD(399,165,23,10,0)
	;;=and interum bills the LOS is the date range inclusive of the last day
	;;^DD(399,165,23,11,0)
	;;=on the bill, all other bills exclude the last day (with exception of
	;;^DD(399,165,23,12,0)
	;;=admit=discharge day).
	;;^DD(399,165,"DT")
	;;=2880602
	;;^DD(399,166,0)
	;;=UNABLE TO WORK FROM^D^^U;16^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,166,3)
	;;=Enter the beginning date the patient became unable to work due to current condition.
	;;^DD(399,166,21,0)
	;;=^^3^3^2920427^^^^
	;;^DD(399,166,21,1,0)
	;;=Enter the beginning date for the period of time that the patient could not
	;;^DD(399,166,21,2,0)
	;;=work due to the condition for which this claim is being submitted.  Printed
	;;^DD(399,166,21,3,0)
	;;=on the HCFA 1500.
	;;^DD(399,166,"DT")
	;;=2920427
	;;^DD(399,167,0)
	;;=UNABLE TO WORK TO^D^^U;17^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,167,3)
	;;=Enter the ending date of the time that the patient was unable to work due to current condition.
	;;^DD(399,167,21,0)
	;;=^^3^3^2920427^^
	;;^DD(399,167,21,1,0)
	;;=This is the ending date of the period of time during which the patient
	;;^DD(399,167,21,2,0)
	;;=was unable to work due to the condition for which this claim is being
	;;^DD(399,167,21,3,0)
	;;=submitted.  Used on the HCFA 1500.
	;;^DD(399,167,"DT")
	;;=2920427
	;;^DD(399,168,0)
	;;=*PLACE OF SERVICE^P353.1'^IBE(353.1,^U;18^Q
	;;^DD(399,168,3)
	;;=Enter the code corresponding to the Place of Service of patient care.
	;;^DD(399,168,21,0)
	;;=^^3^3^2930611^^^^
	;;^DD(399,168,21,1,0)
	;;=This indicates the Place of Service, used on the HCFA 1500.
	;;^DD(399,168,21,2,0)
	;;=Not used after IB v1.5, replaced by PLACE OF SERVICE (304,8) associated
	;;^DD(399,168,21,3,0)
	;;=with a specific procedure.  Marked for deletion 6/11/93.
	;;^DD(399,168,"DT")
	;;=2930611
	;;^DD(399,169,0)
	;;=*TYPE OF SERVICE^P353.2'^IBE(353.2,^U;19^Q
	;;^DD(399,169,3)
	;;=Enter the appropriate Type of Service code for this visit.
	;;^DD(399,169,21,0)
	;;=^^3^3^2930611^^
	;;^DD(399,169,21,1,0)
	;;=Code indicating the Type of Service preformed.  Used on the HCFA 1500.
	;;^DD(399,169,21,2,0)
	;;=Not used after IB v1.5, replaced by TYPE OF SERVICE (304,9) associated
	;;^DD(399,169,21,3,0)
	;;=with a specific procedure.  Marked for deletion 6/11/93.
	;;^DD(399,169,"DT")
	;;=2930611
	;;^DD(399,201,0)
	;;=TOTAL CHARGES^NJ8,2XI^^U1;1^Q
	;;^DD(399,201,1,0)
	;;=^.1
	;;^DD(399,201,1,1,0)
	;;=^^TRIGGER^399^210
	;;^DD(399,201,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X=DIV X ^DD(399,201,1,1,1.4)
	;;^DD(399,201,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U1")):^("U1"),1:""),DIV=X S $P(^("U1"),U,10)=DIV,DIH=399,DIG=210 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,201,1,1,2)
	;;=Q
	;;^DD(399,201,1,1,"CREATE VALUE")
	;;=TOTAL CHARGES
