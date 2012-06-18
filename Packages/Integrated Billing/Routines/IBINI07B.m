IBINI07B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.93)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.93,0,"GL")
	;;=^IBT(356.93,
	;;^DIC("B","INPATIENT INTERIM DRG",356.93)
	;;=
	;;^DIC(356.93,"%D",0)
	;;=^^7^7^2940214^^^^
	;;^DIC(356.93,"%D",1,0)
	;;=This file holds interim DRGs computed by the Claims Tracking Module for
	;;^DIC(356.93,"%D",2,0)
	;;=display in Claims Tracking and on Reports.  The computed ALOS is based
	;;^DIC(356.93,"%D",3,0)
	;;=upon 1992 HCFA average lengths of stay and not VA averages.  The purpose is
	;;^DIC(356.93,"%D",4,0)
	;;=to help utilization review personnel determine if the the ALOS approved
	;;^DIC(356.93,"%D",5,0)
	;;=by an insurance company is within industry standards.
	;;^DIC(356.93,"%D",6,0)
	;;= 
	;;^DIC(356.93,"%D",7,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.93,0)
	;;=FIELD^^.05^5
	;;^DD(356.93,0,"DDA")
	;;=N
	;;^DD(356.93,0,"DT")
	;;=2931213
	;;^DD(356.93,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGPM(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(405,.01,0),U,2) D Y^DIQ:Y]"" W "   Admission Date: ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.93,0,"ID",.03)
	;;=W "   Computed: ",$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)
	;;^DD(356.93,0,"ID","WRITE")
	;;=N Y S Y=$G(^(0)) W "   ",$P($G(^DPT(+$P($G(^DGPM(+$P(Y,U,2),0)),U,3),0)),U)
	;;^DD(356.93,0,"IX","AC",356.93,.04)
	;;=
	;;^DD(356.93,0,"IX","AMVD",356.93,.02)
	;;=
	;;^DD(356.93,0,"IX","AMVD1",356.93,.03)
	;;=
	;;^DD(356.93,0,"IX","B",356.93,.01)
	;;=
	;;^DD(356.93,0,"NM","INPATIENT INTERIM DRG")
	;;=
	;;^DD(356.93,.01,0)
	;;=NAME^RP80.2'^ICD(^0;1^Q
	;;^DD(356.93,.01,1,0)
	;;=^.1
	;;^DD(356.93,.01,1,1,0)
	;;=356.93^B
	;;^DD(356.93,.01,1,1,1)
	;;=S ^IBT(356.93,"B",$E(X,1,30),DA)=""
	;;^DD(356.93,.01,1,1,2)
	;;=K ^IBT(356.93,"B",$E(X,1,30),DA)
	;;^DD(356.93,.01,3)
	;;=
	;;^DD(356.93,.01,21,0)
	;;=^^1^1^2931129^
	;;^DD(356.93,.01,21,1,0)
	;;=Enter the DRG that best describes this inpatient case.
	;;^DD(356.93,.01,"DT")
	;;=2931129
	;;^DD(356.93,.02,0)
	;;=ADMISSION MOVEMENT^*P405'^DGPM(^0;2^S DIC("S")="I $P(^(0),U,2)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.93,.02,1,0)
	;;=^.1
	;;^DD(356.93,.02,1,1,0)
	;;=356.93^AMVD^MUMPS
	;;^DD(356.93,.02,1,1,1)
	;;=S:$P(^IBT(356.93,DA,0),U,3) ^IBT(356.93,"AMVD",X,+$P(^(0),U,3),DA)=""
	;;^DD(356.93,.02,1,1,2)
	;;=K ^IBT(356.93,"AMVD",X,+$P(^IBT(356.93,DA,0),U,3),DA)
	;;^DD(356.93,.02,1,1,"%D",0)
	;;=^^1^1^2931130^
	;;^DD(356.93,.02,1,1,"%D",1,0)
	;;=Cross reference of drgs by admission movement and drg date.
	;;^DD(356.93,.02,1,1,"DT")
	;;=2931130
	;;^DD(356.93,.02,12)
	;;=Must be an admission movement.
	;;^DD(356.93,.02,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=1"
	;;^DD(356.93,.02,21,0)
	;;=^^2^2^2931129^
	;;^DD(356.93,.02,21,1,0)
	;;=This field should point to the admission movement of the inpatient 
	;;^DD(356.93,.02,21,2,0)
	;;=episode that this interim DRG is for.
	;;^DD(356.93,.02,"DT")
	;;=2931130
	;;^DD(356.93,.03,0)
	;;=DATE^D^^0;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.93,.03,1,0)
	;;=^.1
	;;^DD(356.93,.03,1,1,0)
	;;=356.93^AMVD1^MUMPS
	;;^DD(356.93,.03,1,1,1)
	;;=S:$P(^IBT(356.93,DA,0),U,2) ^IBT(356.93,"AMVD",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.93,.03,1,1,2)
	;;=K ^IBT(356.93,"AMVD",+$P(^IBT(356.93,DA,0),U,2),X,DA)
	;;^DD(356.93,.03,1,1,"%D",0)
	;;=^^1^1^2931130^
	;;^DD(356.93,.03,1,1,"%D",1,0)
	;;=Cross reference of drgs by admission movement and drg date.
	;;^DD(356.93,.03,1,1,"DT")
	;;=2931130
	;;^DD(356.93,.03,3)
	;;=This is the date that the INTERIM DRG was computed.
	;;^DD(356.93,.03,21,0)
	;;=^^1^1^2931129^
	;;^DD(356.93,.03,21,1,0)
	;;=Enter the date that this DRG was computed.
