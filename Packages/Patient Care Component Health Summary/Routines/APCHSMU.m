APCHSMU ; IHS/CMI/LAB - utilities for hmr ;
 ;;2.0;IHS PCC SUITE;**2,5,7,11,16**;MAY 14, 2009;Build 9
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
 I $G(APCHSGHR) D  Q
 .NEW A,B
 .S B=""
 .S APCHSGHR(1)=$S($P(^APCHSURV(APCHSITI,0),U,4)]"":$P(^APCHSURV(APCHSITI,0),U,4),1:$P(^APCHSURV(APCHSITI,0),U))
 .S APCHSGHR(2)=$G(APCHLAST)
 .S APCHSGHR(3)=$$DATE($G(APCHLAST))
 .S A=0 F  S A=$O(APCHSTEX(A)) Q:A'=+A  S B=B_" "_APCHSTEX(A)
 .S APCHSGHR(4)=B
 .S APCHSGHR(5)=$G(APCHNEXT)
 .S APCHSGHR(6)=$P($G(APCHICAR),U,4)
 .S APCHSGHR(7)=$P($G(APCHICAR),U,5)
 .S APCHSGHR(8)=$P($G(APCHICAR),U,6)
 I 'APCHSANY D FIRST Q:$D(APCHSQIT)  S APCHSANY=1,APCHSNPG=0
 X APCHSCKP Q:$D(APCHSQIT)
 I APCHSNPG W ?26,"LAST",?38,"NEXT",! S APCHSCT=0,APCHSNPG=0
 W !,$S($P(^APCHSURV(APCHSITI,0),U,4)]"":$P(^APCHSURV(APCHSITI,0),U,4),1:$P(^APCHSURV(APCHSITI,0),U))
 W ?26,$$DATE(APCHLAST)
 W ?36,APCHSTEX(1) F APCHSL=2:1 Q:'$D(APCHSTEX(APCHSL))  W !,?36,APCHSTEX(APCHSL)
 S APCHSCT=APCHSCT+1
 I '(APCHSCT#2) X APCHSCKP Q:$D(APCHSQIT)  W:'APCHSNPG !
 K APCHSTEX Q
 ;
FIRST ;EP
 X APCHSCKP Q:$D(APCHSQIT)  X:'APCHSNPG APCHSBRK
 W ?26,"LAST",?38,"NEXT",!
 S APCHSCT=0
 Q
 ;
INAC(X) ;EP - active?
 Q $P($G(^APCHSURV(X,0)),"^",3)
 ;
LASTLAB(P,APCHI,APCHT,APCHL,APCHLT,F) ;EP P is patient, APCHI is ien of lab test, APCHT is IEN of lab taxonomy, APCHL is ien of loinc code,  APCHLT is ien of loinc taxonmy
 I $G(F)="" S F="D"
 S APCHC=""
 S D=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(APCHC)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(APCHC)  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(APCHC)  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I $G(APCHI),L=APCHI S APCHC=(9999999-D) Q
 ...I $G(APCHT),$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(APCHT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHC=(9999999-D) Q
 ...;Q  ;IHS/CMI/LAB - don't check loinc codes
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,$G(APCHLT),$G(APCHL))
 ...S APCHC=(9999999-D)
 ...Q
 Q APCHC
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
SITECRIT(M) ;EP - does the site have override age/sex ranges
 ;1= YES, 0=NO
 I '$G(M) Q 0
 I '$D(^APCHSURV(M,11)) Q 0  ;no
 NEW G,J,K
 S G=0,J=0 F  S J=$O(^APCHSURV(M,11,J)) Q:J'=+J!(G)  D
 .I '$O(^APCHSURV(M,11,J,11,0)) S G="" Q
 .S K=0 F  S K=$O(^APCHSURV(M,11,J,11,K)) Q:K'=+K!(G)  D
 ..I $P(^APCHSURV(M,11,J,11,K,0),U)]"",$P(^(0),U,3)]"" S G=1
 ..Q
 .Q
 Q G
AGESEX(M,P,F) ;EP - is this patient correct sex,age for this reminder
 I '$G(F) S F=0
 I '$G(P) Q 0
 I '$G(M) Q 0
 NEW S,A,G,MIN,MAX,J,K
 S S=$P(^DPT(P,0),U,2),A=$$FMDIFF^XLFDT(DT,$P(^DPT(P,0),U,3))
 S G=""
 S J=0 F  S J=$O(^APCHSURV(M,11,J)) Q:J'=+J!(G]"")  D
 .Q:$P(^APCHSURV(M,11,J,0),"^")'=S&($P(^APCHSURV(M,11,J,0),"^")'="B")
 .I '$O(^APCHSURV(M,11,J,11,0)) S G="" Q  ;no age ranges specified!  Use default criteria
 .S K=0 F  S K=$O(^APCHSURV(M,11,J,11,K)) Q:K'=+K!(G]"")  D
 ..S MIN=$P(^APCHSURV(M,11,J,11,K,0),U),MIN=$$DAYS(MIN)
 ..Q:A<MIN  ;patient is less than minimum days old
 ..S MAX=$P(^APCHSURV(M,11,J,11,K,0),U,2)
 ..I MAX="" S G=$$DAYS($P(^APCHSURV(M,11,J,11,K,0),"^",3)) Q  ;if no max then it's a hit
 ..S MAX=$$DAYS(MAX)
 ..Q:A>MAX  ;patient is over the max age
 ..I F=1 S G=1
 ..S G=$$DAYS($P(^APCHSURV(M,11,J,11,K,0),"^",3))
 ..Q
 .Q
 Q G
 ;
MINAGE(R,P,F) ;EP - is this patient correct sex,age for this reminder
 I '$G(F) S F=0
 I '$G(P) Q 0
 I '$G(R) Q 0
 NEW S,A,G,MIN,MAX,J,K,M
 S M=99999999
 S S=$P(^DPT(P,0),U,2),A=$$FMDIFF^XLFDT(DT,$P(^DPT(P,0),U,3))
 S G=""
 S J=0 F  S J=$O(^APCHSURV(R,11,J)) Q:J'=+J  D
 .Q:$P(^APCHSURV(R,11,J,0),"^")'=S&($P(^APCHSURV(R,11,J,0),"^")'="B")
 .I '$O(^APCHSURV(R,11,J,11,0)) S G="" Q  ;no age ranges specified!  Use default criteria
 .S K=0 F  S K=$O(^APCHSURV(R,11,J,11,K)) Q:K'=+K  D
 ..S MIN=$P(^APCHSURV(R,11,J,11,K,0),U),MIN=$$DAYS(MIN)
 ..Q:A<MIN
 ..S MAX=$P(^APCHSURV(R,11,J,11,K,0),U,2)
 ..I MAX="" S G=$$DAYS($P(^APCHSURV(R,11,J,11,K,0),"^",3)) Q  ;if no max then it's a hit
 ..S MAX=$$DAYS(MAX)
 ..Q:A>MAX  ;patient is over the max age
 ..I MIN<M S M=MIN
 ..Q
 .Q
 I M="" Q M
 I M=9999999 Q ""
 Q (M\365.25)
LASTITEM(P,V,T,F) ;EP - return last item V
 I $G(F)="" S F="D"
 NEW APCHY,%,E,Y K APCHY S %=P_"^LAST "_T_" "_V,E=$$START1^APCLDF(%,"APCHY(")
 Q $S(F="D":$P($G(APCHY(1)),"^"),F="B":$P($G(APCHY(1)),"^")_"^"_$P($G(APCHY(1)),"^",2),1:$P($G(APCHY(1)),"^",2))
 ;
OVR(P,I) ;EP - return date^prov^comments
 I $G(P)="" Q ""
 I $G(I)="" Q ""
 I '$D(^AUPNHMRO("AA",I,P)) Q ""
 NEW % S %=$O(^AUPNHMRO("AA",I,P,0)),%=$O(^AUPNHMRO("AA",I,P,%,0))
 I '$D(^AUPNHMRO(%,0)) Q ""
 Q $P(^AUPNHMRO(%,0),U,3)_"^"_$$VAL^XBDIQ1(9000025,%,.04)_"^"_$P(^AUPNHMRO(%,0),U,5)
DAYS(V) ;
 I V["Y" Q +V*365.25
 I V["M" Q +V*30.5
 I V["D" Q +V
 Q ""
IPLSNO(P,T,B) ;EP - any problem list entry with a SNOMED in T
 Q $$IPLSNO^APCHSMU1(P,T)
PLTAX(P,A,S,B) ;EP - is A CODE IN THIS TAXONOMY ACTIVE on problem list 1 or 0
 ;IF B=1 THEN COUNT INACTIVE
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 S S=$G(S)
 S B=$G(B)
 N T S T=$O(^ATXAX("B",A,0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) D
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXAPI(Y,T,9)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .I 'B Q:$P(^AUPNPROB(X,0),U,12)="I"  ;CMI/LAB - added per Susan 5/3/16
 .I S]"",$P(^AUPNPROB(X,0),U,12)'=S Q
 .S I=1
 Q I
PLCODE(P,A,F) ;EP
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 I $G(F)="" S F=1
 N T
 S T=+$$CODEABA^ICDEX(A,80)
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I Y=T S I=X
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
 I 'X Q ""
 S N=$O(^AUPNPREF("AA",P,F,I,X,0))
 NEW Y S Y=9999999-X
 I D]"",Y>D Q $S(T="I":Y,1:$$TYPEREF(N)_$E($$VAL^XBDIQ1(F,I,$$FFD(F)),1,(44-$L($$TYPEREF(N))))_"^on "_$$FMTE^XLFDT(Y))_"^"_Y
 I D]"",Y<D Q ""  ;REFUSED BEFORE DATE OF THE LAST
 I T="I" Q Y  ;quit on internal form of date
 Q $$TYPEREF(N)_$E($$VAL^XBDIQ1(F,I,$$FFD(F)),1,(44-$L($$TYPEREF(N))))_"^on "_$$FMTE^XLFDT(Y)_"^"_Y
TYPEREF(N) ;EP
 NEW % S %=$P(^AUPNPREF(N,0),U,7)
 I %="R"!(%="") Q "Patient Declined "
 I %="N" Q "Not Medically Indicated "
 I %="F" Q "No Response to F/U "
 I %="U" Q "Unable to Screen "
 Q $$VAL^XBDIQ1(9000022,N,.07)
LASTPAP(P) ;EP - return last pap date
 I $$SEX^AUPNPAT(P)'="F" Q ""
 NEW APCHY,%,LPAP,T S LPAP="",%=P_"^LAST LAB PAP SMEAR",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) S LPAP=$P(APCHY(1),U)
 K APCHY S %=P_"^LAST LAB [BGP PAP SMEAR TAX",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 I $$VERSION^XPDUTL("BW")>2 D
 .S X=$P($$WHAPI^BWVPAT1(P,$O(^BWVPDT("B","PAP SMEAR",0))),U)
 .I X D
 ..Q:LPAP>X
 ..S LPAP=X
 I $$VERSION^XPDUTL("BW")<3 D
 .S X="" S T="PAP SMEAR",T=$O(^BWPN("B",T,0))
 .I T S X=$$WH^APCHSMU2(P,$$DOB^AUPNPAT(P),DT,T,3)
 .I X]"" D
 ..Q:LPAP>X
 ..S LPAP=X
 K APCHY S %=P_"^LAST DX V76.2",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .S V=$P(APCHY(1),U,5) S V=$$PRIMPROV^APCLV(V,"F") I V,$P($G(^DIC(7,V,9999999)),U,3)'="Y" Q
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 K APCHY S %=P_"^LAST DX V72.32",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .S V=$P(APCHY(1),U,5) S V=$$PRIMPROV^APCLV(V,"F") I V,$P($G(^DIC(7,V,9999999)),U,3)'="Y" Q
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 K APCHY S %=P_"^LAST DX V76.47",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .S V=$P(APCHY(1),U,5) S V=$$PRIMPROV^APCLV(V,"F") I V,$P($G(^DIC(7,V,9999999)),U,3)'="Y" Q
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 F APCHC="795.01","795.02","795.03","795.05","795.06","795.08","795.09" D
 .K APCHY S %=P_"^LAST DX "_APCHC,E=$$START1^APCLDF(%,"APCHY(")
 .I $D(APCHY(1)) D
 ..S V=$P(APCHY(1),U,5) S V=$$PRIMPROV^APCLV(V,"F") I V,$P($G(^DIC(7,V,9999999)),U,3)'="Y" Q
 ..Q:LPAP>$P(APCHY(1),U)
 ..S LPAP=$P(APCHY(1),U)
 K APCHY S %=P_"^LAST PROCEDURE 91.46",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 S T=$O(^ATXAX("B","BGP CPT PAP",0))
 S X=$$CPT^APCHSMU2(P,$P(^DPT(P,0),U,3),DT,T,3)
 I X D
 .Q:LPAP>X
 .S LPAP=X
 Q $G(LPAP)
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
 I F="B" Q $$VAL^XBDIQ1(9000010.23,O(D),.01)_"  "_$$FMTE^XLFDT((9999999-D))
 Q 9999999-D
 ;
FRSTITEM(P,V,T,F) ;EP - return last item V
 I $G(F)="" S F="D"
 NEW APCHY,%,E,Y K APCHY S %=P_"^FIRST "_T_" "_V,E=$$START1^APCLDF(%,"APCHY(")
 Q $S(F="D":$P($G(APCHY(1)),"^"),1:$P($G(APCHY(1)),"^",2))
 ;
FFD(%) ;EP
 I '$G(%) Q .01
 NEW X,Y
 ;S X=$P(^DIC(%,0),U,1)
 S X=0,Y="" F  S X=$O(^AUTTREFT(X)) Q:X'=+X  I $P(^AUTTREFT(X,0),U,2)=% S Y=X
 I 'Y Q .01
 Q $S($P($G(^AUTTREFT(Y,0)),U,3)]"":$P(^AUTTREFT(Y,0),U,3),1:.01)
 ;
GVHMR(P,I) ;PEP - can be called by any application
 ;Input:  P - Patient DFN 
 ;        I - ien of health maintenance reminder from HEALTH SUMMARY MAINT ITEM file
 ;Output:  Name of reminder^date of last (internal)^date of last (external)^NEXT column value of the HMR as displayed on the health summary^internal of next^visit ien (if available)^file found in^ien of file found in
 ;
 I '$G(P) Q ""  ;not a valid patient
 I '$D(^AUPNPAT(P)) Q ""
 I '$D(^DPT(P)) Q ""
 I '$G(I) Q ""  ;not a valid HMR ien
 I '$D(^APCHSURV(I)) Q ""  ;not a valid HMR ien
 NEW APCHSGHR,D,R,APCHSDOB,APCHSEX,APCHSANY,APCHSITM,APCHSTEX,APCHSURX,APCHICAR
 NEW APCHSTEX,APCHOVR,APCHLAST,APCHNEXT,APCHSBWR,X,C,%,T,Y,APCHNUMD,S,R,APCHTAXN,APCHSINT,APCHT,APCHREF,APCHSCRI,APCHTEST,APCHLSIG,APCHLCOL,APCHLBE,APCHPBEG,N,APCHPNEU,APCHMMR,APCHY,APCHX
 K APCHSGHR
 S APCHSGHR=1,R=""
 I $P(^APCHSURV(I,0),U,3)="D" Q ""  ;deleted HMR
 I '$P(^APCHSURV(I,0),U,6) Q ""  ;not officially maintained by IHS
 I $P(^APCHSURV(I,0),U,7)'="R"  ;not a reminder
 S D=$P(^APCHSURV(I,0),U,2)
 I D="" Q ""  ;no program id
 S APCHSPAT=P
 S APCHSITI=I
 S APCHSDOB=$P(^DPT(APCHSPAT,0),U,3)
 S X1=DT,X2=APCHSDOB D ^%DTC S APCHSAGE=$$AGE^AUPNPAT(APCHSPAT)
 S APCHSEX=$P(^DPT(APCHSPAT,0),U,2)
 ;
 S (APCHSANY,APCHSITM)=0
 K APCHSTEX
 S APCHSURX="K APCHSTEX,APCHOVR,APCHICAR,APCHLAST,APCHNEXT,APCHSBWR,X,C,%,T,Y,APCHNUMD,S,R,APCHTAXN,APCHSINT,APCHT,APCHREF,APCHSCRI,APCHTEST,APCHLSIG,APCHLCOL,APCHLBE,APCHPBEG,N,APCHPNEU,APCHMMR,APCHY,APCHX,APCHLSIC,APCHLCOI,APCHLBEI"
 D @($P(D,";")_U_$P(D,";",2))
 ;W !!,APCHSGHR
 I $O(APCHSGHR(0))="" Q ""
 F D=1:1:8 I $D(APCHSGHR(D)) S $P(R,U,D)=$$TRIM^APCHS11C($G(APCHSGHR(D)))
 Q R
 ;
GVTP(P,I,C,APCHRVAL) ;PEP - can be called by any application
 ;Input:  P - Patient DFN 
 ;        I - ien of health maintenance reminder from HEALTH SUMMARY MAINT ITEM file (MUST BE A TYPE OF BEST PRACTICE PROMPT - .07 FIELD VALUE = T)
 ;        C - width of output text, default is 80
 ;Output:  ARRAY NAMED IN APCHRVAL Format:
 ;         APCHRVAL(0)="1^NAME OF BEST PRACTICE PROMPT (.01 value of health summary maint item file)
 ;         APCHRVAL(1-n) = array of Best Practice Prompt text formatted to C width
 ;         APCHRVAL(0)="0^message"  if no Best Practice Prompt value
 ;
 K APCHRVAL
 I '$G(P) S APCHRVAL(0)="0^No Patient identified" Q  ;not a valid patient
 I '$D(^AUPNPAT(P)) S APCHRVAL(0)="0^No Patient identified" Q
 I '$D(^DPT(P)) S APCHRVAL(0)="0^No Patient identified" Q
 I '$G(I) S APCHRVAL(0)="0^No Best Practice Prompt identified" Q  ;not a valid HMR ien
 I '$D(^APCHSURV(I)) S APCHRVAL(0)="0^Not a Best Practice Prompt" Q  ;not a valid HMR ien
 I $P(^APCHSURV(I,0),U,7)'="T" S APCHRVAL(0)="0^Not a Best Practice Prompt" Q
 I $P(^APCHSURV(I,0),U,3)="D" S APCHRVAL(0)="0^Not a valid Best Practice Prompt" Q  ;deleted HMR
 I '$P(^APCHSURV(I,0),U,6) S APCHRVAL(0)="0^Not a valid Best Practice Prompt" Q   ;not officially maintained by IHS
 S D=$P(^APCHSURV(I,0),U,2)
 I D="" Q ""  ;no program id
 NEW APCHSGHR,D,R,APCHSDOB,APCHSEX,APCHSANY,APCHSITM,APCHSTEX,APCHSURX,APCHICAR,APCHCOLW
 NEW APCHSTEX,APCHOVR,APCHLAST,APCHNEXT,APCHSBWR,X,%,T,Y,APCHNUMD,S,R,APCHTAXN,APCHSINT,APCHT,APCHREF,APCHSCRI,APCHTEST,APCHLSIG,APCHLCOL,APCHLBE,APCHPBEG,N,APCHPNEU,APCHMMR,APCHY,APCHX
 S APCHCOLW=$G(C)
 I C'>5 S APCHCOLW=80
 K APCHSGHR
 S APCHSGHR=1,R=""
 S D=$P(^APCHSURV(I,0),U,2)
 I D="" S APCHRVAL(0)="0^Not a valid Best Practice Prompt" Q
 S APCHSPAT=P
 S APCHSITI=I
 S APCHSDOB=$P(^DPT(APCHSPAT,0),U,3)
 S X1=DT,X2=APCHSDOB D ^%DTC S APCHSAGE=$$AGE^AUPNPAT(APCHSPAT)
 S APCHSEX=$P(^DPT(APCHSPAT,0),U,2)
 ;
 S (APCHSANY,APCHSITM)=0
 K APCHSTEX
 S APCHSURX="K APCHSTEX,APCHOVR,APCHICAR,APCHLAST,APCHNEXT,APCHSBWR,X,C,%,T,Y,APCHNUMD,S,R,APCHTAXN,APCHSINT,APCHT,APCHREF,APCHSCRI,APCHTEST,APCHLSIG,APCHLCOL,APCHLBE,APCHPBEG,N,APCHPNEU,APCHMMR,APCHY,APCHX,APCHLSIC,APCHLCOI,APCHLBEI"
 D @($P(D,";")_U_$P(D,";",2))
 Q
 ;
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
 ..Q:'$$ICD^ATXAPI(I,T,1)
 ..S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 .Q
 Q G
