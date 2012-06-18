IBCB2	;ALB/AAS - Process bill after enter/edited ; 13-DEC-89
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRB2
	;
	;IBQUIT = Flag to stop processing
	;IBVIEW = Flag showing Bill has been viewed
	;IBDISP = Flag showing Bill entering display been viewed.
	;
VIEW	;View screens; if status allows editing , allow editing
	S IBVIEW=1,IBV=$S($D(IBV):IBV,1:1),%=2 W !,"WANT TO ",$S('IBV:"EDIT",1:"REVIEW")," SCREENS" D YN^DICN S:%=-1 IBQUIT=1 Q:%=-1!(%=2)
	I '% W !?4,"YES - to ",$S('IBV:"EDIT",1:"REVIEW")," the screens",!?4,"NO - To take no action" G VIEW
	Q:%'=1
VIEW1	S IBVIEW=1 D ^IBCSCU,^IBCSC1
	Q
DISP	S IB("S")=$S($D(^DGCR(399,IBIFN,"S")):^("S"),1:"")
	W ! D DISP^IBCNQ W !
	S IBDISP=1 Q
	Q
EDITS	S IBQUIT=0 I '$D(IBER)!('$D(PRCASV)) D EN^IBCBB
	I IBER]"" D FXERR I IBER]"" W !,"Can't Continue" S IBQUIT=1 Q
	I $D(PRCASV),'($D(PRCASV("OKAY"))) D ^PRCASVC6 I 'PRCASV("OKAY") D FXERR1 I 'PRCASV("OKAY") W !,"Can't Continue" S IBQUIT=1 Q
	D:'$D(IBDISP) DISP
	D:'$D(IBVIEW) VIEW
	Q
FXERR	S Y2="" F I=1:1 S X=$P(IBER,";",I) Q:X=""  I $D(^IBE(350.8,$O(^IBE(350.8,"AC",X,0)),0)) S Y=^(0),Y1=$P(Y,"^",5),Y2=Y2_Y1 I Y1<5 W !?5,$P(Y,"^",2)
	Q:Y2'["3"  W !!,"Do you wish to ",$S(IBAC<4:"edit",1:"review")," Inconsistencies now" S %=2 D YN^DICN Q:%=-1!(%=2)
	I '% W !!?4,"YES - To edit inconsistent fields",!?4,"NO - To discontinue this process." G FXERR
	D VIEW1
	D EN^IBCBB G:IBER]"" FXERR
	Q
FXERR1	S Y2="",J=0 F I=0:0 S J=$O(PRCAE(J)) Q:J=""  S X=PRCAE(J) I $D(^IBE(350.8,$O(^IBE(350.8,"AC",X,0)),0)) S Y=^(0),Y1=$P(Y,"^",5),Y2=Y2_Y1 I Y1<5 W !?5,$P(Y,"^",2)
	Q:Y2'["3"  W !!,"Do you wish to edit Inconsistencies now" S %=2 D YN^DICN Q:%=-1!(%=2)
	I '% W !!?4,"YES - To edit inconsistent fields",!?4,"NO - To discontinue this process." G FXERR1
	D VIEW1
	D GVAR^IBCBB,ARRAY^IBCBB1,^PRCASVC6 G:'PRCASV("OKAY") FXERR1
	Q
NOPTF	S IBAC1=1 I $D(^DGCR(399,IBIFN,0)),$P(^(0),"^",8),'$D(^DGPT($P(^(0),"^",8),0)) S IBAC1=0
	Q
NOPTF1	W !!,*7,"PTF Record for this Bill was DELETED!",!,"Further processing not allowed.  Cancel and re-enter." Q
