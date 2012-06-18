IBINI024	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.71)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.71,.02,3)
	;;=Type a Number between 1 and 9999, the number must not already be defined as a Print Order for the sheet/sub-header.  This determines the printing order for entries within sheets and sub-headers.
	;;^DD(350.71,.02,21,0)
	;;=^^2^2^2920415^^^^
	;;^DD(350.71,.02,21,1,0)
	;;=The order that the members of the check-off sheet/sub-header are printed.
	;;^DD(350.71,.02,21,2,0)
	;;=A print order must be entered or the procedure is deleted from the sheet.
	;;^DD(350.71,.02,"DT")
	;;=2920211
	;;^DD(350.71,.03,0)
	;;=TYPE^RS^S:SUB-HEADER;P:PROCEDURE;^0;3^Q
	;;^DD(350.71,.03,1,0)
	;;=^.1^^0
	;;^DD(350.71,.03,3)
	;;=A sub-header is a subgroup which may have multiple procedures associated with it.  A procedure is printed under a specific sub-header and must have a valid CPT code.
	;;^DD(350.71,.03,21,0)
	;;=^^2^2^2920128^^^
	;;^DD(350.71,.03,21,1,0)
	;;=The type definition for this entry.  There are only two types:
	;;^DD(350.71,.03,21,2,0)
	;;=  "P"rocedures which should always have valid CPT codes, and "S"ub-headers which may have multiple procedures.
	;;^DD(350.71,.03,"DT")
	;;=2920128
	;;^DD(350.71,.04,0)
	;;=CHECK-OFF SHEET^P350.7'^IBE(350.7,^0;4^Q
	;;^DD(350.71,.04,1,0)
	;;=^.1
	;;^DD(350.71,.04,1,1,0)
	;;=350.71^AG1^MUMPS
	;;^DD(350.71,.04,1,1,1)
	;;=I $P(^IBE(350.71,DA,0),"^",2) S ^IBE(350.71,"AG",X,$P(^(0),"^",2),DA)=""
	;;^DD(350.71,.04,1,1,2)
	;;=I $P(^IBE(350.71,DA,0),"^",2) K ^IBE(350.71,"AG",X,$P(^(0),"^",2),DA)
	;;^DD(350.71,.04,1,1,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.04,1,1,"%D",0)
	;;=^^1^1^2920128^^^^
	;;^DD(350.71,.04,1,1,"%D",1,0)
	;;=Quick cross-reference for members and their print orders within a check-off sheet.
	;;^DD(350.71,.04,1,1,"DT")
	;;=2911121
	;;^DD(350.71,.04,1,2,0)
	;;=350.71^G
	;;^DD(350.71,.04,1,2,1)
	;;=S ^IBE(350.71,"G",$E(X,1,30),DA)=""
	;;^DD(350.71,.04,1,2,2)
	;;=K ^IBE(350.71,"G",$E(X,1,30),DA)
	;;^DD(350.71,.04,1,2,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.04,1,2,"%D",0)
	;;=^^1^1^2920128^
	;;^DD(350.71,.04,1,2,"%D",1,0)
	;;=Quick index of all sheets (groups).
	;;^DD(350.71,.04,1,2,"DT")
	;;=2911122
	;;^DD(350.71,.04,3)
	;;=The check-off sheet this entry is a member of.  This entry will be printed on the CPT list for the sheet you specify.
	;;^DD(350.71,.04,21,0)
	;;=^^1^1^2940209^^^^
	;;^DD(350.71,.04,21,1,0)
	;;=The check-off sheet this entry belongs to.
	;;^DD(350.71,.04,23,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.71,.04,23,1,0)
	;;=Under the current hierarchical scheme this field will have data only for
	;;^DD(350.71,.04,23,2,0)
	;;=entries of TYPE=SUB-HEADER.
	;;^DD(350.71,.04,"DT")
	;;=2920128
	;;^DD(350.71,.05,0)
	;;=SUB-HEADER^*P350.71'^IBE(350.71,^0;5^S DIC("S")="I $P(^(0),U,3)=""S""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.71,.05,1,0)
	;;=^.1
	;;^DD(350.71,.05,1,1,0)
	;;=350.71^AS1^MUMPS
	;;^DD(350.71,.05,1,1,1)
	;;=I $P(^IBE(350.71,DA,0),"^",2) S ^IBE(350.71,"AS",X,$P(^(0),"^",2),DA)=""
	;;^DD(350.71,.05,1,1,2)
	;;=I $P(^IBE(350.71,DA,0),"^",2) K ^IBE(350.71,"AS",X,$P(^(0),"^",2),DA)
	;;^DD(350.71,.05,1,1,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.05,1,1,"%D",0)
	;;=^^1^1^2920128^
	;;^DD(350.71,.05,1,1,"%D",1,0)
	;;=Quick index for sub-header members (procedures) and their print orders.
	;;^DD(350.71,.05,1,1,"DT")
	;;=2920128
	;;^DD(350.71,.05,1,3,0)
	;;=350.71^S
	;;^DD(350.71,.05,1,3,1)
	;;=S ^IBE(350.71,"S",$E(X,1,30),DA)=""
	;;^DD(350.71,.05,1,3,2)
	;;=K ^IBE(350.71,"S",$E(X,1,30),DA)
	;;^DD(350.71,.05,1,3,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.05,1,3,"%D",0)
	;;=^^1^1^2920128^
	;;^DD(350.71,.05,1,3,"%D",1,0)
	;;=Quick index of all sub-header entrys.
