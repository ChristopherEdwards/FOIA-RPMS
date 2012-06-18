IBINI00X	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.163,5,1,0)
	;;=36^.161^2
	;;^DD(36,.163,5,2,0)
	;;=36^.162^1
	;;^DD(36,.163,21,0)
	;;=^^1^1^2930715^
	;;^DD(36,.163,21,1,0)
	;;=If this insurance company's outpatient claims office street address is longer than two lines, enter the third line here.
	;;^DD(36,.163,"DT")
	;;=2930715
	;;^DD(36,.164,0)
	;;=CLAIMS (OPT) PROCESS CITY^F^^.16;4^K:$L(X)>25!($L(X)<2) X
	;;^DD(36,.164,3)
	;;=If the outpatient claims process address of this company is different from its main address, enter city of the outpatient claims process address.  Answer must be 2-25 characters in length.
	;;^DD(36,.164,21,0)
	;;=^^1^1^2930715^
	;;^DD(36,.164,21,1,0)
	;;=Enter the city in which this insurance company's outpatient claims office is located.
	;;^DD(36,.164,"DT")
	;;=2930715
	;;^DD(36,.165,0)
	;;=CLAIMS (OPT) PROCESS STATE^P5'^DIC(5,^.16;5^Q
	;;^DD(36,.165,3)
	;;=If the outpatient claims process address of this company is different from its main address, enter state of the outpatient claims address.
	;;^DD(36,.165,21,0)
	;;=^^3^3^2931007^^^^
	;;^DD(36,.165,21,1,0)
	;;=Enter the state in which this insurance company's outpatient claims
	;;^DD(36,.165,21,2,0)
	;;=office is located.  Enter state even if it is the same as the state
	;;^DD(36,.165,21,3,0)
	;;=of the company's main address.
	;;^DD(36,.165,"DT")
	;;=2930715
	;;^DD(36,.166,0)
	;;=CLAIMS (OPT) PROCESS ZIP^FXO^^.16;6^K:$L(X)>20!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
	;;^DD(36,.166,2)
	;;=S Y(0)=Y D ZIPOUT^VAFADDR
	;;^DD(36,.166,2.1)
	;;=D ZIPOUT^VAFADDR
	;;^DD(36,.166,3)
	;;=If the outpatient claims process address of this company is different from its main address, enter zip code of the outpatient claims process address.  Answer with either 5 digit or 9 digit zip code.
	;;^DD(36,.166,21,0)
	;;=^^1^1^2930816^^^^
	;;^DD(36,.166,21,1,0)
	;;=Answer with either the 5 digit zip code (format 12345) or with the 9 digit zip code (in format 123456789 or 12345-6789).
	;;^DD(36,.166,"DT")
	;;=2930816
	;;^DD(36,.167,0)
	;;=CLAIMS (OPT) COMPANY NAME^*P36'X^DIC(36,^.16;7^S DIC(0)=DIC(0)_"F",DIC("S")="I '$P(^(0),U,5),'$P($G(^(.16)),U,7),Y'=DA" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.167,3)
	;;=
	;;^DD(36,.167,5,1,0)
	;;=36^.168^1
	;;^DD(36,.167,12)
	;;=Select an active Insurance Company that will process Outpatient Claims for this company.  It may not be this company or have another company process outpatient claims for it.
	;;^DD(36,.167,12.1)
	;;=S DIC("S")="I '$P(^(0),U,5),'$P($G(^(.16)),U,7),Y'=DA"
	;;^DD(36,.167,21,0)
	;;=^^4^4^2931006^^^^
	;;^DD(36,.167,21,1,0)
	;;=You can only select a company that processes claims.  The company
	;;^DD(36,.167,21,2,0)
	;;=specified in this field must be an active insurance company, not the
	;;^DD(36,.167,21,3,0)
	;;=same company as the entry being edited, and must not have another
	;;^DD(36,.167,21,4,0)
	;;=company specified as handling Outpatient Claims for it.
	;;^DD(36,.167,"DT")
	;;=2931001
	;;^DD(36,.168,0)
	;;=ANOTHER CO. PROCESS CLAIMS?^S^0:NO;1:YES;^.16;8^Q
	;;^DD(36,.168,.1)
	;;=Are Outpatient Claims Processed by Another Insurance Co.?
	;;^DD(36,.168,1,0)
	;;=^.1
	;;^DD(36,.168,1,1,0)
	;;=^^TRIGGER^36^.167
	;;^DD(36,.168,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$P($G(^DIC(36,DA,.16)),"^",8) I X S X=DIV S Y(1)=$S($D(^DIC(36,D0,.16)):^(.16),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" X ^DD(36,.168,1,1,1.4)
	;;^DD(36,.168,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.16)):^(.16),1:""),DIV=X S $P(^(.16),U,7)=DIV,DIH=36,DIG=.167 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.168,1,1,2)
	;;=Q
