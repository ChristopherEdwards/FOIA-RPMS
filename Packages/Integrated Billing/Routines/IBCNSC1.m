IBCNSC1	;ALB/NLR - IBCNS INSURANCE COMPANY ; 23-MAR-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	G EN^IBCNSC
	;
AI	; -- (In)Activate Company
	D FULL^VALM1 W !!
	I '$D(^XUSEC("IB INSURANCE SUPERVISOR",DUZ)) D SORRY G EXIT
	D ^IBCNSC2
	G EXIT
CC	; -- Change Insurance Company
	D FULL^VALM1 W !!
	S IBCNS1=IBCNS K IBCNS D INSCO^IBCNSC
	I $D(VALMQUIT) S IBCNS=IBCNS1 K VALMQUIT
	D:IBCNS'=IBCNS1
	K IBCNS1,VALMQUIT
	G EXIT
EA	; -- Billing,Claims,Appeals,Inquiry,Telephone,Main,Remarks,Synonyms
	D FULL^VALM1 W !!
	D MAIN
	;
	; -- was company deleted
	I '$D(^DIC(36,IBCNS)) W !!,"<DELETED>",!! S VALMQUIT="" Q
	;
EXIT	;
	D HDR^IBCNSC,BLD^IBCNSC
	S VALMBCK="R"
	Q
MAIN	; -- Call edit template
	L +^DIC(36,+IBCNS):5 I '$T D LOCKED^IBTRCD1 G MAINQ
	N DIE S DIE="^DIC(36,",(DA,Y)=IBCNS,DR="[IBEDIT INS CO1]" D ^DIE K DIE I $D(Y) S IB("^")=1
	L -^DIC(36,+IBCNS)
MAINQ	Q
	;
SORRY	; -- can't inactivate, don't have key
	W !!,"You do not have access to Inactivate entries.  See your application coordinator.",! D PAUSE^VALM1
	Q
PRESCR	;
	N OFFSET,START,IBCNS18,IBADD
	S IBCNS18=$$ADDRESS^IBCNSC0(IBCNS,.18,11)
	S START=34,OFFSET=2
	D SET^IBCNSP(START,OFFSET+19," Prescription Claims Office Information ",IORVON,IORVOFF)
	D SET^IBCNSP(START+1,OFFSET," Company Name: "_$P($G(^DIC(36,+$P(IBCNS18,"^",7),0)),"^",1))
	D SET^IBCNSP(START+2,OFFSET,"       Street: "_$P(IBCNS18,"^",1))
	D SET^IBCNSP(START+3,OFFSET,"     Street 2: "_$P(IBCNS18,"^",2))
	N OFFSET S OFFSET=45
	D SET^IBCNSP(START+1,OFFSET,"     Street 3: "_$P(IBCNS18,"^",3)) S IBADD=1
	D SET^IBCNSP(START+1+IBADD,OFFSET,"   City/State: "_$E($P(IBCNS18,"^",4),1,15)_$S($P(IBCNS18,"^",4)="":"",1:", ")_$P($G(^DIC(5,+$P(IBCNS18,"^",5),0)),"^",2)_" "_$E($P(IBCNS18,"^",6),1,5))
	D SET^IBCNSP(START+2+IBADD,OFFSET,"        Phone: "_$P(IBCNS18,"^",8))
	D SET^IBCNSP(START+3+IBADD,OFFSET,"          Fax: "_$P(IBCNS18,"^",9))
	Q
