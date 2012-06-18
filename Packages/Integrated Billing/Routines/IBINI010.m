IBINI010	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.185,"DT")
	;;=2940103
	;;^DD(36,.186,0)
	;;=CLAIMS (RX) ZIP^FXO^^.18;6^K:$L(X)>20!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
	;;^DD(36,.186,2)
	;;=S Y(0)=Y D ZIPOUT^VAFADDR
	;;^DD(36,.186,2.1)
	;;=D ZIPOUT^VAFADDR
	;;^DD(36,.186,3)
	;;=If the prescription claims address of this company is different from its main address, enter zip code of the prescription claims address.  Answer with either 5 digit or 9 digit zip code.
	;;^DD(36,.186,21,0)
	;;=^^1^1^2940103^
	;;^DD(36,.186,21,1,0)
	;;=Answer with either the 5 digit zip code (format 12345) or with the 9 digit zip code (in format 123456789 or 12345-6789).
	;;^DD(36,.186,"DT")
	;;=2940104
	;;^DD(36,.187,0)
	;;=CLAIMS (RX) COMPANY NAME^*P36'X^DIC(36,^.18;7^S DIC(0)=DIC(0)_"F",DIC("S")="I '$P(^(0),U,5),'$P($G(^(.18)),U,7),(Y'=DA)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.187,5,1,0)
	;;=36^.188^1
	;;^DD(36,.187,12)
	;;=Select a company that processes prescription claims for this company.  Must be active, not this company, and process its own prescription claims.
	;;^DD(36,.187,12.1)
	;;=S DIC("S")="I '$P(^(0),U,5),'$P($G(^(.18)),U,7),(Y'=DA)"
	;;^DD(36,.187,21,0)
	;;=^^4^4^2940103^
	;;^DD(36,.187,21,1,0)
	;;=You can only select a company that processes Prescriptions.  The company
	;;^DD(36,.187,21,2,0)
	;;=specified in this field must be an active insurance company, not the
	;;^DD(36,.187,21,3,0)
	;;=same company as the entry being edited, and must not have another company
	;;^DD(36,.187,21,4,0)
	;;=specified as handling Prescriptions for it.
	;;^DD(36,.187,"DT")
	;;=2940104
	;;^DD(36,.188,0)
	;;=ANOTHER CO. PROCESS RX CLAIMS?^S^0:NO;1:YES;^.18;8^Q
	;;^DD(36,.188,.1)
	;;=Are Rx Claims Processed by Another Insurance Co.?
	;;^DD(36,.188,1,0)
	;;=^.1
	;;^DD(36,.188,1,1,0)
	;;=^^TRIGGER^36^.187
	;;^DD(36,.188,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$P($G(^DIC(36,DA,.18)),"^",8) I X S X=DIV S Y(1)=$S($D(^DIC(36,D0,.18)):^(.18),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" X ^DD(36,.188,1,1,1.4)
	;;^DD(36,.188,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.18)):^(.18),1:""),DIV=X S $P(^(.18),U,7)=DIV,DIH=36,DIG=.187 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.188,1,1,2)
	;;=Q
	;;^DD(36,.188,1,1,"%D",0)
	;;=^^1^1^2940104^
	;;^DD(36,.188,1,1,"%D",1,0)
	;;=Enter "Yes" if another insurance company processes prescription claims.
	;;^DD(36,.188,1,1,"CREATE CONDITION")
	;;=S X='$P($G(^DIC(36,DA,.18)),"^",8)
	;;^DD(36,.188,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.188,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(36,.188,1,1,"FIELD")
	;;=#.187
	;;^DD(36,.188,21,0)
	;;=^^1^1^2940121^^^
	;;^DD(36,.188,21,1,0)
	;;=Enter "Yes" if another insurance company processes prescription claims.
	;;^DD(36,.188,"DT")
	;;=2940104
	;;^DD(36,.189,0)
	;;=CLAIMS (RX) FAX^F^^.18;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.189,3)
	;;=Enter the fax number of the prescription claims office with 7-20 characters, ex. 999-9999, 999-999-9999.
	;;^DD(36,.189,21,0)
	;;=^^1^1^2940103^^
	;;^DD(36,.189,21,1,0)
	;;=Enter the fax number of the prescription claims office of this insurance carrier.
	;;^DD(36,.189,"DT")
	;;=2940103
	;;^DD(36,1,0)
	;;=REIMBURSE?^RS^Y:WILL REIMBURSE;*:WILL REIMBURSE IF TREATED UNDER VAR 6046(C) OR VAR 6060.2(A);**:DEPENDS ON POLICY, CHECK WITH COMPANY;N:WILL NOT REIMBURSE;^0;2^Q
	;;^DD(36,1,21,0)
	;;=^^3^3^2930927^^
	;;^DD(36,1,21,1,0)
	;;=Choose from the available list of choices the appropriate code denoting
	;;^DD(36,1,21,2,0)
	;;=whether or not and under which circumstances this insurance carrier will
	;;^DD(36,1,21,3,0)
	;;=reimburse the Dept of Veterans Affairs for care received.
