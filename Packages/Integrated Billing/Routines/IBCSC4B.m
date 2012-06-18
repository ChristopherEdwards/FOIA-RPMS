IBCSC4B	;ALB/MJB - MCCR PTF SCREEN (CONT.)  ;24 FEB 89  9:52
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC4B
	;
DX	Q:$S(IBPTF="":1,'$D(^DGPT(IBPTF,0)):1,1:0)  S IBUC="UNSPECIFIED CODE",IBNC="NO DX CODES ENTERED FOR THIS DATE",IBDXC=0,X="DIAGNOSIS SCREEN" K IBWE,IBWO
	W @IOF,?(40-($L(X)\2)),X,! F I=1:1:79 W "="
	S IBDIA="" I '$D(^UTILITY($J,"IBDX")) W !!," * No DIAGNOSIS CODES in PTF record for this episode of care." D SELD^IBCSC4C G Q
	F I=1:1:13 S IBDIA=$O(^UTILITY($J,"IBDX",IBDIA)) Q:IBDIA=""  D ODD^IBCSC4A S IBDIA=$O(^UTILITY($J,"IBDX",IBDIA)) D:IBDIA]"" EVEN^IBCSC4A D WR D:$Y+6>IOSL ASK Q:IBDIA=""
	S IBDIA="" ; D SELD^IBCSC4C
	G Q
	;
WR	I '$D(IBWE(0)) F B=0:1:5 S IBWE(B)=""
	W !!,"Move: " S Y=$P(IBWO(0),U,2) X ^DD("DD") W $S($P(IBWO(0),U,4)]"":$P(IBWO(0),U,4)_" ",1:""),Y," " W:$P(IBWO(0),"^",3)]"" $E($P(^DIC(42.4,$P(IBWO(0),U,3),0),U),1,12) W " ",$P(IBWO(0),"^",5)
	I IBDIA]"",IBWE(0)]"" W ?43,"Move: " S Y=$P(IBWE(0),U,2) X ^DD("DD") W $S($P(IBWE(0),U,4)]"":$P(IBWE(0),U,4)_" ",1:""),Y," " W:$P(IBWE(0),"^",3)]"" $E($P(^DIC(42.4,$P(IBWE(0),U,3),0),U),1,12) W " ",$P(IBWE(0),"^",5)
	S IBAO=$P(IBWO(0),U,1) I IBAO']"" W:'$D(IBDXY) !,"* ",IBNC S IBDXY=1 F K=1:1:5 S IBWO(K)="" I IBDIA]"" W:K>1 ! D WE Q:IBWO(K)']""&(IBWE(K)']"")
	I IBAO]"" F K=1:1:5 Q:IBWO(K)']""&(IBWE(K)']"")  S X=$S($D(^ICD9((+IBWO(K)),0)):^(0),1:"") W:IBWO(K)]"" !,IBAO,K," - ",$S(X]"":$J($P(X,U,1),6)_"  "_$E($P(X,U,3),1,24),1:IBUC) W:IBWO(K)']"" !,"" D:IBDIA]"" WE
	Q
WE	S IBAE=$P(IBWE(0),U,1) I IBAE']"",'$D(IBDXX),IBWE(0)]"" W ?43,"* ",IBNC S (IBWE(1),IBWE(2),IBWE(3),IBWE(4),IBWE(5))="",IBDXX=1
	I IBAE]"",IBWE(K)]"" S X=$S($D(^ICD9((+IBWE(K)),0)):^(0),1:"") W ?43,IBAE,K," - ",$S(X]"":$J($P(X,U,1),6)_"  "_$E($P(X,U,3),1,24),1:IBUC)
	Q
ASK	W !!,"<RETURN> to see more ",$S($D(IBP):"procedure",1:"diagnosis")," codes or '^' to QUIT: " R A:DTIME I '$T!(A["^") S:$D(IBDIA) IBDIA="" S:$D(IBP) IBP="" Q
	I A["?" W !!?4,"Enter <RETURN> to view more ",$S($D(IBP):"operation/procedure",1:"movement dates and diagnosis")," codes",!?4,"or '^' to stop the display." G ASK
	S A=$S($D(IBP):"OPERATION/PROCEDURE",1:"DIAGNOSIS")_" SCREEN (CONT.)" W !,@IOF,?(40-($L(A)\2)),A,! F S=1:1:79 W "="
	Q
PRO	Q:'$D(IBPTF)  S IBUC="UNSPECIFIED CODE",IBNC="NO PRO CODES ENTERED FOR THIS DATE",IBOPC=0,X="OPERATION/PROCEDURE SCREEN",IBNOR="Non-O/R Procedure Date: ",IBSD="Surgery Date: "
	K IBWE,IBWO
	W @IOF,?(40-($L(X)\2)),X,! S X="",$P(X,"=",1,79)="" W X
	S IBP="" I '$D(^UTILITY($J,"IB")) W !!," * No PROCEDURE CODES in PTF record for this episode of care." G Q
	F I=1:1:13 S IBP=$O(^UTILITY($J,"IB",IBP)) Q:IBP=""  D ODDP^IBCSC4A S IBP=$O(^UTILITY($J,"IB",IBP)) D:IBP]"" EVENP^IBCSC4A D WRP D:$Y+6>IOSL ASK Q:IBP=""
	S IBP=""
Q	K IB3,IB4,IB5,IB6,IB7,IB8,IB9,IBAE,IBAO,IBCT,IBDIA,IBDP,IBDX,IBDXC,IBDXX,IBDXY,IBI,IBNC,IBNOR,IBP,IBPY,IBOP,IBOPC,IBOPX,IBOPY,IBPP,IBPX,IBSD,IBSP,IBWE,IBWO
	K %DT,A,B,DIC,F,I,J,K,M,S,X,Y Q
WRP	I '$D(IBWE(0)) F B=0:1:5 S IBWE(B)=""
	W !!,$S($P(IBWO(0),U,3)["*":IBNOR,1:IBSD) S Y=$P(IBWO(0),U,2) X ^DD("DD") W Y I IBP]"" W ?43,$S($P(IBWE(0),U,3)["*":IBNOR,1:IBSD) S Y=$P(IBWE(0),U,2) X ^DD("DD") W Y
	S IBAO=$P(IBWO(0),U,1) I IBAO']"" W:'$D(IBOPY) !,"* ",IBNC S IBOPY=1 F K=1:1:5 S IBWO(K)="" I IBP]"" W:K>1 ! D WEP
	I IBAO]"" F K=1:1:5 Q:IBWO(K)']""&(IBWE(K)']"")  S X=$S($D(^ICD0((+IBWO(K)),0)):^(0),1:"") W:IBWO(K)]"" !,IBAO,K," - ",$S(X]"":$J($P(X,U,1),6)_"  "_$E($P(X,U,4),1,24),1:IBUC) W:IBWO(K)']"" !,"" D:IBP]"" WEP
	Q
WEP	S IBAE=$P(IBWE(0),U,1) I IBAE']"",'$D(IBOPX) W ?43,"* ",IBNC S (IBWE(1),IBWE(2),IBWE(3),IBWE(4),IBWE(5))="",IBOPX=1
	I IBAE]"",IBWE(K)]"" S X=$S($D(^ICD0((+IBWE(K)),0)):^(0),1:"") W ?43,IBAE,K," - ",$S(X]"":$J($P(X,U,1),6)_"  "_$E($P(X,U,4),1,24),1:IBUC)
	Q
