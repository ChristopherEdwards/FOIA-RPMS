IBINI02E	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,.04,21,0)
	;;=^^8^8^2910416^^^^
	;;^DD(350.9,.04,21,1,0)
	;;=This is the internal fileman date/time that the IBE filer was last started.
	;;^DD(350.9,.04,21,2,0)
	;;=This field should be blank if the FILER STOPPED field contains data.
	;;^DD(350.9,.04,21,3,0)
	;;= 
	;;^DD(350.9,.04,21,4,0)
	;;=If this field contains a date/time and the field FILE IN BACKGROUND is 
	;;^DD(350.9,.04,21,5,0)
	;;=answered 'YES' then it is assumed that an IBE Filer is running.  Use
	;;^DD(350.9,.04,21,6,0)
	;;=the option 'Start the Integrated Billing Background Filer' to start a new filer if
	;;^DD(350.9,.04,21,7,0)
	;;=needed.  This field is updated by the IBE Filer and should not be edited
	;;^DD(350.9,.04,21,8,0)
	;;=with FileMan.
	;;^DD(350.9,.04,"DT")
	;;=2910225
	;;^DD(350.9,.05,0)
	;;=FILER STOPPED^D^^0;5^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,.05,21,0)
	;;=^^5^5^2910227^^^
	;;^DD(350.9,.05,21,1,0)
	;;=This is the internal fileman date/time that the IBE filer was last stopped.
	;;^DD(350.9,.05,21,2,0)
	;;=This field should be blank if the FILER STARTED field contains data.
	;;^DD(350.9,.05,21,3,0)
	;;= 
	;;^DD(350.9,.05,21,4,0)
	;;=This field is updated by the IBE Filer.  It should not be edited with
	;;^DD(350.9,.05,21,5,0)
	;;=FileMan.
	;;^DD(350.9,.05,"DT")
	;;=2910225
	;;^DD(350.9,.06,0)
	;;=FILER LAST RAN^D^^0;6^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,.06,3)
	;;=
	;;^DD(350.9,.06,21,0)
	;;=^^5^5^2910227^^
	;;^DD(350.9,.06,21,1,0)
	;;=This is the date/time that the IBE Filer last passed data to the
	;;^DD(350.9,.06,21,2,0)
	;;=Accounts Receivable module of IFCAP.
	;;^DD(350.9,.06,21,3,0)
	;;= 
	;;^DD(350.9,.06,21,4,0)
	;;=This field is updated by the IBE Filer and should not be edited with
	;;^DD(350.9,.06,21,5,0)
	;;=FileMan.
	;;^DD(350.9,.06,"DT")
	;;=2910225
	;;^DD(350.9,.07,0)
	;;=FILER UCI,VOL^F^^0;7^K:$L(X)>30!($L(X)<3) X
	;;^DD(350.9,.07,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(350.9,.07,21,0)
	;;=^^4^4^2920415^^^
	;;^DD(350.9,.07,21,1,0)
	;;=This is the UCI and Volume set that you want the IBE Filer to run on.  Vax
	;;^DD(350.9,.07,21,2,0)
	;;=sites should leave this blank.  It is recommended that the filer
	;;^DD(350.9,.07,21,3,0)
	;;=run on the volume set that contains either the IB globals or the PRC
	;;^DD(350.9,.07,21,4,0)
	;;=globals.
	;;^DD(350.9,.07,"DT")
	;;=2910225
	;;^DD(350.9,.08,0)
	;;=FILER HANG TIME^NJ2,0^^0;8^K:+X'=X!(X>15)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,.08,3)
	;;=Type a Number between 1 and 15, 0 Decimal Digits
	;;^DD(350.9,.08,21,0)
	;;=^^4^4^2920416^^^^
	;;^DD(350.9,.08,21,1,0)
	;;=This is the number of seconds that the filer will remain idle after
	;;^DD(350.9,.08,21,2,0)
	;;=finishing all transactions and before checking for more transactions
	;;^DD(350.9,.08,21,3,0)
	;;=to file.  The filer will shut itself down after 2000 hangs with no activity
	;;^DD(350.9,.08,21,4,0)
	;;=detected.  The default value for this field is 2 if left blank.
	;;^DD(350.9,.08,"DT")
	;;=2910227
	;;^DD(350.9,.09,0)
	;;=COPAY BACKGROUND ERROR GROUP^P3.8'^XMB(3.8,^0;9^Q
	;;^DD(350.9,.09,21,0)
	;;=^^3^3^2910227^
	;;^DD(350.9,.09,21,1,0)
	;;=This is the mail group that will receive mail bulletins from the IBE filer
	;;^DD(350.9,.09,21,2,0)
	;;=when an unsuccessful attempt to file is detected.  Remember to add users
	;;^DD(350.9,.09,21,3,0)
	;;=to it.
	;;^DD(350.9,.09,"DT")
	;;=2920220
	;;^DD(350.9,.1,0)
	;;=FILER QUEUED^S^1:YES;0:NO;^0;10^Q
	;;^DD(350.9,.1,21,0)
	;;=^^3^3^2910228^
	;;^DD(350.9,.1,21,1,0)
	;;=This field will be set to 'YES' when a file job is queued and set back to
