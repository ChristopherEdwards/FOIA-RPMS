APCDADSE ; IHS/CMI/LAB - EDIT ADMISSION AND DISCHARGE SERVICE ON IP ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;called from the APCD IP (ADD) and APCD IP (MOD) input
 ;templates.
 ;
START ;
 K APCDTERR,APCDTACC,APCDTNAC
 Q:'$D(APCDTSC)
 D CHECK
 K Y
 Q
CHECK ;
 I APCDTSC="07",AUPNDAYS]"",AUPNDAYS>1 W !!,$C(7),$C(7),"Admitting or Discharge Service cannot be NEWBORN if Patient is over 1 day old.",! S APCDTERR=1 Q
 I APCDTSC="11",AUPNDAYS]"",AUPNDAYS>5479 W !!,$C(7),$C(7),"Admitting Service PEDIATRICS (11) cannot be used for a Patient who is over",!,"15 years old!",! S APCDTERR=1 Q
 I APCDTSC="05"!(APCDTSC="08"),AUPNSEX'="F" W !!,$C(7),$C(7),"Patient Must be FEMALE if Admitting Service is OBSTETRICS (08) or ",!,"GYNEGOLOGY (05)!",! S APCDTERR=1 Q
 I APCDTSC="08",AUPNDAYS]"",(AUPNDAYS<3652!(AUPNDAYS>20088)) W !!,$C(7),$C(7),"This Patient's age is outside the IHS edit range for Admitting/Discharge",!,"Service 08 (OBSETRICS)!",! D ACCEPT Q
 Q
ACCEPT ;
 I $D(AUPNTALK) S APCDTACC=1 Q
 W !!,"Do you still want to use this Service" S %=2 D YN^DICN I %'=1 S APCDTACC=0 Q
 S APCDTACC=1
 Q
 ;
LOS ;
 I $D(AUPNTALK) S APCDTACC=1 Q
 W !,$C(7),$C(7),"WARNING:  The Length of Stay is greater than 99 days and will need ",!,"the ACCEPT command applied."
 W !,"Should I apply the ACCEPT command now" S %=2 D YN^DICN I %'=1 W !,"Okay",! K Y Q
 S APCDTACC=1
 K Y
 Q
 ;
ICD(V,T) ;EP is any dx a member of taxonomy T
 I '$G(V) Q ""
 I '$G(T) Q ""
 NEW P,H,I
 S (P,H)=0 F  S P=$O(^AUPNVPOV("AD",V,P)) Q:P'=+P!(H)  S I=$P(^AUPNVPOV(P,0),U) I $$ICD^ATXCHK(I,T,9) S H=1
 Q H
