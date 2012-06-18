IBINI036	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(352.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(352.1,0,"GL")
	;;=^IBE(352.1,
	;;^DIC("B","BILLABLE APPOINTMENT TYPE",352.1)
	;;=
	;;^DIC(352.1,"%D",0)
	;;=^^6^6^2940214^
	;;^DIC(352.1,"%D",1,0)
	;;=Records for each appointment type with indicators for  IGNORE 
	;;^DIC(352.1,"%D",2,0)
	;;=MEANS TEST, PRINT ON INSURANCE REPORT, and DISPLAY ON INPUT
	;;^DIC(352.1,"%D",3,0)
	;;=SCREEN.  Also contains effective date of determination.
	;;^DIC(352.1,"%D",4,0)
	;;=Accessed by extrinsic function ^IBEFUNC.
	;;^DIC(352.1,"%D",5,0)
	;;= 
	;;^DIC(352.1,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(352.1,0)
	;;=FIELD^^.06^6
	;;^DD(352.1,0,"DDA")
	;;=N
	;;^DD(352.1,0,"DT")
	;;=2911022
	;;^DD(352.1,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^SD(409.1,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(409.1,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(352.1,0,"ID",.03)
	;;=W "   ",$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)
	;;^DD(352.1,0,"IX","AIVDT1",352.1,.02)
	;;=
	;;^DD(352.1,0,"IX","AIVDT2",352.1,.03)
	;;=
	;;^DD(352.1,0,"IX","B",352.1,.01)
	;;=
	;;^DD(352.1,0,"IX","C",352.1,.02)
	;;=
	;;^DD(352.1,0,"IX","D",352.1,.03)
	;;=
	;;^DD(352.1,0,"NM","BILLABLE APPOINTMENT TYPE")
	;;=
	;;^DD(352.1,.01,0)
	;;=NUMBER^RNJ2,0^^0;1^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(352.1,.01,1,0)
	;;=^.1^^0
	;;^DD(352.1,.01,1,1,0)
	;;=352.1^B
	;;^DD(352.1,.01,1,1,1)
	;;=S ^IBE(352.1,"B",$E(X,1,30),DA)=""
	;;^DD(352.1,.01,1,1,2)
	;;=K ^IBE(352.1,"B",$E(X,1,30),DA)
	;;^DD(352.1,.01,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(352.1,.01,21,0)
	;;=^^1^1^2920406^^^
	;;^DD(352.1,.01,21,1,0)
	;;=This is a unique number for each entry.
	;;^DD(352.1,.01,"DT")
	;;=2911021
	;;^DD(352.1,.02,0)
	;;=APPOINTMENT TYPE^RP409.1'^SD(409.1,^0;2^Q
	;;^DD(352.1,.02,1,0)
	;;=^.1
	;;^DD(352.1,.02,1,1,0)
	;;=352.1^AIVDT1^MUMPS
	;;^DD(352.1,.02,1,1,1)
	;;=I $P(^IBE(352.1,DA,0),U,3) S ^IBE(352.1,"AIVDT",X,-$P(^(0),U,3),DA)=""
	;;^DD(352.1,.02,1,1,2)
	;;=I $P(^IBE(352.1,DA,0),U,3) K ^IBE(352.1,"AIVDT",X,-$P(^(0),U,3),DA)
	;;^DD(352.1,.02,1,1,"%D",0)
	;;=^^1^1^2911022^
	;;^DD(352.1,.02,1,1,"%D",1,0)
	;;=Used to find most recent entry for appointment type.
	;;^DD(352.1,.02,1,1,"DT")
	;;=2911022
	;;^DD(352.1,.02,1,2,0)
	;;=352.1^C
	;;^DD(352.1,.02,1,2,1)
	;;=S ^IBE(352.1,"C",$E(X,1,30),DA)=""
	;;^DD(352.1,.02,1,2,2)
	;;=K ^IBE(352.1,"C",$E(X,1,30),DA)
	;;^DD(352.1,.02,1,2,"DT")
	;;=2911022
	;;^DD(352.1,.02,21,0)
	;;=^^1^1^2920406^^
	;;^DD(352.1,.02,21,1,0)
	;;=This is the MAS Appointment type.
	;;^DD(352.1,.02,"DT")
	;;=2911022
	;;^DD(352.1,.03,0)
	;;=EFFECTIVE DATE^RDI^^0;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(352.1,.03,1,0)
	;;=^.1
	;;^DD(352.1,.03,1,1,0)
	;;=352.1^AIVDT2^MUMPS
	;;^DD(352.1,.03,1,1,1)
	;;=I $P(^IBE(352.1,DA,0),U,2) S ^IBE(352.1,"AIVDT",$P(^(0),U,2),-X,DA)=""
	;;^DD(352.1,.03,1,1,2)
	;;=I $P(^IBE(352.1,DA,0),U,2) K ^IBE(352.1,"AIVDT",$P(^(0),U,2),-X,DA)
	;;^DD(352.1,.03,1,1,"%D",0)
	;;=^^1^1^2911022^
	;;^DD(352.1,.03,1,1,"%D",1,0)
	;;=Used to find most recent entry for an appointment type.
	;;^DD(352.1,.03,1,1,"DT")
	;;=2911022
	;;^DD(352.1,.03,1,2,0)
	;;=352.1^D
	;;^DD(352.1,.03,1,2,1)
	;;=S ^IBE(352.1,"D",$E(X,1,30),DA)=""
	;;^DD(352.1,.03,1,2,2)
	;;=K ^IBE(352.1,"D",$E(X,1,30),DA)
	;;^DD(352.1,.03,1,2,"DT")
	;;=2911022
	;;^DD(352.1,.03,21,0)
	;;=^^7^7^2920406^^^
	;;^DD(352.1,.03,21,1,0)
	;;=Every Appointment type has certain billing characteristics that may
	;;^DD(352.1,.03,21,2,0)
	;;=change over time.  For example, an appointment type may not be billable
