IBINI06Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.5,0,"GL")
	;;=^IBE(356.5,
	;;^DIC("B","CLAIMS TRACKING ALOS",356.5)
	;;=
	;;^DIC(356.5,"%D",0)
	;;=^^8^8^2940214^^^^
	;;^DIC(356.5,"%D",1,0)
	;;=This file contains the DRG's and average length of stays (ALOS) that
	;;^DIC(356.5,"%D",2,0)
	;;=is the most common alos approved by insurance companies.  this generally
	;;^DIC(356.5,"%D",3,0)
	;;=is much shorted than the ALOS for the VA
	;;^DIC(356.5,"%D",4,0)
	;;= 
	;;^DIC(356.5,"%D",5,0)
	;;=The data in this file is initially seeded with the HCFA 1992 table of
	;;^DIC(356.5,"%D",6,0)
	;;=average length of stays.
	;;^DIC(356.5,"%D",7,0)
	;;= 
	;;^DIC(356.5,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.5,0)
	;;=FIELD^^.03^3
	;;^DD(356.5,0,"DT")
	;;=2931129
	;;^DD(356.5,0,"IX","ADR",356.5,.01)
	;;=
	;;^DD(356.5,0,"IX","ADR1",356.5,.02)
	;;=
	;;^DD(356.5,0,"IX","B",356.5,.01)
	;;=
	;;^DD(356.5,0,"NM","CLAIMS TRACKING ALOS")
	;;=
	;;^DD(356.5,.01,0)
	;;=DRG^RP80.2'^ICD(^0;1^Q
	;;^DD(356.5,.01,1,0)
	;;=^.1
	;;^DD(356.5,.01,1,1,0)
	;;=356.5^B
	;;^DD(356.5,.01,1,1,1)
	;;=S ^IBE(356.5,"B",$E(X,1,30),DA)=""
	;;^DD(356.5,.01,1,1,2)
	;;=K ^IBE(356.5,"B",$E(X,1,30),DA)
	;;^DD(356.5,.01,1,2,0)
	;;=356.5^ADR^MUMPS
	;;^DD(356.5,.01,1,2,1)
	;;=S:$P(^IBE(356.5,DA,0),U,2) ^IBE(356.5,"ADR",X,$P(^(0),U,2),DA)=""
	;;^DD(356.5,.01,1,2,2)
	;;=K ^IBE(356.5,"ADR",X,+$P(^IBE(356.5,DA,0),U,2),DA)
	;;^DD(356.5,.01,1,2,"%D",0)
	;;=^^1^1^2930723^
	;;^DD(356.5,.01,1,2,"%D",1,0)
	;;=Cross-reference of drgs by year.
	;;^DD(356.5,.01,1,2,"DT")
	;;=2930723
	;;^DD(356.5,.01,3)
	;;=
	;;^DD(356.5,.01,21,0)
	;;=^^4^4^2940213^^
	;;^DD(356.5,.01,21,1,0)
	;;=This is the DRG for which you wish to enter an average length of stay
	;;^DD(356.5,.01,21,2,0)
	;;=that will be reflected on the review screen.  This ALOS is an alos
	;;^DD(356.5,.01,21,3,0)
	;;=that is used in practice by the insurance industry which is different
	;;^DD(356.5,.01,21,4,0)
	;;=than the ALOS generally found in DHCP files which are specific to VA care.
	;;^DD(356.5,.01,"DT")
	;;=2931129
	;;^DD(356.5,.02,0)
	;;=YEAR^RDX^^0;2^S %DT="E" D ^%DT S X=Y K:Y<1 X S:$D(X) X=$E(X,1,3)_"0000"
	;;^DD(356.5,.02,1,0)
	;;=^.1
	;;^DD(356.5,.02,1,1,0)
	;;=356.5^ADR1^MUMPS
	;;^DD(356.5,.02,1,1,1)
	;;=S:$P(^IBE(356.5,DA,0),U) ^IBE(356.5,"ADR",$P(^(0),U),X,DA)=""
	;;^DD(356.5,.02,1,1,2)
	;;=K ^IBE(356.5,"ADR",+$P(^IBE(356.5,DA,0),U),X,DA)
	;;^DD(356.5,.02,1,1,"%D",0)
	;;=^^2^2^2930723^
	;;^DD(356.5,.02,1,1,"%D",1,0)
	;;=Cross reference of all drgs by year so that the alos for that drg for the
	;;^DD(356.5,.02,1,1,"%D",2,0)
	;;=correct year can be found.
	;;^DD(356.5,.02,1,1,"DT")
	;;=2930723
	;;^DD(356.5,.02,3)
	;;=Enter the year for this ALOS for this DRG.  If any date other than a year is entered, only the year will be stored.
	;;^DD(356.5,.02,21,0)
	;;=^^3^3^2930723^
	;;^DD(356.5,.02,21,1,0)
	;;=This is the year for which you want to enter an average lenght of stay for
	;;^DD(356.5,.02,21,2,0)
	;;=this DRG.  If any date in a year is entered only the year will be
	;;^DD(356.5,.02,21,3,0)
	;;=stored.
	;;^DD(356.5,.02,"DT")
	;;=2930723
	;;^DD(356.5,.03,0)
	;;=ALOS FOR INS. PURPOSES^NJ7,2^^0;3^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(356.5,.03,3)
	;;=Enter the ALOS for this DRG for this year.  Type a Number between 0 and 9999, 2 Decimal Digits
	;;^DD(356.5,.03,21,0)
	;;=^^4^4^2930723^
	;;^DD(356.5,.03,21,1,0)
	;;=Enter the average length of stay (ALOS) that you wish to be used 
	;;^DD(356.5,.03,21,2,0)
	;;=as a base for insurance purposes.  This ALOS will be displayed on
