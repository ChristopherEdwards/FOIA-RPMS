FHINI0MC	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(118.3,0,"GL")
	;;=^FH(118.3,
	;;^DIC("B","STANDING ORDERS",118.3)
	;;=
	;;^DIC(118.3,"%D",0)
	;;=^^3^3^2871124^
	;;^DIC(118.3,"%D",1,0)
	;;=This is a list of the common standing orders (often called add-ons
	;;^DIC(118.3,"%D",2,0)
	;;=or specials) which may be ordered for a patient. It may include
	;;^DIC(118.3,"%D",3,0)
	;;=such things as 'double portions' or preferences such as 'no fish.'
	;;^DD(118.3,0)
	;;=FIELD^^99^3
	;;^DD(118.3,0,"DT")
	;;=2920504
	;;^DD(118.3,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(118.3,0,"IX","AC",118.3,99)
	;;=
	;;^DD(118.3,0,"IX","B",118.3,.01)
	;;=
	;;^DD(118.3,0,"NM","STANDING ORDERS")
	;;=
	;;^DD(118.3,0,"PT",111.11,.01)
	;;=
	;;^DD(118.3,0,"PT",111.12,.01)
	;;=
	;;^DD(118.3,0,"PT",111.13,.01)
	;;=
	;;^DD(118.3,0,"PT",115.08,1)
	;;=
	;;^DD(118.3,0,"SCR")
	;;=I '$D(^FH(118.3,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(118.3,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(118.3,.01,1,0)
	;;=^.1
	;;^DD(118.3,.01,1,1,0)
	;;=118.3^B
	;;^DD(118.3,.01,1,1,1)
	;;=S ^FH(118.3,"B",$E(X,1,30),DA)=""
	;;^DD(118.3,.01,1,1,2)
	;;=K ^FH(118.3,"B",$E(X,1,30),DA)
	;;^DD(118.3,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(118.3,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(118.3,.01,3)
	;;=ANSWER MUST BE 3-30 CHARACTERS IN LENGTH
	;;^DD(118.3,.01,21,0)
	;;=^^3^3^2880710^
	;;^DD(118.3,.01,21,1,0)
	;;=This field contains the name of a standing order. It may be
	;;^DD(118.3,.01,21,2,0)
	;;=such things as 'double portions', 'extra coffee', or even
	;;^DD(118.3,.01,21,3,0)
	;;=preferences such as 'no fish.'
	;;^DD(118.3,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(118.3,1,0)
	;;=LABEL?^S^Y:YES;N:NO;^0;2^Q
	;;^DD(118.3,1,21,0)
	;;=^^2^2^2920508^^
	;;^DD(118.3,1,21,1,0)
	;;=This field specifies whether the label should be printed or not for this
	;;^DD(118.3,1,21,2,0)
	;;=order.
	;;^DD(118.3,1,"DT")
	;;=2920504
	;;^DD(118.3,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(118.3,99,1,0)
	;;=^.1
	;;^DD(118.3,99,1,1,0)
	;;=118.3^AC^MUMPS
	;;^DD(118.3,99,1,1,1)
	;;=K:X'="Y" ^FH(118.3,DA,"I")
	;;^DD(118.3,99,1,1,2)
	;;=K ^FH(118.3,DA,"I")
	;;^DD(118.3,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(118.3,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(118.3,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(118.3,99,21,0)
	;;=^^2^2^2940701^^
	;;^DD(118.3,99,21,1,0)
	;;=This field, if answered YES, will prohibit further selection of
	;;^DD(118.3,99,21,2,0)
	;;=this standing order by ward or dietetic personnel.
	;;^DD(118.3,99,"DT")
	;;=2880116
