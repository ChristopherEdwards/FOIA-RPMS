IBINI01B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,12,21,0)
	;;=^^3^3^2921009^^^
	;;^DD(350,12,21,1,0)
	;;=This is the date/time that an entry was added to this file.  The most
	;;^DD(350,12,21,2,0)
	;;=recent update to an entry can be determined by finding the last entry in
	;;^DD(350,12,21,3,0)
	;;=this field.
	;;^DD(350,12,"DT")
	;;=2920430
	;;^DD(350,13,0)
	;;=USER LAST UPDATING^P200'^VA(200,^1;3^Q
	;;^DD(350,13,3)
	;;=
	;;^DD(350,13,5,1,0)
	;;=350^.05^2
	;;^DD(350,13,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350,13,21,1,0)
	;;=This is the person last updating an entry in an application when it
	;;^DD(350,13,21,2,0)
	;;=caused an update to this entry in this file.
	;;^DD(350,13,"DT")
	;;=2910205
	;;^DD(350,14,0)
	;;=DATE LAST UPDATED^D^^1;4^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350,14,5,1,0)
	;;=350^.05^3
	;;^DD(350,14,21,0)
	;;=^^1^1^2910301^
	;;^DD(350,14,21,1,0)
	;;=This is the date/time that this entry was last updated.
	;;^DD(350,14,"DT")
	;;=2910205
	;;^DD(350,15,0)
	;;=CHAMPVA ADM DATE^D^^1;5^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350,15,1,0)
	;;=^.1
	;;^DD(350,15,1,1,0)
	;;=350^ACVA1^MUMPS
	;;^DD(350,15,1,1,1)
	;;=I X,$D(^IB(DA,0)),$P(^(0),"^",2) S ^IB("ACVA",$P(^(0),"^",2),X,DA)=""
	;;^DD(350,15,1,1,2)
	;;=I X,$D(^IB(DA,0)),$P(^(0),"^",2) K ^IB("ACVA",$P(^(0),"^",2),X,DA)
	;;^DD(350,15,1,1,"%D",0)
	;;=^^3^3^2930728^
	;;^DD(350,15,1,1,"%D",1,0)
	;;=This cross-reference is used in conjunction with the ACVA cross
	;;^DD(350,15,1,1,"%D",2,0)
	;;=reference on the PATIENT (#.02) field to cross reference all
	;;^DD(350,15,1,1,"%D",3,0)
	;;=CHAMPVA inpatient subsistence charges by patient and admission date.
	;;^DD(350,15,1,1,"DT")
	;;=2930728
	;;^DD(350,15,21,0)
	;;=^^1^1^2930728^
	;;^DD(350,15,21,1,0)
	;;=This is the admission date for the episode of CHAMPVA care being billed.
	;;^DD(350,15,"DT")
	;;=2930728
