IBARXEC4	;ALB/AAS - RX COPAY EXEMPTION CONVERSION REPORT BUILD ; 14-JAN-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	;
BUILD	; -- Build report
	;
	S (IBOK,IBN)=0
	F  S IBN=$O(^IB("AC",11,IBN)) Q:'IBN  D CHK,SET:IBOK
	Q
	;
CHK	; -- is entry in date range
	S IBOK=0
	S X=$G(^IB(IBN,0)),X1=$G(^IB(IBN,1))
	I X=""!(X1="") G CHK Q
	I (IBBDT-.00001)<$P(X1,"^",2),(IBEDT+.9)>$P(X1,"^",2) S IBOK=1
CHKQ	Q
	;
SET	; -- set entry in ^tmp
	S DFN=$P(X,"^",2)
	S IBP=$$PT^IBEFUNC(DFN) ; name^bid^pid
	S ^TMP("IBCONV",$J,$P(IBP,"^"),DFN,IBN)=IBP
	Q
