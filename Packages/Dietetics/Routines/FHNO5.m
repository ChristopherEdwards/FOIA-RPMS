FHNO5 ; HISC/REL - Enter/Edit Supplemental Fdgs. ;7/27/94  14:45 
 ;;5.0;Dietetics;**30**;Oct 11, 1995
 D NOW^%DTC S NOW=%
 S ALL=0 D ^FHDPA G:'DFN KIL W ! D LIS^FHNO7 S PNO=Y
S0 K DIC S DIC="^FH(118.1,",DIC(0)="EQM",OLD=$S('NM:"",1:$P(^FH(118.1,NM,0),"^",1))
 W !!,"Supplemental Feeding Menu: " W:NM OLD," // " R X:DTIME G KIL:'$T,FHNO5:X["^"
 I X="" G FHNO5:'NM,S1
 I X="@" D CAN W "  .. cancelled" G FHNO5
 D ^DIC K DIC G S0:Y<1 S NM=+Y
S1 S KK=1,PNN="^"_NOW_"^"_DUZ_"^"_NM_"^"_$S(NM=1:$P(PNO,"^",5,29),1:^FH(118.1,NM,1))
 I NM'=1 G UPD:$P(PNO,"^",4,29)=$P(PNN,"^",4,29) D CAN G ADD
 S DIC="^FH(118,",DIC(0)="EQM",DIC("S")="I $P(^(0),U,3)'=""Y"""
G1 G:KK>12 G5 S T1=$P("10am^2pm^8pm","^",KK-1\4+1),T2="#"_(KK-1#4+1),P1=KK*2+3
 S DIC("A")=T1_" Feeding "_T2_": "
 S OLD=$P(PNN,"^",P1) I OLD S DIC("A")=DIC("A")_$P(^FH(118,+OLD,0),"^",1)_"// "
G2 W !!,DIC("A") R X:DTIME G:'$T!(X["^") G5
 I X="" G:OLD G3 S KK=$S(KK<5:5,KK<9:9,1:13) G G1
 I OLD,X="@" S $P(PNN,"^",P1)="",$P(PNN,"^",P1+1)="" S KK=KK+1 G G1
 D ^DIC G:Y<1 G2 S Y=+Y,K1=$S(KK<5:1,KK<9:5,1:9)
 F L=K1:1:K1+3 I L'=KK,$P(PNN,"^",L*2+3)=Y W *7," .. DUPLICATE OF EXISTING ITEM!" G G2
 S:OLD'=Y $P(PNN,"^",P1)=Y
G3 S OLD=$P(PNN,"^",P1+1)
G4 W !,T1," ",T2," Qty: ",$S(OLD="":1,1:OLD),"// " R X:DTIME G:'$T!(X["^") G5
 S:X="@" X=0 I X="" S:OLD="" $P(PNN,"^",P1+1)=1 S KK=KK+1 G G1
 I X'?1N.N!(X>20) W *7," ??" S X="?"
 I X["?" W !?5,"Enter a whole number between 1 and 20" G G4
 I 'X S $P(PNN,"^",P1)="",$P(PNN,"^",P1+1)="" S KK=KK+1 G G1
 S $P(PNN,"^",P1+1)=X,KK=KK+1 G G1
G5 S KK=3,X="" F T1=0:1:2 S P1=T1*8-1 F T2=1:1:4 S KK=KK+2 I $P(PNN,"^",KK) S P1=P1+2,$P(X,"^",P1,P1+1)=$P(PNN,"^",KK,KK+1)
 I X="" D CAN G FHNO5
G6 S P1=$P(PNN,"^",29) S:P1="" P1="D" W !!,"Dietary or Therapeutic? ",P1,"// " R Y:DTIME S:'$T!("^"[Y) Y=P1
 S:$P("dietary",Y,1)="" Y="D" S:$P("therapeutic",Y,1)="" Y="T"
 I $P("DIETARY",Y,1)'="",$P("THERAPEUTIC",Y,1)'="" W *7,!?5," Answer D for Dietary use or T for Therapeutic use" G G6
 S $P(X,"^",25)=$E(Y,1),PNN=$P(PNN,"^",1,4)_"^"_X
 G:$P(PNO,"^",5,29)=X UPD D CAN
ADD ; Add Supplemental Feeding
 L +^FHPT(DFN,"A",ADM,"SF",0)
 I '$D(^FHPT(DFN,"A",ADM,"SF",0)) S ^FHPT(DFN,"A",ADM,"SF",0)="^115.07^^"
 S X=^FHPT(DFN,"A",ADM,"SF",0),NO=$P(X,"^",3)+1,^(0)=$P(X,"^",1,2)_"^"_NO_"^"_($P(X,"^",4)+1)
 L -^FHPT(DFN,"A",ADM,"SF",0) I $D(^FHPT(DFN,"A",ADM,"SF",NO)) G ADD
 S ^FHPT(DFN,"A",ADM,"SF",NO,0)=NO_"^"_$P(PNN,"^",2,99)
 S $P(^FHPT(DFN,"A",ADM,0),"^",7)=NO
 I NO'="" S EVT="F^O^"_NO D ^FHORX  ;file event, P30
UPD S:NO $P(^FHPT(DFN,"A",ADM,"SF",NO,0),"^",30,31)=NOW_"^"_DUZ G FHNO5
CAN ; Cancel SF Order
 S NO=$P(^FHPT(DFN,"A",ADM,0),"^",7),$P(^(0),"^",7)=""
 S:NO $P(^FHPT(DFN,"A",ADM,"SF",NO,0),"^",32,33)=NOW_"^"_DUZ
 I NO'="" S EVT="F^C^"_NO D ^FHORX  ;file event, P30
 Q
KIL G KILL^XUSCLEAN
