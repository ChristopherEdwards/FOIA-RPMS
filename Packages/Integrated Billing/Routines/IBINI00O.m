IBINI00O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.126,21,0)
	;;=^^1^1^2930816^^^^
	;;^DD(36,.126,21,1,0)
	;;=Answer with either the 5 digit zip code (format 12345) or with the 9 digit zip code (in format 123456789 or 12345-6789).
	;;^DD(36,.126,"DT")
	;;=2930715
	;;^DD(36,.127,0)
	;;=CLAIMS (INPT) COMPANY NAME^*P36'X^DIC(36,^.12;7^S DIC(0)=DIC(0)_"F",DIC("S")="I '$P(^(0),U,5),'$P($G(^(.12)),U,7),(Y'=DA)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.127,3)
	;;=
	;;^DD(36,.127,5,1,0)
	;;=36^.128^1
	;;^DD(36,.127,12)
	;;=Select a company that processes inpatient claims for this company.  Must be active, not this company, and process its own inpatient claims.
	;;^DD(36,.127,12.1)
	;;=S DIC("S")="I '$P(^(0),U,5),'$P($G(^(.12)),U,7),(Y'=DA)"
	;;^DD(36,.127,21,0)
	;;=^^4^4^2931008^^^^
	;;^DD(36,.127,21,1,0)
	;;=You can only select a company that processes claims.  The company
	;;^DD(36,.127,21,2,0)
	;;=specified in this field must be an active insurance company, not the
	;;^DD(36,.127,21,3,0)
	;;=same company as the entry being edited, and must not have another
	;;^DD(36,.127,21,4,0)
	;;=company specified as handling Inpatient Claims for it.
	;;^DD(36,.127,"DT")
	;;=2931005
	;;^DD(36,.128,0)
	;;=ANOTHER CO. PROCESS CLAIMS?^S^0:NO;1:YES;^.12;8^Q
	;;^DD(36,.128,.1)
	;;=Are Inpatient Claims Processed by Another Insurance Co.?
	;;^DD(36,.128,1,0)
	;;=^.1
	;;^DD(36,.128,1,1,0)
	;;=^^TRIGGER^36^.127
	;;^DD(36,.128,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$P($G(^DIC(36,DA,.12)),"^",8) I X S X=DIV S Y(1)=$S($D(^DIC(36,D0,.12)):^(.12),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" X ^DD(36,.128,1,1,1.4)
	;;^DD(36,.128,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.12)):^(.12),1:""),DIV=X S $P(^(.12),U,7)=DIV,DIH=36,DIG=.127 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.128,1,1,2)
	;;=Q
	;;^DD(36,.128,1,1,"%D",0)
	;;=^^1^1^2931005^^
	;;^DD(36,.128,1,1,"%D",1,0)
	;;=Enter "Yes" if another insurance company processes Inpatient Claims.
	;;^DD(36,.128,1,1,"CREATE CONDITION")
	;;=S X='$P($G(^DIC(36,DA,.12)),"^",8)
	;;^DD(36,.128,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.128,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(36,.128,1,1,"DT")
	;;=2931005
	;;^DD(36,.128,1,1,"FIELD")
	;;=#.127
	;;^DD(36,.128,21,0)
	;;=^^1^1^2940121^^^
	;;^DD(36,.128,21,1,0)
	;;=Enter "Yes" if another insurance company processes Inpatient Claims.
	;;^DD(36,.128,"DT")
	;;=2931007
	;;^DD(36,.129,0)
	;;=CLAIMS (INPT) FAX^F^^.12;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.129,3)
	;;=Enter the fax number of the inpatient claims office with 7-20 characters, e.g. 444-8888, 614-333-9999.
	;;^DD(36,.129,21,0)
	;;=^^1^1^2931122^
	;;^DD(36,.129,21,1,0)
	;;=Enter the fax number of this insurance carrier's inpatient claims office.
	;;^DD(36,.129,"DT")
	;;=2931122
	;;^DD(36,.13,0)
	;;=TYPE OF COVERAGE^P355.2'^IBE(355.2,^0;13^Q
	;;^DD(36,.13,21,0)
	;;=^^11^11^2940209^^
	;;^DD(36,.13,21,1,0)
	;;=If this insurance carrier provides only one type of coverage then select
	;;^DD(36,.13,21,2,0)
	;;=the entry that best describes this carriers type of coverage.  If this
	;;^DD(36,.13,21,3,0)
	;;=carrier provides more than one type of coverage then select HEALTH
	;;^DD(36,.13,21,4,0)
	;;=INSURANCE.  The default answer if left unanswered is Health Insurance.
	;;^DD(36,.13,21,5,0)
	;;= 
	;;^DD(36,.13,21,6,0)
	;;=This is useful information when contacting carriers, when creating 
	;;^DD(36,.13,21,7,0)
	;;=claims for reimbursement and when estimating if the payment received is
	;;^DD(36,.13,21,8,0)
	;;=appropriate.
	;;^DD(36,.13,21,9,0)
	;;= 
	;;^DD(36,.13,21,10,0)
	;;=If this field is answered it may affect choices that can be selected when
