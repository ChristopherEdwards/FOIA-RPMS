BDMSMU ; IHS/CMI/LAB - utilities for hmr ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4**;JUN 14, 2007
 ;
D1(D) ;EP - DATE WITH 4 YR
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
DATEAGE(P,Y) ;EP
 I '$G(P) Q ""
 NEW D
 S D=$$DOB^AUPNPAT(P),D=($E(D,1,3)+Y)_$E(D,4,7)
 Q D
WRITE ;EP - write out reminder
 I $G(BDMSGHR) D  Q
 .NEW A,B
 .S B=""
 .S BDMSGHR(1)=$S($P(^BDMSURV(BDMSITI,0),U,4)]"":$P(^BDMSURV(BDMSITI,0),U,4),1:$P(^BDMSURV(BDMSITI,0),U))
 .S BDMSGHR(2)=$G(BDMLAST)
 .S BDMSGHR(3)=$$DATE($G(BDMLAST))
 .S A=0 F  S A=$O(BDMSTEX(A)) Q:A'=+A  S B=B_" "_BDMSTEX(A)
 .S BDMSGHR(4)=B
 .S BDMSGHR(5)=$G(BDMNEXT)
 .S BDMSGHR(6)=$P($G(BDMICAR),U,4)
 .S BDMSGHR(7)=$P($G(BDMICAR),U,5)
 .S BDMSGHR(8)=$P($G(BDMICAR),U,6)
 I 'BDMSANY D FIRST Q:$D(BDMSQIT)  S BDMSANY=1,BDMSNPG=0
 X BDMSCKP Q:$D(BDMSQIT)
 I BDMSNPG W ?26,"LAST",?38,"NEXT",! S BDMSCT=0,BDMSNPG=0
 W !,$S($P(^BDMSURV(BDMSITI,0),U,4)]"":$P(^BDMSURV(BDMSITI,0),U,4),1:$P(^BDMSURV(BDMSITI,0),U))
 W ?26,$$DATE(BDMLAST)
 W ?36,BDMSTEX(1) F BDMSL=2:1 Q:'$D(BDMSTEX(BDMSL))  W !,?36,BDMSTEX(BDMSL)
 S BDMSCT=BDMSCT+1
 I '(BDMSCT#2) X BDMSCKP Q:$D(BDMSQIT)  W:'BDMSNPG !
 K BDMSTEX Q
 ;
FIRST ;EP
 X BDMSCKP Q:$D(BDMSQIT)  X:'BDMSNPG BDMSBRK
 W ?26,"LAST",?38,"NEXT",!
 S BDMSCT=0
 Q
 ;
INAC(X) ;EP - active?
 Q $P($G(^BDMSURV(X,0)),"^",3)
 ;
LASTLAB(P,BDMI,BDMT,BDML,BDMLT,F) ;EP P is patient, BDMI is ien of lab test, BDMT is IEN of lab taxonomy, BDML is ien of loinc code,  BDMLT is ien o f loinc taxonmy
 I $G(F)="" S F="D"
 S BDMC=""
 S D=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(BDMC)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BDMC)  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BDMC)  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I $G(BDMI),L=BDMI S BDMC=(9999999-D) Q
 ...I $G(BDMT),$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BDMT,21,"B",$P(^AUPNVLAB(X,0),U))) S BDMC=(9999999-D) Q
 ...;Q  ;IHS/CMI/LAB - don't check loinc codes
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,$G(BDMLT),$G(BDML))
 ...S BDMC=(9999999-D)
 ...Q
 Q BDMC
LOINC(A,LT,LI) ;
 I '$G(LT),'$G(LI) Q ""
 I A,LI,A=LI Q 1
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",LT,$D(^ATXAX(LT,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(LT,21,"B",%)) Q 1
 Q ""
INP ;EP - called from input transform
 I $G(X)="" K X Q
 ;I X="ONCE" Q
 I '(+X) D EN^DDIOL("Must begin with a numeric value.") K X Q
 I "MDY"'[$E(X,$L(X)) D EN^DDIOL("Must contain a D for Days, M for Months or Y for Years.") K X Q
 Q
LASTITEM(P,V,T,F) ;EP - return last item V
 I $G(F)="" S F="D"
 NEW BDMY,%,E,Y K BDMY S %=P_"^LAST "_T_" "_V,E=$$START1^APCLDF(%,"BDMY(")
 Q $S(F="D":$P($G(BDMY(1)),"^"),F="B":$P($G(BDMY(1)),"^")_"^"_$P($G(BDMY(1)),"^",2),1:$P($G(BDMY(1)),"^",2))
 ;
PLTAX(P,A,S) ;EP - is DM on problem list 1 or 0
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 S S=$G(S)
 N T S T=$O(^ATXAX("B",A,0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) D
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .I S]"",$P(^AUPNPROB(X,0),U,12) Q
 .S I=1
 Q I
PLCODE(P,A,F) ;EP
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 I $G(F)="" S F=1
 N T
 S T=+$$CODEN^ICDCODE(A,80)
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I Y=T S I=X
 I F=1 Q I
 I F=2 Q X
 Q ""
REF(P,F,I,D,T) ;EP - dm item refused?
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(D)="" S D=""
 I $G(T)="" S T="E"
 NEW X,N S X=$O(^AUPNPREF("AA",P,F,I,0))
 I 'X Q ""  ;none of this item was refused
 S N=$O(^AUPNPREF("AA",P,F,I,X,0))
 NEW Y S Y=9999999-X
 I D]"",Y>D Q $S(T="I":Y,1:$$TYPEREF(N)_$E($$VAL^XBDIQ1(F,I,$$FFD(F)),1,(44-$L($$TYPEREF(N))))_"^on "_$$FMTE^XLFDT(Y))_"^"_Y
 I D]"",Y<D Q ""  ;REFUSED BEFORE DATE OF THE LAST
 I T="I" Q Y  ;quit on internal form of date
 Q $$TYPEREF(N)_$E($$VAL^XBDIQ1(F,I,$$FFD(F)),1,(44-$L($$TYPEREF(N))))_"^on "_$$FMTE^XLFDT(Y)_"^"_Y
TYPEREF(N) ;EP
 NEW % S %=$P(^AUPNPREF(N,0),U,7)
 I %="R"!(%="") Q "Patient Refused "
 I %="N" Q "Not Medically Indicated "
 I %="F" Q "No Response to F/U "
 I %="U" Q "Unable to Screen "
 Q $$VAL^XBDIQ1(9000022,N,.07)
LASTHF(P,C,F) ;EP - get last factor in category C for patient P
 I '$G(P) Q ""
 I $G(C)="" Q ""
 I $G(F)="" S F=""
 S C=$O(^AUTTHF("B",C,0))
 I '$G(C) Q ""
 NEW H,D,O S H=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNVHF("AA",P,H))
 .  S D=$O(^AUPNVHF("AA",P,H,""))
 .  Q:'D
 .  S O(D)=$O(^AUPNVHF("AA",P,H,D,""))
 .  Q
 S D=$O(O(0))
 I D="" Q D
 I F="N" Q $$VAL^XBDIQ1(9000010.23,O(D),.01)
 I F="S" Q $P($G(^AUPNVHF(O(D),0)),U,6)
 I F="B" Q $$VAL^XBDIQ1(9000010.23,O(D),.01)_"  "_$$DATE^BDMS9B1((9999999-D))
 I F="X" Q $$VAL^XBDIQ1(9000010.23,O(D),.01)_"  "_$$DATE^BDMS9B1((9999999-D))_U_(9999999-D)
 Q 9999999-D
 ;
FRSTITEM(P,V,T,F) ;EP - return last item V
 I $G(F)="" S F="D"
 NEW BDMY,%,E,Y K BDMY S %=P_"^FIRST "_T_" "_V,E=$$START1^APCLDF(%,"BDMY(")
 Q $S(F="D":$P($G(BDMY(1)),"^"),1:$P($G(BDMY(1)),"^",2))
 ;
FFD(%) ;EP
 I '$G(%) Q .01
 NEW X,Y
 ;S X=$P(^DIC(%,0),U,1)
 S X=0,Y="" F  S X=$O(^AUTTREFT(X)) Q:X'=+X  I $P(^AUTTREFT(X,0),U,2)=% S Y=X
 I 'Y Q .01
 Q $S($P($G(^AUTTREFT(Y,0)),U,3)]"":$P(^AUTTREFT(Y,0),U,3),1:.01)
REFUSAL(P,F,I,B,E) ;EP
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW G,X,Y,%DT S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 Q G
 ;
CPTREFT(P,BDATE,EDATE,T) ;EP - return ien of CPT entry
 I '$G(P) Q ""
 I '$G(T) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,81,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..Q:'$$ICD^ATXCHK(I,T,1)
 ..S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 .Q
 Q G
