FHSPED	; HISC/REL/NCA - Enter/Cancel Standing Orders ;7/22/94  13:59 
	;;5.0;Dietetics;;Oct 11, 1995
EN1	; Enter Standing Orders for Patient
	D NOW^%DTC S NOW=% S ALL=0 D ^FHDPA G:'DFN KIL
E1	W ! S NO=1 D LIS G:'LN N1
	K DIR W ! S DIR(0)="YA",DIR("A")="Edit a Standing Order? ",DIR("B")="YES" D ^DIR K DIR G:$D(DIRUT)!$D(DIROUT) EN1 G:Y<1 N1
N0	R !!,"Edit which Order #? ",X:DTIME G:'$T!("^"[X) EN1 I X'?1N.N!(X<1)!(X>LN) W *7," Enter # of Order to Edit" G N0
	S SP=$P(LS,",",+X),SP=$P($G(^FHPT(DFN,"A",ADM,"SP",+SP,0)),"^",2) I $D(P(+X,SP)) S LN=+X  G N1A
	W !!,"Standing Order ",$P($G(^FH(118.3,+SP,0)),"^",1)," added" S LN=LN+1,P(LN,SP)="" G N1A
N1	K DIC W ! S DIC="^FH(118.3,",DIC("A")="Enter Standing Order: ",DIC(0)="AEQM"
	D ^DIC K DIC,DLAYGO G EN1:"^"[X!$D(DTOUT),N1:Y<1 S SP=+Y
	W !!,"Standing Order ",$P($G(^FH(118.3,+SP,0)),"^",1)," added"
	S LN=LN+1,P(LN,SP)=""
N1A	W !,"Standing Order: ",$P($G(^FH(118.3,+SP,0)),"^",1)_" // " R X:DTIME G KIL:'$T,FHSPED:X="^"
	I X="@" D EN3 W "  .. Done" G E1
	I X'="" W *7,!,"Press Return to take Default or ""@"" to Delete" G N1A
	S $P(P(LN,SP),"^",5)=SP
N2	W !,"Select Meal (B,N,E or ALL): ",$S($P(P(LN,SP),"^",3)'="":$P(P(LN,SP),"^",3)_" // ",1:"") R MEAL:DTIME G:'$T!(MEAL="^") KIL
	I MEAL="" G:$P(P(LN,SP),"^",3)="" KIL S MEAL=$P(P(LN,SP),"^",3),$P(P(LN,SP),"^",6)=MEAL G N2A
	I MEAL="@" S $P(P(LN,SP),"^",3)="" G N2
	S X=MEAL D TR^FH S MEAL=X S:$P("ALL",MEAL,1)="" MEAL="BNE" S X=MEAL,MEAL="" S:X["B" MEAL="B" S:X["N" MEAL=MEAL_"N" S:X["E" MEAL=MEAL_"E"
	I $L(X)'=$L(MEAL) W *7,!,"Select B for Breakfast, N for Noon, E for Evening or ALL for all meals",!,"Answer may be multiple meals, e.g., BN or NE" G N2
	S $P(P(LN,SP),"^",6)=MEAL
N2A	W !,"Quantity:  ",$S($P(P(LN,SP),"^",4):$P(P(LN,SP),"^",4)_"// ",1:"1// ") R NUM:DTIME S:NUM="" NUM=$S($P(P(LN,SP),"^",4):$P(P(LN,SP),"^",4),1:1) G:'$T!(NUM="^") KIL
	I NUM="@" S $P(P(LN,SP),"^",4)="" G N2A
	I NUM'?1N!(NUM<1) W !,*7,"Enter a number from 1-9." G N2A
	S $P(P(LN,SP),"^",7)=NUM
	S C1=$P(P(LN,SP),"^",2,4),C2=$P(P(LN,SP),"^",5,7) G:C1=C2 E1
N3	W !!,"ADD this Order? Y// " R YN:DTIME G:'$T!(YN="^") KIL S:YN="" YN="Y" S X=YN D TR^FH S YN=X I $P("YES",YN,1)'="",$P("NO",YN,1)'="" W *7,"  Answer YES or NO" G N3
	G:YN?1"N".E E1
	I C1'="^^" S OLD=$P(P(LN,SP),"^",1),$P(^FHPT(DFN,"A",ADM,"SP",OLD,0),"^",6,7)=NOW_"^"_DUZ K ^FHPT("ASP",DFN,ADM,OLD) S EVT="S^C^"_OLD D ^FHORX
	S $P(P(LN,SP),"^",2,4)="^^",$P(P(LN,SP),"^",2,4)=$P(P(LN,SP),"^",5,7),$P(P(LN,SP),"^",5,7)="^^"
ADD	; Add Standing Order
	L +^FHPT(DFN,"A",ADM,"SP",0)
	I '$D(^FHPT(DFN,"A",ADM,"SP",0)) S ^FHPT(DFN,"A",ADM,"SP",0)="^115.08^^"
	S X=^FHPT(DFN,"A",ADM,"SP",0),NO=$P(X,"^",3)+1,^(0)=$P(X,"^",1,2)_"^"_NO_"^"_($P(X,"^",4)+1)
	L -^FHPT(DFN,"A",ADM,"SP",0) I $D(^FHPT(DFN,"A",ADM,"SP",NO)) G ADD
	S ^FHPT(DFN,"A",ADM,"SP",NO,0)=NO_"^"_SP_"^"_MEAL_"^"_NOW_"^"_DUZ_"^^^"_NUM,^FHPT("ASP",DFN,ADM,NO)="",LS=LS_NO_","
	S $P(P(LN,SP),"^",1)=NO,EVT="S^O^"_NO D ^FHORX W "  .. done" G E1
EN2	; Standing Order Inquiry
	S ALL=0 D ^FHDPA G:'DFN KIL S NO=0 D LIS G EN2
EN3	; Cancel Standing Order
	S NO=$P($G(P(LN,SP)),"^",1) Q:'NO
	S $P(^FHPT(DFN,"A",ADM,"SP",NO,0),"^",6,7)=NOW_"^"_DUZ
	S X=^FHPT(DFN,"A",ADM,"SP",NO,0),SP=$P(X,"^",2),MEAL=$P(X,"^",3),NUM=""
	K ^FHPT("ASP",DFN,ADM,NO),P(LN,SP) S EVT="S^C^"_NO D ^FHORX Q
LIS	S NAM=$P(^DPT(DFN,0),"^",1) D CUR^FHORD7
	W !!,NAM,"  " W:WARD'="" "( ",WARD," )"
	W !!,"Current Diet: ",$S(Y'="":Y,1:"No current order")
	K N,P S CTR=0
	F K=0:0 S K=$O(^FHPT("ASP",DFN,ADM,K)) Q:K<1  S X=^FHPT(DFN,"A",ADM,"SP",K,0),M=$P(X,"^",3),M=$S(M="BNE":"A",1:$E(M,1)),N(M,K)=$P(X,"^",2,3)_"^"_$P(X,"^",8,9)
	S LN=0,LS="" I $O(N(""))="" W !!,"No Active Standing Orders" Q
	W !!,"Active Standing Orders ",!
	F M="A","B","N","E" D
	.F K=0:0 S K=$O(N(M,K)) Q:K<1  S Z=+N(M,K) I Z D
	..S LN=LN+1,LS=LS_K_"," D L1 W ! W:NO $J(LN,2)
	..S NUM=$P(N(M,K),"^",3)
	..W ?5,M2,?18,$S(NUM:NUM,1:1)," ",$P(^FH(118.3,Z,0),"^",1)_$S($P(N(M,K),"^",4)'="Y":" (I)",1:"")
	..S P(LN,+Z)=K_"^"_$P(N(M,K),"^",1,3) Q
	.Q
	Q
L1	; Store Standing Order By Meal
	S M1=$P(N(M,K),"^",2) I M1="BNE" S M2="All Meals" Q
	S L=$E(M1,1),M2=$S(L="B":"Break",L="N":"Noon",1:"Even")
	S L=$E(M1,2) Q:L=""  S M2=M2_","_$S(L="B":"Break",L="N":"Noon",1:"Even") Q
KIL	G KILL^XUSCLEAN
