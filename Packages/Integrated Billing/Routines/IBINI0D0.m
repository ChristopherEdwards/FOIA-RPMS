IBINI0D0	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIPT",841,"DXS",2,0)
	;;=INACTIVE
	;;^UTILITY(U,$J,"DIPT",841,"DXS",2,1)
	;;=ACTIVE
	;;^UTILITY(U,$J,"DIPT",841,"F",1)
	;;=.01;S1;""~"Wage";C30;S1~"Non-Wage";C46~"Effective Date";C3~"Status";C20~"Percentage";C30~"Percentage";C46~"Locality Modifier";C61~"--------------";C3~
	;;^UTILITY(U,$J,"DIPT",841,"F",2)
	;;="------";C20~"----------";C30~"----------";C46~"-----------------";C61~
	;;^UTILITY(U,$J,"DIPT",841,"F",3)
	;;=-350.5,^IBE(350.5,^1^S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0);Z;"BASC LOCALITY MODIFIER:"~-350.5,.01;C4;""~-350.5,.04;C20;""~
	;;^UTILITY(U,$J,"DIPT",841,"F",4)
	;;=-350.5,.05;C30;R8;D4;""~-350.5,.06;C46;R8;D4;""~-350.5,.07;C64;R8;D4;""~"";S1~
	;;^UTILITY(U,$J,"DIPT",841,"F",5)
	;;=S X="-",DIP(1)=X,DIP(2)=X,X=$S($D(IOM):IOM,1:80) S X=X,X1=DIP(1) S %=X,X="" Q:X1=""  S $P(X,X1,%\$L(X1)+1)=X1,X=$E(X,1,%) W X K DIP;C1;X;Z;"DUP("-",IOM)"~
	;;^UTILITY(U,$J,"DIPT",841,"H")
	;;=MEDICAL CENTER DIVISION BILLING LIST
	;;^UTILITY(U,$J,"DIPT",841,"IOM")
	;;=80
	;;^UTILITY(U,$J,"DIPT",841,"LAST")
	;;=
	;;^UTILITY(U,$J,"DIPT",841,"ROU")
	;;=^IBXDIVD
	;;^UTILITY(U,$J,"DIPT",841,"ROUOLD")
	;;=IBXDIVD
	;;^UTILITY(U,$J,"DIPT",843,0)
	;;=IB CLK PROD^2920910.1405^@^399^10882^@^2940315
	;;^UTILITY(U,$J,"DIPT",843,"%D",0)
	;;=^^1^1^2920708^^^^
	;;^UTILITY(U,$J,"DIPT",843,"%D",1,0)
	;;=Clerk Productivity Report.
	;;^UTILITY(U,$J,"DIPT",843,"DCL","399^.01")
	;;=!
	;;^UTILITY(U,$J,"DIPT",843,"DCL","399^201")
	;;=&
	;;^UTILITY(U,$J,"DIPT",843,"F",1)
	;;=2;N;L20~.07;L20~1;L12~.13;"CURRENT STATUS";L15~.01;L7~201~
	;;^UTILITY(U,$J,"DIPT",843,"F",2)
	;;=-2,^DPT(^^S I(0,0)=D0 S DIP(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X;Z;"PATIENT:"~-2,.01;L20~-2,.363;"PATIENT ID";L12~
	;;^UTILITY(U,$J,"DIPT",843,"H")
	;;=FULL CLERK PRODUCTIVITY REPORT
	;;^UTILITY(U,$J,"DIPT",848,0)
	;;=IB BILLING CLOCK HEADER^2920116.1055^^351^^^^
	;;^UTILITY(U,$J,"DIPT",848,"%D",0)
	;;=^^1^1^2920708^^
	;;^UTILITY(U,$J,"DIPT",848,"%D",1,0)
	;;=Displays the header for the Patient Billing Clock Inquiry.
	;;^UTILITY(U,$J,"DIPT",848,"DXS",1,9)
	;;=X DXS(1,9.3) S DIP(109)=X S X=9,X=$E(DIP(108),DIP(109),X) S Y=X,X=DIP(107),X=X_Y
	;;^UTILITY(U,$J,"DIPT",848,"DXS",1,9.2)
	;;=S DIP(101)=$S($D(^DPT(D0,0)):^(0),1:"") S X=$P(DIP(101),U,9),DIP(102)=X S X=1,DIP(103)=X S X=3,X=$E(DIP(102),DIP(103),X)_"-",DIP(104)=X S X=$P(DIP(101),U,9)
	;;^UTILITY(U,$J,"DIPT",848,"DXS",1,9.3)
	;;=X DXS(1,9.2) S DIP(105)=X S X=4,DIP(106)=X S X=5,X=$E(DIP(105),DIP(106),X) S Y=X,X=DIP(104),X=X_Y_"-",DIP(107)=X S X=$P(DIP(101),U,9),DIP(108)=X S X=6
	;;^UTILITY(U,$J,"DIPT",848,"F",1)
	;;=.02;L20;C1~-2,^DPT(^^S I(0,0)=D0 S DIP(1)=$S($D(^IBE(351,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X;Z;"PATIENT:"~
	;;^UTILITY(U,$J,"DIPT",848,"F",2)
	;;=-2,X DXS(1,9) W X K DIP;L12;C25;Z;"$E(SOCIAL SECURITY NUMBER,1,3)_"-"_$E(SOCIAL SECURITY NUMBER,4,5)_"-"_$E(SOCIAL SECURITY NUMBER,6,9)"~-2,.03;L12;C41~
	;;^UTILITY(U,$J,"DIPT",848,"F",3)
	;;=-2,391;L22;C57~"================================================================================";C1~
	;;^UTILITY(U,$J,"DIPT",848,"H")
	;;=@
	;;^UTILITY(U,$J,"DIPT",848,"IOM")
	;;=80
	;;^UTILITY(U,$J,"DIPT",848,"LAST")
	;;=
	;;^UTILITY(U,$J,"DIPT",848,"ROU")
	;;=^IBXBCR2
	;;^UTILITY(U,$J,"DIPT",848,"ROUOLD")
	;;=IBXBCR2
	;;^UTILITY(U,$J,"DIPT",848,"SUB")
	;;=1
	;;^UTILITY(U,$J,"DIPT",849,0)
	;;=IB BILLING CLOCK INQ^2920520.0918^@^351^11416^@^2920520
	;;^UTILITY(U,$J,"DIPT",849,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIPT",849,"%D",1,0)
	;;=Displays the Patient Billing Clock Inquiry data.
