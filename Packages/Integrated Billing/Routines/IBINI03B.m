IBINI03B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(352.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(352.3,0,"GL")
	;;=^IBE(352.3,
	;;^DIC("B","NON-BILLABLE CLINIC STOP CODES",352.3)
	;;=
	;;^DIC(352.3,"%D",0)
	;;=^^12^12^2940214^^^^
	;;^DIC(352.3,"%D",1,0)
	;;=This file shall be used to flag clinic stop codes in the CLINIC
	;;^DIC(352.3,"%D",2,0)
	;;=STOP (#40.7) file as either billable or non-billable for Means
	;;^DIC(352.3,"%D",3,0)
	;;=Test Billing.  The flagging of the stop codes is date-sensitive,
	;;^DIC(352.3,"%D",4,0)
	;;=so the ability to not bill can be turned on or off.  The default
	;;^DIC(352.3,"%D",5,0)
	;;=billing action is TO BILL ALL stop codes; thus, it is only
	;;^DIC(352.3,"%D",6,0)
	;;=necessary to add entries to this file if billing of a particular
	;;^DIC(352.3,"%D",7,0)
	;;=clinic stop code is not desired.
	;;^DIC(352.3,"%D",8,0)
	;;= 
	;;^DIC(352.3,"%D",9,0)
	;;=The routine IBEFUNC contains the function call to determine if a
	;;^DIC(352.3,"%D",10,0)
	;;=clinic stop code should not be billed on a specific date.
	;;^DIC(352.3,"%D",11,0)
	;;= 
	;;^DIC(352.3,"%D",12,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(352.3,0)
	;;=FIELD^^.03^3
	;;^DD(352.3,0,"DDA")
	;;=N
	;;^DD(352.3,0,"DT")
	;;=2930720
	;;^DD(352.3,0,"IX","AIVDT",352.3,.01)
	;;=
	;;^DD(352.3,0,"IX","AIVDT1",352.3,.02)
	;;=
	;;^DD(352.3,0,"IX","B",352.3,.01)
	;;=
	;;^DD(352.3,0,"NM","NON-BILLABLE CLINIC STOP CODES")
	;;=
	;;^DD(352.3,.01,0)
	;;=CLINIC STOP CODE^RP40.7'^DIC(40.7,^0;1^Q
	;;^DD(352.3,.01,1,0)
	;;=^.1
	;;^DD(352.3,.01,1,1,0)
	;;=352.3^B
	;;^DD(352.3,.01,1,1,1)
	;;=S ^IBE(352.3,"B",$E(X,1,30),DA)=""
	;;^DD(352.3,.01,1,1,2)
	;;=K ^IBE(352.3,"B",$E(X,1,30),DA)
	;;^DD(352.3,.01,1,2,0)
	;;=352.3^AIVDT^MUMPS
	;;^DD(352.3,.01,1,2,1)
	;;=I $D(^IBE(352.3,DA,0)),$P(^(0),"^",2) S ^IBE(352.3,"AIVDT",X,-$P(^(0),"^",2),DA)=""
	;;^DD(352.3,.01,1,2,2)
	;;=I $D(^IBE(352.3,DA,0)),$P(^(0),"^",2) K ^IBE(352.3,"AIVDT",X,-$P(^(0),"^",2),DA)
	;;^DD(352.3,.01,1,2,"%D",0)
	;;=^^3^3^2930720^
	;;^DD(352.3,.01,1,2,"%D",1,0)
	;;=This cross-reference on the CLINIC STOP CODE (#.01) field and the
	;;^DD(352.3,.01,1,2,"%D",2,0)
	;;=EFFECTIVE DATE (#.02) field is used to locate the appropriate record
	;;^DD(352.3,.01,1,2,"%D",3,0)
	;;=for a clinic stop code on a specific effective date.
	;;^DD(352.3,.01,1,2,"DT")
	;;=2930720
	;;^DD(352.3,.01,3)
	;;=Please enter a clinic stop code.
	;;^DD(352.3,.01,21,0)
	;;=^^3^3^2930720^
	;;^DD(352.3,.01,21,1,0)
	;;=This field is a pointer to the CLINIC STOP (#40.7) file and identifies
	;;^DD(352.3,.01,21,2,0)
	;;=the clinic stop code which is being established as either billable
	;;^DD(352.3,.01,21,3,0)
	;;=or non-billable for Means Test billing.
	;;^DD(352.3,.01,"DT")
	;;=2930720
	;;^DD(352.3,.02,0)
	;;=EFFECTIVE DATE^RD^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(352.3,.02,1,0)
	;;=^.1
	;;^DD(352.3,.02,1,1,0)
	;;=352.3^AIVDT1^MUMPS
	;;^DD(352.3,.02,1,1,1)
	;;=I $D(^IBE(352.3,DA,0)),+^(0) S ^IBE(352.3,"AIVDT",+^(0),-X,DA)=""
	;;^DD(352.3,.02,1,1,2)
	;;=I $D(^IBE(352.3,DA,0)),+^(0) K ^IBE(352.3,"AIVDT",+^(0),-X,DA)
	;;^DD(352.3,.02,1,1,"%D",0)
	;;=^^3^3^2930720^
	;;^DD(352.3,.02,1,1,"%D",1,0)
	;;=This cross-reference on the CLINIC STOP CODE (#.01) field and the
	;;^DD(352.3,.02,1,1,"%D",2,0)
	;;=EFFECTIVE DATE (#.02) field is used to locate the appropriate record
	;;^DD(352.3,.02,1,1,"%D",3,0)
	;;=for a clinic stop code on a specific effective date.
	;;^DD(352.3,.02,1,1,"DT")
	;;=2930720
	;;^DD(352.3,.02,3)
	;;=Please enter an effective date.
	;;^DD(352.3,.02,21,0)
	;;=^^2^2^2930720^
	;;^DD(352.3,.02,21,1,0)
	;;=This is the date on which Means Test billing for this clinic stop
