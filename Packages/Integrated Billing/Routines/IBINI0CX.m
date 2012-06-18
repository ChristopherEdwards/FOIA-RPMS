IBINI0CX	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIPT",677,0)
	;;=IB BILLING RATES^2900529.1^^399.5^^^2920708^
	;;^UTILITY(U,$J,"DIPT",677,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIPT",677,"%D",1,0)
	;;=List billing rates.
	;;^UTILITY(U,$J,"DIPT",677,"F",2)
	;;=.02;L30~.03~.04~.05;L15~.06;L30~.07;"NON-STANDARD"~
	;;^UTILITY(U,$J,"DIPT",677,"H")
	;;=BILLING RATES LIST
	;;^UTILITY(U,$J,"DIPT",735,0)
	;;=IB LIST^2910419.0822^^350^^^2940308^
	;;^UTILITY(U,$J,"DIPT",735,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIPT",735,"%D",1,0)
	;;=Integrated Billing Action List.
	;;^UTILITY(U,$J,"DIPT",735,"DCL","350^.01")
	;;=!
	;;^UTILITY(U,$J,"DIPT",735,"DCL","350^.06")
	;;=&
	;;^UTILITY(U,$J,"DIPT",735,"DCL","350^.07")
	;;=&
	;;^UTILITY(U,$J,"DIPT",735,"DXS",1,9.2)
	;;=S DIP(1)=$S($D(^IB(D0,0)):^(0),1:"") S X=$S('$D(^IBE(350.1,+$P(DIP(1),U,3),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=" ",DIP(3)=X S X=2,DIP(4)=X S X=99
	;;^UTILITY(U,$J,"DIPT",735,"F",1)
	;;=.02;L20~.01;"REF. NO";L10~X DXS(1,9.2) S X=$P(DIP(2),DIP(3),DIP(4),X) W X K DIP;"TYPE";L20;Z;"$P(#.03," ",2,99)"~.05;L10~
	;;^UTILITY(U,$J,"DIPT",735,"F",2)
	;;=S DIP(1)=$S($D(^IB(D0,1)):^(1),1:"") S X=$P(DIP(1),U,2),X=$P(X,".",1) S Y=X D DT K DIP;L11;"DATE ADDED";Z;"DATE(#12)"~.06;R5~.07;"CHARGE";R8~.08~
	;;^UTILITY(U,$J,"DIPT",735,"F",3)
	;;=.11;"CHARGE ID";L10~
	;;^UTILITY(U,$J,"DIPT",735,"H")
	;;=INTEGRATED BILLING ACTION LIST
	;;^UTILITY(U,$J,"DIPT",834,0)
	;;=IB INCOMPLETE^2910318.1107^^350^^^^
	;;^UTILITY(U,$J,"DIPT",834,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIPT",834,"%D",1,0)
	;;=Integrated Billing Action List of entries with Status of Incomplete.
	;;^UTILITY(U,$J,"DIPT",834,"F",1)
	;;=.02;"Patient";L20~-2,^DPT(^^S I(0,0)=D0 S DIP(1)=$S($D(^IB(D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X;Z;"PATIENT:"~-2,.09;"SSN"~
	;;^UTILITY(U,$J,"DIPT",834,"F",2)
	;;=.01;"Ref. No.";L10~.08~-350.1,^IBE(350.1,^^S I(0,0)=D0 S DIP(1)=$S($D(^IB(D0,0)):^(0),1:"") S X=$P(DIP(1),U,3),X=X S D(0)=+X;Z;"ACTION TYPE:"~
	;;^UTILITY(U,$J,"DIPT",834,"F",3)
	;;=-350.1,.05;"TYPE";L10~I '$D(IBPASS) S IBPASS=0;Z;"I '$D(IBPASS) S IBPASS=0"~I IBPASS D REPASS^IBAFIL;Z;"I IBPASS D REPASS^IBAFIL"~
	;;^UTILITY(U,$J,"DIPT",834,"H")
	;;=INTEGRATED BILLING ACTION LIST
	;;^UTILITY(U,$J,"DIPT",837,0)
	;;=IB CPT UPDATE ERROR^2920128.1719^@^350.41^10882^@^2920715
	;;^UTILITY(U,$J,"DIPT",837,"%D",0)
	;;=^^1^1^2920708^^^^
	;;^UTILITY(U,$J,"DIPT",837,"%D",1,0)
	;;=Update Billable Amb. Surg. Transfer Error List Report.
	;;^UTILITY(U,$J,"DIPT",837,"DXS",1,9.2)
	;;=S I(0,0)=$S($D(D0):D0,1:""),DIP(1)=$S($D(^IBE(350.41,D0,0)):^(0),1:""),D0=$P(DIP(1),U,3) S:'$D(^IBE(350.1,+D0,0)) D0=-1 S DIP(101)=$S($D(^IBE(350.1,D0,0)):^(0),1:"")
	;;^UTILITY(U,$J,"DIPT",837,"DXS",2,9.2)
	;;=S I(0,0)=$S($D(D0):D0,1:""),DIP(1)=$S($D(^IBE(350.41,D0,0)):^(0),1:""),D0=$P(DIP(1),U,4) S:'$D(^IBE(350.1,+D0,0)) D0=-1 S DIP(101)=$S($D(^IBE(350.1,D0,0)):^(0),1:"")
	;;^UTILITY(U,$J,"DIPT",837,"F",1)
	;;=.01;N~.02~X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) W X K DIP;C28;"OLD GROUP";Z;"OLD RATE GROUP:ABBREVIATION"~
	;;^UTILITY(U,$J,"DIPT",837,"F",2)
	;;=X DXS(2,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) W X K DIP;"NEW GROUP";Z;"NEW RATE GROUP:ABBREVIATION"~.06~.08;W55~
	;;^UTILITY(U,$J,"DIPT",837,"H")
	;;=UPDATE BILLABLE AMB. SURG. ERROR LIST
	;;^UTILITY(U,$J,"DIPT",838,0)
	;;=IB CPT PG DISPLAY^2920205.1721^@^350.7^10882^@^2920331
	;;^UTILITY(U,$J,"DIPT",838,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIPT",838,"%D",1,0)
	;;=Displays a Check-off Sheets line format and associated sub-headers.
	;;^UTILITY(U,$J,"DIPT",838,"DXS",1,9.2)
	;;=F D=0:0 S (D,D0)=$N(^SC("AF",I(0,0),D)) Q:D'>0  I $D(^SC(D,0)) S X=$P(^(0),U,1) X DICMX Q:'$D(D)  S D=D0
