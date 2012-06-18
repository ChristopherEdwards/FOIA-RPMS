IBCB1	;ALB/AAS - Process bill after enter/edited ; 2-NOV-89
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRB1
	;
	;IBQUIT = Flag to stop processing
	;IBVIEW = Flag showing Bill has been viewed
	;IBDISP = Flag showing Bill entering display been viewed.
	;
	K ^UTILITY($J) I $D(IBAC),IBAC>1 G @IBAC
1	;complete bill
	D END,EDITS^IBCB2 G:IBQUIT END
	;
2	;review bill
	;I '$D(^XUSEC("IB AUTHORIZE",DUZ))!('$D(IBIFN)) W !!,"You do not hold the Review Key.",! G END
	;I '$P($G(^IBE(350.9,1,1)),"^",11),DUZ=$P(^DGCR(399,IBIFN,"S"),"^",2) W !!,"Entering user can not review bill.",! G END
	;D EDITS^IBCB2 G:IBQUIT END
REV	;W !!,"WANT TO ",$S($P(^DGCR(399,IBIFN,"S"),"^",6)]"":"RE-",1:""),"REVIEW BILL AT THIS TIME" S %=2 D YN^DICN G:%=-1!(%=2) END
	;I '% W !?4,"YES - To set the status to Reviewed",!?4,"No - To take no action" G REV
	;
	;S (DIC,DIE)=399,DA=IBIFN,DR="[IB STATUS]" D ^DIE K DIC,DIE D:$D(IBX3) DISAP^IBCBULL
	;
3	;authorize bill
	I '$D(^XUSEC("IB AUTHORIZE",DUZ))!('$D(IBIFN)) W !!,"You do not hold the Authorize Key.",! G END
	;I '$P(^DGCR(399,IBIFN,"S"),"^",6) W:IBAC>2 !!,"Not Yet Reviewed.",! G END
	;I '$P($G(^IBE(350.9,1,1)),"^",3),DUZ=$P(^DGCR(399,IBIFN,"S"),"^",8) W !!,"Reviewing user can not authorize.",! G END
	I '$P($G(^IBE(350.9,1,1)),"^",23),DUZ=$P(^DGCR(399,IBIFN,"S"),"^",2) W !!,"Entering user can not authorize.",! G END
	I $P(^DGCR(399,IBIFN,"S"),"^",9) W !,"Already Approved, Can't change" G END
	D EDITS^IBCB2 G:IBQUIT END
AUTH	W !!,"WANT TO AUTHORIZE BILL AT THIS TIME" S %=2 D YN^DICN G:%=-1!(%=2) END
	I '% W !?4,"YES - To set the status to Complete",!?4,"No - To take no action" G AUTH
	S (DIC,DIE)=399,IBYY="@90",DA=IBIFN,DR="[IB STATUS]" D ^DIE K DIC,DIE,IBYY D:$D(IBX3) DISAP^IBCBULL
	I '$P(^DGCR(399,IBIFN,"S"),"^",9) G END
	W !,"Passing completed Bill to Accounts Receivable.  Bill is no longer editable."
	I $P(^DGCR(399,IBIFN,"S"),"^",9) D GVAR^IBCBB,ARRAY^IBCBB1,^PRCASVC6 D REL^PRCASVC:PRCASV("OKAY") I 'PRCASV("OKAY") D FXERR1^IBCB2 G END
	W !,"Completed Bill Successfully sent to Accounts Receivable."
	;
4	;generate/print bill
	G:('$D(IBIFN)) END
	I '$P(^DGCR(399,IBIFN,"S"),"^",9) W !!,*7,"Not Authorized, Can Not Print!" G END
	D DISP^IBCB2
	S:'$D(IBQUIT) IBQUIT=0
	D:'$D(IBVIEW) VIEW^IBCB2 G:IBQUIT END
	S IBPNT=$P(^DGCR(399,IBIFN,"S"),"^",12)
GEN	W !!,"WANT TO ",$S(IBPNT]"":"RE-",1:""),"PRINT BILL AT THIS TIME" S %=2 D YN^DICN G:%=-1!(%=2) END
	I '% W !?4,"YES - to print the bill now",!?4,"NO - To take no action" G GEN
	I 'IBPNT D EN1^IBCF G END
RPNT	R !!,"(2)nd Notice, (3)rd Notice, (C)opy or (O)riginal: C// ",IBPNT:DTIME S:IBPNT="" IBPNT="C" G:IBPNT["^" END
	S IBPNT=$E(IBPNT,1) I "23oOcC"'[IBPNT W !?5,"Enter 'O' to reprint the original bill or",!?5,"Enter 'C' to reprint the bill as a duplicate copy or",!?5,"Enter '2' or '3' to print 2nd or 3rd follow-up notices." S IBPNT=1 G RPNT
	W "  (",$S("cC"[IBPNT:"COPY","oO"[IBPNT:"ORIGINAL",IBPNT=2:"2nd NOTICE",IBPNT=3:"3rd NOTICE",1:""),")"
	S IBPNT=$S("oO"[IBPNT:1,"cC"[IBPNT:0,1:IBPNT)
	D EN1^IBCF
	;
END	K IBER D END^IBCBB1 K IBQUIT,IBVIEW,IBDISP,IBST,IB,PRCAERCD,PRCAERR,PRCASVC,PRCAT,DGRA2,IBBT,IBCH,IBNDS,IBOA,IBREV,IBX,DGXRF1,PRCAORA,IBX3,DGBILLBS,DGII,DGVISCNT,DGFIL,DGTE
	K %DT,DIC,DIE,I,J,X,Y,Y1,Y2,IBER,IBDFN,IBDSDT,IBJ,IBNDI1,IBZZ,VA,IBMA,IBXDT,DI,PRCAPAYR,DGBS,DGCNT,DGDA,DGPAG,DGREVC,DGRV,DGTEXT,DGTOTPAG,IBOPV,DGLCNT,DGTEXT1,DGRSPAC,DGSM,IBPNT,DGINPT,DGLL,IBCPTN
	K IBOPV1,IBOPV2,IBCHG,DGBIL1,DGU,DDH,IBA1,IBINS,IBPROC,PRCARI K:'$D(PRCASV("NOTICE")) PRCASV
	Q
