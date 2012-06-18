IBINI078	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.9,.04,1,2,"%D",0)
	;;=^^1^1^2930901^
	;;^DD(356.9,.04,1,2,"%D",1,0)
	;;=Cross-reference of admitting diagnosis by admission movement.
	;;^DD(356.9,.04,1,2,"DT")
	;;=2930901
	;;^DD(356.9,.04,12)
	;;=Only one diagnosis can be primary or admitting diagnosis for an admission.
	;;^DD(356.9,.04,12.1)
	;;=S DIC("S")="I $$DICS^IBTRED1(Y)"
	;;^DD(356.9,.04,21,0)
	;;=^^3^3^2930901^^
	;;^DD(356.9,.04,21,1,0)
	;;=Enter 'PRIMARY' if this is the primary diagnosis for this date, enter
	;;^DD(356.9,.04,21,2,0)
	;;='SECONDARY' if this is not the primary diagnosis for this date.
	;;^DD(356.9,.04,21,3,0)
	;;=Enter "ADMITTING" if this is the admitting diagnosis.
	;;^DD(356.9,.04,"DT")
	;;=2930901
