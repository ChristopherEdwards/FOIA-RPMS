IBDEI00A	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.1,89,0)
	;;=PROGRESS NOTES (SOAP)^^^90^0^132^31^^^2^Progress Notes:   (  ) Attached  (  ) See Chart^^Data Fields (w/o data) - for writing progress notes in SOAP format^1
