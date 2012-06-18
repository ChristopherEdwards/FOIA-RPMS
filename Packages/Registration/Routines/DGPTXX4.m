DGPTXX4 ; COMPILED XREF FOR FILE #45.05 ; 02/13/06
 ; 
 S DA=0
A1 ;
 I $D(DIKILL) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGPT(DA(1),"P",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X=$P(DIKZ(0),U,3)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGPT(D0,"P",D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(45.05,2,1,1,2.4)
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X=$P(DIKZ(0),U,5)
 I X'="" K ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,6)
 I X'="" K ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,7)
 I X'="" K ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,8)
 I X'="" K ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,9)
 I X'="" K ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)
 G:'$D(DIKLM) A Q:$D(DIKILL)
END G ^DGPTXX5
