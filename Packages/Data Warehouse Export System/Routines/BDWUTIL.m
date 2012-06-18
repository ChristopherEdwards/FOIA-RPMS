BDWUTIL ; IHS/CMI/LAB - DW UTILITIES ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
 ;
POVS(RETVAL,BDWV) ;EP
 NEW BDWP,BDWS,BDWC,BDWY
 K RETVAL
 I '$D(^AUPNVPOV("AD",BDWV)) Q
 S BDWP="",BDWY=0
 I $P(^AUPNVSIT(BDWV,0),"^",7)="H" F  S BDWY=$O(^AUPNVPOV("AD",BDWV,BDWY)) Q:BDWY'=+BDWY!(BDWP)  I $P(^AUPNVPOV(BDWY,0),"^",12)="P" S BDWP=BDWY
 I $P(^AUPNVSIT(BDWV,0),"^",7)'="H" S BDWP=$O(^AUPNVPOV("AD",BDWV,0))
 S BDWC=1
 I $P(^AUPNVSIT(BDWV,0),U,7)="H",'BDWP S RETVAL(BDWC)=""
 I BDWP S RETVAL(BDWC)=$$VAL^XBDIQ1(9000010.07,BDWP,.01)_"^"_$P(^AUPNVPOV(BDWP,0),"^",7)_"^"_$$VAL^XBDIQ1(9000010.07,BDWP,.09)_"^"_$P(^AUPNVPOV(BDWP,0),"^",11)
 S BDWS=0 F  S BDWS=$O(^AUPNVPOV("AD",BDWV,BDWS)) Q:BDWS'=+BDWS  D
 .Q:BDWS=BDWP
 .S BDWC=BDWC+1,RETVAL(BDWC)=$$VAL^XBDIQ1(9000010.07,BDWS,.01)_"^"_$P(^AUPNVPOV(BDWS,0),"^",7)_"^"_$$VAL^XBDIQ1(9000010.07,BDWS,.09)_"^"_$P(^AUPNVPOV(BDWS,0),"^",11)
 Q
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
DISPER(V) ;EP - called to get ER disposition
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 NEW Y S Y=$O(^AUPNVER("AD",V,0)) I 'Y Q ""
 Q $$VALI^XBDIQ1(9000010.29,Y,.11)
CPT(RETVAL,V) ;EP cpt and quantity
 K AUPNCPT,RETVAL
 NEW X,C,E S X=$$CPT^AUPNCPT(V)
 I '$D(AUPNCPT) Q
 S (X,C)=0 F  S X=$O(AUPNCPT(X)) Q:X'=+X  S C=C+1,RETVAL(C)=$P(AUPNCPT(X),"^") I $P(AUPNCPT(X),"^",4)=9000010.18 S E=$P(AUPNCPT(X),"^",5),$P(RETVAL(C),"^",2)=$P($G(^AUPNVCPT(E,0)),"^",16)
 Q
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
 Q $P(Y,".")
CHSDD ;
 S Z=$O(^AUPNVCHS("AD",V,0)) I 'Z Q Z
 S Y=$P(^AUPNVCHS(Z,0),"^",7)
 I Y="" Q Y
 Q $P(Y,".")
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
MEAS(RETVAL,BDWV) ;EP - 
 K RETVAL
 I $P($G(^BDWSITE(1,11)),U,1) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 I '$D(^AUPNVMSR("AD",BDWV)) Q
 NEW BDWC,BDWI,BDWM
 S (BDWI,BDWC)=0 F  S BDWI=$O(^AUPNVMSR("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .S BDWM=$$VAL^XBDIQ1(9000010.01,BDWI,.01)
 .I BDWM'="BP",BDWM'="HT",BDWM'="WT" Q
 .S BDWVAL=$P(^AUPNVMSR(BDWI,0),"^",4) I BDWM="HT"!(BDWM="WT") S BDWVAL=BDWVAL+.05,BDWVAL=+($P(BDWVAL,".")_"."_$E($P(BDWVAL,".",2),1))
 .S BDWC=BDWC+1
 .S RETVAL(BDWC)=$P(^AUTTMSR($P(^AUPNVMSR(BDWI,0),"^"),0),"^",3)_"^"_BDWVAL
 .Q
 Q
EXAM(RETVAL,BDWV) ;EP - return nth v exam on this visit
 K RETVAL
 I '$G(BDWV) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 NEW BDWI,BDWC,BDWE
 S (BDWI,BDWC)=0
 F  S BDWI=$O(^AUPNVXAM("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .Q:'$D(^AUPNVXAM(BDWI,0))
 .S BDWE=$P(^AUPNVXAM(BDWI,0),"^")
 .I '$D(^AUTTEXAM(BDWE,0)) Q
 .S BDWE=$P(^AUTTEXAM(BDWE,0),"^",2)
 .S BDWC=BDWC+1,RETVAL(BDWC)=BDWE
 .Q
 Q
 ;
PED(RETVAL,BDWV) ;EP - return nth v patient ed on this visit
 K RETVAL
 I '$G(BDWV) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 NEW BDWI,BDWC,BDWE
 S (BDWI,BDWC)=0
 F  S BDWI=$O(^AUPNVPED("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .Q:'$D(^AUPNVPED(BDWI,0))
 .S BDWE=$P(^AUPNVPED(BDWI,0),"^")
 .I '$D(^AUTTEDT(BDWE,0)) Q
 .S BDWE=$P(^AUTTEDT(BDWE,0),"^",2)
 .S BDWC=BDWC+1,RETVAL(BDWC)=BDWE
 .I $P($G(^BDWSITE(1,11)),U,1) Q
 .S RETVAL(BDWC)=RETVAL(BDWC)_"^"_$P(^AUPNVPED(BDWI,0),"^",6)_"^"_$P(^AUPNVPED(BDWI,0),"^",8)
 .Q
 Q
 ;
DENTCOST(V) ;COST OF THIS VISIT
 I '$G(V) Q ""
 NEW X,Y,C
 S X=0,C=""
 F  S X=$O(^AUPNVDEN("AD",V,X)) Q:X'=+X  S C=C+$P(^AUPNVDEN(X,0),U,7)
 Q $S(C=0:"",1:$P((C+.5),"."))
DENT(RETVAL,BDWV) ;EP
 I '$G(BDWV) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 K RETVAL
 NEW BDWI,BDWC
 S (BDWI,BDWC)=0
 F  S BDWI=$O(^AUPNVDEN("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .Q:'$D(^AUPNVDEN(BDWI,0))
 .S BDWC=BDWC+1
 .S RETVAL(BDWC)=$$VAL^XBDIQ1(9000010.05,BDWI,.01)_"^"_$P(^AUPNVDEN(BDWI,0),"^",4)_"^"_$P(^AUPNVDEN(BDWI,0),"^",7)_"^"_$S($P(^AUPNVSIT(BDWV,0),"^",3)="C":"K",1:"D")
 .S $P(RETVAL(BDWC),"^",5)=$$DENTSSN(BDWV)
 .I $P(^AUPNVDEN(BDWI,0),"^",5)]"" S $P(RETVAL(BDWC),"^",6)=$$VAL^XBDIQ1(9002010.03,$P(^AUPNVDEN(BDWI,0),"^",5),8801)
 .S $P(RETVAL(BDWC),"^",7)=$P(^AUPNVDEN(BDWI,0),"^",6)
 .I BDWC=1 S $P(RETVAL(BDWC,0),"^",8)=$$DENTCOST(BDWV)
 Q
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
DMNUTR(V) ;EP - was dm nutrition educ done on this visit, Y or N
 I '$G(V) Q "N"
 I '$D(^AUPNVSIT(V)) Q "N"
 I '$D(^AUPNVPED("AD",V)) Q "N"
 NEW Y S Y=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 I 'Y Q ""
 NEW X,Z,R
 S R=""
 S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  S Z=$P(^AUPNVPED(X,0),"^") I $D(^ATXAX(Y,21,"B",Z)) S R=1
 Q $S($G(R):"Y",1:"N")
 ;
LABDONE(V,T) ;EP - return Y/N
 I $P($G(^BDWSITE(1,11)),U,1) Q ""
 I '$G(V) Q ""
 I $G(T)="" Q ""
 S T=$O(^ATXLAB("B",T,0)) I 'T Q ""
 NEW %,X,Y S %="N",X=0
 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(%="Y")  S Y=$P(^AUPNVLAB(X,0),"^") I $D(^ATXLAB(T,21,"B",Y)) S %="Y"
 Q %
LABRES(V,T) ;EP - return result of lab test in taxonomy T
 I $P($G(^BDWSITE(1,11)),U,1) Q ""
 I '$G(V) Q ""
 I $G(T)="" Q ""
 S T=$O(^ATXLAB("B",T,0)) I 'T Q ""
 NEW %,X,Y S %="",X=0
 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(%]"")  S Y=$P(^AUPNVLAB(X,0),"^") I $D(^ATXLAB(T,21,"B",Y)) S %=$P(^AUPNVLAB(X,0),"^",4)
 Q %
 ;
LAB(RETVAL,BDWV) ;EP
 I $P($G(^BDWSITE(1,11)),U,1) Q
 K RETVAL
 I '$G(BDWV) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 NEW BDWI,BDWC,BDWL
 S (BDWI,BDWC)=0
 F  S BDWI=$O(^AUPNVLAB("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .Q:'$D(^AUPNVLAB(BDWI,0))
 .S BDWL=$P(^AUPNVLAB(BDWI,0),"^")
 .I '$D(^LAB(60,BDWL,0)) Q
 .S BDWLOINC=$$LOINC($P(^AUPNVLAB(BDWI,0),U))
 .Q:BDWLOINC=""  ;don't want that test
 .S BDWC=BDWC+1
 .;S RETVAL(BDWC)=$$VAL^XBDIQ1(9000010.09,BDWI,1113)_"^"_$P(^LAB(60,BDWL,0),"^")_"^"_$P(^AUPNVLAB(BDWI,0),"^",4)_"^"_$P($G(^AUPNVLAB(BDWI,11)),"^")_"^"_$P($G(^AUPNVLAB(BDWI,11)),"^",4)_"^"_$P($G(^AUPNVLAB(BDWI,11)),"^",5)
 .S RETVAL(BDWC)=BDWLOINC_"^"_$P(^LAB(60,BDWL,0),"^")_"^"_$P(^AUPNVLAB(BDWI,0),"^",4)_"^"_$P($G(^AUPNVLAB(BDWI,11)),"^")_"^"_$P($G(^AUPNVLAB(BDWI,11)),"^",4)_"^"_$P($G(^AUPNVLAB(BDWI,11)),"^",5)
 .Q
 Q
 ;
LOINC(X) ;is this a test we want?
 NEW T
 S T=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "4548-4"
 S T=$O(^ATXLAB("B","BDW PAP SMEAR LAB TESTS",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "19762-4"
 I $P(^LAB(60,X,0),U)="PAP SMEAR" Q "19762-4"
 S T=$O(^ATXLAB("B","DM AUDIT GLUCOSE TESTS TAX",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "2345-7"
 S T=$O(^ATXLAB("B","DM AUDIT HDL TAX",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "2085-9"
 S T=$O(^ATXLAB("B","DM AUDIT LDL CHOLESTEROL TAX",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "2089-1"
 S T=$O(^ATXLAB("B","DM AUDIT TRIGLYCERIDE TAX",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "2571-8"
 S T=$O(^ATXLAB("B","BDW PSA TESTS TAX",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "2857-1"
 S T=$O(^ATXLAB("B","APCH FECAL OCCULT BLOOD",0))
 I T,$D(^ATXLAB(T,21,"B",X)) Q "2335-8"
 Q ""
FACTX(V) ;EP
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S Y=$P(^AUPNVINP(Z,0),"^",9)
 I Y="" Q ""
 I Y'["DIC(4" Q ""
 S Y=+Y
 I '$D(^AUTTLOC(Y,0)) Q ""
 Q $P(^AUTTLOC(Y,0),"^",10)
