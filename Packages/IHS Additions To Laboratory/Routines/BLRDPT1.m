BLRDPT1 ; IHS/DIR/FJE - PATIENT VARIABLES ;
 ;;5.2;BLR;;NOV 01, 1997
 ;
 ;;MAS VERSION 5.0;
1 ;Demographic [DEM]
 N W,Z
 ;
 ; -- name [1 - NM]
 S VAX=^DPT(DFN,0),@VAV@($P(VAS,"^",1))=$P(VAX,"^")
 ;
 ; -- ssn [2 - SS]
 S Z=$P(VAX,"^",9) S:Z]"" @VAV@($P(VAS,"^",2))=Z_$S(Z]"":"^"_$E(Z,1,3)_"-"_$E(Z,4,5)_"-"_$E(Z,6,10),1:"")
 ;
 ; -- date of birth [2 - DB]
 S Z=$P(VAX,"^",3),Y=Z I Y]"" X ^DD("DD") S @VAV@($P(VAS,"^",3))=Z_"^"_Y
 ;
 ; -- age [4 - AG]
 S W=$S('$D(^DPT(DFN,.35)):"",'^(.35):"",1:+^(.35)) S Y=$S('W:DT,1:W) S:Z]"" @VAV@($P(VAS,"^",4))=$E(Y,1,3)-$E(Z,1,3)-($E(Y,4,7)<$E(Z,4,7))
 I @VAV@($P(VAS,"^",4))<2 D PAGE  ;IHS/ANMC/CLS 10/15/94
 ;
 ; -- expired date [6 - EX]
 S (Y,Z)=W X:Y]"" ^DD("DD") S:Z]"" @VAV@($P(VAS,"^",6))=Z_"^"_Y
 ;
 ; -- sex [5 - SX]
 S Z=$P(VAX,"^",2) S:Z]"" @VAV@($P(VAS,"^",5))=Z_"^"_$S(Z="M":"MALE",Z="F":"FEMALE",1:"") K Z
 ;
 ; -- remarks [7 - RE]
 S @VAV@($P(VAS,"^",7))=$P(VAX,"^",10)
 ;
 ; -- race [8 - RA]
 S Z=$P(VAX,"^",6),@VAV@($P(VAS,"^",8))=Z_$S($D(^DIC(10,+Z,0)):"^"_$P(^(0),"^"),1:"")
 ;
 ; -- religion [9 - RP]
 S Z=$P(VAX,"^",8),@VAV@($P(VAS,"^",9))=Z_$S($D(^DIC(13,+Z,0)):"^"_$P(^(0),"^"),1:"")
 ;
 ; -- marital status [10 - MS]
 S Z=$P(VAX,"^",5),@VAV@($P(VAS,"^",10))=Z_$S($D(^DIC(11,+Z,0)):"^"_$P(^(0),"^"),1:"")
 ;
 ; -- IHS health record number [11 - HR]
 S Z=$S($P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),U,2)'="":$P(^(0),U,2),1:"??"),@VAV@($P(VAS,"^",11))=Z  ;IHS/ANMC/CLS 10/15/94
 Q
 ;
PAGE ; -- IHS printable age  ;IHS/ANMC/CLS 10/15/94
 N X,X1,X2,Y,AUX,D0
 S D0=DFN X ^DD(9000001,1102.98,9.3) S X=$P(Y(9000001,1102.98,101),U,3),Y=X,X=Y(9000001,1102.98,1),X=X,X1=X,X2=Y,X="" D:X2 ^%DTC:X1 S AUX=X\365.25,X=$S(AUX>2:AUX_" YRS",X<31:X_" DYS",1:X\30_" MOS") K AUX S D0=Y(9000001,1102.98,80)
 S @VAV@($P(VAS,"^",4))=X Q
 ;
2 ;Other Patient Variables [OPD]
 N W,Z
 S VAX=^DPT(DFN,0)
 ;
 ; -- city of birth [1 - BC]
 S @VAV@($P(VAS,"^",1))=$P(VAX,"^",11)
 ;
 ; -- state of birth [2 - BS]
 S Z=$P(VAX,"^",12),@VAV@($P(VAS,"^",2))=Z_$S($D(^DIC(5,+Z,0)):"^"_$P(^(0),"^",1),1:"")
 ;
 ; -- occupation [6 - OC]
 S @VAV@($P(VAS,"^",6))=$P(VAX,"^",7)
 ;
 ; -- names
 S VAX=$S($D(^DPT(DFN,.24)):^(.24),1:"")
 S @VAV@($P(VAS,"^",3))=$P(VAX,"^",1) ; father's        [3 - FN]
 S @VAV@($P(VAS,"^",4))=$P(VAX,"^",2) ; mother's        [4 - MN]
 S @VAV@($P(VAS,"^",5))=$P(VAX,"^",3) ; mother's maiden [5 - MM]
 ;
 ; -- employment status [7 - ES]
 S VAX=$S($D(^DPT(DFN,.311)):^(.311),1:""),W="EMPLOYED FULL TIME^EMPLOYED PART TIME^NOT EMPLOYED^SELF EMPLOYED^RETIRED^ACTIVE MILITARY DUTY^UNKNOWN"
 S Z=$P(VAX,"^",15),@VAV@($P(VAS,"^",7))=Z_$S(Z:"^"_$P(W,"^",Z),1:"")
 Q
 ;
3 ;Address [ADD]
 S VABEG=$S($D(VATEST("ADD",9)):VATEST("ADD",9),1:DT),VAEND=$S($D(VATEST("ADD",10)):VATEST("ADD",10),1:DT)
 I $S($D(VAPA("P")):1,'$D(^DPT(DFN,.121)):1,$P(^(.121),"^",9)'="Y":1,'$P(^(.121),"^",7):1,$P(^(.121),"^",7)>VABEG:1,'$P(^(.121),"^",8):0,1:$P(^(.121),"^",8)<VAEND) S VAX=$S($D(^DPT(DFN,.11)):^(.11),1:""),VAX(1)=0
 E  S VAX=$S($D(^DPT(DFN,.121)):^(.121),1:""),VAX(1)=1
 F I=1:1:6 S VAZ=$P(VAX,"^",I),@VAV@($P(VAS,"^",I))=VAZ I I=5,$D(^DIC(5,+VAZ,0)) S VAZ=$P(^(0),"^"),@VAV@($P(VAS,"^",5))=@VAV@($P(VAS,"^",5))_"^"_VAZ
 I 'VAX(1) S VAZ=$P(VAX,"^",7) S:$D(^DIC(5,+$P(VAX,"^",5),1,+VAZ,0)) VAZ=VAZ_"^"_$P(^(0),"^",1) S @VAV@($P(VAS,"^",7))=VAZ S:$D(^DPT(DFN,.13)) @VAV@($P(VAS,"^",8))=$P(^(.13),"^",1) G Q3
 S @VAV@($P(VAS,"^",8))=$P(VAX,"^",10)
 F I=7,8 S VAZ=$P(VAX,"^",I),Y=VAZ X:Y]"" ^DD("DD") S @VAV@($P(VAS,"^",I+2))=VAZ_"^"_Y
Q3 K VABEG,VAEND Q
 ;
4 ;Other Address [OAD]
 I $S('$D(VAOA("A")):1,VAOA("A")<1:1,VAOA("A")>6:1,1:0) S VAX=.21
 E  S VAX="."_$P("33^34^211^331^311^25","^",+VAOA("A"))
 S VAX(1)=VAX,VAX=$S($D(^DPT(DFN,VAX(1))):^(VAX(1)),1:"") I VAX(1)=.25 S VAX=$P(VAX,"^",1)_"^^"_$P(VAX,"^",2,99)
 S VAX(2)=0 F I=3,4,5,6,7,8 S VAX(2)=VAX(2)+1,@VAV@($P(VAS,"^",VAX(2)))=$P(VAX,"^",I)
 S @VAV@($P(VAS,"^",7))="",@VAV@($P(VAS,"^",8))=$P(VAX,"^",9),VAX(2)=8
 F I=1,2 S VAX(2)=VAX(2)+1,@VAV@($P(VAS,"^",VAX(2)))=$P(VAX,"^",I)
 I "^.311^.25"[("^"_VAX(1)_"^") S @VAV@($P(VAS,"^",10))=""
 S VAZ=@VAV@($P(VAS,"^",5)) I VAZ,$D(^DIC(5,+VAZ,0)) S VAZ(1)=$P(^(0),"^",1),@VAV@($P(VAS,"^",5))=VAZ_"^"_VAZ(1)
 Q
