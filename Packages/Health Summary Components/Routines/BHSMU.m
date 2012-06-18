BHSMU ;IHS/CIA/MGH - Health Summary Utilities ;06-May-2010 10:37;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**2,4**;March 17, 2006;Build 13
 ;===================================================================
 ;Taken from APCHSMU
 ; IHS/CMI/LAB - utilities for hmr ;  [ 09/08/04  10:39 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**8,10,11,12**;JUN 24, 1997
 ;Patch 2 changed for Code set versioning
 ;
D1(D) ;EP - DATE WITH 4 YR
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
LASTLAB(P,APCHI,APCHT,APCHL,APCHLT,F) ;EP P is patient, APCHI is ien of lab test, APCHT is IEN of lab taxonomy, APCHL is ien of loinc code,  APCHLT is ien o f loinc taxonmy
 ;now get all loinc/taxonomy tests
 N J,L
 I $G(F)="" S F="D"
 S APCHC=""
 S D=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(APCHC)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(APCHC)  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(APCHC)  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I $G(APCHI),L=APCHI S APCHC=(9999999-D) Q
 ...I $G(APCHT),$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(APCHT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHC=(9999999-D) Q
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,$G(APCHLT),$G(APCHL))
 ...S APCHC=(9999999-D)
 ...Q
 Q APCHC
LOINC(A,LT,LI) ;
 I '$G(LT),'$G(LI) Q ""  ;no ien or taxonomy
 I A,LI,A=LI Q 1
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",LT,$D(^ATXAX(LT,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(LT,21,"B",%)) Q 1
 Q ""
LASTITEM(P,V,T,F) ;EP - return last item V
 I $G(F)="" S F="D"
 NEW BHSY,%,E,Y K BHSY S %=P_"^LAST "_T_" "_V,E=$$START1^APCLDF(%,"BHSY(")
 Q $S(F="D":$P($G(BHSY(1)),"^"),1:$P($G(BHSY(1)),"^",2))
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
PLTAX(P,A,S) ;EP - is DM on problem list 1 or 0
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 S S=$G(S)
 N T S T=$O(^ATXAX("B",A,0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) D
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S I=1
 Q I
PLCODE(P,A,F) ;EP
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 I $G(F)="" S F=1
 N T
 S T=+$$CODEN^ICDCODE(A,80)
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=X
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
 I D]"",Y>D Q $S(T="I":Y,1:$$TYPEREF(N)_$E($$VAL^XBDIQ1(F,I,.01),1,(44-$L($$TYPEREF(N))))_"^on "_$$FMTE^XLFDT(Y))_"^"_Y
 I D]"",Y<D Q ""  ;REFUSED BEFORE DATE OF THE LAST
 I T="I" Q Y  ;quit on internal form of date
 Q $$TYPEREF(N)_$E($$VAL^XBDIQ1(F,I,.01),1,(44-$L($$TYPEREF(N))))_"^on "_$$FMTE^XLFDT(Y)_"^"_Y
TYPEREF(N) ;EP
 NEW % S %=$P(^AUPNPREF(N,0),U,7)
 I %="R"!(%="") Q "Patient Refused "
 I %="N" Q "Not Medically Indicated "
 I %="F" Q "No Response to F/U "
 I %="U" Q "Unable to Screen "
 Q $$VAL^XBDIQ1(9000022,N,.07)
LASTPAP(P) ;EP - return last pap date
 I $$SEX^AUPNPAT(P)'="F" Q ""
 NEW BHSY,%,LPAP,T S LPAP="",%=P_"^LAST LAB PAP SMEAR",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LPAP=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST LAB [BGP PAP SMEAR TAX",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LPAP>$P(BHSY(1),U)
 .S LPAP=$P(BHSY(1),U)
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
 K BHSY S %=P_"^LAST DX V76.2",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .S V=$P(BHSY(1),U,5) S V=$$PRIMPROV^APCLV(V,"F") I V,$P($G(^DIC(7,V,9999999)),U,3)'="Y" Q
 .Q:LPAP>$P(BHSY(1),U)
 .S LPAP=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST DX V72.31",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .S V=$P(BHSY(1),U,5) S V=$$PRIMPROV^APCLV(V,"F") I V,$P($G(^DIC(7,V,9999999)),U,3)'="Y" Q
 .Q:LPAP>$P(BHSY(1),U)
 .S LPAP=$P(BHSY(1),U)
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
 K BHSY S %=P_"^LAST PROCEDURE 91.46",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LPAP>$P(BHSY(1),U)
 .S LPAP=$P(BHSY(1),U)
 S T=$O(^ATXAX("B","BGP CPT PAP",0))
 S X=$$CPT^APCHSMU2(P,$P(^DPT(P,0),U,3),DT,T,3)
 I X D
 .Q:LPAP>X
 .S LPAP=X
 Q $G(LPAP)
LASTFLU(P,C) ;EP - return last flu shot date
 NEW BHSY,%,LFLU,T,E S LFLU="",%=P_"^LAST IMMUNIZATION "_C,E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LFLU=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST DX V04.8",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LFLU>$P(BHSY(1),U)
 .S LFLU=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST DX V06.6",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LFLU>$P(BHSY(1),U)
 .S LFLU=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 99.52",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LFLU>$P(BHSY(1),U)
 .S LFLU=$P(BHSY(1),U)
 K BHSY NEW % F %=1:1 S T=$T(FLUCPTS+%^APCHSMU1) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S BHSY(1)=$O(^AUPNVCPT("AA",P,T,0)) I BHSY(1) S BHSY(1)=9999999-BHSY(1) D
 .Q:LFLU>$P(BHSY(1),U)
 .S LFLU=$P(BHSY(1),U)
 Q $G(LFLU)
LASTBE(P) ;EP
 I '$G(P) Q ""
 NEW BHSY,LBE,%,E,T,X,Y,V S LBE=""
 K BHSY S %=P_"^LAST PROCEDURE 87.64",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LBE=$P(BHSY(1),U)
 K BHSY NEW % F %=1:1 S T=$T(BECPTS+%^APCHSMU1) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S BHSY(1)=$O(^AUPNVCPT("AA",P,T,0)) I BHSY(1) S BHSY(1)=9999999-BHSY(1) D
 .Q:LBE>$P(BHSY(1),U)
 .S LBE=$P(BHSY(1),U)
 S (X,Y,V)=0 F  S X=$O(^AUPNVRAD("AC",P,X)) Q:X'=+X  D
 .S V=$P(^AUPNVRAD(X,0),U,3),V=$P($P($G(^AUPNVSIT(V,0)),U),".")
 .S Y=$P(^AUPNVRAD(X,0),U),Y=$P($G(^RAMIS(71,Y,0)),U,9)
 .I Y=74280,V>LBE S LBE=V Q
 .I Y=74270,V>LBE S LBE=V Q
 .I Y=74275,V>LBE S LBE=V Q
 Q $G(LBE)
LASTCOLO(P) ;EP
 I '$G(P) Q ""
 NEW BHSY,LCOLO,%,E,T S LCOLO=""
 K BHSY S %=P_"^LAST PROCEDURE 45.43",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LCOLO=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 45.22",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LCOLO>$P(BHSY(1),U)
 .S LCOLO=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 45.23",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LCOLO>$P(BHSY(1),U)
 .S LCOLO=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 45.25",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LCOLO>$P(BHSY(1),U)
 .S LCOLO=$P(BHSY(1),U)
 ;K BHSY NEW % F %=1:1 S T=$T(COLOCPTS+%^APCHSMU1) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S BHSY(1)=$O(^AUPNVCPT("AA",P,T,0)) I BHSY(1) S BHSY(1)=9999999-BHSY(1) D
 ;.Q:LCOLO>$P(BHSY(1),U)
 ;.S LCOLO=$P(BHSY(1),U)
 S T=$O(^ATXAX("B","BGP COLO CPTS",0))
 S X=$$CPT^APCHSMU2(P,$P(^DPT(P,0),U,3),DT,T,3)
 I X D
 .Q $G(LCOLO)
 .S LCOLO=X
 Q $G(LCOLO)
LASTSIG(P) ;EP
 I '$G(P) Q ""
 NEW BHSY,LSIG,%,E,T S LSIG=""
 K BHSY S %=P_"^LAST PROCEDURE 45.24",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LSIG=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 48.23",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY) D
 .Q:LSIG>$P(BHSY(1),U)
 .S LSIG=$P(BHSY(1),U)
 K BHSY NEW % F %=1:1 S T=$T(SIGCPTS+%^APCHSMU1) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S BHSY(1)=$O(^AUPNVCPT("AA",P,T,0)) I BHSY(1) S BHSY(1)=9999999-BHSY(1) D
 .Q:LSIG>$P(BHSY(1),U)
 .S LSIG=$P(BHSY(1),U)
 Q $G(LSIG)
LASTVISI(P) ;EP - get last vision exam (exam,measurments)
 I '$G(P) Q ""
 NEW D,%
 S D=$$LASTITEM(P,"19","EXAM")
 S %=$$LASTITEM(P,"07","MEASUREMENT")
 I %]D S D=%
 S %=$$LASTITEM(P,"08","MEASUREMENT")
 I %]D S D=%
 Q D
LASTHEAR(P) ;EP
 I '$G(P) Q ""
 NEW D,%
 S D=$$LASTITEM(P,"17","EXAM")
 S %=$$LASTITEM(P,"23","EXAM")
 I %>D S D=%
 S %=$$LASTITEM(P,"24","EXAM")
 I %>D S D=%
 S %=$$LASTITEM(P,"09","MEASUREMENT")
 I %>D S D=%
 S %=$$LASTITEM(P,10,"MEASUREMENT")
 I %>D S D=%
 Q D
LASTHF(P,C,F) ;EP - get last factor in category C for patient P
 I '$G(P) Q ""
 I $G(C)="" Q ""
 I $G(F)="" S F=""
 S C=$O(^AUTTHF("B",C,0)) ;ien of category passed
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
 NEW BHSY,%,E,Y K BHSY S %=P_"^FIRST "_T_" "_V,E=$$START1^APCLDF(%,"BHSY(")
 Q $S(F="D":$P($G(BHSY(1)),"^"),1:$P($G(BHSY(1)),"^",2))
 ;
