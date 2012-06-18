IBCSC4A	;ALB/MJB - MCCR PTF SCREEN  ;24 FEB 89 9:49
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC4A
	;
DX	Q:'$D(^DGPT(+IBPTF,0))  S (IBDXC,IBOPC)=0,IBNC="NO DX CODES ENTERED FOR THIS DATE" K ^UTILITY($J,"IBDX")
	F I=0:0 S I=$O(^DGPT(IBPTF,"M","AM",I)) Q:I'>0  S X=$O(^DGPT(IBPTF,"M","AM",I,0)),IBDX((9999999-$P(I,".",1)),X)=""
	I '$D(^DGPT(IBPTF,"M","AM")) S IBDX(9999999-DT,1)=""
	S IBDIA=0 F I=1:1:26 S IBDIA=$O(IBDX(IBDIA)) Q:IBDIA=""  S X=$O(IBDX(IBDIA,0)),M=$S($D(^DGPT(IBPTF,"M",X,0)):^(0),1:"") I M]"" S IBCT=0 F J=5:1:9 S:$P(M,U,J)]"" IBCT=IBCT+1,^UTILITY($J,"IBDX",I,IBCT)=$P(M,U,J) D:J=5 T
	S IBDIA="" F I=1:1:13 S IBDIA=$O(^UTILITY($J,"IBDX",IBDIA)) Q:IBDIA=""  D ODD S IBDIA=$O(^UTILITY($J,"IBDX",IBDIA)) D:IBDIA]"" EVEN D SETD^IBCSC4C Q:IBDIA']""
	;
PRO	S IBNC="NO PRO CODES ENTERED FOR THIS DATE",IBOPC=0 K ^UTILITY($J,"IB")
	F I=0:0 S I=$O(^DGPT(IBPTF,"S",I)) Q:I'>0  S J=$S($D(^DGPT(IBPTF,"S",I,0)):^(0),1:"") I J]"" S X=+J,X=$S(X[".":9999999-X,1:(9999999_"."_I)-X),IBOP(X)=$P(J,U)_U_$P(J,U,8,12)
	F I=0:0 S I=$O(^DGPT(IBPTF,"P",I)) Q:I'>0  S J=$S($D(^DGPT(IBPTF,"P",I,0)):^(0),1:"") I J]"" S X=+J,X=$S(X[".":9999999-X,1:(9999999_"."_I)-X),IBSP(X)=$P(J,U)_U_$P(J,U,5,9)
	S IBP=0 F I=1:1:26 S IBP=$O(IBOP(IBP)) Q:IBP=""  S M=IBOP(IBP),IBCT=0 F J=2:1:6 Q:IBCT=3  S:$P(M,U,J)]"" IBCT=IBCT+1,^UTILITY($J,"IB",I,IBCT)=$P(M,U,J) D:J=2 TP
	I I<26 S IBP="" F I=I:1:26 S IBP=$O(IBSP(IBP)) Q:IBP=""  S M=IBSP(IBP),IBCT=0 F J=2:1:6 Q:IBCT=3  S:$P(M,U,J)]"" IBCT=IBCT+1 D:$P(M,U,J)]"" T1 D:J=2 T2
	S IBP="" F I=1:1:13 S IBP=$O(^UTILITY($J,"IB",IBP)) Q:IBP=""  D ODDP S IBP=$O(^UTILITY($J,"IB",IBP)) D:IBP]"" EVENP D SETP^IBCSC4C Q:IBP=""
	Q
	;
T	I IBCT>0 S IBDXC=IBDXC+1,^UTILITY($J,"IBDX",I,IBCT)=^UTILITY($J,"IBDX",I,IBCT)_U_$P($P(M,U,10),".",1)_U_$C(64+IBDXC)_U_$P(M,U,2)_"^"_$S(X'=1:"",'$D(^DGPT(IBPTF,70)):"",1:"D/C")_"^"_$$SC(M) Q
	S ^UTILITY($J,"IBDX",I,1)=IBNC_U_$P($P(M,U,10),".",1)_"^^"_$P(^DGPT(IBPTF,"M",X,0),U,2)_"^^"_$$SC(M) Q
	;
ODD	S X=^UTILITY($J,"IBDX",IBDIA,1),IBWO(0)=$P(X,U,3)_U_$P(X,U,2)_U_$P(X,U,4,6),IBWO(1)=$P(X,U,1) F M=2:1:5 S IBWO(M)=$S($D(^UTILITY($J,"IBDX",IBDIA,M)):^(M),1:"")
	Q
	;
EVEN	S X=^UTILITY($J,"IBDX",IBDIA,1),IBWE(0)=$P(X,U,3)_U_$P(X,U,2)_U_$P(X,U,4,6),IBWE(1)=$P(X,U,1) F M=2:1:5 S IBWE(M)=$S($D(^UTILITY($J,"IBDX",IBDIA,M)):^(M),1:"")
	I $P(IBWE(0),U,1)']"" F M=1:1:5 S IBWE(M)=""
	Q
	;
TP	I IBCT>0 S IBOPC=IBOPC+1,^UTILITY($J,"IB",I,IBCT)=^UTILITY($J,"IB",I,IBCT)_U_$P(+M,".",1)_U_$C(64+IBOPC) Q
	S ^UTILITY($J,"IB",I,1)=IBNC_U_$P(+M,".",1) Q
T1	S ^UTILITY($J,"IB",I,IBCT)=$P(M,U,J) Q
T2	I IBCT>0 S IBOPC=IBOPC+1,^UTILITY($J,"IB",I,IBCT)=^UTILITY($J,"IB",I,IBCT)_U_$P($P(M,U,1),".",1)_U_$C(64+IBOPC)_U_"*" Q
	S ^UTILITY($J,"IB",I,1)=IBNC_U_$P($P(M,U,1),".",1)_"^^*" Q
	;
ODDP	S X=^UTILITY($J,"IB",IBP,1),IBWO(0)=$P(X,U,3)_U_$P(X,U,2)_U_$S($P(X,U,4)="*":"*",1:""),IBWO(1)=$P(X,U,1) F M=2:1:5 S IBWO(M)=$S($D(^UTILITY($J,"IB",IBP,M)):^(M),1:"")
	Q
	;
EVENP	S X=^UTILITY($J,"IB",IBP,1),IBWE(0)=$P(X,U,3)_U_$P(X,U,2)_U_$S($P(X,U,4)="*":"*",1:""),IBWE(1)=$P(X,U,1) F M=2:1:5 S IBWE(M)=$S($D(^UTILITY($J,"IB",IBP,M)):^(M),1:"")
	Q
	;
NUL	F I=1:1:13 S $P(^DGCR(399,IBIFN,"C"),U,I)=""
	Q
	;
P	S M=($A($E(X,1))-64),S=$E(X,2),IB5=$S($D(^UTILITY($J,"IB",M,S)):^(S),1:"") I IB5]"" Q:$P(^UTILITY($J,"IB",M,1),U,3)=$E(X,1)
	F J=M:1:26 Q:'$D(^UTILITY($J,"IB",J))  I $P(^UTILITY($J,"IB",J,1),U,3)=$E(X,1) S M=J,IBA=1 Q
	S:'$D(IBA) M=0 K IBA Q
D	S M=($A($E(X,1))-64),S=$E(X,2),IB4=$S($D(^UTILITY($J,"IBDX",M,S)):^(S),1:"") I IB4]"" Q:$P(^UTILITY($J,"IBDX",M,1),U,3)=$E(X,1)
	F J=M:1:26 Q:'$D(^UTILITY($J,"IBDX",J))  I $P(^UTILITY($J,"IBDX",J,1),U,3)=$E(X,1) S M=J,IBA=1 Q
	S:'$D(IBA) M=0 K IBA Q
	;
SC(M)	;  - check SC flag of movement
	;    input movement node
	;    output flag as to whether sc or not
	I '$D(M) Q ""
	I M="" Q ""
	Q $S($P(M,"^",18)=1:"<SC>",1:"<NSC>")
