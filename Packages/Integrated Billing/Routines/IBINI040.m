IBINI040	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(354.3,0,"GL")
	;;=^IBE(354.3,
	;;^DIC("B","BILLING THRESHOLDS",354.3)
	;;=
	;;^DIC(354.3,"%D",0)
	;;=^^15^15^2940214^^^^
	;;^DIC(354.3,"%D",1,0)
	;;=This file contains the threshold amounts for the Medication Copayment
	;;^DIC(354.3,"%D",2,0)
	;;=Income Exemption.  It may contain other types of thresholds in the 
	;;^DIC(354.3,"%D",3,0)
	;;=future.  The Medication Copayment Income Exemption legislation
	;;^DIC(354.3,"%D",4,0)
	;;=was effective on 30-Oct-92.  The thresholds are normally effective
	;;^DIC(354.3,"%D",5,0)
	;;=on December 1.  To simplify implementation VACO has determined that
	;;^DIC(354.3,"%D",6,0)
	;;=the threshold effective 1-Dec-92 would be used for the period from 30-Oct-92
	;;^DIC(354.3,"%D",7,0)
	;;=to 1-Dec-92.
	;;^DIC(354.3,"%D",8,0)
	;;= 
	;;^DIC(354.3,"%D",9,0)
	;;=The Medication Copayment Income Exemption is based on veterans making
	;;^DIC(354.3,"%D",10,0)
	;;=less than the VBA rate for pension plus Aid and Attendence.  
	;;^DIC(354.3,"%D",11,0)
	;;= 
	;;^DIC(354.3,"%D",12,0)
	;;= 
	;;^DIC(354.3,"%D",13,0)
	;;= 
	;;^DIC(354.3,"%D",14,0)
	;;= 
	;;^DIC(354.3,"%D",15,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(354.3,0)
	;;=FIELD^^.12^12
	;;^DD(354.3,0,"DDA")
	;;=N
	;;^DD(354.3,0,"DT")
	;;=2930405
	;;^DD(354.3,0,"ID",.02)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(354.3,.02,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,2)_"":"",2),$C(59),1)")
	;;^DD(354.3,0,"ID",.03)
	;;=W "   ",$P(^(0),U,3)
	;;^DD(354.3,0,"ID",.04)
	;;=W ""
	;;^DD(354.3,0,"ID",.12)
	;;=W ""
	;;^DD(354.3,0,"IX","AC",354.3,.02)
	;;=
	;;^DD(354.3,0,"IX","AIVDT",354.3,.01)
	;;=
	;;^DD(354.3,0,"IX","AIVDT1",354.3,.02)
	;;=
	;;^DD(354.3,0,"IX","B",354.3,.01)
	;;=
	;;^DD(354.3,0,"NM","BILLING THRESHOLDS")
	;;=
	;;^DD(354.3,.01,0)
	;;=DATE^RD^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(354.3,.01,1,0)
	;;=^.1
	;;^DD(354.3,.01,1,1,0)
	;;=354.3^B
	;;^DD(354.3,.01,1,1,1)
	;;=S ^IBE(354.3,"B",$E(X,1,30),DA)=""
	;;^DD(354.3,.01,1,1,2)
	;;=K ^IBE(354.3,"B",$E(X,1,30),DA)
	;;^DD(354.3,.01,1,2,0)
	;;=354.3^AIVDT^MUMPS
	;;^DD(354.3,.01,1,2,1)
	;;=I $P(^IBE(354.3,DA,0),"^",2) S ^IBE(354.3,"AIVDT",$P(^(0),"^",2),-X,DA)=""
	;;^DD(354.3,.01,1,2,2)
	;;=K ^IBE(354.3,"AIVDT",+$P(^IBE(354.3,DA,0),"^",2),-X,DA)
	;;^DD(354.3,.01,1,2,"%D",0)
	;;=^^2^2^2921211^
	;;^DD(354.3,.01,1,2,"%D",1,0)
	;;=Inverse date cross reference to rapidly retrieve the proper threshold
	;;^DD(354.3,.01,1,2,"%D",2,0)
	;;=prior to date x.
	;;^DD(354.3,.01,1,2,"DT")
	;;=2921211
	;;^DD(354.3,.01,3)
	;;=
	;;^DD(354.3,.01,21,0)
	;;=^^1^1^2921209^^^
	;;^DD(354.3,.01,21,1,0)
	;;=This is the effective date of this threshold.
	;;^DD(354.3,.01,"DT")
	;;=2921211
	;;^DD(354.3,.02,0)
	;;=TYPE^S^2:PENSION PLUS A&A;^0;2^Q
	;;^DD(354.3,.02,1,0)
	;;=^.1
	;;^DD(354.3,.02,1,1,0)
	;;=354.3^AC
	;;^DD(354.3,.02,1,1,1)
	;;=S ^IBE(354.3,"AC",$E(X,1,30),DA)=""
	;;^DD(354.3,.02,1,1,2)
	;;=K ^IBE(354.3,"AC",$E(X,1,30),DA)
	;;^DD(354.3,.02,1,1,"DT")
	;;=2930319
	;;^DD(354.3,.02,1,2,0)
	;;=354.3^AIVDT1^MUMPS
	;;^DD(354.3,.02,1,2,1)
	;;=I +^IBE(354.3,DA,0) S ^IBE(354.3,"AIVDT",X,-$P(^(0),"^"),DA)=""
	;;^DD(354.3,.02,1,2,2)
	;;=K ^IBE(354.3,"AIVDT",X,-$P(^IBE(354.3,DA,0),"^"),DA)
	;;^DD(354.3,.02,1,2,3)
	;;=DON'T DELETE
	;;^DD(354.3,.02,1,2,"%D",0)
	;;=^^2^2^2921211^
	;;^DD(354.3,.02,1,2,"%D",1,0)
	;;=Inverse date cross reference used to quickly retrieve threshold immediately
	;;^DD(354.3,.02,1,2,"%D",2,0)
	;;=prior to date x.
	;;^DD(354.3,.02,1,2,"DT")
	;;=2921211
	;;^DD(354.3,.02,21,0)
	;;=^^4^4^2930317^^^^
	;;^DD(354.3,.02,21,1,0)
	;;=This is the type of Threshold that this entry is for.  
