IBINI056	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(355.6,0,"GL")
	;;=^IBE(355.6,
	;;^DIC("B","INSURANCE RIDERS",355.6)
	;;=
	;;^DIC(355.6,"%D",0)
	;;=^^7^7^2940214^^^^
	;;^DIC(355.6,"%D",1,0)
	;;=This file contains a listing of Insurance Riders that can be purchased
	;;^DIC(355.6,"%D",2,0)
	;;=as add on coverage to a group plan.  The software does nothing special
	;;^DIC(355.6,"%D",3,0)
	;;=with these riders.  The listing may be added to locally and be assigned
	;;^DIC(355.6,"%D",4,0)
	;;=to patients as Policy riders.  This information is strictly for display
	;;^DIC(355.6,"%D",5,0)
	;;=and tracking purposes only.
	;;^DIC(355.6,"%D",6,0)
	;;= 
	;;^DIC(355.6,"%D",7,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(355.6,0)
	;;=FIELD^^11^2
	;;^DD(355.6,0,"DDA")
	;;=N
	;;^DD(355.6,0,"IX","B",355.6,.01)
	;;=
	;;^DD(355.6,0,"NM","INSURANCE RIDERS")
	;;=
	;;^DD(355.6,0,"PT",355.7,.01)
	;;=
	;;^DD(355.6,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(355.6,.01,1,0)
	;;=^.1
	;;^DD(355.6,.01,1,1,0)
	;;=355.6^B
	;;^DD(355.6,.01,1,1,1)
	;;=S ^IBE(355.6,"B",$E(X,1,30),DA)=""
	;;^DD(355.6,.01,1,1,2)
	;;=K ^IBE(355.6,"B",$E(X,1,30),DA)
	;;^DD(355.6,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(355.6,.01,21,0)
	;;=^^3^3^2931129^
	;;^DD(355.6,.01,21,1,0)
	;;=This is the name of the Rider.  The entries in this file are generic
	;;^DD(355.6,.01,21,2,0)
	;;=riders that are commonly purchased as add-on insurance to a group plan.
	;;^DD(355.6,.01,21,3,0)
	;;=Many plans allow the purchase of add-on riders while many do not.
	;;^DD(355.6,.01,"DT")
	;;=2931129
	;;^DD(355.6,11,0)
	;;=DESCRIPTION^355.611^^11;0
	;;^DD(355.6,11,21,0)
	;;=^^1^1^2931129^
	;;^DD(355.6,11,21,1,0)
	;;=This is a description of the riders.
	;;^DD(355.611,0)
	;;=DESCRIPTION SUB-FIELD^^.01^1
	;;^DD(355.611,0,"NM","DESCRIPTION")
	;;=
	;;^DD(355.611,0,"UP")
	;;=355.6
	;;^DD(355.611,.01,0)
	;;=DESCRIPTION^W^^0;1^Q
	;;^DD(355.611,.01,"DT")
	;;=2931129
