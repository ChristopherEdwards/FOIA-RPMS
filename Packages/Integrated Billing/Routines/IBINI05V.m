IBINI05V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.1,1.14,21,3,0)
	;;=review into the next days review so you don't have to do all the
	;;^DD(356.1,1.14,21,4,0)
	;;=data entry.  Answer No and you will be asked each prompt as appropriate.
	;;^DD(356.1,1.14,21,5,0)
	;;= 
	;;^DD(356.1,1.14,21,6,0)
	;;=A review that was copied may be edited at any time if necessary.
	;;^DD(356.1,1.14,"DT")
	;;=2930830
	;;^DD(356.1,1.15,0)
	;;=ADDITIONAL REVIEWS REQUIRED^S^1:YES;0:NO;^1;15^Q
	;;^DD(356.1,1.15,3)
	;;=
	;;^DD(356.1,1.15,21,0)
	;;=^^4^4^2940213^^^
	;;^DD(356.1,1.15,21,1,0)
	;;=If this visit does not require any additional reviews then answer NO and
	;;^DD(356.1,1.15,21,2,0)
	;;=the computer will not create any more reviews automatically unless there
	;;^DD(356.1,1.15,21,3,0)
	;;=is a change is service.  Answer YES or leave blank if additional reviews
	;;^DD(356.1,1.15,21,4,0)
	;;=are required.
	;;^DD(356.1,1.15,22)
	;;=
	;;^DD(356.1,1.15,"DT")
	;;=2930830
	;;^DD(356.1,1.17,0)
	;;=ACUTE CARE DISCHARGE DATE^D^^1;17^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.1,1.17,3)
	;;=
	;;^DD(356.1,1.17,21,0)
	;;=^^2^2^2940213^^
	;;^DD(356.1,1.17,21,1,0)
	;;=If the patient no longer requires acute care, then this is the date
	;;^DD(356.1,1.17,21,2,0)
	;;=that the patient left an acute status.  
	;;^DD(356.1,1.17,"DT")
	;;=2930830
	;;^DD(356.1,11,0)
	;;=UTILIZATION REVIEW COMMENTS^356.111^^11;0
	;;^DD(356.1,11,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.1,11,21,1,0)
	;;=This field is used to store comments about the UR Review.  It can be
	;;^DD(356.1,11,21,2,0)
	;;=used to document reasons for non-acute admissions, non-acute days,
	;;^DD(356.1,11,21,3,0)
	;;=or other items that require a greater explanation.
	;;^DD(356.1,12,0)
	;;=REASON FOR NON-ACUTE ADMISSION^356.112PA^^12;0
	;;^DD(356.1,12,12)
	;;=Only reasons for non-acute admissions may be selected!
	;;^DD(356.1,12,12.1)
	;;=S DIC("S")="I $P(^(0),U,5)=1"
	;;^DD(356.1,12,21,0)
	;;=^^6^6^2940213^^^
	;;^DD(356.1,12,21,1,0)
	;;=If this patient did not meet criteria for an acute admission within
	;;^DD(356.1,12,21,2,0)
	;;=24 hours enter the reasons that best describe why the admission didn't
	;;^DD(356.1,12,21,3,0)
	;;=meet criteria.  If no reason can be determined enter 8.02 other.
	;;^DD(356.1,12,21,4,0)
	;;= 
	;;^DD(356.1,12,21,5,0)
	;;=This reason will be transmitted to the national database when it becomes
	;;^DD(356.1,12,21,6,0)
	;;=available.
	;;^DD(356.1,13,0)
	;;=REASON FOR NON-ACUTE DAYS^356.113PA^^13;0
	;;^DD(356.1,13,12)
	;;=Only reasons for non-acute days of care may be selected!
	;;^DD(356.1,13,12.1)
	;;=S DIC("S")="I $P(^(0),U,5)=2"
	;;^DD(356.1,13,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.1,13,21,1,0)
	;;=If this patient had non-acute days of care during this review, enter
	;;^DD(356.1,13,21,2,0)
	;;=reasons that best describe the reason for the non-acute days.  If no
	;;^DD(356.1,13,21,3,0)
	;;=reason can be deteremined select the reason 8.01, Other.
	;;^DD(356.1,21,0)
	;;=PATIENT^CJ30^^ ; ^X ^DD(356.1,21,9.2) S Y(356.1,21,101)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$S('$D(^DPT(+$P(Y(356.1,21,101),U,2),0)):"",1:$P(^(0),U,1)) S D0=Y(356.1,21,80)
	;;^DD(356.1,21,9)
	;;=^
	;;^DD(356.1,21,9.01)
	;;=356^.02;356.1^.02
	;;^DD(356.1,21,9.1)
	;;=TRACKING ID:PATIENT
	;;^DD(356.1,21,9.2)
	;;=S Y(356.1,21,80)=$S($D(D0):D0,1:""),Y(356.1,21,1)=$S($D(^IBT(356.1,D0,0)):^(0),1:""),D0=$P(Y(356.1,21,1),U,2) S:'$D(^IBT(356,+D0,0)) D0=-1
	;;^DD(356.1,21,21,0)
	;;=^^1^1^2930726^
	;;^DD(356.1,21,21,1,0)
	;;=This is the patient whose tracking entry this review is for.
	;;^DD(356.111,0)
	;;=UTILIZATION REVIEW COMMENTS SUB-FIELD^^.01^1
