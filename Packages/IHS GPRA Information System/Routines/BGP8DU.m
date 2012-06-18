BGP8DU ; IHS/CMI/LAB - gpra utility calls ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
WH(P,BDATE,EDATE,T,F) ;EP
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through procedures in a date range for this patient, check proc type
 NEW D,X,Y,G,V,O
 S (G,V)=0,I="" F  S V=$O(^BWPCD("C",P,V)) Q:V=""  D
 .Q:'$D(^BWPCD(V,0))
 .I $P(^BWPCD(V,0),U,4)'=T Q
 .S D=$P(^BWPCD(V,0),U,12)
 .Q:D<BDATE
 .Q:D>EDATE
 .S I=$O(G(0)) I I>D Q
 .S G=V,G(D)=""
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S D=$P(^BWPCD(G,0),U,12) Q D
 I F=4 S D=$P(^BWPCD(G,0),U,12) Q $$FMTE^XLFDT(D)
 Q ""
PLCODE(P,A) ;EP
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 N T
 ;S T=$O(^ICD9("AB",A,0))
 S T=+$$CODEN^ICDCODE(A,80)
 I T'>0 Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I Y=T S I=1
 Q I
PLTAX(P,A) ;EP - is DX on problem list 1 or 0
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 N T S T=$O(^ATXAX("B",A,0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 Q I
CPT(P,BDATE,EDATE,T,F,SCEX) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 S SCEX=$G(SCEX)
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..I SCEX]"",SCEX[$P(^AUPNVSIT(V,0),U,7) Q
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 I F=5 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVCPT(G,0),U)),U,2)
 I F=6 S V=$P(^AUPNVCPT(G,0),U,3) I V Q 1_"^"_$P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVCPT(G,0),U)),U,2)_"^"_G
 Q ""
RAD(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V,C
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVRAD("AD",V))
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X!(G)  D
 ...S C=$P(^AUPNVRAD(X,0),U) Q:C=""  S C=$P($G(^RAMIS(71,C,0)),U,9) Q:C=""
 ...I $$ICD^ATXCHK(C,T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 I F=5 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^RAMIS(71,$P(^AUPNVRAD(G,0),U),0),U,9)
 I F=6 S V=$P(^AUPNVRAD(G,0),U,3) I V Q 1_"^"_$P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^RAMIS(71,$P(^AUPNVRAD(G,0),U),0),U)_"^"_G
 Q ""
CPTI(P,BDATE,EDATE,CPTI,SCEX,SCLN,SMOD) ;EP - did patient have this cpt (ien) in date range
 I '$G(P) Q ""
 I $G(CPTI)="" Q ""
 I $G(BDATE)="" Q ""
 I $G(EDATE)="" Q ""
 S SCEX=$G(SCEX)
 S SCLN=$G(SCLN)
 S SMOD=$G(SMOD)
 I '$D(^ICPT(CPTI)) Q ""  ;not a valid cpt ien
 I '$D(^AUPNVCPT("AA",P)) Q ""  ;no cpts for this patient
 NEW D,BD,ED,X,Y,D,G,V,I,M,M1,Z,J,K,Q
 S ED=9999999-EDATE-1,BD=9999999-BDATE,G=""
 F  S ED=$O(^AUPNVCPT("AA",P,CPTI,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S I=0 F  S I=$O(^AUPNVCPT("AA",P,CPTI,ED,I)) Q:I'=+I!(G)  D
 ..S V=$P($G(^AUPNVCPT(I,0)),U,3)
 ..I SCEX]"",SCEX[$P(^AUPNVSIT(V,0),U,7) Q
 ..I SCLN]"",$$CLINIC^APCLV(V,"C")=SCLN Q
 ..S M=$$VAL^XBDIQ1(9000010.18,I,.08)
 ..S M1=$$VAL^XBDIQ1(9000010.18,I,.09)
 ..S Q=0
 ..I SMOD]"" F J=1:1 S K=$P(SMOD,";",J) Q:K=""  I K=M S Q=1
 ..Q:Q
 ..I SMOD]"" F J=1:1 S K=$P(SMOD,";",J) Q:K=""  I K=M1 S Q=1
 ..Q:Q
 ..S G="1"_"^"_(9999999-ED)
 Q G
 ;
TRANI(P,BDATE,EDATE,CPTI) ;EP
 I '$G(P) Q ""
 I $G(TRANI)="" Q ""
 I $G(BDATE)="" Q ""
 I $G(EDATE)="" Q ""
 I '$D(^ICPT(CPTI)) Q ""
 I '$D(^AUPNVTC("AC",P)) Q ""  ;no cpts for this patient
 NEW X,V,C,G
 S G=""
 S X=0 F  S X=$O(^AUPNVTC("AC",P,X)) Q:X'=+X  D
 .S C=$P($G(^AUPNVTC(X,0)),U,7)
 .Q:C'=CPTI
 .S V=$P(^AUPNVTC(X,0),U,3)
 .S V=$P($P($G(^AUPNVSIT(V,0)),U),".")
 .Q:V<BDATE
 .Q:V>EDATE
 .S G="1"_"^"_V
 Q G
TRAN(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT IN A TRAN CODE
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVTC("AD",V))
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXCHK($P(^AUPNVTC(X,0),U,7),T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVTC(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVTC(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 I F=5 S V=$P(^AUPNVTC(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVTC(G,0),U,7)),U,2)
 I F=6 S V=$P(^AUPNVTC(G,0),U,3) I V Q 1_"^"_$P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVTC(G,0),U,7)),U,2)_"^"_G
 Q ""
 ;
LASTITEM(P,BD,ED,BGPT,BGPV) ;PEP - return last item APCLV OF TYPE APCLT DURING BD TO ED IN FORM APCLF
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(BGPT)="" Q ""
 I $G(BGPV)="" Q ""
 NEW BGPR,%,E,Y K R S %=P_"^LAST "_BGPT_" "_BGPV_";DURING "_BD_"-"_ED,E=$$START1^APCLDF(%,"BGPR(")
 I '$D(BGPR(1)) Q ""
 Q 1_U_$P(BGPR(1),U,1)_U_$P(BGPR(1),U,3)_U_$P(BGPR(1),U,2)
 ;
BANNER ;EP
V ; GET VERSION
 S BGP("VERSION")="2.0  January, 2003"
 S BGPTEXT="TEXT",BGPLINE=3 G PRINT
 F BGPJ=1:1 S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) Q:BGPX="QUIT"!(BGPX="")  S BGPLINE=BGPJ
PRINT W:$D(IOF) @IOF
 F BGPJ=1:1:BGPLINE S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) W !?80-$L(BGPX)\2,BGPX K BGPX
 W !?80-(8+$L(BGP("VERSION")))/2,"Version ",BGP("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BGP("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BGP("SITE"))\2,BGP("SITE")
XIT ;
 K BGPJ,BGPX,BGPTEXT,BGPLINE,BGP("SITE"),BGP("VERSION")
 Q
TEXT ;
 ;;*******************************************************
 ;;** Indian Health Service GPRA Data Reporting System  **
 ;;*******************************************************
 ;;QUIT
BECPTS ;;
 ;;74270
 ;;74275
 ;;74280
 ;;
SIGCPTS ;;
 ;;45300
 ;;45303
 ;;45305
 ;;45307
 ;;45308
 ;;45309
 ;;45315
 ;;45317
 ;;45320
 ;;45321
 ;;45327
 ;;45330
 ;;45331
 ;;45332
 ;;45333
 ;;45334
 ;;45336
 ;;45337
 ;;45338
 ;;45339
 ;;45341
 ;;45342
 ;;45345
 ;;
COLOCPTS ;;
 ;;45355
 ;;45360
 ;;45361
 ;;45362
 ;;45363
 ;;45364
 ;;45365
 ;;45366
 ;;45367
 ;;45368
 ;;45369
 ;;45370
 ;;45371
 ;;45372
 ;;45378
 ;;45379
 ;;45380
 ;;45382
 ;;45383
 ;;45384
 ;;45385
 ;;45387
 ;;
