BLRDPT5 ; IHS/DIR/FJE - PATIENT VARIABLES ;
 ;;5.2;BLR;;NOV 01, 1997
 ;
 ;;MAS VERSION 5.0;
10 ;Registration/Disposition [REG]
 S VARP("C")=$S('$D(VARP("C")):999999999,'VARP("C"):999999999,1:+VARP("C")),VARP("F")=$S('$D(VARP("F")):0,VARP("F")?7N.E:VARP("F"),1:0),VARP("T")=$S('$D(VARP("T")):0,VARP("T")?7N.E:VARP("T"),1:0)
 I VARP("F") S VARP("F")=$P(VARP("F"),".",1)_"."_$S($P(VARP("F"),".",2):$P(VARP("F"),".",2),1:""),VARP("F")=9999999=VARP("F")
 I VARP("T") S VARP("T")=$P(VARP("T"),".",1)_"."_$S($P(VARP("T"),".",2):$P(VARP("T"),".",2),1:999999),VARP("T")=9999999-VARP("T")
 S VAX=VARP("T"),VAX(1)=0 F I=0:0 S VAX=$O(^DPT(DFN,"DIS",VAX)) Q:VAX=""!(VAX<VARP("F"))!(VAX(1)+1>VARP("C"))  S VAX(2)=^(VAX,0),VAX(1)=VAX(1)+1 D 101:+VAX(2)>0
 Q
101 S (VAX("I"),VAX("E"))="",VAX(3)=0 F I=1,2,3,4,5,6,7,9 S VAX(3)=VAX(3)+1,$P(VAX("I"),"^",VAX(3))=$P(VAX(2),"^",I) D 102
 S @VAV@(VAX(1),"I")=VAX("I"),@VAV@(VAX(1),"E")=VAX("E") Q
102 I "^1^6^"[("^"_VAX(3)_"^") S Y=$P(VAX("I"),"^",VAX(3)) I Y]"" X ^DD("DD") S $P(VAX("E"),"^",VAX(3))=Y Q
 S X(1)=$S($D(^DD(2.101,$S(I<9:(I-1),1:I),0)):$P(^(0),"^",3),1:"") I "^2^3^"[("^"_VAX(3)_"^"),$P(VAX("I"),"^",VAX(3))]"",X(1)]"" S $P(VAX("E"),"^",VAX(3))=$P($P(X(1),$P(VAX("I"),"^",VAX(3))_":",2),";",1) Q
 I "^4^5^7^8^"[("^"_VAX(3)_"^"),$P(VAX("I"),"^",VAX(3))]"",X(1)]"" S X(1)="^"_X(1)_$P(VAX("I"),"^",VAX(3))_",0)" I $D(@(X(1))) S $P(VAX("E"),"^",VAX(3))=$P(^(0),"^",1)
 Q
 ;
11 ;Clinic Enrollments [SDE]
 S (VAX,VAX(1))=0 F I=0:0 S VAX=$O(^DPT(DFN,"DE",VAX)) Q:VAX'>0  S VAZ=$S($D(^DPT(DFN,"DE",VAX,0)):^(0),1:"") I +VAZ,$P(VAZ,"^",2)'="I" S VAX(3)=0 D 111
 Q
111 S VAX(4)=0 F I1=0:0 S VAX(4)=$O(^DPT(DFN,"DE",1,VAX(4))) Q:VAX(4)'>0!(VAX(3))  S VAZ(1)=$S($D(^DPT(DFN,"DE",VAX,1,VAX(4),0)):^(0),1:"") I +VAZ(1),$P(VAZ(1),"^",3)']"" S VAX(3)=VAZ(1)
 Q:'VAX(3)  S (VAX("I"),VAX("E"))="",Y=+VAX(3),$P(VAX("I"),"^",2)=Y X ^DD("DD") S $P(VAX("E"),"^",2)=Y
 S $P(VAX("I"),"^",3)=$P(VAX(3),"^",2) I $P(VAX("I"),"^",3)]"" S $P(VAX("E"),"^",3)=$S($P(VAX("I"),"^",3)="O":"OPT",$P(VAX("I"),"^",3)="A":"AC",1:"")
 S $P(VAX("I"),"^",1)=+VAZ,$P(VAX("E"),"^",1)=$S($D(^SC(+VAZ,0)):$P(^(0),"^",1),1:""),VAX(1)=VAX(1)+1,@VAV@(VAX(1),"I")=VAX("I"),@VAV@(VAX(1),"E")=VAX("E") Q
 ;
12 ;Appointments [SDA]
 D NOW^%DTC S VASD("F")=$S('$D(VASD("F")):%,VASD("F")?7N.E:VASD("F"),1:%),VASD("T")=$S($D(VASD("T")):+VASD("T"),1:0),VASD("W")=$S('$D(VASD("W")):12,1:VASD("W")),VAZ(2)=$S($D(VASD("N")):VASD("N"),1:9999) S:'VASD("T") VASD("T")=999999999999999
 S VAZ="^I^N^NA^C^CA^PC^PCA^",VAZ(1)="^" F I=1:1 S I1=+$E(VASD("W"),I) Q:'I1  S VAZ(1)=VAZ(1)_$P(VAZ,"^",I1)_"^"
 I VASD("T")<99999999 S VASD("T")=$P(VASD("T"),".",1)_"."_$S($P(VASD("T"),".",2):$P(VASD("T"),".",2),1:2359)
 S VASD("C")=0 I $O(VASD("C",0))>0 S VASD("C")=1
 S VAX=VASD("F"),VAX(1)=0 F I=0:0 S VAX=$O(^DPT(DFN,"S",VAX)) Q:VAX'>0!(VAX>VASD("T"))!(VAX(1)'<VAZ(2))  S VAZ=$S($D(^DPT(DFN,"S",VAX,0)):^(0),1:"") I VAZ,$P(VAZ,"^",2)=""!(VAZ(1)[("^"_$P(VAZ,"^",2)_"^")) D 121,122:VAX(5)
 Q
121 S VAX(5)=1 I VASD("W")'[1,$P(VAZ,"^",2)']"" S VAX(5)=0 Q
 I VASD("C"),'$D(VASD("C",+VAZ)) S VAX(5)=0 Q
 S (VAX("I"),VAX("E"))="",VAX(2)=1,$P(VAX("I"),"^",1)=+VAX F I1=1,2,16 S VAX(2)=VAX(2)+1,$P(VAX("I"),"^",VAX(2))=$P(VAZ,"^",I1)
 Q
122 S Y=+VAX X ^DD("DD") S $P(VAX("E"),"^",1)=Y,Y=$P(VAZ,"^",1),$P(VAX("E"),"^",2)=$S($D(^SC(+Y,0)):$P(^(0),"^",1),1:""),Y=+$P(VAX("I"),"^",4),$P(VAX("E"),"^",4)=$S($D(^SD(409.1,+Y,0)):$P(^(0),"^",1),1:"")
 S Y=$P(VAX("I"),"^",3) I Y]"" S X=$S($D(^DD(2.98,3,0)):$P(^(0),"^",3),1:""),$P(VAX("E"),"^",3)=$P($P(X,Y_":",2),";",1)
 S VAX(1)=VAX(1)+1,@VAV@(VAX(1),"I")=VAX("I"),@VAV@(VAX(1),"E")=VAX("E") Q
