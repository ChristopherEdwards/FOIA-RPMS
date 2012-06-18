IBINI07D	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.94)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.94,0,"GL")
	;;=^IBT(356.94,
	;;^DIC("B","INPATIENT PROVIDERS",356.94)
	;;=
	;;^DIC(356.94,"%D",0)
	;;=^^11^11^2940214^^^^
	;;^DIC(356.94,"%D",1,0)
	;;=This file is to allow the claims tracking module store the admitting
	;;^DIC(356.94,"%D",2,0)
	;;=physician.  In addition, the attending and resident providers can be
	;;^DIC(356.94,"%D",3,0)
	;;=identified in this file.  If attending and resident providers are
	;;^DIC(356.94,"%D",4,0)
	;;=entered then they are assume to be entered completely for an episode
	;;^DIC(356.94,"%D",5,0)
	;;=of care being tracked.  If no provider other than admitting physician
	;;^DIC(356.94,"%D",6,0)
	;;=is entered then the providers and attending from MAS will be considered
	;;^DIC(356.94,"%D",7,0)
	;;=to the the correct providers.  Because QM data may be extracting this
	;;^DIC(356.94,"%D",8,0)
	;;=data on the national roll-up, it is necessary to correctly identify the
	;;^DIC(356.94,"%D",9,0)
	;;=attending physician.
	;;^DIC(356.94,"%D",10,0)
	;;= 
	;;^DIC(356.94,"%D",11,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.94,0)
	;;=FIELD^^.04^4
	;;^DD(356.94,0,"DDA")
	;;=N
	;;^DD(356.94,0,"DT")
	;;=2940202
	;;^DD(356.94,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGPM(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(405,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.94,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^VA(200,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(200,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.94,0,"ID","WRITE")
	;;=N Y S Y=$G(^(0)) W "   ",$P($G(^DPT(+$P($G(^DGPM(+$P(Y,U,2),0)),U,3),0)),U)
	;;^DD(356.94,0,"IX","ADG",356.94,.02)
	;;=
	;;^DD(356.94,0,"IX","ADG1",356.94,.03)
	;;=
	;;^DD(356.94,0,"IX","ADG2",356.94,.04)
	;;=
	;;^DD(356.94,0,"IX","ADGPM",356.94,.02)
	;;=
	;;^DD(356.94,0,"IX","ADGPM1",356.94,.03)
	;;=
	;;^DD(356.94,0,"IX","ATP",356.94,.02)
	;;=
	;;^DD(356.94,0,"IX","ATP1",356.94,.04)
	;;=
	;;^DD(356.94,0,"IX","B",356.94,.01)
	;;=
	;;^DD(356.94,0,"IX","C",356.94,.02)
	;;=
	;;^DD(356.94,0,"IX","D",356.94,.03)
	;;=
	;;^DD(356.94,0,"NM","INPATIENT PROVIDERS")
	;;=
	;;^DD(356.94,.01,0)
	;;=DATE OF CHANGE^RDX^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X K:'$$DTCHK^IBTRE5(DA,$G(X)) X
	;;^DD(356.94,.01,1,0)
	;;=^.1
	;;^DD(356.94,.01,1,1,0)
	;;=356.94^B
	;;^DD(356.94,.01,1,1,1)
	;;=S ^IBT(356.94,"B",$E(X,1,30),DA)=""
	;;^DD(356.94,.01,1,1,2)
	;;=K ^IBT(356.94,"B",$E(X,1,30),DA)
	;;^DD(356.94,.01,3)
	;;=Enter the date the is provider assumes responsibility for the patient.  It can not be before the admission date or after the discharge date or if not discharged, more than 7 days into the future.
	;;^DD(356.94,.01,21,0)
	;;=^^9^9^2940222^^
	;;^DD(356.94,.01,21,1,0)
	;;=This is the first day that this provider is responsible for care for
	;;^DD(356.94,.01,21,2,0)
	;;=the patient.  Enter the date that the provider assumes responsibility.
	;;^DD(356.94,.01,21,3,0)
	;;=For claims tracking purposes the provider will be resonsible for the
	;;^DD(356.94,.01,21,4,0)
	;;=care from this date (inclusive) until another provider assumes
	;;^DD(356.94,.01,21,5,0)
	;;=responsibility for the same level.
	;;^DD(356.94,.01,21,6,0)
	;;= 
	;;^DD(356.94,.01,21,7,0)
	;;=The date must not be before the admission date or after the discharge
	;;^DD(356.94,.01,21,8,0)
	;;=date.  If a current inpatient, it can not be more than 7 days into the
	;;^DD(356.94,.01,21,9,0)
	;;=future.
	;;^DD(356.94,.01,"DT")
	;;=2940222
	;;^DD(356.94,.02,0)
	;;=ADMISSION MOVEMENT^R*P405'^DGPM(^0;2^S DIC("S")="I $P(^(0),U,2)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
