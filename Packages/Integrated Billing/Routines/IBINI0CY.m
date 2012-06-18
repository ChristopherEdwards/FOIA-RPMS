IBINI0CY	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIPT",838,"DXS",2,9.2)
	;;=F D=0:0 S (D,D0)=$N(^IBE(350.71,"G",I(0,0),D)) Q:D'>0  I $D(^IBE(350.71,D,0)) S X=$P(^(0),U,1) S DIXX=DIXX(1) D M Q:'$D(D)  S D=D0
	;;^UTILITY(U,$J,"DIPT",838,"DXS",3,0)
	;;=NO
	;;^UTILITY(U,$J,"DIPT",838,"DXS",3,1)
	;;=YES
	;;^UTILITY(U,$J,"DIPT",838,"DXS",4,2)
	;;=TWO VERTICAL
	;;^UTILITY(U,$J,"DIPT",838,"DXS",4,3)
	;;=THREE VERTICAL
	;;^UTILITY(U,$J,"DIPT",838,"DXS",5,1)
	;;=CODE/NAME/$
	;;^UTILITY(U,$J,"DIPT",838,"DXS",5,2)
	;;=NAME/CODE/$
	;;^UTILITY(U,$J,"DIPT",838,"F",1)
	;;=.01;C1;L59;S1;""~"CHARGE";C5;S1~"DISPLAYED";C5~"# OF COLUMNS";C16~"LINE FORMAT";C33~"ASSOCIATED CLINICS";C47~"---------";C5~"------------";C16~
	;;^UTILITY(U,$J,"DIPT",838,"F",2)
	;;="-----------";C33~"------------------";C47~.02;C8;""~.03;C16;""~.04;C33;""~
	;;^UTILITY(U,$J,"DIPT",838,"F",3)
	;;=S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0) W X K DIP;C47;"";m;Z;"HOSPITAL LOCATION"~"SUB-HEADER";C5;S1~"PRINT ORDER";C67~
	;;^UTILITY(U,$J,"DIPT",838,"F",4)
	;;="----------";C5~"-----------";C67~-350.71,^IBE(350.71,^1^S I(0,0)=$S($D(D0):D0,1:"") X DXS(2,9.2) S X="" S D0=I(0,0);Z;"AMBULATORY SURG. CHECK:"~
	;;^UTILITY(U,$J,"DIPT",838,"F",5)
	;;=-350.71,.01;C5;L59;""~-350.71,.02;C67;R7;""~
	;;^UTILITY(U,$J,"DIPT",838,"F",6)
	;;=S X="-",DIP(1)=X,DIP(2)=X,X=$S($D(IOM):IOM,1:80) S X=X,X1=DIP(1) S %=X,X="" Q:X1=""  S $P(X,X1,%\$L(X1)+1)=X1,X=$E(X,1,%) W X K DIP;C1;S1;"";Z;"DUP("-",IOM)"~
	;;^UTILITY(U,$J,"DIPT",838,"H")
	;;=AMBULATORY SURGERY CHECK-OFF SHEET
	;;^UTILITY(U,$J,"DIPT",838,"IOM")
	;;=80
	;;^UTILITY(U,$J,"DIPT",838,"LAST")
	;;=
	;;^UTILITY(U,$J,"DIPT",838,"ROU")
	;;=^IBXCPTG
	;;^UTILITY(U,$J,"DIPT",838,"ROUOLD")
	;;=IBXCPTG
	;;^UTILITY(U,$J,"DIPT",839,0)
	;;=IB CPT CP DISPLAY^2920205.172^@^350.71^10882^@^2920608
	;;^UTILITY(U,$J,"DIPT",839,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIPT",839,"%D",1,0)
	;;=Displays procedures associated with a particular Check-off Sheet sub-header.
	;;^UTILITY(U,$J,"DIPT",839,"DXS",1,9.2)
	;;=F D=0:0 S (D,D0)=$N(^IBE(350.71,"S",I(0,0),D)) Q:D'>0  I $D(^IBE(350.71,D,0)) S X=$P(^(0),U,1) S DIXX=DIXX(1) D M Q:'$D(D)  S D=D0
	;;^UTILITY(U,$J,"DIPT",839,"DXS",2,9.2)
	;;=S I(100,0)=$S($D(D0):D0,1:""),DIP(101)=$S($D(^IBE(350.71,D0,0)):^(0),1:""),D0=$P(DIP(101),U,6) S:'$D(^SD(409.71,+D0,0)) D0=-1 S DIP(201)=$S($D(^SD(409.71,D0,0)):^(0),1:"")
	;;^UTILITY(U,$J,"DIPT",839,"F",1)
	;;=.01;C1;L59;S1;""~"CHECK-OFF SHEET";C2;S1~"PRINT ORDER";C61~"---------------";C2~"-----------";C61~.04;C2;""~.02;C61;R7;""~"PROCEDURES";C2;S1~
	;;^UTILITY(U,$J,"DIPT",839,"F",2)
	;;="PRINT ORDER";C61~"CHARGE";C74~"----------";C2~"-----------";C61~"------";C74~
	;;^UTILITY(U,$J,"DIPT",839,"F",3)
	;;=-350.71,^IBE(350.71,^1^S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0);Z;"AMBULATORY SURG. CHECK:"~
	;;^UTILITY(U,$J,"DIPT",839,"F",4)
	;;=-350.71,X DXS(2,9.2) S X=$S('$D(^ICPT(+$P(DIP(201),U,1),0)):"",1:$P(^(0),U,1)) S D0=I(100,0) W X K DIP;C2;"";Z;"PROCEDURE:CODE"~-350.71,.01;C9;L51;""~
	;;^UTILITY(U,$J,"DIPT",839,"F",5)
	;;=-350.71,.02;C61;R7;""~-350.71,.08;C72;R8;""~
	;;^UTILITY(U,$J,"DIPT",839,"F",6)
	;;=S X="-",DIP(1)=X,DIP(2)=X,X=$S($D(IOM):IOM,1:80) S X=X,X1=DIP(1) S %=X,X="" Q:X1=""  S $P(X,X1,%\$L(X1)+1)=X1,X=$E(X,1,%) W X K DIP;C1;S1;"";Z;"DUP("-",IOM)"~
	;;^UTILITY(U,$J,"DIPT",839,"H")
	;;=AMB. SURG. CHECK-OFF SHEET PRINT FIELDS LIST
	;;^UTILITY(U,$J,"DIPT",839,"IOM")
	;;=80
	;;^UTILITY(U,$J,"DIPT",839,"LAST")
	;;=
	;;^UTILITY(U,$J,"DIPT",839,"ROU")
	;;=^IBXCPTC
	;;^UTILITY(U,$J,"DIPT",839,"ROUOLD")
	;;=IBXCPTC
