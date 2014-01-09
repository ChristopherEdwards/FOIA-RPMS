DGPTXX12 ; COMPILED XREF FOR FILE #45.05 ; 10/15/12
 ; 
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGPT(DA(1),"P",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X=$P($G(DIKZ(0)),U,3)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(0)=X S X=$P(^DGPT(DA(1),0),U,11)=1 I X S X=DIV S Y(1)=$S($D(^DGPT(D0,"P",D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(45.05,2,1,1,1.4)
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X=$P($G(DIKZ(0)),U,5)
 I X'="" S ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)=""
 S X=$P($G(DIKZ(0)),U,6)
 I X'="" S ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)=""
 S X=$P($G(DIKZ(0)),U,7)
 I X'="" S ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)=""
 S X=$P($G(DIKZ(0)),U,8)
 I X'="" S ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)=""
 S X=$P($G(DIKZ(0)),U,9)
 I X'="" S ^DGPT(DA(1),"P","AP6",$E(X,1,30),DA)=""
CR1 S DIXR=356
 K X
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,5)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"P",1)
CR2 S DIXR=357
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,6)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"P",2)
CR3 S DIXR=358
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,7)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"P",3)
CR4 S DIXR=359
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,8)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"P",4)
CR5 S DIXR=360
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"P",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,9)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"P",5)
CR6 K X
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^DGPTXX13
