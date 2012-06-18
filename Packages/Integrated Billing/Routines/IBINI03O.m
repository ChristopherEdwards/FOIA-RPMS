IBINI03O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354,.04,21,10,0)
	;;=pension level, he is exempt.
	;;^DD(354,.04,23,0)
	;;=^^6^6^2930429^^^
	;;^DD(354,.04,23,1,0)
	;;= 
	;;^DD(354,.04,23,2,0)
	;;=This field will be updated by the Copay Exemption software every time
	;;^DD(354,.04,23,3,0)
	;;=a new current exemption is added.  It should not be edited.
	;;^DD(354,.04,23,4,0)
	;;= 
	;;^DD(354,.04,23,5,0)
	;;=Programmers must 4 slash stuff data into this field to bypass the input
	;;^DD(354,.04,23,6,0)
	;;=transform.
	;;^DD(354,.04,"DT")
	;;=2930210
	;;^DD(354,.05,0)
	;;=COPAY EXEMPTION REASON^R*P354.2'^IBE(354.2,^0;5^S DIC("S")="I Y=$P(^IBA(354,DA,0),U,5)!($G(IBJOB)>10)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(354,.05,1,0)
	;;=^.1
	;;^DD(354,.05,1,1,0)
	;;=354^AC
	;;^DD(354,.05,1,1,1)
	;;=S ^IBA(354,"AC",$E(X,1,30),DA)=""
	;;^DD(354,.05,1,1,2)
	;;=K ^IBA(354,"AC",$E(X,1,30),DA)
	;;^DD(354,.05,1,1,"DT")
	;;=2930120
	;;^DD(354,.05,9)
	;;=^
	;;^DD(354,.05,12)
	;;=This field can only be edited/updated by the Copay Exemption software.
	;;^DD(354,.05,12.1)
	;;=S DIC("S")="I Y=$P(^IBA(354,DA,0),U,5)!($G(IBJOB)>10)"
	;;^DD(354,.05,21,0)
	;;=^^4^4^2930429^^^^
	;;^DD(354,.05,21,1,0)
	;;=DO NOT EDIT THIS FIELD.  It is maintained by the Copay Exemption Software.
	;;^DD(354,.05,21,2,0)
	;;= 
	;;^DD(354,.05,21,3,0)
	;;=This is the exemption reason for the current copay exemption.  It will
	;;^DD(354,.05,21,4,0)
	;;=be entered by the system.  
	;;^DD(354,.05,23,0)
	;;=^^6^6^2930429^^^
	;;^DD(354,.05,23,1,0)
	;;= 
	;;^DD(354,.05,23,2,0)
	;;=This field will be updated by the Copay Exemption software every time
	;;^DD(354,.05,23,3,0)
	;;=a new current exemption is added.  It should not be edited.
	;;^DD(354,.05,23,4,0)
	;;= 
	;;^DD(354,.05,23,5,0)
	;;=Programmers must 4 slash stuff data into this field to bypass the input
	;;^DD(354,.05,23,6,0)
	;;=transform.
	;;^DD(354,.05,"DT")
	;;=2930210
