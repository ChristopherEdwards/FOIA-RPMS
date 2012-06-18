IBINI03D	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(352.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(352.4,0,"GL")
	;;=^IBE(352.4,
	;;^DIC("B","NON-BILLABLE CLINICS",352.4)
	;;=
	;;^DIC(352.4,"%D",0)
	;;=^^11^11^2940214^^^
	;;^DIC(352.4,"%D",1,0)
	;;=This file shall be used to flag clinics in the HOSPITAL LOCATION (#44)
	;;^DIC(352.4,"%D",2,0)
	;;=file as either billable or non-billable for Means Test Billing.  The
	;;^DIC(352.4,"%D",3,0)
	;;=flagging of clinics is date-sensitive, so the ability to not bill
	;;^DIC(352.4,"%D",4,0)
	;;=may be turned on or off.  Please note that the default billing action
	;;^DIC(352.4,"%D",5,0)
	;;=IS TO BILL all clinics; thus, it is only necessary to add entries in
	;;^DIC(352.4,"%D",6,0)
	;;=this file for clinics where Means Test billing is NOT desired.
	;;^DIC(352.4,"%D",7,0)
	;;= 
	;;^DIC(352.4,"%D",8,0)
	;;=The routine IBEFUNC contains the function call to determine if a
	;;^DIC(352.4,"%D",9,0)
	;;=clinic should be not billed on a specific date.
	;;^DIC(352.4,"%D",10,0)
	;;= 
	;;^DIC(352.4,"%D",11,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(352.4,0)
	;;=FIELD^^.03^3
	;;^DD(352.4,0,"DDA")
	;;=N
	;;^DD(352.4,0,"DT")
	;;=2930720
	;;^DD(352.4,0,"IX","AIVDT",352.4,.01)
	;;=
	;;^DD(352.4,0,"IX","AIVDT1",352.4,.02)
	;;=
	;;^DD(352.4,0,"IX","B",352.4,.01)
	;;=
	;;^DD(352.4,0,"NM","NON-BILLABLE CLINICS")
	;;=
	;;^DD(352.4,.01,0)
	;;=CLINIC^R*P44'^SC(^0;1^S DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(352.4,.01,1,0)
	;;=^.1
	;;^DD(352.4,.01,1,1,0)
	;;=352.4^B
	;;^DD(352.4,.01,1,1,1)
	;;=S ^IBE(352.4,"B",$E(X,1,30),DA)=""
	;;^DD(352.4,.01,1,1,2)
	;;=K ^IBE(352.4,"B",$E(X,1,30),DA)
	;;^DD(352.4,.01,1,2,0)
	;;=352.4^AIVDT^MUMPS
	;;^DD(352.4,.01,1,2,1)
	;;=I $D(^IBE(352.4,DA,0)),$P(^(0),"^",2) S ^IBE(352.4,"AIVDT",X,-$P(^(0),"^",2),DA)=""
	;;^DD(352.4,.01,1,2,2)
	;;=I $D(^IBE(352.4,DA,0)),$P(^(0),"^",2) K ^IBE(352.4,"AIVDT",X,-$P(^(0),"^",2),DA)
	;;^DD(352.4,.01,1,2,"%D",0)
	;;=^^3^3^2930720^
	;;^DD(352.4,.01,1,2,"%D",1,0)
	;;=This cross-reference on the CLINIC (#.01) field and the EFFECTIVE DATE
	;;^DD(352.4,.01,1,2,"%D",2,0)
	;;=(#.02) field is used to locate the appropriate record for a clinic on
	;;^DD(352.4,.01,1,2,"%D",3,0)
	;;=a specific effective date.
	;;^DD(352.4,.01,1,2,"DT")
	;;=2930720
	;;^DD(352.4,.01,3)
	;;=Please enter a clinic.
	;;^DD(352.4,.01,12)
	;;=This screen is used to assure that only clinics in file #44 are selected.
	;;^DD(352.4,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)=""C"""
	;;^DD(352.4,.01,21,0)
	;;=^^3^3^2930720^
	;;^DD(352.4,.01,21,1,0)
	;;=This field is a pointer to the HOSPITAL LOCATION (#44) file and
	;;^DD(352.4,.01,21,2,0)
	;;=identifies the clinic which is being flagged as billable or
	;;^DD(352.4,.01,21,3,0)
	;;=non-billable for Means Test billing.
	;;^DD(352.4,.01,"DT")
	;;=2930720
	;;^DD(352.4,.02,0)
	;;=EFFECTIVE DATE^RD^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(352.4,.02,1,0)
	;;=^.1
	;;^DD(352.4,.02,1,1,0)
	;;=352.4^AIVDT1^MUMPS
	;;^DD(352.4,.02,1,1,1)
	;;=I $D(^IBE(352.4,DA,0)),+^(0) S ^IBE(352.4,"AIVDT",+^(0),-X,DA)=""
	;;^DD(352.4,.02,1,1,2)
	;;=I $D(^IBE(352.4,DA,0)),+^(0) K ^IBE(352.4,"AIVDT",+^(0),-X,DA)
	;;^DD(352.4,.02,1,1,"%D",0)
	;;=^^3^3^2930720^
	;;^DD(352.4,.02,1,1,"%D",1,0)
	;;=This cross-reference on the CLINIC (#.01) field and the EFFECTIVE DATE
	;;^DD(352.4,.02,1,1,"%D",2,0)
	;;=(#.02) field is used to locate the appropriate record for a clinic on
	;;^DD(352.4,.02,1,1,"%D",3,0)
	;;=a specific effective date.
	;;^DD(352.4,.02,1,1,"DT")
	;;=2930720
	;;^DD(352.4,.02,3)
	;;=Please enter the effective date.
	;;^DD(352.4,.02,21,0)
	;;=^^2^2^2930720^
