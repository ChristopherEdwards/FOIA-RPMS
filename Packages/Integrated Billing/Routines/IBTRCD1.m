IBTRCD1	;ALB/AAS - CLAIMS TRACKING INS ACTION EDIT ; 06-JUL-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	G ^IBTRC
	;
QE	; -- Quick edit
	N IBXX,VALMY,DA,DR,DIC,DIE
	D QE1^IBTRC1
	D BLD^IBTRCD
	S VALMBCK="R"
	Q
	;
NX(IBTMPNM,BLD)	; -- edit next template
	N IBXX,VALMY
	D EN^VALM(IBTMPNM)
	I '$D(IBFASTXT) D:'$G(BLD) BLD^IBTRCD
	S VALMBCK="R"
	Q
	;
EDIT(DR,BLD)	; -- edit entry point for claims tracking reviews
	; -- Input   IBTEMP = template name or dr string
	;               BLD = any non-zero value if calling routine is doing own
	;                      rebuild
	;
	N IBDIF,DA,DIC,DIE,DIR,X,Y,IBTLST
	D FULL^VALM1 W !
	D SAVE
	S DIE="^IBT(356.2,",DA=IBTRC
	L +^IBT(356.2,+IBTRC):5 I '$T D LOCKED G EDITQ
	D ^DIE K DA,DR,DIC,DIE
	I '$D(IBCON) D CON K IBCON
	D COMP
	I IBDIF=1 D UPDATE
	L -^IBT(356.2,+IBTRC)
	D BLD^IBTRCD:'$G(BLD)
EDITQ	K ^TMP($J,"IBT")
	S VALMBCK="R"
	Q
	;
SAVE	; -- Save the global before editing
	K ^TMP($J,"IBT")
	S ^TMP($J,"IBT",356.2,IBTRC,0)=$G(^IBT(356.2,IBTRC,0))
	S ^TMP($J,"IBT",356.2,IBTRC,1)=$G(^IBT(356.2,IBTRC,1))
	S ^TMP($J,"IBT",356.2,IBTRC,11,0)=$G(^IBT(356.2,IBTRC,11,0))
	S ^TMP($J,"IBT",356.2,IBTRC,12,0)=$G(^IBT(356.2,IBTRC,12,0))
	S ^TMP($J,"IBT",356.2,IBTRC,13,0)=$G(^IBT(356.2,IBTRC,13,0))
	Q
	;
COMP	; -- Compare before editing with globals
	S IBDIF=0
	I $G(^IBT(356.2,IBTRC,0))'=$G(^TMP($J,"IBT",356.2,IBTRC,0)) S IBDIF=1 Q
	I $G(^IBT(356.2,IBTRC,1))'=$G(^TMP($J,"IBT",356.2,IBTRC,1)) S IBDIF=1 Q
	I $G(^IBT(356.2,IBTRC,11,0))'=$G(^TMP($J,"IBT",356.2,IBTRC,11,0)) S IBDIF=1 Q
	I $G(^IBT(356.2,IBTRC,12,0))'=$G(^TMP($J,"IBT",356.2,IBTRC,12,0)) S IBDIF=1 Q
	I $G(^IBT(356.2,IBTRC,13,0))'=$G(^TMP($J,"IBT",356.2,IBTRC,13,0)) S IBDIF=1 Q
	Q
	;
UPDATE	; -- enter date and user if editing has taken place
	;    entry locked during edit lock not needed here
	S DIE="^IBT(356.2,",DA=IBTRC
	S DR="1.03///NOW;1.04////"_DUZ
	D ^DIE K DA,DR,DIC,DIE
	Q
	;
LOCKED	; -- write locked message
	Q:$D(ZTQUEUED)
	W !!,"Sorry, another user currently editing this entry."
	W !,"Try again later."
	D PAUSE^VALM1
	Q
	;
CON	; -- consistency checker for insurance reviews
	N I,J,X,Y,DA,DR,DIC,DIE,IBI,IBDEL,IBACTION
	S IBCON=1
	S IBACTION=$P($G(^IBE(356.7,+$P(^IBT(356.2,IBTRC,0),"^",11),0)),"^",3)
	I $G(IBACTION)="" S IBACTION=99
	;
	; -- if action and type the same okay, check nxt rv. dates
	I $P($G(^IBT(356.2,IBTRC,0)),"^",4)=$P($G(^TMP($J,"IBT",356.2,IBTRC,0)),"^",4),$P($G(^IBT(356.2,IBTRC,0)),"^",11)=$P($G(^TMP($J,"IBT",356.2,IBTRC,0)),"^",11) G NXRV
	;
	; -- if action different
	I $P($G(^TMP($J,"IBT",356.2,IBTRC,0)),"^",11)="" Q  ; no previous action
	I $P($G(^IBT(356.2,IBTRC,0)),"^",11)'=$P($G(^TMP($J,"IBT",356.2,IBTRC,0)),"^",11) D
	.S DR=$P($T(@(IBACTION)),";;",2,99)
	.I DR'="" D EDIT(DR,1)
	.I IBACTION'=10 S $P(^IBT(356.2,IBTRC,0),"^",12,13)="^"
	.I IBACTION'=20 S $P(^IBT(356.2,IBTRC,0),"^",15,16)="^"
	.W !,"WARNING: I detected you changed the Action on this review and deleted",!,"data associated with the previous action." H 3
	.Q
	; -- if not denial and denial reasons delete
	I $O(^IBT(356.2,IBTRC,12,0)),$G(IBACTION)'=20 D
	.S IBI=0 F  S IBI=$O(^IBT(356.2,IBTRC,12,IBI)) Q:'IBI  S DA=IBI,DA(1)=IBTRC,DIK="^IBT(356.2,"_IBTRC_",12," D ^DIK
	;
	; -- if not penalty and penalty reasons delete
	I $O(^IBT(356.2,IBTRC,13,0)),$G(IBACTION)'=30 D
	.S IBI=0 F  S IBI=$O(^IBT(356.2,IBTRC,13,IBI)) Q:'IBI  S DA=IBI,DA(1)=IBTRC,DIK="^IBT(356.2,"_IBTRC_",13," D ^DIK
	.Q
	;
NXRV	; -- check Next Review Dates
	I '$D(IBTRN) N IBTRN S IBTRN=$P($G(^IBT(356.2,+$G(IBTRC),0)),"^",2)
	Q:'$G(IBTRN)
	S IBI=0 F  S IBI=$O(^IBT(356.2,"C",IBTRN,IBI)) Q:'IBI  I IBI'=IBTRC D
	.I $P($G(^IBT(356.2,IBI,0)),"^",24) S IBI(IBI)=""
	.Q
	I $O(IBI(0)) D ASKDEL I IBDEL D
	.I $P(^IBT(356.2,IBTRC,0),U,24) W !,"Warning: There are other reviews with Next Review Dates specified.",!,"Generally only the last review date should have a Next Review Date." H 3 Q
	.I $O(IBI(+$O(IBI(0)))) W !,"Warning:  More that one review has a Next Review Date Specified.",!,"Generally only the last review date should have a Next Review Date." H 3 Q
	.Q
	Q
	;
ASKDEL	; -- ask if okay to delete next review dates
	S IBDEL=1
	Q
	;
10	;;1.07///@;.2///@;.21///@
20	;;.14///@;1.08///@;.2///@;21///@;.28///@
30	;;.14///@;1.07///@;1.08///@;.2///@;21///@;.28///@
40	;;.14///@;1.07///@;1.08///@;21///@;.28///@
50	;;.14///@;1.07///@;1.08///@;.2///@;.28///@
99	;;.14///@;1.07///@;1.08///@;.2///@;21///@;.28///@
