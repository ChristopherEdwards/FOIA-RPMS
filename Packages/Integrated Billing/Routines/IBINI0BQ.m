IBINI0BQ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(399.3,0,"GL")
	;;=^DGCR(399.3,
	;;^DIC("B","RATE TYPE",399.3)
	;;=
	;;^DIC(399.3,"%D",0)
	;;=^^3^3^2940215^^^^
	;;^DIC(399.3,"%D",1,0)
	;;=This file contains all of the Rate Types which may be used in MCCR Billing.
	;;^DIC(399.3,"%D",2,0)
	;;= 
	;;^DIC(399.3,"%D",3,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(399.3,0)
	;;=FIELD^^.09^10
	;;^DD(399.3,0,"DT")
	;;=2920206
	;;^DD(399.3,0,"ID",.07)
	;;=W "Who's Responsible: ",@("$P($P($C(59)_$S($D(^DD(399.3,.07,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,7)_"":"",2),$C(59),1)")
	;;^DD(399.3,0,"IX","B",399.3,.01)
	;;=
	;;^DD(399.3,0,"NM","RATE TYPE")
	;;=
	;;^DD(399.3,0,"PT",399,.07)
	;;=
	;;^DD(399.3,.001,0)
	;;=NUMBER^NJ3,0^^ ^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(399.3,.001,3)
	;;=Enter the internal file number of this entry.
	;;^DD(399.3,.001,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.3,.001,21,1,0)
	;;=This is the internal file number of this entry.
	;;^DD(399.3,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<1)!'(X'?1P.E) X
	;;^DD(399.3,.01,1,0)
	;;=^.1
	;;^DD(399.3,.01,1,1,0)
	;;=399.3^B
	;;^DD(399.3,.01,1,1,1)
	;;=S ^DGCR(399.3,"B",$E(X,1,30),DA)=""
	;;^DD(399.3,.01,1,1,2)
	;;=K ^DGCR(399.3,"B",$E(X,1,30),DA)
	;;^DD(399.3,.01,3)
	;;=Enter the 1-30 character name/description of this rate type.
	;;^DD(399.3,.01,21,0)
	;;=^^1^1^2890331^^
	;;^DD(399.3,.01,21,1,0)
	;;=This is the name/description of this rate type.
	;;^DD(399.3,.01,"DEL",.01,0)
	;;=I 1 W !,"Deletion of Rate Types not allowed. Use the Inactive field."
	;;^DD(399.3,.02,0)
	;;=BILL NAME^RF^^0;2^K:$L(X)>30!($L(X)<1)!'(X'?1P.E) X
	;;^DD(399.3,.02,3)
	;;=Enter the 1-30 character text which you want to appear on the UB form each time a bill of this rate type is printed.
	;;^DD(399.3,.02,21,0)
	;;=^^2^2^2940120^^
	;;^DD(399.3,.02,21,1,0)
	;;=This is the text which will appear on the UB claim form each time a bill of
	;;^DD(399.3,.02,21,2,0)
	;;=this rate type is printed.
	;;^DD(399.3,.03,0)
	;;=INACTIVE^S^0:NO;1:YES;^0;3^Q
	;;^DD(399.3,.03,3)
	;;=Enter the code which indicates whether or not you would like to inactivate this rate type.
	;;^DD(399.3,.03,21,0)
	;;=^^1^1^2890405^^
	;;^DD(399.3,.03,21,1,0)
	;;=This indicates whether or not this code has been inactivated.
	;;^DD(399.3,.03,"DT")
	;;=2890405
	;;^DD(399.3,.04,0)
	;;=ABBREVIATION^RF^^0;4^K:$L(X)>8!($L(X)<2)!'(X?1A.ANP) X
	;;^DD(399.3,.04,3)
	;;=Enter the 2-8 character abbreviation of the name of this rate type which will appear on all of the billing outputs.
	;;^DD(399.3,.04,21,0)
	;;=^^2^2^2880901^
	;;^DD(399.3,.04,21,1,0)
	;;=This defines the abbreviation of the name of this rate type which will
	;;^DD(399.3,.04,21,2,0)
	;;=appear on all of the billing outputs.
	;;^DD(399.3,.05,0)
	;;=IS THIS A THIRD PARTY BILL?^RS^0:NO;1:YES;^0;5^Q
	;;^DD(399.3,.05,3)
	;;=Enter '1' or 'Yes' if this is a third party bill or '0' or 'No' if a bill of this rate type is not a third party bill.
	;;^DD(399.3,.05,21,0)
	;;=^^2^2^2880901^
	;;^DD(399.3,.05,21,1,0)
	;;=This allows the user to determine whether or not a bill of this rate type
	;;^DD(399.3,.05,21,2,0)
	;;=is a third party bill.
	;;^DD(399.3,.06,0)
	;;=ACCOUNTS RECEIVABLE CATEGORY^R*P430.2'^PRCA(430.2,^0;6^S DIC("S")="I $P(^(0),U,7)>9" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.3,.06,1,0)
	;;=^.1
	;;^DD(399.3,.06,1,1,0)
	;;=^^TRIGGER^399.3^.07
	;;^DD(399.3,.06,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399.3,D0,0)):^(0),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X=DIV D ARCAT^IBCU X ^DD(399.3,.06,1,1,1.4)
