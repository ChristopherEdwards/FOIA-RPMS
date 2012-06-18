BGPD2 ; IHS/CMI/LAB - indicator 2 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I2A ;EP ;EP - indicator 2a
 ;Q:'$D(BGPIND(3))
 Q:'BGPDMPAT  ;not in the simple population for denominator
 S BGPLHGB=$$LASTHGB(DFN,BGPEDATE)
 I BGPLHGB D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),1,1) ;number with hgb a1c done result or not
 S BGPHGBV=$$HGBA1C(DFN,BGPEDATE) ;get last HGB value in past year
 ;set value 2,3,4 piece and set list
 I $P(BGPHGBV,U,2) D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),$P(BGPHGBV,U,2),1) ;set piece 2,3,4
 I $D(BGPLIST(3)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",3,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=$P(BGPHGBV,U)
 Q
I2B ;EP
 ;Q:'$D(BGPIND(4))
 Q:'BGPDMPAT  ;not in the simple population for denominator
 Q:'$$V2(DFN,$$FMADD^XLFDT(BGPEDATE,-365),BGPEDATE)  ;quit if not 2 visits in past year
 Q:'$$FIRSTDM(DFN,BGPEDATE)
 S BGP2BD=1 D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),5,1) ;set 2B denom
 I BGPLHGB D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),6,1) ;number with hgb a1c done result or not
 ;set value 2,3,4 piece and set list
 I $P(BGPHGBV,U,2) D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),$P(BGPHGBV,U,2)+5,1) ;set piece 2,3,4
 I $D(BGPLIST(4)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",4,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=$P(BGPHGBV,U)
 Q
I2C ;EP
 ;Q:'$D(BGPIND(5))
 Q:'BGPDMPAT  ;not in the simple population for denominator
 Q:'$$V2DM(DFN,$P(^DPT(DFN,0),U,3),BGPEDATE)  ;must have at least 2 visits W/ dm dx
 Q:'$$V1DM(DFN,BGPEDATE)  ;quit if not visit w dm pov and primary care provider
 Q:$$AGE^AUPNPAT(DFN,BGPBDATE)<19  ;older than 18 at beg of tf
 Q:'$$CREAT(DFN,BGPEDATE)
 S BGP2CD=1 D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),10,1) ;set 2C denom
 I BGPLHGB D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),11,1) ;number with hgb a1c done result or not
 ;set value 2,3,4 piece and set list
 I $P(BGPHGBV,U,2) D S(BGPRPT,$S(BGPTIME=1:12,BGPTIME=0:42,BGPTIME=8:82,1:999),$P(BGPHGBV,U,2)+10,1) ;set piece 2,3,4
 I $D(BGPLIST(5)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",5,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=$P(BGPHGBV,U)
 Q
S(R,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(^BGPD(R,N),U,P)=$P($G(^BGPD(R,N)),U,P)+V
 Q
LASTHGB(P,EDATE) ;
 NEW BGPG,E,D,%
 K BGPG
 S D=$$FMADD^XLFDT(EDATE,-365)
 S %=P_"^LAST LAB [DM AUDIT HGB A1C;DURING "_$$FMTE^XLFDT(D)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I '$D(BGPG(1)) Q ""
 Q 1
HGBA1C(P,EDATE) ;EP
 NEW BGPG,X,D,E,%,R
 K BGPG
 S D=$$FMADD^XLFDT(EDATE,-365)
 S %=P_"^LAST LAB [DM AUDIT HGB A1C;DURING "_$$FMTE^XLFDT(D)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I '$D(BGPG(1)) S R="" D BS Q R
 S X=$P(^AUPNVLAB(+$P(BGPG(1),U,4),0),U,4) ;get result
 I $$UP^XLFSTR(X)="COMMENT" D BS Q R
 I X[">" Q X_"^"_3
 I X["<" Q X_"^"_2
 I $E(X)'=+$E(X) D BS Q R
 I +X'>7 Q X_"^"_2
 I +X'<9.5 Q X_"^3"
 ;S X=""
 Q X
BS ;EP
 NEW BGPBS,A,B,C,T
 K BGPBS
 S A=P_"^LAST 3 LAB [DM AUDIT GLUCOSE TESTS TAX;DURING "_$$FMTE^XLFDT(D)_"-"_EDATE,B=$$START1^APCLDF(A,"BGPBS(")
 I '$D(BGPBS(1)) K BGPBS S R="^4" Q
 S (A,C,T)=0 F  S A=$O(BGPBS(A)) Q:A'=+A  S B=$P(^AUPNVLAB(+$P(BGPBS(A),U,4),0),U,4) I B=+B S C=C+1,T=T+B
 I C<3 K BGPBS S R="^4" Q  ;not 3 with numeric value
 S B=T/3,A=$S(B'>150:2,B'<225:3,1:"")
 S R=$J(B,5,1)_"^"_A
 Q
 ;
V1DM(P,EDATE) ;
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW A,B,E,V,X,G,D,T,PP,Y,PC
 S PC=$O(^ATXAX("B","BGP PRIMARY CARE CLINICS",0))
 I 'PC Q ""
 S PP=$O(^ATXAX("B","BGP PRIMARY PROVIDER DISC",0))
 I 'PP Q ""
 S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 S D=$$FMADD^XLFDT(EDATE,-365)
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(D)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>2)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:$P(^AUPNVSIT(V,0),U,6)'=DUZ(2)
 .Q:'$D(^AUPNVPOV("AD",V))
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXCHK(%,T,9) S D=1
 .Q:'D
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S Y=$$PRIMPROV^APCLV(V,"F")
 .Q:'Y
 .Q:'$D(^ATXAX(PP,21,"B",Y))
 .S Y=$$CLINIC^APCLV(V,"I")
 .Q:'Y
 .Q:'$D(^ATXAX(PC,21,"B",Y))
 .S G=G+1
 .Q
 Q $S(G<1:"",1:G)
 ;
V2(P,BDATE,EDATE) ;
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW A,B,E,V,X,G
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>2)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S G=G+1
 .Q
 Q $S(G<2:"",1:G)
 ;
V2DM(P,BDATE,EDATE) ;
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW A,B,E,V,X,G,D,T,Y
 S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>2)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXCHK(%,T,9) S D=1
 .Q:'D
 .S G=G+1
 .Q
 Q $S(G<2:"",1:G)
 ;
FIRSTDM(P,EDATE) ;
 I $G(P)="" Q ""
 NEW X,E,BGPG,Y
 K BGPG
 S Y="BGPG("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG(1)) Q ""
 S X=$$FMDIFF^XLFDT(EDATE,$P(BGPG(1),U))
 Q $S(X>365:1,1:"")
 ;
CREAT(P,EDATE) ;get all creatines all must be <5
 NEW BGPG,X,%,E,R,V
 K BGPG
 S %=P_"^ALL LAB [DM AUDIT CREATININE TAX",E=$$START1^APCLDF(%,"BGPG(")
 I '$D(BGPG(1)) Q 1  ;no creatinines 5 or greater
 S X=0,E=1 F  S X=$O(BGPG(X)) Q:X'=+X  S R=$P(BGPG(X),U,2) I +R'<5 S E=""
 Q E
