IBDEI00L	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.3)
	;;=^IBE(358.3,
	;;^UTILITY(U,$J,358.3,0)
	;;=IMP/EXP SELECTION^358.3I^60^60
	;;^UTILITY(U,$J,358.3,1,0)
	;;=99201^^4^7^1
	;;^UTILITY(U,$J,358.3,1,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,1,1,1,0)
	;;=1^Brief Visit         (1-15 Min)
	;;^UTILITY(U,$J,358.3,1,1,2,0)
	;;=2^99201
	;;^UTILITY(U,$J,358.3,2,0)
	;;=99202^^4^7^2
	;;^UTILITY(U,$J,358.3,2,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,2,1,1,0)
	;;=1^Limited Exam        (16-25 Min)
	;;^UTILITY(U,$J,358.3,2,1,2,0)
	;;=2^99202
	;;^UTILITY(U,$J,358.3,3,0)
	;;=99203^^4^7^3
	;;^UTILITY(U,$J,358.3,3,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,3,1,1,0)
	;;=1^Intermediate Exam   (26-35 Min)
	;;^UTILITY(U,$J,358.3,3,1,2,0)
	;;=2^99203
	;;^UTILITY(U,$J,358.3,4,0)
	;;=99204^^4^7^4
	;;^UTILITY(U,$J,358.3,4,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,4,1,1,0)
	;;=1^Extended Exam       (36-50 Min)
	;;^UTILITY(U,$J,358.3,4,1,2,0)
	;;=2^99204
	;;^UTILITY(U,$J,358.3,5,0)
	;;=99205^^4^7^5
	;;^UTILITY(U,$J,358.3,5,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,5,1,1,0)
	;;=1^Comprehensive Exam  (51-60+ Min)
	;;^UTILITY(U,$J,358.3,5,1,2,0)
	;;=2^99205
	;;^UTILITY(U,$J,358.3,6,0)
	;;=99211^^4^8^1
	;;^UTILITY(U,$J,358.3,6,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,6,1,1,0)
	;;=1^Brief Exam          (1-5 Min)
	;;^UTILITY(U,$J,358.3,6,1,2,0)
	;;=2^99211
	;;^UTILITY(U,$J,358.3,7,0)
	;;=99212^^4^8^2
	;;^UTILITY(U,$J,358.3,7,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,7,1,1,0)
	;;=1^Limited Exam        (6-10 Min)
	;;^UTILITY(U,$J,358.3,7,1,2,0)
	;;=2^99212
	;;^UTILITY(U,$J,358.3,8,0)
	;;=99213^^4^8^3
	;;^UTILITY(U,$J,358.3,8,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,8,1,1,0)
	;;=1^Intermediate Exam   (11-19 Min)
	;;^UTILITY(U,$J,358.3,8,1,2,0)
	;;=2^99213
	;;^UTILITY(U,$J,358.3,9,0)
	;;=99214^^4^8^4
	;;^UTILITY(U,$J,358.3,9,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,9,1,1,0)
	;;=1^Extended Exam       (20-30 Min)
	;;^UTILITY(U,$J,358.3,9,1,2,0)
	;;=2^99214
	;;^UTILITY(U,$J,358.3,10,0)
	;;=99215^^4^8^5
	;;^UTILITY(U,$J,358.3,10,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,10,1,1,0)
	;;=1^Comprehensive Exam  (31-40+ Min)
	;;^UTILITY(U,$J,358.3,10,1,2,0)
	;;=2^99215
	;;^UTILITY(U,$J,358.3,11,0)
	;;=99241^^4^9^1
	;;^UTILITY(U,$J,358.3,11,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,11,1,1,0)
	;;=1^Brief Visit         (1-20 Min)
	;;^UTILITY(U,$J,358.3,11,1,2,0)
	;;=2^99241
	;;^UTILITY(U,$J,358.3,12,0)
	;;=99242^^4^9^2
	;;^UTILITY(U,$J,358.3,12,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,12,1,1,0)
	;;=1^Limited Visit       (21-35 Min)
	;;^UTILITY(U,$J,358.3,12,1,2,0)
	;;=2^99242
	;;^UTILITY(U,$J,358.3,13,0)
	;;=99243^^4^9^3
	;;^UTILITY(U,$J,358.3,13,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,13,1,1,0)
	;;=1^Intermediate Visit  (35-50 Min)
	;;^UTILITY(U,$J,358.3,13,1,2,0)
	;;=2^99243
	;;^UTILITY(U,$J,358.3,14,0)
	;;=99244^^4^9^4
	;;^UTILITY(U,$J,358.3,14,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,14,1,1,0)
	;;=1^Extended Visit      (51-60 Min)
	;;^UTILITY(U,$J,358.3,14,1,2,0)
	;;=2^99244
	;;^UTILITY(U,$J,358.3,15,0)
	;;=99245^^4^9^5
	;;^UTILITY(U,$J,358.3,15,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,15,1,1,0)
	;;=1^Comprehensive Visit (71-80+ Min)
	;;^UTILITY(U,$J,358.3,15,1,2,0)
	;;=2^99245
	;;^UTILITY(U,$J,358.3,16,0)
	;;=99201^^9^18^1
	;;^UTILITY(U,$J,358.3,16,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,16,1,1,0)
	;;=1^Brief Visit         (1-15 Min)
	;;^UTILITY(U,$J,358.3,16,1,2,0)
	;;=2^99201
	;;^UTILITY(U,$J,358.3,17,0)
	;;=99202^^9^18^2
	;;^UTILITY(U,$J,358.3,17,1,0)
	;;=^357.31AI^2^2
	;;^UTILITY(U,$J,358.3,17,1,1,0)
	;;=1^Limited Exam        (16-25 Min)
