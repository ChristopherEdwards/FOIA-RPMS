IBCCC1	;ALB/AAS - CANCEL AND CLONE A BILL - CONTINUED ;25-JAN-90
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRCC1
	;
	;STEP 1 - cancell bill
	;STEP 1.5 - entry to clone previously cancelled bill.  (must be cancell)
	;STEP 2 - build array of IBIDS call screen that asks ok
	;STEP 3 - pass stub entry to ar
	;STEP 4 - store stub data in MCCR then x-ref
	;STEP 5 - get remainder of data to move and store in MCCR then x-ref
	;STEP 6 - go to screens, come out to IBB1 or something like that
	;
STEP4	S X=$P($T(WHERE),";;",2) F I=0:0 S I=$O(IBIDS(I)) Q:'I  S X1=$P($E(X,$F(X,I)+1,999),";",1),$P(IBDR($P(X1,"^",1)),"^",$P(X1,"^",2))=IBIDS(I)
	S IBIFN=PRCASV("ARREC") F I=0,"C","M","M1","S","U","U1" I $D(IBDR(I)) S ^DGCR(399,IBIFN,I)=IBDR(I)
	S $P(^DGCR(399,0),"^",3)=IBIFN,$P(^(0),"^",4)=$P(^(0),"^",4)+1 W !,"Cross-referencing new billing entry..." D INDEX^IBCCC2
	S IBYN=1 W !!,*7,"Billing Record #",$P(^DGCR(399,+IBIFN,0),"^",1)," established for '",VADM(1),"'..."
END	K %,%DT,IB,IBA,IBNWBL,IBBT,IBIDS,I,J,VADM,X,X1,X2,X3,X4,Y
	;
	G ^IBCCC2 ;go to step 5
	;
	;
XREF	F IBI1=0:0 S IBI1=$O(^DD(399,IBI,1,IBI1)) Q:'IBI1  I $D(^DD(399,IBI,1,IBI1,1)) S DA=IBIFN,X=IBIDS(IBI) I X]"" X ^DD(399,IBI,1,IBI1,1)
	Q
	;
WHERE	;;.01^0^1;.02^0^2;.03^0^3;.04^0^4;.05^0^5;.06^0^6;.07^0^7;.08^0^8;.09^0^9;.11^0^11;.12^0^12;.17^0^17;.18^0^18;.19^0^19;.15^0^15;.16^0^16;104^M^4;105^M^5;106^M^6;107^M^7;108^M^8;109^M^9;121^M1^1;151^U^1;152^U^2;155^U^5;101^M^1;
