IBINI0AQ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,457,0)
	;;=FORM LOCATOR 57^F^^UF31;1^K:$L(X)>27!($L(X)<3) X
	;;^DD(399,457,3)
	;;=Answer must be 3-27 characters in length.
	;;^DD(399,457,21,0)
	;;=^^1^1^2931216^
	;;^DD(399,457,21,1,0)
	;;=Unlabled Form Locator 57 on the UB-92.
	;;^DD(399,457,"DT")
	;;=2931216
	;;^DD(399,458,0)
	;;=FORM LOCATOR 78^F^^UF31;2^K:$L(X)>5!($L(X)<3) X
	;;^DD(399,458,3)
	;;=Answer must be 3-5 characters in length.
	;;^DD(399,458,21,0)
	;;=^^2^2^2931216^
	;;^DD(399,458,21,1,0)
	;;=Printed in Form Locator 78 on the UB-92.  If more than 3 characters are
	;;^DD(399,458,21,2,0)
	;;=entered this will be printed on two lines.
	;;^DD(399,458,23,0)
	;;=^^4^4^2931216^
	;;^DD(399,458,23,1,0)
	;;=Unlabled Form Locator 78 on the UB-92.  On the form the block is two lines
	;;^DD(399,458,23,2,0)
	;;=of 2 and 3 characters, with the upper line optional.  Therefore, if
	;;^DD(399,458,23,3,0)
	;;=string is longer than 3 characters it must be split and printed on both
	;;^DD(399,458,23,4,0)
	;;=lines.
	;;^DD(399,458,"DT")
	;;=2931216
	;;^DD(399.0304,0)
	;;=PROCEDURES SUB-FIELD^^13^14
	;;^DD(399.0304,0,"DIK")
	;;=IBXX
	;;^DD(399.0304,0,"DT")
	;;=2931130
	;;^DD(399.0304,0,"ID","WRITE")
	;;=N X S X=^(0) W "   ",$E($P($G(@(U_$P($P(X,U),";",2)_+X_",0)")),U,$S($P(X,U,1)["CPT":2,1:4)),1,30)
	;;^DD(399.0304,0,"IX","AREV7",399.0304,4)
	;;=
	;;^DD(399.0304,0,"IX","ASC",399.0304,4)
	;;=
	;;^DD(399.0304,0,"IX","B",399.0304,.01)
	;;=
	;;^DD(399.0304,0,"IX","D",399.0304,3)
	;;=
	;;^DD(399.0304,0,"NM","PROCEDURES")
	;;=
	;;^DD(399.0304,0,"UP")
	;;=399
	;;^DD(399.0304,.01,0)
	;;=PROCEDURES^MV^^0;1^Q
	;;^DD(399.0304,.01,1,0)
	;;=^.1
	;;^DD(399.0304,.01,1,1,0)
	;;=399.0304^B
	;;^DD(399.0304,.01,1,1,1)
	;;=S ^DGCR(399,DA(1),"CP","B",$E(X,1,30),DA)=""
	;;^DD(399.0304,.01,1,1,2)
	;;=K ^DGCR(399,DA(1),"CP","B",$E(X,1,30),DA)
	;;^DD(399.0304,.01,1,1,3)
	;;=Required Index for Variable Pointer
	;;^DD(399.0304,.01,1,2,0)
	;;=399^ASD^MUMPS
	;;^DD(399.0304,.01,1,2,1)
	;;=I $P(X,";",2)="ICPT(",$D(^DGCR(399,DA(1),"CP",DA,0)),$P(^(0),"^",2) S ^DGCR(399,"ASD",-$P(^(0),"^",2),+X,DA(1),DA)=""
	;;^DD(399.0304,.01,1,2,2)
	;;=I $P(X,";",2)="ICPT(",$D(^DGCR(399,DA(1),"CP",DA,0)),$P(^(0),"^",2) K ^DGCR(399,"ASD",-$P(^(0),"^",2),+X,DA(1),DA)
	;;^DD(399.0304,.01,1,2,3)
	;;=DO NOT DELETE
	;;^DD(399.0304,.01,1,2,"%D",0)
	;;=^^1^1^2930513^^^
	;;^DD(399.0304,.01,1,2,"%D",1,0)
	;;=Index procedure date and all CPT procedures.
	;;^DD(399.0304,.01,1,2,"DT")
	;;=2920311
	;;^DD(399.0304,.01,1,3,0)
	;;=^^TRIGGER^399.0304^4
	;;^DD(399.0304,.01,1,3,1)
	;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"CP",D1,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y X ^DD(399.0304,.01,1,3,1.1) X ^DD(399.0304,.01,1,3,1.4)
	;;^DD(399.0304,.01,1,3,1.1)
	;;=S X=DIV S X=$$CP^IBEFUNC1(DA(1),DA) I X'="" S X=1
	;;^DD(399.0304,.01,1,3,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"CP",DIV(1),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=399.0304,DIG=4 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399.0304,.01,1,3,2)
	;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"CP",D1,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(399.0304,.01,1,3,2.4)
	;;^DD(399.0304,.01,1,3,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"CP",DIV(1),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=399.0304,DIG=4 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399.0304,.01,1,3,"%D",0)
	;;=^^1^1^2930903^
	;;^DD(399.0304,.01,1,3,"%D",1,0)
	;;=Calculate BASC Billable status.
	;;^DD(399.0304,.01,1,3,"CREATE VALUE")
	;;=S X=$$CP^IBEFUNC1(DA(1),DA) I X'="" S X=1
	;;^DD(399.0304,.01,1,3,"DELETE VALUE")
	;;=@
