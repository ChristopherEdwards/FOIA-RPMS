IBINI00V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.156,"DT")
	;;=2930226
	;;^DD(36,.157,0)
	;;=INQUIRY COMPANY NAME^*P36'X^DIC(36,^.15;7^S DIC(0)=DIC(0)_"F",DIC("S")="I '$P(^(0),U,5),'$P($G(^(.15)),U,7),(Y'=DA)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.157,3)
	;;=
	;;^DD(36,.157,5,1,0)
	;;=36^.158^1
	;;^DD(36,.157,12)
	;;=Select a company that processes inquiries for this company.  Must be active, not this company, and process its own inquiries.
	;;^DD(36,.157,12.1)
	;;=S DIC("S")="I '$P(^(0),U,5),'$P($G(^(.15)),U,7),(Y'=DA)"
	;;^DD(36,.157,21,0)
	;;=^^4^4^2931006^^^
	;;^DD(36,.157,21,1,0)
	;;=You can only select a company that processes Inquiries.  The company
	;;^DD(36,.157,21,2,0)
	;;=specified in this field must be an active insurance company, not the
	;;^DD(36,.157,21,3,0)
	;;=same company as the entry being edited, and must not have another
	;;^DD(36,.157,21,4,0)
	;;=company specified as handling Inquiries for it.
	;;^DD(36,.157,"DT")
	;;=2931008
	;;^DD(36,.158,0)
	;;=ANOTHER CO. PROCESS INQUIRIES?^S^0:NO;1:YES;^.15;8^Q
	;;^DD(36,.158,.1)
	;;=Are Inquiries Processed by Another Insurance Co.?
	;;^DD(36,.158,1,0)
	;;=^.1
	;;^DD(36,.158,1,1,0)
	;;=^^TRIGGER^36^.157
	;;^DD(36,.158,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$P($G(^DIC(36,DA,.15)),"^",8) I X S X=DIV S Y(1)=$S($D(^DIC(36,D0,.15)):^(.15),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" X ^DD(36,.158,1,1,1.4)
	;;^DD(36,.158,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.15)):^(.15),1:""),DIV=X S $P(^(.15),U,7)=DIV,DIH=36,DIG=.157 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.158,1,1,2)
	;;=Q
	;;^DD(36,.158,1,1,"CREATE CONDITION")
	;;=S X='$P($G(^DIC(36,DA,.15)),"^",8)
	;;^DD(36,.158,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.158,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(36,.158,1,1,"FIELD")
	;;=#.157
	;;^DD(36,.158,21,0)
	;;=^^1^1^2931007^^
	;;^DD(36,.158,21,1,0)
	;;=Enter "Yes" if another insurance company processes Inquiries.
	;;^DD(36,.158,"DT")
	;;=2931007
	;;^DD(36,.159,0)
	;;=INQUIRY FAX^F^^.15;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.159,3)
	;;=Enter the fax number of this insurance carrier's inquiries office with 7 - 20 characters, ex. 999-9999, 999-999-9999.
	;;^DD(36,.159,21,0)
	;;=^^1^1^2931122^^
	;;^DD(36,.159,21,1,0)
	;;=Enter the fax number of the inquiries office of this insurance carrier.
	;;^DD(36,.159,"DT")
	;;=2931122
	;;^DD(36,.16,0)
	;;=REPOINT PATIENTS TO^P36^DIC(36,^0;16^Q
	;;^DD(36,.16,9)
	;;=^
	;;^DD(36,.16,21,0)
	;;=^^2^2^2940228^^
	;;^DD(36,.16,21,1,0)
	;;=If an insurance company has been inactivated and the patients repointed
	;;^DD(36,.16,21,2,0)
	;;=to another company then this is the company that they are assigned.
	;;^DD(36,.16,23,0)
	;;=^^1^1^2940228^
	;;^DD(36,.16,23,1,0)
	;;=This field will be maintained by the computer.  Do not manually enter/edit.
	;;^DD(36,.16,"DT")
	;;=2940228
	;;^DD(36,.161,0)
	;;=CLAIMS (OPT) STREET ADDRESS 1^F^^.16;1^K:$L(X)>35!($L(X)<3) X
	;;^DD(36,.161,1,0)
	;;=^.1
	;;^DD(36,.161,1,1,0)
	;;=^^TRIGGER^36^.162
	;;^DD(36,.161,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.16)):^(.16),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.161,1,1,1.4)
	;;^DD(36,.161,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.16)):^(.16),1:""),DIV=X S $P(^(.16),U,2)=DIV,DIH=36,DIG=.162 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.161,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.16)):^(.16),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.161,1,1,2.4)
	;;^DD(36,.161,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.16)):^(.16),1:""),DIV=X S $P(^(.16),U,2)=DIV,DIH=36,DIG=.162 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
