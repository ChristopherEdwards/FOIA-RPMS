IBINI05O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.1,0,"GL")
	;;=^IBT(356.1,
	;;^DIC("B","HOSPITAL REVIEW",356.1)
	;;=
	;;^DIC(356.1,"%D",0)
	;;=^^11^11^2940214^^^^
	;;^DIC(356.1,"%D",1,0)
	;;=This file contains Utilization Review information about appropriateness
	;;^DIC(356.1,"%D",2,0)
	;;=of admission and continued stay in an acute medical setting.  It uses
	;;^DIC(356.1,"%D",3,0)
	;;=the Interqual criteria for appropriateness.  An entry for each day of
	;;^DIC(356.1,"%D",4,0)
	;;=care for cases being tracked is required by the QM office in VACO.  The
	;;^DIC(356.1,"%D",5,0)
	;;=information in this file will be rolled up into a national data base.
	;;^DIC(356.1,"%D",6,0)
	;;=Only reviews that have a status of COMPLETE should be rolled up.
	;;^DIC(356.1,"%D",7,0)
	;;= 
	;;^DIC(356.1,"%D",8,0)
	;;=The information in this file is clinical in nature and should be treated
	;;^DIC(356.1,"%D",9,0)
	;;=with the same confidentiality as required of all clinical data.
	;;^DIC(356.1,"%D",10,0)
	;;= 
	;;^DIC(356.1,"%D",11,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.1,0)
	;;=FIELD^^.24^34
	;;^DD(356.1,0,"DT")
	;;=2930928
	;;^DD(356.1,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBT(356,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(356,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.1,0,"ID",.21)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(356.1,.21,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,21)_"":"",2),$C(59),1)")
	;;^DD(356.1,0,"ID",.22)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(356.11,+$P(^(0),U,22),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(356.11,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.1,0,"IX","AC",356.1,.21)
	;;=
	;;^DD(356.1,0,"IX","AD",356.1,.22)
	;;=
	;;^DD(356.1,0,"IX","APEND",356.1,.2)
	;;=
	;;^DD(356.1,0,"IX","ASPC",356.1,.07)
	;;=
	;;^DD(356.1,0,"IX","ATIDT",356.1,.01)
	;;=
	;;^DD(356.1,0,"IX","ATIDT1",356.1,.02)
	;;=
	;;^DD(356.1,0,"IX","ATRTP",356.1,.22)
	;;=
	;;^DD(356.1,0,"IX","ATRTP1",356.1,.02)
	;;=
	;;^DD(356.1,0,"IX","B",356.1,.01)
	;;=
	;;^DD(356.1,0,"IX","C",356.1,.02)
	;;=
	;;^DD(356.1,0,"NM","HOSPITAL REVIEW")
	;;=
	;;^DD(356.1,0,"PT",356.1,.24)
	;;=
	;;^DD(356.1,0,"PT",356.2,.03)
	;;=
	;;^DD(356.1,.01,0)
	;;=REVIEW DATE^RD^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.1,.01,1,0)
	;;=^.1
	;;^DD(356.1,.01,1,1,0)
	;;=356.1^B
	;;^DD(356.1,.01,1,1,1)
	;;=S ^IBT(356.1,"B",$E(X,1,30),DA)=""
	;;^DD(356.1,.01,1,1,2)
	;;=K ^IBT(356.1,"B",$E(X,1,30),DA)
	;;^DD(356.1,.01,1,2,0)
	;;=356.1^ATIDT^MUMPS
	;;^DD(356.1,.01,1,2,1)
	;;=S:$P(^IBT(356.1,DA,0),U,2) ^IBT(356.1,"ATIDT",$P(^(0),U,2),-X,DA)=""
	;;^DD(356.1,.01,1,2,2)
	;;=K ^IBT(356.1,"ATIDT",+$P(^IBT(356.1,DA,0),U,2),-X,DA)
	;;^DD(356.1,.01,1,2,"%D",0)
	;;=^^2^2^2930714^
	;;^DD(356.1,.01,1,2,"%D",1,0)
	;;=Cross reference in inverse date order of all reviews for a tracking 
	;;^DD(356.1,.01,1,2,"%D",2,0)
	;;=entry.
	;;^DD(356.1,.01,1,2,"DT")
	;;=2930714
	;;^DD(356.1,.01,3)
	;;=
	;;^DD(356.1,.01,21,0)
	;;=^^13^13^2940213^^^^
	;;^DD(356.1,.01,21,1,0)
	;;=This is the date of the Review.  Normally, reviews are done for UR purposes
	;;^DD(356.1,.01,21,2,0)
	;;=on days 3, 6, 9, 14, 21, 28 and every 7 days thereafter.  This field
	;;^DD(356.1,.01,21,3,0)
	;;=contains the date of these reviews.
	;;^DD(356.1,.01,21,4,0)
	;;= 
	;;^DD(356.1,.01,21,5,0)
	;;=There are 2 related fields,  DAY FOR REVIEW, and DATE ENTERED.  The field
	;;^DD(356.1,.01,21,6,0)
	;;=DAY FOR REVIEW will generally be computed for you based on the REVIEW DATE.
	;;^DD(356.1,.01,21,7,0)
	;;=The DATE ENTERED is the date the review was entered into the computer and
