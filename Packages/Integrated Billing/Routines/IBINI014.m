IBINI014	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,.01,21,0)
	;;=^^5^5^2940209^^^
	;;^DD(350,.01,21,1,0)
	;;=This is the station number concatenated with the internal number of 
	;;^DD(350,.01,21,2,0)
	;;=this entry in this file.  The purpose of this number is to provide
	;;^DD(350,.01,21,3,0)
	;;=a unique number for each entry for each station.  Modifying this
	;;^DD(350,.01,21,4,0)
	;;=number may have serious consequences when and where centralized
	;;^DD(350,.01,21,5,0)
	;;=billing and accounting are taking place.
	;;^DD(350,.01,"DEL",1,0)
	;;=I 1 W !,"Deleting entries not allowed"
	;;^DD(350,.01,"DT")
	;;=2910304
	;;^DD(350,.02,0)
	;;=PATIENT^P2'I^DPT(^0;2^Q
	;;^DD(350,.02,1,0)
	;;=^.1
	;;^DD(350,.02,1,1,0)
	;;=350^C
	;;^DD(350,.02,1,1,1)
	;;=S ^IB("C",$E(X,1,30),DA)=""
	;;^DD(350,.02,1,1,2)
	;;=K ^IB("C",$E(X,1,30),DA)
	;;^DD(350,.02,1,2,0)
	;;=350^AFDT^MUMPS
	;;^DD(350,.02,1,2,1)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",17) S ^IB("AFDT",X,-$P(^(0),"^",17),DA)=""
	;;^DD(350,.02,1,2,2)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",17) K ^IB("AFDT",X,-$P(^(0),"^",17),DA)
	;;^DD(350,.02,1,2,"%D",0)
	;;=^^5^5^2911101^
	;;^DD(350,.02,1,2,"%D",1,0)
	;;=Cross-reference of all IB ACTION entries which represent inpatient/NHCU
	;;^DD(350,.02,1,2,"%D",2,0)
	;;=admissions by the patient field and the minus (negative or inverse) event
	;;^DD(350,.02,1,2,"%D",3,0)
	;;=date (#.17) field.  A billable event may be located for a patient using
	;;^DD(350,.02,1,2,"%D",4,0)
	;;=this cross-reference.  The "AFDT1" cross-reference on the event date (#.17)
	;;^DD(350,.02,1,2,"%D",5,0)
	;;=field is the companion to this cross-reference.
	;;^DD(350,.02,1,2,"DT")
	;;=2911101
	;;^DD(350,.02,1,3,0)
	;;=350^APTDT^MUMPS
	;;^DD(350,.02,1,3,1)
	;;=I $D(^IB(DA,1)),$P(^(1),"^",2) S ^IB("APTDT",X,$P(^(1),"^",2),DA)=""
	;;^DD(350,.02,1,3,2)
	;;=I $D(^IB(DA,1)),$P(^(1),"^",2) K ^IB("APTDT",X,$P(^(1),"^",2),DA)
	;;^DD(350,.02,1,3,"%D",0)
	;;=^^3^3^2920226^^^^
	;;^DD(350,.02,1,3,"%D",1,0)
	;;=Cross-reference of all IB ACTION entries by patient (#.02) and date entry added
	;;^DD(350,.02,1,3,"%D",2,0)
	;;=(#12) fields.  The "APTDT1" cross-reference on the date entry added field is
	;;^DD(350,.02,1,3,"%D",3,0)
	;;=the companion to this cross-reference.
	;;^DD(350,.02,1,4,0)
	;;=350^AH1^MUMPS
	;;^DD(350,.02,1,4,1)
	;;=I $D(^IB(DA,0)),$P(^(0),U,5)=8 S ^IB("AH",X,DA)=""
	;;^DD(350,.02,1,4,2)
	;;=I $D(^IB(DA,0)),$P(^(0),U,5)=8 K ^IB("AH",X,DA)
	;;^DD(350,.02,1,4,"%D",0)
	;;=^^1^1^2920302^
	;;^DD(350,.02,1,4,"%D",1,0)
	;;=All mt bills in a hold status
	;;^DD(350,.02,1,4,"DT")
	;;=2920302
	;;^DD(350,.02,1,5,0)
	;;=350^AI1^MUMPS
	;;^DD(350,.02,1,5,1)
	;;=I $D(^IB(DA,0)),$P(^(0),U,5)=99 S ^IB("AI",X,DA)=""
	;;^DD(350,.02,1,5,2)
	;;=I $D(^IB(DA,0)),$P(^(0),U,5)=99 K ^IB("AI",X,DA)
	;;^DD(350,.02,1,5,"%D",0)
	;;=^^1^1^2920430^
	;;^DD(350,.02,1,5,"%D",1,0)
	;;=COMPANION TO AI X-REF ON FIELD .05
	;;^DD(350,.02,1,5,"DT")
	;;=2920430
	;;^DD(350,.02,1,6,0)
	;;=350^ACVA^MUMPS
	;;^DD(350,.02,1,6,1)
	;;=I X,$D(^IB(DA,1)),$P(^(1),"^",5) S ^IB("ACVA",X,$P(^(1),"^",5),DA)=""
	;;^DD(350,.02,1,6,2)
	;;=I X,$D(^IB(DA,1)),$P(^(1),"^",5) K ^IB("ACVA",X,$P(^(1),"^",5),DA)
	;;^DD(350,.02,1,6,"%D",0)
	;;=^^4^4^2930728^^
	;;^DD(350,.02,1,6,"%D",1,0)
	;;=This cross-reference is used in conjunction with the ACVA1 cross
	;;^DD(350,.02,1,6,"%D",2,0)
	;;=reference on the CHAMPVA ADM DATE (#15) field to cross reference
	;;^DD(350,.02,1,6,"%D",3,0)
	;;=all CHAMPVA inpatient subsistence charges by patient and admission
	;;^DD(350,.02,1,6,"%D",4,0)
	;;=date.
	;;^DD(350,.02,1,6,"DT")
	;;=2930728
	;;^DD(350,.02,21,0)
	;;=^^3^3^2910301^
