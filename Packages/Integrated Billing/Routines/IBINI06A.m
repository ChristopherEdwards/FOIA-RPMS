IBINI06A	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,11,21,3,0)
	;;=in other fields or to pass along pertinent information to other users.
	;;^DD(356.2,12,0)
	;;=REASONS FOR DENIAL^356.212PA^^12;0
	;;^DD(356.2,12,21,0)
	;;=^^2^2^2940202^^
	;;^DD(356.2,12,21,1,0)
	;;=If this contact was a denial, this is the reason(s) for denial.  More
	;;^DD(356.2,12,21,2,0)
	;;=than one reason may be selected from the available choices.
	;;^DD(356.2,13,0)
	;;=PENALTY^356.213SA^^13;0
	;;^DD(356.2,13,21,0)
	;;=^^2^2^2940213^^
	;;^DD(356.2,13,21,1,0)
	;;=If the action taken by an insurance company was to assess a penalty,
	;;^DD(356.2,13,21,2,0)
	;;=then this is the reason for the penalty.
	;;^DD(356.2,14,0)
	;;=APPROVE ON APPEAL FROM^356.214DA^^14;0
	;;^DD(356.2,14,21,0)
	;;=^^3^3^2940213^^^
	;;^DD(356.2,14,21,1,0)
	;;=Enter the dates that were approved for payment after an appeal.  If the
	;;^DD(356.2,14,21,2,0)
	;;=appeal was partially or fully approved enter the dates that this appeal
	;;^DD(356.2,14,21,3,0)
	;;=was approved from.
	;;^DD(356.211,0)
	;;=COMMENTS SUB-FIELD^^.01^1
	;;^DD(356.211,0,"NM","COMMENTS")
	;;=
	;;^DD(356.211,0,"UP")
	;;=356.2
	;;^DD(356.211,.01,0)
	;;=COMMENTS^W^^0;1^Q
	;;^DD(356.211,.01,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.211,.01,21,1,0)
	;;=This field is used to store long textual information about the contact.
	;;^DD(356.211,.01,21,2,0)
	;;=This may be used to document specific information that is not captured
	;;^DD(356.211,.01,21,3,0)
	;;=in other fields or to pass along pertinent information to other users.
	;;^DD(356.211,.01,"DT")
	;;=2930610
	;;^DD(356.212,0)
	;;=REASONS FOR DENIAL SUB-FIELD^^.01^1
	;;^DD(356.212,0,"IX","B",356.212,.01)
	;;=
	;;^DD(356.212,0,"NM","REASONS FOR DENIAL")
	;;=
	;;^DD(356.212,0,"UP")
	;;=356.2
	;;^DD(356.212,.01,0)
	;;=REASONS FOR DENIAL^MP356.21'^IBE(356.21,^0;1^Q
	;;^DD(356.212,.01,1,0)
	;;=^.1
	;;^DD(356.212,.01,1,1,0)
	;;=356.212^B
	;;^DD(356.212,.01,1,1,1)
	;;=S ^IBT(356.2,DA(1),12,"B",$E(X,1,30),DA)=""
	;;^DD(356.212,.01,1,1,2)
	;;=K ^IBT(356.2,DA(1),12,"B",$E(X,1,30),DA)
	;;^DD(356.212,.01,21,0)
	;;=^^2^2^2940202^^^
	;;^DD(356.212,.01,21,1,0)
	;;=If this contact was a denial, this is the reason(s) for denial.  More
	;;^DD(356.212,.01,21,2,0)
	;;=than one reason may be selected from the available choices.
	;;^DD(356.212,.01,"DT")
	;;=2930610
	;;^DD(356.213,0)
	;;=PENALTY SUB-FIELD^^.02^2
	;;^DD(356.213,0,"DT")
	;;=2940125
	;;^DD(356.213,0,"IX","B",356.213,.01)
	;;=
	;;^DD(356.213,0,"NM","PENALTY")
	;;=
	;;^DD(356.213,0,"UP")
	;;=356.2
	;;^DD(356.213,.01,0)
	;;=PENALTY^MS^1:NO PRE ADMISSION CERTIFICATION;2:UNTIMELY PRE ADMISSION CERTIFICATION;3:VA A NON-PROVIDER;^0;1^Q
	;;^DD(356.213,.01,1,0)
	;;=^.1
	;;^DD(356.213,.01,1,1,0)
	;;=356.213^B
	;;^DD(356.213,.01,1,1,1)
	;;=S ^IBT(356.2,DA(1),13,"B",$E(X,1,30),DA)=""
	;;^DD(356.213,.01,1,1,2)
	;;=K ^IBT(356.2,DA(1),13,"B",$E(X,1,30),DA)
	;;^DD(356.213,.01,21,0)
	;;=^^2^2^2940213^^^
	;;^DD(356.213,.01,21,1,0)
	;;=If the action taken by an insurance company was to assess a penalty,
	;;^DD(356.213,.01,21,2,0)
	;;=then this is the reason for the penalty.
	;;^DD(356.213,.01,"DT")
	;;=2940125
	;;^DD(356.213,.02,0)
	;;=AMOUNT OF PENALTY^NJ9,2^^0;2^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(356.213,.02,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(356.213,.02,21,0)
	;;=^^2^2^2940213^^
	;;^DD(356.213,.02,21,1,0)
	;;=If the action taken by an insurance company was to assess a penalty,
	;;^DD(356.213,.02,21,2,0)
	;;=this is the amount of the penalty assessed.
	;;^DD(356.213,.02,"DT")
	;;=2930806
