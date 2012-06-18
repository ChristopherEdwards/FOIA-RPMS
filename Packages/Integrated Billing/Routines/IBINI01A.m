IBINI01A	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,.17,1,1,"%D",1,0)
	;;=Cross-reference of all IB ACTION entries which represent inpatient/NHCU
	;;^DD(350,.17,1,1,"%D",2,0)
	;;=admissions by the patient (#.02) field and the minus (negative or inverse)
	;;^DD(350,.17,1,1,"%D",3,0)
	;;=event date field.  A billable event may be located for a patient using
	;;^DD(350,.17,1,1,"%D",4,0)
	;;=this cross-reference.  The "AFDT" cross-reference on the patient (#.02)
	;;^DD(350,.17,1,1,"%D",5,0)
	;;=field is the companion to this cross-reference.
	;;^DD(350,.17,1,1,"DT")
	;;=2911101
	;;^DD(350,.17,21,0)
	;;=^^6^6^2911104^^^^
	;;^DD(350,.17,21,1,0)
	;;=This field will only be used for those IB ACTION entries which represent
	;;^DD(350,.17,21,2,0)
	;;=Hospital/NHCU admissions and outpatient visits for which Category C
	;;^DD(350,.17,21,3,0)
	;;=copayment and per diem charges will be billed to the patient.  The
	;;^DD(350,.17,21,4,0)
	;;=value of this field will be the admission or visit date.  The inverse
	;;^DD(350,.17,21,5,0)
	;;=(negative) value of this date will be cross-referenced by patient for
	;;^DD(350,.17,21,6,0)
	;;=look-up purposes.
	;;^DD(350,.17,"DT")
	;;=2911101
	;;^DD(350,.18,0)
	;;=DATE LAST BILLED^D^^0;18^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350,.18,21,0)
	;;=^^4^4^2911101^
	;;^DD(350,.18,21,1,0)
	;;=This field will only be used for those IB ACTION entries which represent
	;;^DD(350,.18,21,2,0)
	;;=inpatient or NHCU admissions for which Category C copayment and per diem
	;;^DD(350,.18,21,3,0)
	;;=charges will be billed to the patient.  The value of this field will be
	;;^DD(350,.18,21,4,0)
	;;=the last day through which charges have been calculated for the admission.
	;;^DD(350,.18,"DT")
	;;=2911101
	;;^DD(350,11,0)
	;;=USER ADDING ENTRY^P200'I^VA(200,^1;1^Q
	;;^DD(350,11,21,0)
	;;=^^2^2^2911008^^^^
	;;^DD(350,11,21,1,0)
	;;=This is the person adding an entry in an application that cause the
	;;^DD(350,11,21,2,0)
	;;=application to create an entry in this file.
	;;^DD(350,11,"DT")
	;;=2910304
	;;^DD(350,12,0)
	;;=DATE ENTRY ADDED^DI^^1;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350,12,1,0)
	;;=^.1^^-1
	;;^DD(350,12,1,1,0)
	;;=350^D
	;;^DD(350,12,1,1,1)
	;;=S ^IB("D",$E(X,1,30),DA)=""
	;;^DD(350,12,1,1,2)
	;;=K ^IB("D",$E(X,1,30),DA)
	;;^DD(350,12,1,2,0)
	;;=350^APDT1^MUMPS
	;;^DD(350,12,1,2,1)
	;;=I $P(^IB(DA,0),"^",9) S ^IB("APDT",$P(^(0),"^",9),-X,DA)=""
	;;^DD(350,12,1,2,2)
	;;=I $P(^IB(DA,0),"^",9) K ^IB("APDT",$P(^(0),"^",9),-X,DA)
	;;^DD(350,12,1,2,"%D",0)
	;;=^^5^5^2910417^
	;;^DD(350,12,1,2,"%D",1,0)
	;;=Cross-reference of all IB ACTION entries by parent link (#.09) field and
	;;^DD(350,12,1,2,"%D",2,0)
	;;=the minus (negative or inverse) date entry added (#12) field.  The most
	;;^DD(350,12,1,2,"%D",3,0)
	;;=current ACTION for the original entry can be found using this cross
	;;^DD(350,12,1,2,"%D",4,0)
	;;=reference.  The "APDT" cross-reference on the parent link (#.09) is the 
	;;^DD(350,12,1,2,"%D",5,0)
	;;=companion to this cross-reference.
	;;^DD(350,12,1,3,0)
	;;=350^APTDT1^MUMPS
	;;^DD(350,12,1,3,1)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",2) S ^IB("APTDT",$P(^(0),"^",2),X,DA)=""
	;;^DD(350,12,1,3,2)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",2) K ^IB("APTDT",$P(^(0),"^",2),X,DA)
	;;^DD(350,12,1,3,"%D",0)
	;;=^^3^3^2910417^
	;;^DD(350,12,1,3,"%D",1,0)
	;;=Cross-reference of all IB ACTION entries by patient (#.02) and the date entry added (#12)
	;;^DD(350,12,1,3,"%D",2,0)
	;;=field.  The "APTDT" cross-reference on the patient (#.02) field is the
	;;^DD(350,12,1,3,"%D",3,0)
	;;=companion to this cross-reference.
