IBINI039	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(352.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(352.2,0,"GL")
	;;=^IBE(352.2,
	;;^DIC("B","NON-BILLABLE DISPOSITIONS",352.2)
	;;=
	;;^DIC(352.2,"%D",0)
	;;=^^11^11^2940214^^^^
	;;^DIC(352.2,"%D",1,0)
	;;=This file shall be used to flag dispositions in the DISPOSITION (#37)
	;;^DIC(352.2,"%D",2,0)
	;;=file as either billable or non-billable for Means Test Billing.  The
	;;^DIC(352.2,"%D",3,0)
	;;=flagging of dispositions is date-sensitive, so the ability to not
	;;^DIC(352.2,"%D",4,0)
	;;=bill can be turned on or off.  The default billing action is TO BILL
	;;^DIC(352.2,"%D",5,0)
	;;=ALL dispositions; thus, it is only necessary to add entries to this
	;;^DIC(352.2,"%D",6,0)
	;;=file if billing of a particular disposition is not desired.
	;;^DIC(352.2,"%D",7,0)
	;;= 
	;;^DIC(352.2,"%D",8,0)
	;;=The routine IBEFUNC contains the function call to determine if a
	;;^DIC(352.2,"%D",9,0)
	;;=disposition should not be billed on a specific date.
	;;^DIC(352.2,"%D",10,0)
	;;= 
	;;^DIC(352.2,"%D",11,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(352.2,0)
	;;=FIELD^^.03^3
	;;^DD(352.2,0,"DDA")
	;;=N
	;;^DD(352.2,0,"DT")
	;;=2930720
	;;^DD(352.2,0,"IX","AIVDT",352.2,.01)
	;;=
	;;^DD(352.2,0,"IX","AIVDT1",352.2,.02)
	;;=
	;;^DD(352.2,0,"IX","B",352.2,.01)
	;;=
	;;^DD(352.2,0,"NM","NON-BILLABLE DISPOSITIONS")
	;;=
	;;^DD(352.2,.01,0)
	;;=DISPOSITION^RP37'^DIC(37,^0;1^Q
	;;^DD(352.2,.01,1,0)
	;;=^.1
	;;^DD(352.2,.01,1,1,0)
	;;=352.2^B
	;;^DD(352.2,.01,1,1,1)
	;;=S ^IBE(352.2,"B",$E(X,1,30),DA)=""
	;;^DD(352.2,.01,1,1,2)
	;;=K ^IBE(352.2,"B",$E(X,1,30),DA)
	;;^DD(352.2,.01,1,2,0)
	;;=352.2^AIVDT^MUMPS
	;;^DD(352.2,.01,1,2,1)
	;;=I $D(^IBE(352.2,DA,0)),$P(^(0),"^",2) S ^IBE(352.2,"AIVDT",X,-$P(^(0),"^",2),DA)=""
	;;^DD(352.2,.01,1,2,2)
	;;=I $D(^IBE(352.2,DA,0)),$P(^(0),"^",2) K ^IBE(352.2,"AIVDT",X,-$P(^(0),"^",2),DA)
	;;^DD(352.2,.01,1,2,"%D",0)
	;;=^^3^3^2930720^^
	;;^DD(352.2,.01,1,2,"%D",1,0)
	;;=This cross-reference on the DISPOSITION (#.01) field and the EFFECTIVE
	;;^DD(352.2,.01,1,2,"%D",2,0)
	;;=DATE (#.02) field is used to locate the appropriate record for a
	;;^DD(352.2,.01,1,2,"%D",3,0)
	;;=disposition on a specific effective date.
	;;^DD(352.2,.01,1,2,"DT")
	;;=2930720
	;;^DD(352.2,.01,3)
	;;=Please enter a disposition.
	;;^DD(352.2,.01,21,0)
	;;=^^3^3^2930805^^
	;;^DD(352.2,.01,21,1,0)
	;;=This field is a pointer to the DISPOSITION (#37) file, and identifies
	;;^DD(352.2,.01,21,2,0)
	;;=the disposition which is being established as either billable or
	;;^DD(352.2,.01,21,3,0)
	;;=non-billable for Means Test billing.
	;;^DD(352.2,.01,"DT")
	;;=2930720
	;;^DD(352.2,.02,0)
	;;=EFFECTIVE DATE^RD^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(352.2,.02,1,0)
	;;=^.1
	;;^DD(352.2,.02,1,1,0)
	;;=352.2^AIVDT1^MUMPS
	;;^DD(352.2,.02,1,1,1)
	;;=I $D(^IBE(352.2,DA,0)),+^(0) S ^IBE(352.2,"AIVDT",+^(0),-X,DA)=""
	;;^DD(352.2,.02,1,1,2)
	;;=I $D(^IBE(352.2,DA,0)),+^(0) K ^IBE(352.2,"AIVDT",+^(0),-X,DA)
	;;^DD(352.2,.02,1,1,"%D",0)
	;;=^^3^3^2930720^
	;;^DD(352.2,.02,1,1,"%D",1,0)
	;;=This cross-reference on the DISPOSITION (#.01) field and the EFFECTIVE
	;;^DD(352.2,.02,1,1,"%D",2,0)
	;;=DATE (#.02) field is used to locate the appropriate record for a
	;;^DD(352.2,.02,1,1,"%D",3,0)
	;;=disposition on a specific effective date.
	;;^DD(352.2,.02,1,1,"DT")
	;;=2930720
	;;^DD(352.2,.02,3)
	;;=Please enter an effective date.
	;;^DD(352.2,.02,21,0)
	;;=^^2^2^2930805^^
	;;^DD(352.2,.02,21,1,0)
	;;=This is the date on which Means Test billing for this disposition
	;;^DD(352.2,.02,21,2,0)
	;;=should be activated or ignored.
