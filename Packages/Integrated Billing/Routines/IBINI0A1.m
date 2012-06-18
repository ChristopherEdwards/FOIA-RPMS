IBINI0A1	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.19,1,1,"%D",2,0)
	;;=set coding method to CPT-4.
	;;^DD(399,.19,1,1,"CREATE CONDITION")
	;;=FORM TYPE="HCFA 1500"&(PROCEDURE CODING METHOD="")
	;;^DD(399,.19,1,1,"CREATE VALUE")
	;;=S X=4
	;;^DD(399,.19,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.19,1,1,"DT")
	;;=2920430
	;;^DD(399,.19,1,1,"FIELD")
	;;=PROCEDURE CODING METHOD
	;;^DD(399,.19,1,2,0)
	;;=399^AREV7^MUMPS
	;;^DD(399,.19,1,2,1)
	;;=S DGRVRCAL=1
	;;^DD(399,.19,1,2,2)
	;;=S DGRVRCAL=2
	;;^DD(399,.19,1,2,3)
	;;=DO NOT DELETE
	;;^DD(399,.19,1,2,"%D",0)
	;;=^^2^2^2940214^
	;;^DD(399,.19,1,2,"%D",1,0)
	;;=Variable causes revenue codes and chrges to be re-calculated on return
	;;^DD(399,.19,1,2,"%D",2,0)
	;;=to the enter/edit billing screens.
	;;^DD(399,.19,1,2,"DT")
	;;=2920428
	;;^DD(399,.19,3)
	;;=Enter the type of claim form to be used.
	;;^DD(399,.19,5,1,0)
	;;=399^.01^7
	;;^DD(399,.19,5,2,0)
	;;=399^101^4
	;;^DD(399,.19,21,0)
	;;=^^1^1^2920427^^^^
	;;^DD(399,.19,21,1,0)
	;;=The form type that the bill is printed on.
	;;^DD(399,.19,"DT")
	;;=2920430
	;;^DD(399,.2,0)
	;;=AUTO^S^0:NO;1:YES;^0;20^Q
	;;^DD(399,.2,3)
	;;=True if this bill was created by the auto biller.
	;;^DD(399,.2,21,0)
	;;=^^2^2^2940125^
	;;^DD(399,.2,21,1,0)
	;;=True if this bill was created by the auto biller.  Should only be set
	;;^DD(399,.2,21,2,0)
	;;=by the auto biller software, no manual entry.
	;;^DD(399,.2,"DT")
	;;=2940125
	;;^DD(399,1,0)
	;;=DATE ENTERED^RDXI^^S;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399,1,1,0)
	;;=^.1
	;;^DD(399,1,1,1,0)
	;;=399^APD
	;;^DD(399,1,1,1,1)
	;;=S ^DGCR(399,"APD",$E(X,1,30),DA)=""
	;;^DD(399,1,1,1,2)
	;;=K ^DGCR(399,"APD",$E(X,1,30),DA)
	;;^DD(399,1,1,1,"%D",0)
	;;=^^1^1^2920521^
	;;^DD(399,1,1,1,"%D",1,0)
	;;=Regular cross-reference used to speed up reports.
	;;^DD(399,1,1,1,"DT")
	;;=2920521
	;;^DD(399,1,3)
	;;=Enter the date on which this billing record was established.
	;;^DD(399,1,5,1,0)
	;;=399^.01^3
	;;^DD(399,1,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,1,21,1,0)
	;;=This is the date on which this billing record was established.
	;;^DD(399,1,"DT")
	;;=2920521
	;;^DD(399,2,0)
	;;=ENTERED/EDITED BY^RP200'I^VA(200,^S;2^Q
	;;^DD(399,2,3)
	;;=Enter the user who established this billing record.
	;;^DD(399,2,5,1,0)
	;;=399^.01^4
	;;^DD(399,2,21,0)
	;;=^^1^1^2940214^^^
	;;^DD(399,2,21,1,0)
	;;=This is the user who established this billing record.
	;;^DD(399,2,"DT")
	;;=2900921
	;;^DD(399,3,0)
	;;=INITIAL REVIEW^FOX^^S;3^I $D(X) D YN^IBCU
	;;^DD(399,3,.1)
	;;=DO YOU APPROVE THIS BILL? (Y/N)
	;;^DD(399,3,1,0)
	;;=^.1
	;;^DD(399,3,1,1,0)
	;;=^^TRIGGER^399^4
	;;^DD(399,3,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,4)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,3,1,1,1.4)
	;;^DD(399,3,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,4)=DIV,DIH=399,DIG=4 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399,3,1,1,2)
	;;=Q
	;;^DD(399,3,1,1,"CREATE CONDITION")
	;;=INITIAL REVIEW DATE=""
	;;^DD(399,3,1,1,"CREATE VALUE")
	;;=TODAY
	;;^DD(399,3,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,3,1,1,"DT")
	;;=2940310
	;;^DD(399,3,1,1,"FIELD")
	;;=INITIAL REVIEW DATE
	;;^DD(399,3,1,2,0)
	;;=^^TRIGGER^399^5
	;;^DD(399,3,1,2,1)
	;;=X ^DD(399,3,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,3,1,2,1.4)
	;;^DD(399,3,1,2,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,5),0)):"",1:$P(^(0),U,1))=""
