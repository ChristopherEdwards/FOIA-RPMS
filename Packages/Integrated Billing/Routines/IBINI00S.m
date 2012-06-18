IBINI00S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.144,21,0)
	;;=^^2^2^2930607^^
	;;^DD(36,.144,21,1,0)
	;;=Enter the city in which the appeals office of this insurance company
	;;^DD(36,.144,21,2,0)
	;;=is located.
	;;^DD(36,.144,"DT")
	;;=2930225
	;;^DD(36,.145,0)
	;;=APPEALS ADDRESS STATE^P5'^DIC(5,^.14;5^Q
	;;^DD(36,.145,3)
	;;=If the appeals address of this company is different from its main address, enter state of the appeals address.
	;;^DD(36,.145,21,0)
	;;=^^3^3^2931007^^^^
	;;^DD(36,.145,21,1,0)
	;;=Enter the state in which the appeals office of this insurance
	;;^DD(36,.145,21,2,0)
	;;=company is located.  Enter state even if it is the same as the state
	;;^DD(36,.145,21,3,0)
	;;=of the company's main address.
	;;^DD(36,.145,22)
	;;=DESCR
	;;^DD(36,.145,"DT")
	;;=2931007
	;;^DD(36,.146,0)
	;;=APPEALS ADDRESS ZIP^FXO^^.14;6^K:$L(X)>20!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
	;;^DD(36,.146,2)
	;;=S Y(0)=Y D ZIPOUT^VAFADDR
	;;^DD(36,.146,2.1)
	;;=D ZIPOUT^VAFADDR
	;;^DD(36,.146,3)
	;;=If the appeals address of this company is different from its main address, enter zip code of the appeals address.  Answer with either 5 digit or 9 digit zip code.
	;;^DD(36,.146,21,0)
	;;=2^^2^2^2930226^^^^
	;;^DD(36,.146,21,1,0)
	;;=Answer with either the 5 digit zip code (format 12345) or with the 9 
	;;^DD(36,.146,21,2,0)
	;;=digit zip code (in format 123456789 or 12345-6789).
	;;^DD(36,.146,"DT")
	;;=2930226
	;;^DD(36,.147,0)
	;;=APPEALS COMPANY NAME^*P36'X^DIC(36,^.14;7^S DIC(0)=DIC(0)_"F",DIC("S")="I '$P(^(0),U,5),'$P($G(^(.14)),U,7),(Y'=DA)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.147,3)
	;;=
	;;^DD(36,.147,5,1,0)
	;;=36^.148^1
	;;^DD(36,.147,12)
	;;=Select a company that processes inpatient claims for this company.  Must be active, not this company, and process its own inpatient claims.
	;;^DD(36,.147,12.1)
	;;=S DIC("S")="I '$P(^(0),U,5),'$P($G(^(.14)),U,7),(Y'=DA)"
	;;^DD(36,.147,21,0)
	;;=^^4^4^2931006^^^
	;;^DD(36,.147,21,1,0)
	;;=You can only select a company that processes Appeals.  The company
	;;^DD(36,.147,21,2,0)
	;;=specified in this field must be an active insurance company, not the
	;;^DD(36,.147,21,3,0)
	;;=same company as the entry being edited, and must not have another
	;;^DD(36,.147,21,4,0)
	;;=company specified as handling Appeals for it.
	;;^DD(36,.147,"DT")
	;;=2931006
	;;^DD(36,.148,0)
	;;=ANOTHER CO. PROCESS APPEALS?^S^0:NO;1:YES;^.14;8^Q
	;;^DD(36,.148,.1)
	;;=Are Appeals Processed by Another Insurance Co.?
	;;^DD(36,.148,1,0)
	;;=^.1
	;;^DD(36,.148,1,1,0)
	;;=^^TRIGGER^36^.147
	;;^DD(36,.148,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$P($G(^DIC(36,DA,.14)),"^",8) I X S X=DIV S Y(1)=$S($D(^DIC(36,D0,.14)):^(.14),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" X ^DD(36,.148,1,1,1.4)
	;;^DD(36,.148,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.14)):^(.14),1:""),DIV=X S $P(^(.14),U,7)=DIV,DIH=36,DIG=.147 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.148,1,1,2)
	;;=Q
	;;^DD(36,.148,1,1,"CREATE CONDITION")
	;;=S X='$P($G(^DIC(36,DA,.14)),"^",8)
	;;^DD(36,.148,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.148,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(36,.148,1,1,"DT")
	;;=2931006
	;;^DD(36,.148,1,1,"FIELD")
	;;=#.147
	;;^DD(36,.148,21,0)
	;;=^^1^1^2931007^^^
	;;^DD(36,.148,21,1,0)
	;;=Enter "Yes" if another insurance company processes appeals.
	;;^DD(36,.148,"DT")
	;;=2931007
	;;^DD(36,.149,0)
	;;=APPEALS FAX^F^^.14;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.149,3)
	;;=Enter the fax number of this insurance carrier's appeals office with 7 - 20 characters, ex. 999-999, 999-999-9999.
	;;^DD(36,.149,21,0)
	;;=^^1^1^2931122^^^
