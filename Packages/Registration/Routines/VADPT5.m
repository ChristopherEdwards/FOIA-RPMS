VADPT5 ;ALB/MRL/MJK - PATIENT VARIABLES [REG]; 14 DEC 1988 ;2/5/92  09:12
 ;;5.3;Registration;**54,63,242,1004**;Aug 13, 1993
 ;IHS/OIT/LJF  11/10/2005 PATCH 1004 included for sites where it has been overwritten
 ;
10 ;Registration/Disposition [REG]
 N VARPSV
 S VARPSV("C")=$S('$G(VARP("C")):999999999,1:+VARP("C"))
 S VARPSV("F")=9999999-$S($G(VARP("F"))?7N.E:VARP("F"),1:0)
 S VARPSV("T")=$S($G(VARP("T"))?7N.E:VARP("T"),1:7777777) I '$P(VARPSV("T"),".",2) S $P(VARPSV("T"),".",2)=999999
 S VARPSV("T")=9999999-VARPSV("T")
 S VAX=VARPSV("T"),VAX(1)=0
 I '$D(^DPT(DFN,"DIS")) Q
 F I=0:0 S VAX=$O(^DPT(DFN,"DIS",VAX)) Q:VAX=""!(VAX>VARPSV("F"))!(VAX(1)+1>VARPSV("C"))  S VAX(2)=$G(^DPT(DFN,"DIS",VAX,0)),VAX(1)=VAX(1)+1 D 101:+VAX(2)>0
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
111 S VAX(4)=0 F I1=0:0 S VAX(4)=$O(^DPT(DFN,"DE",VAX,1,VAX(4))) Q:VAX(4)'>0!(VAX(3))  S VAZ(1)=$S($D(^DPT(DFN,"DE",VAX,1,VAX(4),0)):^(0),1:"") I +VAZ(1),$P(VAZ(1),"^",3)']"" S VAX(3)=VAZ(1)
 Q:'VAX(3)  S (VAX("I"),VAX("E"))="",Y=+VAX(3),$P(VAX("I"),"^",2)=Y X ^DD("DD") S $P(VAX("E"),"^",2)=Y
 S $P(VAX("I"),"^",3)=$P(VAX(3),"^",2) I $P(VAX("I"),"^",3)]"" S $P(VAX("E"),"^",3)=$S($P(VAX("I"),"^",3)="O":"OPT",$P(VAX("I"),"^",3)="A":"AC",1:"")
 S $P(VAX("I"),"^",1)=+VAZ,$P(VAX("E"),"^",1)=$S($D(^SC(+VAZ,0)):$P(^(0),"^",1),1:""),VAX(1)=VAX(1)+1,@VAV@(VAX(1),"I")=VAX("I"),@VAV@(VAX(1),"E")=VAX("E") Q
 ;
12 ;Appointments [SDA]
 N VASDSV
 D NOW^%DTC
 S VASDSV("F")=$S($G(VASD("F"))?7N.E:VASD("F"),1:%)
 S VASDSV("T")=$S(+$G(VASD("T")):+VASD("T"),1:9999999) I '$P(VASDSV("T"),".",2) S $P(VASDSV("T"),".",2)=999999
 S VASDSV("W")=$S('$G(VASD("W")):12,1:VASD("W"))
 S VAZ(2)=$S($D(VASD("N")):VASD("N"),1:9999)
 S VAZ="^I^N^NA^C^CA^PC^PCA^NT^",VAZ(1)="^" F I=1:1 S I1=+$E(VASDSV("W"),I) Q:'I1  S VAZ(1)=VAZ(1)_$P(VAZ,"^",I1)_"^"
 S VASDSV("C")=0 I $O(VASD("C",0))>0 S VASDSV("C")=1
 S VAX=VASDSV("F"),VAX(1)=0 F I=0:0 S VAX=$O(^DPT(DFN,"S",VAX)) Q:VAX'>0!(VAX>VASDSV("T"))!(VAX(1)'<VAZ(2))  S VAZ=$S($D(^DPT(DFN,"S",VAX,0)):^(0),1:"") I VAZ,$P(VAZ,"^",2)=""!(VAZ(1)[("^"_$P(VAZ,"^",2)_"^")) D 121,122:VAX(5)
 Q
121 S VAX(5)=1 I VASDSV("W")'[1,$P(VAZ,"^",2)']"" S VAX(5)=0 Q
 I VASDSV("C"),'$D(VASD("C",+VAZ)) S VAX(5)=0 Q
 S (VAX("I"),VAX("E"))="",VAX(2)=1,$P(VAX("I"),"^",1)=+VAX F I1=1,2,16 S VAX(2)=VAX(2)+1,$P(VAX("I"),"^",VAX(2))=$P(VAZ,"^",I1)
 Q
122 S Y=+VAX X ^DD("DD") S $P(VAX("E"),"^",1)=Y,Y=$P(VAZ,"^",1),$P(VAX("E"),"^",2)=$S($D(^SC(+Y,0)):$P(^(0),"^",1),1:""),Y=+$P(VAX("I"),"^",4),$P(VAX("E"),"^",4)=$S($D(^SD(409.1,+Y,0)):$P(^(0),"^",1),1:"")
 S Y=$P(VAX("I"),"^",3) I Y]"" S X=$S($D(^DD(2.98,3,0)):$P(^(0),"^",3),1:""),$P(VAX("E"),"^",3)=$P($P(X,Y_":",2),";",1)
 S VAX(1)=VAX(1)+1,@VAV@(VAX(1),"I")=VAX("I"),@VAV@(VAX(1),"E")=VAX("E") Q
