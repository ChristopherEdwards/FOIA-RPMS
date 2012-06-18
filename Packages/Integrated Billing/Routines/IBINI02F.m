IBINI02F	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,.1,21,2,0)
	;;='NO' when the queued job is started.  It will be used to prevent queueing
	;;^DD(350.9,.1,21,3,0)
	;;=two or more jobs before the first job starts.
	;;^DD(350.9,.1,"DT")
	;;=2910228
	;;^DD(350.9,.11,0)
	;;=CATEGORY C BILLING MAIL GROUP^P3.8'^XMB(3.8,^0;11^Q
	;;^DD(350.9,.11,21,0)
	;;=^^3^3^2920106^^
	;;^DD(350.9,.11,21,1,0)
	;;=Members of this mail group will receive bulletins when Means Test/Category
	;;^DD(350.9,.11,21,2,0)
	;;=C billing processing errors have been encountered, and when movements and
	;;^DD(350.9,.11,21,3,0)
	;;=Means Tests for Category C patients have been edited or deleted.
	;;^DD(350.9,.11,"DT")
	;;=2911209
	;;^DD(350.9,.12,0)
	;;=PER DIEM START DATE^D^^0;12^S %DT="EX" D ^%DT S X=Y K:3991231<X!(2901105>X) X
	;;^DD(350.9,.12,3)
	;;=This is the date this hospital began the $5 and $10 Per Diem Billing.  Enter a date no earlier than 11/5/90.
	;;^DD(350.9,.12,21,0)
	;;=^^10^10^2920205^^^^
	;;^DD(350.9,.12,21,1,0)
	;;=This is the date that this facility counseled category C patients that
	;;^DD(350.9,.12,21,2,0)
	;;=they would have to pay the new Per Diem charges and began the Per Diem
	;;^DD(350.9,.12,21,3,0)
	;;=billing.
	;;^DD(350.9,.12,21,4,0)
	;;= 
	;;^DD(350.9,.12,21,5,0)
	;;=This field represents the earliest date for which the Hospital ($10) or
	;;^DD(350.9,.12,21,6,0)
	;;=Nursing Home ($5) Per Diem charge may be billed to a Category C patient.
	;;^DD(350.9,.12,21,7,0)
	;;=This billing is mandated by Public Law 101-508, which was implemented
	;;^DD(350.9,.12,21,8,0)
	;;=on November 5, 1990.
	;;^DD(350.9,.12,21,9,0)
	;;= 
	;;^DD(350.9,.12,21,10,0)
	;;=Please note that the Per Diem billing will not occur if this field is null.
	;;^DD(350.9,.12,"DT")
	;;=2920205
	;;^DD(350.9,.13,0)
	;;=COPAY EXEMPTION MAIL GROUP^P3.8^XMB(3.8,^0;13^Q
	;;^DD(350.9,.13,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,.13,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.9,.13,21,1,0)
	;;=This mail group will be sent the copay exemption bulletins and error
	;;^DD(350.9,.13,21,2,0)
	;;=messages.
	;;^DD(350.9,.13,21,3,0)
	;;= 
	;;^DD(350.9,.13,21,4,0)
	;;=The value of this field is the number of fiscal years, prior to the
	;;^DD(350.9,.13,21,5,0)
	;;=current fiscal year, for which Category C Billing Clock data should be
	;;^DD(350.9,.13,21,6,0)
	;;=retained in the system when the option to purge billing clock records
	;;^DD(350.9,.13,21,7,0)
	;;=is run.  If that option is tasked to run automatically, then this
	;;^DD(350.9,.13,21,8,0)
	;;=parameter is directly accessed and used to determine which data shall
	;;^DD(350.9,.13,21,9,0)
	;;=be purged from the database (if the value of this field is null or less
	;;^DD(350.9,.13,21,10,0)
	;;=than one, one previous year's worth of data is retained).  If the option
	;;^DD(350.9,.13,21,11,0)
	;;=is manually invoked, the value of this field is defaulted when the user
	;;^DD(350.9,.13,21,12,0)
	;;=is prompted for the number of year's worth of data to retain.
	;;^DD(350.9,.13,"DT")
	;;=2930115
	;;^DD(350.9,.14,0)
	;;=USE ALERTS^*S^1:YES;0:NO;^0;14^Q
	;;^DD(350.9,.14,12)
	;;=Version 7 of Kernel must be installed inorder to turn this feature on.
	;;^DD(350.9,.14,12.1)
	;;=S DIC("S")="I 'Y!(+$G(^DD(200,0,""VR""))'<7)"
	;;^DD(350.9,.14,21,0)
	;;=^^7^7^2930204^^
	;;^DD(350.9,.14,21,1,0)
	;;=If a facility has installed Version 7 or higher of Kernel, then the
	;;^DD(350.9,.14,21,2,0)
	;;=site may decide whether to use Alerts or Bulletins for internal messages
	;;^DD(350.9,.14,21,3,0)
	;;=in Integrated Billing.  Initially this functionality will only be
