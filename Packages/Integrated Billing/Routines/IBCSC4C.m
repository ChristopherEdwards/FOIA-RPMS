IBCSC4C	;ALB/MJB - MCCR PTF SCREEN (CONT.)  ;24 FEB 9:43
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC4C
	;
SETP	S:IBP'>2 IB9=0 D S
	F F=1:1:3 Q:IB9=3  I $D(IBWO(F)),IBWO(F)]"",$P(IBWO(F),U,1)'=IBNC S IB9=IB9+1,IB7(IB9)=IBWO(F)_U_$S($P(IBWO(F),U,2)']"":$P(IBWO(0),U,2),1:"")
	I '$D(IB7(3)) F F=1:1:3 Q:IB9=3  I $D(IBWE(F)),IBWE(F)]"",$P(IBWE(F),U,1)'=IBNC S IB9=IB9+1,IB7(IB9)=IBWE(F)_U_$S($P(IBWE(F),U,2)']"":$P(IBWE(0),U,2),1:"")
	Q:"^^"[$P(IB("C"),U,4,6)!($P(IB("C"),U,4)]"")!($P(IB("C"),U,5)]"")!($P(IB("C"),U,6)]"")
	F F=1:1:3 I $D(IB7(F)),$P(^DGCR(399,IBIFN,"C"),U,(F+3))']"" S $P(^DGCR(399,IBIFN,"C"),U,(F+3))=$P(IB7(F),U,1),$P(^("C"),U,(F+10))=$P(IB7(F),U,2)
	S:$P(^DGCR(399,IBIFN,0),U,9)="" $P(^DGCR(399,IBIFN,0),U,9)=9
	Q
SETD	S:IBDIA'>2 IB8=0 D S
	F F=1:1:5 Q:IB8=5  I $D(IBWO(F)),IBWO(F)]"",$P(IBWO(F),U,1)'=IBNC S IB8=IB8+1,IB6(IB8)=$P(IBWO(F),U,1)
	I '$D(IB6(5)) F F=1:1:5 Q:IB8=5  I $D(IBWE(F)),IBWE(F)]"",$P(IBWE(F),U,1)'=IBNC S IB8=IB8+1,IB6(IB8)=$P(IBWE(F),U,1)
	Q:"^^^^"[$P(IB("C"),U,14,18)!($P(IB("C"),U,14)]"")!($P(IB("C"),U,15)]"")!($P(IB("C"),U,16)]"")!($P(IB("C"),U,17)]"")!($P(IB("C"),U,18)]"")
	F F=1:1:5 I $D(IB6(F)) S $P(^DGCR(399,IBIFN,"C"),U,(F+13))=IB6(F)
	Q
SELP	D S F I=1:1 W ! Q:$Y+10>IOSL
	F I=1:1:3 W !,"ICD PROCEDURE CODE (",I,"): " S IBPX=$S($P(IB("C"),U,(I+3))]"":$P(IB("C"),U,(I+3)),1:"") W:IBPX]"" $S($D(^ICD0($P(IBPX,U,1),0)):$J($P(^(0),U,1),6),1:IBUC)_"// " R X:DTIME Q:'$T!(X["^")  D CHP D:$D(IB3) PD D S
	Q
PD	S %DT("A")="      PROCEDURE DATE ("_I_"): ",%DT="AEX" D ^%DT I Y>0 S $P(^DGCR(399,IBIFN,"C"),U,(I+10))=+Y,IB("C")=^DGCR(399,IBIFN,"C") K IB3
	Q
SELD	D S F I=1:1 W ! Q:$Y+10>IOSL
	F I=1:1:5 W !,"DIAGNOSIS CODE (",I,"): " S IBPY=$S($P(IB("C"),U,(I+13))]"":$P(IB("C"),U,(I+13)),1:"") W:IBPY]"" $S($D(^ICD9($P(IBPY,U,1),0)):$J($P(^(0),U,1),6)_"// ",1:IBUC) R X:DTIME Q:'$T!(X["^")!((X="")&(IBPY=""))  D CHD,S
	Q
CHP	I X="?" D 3^IBCSCH1 S I=I-1 Q
	I X="",$P(IB("C"),U,(I+3))]"" Q
	I X["@" W "   ...Deleted" S IB7(I)="",$P(^DGCR(399,IBIFN,"C"),U,(I+3))="",$P(^("C"),U,(I+10))="",$P(IB("C"),U,(I+10))="",IBPX=1 Q
	I X="" S $P(^DGCR(399,IBIFN,"C"),U,(I+3))="",$P(^("C"),U,(I+10))="" Q
	I X?1A1N D P^IBCSC4A S IB5=$S($D(^UTILITY($J,"IB",M,S)):^(S),1:"") S:IB5]"" $P(^DGCR(399,IBIFN,"C"),U,(I+3))=$P(IB5,U,1) D:IB5]"" DT Q:IB5]""  W *7,"  ??" S I=I-1 Q
	I $P(^IBE(350.9,1,1),U,15)'=1 D PAR Q
	S:X["?" X="??" S IBI=I,DIC="^ICD0(" D DIC I Y'>0 S I=IBI-1 Q
	S X=+Y,$P(^DGCR(399,IBIFN,"C"),U,(I+3))=X D PD
	Q
CHD	I X="?" D 3^IBCSCH1 S I=I-1 Q
	I X="",$P(IB("C"),U,(I+13))]"" Q
	I X["@" W "   ...Deleted" S IB6(I)="",$P(^DGCR(399,IBIFN,"C"),U,(I+13))="",$P(IB("C"),U,(I+13))="",IBPY=1 Q
	I X="" S $P(^DGCR(399,IBIFN,"C"),U,(I+13))="" Q
	I X?1A1N D D^IBCSC4A S IB4=$S($D(^UTILITY($J,"IBDX",M,S)):^(S),1:"") S:IB4]"" $P(^DGCR(399,IBIFN,"C"),U,(I+13))=$P(IB4,U,1),IB3=1 Q:IB4]""  W *7,"  ??" S I=I-1 Q
	I $P(^IBE(350.9,1,1),U,15)'=1 D PAR Q
	S:X["?" X="??" S IBI=I,DIC="^ICD9(" D DIC I Y'>0 S I=IBI-1 Q
	S X=+Y,$P(^DGCR(399,IBIFN,"C"),U,(I+13))=X
	Q
DT	S $P(^DGCR(399,IBIFN,"C"),U,(I+10))=$S($P(IB5,U,2)]"":$P(IB5,U,2),1:$P(^UTILITY($J,"IB",M,1),U,2)) Q
PAR	W:X'["?" "  ??" W !?7,"You may only choose codes found in PTF record!" D 3^IBCSCH1 S I=I-1 Q
DIC	S DIC(0)="EMQ",DIC("S")="I $S($P(^(0),U,9):0,$P(^(0),U,10)']"""":1,$P(^(0),U,10)=$S($D(^DPT(DFN,0)):$P(^(0),U,2),1:""M""):1,1:0)" D ^DIC Q
S	S:'$D(^DGCR(399,IBIFN,"C")) ^DGCR(399,IBIFN,"C")="" S IB("C")=^DGCR(399,IBIFN,"C")
