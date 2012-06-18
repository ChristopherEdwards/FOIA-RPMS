IBINI025	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.71)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.71,.05,1,3,"DT")
	;;=2920128
	;;^DD(350.71,.05,1,4,0)
	;;=350.71^AP1^MUMPS
	;;^DD(350.71,.05,1,4,1)
	;;=I $P(^IBE(350.71,DA,0),"^",6) S ^IBE(350.71,"AP",X,$P(^(0),"^",6),DA)=""
	;;^DD(350.71,.05,1,4,2)
	;;=I $P(^IBE(350.71,DA,0),"^",6) K ^IBE(350.71,"AP",X,$P(^(0),"^",6),DA)
	;;^DD(350.71,.05,1,4,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.05,1,4,"%D",0)
	;;=^^1^1^2920128^^^
	;;^DD(350.71,.05,1,4,"%D",1,0)
	;;=Quick cross-reference between procedures and sub-headers.
	;;^DD(350.71,.05,1,4,"DT")
	;;=2911122
	;;^DD(350.71,.05,3)
	;;=Enter the sub-header that this procedure should be printed under on the check-off sheet.
	;;^DD(350.71,.05,12)
	;;=Procedures cannot be sub-headers.
	;;^DD(350.71,.05,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)=""S"""
	;;^DD(350.71,.05,21,0)
	;;=^^1^1^2940209^^^^
	;;^DD(350.71,.05,21,1,0)
	;;=The sub-header that this entry is a member of.
	;;^DD(350.71,.05,23,0)
	;;=^^2^2^2940209^^
	;;^DD(350.71,.05,23,1,0)
	;;=Under the current hierarchical scheme this field should have data only if
	;;^DD(350.71,.05,23,2,0)
	;;=TYPE=PROCEDURE.
	;;^DD(350.71,.05,"DT")
	;;=2920128
	;;^DD(350.71,.06,0)
	;;=PROCEDURE^R*P409.71'^SD(409.71,^0;6^S DIC("S")="I $D(DA),$P($G(^IBE(350.71,+DA,0)),U,3)=""P""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.71,.06,1,0)
	;;=^.1
	;;^DD(350.71,.06,1,1,0)
	;;=350.71^P
	;;^DD(350.71,.06,1,1,1)
	;;=S ^IBE(350.71,"P",$E(X,1,30),DA)=""
	;;^DD(350.71,.06,1,1,2)
	;;=K ^IBE(350.71,"P",$E(X,1,30),DA)
	;;^DD(350.71,.06,1,1,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.06,1,1,"DT")
	;;=2911122
	;;^DD(350.71,.06,1,2,0)
	;;=350.71^AP^MUMPS
	;;^DD(350.71,.06,1,2,1)
	;;=I $P(^IBE(350.71,DA,0),"^",5) S ^IBE(350.71,"AP",$P(^(0),"^",5),X,DA)=""
	;;^DD(350.71,.06,1,2,2)
	;;=I $P(^IBE(350.71,DA,0),"^",5) K ^IBE(350.71,"AP",$P(^(0),"^",5),X,DA)
	;;^DD(350.71,.06,1,2,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.06,1,2,"%D",0)
	;;=^^1^1^2920128^^^
	;;^DD(350.71,.06,1,2,"%D",1,0)
	;;=Quick cross-reference between procedures and sub-headers.
	;;^DD(350.71,.06,1,2,"DT")
	;;=2911122
	;;^DD(350.71,.06,3)
	;;=Enter the CPT code for this Procedure.
	;;^DD(350.71,.06,12)
	;;=Only TYPE "P" entries may have procedures.
	;;^DD(350.71,.06,12.1)
	;;=S DIC("S")="I $D(DA),$P($G(^IBE(350.71,+DA,0)),U,3)=""P"""
	;;^DD(350.71,.06,21,0)
	;;=^^1^1^2920331^^^
	;;^DD(350.71,.06,21,1,0)
	;;=The CPT code for this PROCEDURE.  Should only be defined for TYPE="P".
	;;^DD(350.71,.06,"DT")
	;;=2911202
	;;^DD(350.71,.08,0)
	;;=CHARGE^CJ8,2^^ ; ^X ^DD(350.71,.08,9.4) S X1=Y(350.71,.08,1) S IBCDX=X,IBDTX=X1 D FCC^IBEFUNC1 S X=IBCHGX K IBCDX,IBDTX,IBCHGX S X=X S D0=Y(350.71,.08,80) S X=$J(X,0,2)
	;;^DD(350.71,.08,9)
	;;=^
	;;^DD(350.71,.08,9.01)
	;;=409.71^.01;350.71^.06
	;;^DD(350.71,.08,9.1)
	;;=IB CPT BILLING CHARGE(TODAY,PROCEDURE)
	;;^DD(350.71,.08,9.2)
	;;=S Y(350.71,.08,80)=$S($D(D0):D0,1:""),Y(350.71,.08,2)=$S($D(^IBE(350.71,D0,0)):^(0),1:""),X=DT S X=X,Y(350.71,.08,1)=X
	;;^DD(350.71,.08,9.3)
	;;=X ^DD(350.71,.08,9.2) S D0=$P(Y(350.71,.08,2),U,6) S:'$D(^SD(409.71,+D0,0)) D0=-1 S Y(350.71,.08,101)=$S($D(^SD(409.71,D0,0)):^(0),1:"")
	;;^DD(350.71,.08,9.4)
	;;=X ^DD(350.71,.08,9.3) S X=$S('$D(^ICPT(+$P(Y(350.71,.08,101),U,1),0)):"",1:$P(^(0),U,1))
	;;^DD(350.71,.08,21,0)
	;;=^^1^1^2930616^^^^
	;;^DD(350.71,.08,21,1,0)
	;;=Displays the charge for a CPT code.
	;;^DD(350.71,.08,"DT")
	;;=2920205
