IBINI02X	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,7.01,21,3,0)
	;;=If the auto biller should run every night, enter 1.
	;;^DD(350.9,7.01,21,4,0)
	;;= 
	;;^DD(350.9,7.01,21,5,0)
	;;=This will not effect the date range of the bills themselves, but will
	;;^DD(350.9,7.01,21,6,0)
	;;=only effect the date they are created.
	;;^DD(350.9,7.01,21,7,0)
	;;= 
	;;^DD(350.9,7.01,21,8,0)
	;;=If this is left blank or zero then the auto biller will never run.
	;;^DD(350.9,7.01,"DT")
	;;=2931021
	;;^DD(350.9,7.02,0)
	;;=LAST AUTO BILLER DATE^D^^7;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,7.02,3)
	;;=This is the last date on which the auto biller ran.
	;;^DD(350.9,7.02,21,0)
	;;=^^1^1^2931021^
	;;^DD(350.9,7.02,21,1,0)
	;;=This is generally set by the system.
	;;^DD(350.9,7.02,"DT")
	;;=2931021
	;;^DD(350.9,7.03,0)
	;;=INPATIENT STATUS (AB)^S^1:Closed;2:Released;3:Transmitted;^7;3^Q
	;;^DD(350.9,7.03,3)
	;;=Enter the Status that an Inpatients PTF record should have before the automated biller attempts to create a bill for that inpatient stay.
	;;^DD(350.9,7.03,21,0)
	;;=^^9^9^2940125^^^^
	;;^DD(350.9,7.03,21,1,0)
	;;=This is the status that a PTF record must be in before the automated biller
	;;^DD(350.9,7.03,21,2,0)
	;;=will attempt to create an inpatient bill.
	;;^DD(350.9,7.03,21,3,0)
	;;= 
	;;^DD(350.9,7.03,21,4,0)
	;;=The auto biller will use the Frequency, Billing Cycle and Days Delay
	;;^DD(350.9,7.03,21,5,0)
	;;=parameters to decide when to try to create an inpatient bill.  However,
	;;^DD(350.9,7.03,21,6,0)
	;;=the auto biller can not set up a bill until the PTF record is Closed.
	;;^DD(350.9,7.03,21,7,0)
	;;=Of the two dates, the date calculated from the site parameters or the date
	;;^DD(350.9,7.03,21,8,0)
	;;=that the PTF record meets the Status entered here, the bill will be created
	;;^DD(350.9,7.03,21,9,0)
	;;=on the later date.
	;;^DD(350.9,7.03,23,0)
	;;=^^12^12^2940125^^^^
	;;^DD(350.9,7.03,23,1,0)
	;;=This set of codes should exactly mirror the PTF Status (45,6) set of 
	;;^DD(350.9,7.03,23,2,0)
	;;=codes, except for Open.
	;;^DD(350.9,7.03,23,3,0)
	;;= 
	;;^DD(350.9,7.03,23,4,0)
	;;=Some sites want to wait until the PTF is closed before a bill is created
	;;^DD(350.9,7.03,23,5,0)
	;;=because they know it will be coded at that time.  Others do not want to
	;;^DD(350.9,7.03,23,6,0)
	;;=bill until the PTF record has been transmitted and they know that it is
	;;^DD(350.9,7.03,23,7,0)
	;;=complete.
	;;^DD(350.9,7.03,23,8,0)
	;;= 
	;;^DD(350.9,7.03,23,9,0)
	;;=After this had been added it was decided that an auto bill should not be
	;;^DD(350.9,7.03,23,10,0)
	;;=created for inpatients until after the PTF record has been closed.
	;;^DD(350.9,7.03,23,11,0)
	;;=So, the option of creating an auto bill when the PTF record was still open
	;;^DD(350.9,7.03,23,12,0)
	;;=was removed.
	;;^DD(350.9,7.03,"DT")
	;;=2940125
