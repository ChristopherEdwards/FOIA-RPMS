IBRFN	;ALB/AAS - Supported functions for AR ; cinco de mayo, 1992
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
ERR(Y)	;  - input Y = -1^error code[;error code...]^literal message
	;  - output IBRERR = error message 1
	;         if more than one code then
	;           IBRERR(n)=error code n
	N N,X,X1,X2 K IBRERR S IBRERR=""
	G:+Y>0 ERRQ
	S X2=$P(Y,"^",2) F N=1:1 S X=$P(X2,";",N) Q:X=""  S X1=$P($G(^IBE(350.8,+$O(^IBE(350.8,"AC",X,0)),0)),"^",2) D
	.I N=1 S IBRERR=X1
	.I $P(Y,"^",3)]""!($P(X2,";",2,99)]"") S IBRERR(N)=X1
	I $P(Y,"^",3)]"" S N=N+1,IBRERR(N)=$P(Y,"^",3)
ERRQ	Q IBRERR
	;
MESS(Y)	;  -input y=error code - from file 350.8 (piece 3)
	;   output error message
	Q $P($G(^IBE(350.8,+$O(^IBE(350.8,"AC",Y,0)),0)),"^",2)
	;
SVDT(BN,VDT)	;returns service dates for a specific bill
	;- input:  BN bill number (external form)
	;          VDT name of array to hold outpatient visit dates, pass by value (if needed)
	;- output: X function value, string, = 0 if bill not found
	;            = 1 (Inpt) or 2 (Outpt)^event date^stmt from date^stmt to date^LOS (I)^Number of visit dates (O)
	;              all are internal form, any piece may be null if not defined for the bill
	;          array containing outpatient visit dates as subscripts/no data, if VDT passed by value
	N X,Y,IFN S X=0,BN=$G(BN)
	I BN'="" S IFN=+$O(^DGCR(399,"B",BN,0)),Y=$G(^DGCR(399,IFN,0)) I Y'="" D
	. S X=$S(+$P(Y,U,5)<1:"",+$P(Y,U,5)<3:1,+$P(Y,U,5)<5:2,1:"")_U_$P(Y,U,3),Y=$G(^DGCR(399,IFN,"U"))
	. S X=X_U_$P(Y,U,1)_U_$P(Y,U,2)_U_$P(Y,U,15)_U_$P($G(^DGCR(399,IFN,"OP",0)),U,4)
	. S Y=0 F  S Y=$O(^DGCR(399,IFN,"OP",Y)) Q:'Y  S VDT(Y)=""
	Q X
