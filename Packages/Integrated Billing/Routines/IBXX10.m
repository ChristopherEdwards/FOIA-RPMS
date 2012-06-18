IBXX10 ; COMPILED XREF FOR FILE #399 ; 02/13/06
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DGCR(399,"B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,1)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,.01,1,3,1.4)
 S X=$P(DIKZ(0),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=$S(($D(DUZ)#2):DUZ,1:"") X ^DD(399,.01,1,4,1.4)
 S X=$P(DIKZ(0),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,14)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y X ^DD(399,.01,1,5,1.1) X ^DD(399,.01,1,5,1.4)
 S X=$P(DIKZ(0),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=1 X ^DD(399,.01,1,6,1.4)
 S X=$P(DIKZ(0),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.01,1,7,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,19),X=X S DIU=X K Y S X=DIV S X=$P($G(^IBE(350.9,1,1)),U,26) X ^DD(399,.01,1,7,1.4)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" S ^DGCR(399,"C",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,3)
 I X'="" S ^DGCR(399,"D",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,3)
 I X'="" S IBN=$P(^DGCR(399,DA,0),"^",2) S:$D(IBN) ^DGCR(399,"APDT",IBN,DA,9999999-X)="" K IBN
 S X=$P(DIKZ(0),U,3)
 I X'="" S ^DGCR(399,"ABNDT",DA,9999999-X)=""
 S X=$P(DIKZ(0),U,5)
 I X'="" S ^DGCR(399,"ABT",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,7)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.07,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X="Y" X ^DD(399,.07,1,1,1.4)
 S X=$P(DIKZ(0),U,7)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y X ^DD(399,.07,1,2,1.1) X ^DD(399,.07,1,2,1.4)
 S X=$P(DIKZ(0),U,7)
 I X'="" S ^DGCR(399,"AD",$E(X,1,30),DA)=""
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,8)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.08,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV S X=2 X ^DD(399,.08,1,1,1.4)
 S X=$P(DIKZ(0),U,8)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.08,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X=DIV S X=2 X ^DD(399,.08,1,2,1.4)
 S X=$P(DIKZ(0),U,8)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X=99 X ^DD(399,.08,1,3,1.4)
 S X=$P(DIKZ(0),U,8)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.08,1,4,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X=DIV D DIS^IBCU S X=X X ^DD(399,.08,1,4,1.4)
 S X=$P(DIKZ(0),U,8)
 I X'="" S ^DGCR(399,"APTF",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,8)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^DGCR(399,DA,0),U,5)<3 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X=DIV S X=+$$LOS1^IBCU64(DA) X ^DD(399,.08,1,6,1.4)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,11)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.11,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X=DIV D EN1^IBCU5 X ^DD(399,.11,1,1,1.4)
 S X=$P(DIKZ(0),U,11)
 I X'="" D EN^IBCU5
 S X=$P(DIKZ(0),U,11)
 I X'="" S DGRVRCAL=1
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,13)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,.13,1,1,1.4)
 S X=$P(DIKZ(0),U,13)
 I X'="" I X>0,X<3,$P(^DGCR(399,DA,0),U,2) S ^DGCR(399,"AOP",$P(^(0),U,2),DA)=""
 S X=$P(DIKZ(0),U,13)
 I X'="" I +X=3 S ^DGCR(399,"AST",+X,DA)=""
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,17)
 I X'="" S ^DGCR(399,"AC",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,19)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.19,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV S X=4 X ^DD(399,.19,1,1,1.4)
 S X=$P(DIKZ(0),U,19)
 I X'="" S DGRVRCAL=1
 S DIKZ("S")=$G(^DGCR(399,DA,"S"))
 S X=$P(DIKZ("S"),U,1)
 I X'="" S ^DGCR(399,"APD",$E(X,1,30),DA)=""
 S X=$P(DIKZ("S"),U,3)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,4)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,3,1,1,1.4)
 S X=$P(DIKZ("S"),U,3)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,3,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,3,1,2,1.4)
 S X=$P(DIKZ("S"),U,3)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,3,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X=+X X ^DD(399,3,1,3,1.4)
 S DIKZ("S")=$G(^DGCR(399,DA,"S"))
 S X=$P(DIKZ("S"),U,6)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,7)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,6,1,1,1.4)
 S X=$P(DIKZ("S"),U,6)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,6,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,6,1,2,1.4)
 S X=$P(DIKZ("S"),U,6)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y=Y(0) X:$D(^DD(399,6,2)) ^(2) S X=Y="YES" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=2 X ^DD(399,6,1,3,1.4)
 S DIKZ("S")=$G(^DGCR(399,DA,"S"))
 S X=$P(DIKZ("S"),U,9)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,10)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,9,1,1,1.4)
 S X=$P(DIKZ("S"),U,9)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,9,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,9,1,2,1.4)
 S X=$P(DIKZ("S"),U,9)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y=Y(0) X:$D(^DD(399,9,2)) ^(2) S X=Y="YES" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=3 X ^DD(399,9,1,3,1.4)
 S DIKZ("S")=$G(^DGCR(399,DA,"S"))
 S X=$P(DIKZ("S"),U,12)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,14)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,12,1,1,1.4)
 S X=$P(DIKZ("S"),U,12)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,12,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,12,1,2,1.4)
 S X=$P(DIKZ("S"),U,12)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,12,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(399,12,1,3,1.4)
 S X=$P(DIKZ("S"),U,12)
 I X'="" S ^DGCR(399,"AP",$E(X,1,30),DA)=""
 S DIKZ("S")=$G(^DGCR(399,DA,"S"))
 S X=$P(DIKZ("S"),U,14)
END G ^IBXX11
