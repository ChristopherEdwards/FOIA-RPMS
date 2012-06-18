IBINI02Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(351,.02,1,1,"%D",4,0)
	;;=reference.  The "AIVDT1" cross-reference on the cycle date (#.03) field
	;;^DD(351,.02,1,1,"%D",5,0)
	;;=is the companion to this cross-reference.
	;;^DD(351,.02,1,1,"DT")
	;;=2911009
	;;^DD(351,.02,1,2,0)
	;;=351^ACT^MUMPS
	;;^DD(351,.02,1,2,1)
	;;=I $D(^IBE(351,DA,0)),$P(^(0),"^",4)=1 S ^IBE(351,"ACT",X,DA)=""
	;;^DD(351,.02,1,2,2)
	;;=K ^IBE(351,"ACT",X,DA)
	;;^DD(351,.02,1,2,"%D",0)
	;;=^^7^7^2911106^
	;;^DD(351,.02,1,2,"%D",1,0)
	;;=Cross-reference of all active IB BILLING CYCLES by patient.
	;;^DD(351,.02,1,2,"%D",2,0)
	;;= 
	;;^DD(351,.02,1,2,"%D",3,0)
	;;=This is a temporary cross-reference which is used to find a patient's
	;;^DD(351,.02,1,2,"%D",4,0)
	;;=active billing cycle record, if one exists.  The cross-reference is
	;;^DD(351,.02,1,2,"%D",5,0)
	;;=set whenever the status (#.04 field) of a billing cycle is changed to 1
	;;^DD(351,.02,1,2,"%D",6,0)
	;;=(CURRENT), and killed without condition.  The "ACT1" cross-reference on
	;;^DD(351,.02,1,2,"%D",7,0)
	;;=the status field is the companion to this cross-reference.
	;;^DD(351,.02,1,2,"DT")
	;;=2911106
	;;^DD(351,.02,1,3,0)
	;;=351^C
	;;^DD(351,.02,1,3,1)
	;;=S ^IBE(351,"C",$E(X,1,30),DA)=""
	;;^DD(351,.02,1,3,2)
	;;=K ^IBE(351,"C",$E(X,1,30),DA)
	;;^DD(351,.02,1,3,"DT")
	;;=2911226
	;;^DD(351,.02,3)
	;;=Please enter the patient for whom this billing clock is being opened.
	;;^DD(351,.02,21,0)
	;;=^^1^1^2911226^^
	;;^DD(351,.02,21,1,0)
	;;=This is the patient for whom the billing clock is being opened.
	;;^DD(351,.02,"DT")
	;;=2911226
	;;^DD(351,.03,0)
	;;=CLOCK BEGIN DATE^RD^^0;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(351,.03,1,0)
	;;=^.1
	;;^DD(351,.03,1,1,0)
	;;=351^AIVDT1^MUMPS
	;;^DD(351,.03,1,1,1)
	;;=I $D(^IBE(351,DA,0)),$P(^(0),"^",2) S ^IBE(351,"AIVDT",$P(^(0),"^",2),-X,DA)=""
	;;^DD(351,.03,1,1,2)
	;;=I $D(^IBE(351,DA,0)),$P(^(0),"^",2) K ^IBE(351,"AIVDT",$P(^(0),"^",2),-X,DA)
	;;^DD(351,.03,1,1,"%D",0)
	;;=^^5^5^2911105^^^^
	;;^DD(351,.03,1,1,"%D",1,0)
	;;=Cross-reference of all IB MT BILLING CYCLE entries by the patient (#.02)
	;;^DD(351,.03,1,1,"%D",2,0)
	;;=field and the minus (negative or inverse) cycle date (#.03) field.  The
	;;^DD(351,.03,1,1,"%D",3,0)
	;;=most current billing cycle for a patient may be found using this cross-
	;;^DD(351,.03,1,1,"%D",4,0)
	;;=reference.  The "AIVDT" cross-reference on the patient (#.02) field is
	;;^DD(351,.03,1,1,"%D",5,0)
	;;=is the companion to this cross-reference.
	;;^DD(351,.03,1,1,"DT")
	;;=2911009
	;;^DD(351,.03,3)
	;;=Please enter the date on which the billing clock should begin.
	;;^DD(351,.03,21,0)
	;;=^^1^1^2920211^^^^
	;;^DD(351,.03,21,1,0)
	;;=This is the date on which the billing clock has been opened.
	;;^DD(351,.03,"DT")
	;;=2911230
	;;^DD(351,.04,0)
	;;=STATUS^S^1:CURRENT;2:CLOSED;3:CANCELLED;^0;4^Q
	;;^DD(351,.04,1,0)
	;;=^.1
	;;^DD(351,.04,1,1,0)
	;;=351^ACT1^MUMPS
	;;^DD(351,.04,1,1,1)
	;;=I X=1,$D(^IBE(351,DA,0)),$P(^(0),"^",2) S ^IBE(351,"ACT",$P(^(0),"^",2),DA)=""
	;;^DD(351,.04,1,1,2)
	;;=I $D(^IBE(351,DA,0)),$P(^(0),"^",2) K ^IBE(351,"ACT",$P(^(0),"^",2),DA)
	;;^DD(351,.04,1,1,"%D",0)
	;;=^^7^7^2911106^
	;;^DD(351,.04,1,1,"%D",1,0)
	;;=Cross-reference of all active IB BILLING CYCLES by patient (#.02 field).
	;;^DD(351,.04,1,1,"%D",2,0)
	;;= 
	;;^DD(351,.04,1,1,"%D",3,0)
	;;=This is a temporary cross-reference which is used to find a patient's
	;;^DD(351,.04,1,1,"%D",4,0)
	;;=active billing cycle record, if one exists.  The cross-reference is set
	;;^DD(351,.04,1,1,"%D",5,0)
	;;=whenever the status of a billing cycle is changed to 1 (CURRENT), and
