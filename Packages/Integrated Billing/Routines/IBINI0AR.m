IBINI0AR	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.0304,.01,1,3,"DT")
	;;=2930903
	;;^DD(399.0304,.01,1,3,"FIELD")
	;;=BASC BILLABLE
	;;^DD(399.0304,.01,3)
	;;=Procedure coding must match the PROCEDURE CODING METHOD entry for this bill.
	;;^DD(399.0304,.01,4)
	;;=D 3^IBCSCH1
	;;^DD(399.0304,.01,7.5)
	;;=D ^IBCU7
	;;^DD(399.0304,.01,21,0)
	;;=^^2^2^2930513^^^^
	;;^DD(399.0304,.01,21,1,0)
	;;=These are ICD, CPT, of HCFA procedure codes associated with the episode
	;;^DD(399.0304,.01,21,2,0)
	;;=of care on this bill.
	;;^DD(399.0304,.01,23,0)
	;;=^^1^1^2930513^^^
	;;^DD(399.0304,.01,23,1,0)
	;;= 
	;;^DD(399.0304,.01,"DT")
	;;=2930903
	;;^DD(399.0304,.01,"V",0)
	;;=^.12P^2^2
	;;^DD(399.0304,.01,"V",1,0)
	;;=81^CPT^1^CPT^n^n
	;;^DD(399.0304,.01,"V",2,0)
	;;=80.1^ICD operation/procedure^2^ICD^n^n
	;;^DD(399.0304,1,0)
	;;=PROCEDURE DATE^DX^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X),$D(IBIFN),'$$OPV2^IBCU41(X,IBIFN,1) K X
	;;^DD(399.0304,1,1,0)
	;;=^.1
	;;^DD(399.0304,1,1,1,0)
	;;=399^ASD1^MUMPS
	;;^DD(399.0304,1,1,1,1)
	;;=I $D(^DGCR(399,DA(1),"CP",DA,0)),+^(0),$P($P(^(0),"^",1),";",2)="ICPT(" S ^DGCR(399,"ASD",-X,+^(0),DA(1),DA)=""
	;;^DD(399.0304,1,1,1,2)
	;;=I $D(^DGCR(399,DA(1),"CP",DA,0)),+^(0),$P($P(^(0),"^",1),";",2)="ICPT(" K ^DGCR(399,"ASD",-X,+^(0),DA(1),DA)
	;;^DD(399.0304,1,1,1,3)
	;;=DO NOT DELETE
	;;^DD(399.0304,1,1,1,"%D",0)
	;;=^^1^1^2930617^^^
	;;^DD(399.0304,1,1,1,"%D",1,0)
	;;=Index procedure date and all CPT procedures.
	;;^DD(399.0304,1,1,1,"DT")
	;;=2920311
	;;^DD(399.0304,1,1,2,0)
	;;=^^TRIGGER^399.0304^4
	;;^DD(399.0304,1,1,2,1)
	;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"CP",D1,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y X ^DD(399.0304,1,1,2,1.1) X ^DD(399.0304,1,1,2,1.4)
	;;^DD(399.0304,1,1,2,1.1)
	;;=S X=DIV S X=$$CP^IBEFUNC1(DA(1),DA) I X'="" S X=1
	;;^DD(399.0304,1,1,2,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"CP",DIV(1),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=399.0304,DIG=4 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399.0304,1,1,2,2)
	;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"CP",D1,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(399.0304,1,1,2,2.4)
	;;^DD(399.0304,1,1,2,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"CP",DIV(1),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=399.0304,DIG=4 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399.0304,1,1,2,"%D",0)
	;;=^^1^1^2930903^
	;;^DD(399.0304,1,1,2,"%D",1,0)
	;;=Calculate BASC Billable Status flag.
	;;^DD(399.0304,1,1,2,"CREATE VALUE")
	;;=S X=$$CP^IBEFUNC1(DA(1),DA) I X'="" S X=1
	;;^DD(399.0304,1,1,2,"DELETE VALUE")
	;;=@
	;;^DD(399.0304,1,1,2,"DT")
	;;=2930903
	;;^DD(399.0304,1,1,2,"FIELD")
	;;=BASC BILLABLE
	;;^DD(399.0304,1,3)
	;;=Procedure date must be within the bill's STATEMENT FROM and STATEMENT TO dates.
	;;^DD(399.0304,1,21,0)
	;;=^^1^1^2911025^
	;;^DD(399.0304,1,21,1,0)
	;;=This is the date the procedure was performed.
	;;^DD(399.0304,1,"DT")
	;;=2930903
	;;^DD(399.0304,2,0)
	;;=*ADDITIONAL PROCEDURE NAME^FI^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>28!($L(X)<3)!'(X?.ANP) X
	;;^DD(399.0304,2,.1)
	;;=ADDITIONAL PROCEDURE NAME
	;;^DD(399.0304,2,1,0)
	;;=^.1^^0
	;;^DD(399.0304,2,3)
	;;=Answer must be 3-28 characters in length.
	;;^DD(399.0304,2,9)
	;;=^
	;;^DD(399.0304,2,21,0)
	;;=^^3^3^2920211^^^
	;;^DD(399.0304,2,21,1,0)
	;;=This is the name of the procedure.
	;;^DD(399.0304,2,21,2,0)
	;;= 
	;;^DD(399.0304,2,21,3,0)
	;;=This field has been marked for deletion 11/4/91.
	;;^DD(399.0304,2,"DT")
	;;=2911104
	;;^DD(399.0304,3,0)
	;;=PRINT ORDER^NJ2,0X^^0;4^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X I $D(X),$D(^DGCR(399,DA(1),"CP","D",X)) W !!,*7,"This number already used!" K X
