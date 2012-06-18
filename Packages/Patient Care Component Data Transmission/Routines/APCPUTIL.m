APCPUTIL ; IHS/TUCSON/LAB - DW UTILITIES ; [ 08/18/2003   7:44 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION;**6**;APR 03, 1998
 ;
 ;
DATE(D) ;EP - return YYYYMMDD from internal fm format
 I $G(D)="" Q ""
 Q ($E(D,1,3)+1700)_$E(D,4,7)
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
 ;
CPTRECS(V) ;EP # of cpt records (AD4's)
 K AUPNCPT
 NEW X,C,R S X=$$CPT^AUPNCPT(V)
 I '$D(AUPNCPT) Q 0
 S (X,C)=0 F  S X=$O(AUPNCPT(X)) Q:X'=+X  S C=C+1
 S R=$S(C#25=0:C/25,1:(C\25)+1) ;IHS/CMI/LAB
 Q R
DSCHTYPE(V) ;EP
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I $P(^AUPNVSIT(V,0),"^",7)'="H" Q ""
 NEW %,Y,Z
 I $P(^AUPNVSIT(V,0),"^",3)="C" G CHSDT
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q Z
 S Y=$$VALI^XBDIQ1(9000010.02,Z,.06)
 I 'Y Q ""
 I $P(^DD(9000010.02,.06,0),"^",2)[42.2 Q $P($G(^DIC(42.2,Y,9999999)),"^")
 I $P(^DD(9000010.02,.06,0),"^",2)[405.1 Q $P($G(^DG(405.1,Y,"IHS")),"^")
 Q ""
VENTYP(V) ;EP return vendor type from VCHS
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 NEW C S C=$O(^AUPNVCHS("AD",V,0))
 I 'C Q ""
 I '$D(^AUPNVCHS(C,0)) Q ""
 NEW E,T
 S E=$P(^AUPNVCHS(C,0),"^",14)
 I 'E Q ""
 S T=$$VAL^XBDIQ1(9999999.11,E,1103)
 Q T
CHSDT ;
 S Z=$O(^AUPNVCHS("AD",V,0)) I 'Z Q ""
 S Y=$$VALI^XBDIQ1(9000010.03,Z,.08)
 S Y=$S(Y="":"",Y=1:1,Y=2:3,Y=3:5,Y=4:7,Y=5:2,1:"")
 Q Y
DSCHDATE(V) ;EP
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I $P(^AUPNVSIT(V,0),"^",7)'="H" Q ""
 NEW Y,Z
 S Z=$O(^AUPNVINP("AD",V,0)) I 'Z G CHSDD
 S Y=$P(^AUPNVINP(Z,0),"^")
 I Y="" Q Y
 Q $$DATE($P(Y,"."))
CHSDD ;
 S Z=$O(^AUPNVCHS("AD",V,0)) I 'Z Q Z
 S Y=$P(^AUPNVCHS(Z,0),"^",7)
 I Y="" Q Y
 Q $$DATE($P(Y,"."))
LOS(V) ;EP
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I $P(^AUPNVSIT(V,0),"^",7)'="H" Q ""
 NEW Y,Z,X,X1,X2
 I $P(^AUPNVSIT(V,0),"^",3)="C" G CHSLOS
 S Z=$O(^AUPNVINP("AD",V,0)) I 'Z Q ""
 S X1=$P($P(^AUPNVINP(Z,0),"^"),"."),X2=$P($P(^AUPNVSIT($P(^AUPNVINP(Z,0),"^",3),0),"^"),".") D ^%DTC
 S:X=0 X=1
 Q X
CHSLOS ;
 S Z=$O(^AUPNVCHS("AD",V,0)) I 'Z Q ""
 S X1=$P($P(^AUPNVCHS(Z,0),"^",7),"."),X2=$P($P(^AUPNVSIT($P(^AUPNVCHS(Z,0),"^",3),0),"^"),".") D ^%DTC
 S:X=0 X=1
 Q X
PHNAC(V) ;
 I '$G(V) Q ""
 I '$$PHN(V) Q ""  ;not a phn visit
 I $P(^AUPNVSIT(V,0),"^",7)="N" Q "03"
 I $$CLINIC^APCLV(V,"C")=11 Q "01"
 Q "02"
PHN(V) ;
 ;is one of the providers a CHN?
 I '$G(V) Q ""
 NEW X,%,D,N
 I $$PRIMPROV^APCLV(V,"D")=13!($$PRIMPROV^APCLV(V,"D")=32) Q 1
 S (X,%,N)=0 F  S X=$O(^AUPNVPRV("AD",V,X)) Q:X'=+X  I $P(^AUPNVPRV(X,0),"^",4)'="P" S N=N+1 S D=$$SECPROV^APCLV(V,"D",N) I D=13!(D=32) S %=1
 Q %
LEVEL(V) ;EP
 I '$G(V) Q ""
 I '$$PHN(V) Q ""
 NEW P S P=$O(^AUPNVPHN("AD",V,0))
 I 'P Q ""
 Q $P(^AUPNVPHN(P,0),"^",5)
 ;
MEAS(V,T,F) ;EP - return first weight recorded
 ;F=1 returns value as is, otherwise truncate and round to 2 digits
 ;V is visit ien T is measurement type 
 I '$D(^AUPNVSIT(V)) Q ""
 I $G(T)="" Q ""
 I '$D(^AUPNVMSR("AD",V)) Q ""
 NEW Y S Y=$O(^AUTTMSR("B",T,0))
 I 'Y Q ""
 S F=$G(F)
 NEW X,Z,R S R=""
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  I $P(^AUPNVMSR(X,0),"^")=Y S R=$P(^AUPNVMSR(X,0),"^",4)
 I R="" Q R
 I $G(F)=1 Q R
 S R=R+.05 Q +($P(R,".")_"."_$E($P(R,".",2),1))
EXAM(V,N) ;EP - return nth v exam on this visit
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVXAM("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVXAM(Y,0),"^"),Z=Y
 I 'P Q P
 I '$D(^AUTTEXAM(P)) Q ""
 Q $P(^AUTTEXAM(P,0),"^",2)
 ;
PED(V,N) ;EP - return nth v patient ed on this visit
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVPED("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVPED(Y,0),"^"),Z=Y
 I 'P Q P
 I '$D(^AUTTEDT(P)) Q ""
 Q $P(^AUTTEDT(P,0),"^",2)
 ;
IMM(V,F,N) ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 I '$G(N) Q -1
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVIMM("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVIMM(Y,0),"^"),Z=Y
 I 'P Q P
 I '$D(^AUTTIMM(P)) Q -1
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
I ;
 S %=P Q
E ;
 S %=$P(^AUTTIMM(P,0),"^") Q
S ;
 S %=$P(^AUPNVIMM(Z,0),"^",4) Q
C ;
 ;IHS/CMI/LAB - modified line below for patch 4 1/5/1999
 S %=$P(^AUTTIMM(P,0),"^",$S($$BI:20,1:3)) Q
 ;
H ;
 I '$$BI S %="" Q
 S %=$P(^AUTTIMM(P,0),"^",3)
 Q
BI() ;IHS/CMI/LAB - new subroutine patch 4 1/5/1999
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
 ;
DENTSSN(V) ;EP - if a provider is a 52 get SSN
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 NEW X,Y,S S S="",X=0 F  S X=$O(^AUPNVPRV("AD",V,X)) Q:X'=+X!(S]"")  S Y=$P(^AUPNVPRV(X,0),"^") D
 .S D=$$CLS(Y)
 .I D=52 S S=$$SSN(Y)
 .Q
 Q S
CLS(P) ;return ihs class code for provider P
 I '$G(P) Q ""
 NEW % S %=""
 I $P(^DD(9000010.06,.01,0),"^",2)[200 D  Q %
 .Q:'$D(^VA(200,P))
 .NEW %1 S %1=$P($G(^VA(200,P,"PS")),"^",5)
 .I '%1 Q
 .S %=$P($G(^DIC(7,%1,9999999)),"^")
 .Q
 I '$D(^DIC(6,P,0)) Q ""
 NEW %1 S %1=$P(^DIC(6,P,0),"^",4)
 I '%1 Q ""
 Q $P($G(^DIC(7,%1,9999999)),"^",1)
 ;
SSN(P) ;return provider's ssn
 I '$G(P) Q ""
 I $P(^DD(9000010.06,.01,0),"^",2)[200 Q $P($G(^VA(200,P,1)),"^",9)
 I $P(^DD(9000010.06,.01,0),"^",2)[6 Q $P($G(^DIC(16,P,0)),"^",9)
 ;
NATION(V) ;EP 
 I '$G(V) Q ""
 NEW P S P=$P(^AUPNVSIT(V,0),"^",5)
 I 'P Q ""
 Q $S($$BEN^AUPNPAT(P,"C")="01":"I",$$BEN^AUPNPAT(P,"C")="":"I",1:"O")
DENTCOST(V) ;COST OF THIS VISIT
 I '$G(V) Q ""
 NEW X,Y,C
 S X=0,C=""
 F  S X=$O(^AUPNVDEN("AD",V,X)) Q:X'=+X  S C=C+$P(^AUPNVDEN(X,0),U,7)
 Q $S(C=0:"",1:$P((C+.5),"."))
DMNUTR(V) ;EP - was dm nutrition educ done on this visit, Y or N
 I '$G(V) Q "N"
 I '$D(^AUPNVSIT(V)) Q "N"
 I '$D(^AUPNVPED("AD",V)) Q "N"
 NEW Y S Y=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 I 'Y Q ""
 NEW X,Z,R
 S R=""
 S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  S Z=$P(^AUPNVPED(X,0),U) I $D(^ATXAX(Y,21,"B",Z)) S R=1
 Q $S($G(R):"Y",1:"N")
 ;
ZIP(V) ;EP - zip code of patient
 I '$G(V) Q ""
 NEW P S P=$P(^AUPNVSIT(V,0),U,5)
 Q $P($G(^DPT(P,.11)),U,6)
PAP(V) ;EP - was pap performed Y/N
 I '$G(V) Q ""
 NEW T S T=$O(^ATXLAB("B","APCP PAP SMEAR LAB TESTS",0))
 I 'T Q ""
 NEW X,Y,Z S Y="N",X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(Y="Y")  S Z=$P(^AUPNVLAB(X,0),U) I $D(^ATXLAB(T,21,"B",Z)) S Y="Y"
 Q Y
GLUCOSE(V) ;EP - return glucose test value on this visit
 I '$G(V) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT GLUCOSE TESTS TAX",0))
 I 'T Q ""
 NEW X,Y,Z S Y="",X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(Y]"")  S Z=$P(^AUPNVLAB(X,0),U) I $D(^ATXLAB(T,21,"B",Z)) S Y=$P(^AUPNVLAB(X,0),U,4)
 Q $E(Y,1,15) ;**********
LABDONE(V,T) ;EP - return Y/N
 I '$G(V) Q ""
 I $G(T)="" Q ""
 S T=$O(^ATXLAB("B",T,0)) I 'T Q ""
 NEW %,X,Y S %="N",X=0
 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(%="Y")  S Y=$P(^AUPNVLAB(X,0),U) I $D(^ATXLAB(T,21,"B",Y)) S %="Y"
 Q %
LABRES(V,T) ;EP - return result of lab test in taxonomy T
 I '$G(V) Q ""
 I $G(T)="" Q ""
 S T=$O(^ATXLAB("B",T,0)) I 'T Q ""
 NEW %,X,Y S %="",X=0
 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(%]"")  S Y=$P(^AUPNVLAB(X,0),U) I $D(^ATXLAB(T,21,"B",Y)) S %=$P(^AUPNVLAB(X,0),U,4)
 Q $E(%,1,15) ;**********
HF(V,F) ;EP was this health factor recorded on this visit
 I '$G(V) Q ""
 NEW T S T=$O(^AUTTHF("B",F,0)) I 'T Q ""
 NEW X,Y S X=0,Y="N" F  S X=$O(^AUPNVHF("AD",V,X)) Q:X'=+X!(Y="Y")  I $P(^AUPNVHF(X,0),U)=T S Y="Y"
 Q Y
HFNAME(V,C) ;EP return name of health factor in this category
 I '$G(V) Q ""
 S C=$O(^AUTTHF("B",C,0)) I 'C Q ""
 NEW X,Y,Z S Y="",X=0 F  S X=$O(^AUPNVHF("AD",V,X)) Q:X'=+X!(Y]"")  S Z=$P(^AUPNVHF(X,0),U) I $P(^AUTTHF(Z,0),U,3)=C S Y=$P(^AUTTHF(Z,0),U)
 Q Y
DELM(V) ;
 NEW S
 I '$G(V) Q ""
 S S=$S($P(^AUPNVSIT(V,0),U,7)="C":"K",1:"D")
 I $$CLINIC^APCLV(APCPVIEN,"C")=56 Q S
 I $$CLINIC^APCLV(APCPVIEN,"C")=99 Q S
 I $D(^AUPNVDEN("AD",APCPVIEN)) Q S
 Q ""
UPI(V) ;EP unique Patient ID
 I '$G(V) Q ""
 NEW P S P=$P(^AUPNVSIT(V,0),U,5)
 I 'P Q ""
 I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 ;
 Q $P(^AUTTSITE(1,1),U,3)_$E("0000000000",1,10-$L(P))_P
