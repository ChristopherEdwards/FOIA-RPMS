IBTRE4	;ALB/AAS - CLAIMS TRACKING EDIT PROCEDURE ; 1-SEP-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	G ^IBTRE
	;
EN(IBTRN)	; -- entry point for protocols
	;    must do own rebuild actions
	; -- Input - point to 356
	;
	N IBETYP,IBTRND,IBXY,IBCNT,IBDGPM
	D FULL^VALM1
	S VALMBCK=""
	S IBTRND=$G(^IBT(356,IBTRN,0)),IBDGPM=$P(IBTRND,"^",5)
	;
	S IBETYP=$$TRTP^IBTRE1(IBTRN)
	I IBETYP>2 W !!,"Clinical Information comes from the parent package." D PAUSE^VALM1 G ENQ
	;
	; -- outpatient procedure
	I IBETYP=2 D  G ENQ
	.W !!,*7,"You must use the add/edit action on Check-out to add procedures to Outpatient Encounters.",!
	.S VALMBCK="R"
	;
	; -- Inpatient procedure
	Q:'IBDGPM
	I IBETYP=1 D PROC(IBTRN,IBETYP) S VALMBCK="R"
	;
ENQ	;
	Q
	;
PROC(IBTRN,IBETYP)	; -- add/edit procedure
	Q:'IBTRN
	I $G(IBETYP)'=1 Q
	N DA,DR,DIC,DIE
	;S IBDGPM=$P(^IBT(356,+IBTRN,0),"^",5)
	I IBETYP'=1!('IBDGPM) W !!,"You can only enter a procedure for an admission",! D PAUSE^VALM1 G PROCQ
	;
	S X="IOINHI;IOINORM" D ENDR^%ZISS
	W !!,"--- ",IOINHI,"Procedure",IOINORM," --- "
	S IBSEL="Add"
	D SET(IBTRN) I $D(IBXY) D LIST(.IBXY) S IBSEL=$$ASK(IBCNT,"A")
	I IBSEL["^"!(IBSEL["Return") S:IBSEL["^" IBQUIT=1 G PROCQ
	I IBSEL="Add" D ADD(IBTRN)
	D:IBSEL EDT(+$G(IBXY(+IBSEL)),".01;.03;")
PROCQ	Q
	;
ADD(IBTRN,TYPE)	; -- Add a new procedure
	;
	N DTOUT,DUTOU,X,Y,DIC
	S IBCNT=0
	I '$G(TYPE) S TYPE=""
NXT	S DIC("A")=$S(IBCNT<1:"Select Procedure: ",1:"Next Procedure: ")
	S DIC("S")="I '$P(^(0),U,9)"
	S DIC="^ICD0(",DIC(0)="AEMQ",X=""
	W:$G(IBCNT) ! D ^DIC K DIC G ADDQ:Y<0
	I $D(^IBT(356.91,"ADGPM",$$DGPM^IBTRE3(IBTRN),+Y)) W !!,*7,$P(Y,"^",2)," is already a procedure.",!
	S IBCNT=IBCNT+1
	S IBADG=$$NEW(+Y,IBTRN,TYPE)
	I IBADG,TYPE'=3 D EDT(IBADG) G NXT
ADDQ	Q
	;
NEW(ICDI,IBTRN,TYPE)	; -- file new entry
	;
	N DA,DD,DO,DIC,DIK,DINUM,DLAYGO,X,Y,I,J
	S X=ICDI,(DIC,DIK)="^IBT(356.91,",DIC(0)="L",DLAYGO=356.91
	D FILE^DICN S IBADG=+Y
	I IBADG>0 L +^IBT(356.91,IBADG) S $P(^IBT(356.91,IBADG,0),"^",2,4)=$$DGPM^IBTRE3(IBTRN)_"^"_$P($P(^IBT(356,IBTRN,0),"^",6),"."),DA=IBADG D IX1^DIK L -^IBT(356.91,IBADG)
NEWQ	Q IBADG
	;
EDT(IBADG,IBDR)	; -- edit entry
	;
	N DR,DIE,DA
	S DR=$G(IBDR) I DR="" S DR=".03;"
	S DA=IBADG,DIE="^IBT(356.91,"
	L +^IBT(356.91,IBADG):5 I '$T D LOCKED^IBTRCD1 G EDTQ
	Q:'$G(^IBT(356.91,DA,0))
	L -^IBT(356.91,IBADG)
	D ^DIE
EDTQ	Q
	;
SET(IBTRN)	; -- set array
	N IBDGPM,IBICD
	S IBDGPM=$$DGPM^IBTRE3(IBTRN)
	S (IBICD,IBCNT)=0
	F  S IBICD=$O(^IBT(356.91,"ADGPM",IBDGPM,IBICD)) Q:'IBICD  S IBDA=$O(^(IBICD,0)) D
	.S IBCNT=IBCNT+1
	.S IBXY(IBCNT)=IBDA_"^"_IBICD
SETQ	Q
	;
LIST(IBXY)	;List Diagnosis Array
	; Input  -- IBXY     Diagnosis Array Subscripted by a Number
	; Output -- List Diagnosis Array
	N I,IBXD
	W !
	S I=0 F  S I=$O(IBXY(I)) Q:'I  S IBXD=$G(^ICD0(+$P(IBXY(I),"^",2),0)) D
	.S IBTNOD=$G(^IBT(356.91,+IBXY(I),0))
	.W !?2,I,"  ",$P(IBXD,"^"),?15,$E($P(IBXD,"^",4),1,43),?60,$$DAT1^IBOUTL($P($P(IBTNOD,"^",3),"."),2)
	Q
	;
ASK(IBCNT,IBPAR,IBSELDF)	;Ask user to select from list
	; Input  -- SDCNT    Number of Entities
	;           SDPAR    Selection Parameters (A=Add)
	;           SDSELDF  Selection Default  [Optional]
	; Output -- Selection
	N DIR,DIRUT,DTOUT,DUOUT,X,Y
REASK	S DIR("?")="Enter "_$S($G(IBSELDF)]"":"<RETURN> for '"_IBSELDF_"', ",1:"")_$S(IBCNT=1:"1",1:"1-"_IBCNT)_" to Edit"_$S(IBPAR["A":", or 'A' to Add",1:"")
	S DIR("A")="Enter "_$S(IBCNT=1:"1",1:"1-"_IBCNT)_" to Edit"_$S(IBPAR["A":", or 'A' to Add",1:"")_": "_$S($G(IBSELDF)]"":IBSELDF_"// ",1:"")
	S DIR(0)="FAO^1:30"
	D ^DIR I $D(DTOUT)!($D(DUOUT)) S Y="^" G ASKQ
	S Y=$$UPPER^VALM1(Y)
	I Y?.N,Y,Y'>IBCNT G ASKQ
	I IBPAR["A",$E(Y)="A" S Y="Add" G ASKQ
	I Y="" S Y=$S($G(IBSELDF)]"":IBSELDF,1:"Return") G ASKQ
	W !!?5,DIR("?"),".",! G REASK
ASKQ	Q $G(Y)
