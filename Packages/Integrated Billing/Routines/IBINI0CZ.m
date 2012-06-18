IBINI0CZ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIPT",840,0)
	;;=IB CPT RG DISPLAY^2920206.0912^@^409.71^10882^@^2920708
	;;^UTILITY(U,$J,"DIPT",840,"%D",0)
	;;=^^1^1^2920708^^^
	;;^UTILITY(U,$J,"DIPT",840,"%D",1,0)
	;;=Displays billing medicare rate group data for a procedure.
	;;^UTILITY(U,$J,"DIPT",840,"DXS",1,9)
	;;=S I(0,0)=$S($D(D0):D0,1:""),DIP(1)=$S($D(^SD(409.71,D0,0)):^(0),1:""),D0=$P(DIP(1),U,1) S:'$D(^ICPT(+D0,0)) D0=-1 X DXS(1,9.2):D0>0 S X="" S D0=I(0,0)
	;;^UTILITY(U,$J,"DIPT",840,"DXS",1,9.2)
	;;=S I(100)="^ICPT(",J(100)=81 F D=0:0 S (D,D1)=$N(^ICPT(D0,"D",D)) Q:D'>0  I $D(^(D,0))#2 S X=$P(^(0),U,1) X DICMX Q:'$D(D)  S D=D1
	;;^UTILITY(U,$J,"DIPT",840,"DXS",2,9.2)
	;;=F D=0:0 S (D,D0)=$N(^IBE(350.4,"C",I(0,0),D)) Q:D'>0  I $D(^IBE(350.4,D,0)) S X=$P(^(0),U,1),Y=X D D^DIQ S X=Y S DIXX=DIXX(1) D M Q:'$D(D)  S D=D0
	;;^UTILITY(U,$J,"DIPT",840,"DXS",3,9.2)
	;;=S DIP(101)=$S($D(^IBE(350.4,D0,0)):^(0),1:"") S X=$S('$D(^IBE(350.1,+$P(DIP(101),U,3),0)):"",1:$P(^(0),U,1)),DIP(102)=X S X=" ",DIP(103)=X S X=2,DIP(104)=X S X=999
	;;^UTILITY(U,$J,"DIPT",840,"DXS",4,9)
	;;=S IBDTX=$P(^IBE(350.4,D0,0),U,1) S:$D(IBDIV) IBDIVX=IBDIV D FMCD^IBEFUNC1 W:$D(^DG(40.8,+IBDIVX,0)) $E($P(^DG(40.8,+IBDIVX,0),U,1),1,15)
	;;^UTILITY(U,$J,"DIPT",840,"DXS",5,9)
	;;=S IBCDX=$P(^IBE(350.4,D0,0),U,2) D FCC^IBEFUNC1 W:IBCHGX'="" $J(IBCHGX,8,2) K IBDTX,IBDIVX,IBCDX,IBCHGX
	;;^UTILITY(U,$J,"DIPT",840,"DXS",6,0)
	;;=INACTIVE
	;;^UTILITY(U,$J,"DIPT",840,"DXS",6,1)
	;;=ACTIVE
	;;^UTILITY(U,$J,"DIPT",840,"F",1)
	;;="CPT/HCFA Code";C1;S1~"Current OPC Status";C63~"--------------";C1~"------------------";C63~.01;C1;""~
	;;^UTILITY(U,$J,"DIPT",840,"F",2)
	;;=X $P(^DD(409.71,.015,0),U,5,99) S DIP(1)=X S X="- "_DIP(1) W X K DIP;C7;"";Z;""- "_SHORT NAME"~205;"";C50;R31~
	;;^UTILITY(U,$J,"DIPT",840,"F",3)
	;;=X DXS(1,9) W X K DIP;C5;S1;"";m;Z;"CODE:DESCRIPTION"~"Effective Date";C2;S1~"Billing Status";C18~"Billing Group";C34~"Division";C56~"Charge";C74~
	;;^UTILITY(U,$J,"DIPT",840,"F",4)
	;;="--------------";C2~"--------------";C18~"--------------";C34~"--------";C56~"------";C74~
	;;^UTILITY(U,$J,"DIPT",840,"F",5)
	;;=-350.4,^IBE(350.4,^1^S I(0,0)=$S($D(D0):D0,1:"") X DXS(2,9.2) S X="" S D0=I(0,0);Z;"BILLABLE AMBULATORY SURGICAL:"~-350.4,.01;C2;""~-350.4,.04;C18;""~
	;;^UTILITY(U,$J,"DIPT",840,"F",6)
	;;=-350.4,X DXS(3,9.2) S X=$P(DIP(102),DIP(103),DIP(104),X) W X K DIP;C34;L19;"";Z;"$P(RATE GROUP," ",2,999)"~
	;;^UTILITY(U,$J,"DIPT",840,"F",7)
	;;=-350.4,X DXS(4,9);C56;"";Z;"S IBDTX=$P(^IBE(350.4,D0,0),U,1) S:$D(IBDIV) IBDIVX=IBDIV D FMCD^IBEFUNC1 W:$D(^DG(40.8,+IBDIVX,0)) $E($P(^DG(40.8,+IBDIVX,0),U,1),1,15)"~
	;;^UTILITY(U,$J,"DIPT",840,"F",8)
	;;=-350.4,X DXS(5,9);C72;X;"";Z;"S IBCDX=$P(^IBE(350.4,D0,0),U,2) D FCC^IBEFUNC1 W:IBCHGX'="" $J(IBCHGX,8,2) K IBDTX,IBDIVX,IBCDX,IBCHGX"~
	;;^UTILITY(U,$J,"DIPT",840,"F",9)
	;;=S X="-",DIP(1)=X,DIP(2)=X,X=$S($D(IOM):IOM,1:80) S X=X,X1=DIP(1) S %=X,X="" Q:X1=""  S $P(X,X1,%\$L(X1)+1)=X1,X=$E(X,1,%) W X K DIP;C1;S1;X;Z;"DUP("-",IOM)"~
	;;^UTILITY(U,$J,"DIPT",840,"H")
	;;=AMBULATORY PROCEDURE BILLING LIST
	;;^UTILITY(U,$J,"DIPT",840,"IOM")
	;;=80
	;;^UTILITY(U,$J,"DIPT",840,"LAST")
	;;=
	;;^UTILITY(U,$J,"DIPT",840,"ROU")
	;;=^IBXCPTR
	;;^UTILITY(U,$J,"DIPT",840,"ROUOLD")
	;;=IBXCPTR
	;;^UTILITY(U,$J,"DIPT",841,0)
	;;=IB DIVISION DISPLAY^2920205.1722^@^40.8^10882^@^2930406
	;;^UTILITY(U,$J,"DIPT",841,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIPT",841,"%D",1,0)
	;;=Displays wage rates and locality modifer data for a division.
	;;^UTILITY(U,$J,"DIPT",841,"DXS",1,9.2)
	;;=F D=0:0 S (D,D0)=$N(^IBE(350.5,"C",I(0,0),D)) Q:D'>0  I $D(^IBE(350.5,D,0)) S X=$P(^(0),U,1),Y=X D D^DIQ S X=Y S DIXX=DIXX(1) D M Q:'$D(D)  S D=D0
