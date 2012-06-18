IBINI05W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.111,0,"DT")
	;;=2930723
	;;^DD(356.111,0,"NM","UTILIZATION REVIEW COMMENTS")
	;;=
	;;^DD(356.111,0,"UP")
	;;=356.1
	;;^DD(356.111,.01,0)
	;;=UTILIZATION REVIEW COMMENTS^W^^0;1^Q
	;;^DD(356.111,.01,.1)
	;;=COMMENTS
	;;^DD(356.111,.01,21,0)
	;;=^^3^3^2940213^^^
	;;^DD(356.111,.01,21,1,0)
	;;=This field is used to store comments about the UR Review.  It can be
	;;^DD(356.111,.01,21,2,0)
	;;=used to document reasons for non-acute admissions, non-acute days,
	;;^DD(356.111,.01,21,3,0)
	;;=or other items that require a greater explanation.
	;;^DD(356.111,.01,"DT")
	;;=2930723
	;;^DD(356.112,0)
	;;=REASON FOR NON-ACUTE ADMISSION SUB-FIELD^^.01^1
	;;^DD(356.112,0,"DT")
	;;=2930826
	;;^DD(356.112,0,"IX","B",356.112,.01)
	;;=
	;;^DD(356.112,0,"NM","REASON FOR NON-ACUTE ADMISSION")
	;;=
	;;^DD(356.112,0,"UP")
	;;=356.1
	;;^DD(356.112,.01,0)
	;;=REASON FOR NON-ACUTE ADMISSION^M*P356.4'^IBE(356.4,^0;1^S DIC("S")="I $P(^(0),U,5)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.112,.01,1,0)
	;;=^.1
	;;^DD(356.112,.01,1,1,0)
	;;=356.112^B
	;;^DD(356.112,.01,1,1,1)
	;;=S ^IBT(356.1,DA(1),12,"B",$E(X,1,30),DA)=""
	;;^DD(356.112,.01,1,1,2)
	;;=K ^IBT(356.1,DA(1),12,"B",$E(X,1,30),DA)
	;;^DD(356.112,.01,21,0)
	;;=^^6^6^2940213^^
	;;^DD(356.112,.01,21,1,0)
	;;=If this patient did not meet criteria for an acute admission within
	;;^DD(356.112,.01,21,2,0)
	;;=24 hours enter the reasons that best describe why the admission didn't
	;;^DD(356.112,.01,21,3,0)
	;;=meet criteria.  If no reason can be determined enter 8.02 other.
	;;^DD(356.112,.01,21,4,0)
	;;= 
	;;^DD(356.112,.01,21,5,0)
	;;=This reason will be transmitted to the national database when it become
	;;^DD(356.112,.01,21,6,0)
	;;=available.
	;;^DD(356.112,.01,"DT")
	;;=2930826
	;;^DD(356.113,0)
	;;=REASON FOR NON-ACUTE DAYS SUB-FIELD^^.01^1
	;;^DD(356.113,0,"DT")
	;;=2930826
	;;^DD(356.113,0,"IX","B",356.113,.01)
	;;=
	;;^DD(356.113,0,"NM","REASON FOR NON-ACUTE DAYS")
	;;=
	;;^DD(356.113,0,"UP")
	;;=356.1
	;;^DD(356.113,.01,0)
	;;=REASON FOR NON-ACUTE DAYS^M*P356.4'^IBE(356.4,^0;1^S DIC("S")="I $P(^(0),U,5)=2" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.113,.01,1,0)
	;;=^.1
	;;^DD(356.113,.01,1,1,0)
	;;=356.113^B
	;;^DD(356.113,.01,1,1,1)
	;;=S ^IBT(356.1,DA(1),13,"B",$E(X,1,30),DA)=""
	;;^DD(356.113,.01,1,1,2)
	;;=K ^IBT(356.1,DA(1),13,"B",$E(X,1,30),DA)
	;;^DD(356.113,.01,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.113,.01,21,1,0)
	;;=If this patient had non-acute days of care during this review, enter
	;;^DD(356.113,.01,21,2,0)
	;;=reasons that best describe the reason for the non-acute days.  If no
	;;^DD(356.113,.01,21,3,0)
	;;=reason can be determined select the reason 8.01.
	;;^DD(356.113,.01,"DT")
	;;=2930826
