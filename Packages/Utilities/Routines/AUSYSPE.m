AUSYSPE ;ENTER/EDIT IHS SPECIFIC PARAMETERS [ 02/03/87  9:52 AM ]
Z W !!,"EDIT 'IHS' SYSTEM PARAMETERS",!! D DT^DICRW,^AUSITE D DEFCK G END:$D(A("DEFCK"))
A1 W !!,"Select APPLICATION SYSTEM: " D SBRS G END:$D(DFOUT),END:$D(DTOUT),B1:$D(DQOUT),END:Y=""
 S C=0,N="",L=$L(Y)
A2 S N=$O(^AUTTSYS(DUZ(2),N)) G A3:N="",A2:'$D(^(N,1,0)) S X=$P(^(0),"^",1)
 I $E(X,1,L)=Y S C=C+1,AUSYS=N W:C+1 $E(X,L+1,99) W:C>1 !,?5,X
 G A2
A3 G A4:C=1 W "  ??" I 'C G B1
 G A1
NOASK ;ENTRY POINT
 ;SET "AUSYS" EQUAL TO NAMESPACE
A4 D:'$D(DUZ(2)) ^AUSITE D DEFCK G END:$D(A("DEFCK")) W !!,"Edit ",$P(^AUTTSYS(DUZ(2),AUSYS,1,0),"^",1)," Parameters"
 W ! S DIE="^AUTTSYS(DUZ(2),"""_AUSYS_""",",DA=1,DR=".02:9999" D ^DIE
 G END
B1 W !!,"Select From:   ",!,?50 S N=""
B2 S N=$O(^AUTTSYS(DUZ(2),N)) G B9:N="" I $D(^(N,1,0)) W:$X>45 !,?5 W $P(^(0),"^",1),?44
 G B2
B9 W !! G A1
END K AUSYS,A("DEFCK"),X,Y,DA,DR,DIE,N,D,DIC,D0,DQ,%DT Q
DEFCK K A("DEFCK") I '$D(^AUTTSYS(DUZ(2))) W *7,!,"The PARAMETER FILE has not been established for this facility.",!!,"Please contact your system support person.",!! H 5 S A("DEFCK")=""
 Q
GET ;ENTRY POINT - "AUSYS" EQUALS NAMESPACE; DUZ(2) ALREADY DEFINED
 D DEFCK G END:$D(A("DEFCK"))
 S Y=AUSYS_"OPT" K @Y Q:'$D(^AUTTSYS(DUZ(2),AUSYS,1,0))  S Z="",I=2,K=1
G1 S Z=$O(^(Z)) I Z="" K D,Z,Y,I,K,AUSYS Q
 S D=^(Z) G G1:D'["^" F I=I:1 S @(Y_"(K)=$P(D,""^"",I)"),K=K+1 Q:I=$L(D,"^")
 S I=1 G G1
SBRS K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT R Y:DTIME I '$T W *7 R Y:5 G SBRS:Y="." I '$T S (DTOUT,DFOUT)="" Q
 S:Y="" DLOUT="" S:Y="^" (DUOUT,Y)="" S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 Q
