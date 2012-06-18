IBINI031	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(351,.09,21,3,0)
	;;=The field is used to determine the co-payment charges billed to the
	;;^DD(351,.09,21,4,0)
	;;=patient for care received.
	;;^DD(351,.09,"DT")
	;;=2911009
	;;^DD(351,.1,0)
	;;=CLOCK END DATE^D^^0;10^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(351,.1,3)
	;;=Enter the date on which this billing clock must be closed.
	;;^DD(351,.1,21,0)
	;;=^^2^2^2911226^^
	;;^DD(351,.1,21,1,0)
	;;=This is the date on which the billing clock was closed.  This date
	;;^DD(351,.1,21,2,0)
	;;=should not be more than 365 days after the Clock Begin Date.
	;;^DD(351,.1,"DT")
	;;=2911226
	;;^DD(351,11,0)
	;;=USER ADDING ENTRY^P200'^VA(200,^1;1^Q
	;;^DD(351,11,9)
	;;=^
	;;^DD(351,11,21,0)
	;;=^^3^3^2911226^^
	;;^DD(351,11,21,1,0)
	;;=This is the person performing a transaction in an application that
	;;^DD(351,11,21,2,0)
	;;=causes the application to create an entry in this file.  This field
	;;^DD(351,11,21,3,0)
	;;=may be null if the entry was created by an off-line compilation job.
	;;^DD(351,11,"DT")
	;;=2911009
	;;^DD(351,12,0)
	;;=DATE ENTRY ADDED^D^^1;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(351,12,9)
	;;=^
	;;^DD(351,12,21,0)
	;;=^^1^1^2911226^^
	;;^DD(351,12,21,1,0)
	;;=This the date/time that an entry was added to this file.
	;;^DD(351,12,"DT")
	;;=2911009
	;;^DD(351,13,0)
	;;=USER LAST UPDATING^P200'^VA(200,^1;3^Q
	;;^DD(351,13,21,0)
	;;=^^3^3^2911226^^
	;;^DD(351,13,21,1,0)
	;;=This is the person performing a transaction in an application which
	;;^DD(351,13,21,2,0)
	;;=causes the application to update this entry.  This entry may be null
	;;^DD(351,13,21,3,0)
	;;=if the entry was last updated in an off-line compilation job.
	;;^DD(351,13,"DT")
	;;=2911009
	;;^DD(351,14,0)
	;;=DATE LAST UPDATED^D^^1;4^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(351,14,21,0)
	;;=^^1^1^2911226^^
	;;^DD(351,14,21,1,0)
	;;=This is the date/time that this entry was last updated.
	;;^DD(351,14,"DT")
	;;=2911009
	;;^DD(351,15,0)
	;;=UPDATE REASON^F^^0;11^K:$L(X)>40!($L(X)<3) X
	;;^DD(351,15,3)
	;;= Answer must be 3-40 characters in length.
	;;^DD(351,15,21,0)
	;;=^^1^1^2920225^
	;;^DD(351,15,21,1,0)
	;;=Brief description of reason for updating billing clock.
	;;^DD(351,15,"DT")
	;;=2920225
