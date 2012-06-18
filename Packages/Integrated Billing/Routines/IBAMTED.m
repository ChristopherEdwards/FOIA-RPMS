IBAMTED	;ALB/CPM - MEANS TEST EVENT DRIVER INTERFACE ; 21-FEB-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	; -- do medication copayment exemption processing
	D ^IBAMTED1
	;
	; Quit if supported variables are unavailable.
	Q:'$D(DFN)!('$D(DGMTA))!('$D(DGMTP))!('$D(DUZ))!('$D(DGMTINF))
	;
	;***
	;S XRTL=$ZU(0),XRTN="IBAMTED-1" D T0^%ZOSV ;start rt clock
	;
	; -- quit if copay exemption test
	I $P(DGMTA,"^",19)=2!($P(DGMTP,"^",19)=2) G END
	;
	; Quit if test is a Category change resulting from a deleted test.
	I DGMTA]"",DGMTP]"",+DGMTA'=+DGMTP G END
	;
	; Quit if the most current Means Test was not altered.
	S IBMT=$S(DGMTA="":DGMTP,1:DGMTA)
	S X=$$LST^DGMTU(DFN) I X,$P(X,"^",2)>+IBMT G END
	;
	; Quit if an added or deleted test is a Required test.
	I (DGMTA=""!(DGMTP="")),$P(IBMT,"^",3)=1 G END
	;
	; Determine the billable status before and after the transaction.
	D NOW^%DTC S IBCATCA=$$BIL^DGMTUB(DFN,%)
	S IBCATCP=$S(DGMTP="":$$ADD,DGMTA="":$$CK^DGMTUB(DGMTP),1:$$EDIT)
	;
	; Generate a bulletin if the patient's billing status has changed.
	I (IBCATCP&('IBCATCA))!('IBCATCP&(IBCATCA)) D
	.S IBEFDT=$S($P(IBMT,"^",7):+$P(IBMT,"^",7),1:+IBMT)
	.I IBCATCP,'IBCATCA,'$$CHG^IBAMTEDU(IBEFDT) Q  ; hasn't been billed since going c->a
	.I 'IBCATCP,IBCATCA,'$$EP^IBAMTEDU(IBEFDT) Q  ; hasn't been treated since going a->c
	.D MT^IBAMTBU2 ; create bulletin
	;
END	K IBARR,IBCANCEL,IBCATCA,IBCATCP,IBDIQ,IBDUZ,IBEFDT,IBMT,IBI,IBC,IBPT,IBT
	K DIC,DIQ,DR,DA,VA,VAERR,VAEL,X,X1,X2,XMDUZ,XMTEXT,XMY,XMSUB
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBAMTED" D T1^%ZOSV ;stop rt clock
	Q
	;
	;
ADD()	; Determine the billable status before adding a Means Test.
	S X1=$S($P(DGMTA,"^",3)=3:+DGMTA,1:+$P(DGMTA,"^",7)\1),X2=-1 D C^%DTC
	Q $$BIL^DGMTUB(DFN,X)
	;
	;
EDIT()	; Determine the billable status before editing a Means Test.
	I $P(DGMTP,"^",3)'=1 Q $$CK^DGMTUB(DGMTP)
	S X1=+DGMTP,X2=-1 D C^%DTC Q $$BIL^DGMTUB(DFN,X)
