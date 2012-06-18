IBINI03W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(354.2,0,"GL")
	;;=^IBE(354.2,
	;;^DIC("B","EXEMPTION REASON",354.2)
	;;=
	;;^DIC(354.2,"%D",0)
	;;=^^14^14^2940214^^^^
	;;^DIC(354.2,"%D",1,0)
	;;=Warning:  DO NOT EDIT ENTRIES IN THIS FILE without instructions from
	;;^DIC(354.2,"%D",2,0)
	;;=your ISC.
	;;^DIC(354.2,"%D",3,0)
	;;= 
	;;^DIC(354.2,"%D",4,0)
	;;=This file contains the reasons for exemptions to a particular billing
	;;^DIC(354.2,"%D",5,0)
	;;=process.  Initially it will contain reasons only for the Pharmacy Copay
	;;^DIC(354.2,"%D",6,0)
	;;=Income exemption process.  This may be expanded in a later release 
	;;^DIC(354.2,"%D",7,0)
	;;=to allow other exemptions to other processes.  The current software 
	;;^DIC(354.2,"%D",8,0)
	;;=expects certain entries in this file to exist.  Changing the data in
	;;^DIC(354.2,"%D",9,0)
	;;=this file can have major impact on the Pharmacy Copay process.  It
	;;^DIC(354.2,"%D",10,0)
	;;=should not be edited except on instruction from your ISC.  Generally
	;;^DIC(354.2,"%D",11,0)
	;;=instructions to modify this file will be released through the National
	;;^DIC(354.2,"%D",12,0)
	;;=Patch Module on FORUM.
	;;^DIC(354.2,"%D",13,0)
	;;= 
	;;^DIC(354.2,"%D",14,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(354.2,0)
	;;=FIELD^^.1^6
	;;^DD(354.2,0,"DDA")
	;;=N
	;;^DD(354.2,0,"DT")
	;;=2921216
	;;^DD(354.2,0,"ID",.03)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(354.2,.03,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,3)_"":"",2),$C(59),1)")
	;;^DD(354.2,0,"ID",.04)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(354.2,.04,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,4)_"":"",2),$C(59),1)")
	;;^DD(354.2,0,"ID",.05)
	;;=W "   ",$P(^(0),U,5)
	;;^DD(354.2,0,"ID",.1)
	;;=W:$D(^(10)) "   ",@("$P($P($C(59)_$S($D(^DD(354.2,.1,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(10),U,1)_"":"",2),$C(59),1)")
	;;^DD(354.2,0,"IX","AA",354.2,.1)
	;;=
	;;^DD(354.2,0,"IX","ACODE",354.2,.05)
	;;=
	;;^DD(354.2,0,"IX","AS",354.2,.04)
	;;=
	;;^DD(354.2,0,"IX","B",354.2,.01)
	;;=
	;;^DD(354.2,0,"IX","C",354.2,.05)
	;;=
	;;^DD(354.2,0,"NM","EXEMPTION REASON")
	;;=
	;;^DD(354.2,0,"PT",354,.05)
	;;=
	;;^DD(354.2,0,"PT",354.1,.05)
	;;=
	;;^DD(354.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(354.2,.01,1,0)
	;;=^.1
	;;^DD(354.2,.01,1,1,0)
	;;=354.2^B
	;;^DD(354.2,.01,1,1,1)
	;;=S ^IBE(354.2,"B",$E(X,1,30),DA)=""
	;;^DD(354.2,.01,1,1,2)
	;;=K ^IBE(354.2,"B",$E(X,1,30),DA)
	;;^DD(354.2,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(354.2,.01,21,0)
	;;=^^3^3^2921208^^
	;;^DD(354.2,.01,21,1,0)
	;;=This is the name of the exemption reason.  Do not edit this field.
	;;^DD(354.2,.01,21,2,0)
	;;= 
	;;^DD(354.2,.01,21,3,0)
	;;=This field can be printed as the short name of the exemption reason.
	;;^DD(354.2,.01,"DT")
	;;=2921208
	;;^DD(354.2,.02,0)
	;;=LONG NAME^F^^0;2^K:$L(X)>80!($L(X)<3) X
	;;^DD(354.2,.02,.1)
	;;=DESCRIPTION
	;;^DD(354.2,.02,3)
	;;=Enter the long description of this exemption reason.  Answer must be 3-80 characters in length.
	;;^DD(354.2,.02,21,0)
	;;=^^3^3^2921208^^^
	;;^DD(354.2,.02,21,1,0)
	;;=Enter a long description to explain this exemption
	;;^DD(354.2,.02,21,2,0)
	;;=reason.  This field will generally be displayed to users
	;;^DD(354.2,.02,21,3,0)
	;;=along with the Exemption Status to explain the status of an exemption.
	;;^DD(354.2,.02,"DT")
	;;=2921208
	;;^DD(354.2,.03,0)
	;;=TYPE^S^1:COPAY INCOME EXEMPTION;^0;3^Q
	;;^DD(354.2,.03,21,0)
	;;=^^6^6^2930430^^^
	;;^DD(354.2,.03,21,1,0)
	;;=This is the type of exemption this reason is for.  When creating an
