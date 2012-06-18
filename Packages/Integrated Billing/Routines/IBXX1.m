IBXX1 ; COMPILED XREF FOR FILE #399 ; 02/13/06
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^DGCR(399,"C",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,3)
 I X'="" K ^DGCR(399,"D",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,3)
 I X'="" S IBN=$P(^DGCR(399,DA,0),"^",2) I $D(IBN) K ^DGCR(399,"APDT",IBN,DA,9999999-X),IBN
 S X=$P(DIKZ(0),U,3)
 I X'="" K ^DGCR(399,"ABNDT",DA,9999999-X)
 S X=$P(DIKZ(0),U,5)
 I X'="" K ^DGCR(399,"ABT",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,7)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.07,1,1,2.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X="N" X ^DD(399,.07,1,1,2.4)
 S X=$P(DIKZ(0),U,7)
 I X'="" K ^DGCR(399,"AD",$E(X,1,30),DA)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,8)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X="" X ^DD(399,.08,1,4,2.4)
 S X=$P(DIKZ(0),U,8)
 I X'="" K ^DGCR(399,"APTF",$E(X,1,30),DA)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,11)
 I X'="" D DEL^IBCU5
 S X=$P(DIKZ(0),U,11)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ(0),U,13)
 I X'="" I $P(^DGCR(399,DA,0),U,2) K ^DGCR(399,"AOP",$P(^(0),U,2),DA)
 S X=$P(DIKZ(0),U,13)
 I X'="" K ^DGCR(399,"AST",+X,DA)
 S X=$P(DIKZ(0),U,17)
 I X'="" K ^DGCR(399,"AC",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,19)
 I X'="" S DGRVRCAL=2
 S DIKZ("S")=$G(^DGCR(399,DA,"S"))
 S X=$P(DIKZ("S"),U,1)
 I X'="" K ^DGCR(399,"APD",$E(X,1,30),DA)
 S X=$P(DIKZ("S"),U,12)
 I X'="" K ^DGCR(399,"AP",$E(X,1,30),DA)
 S DIKZ("C")=$G(^DGCR(399,DA,"C"))
 S X=$P(DIKZ("C"),U,14)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"C")):^("C"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X="" X ^DD(399,64,1,1,2.4)
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,1)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ("M"),U,1)
 I X'="" K:$P(^DGCR(399,DA,0),"^",2) ^DGCR(399,"AE",$P(^(0),U,2),X,DA)
 S X=$P(DIKZ("M"),U,11)
 I X'="" D DEL^IBCU5
 S X=$P(DIKZ("M"),U,11)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ("M"),U,12)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X="" X ^DD(399,112,1,1,2.4)
 S X=$P(DIKZ("M"),U,12)
 I X'="" D KIX^IBCNS2(DA,"I1")
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,13)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399,113,1,1,2.4)
 S X=$P(DIKZ("M"),U,13)
 I X'="" D KIX^IBCNS2(DA,"I2")
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,14)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(399,114,1,1,2.4)
 S X=$P(DIKZ("M"),U,14)
 I X'="" D KIX^IBCNS2(DA,"I3")
 S DIKZ("U")=$G(^DGCR(399,DA,"U"))
 S X=$P(DIKZ("U"),U,1)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ("U"),U,2)
 I X'="" S DGRVRCAL=2
 S DIKZ("U1")=$G(^DGCR(399,DA,"U1"))
 S X=$P(DIKZ("U1"),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,2)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(399,202,1,1,2.4)
 S DIKZ("U1")=$G(^DGCR(399,DA,"U1"))
 S X=$P(DIKZ("U1"),U,10)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X="" X ^DD(399,210,1,1,2.4)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^DGCR(399,"B",$E(X,1,30),DA)
END G ^IBXX2
