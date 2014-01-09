BDMDADU ; IHS/CMI/LAB - gpra utility calls ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**6**;JUN 14, 2007;Build 6
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
 .Q:$$UP^XLFSTR($$VAL^XBDIQ1(9002086.1,V,.05))="ERROR/DISREGARD"
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
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I Y=T S I=1
 Q I
PLTAX(P,A) ;EP - is DX on problem list 1 or 0
 I $G(P)="" Q ""
 I $G(A)="" Q ""
 N T S T=$O(^ATXAX("B",A,0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
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
 ..S G="1"_"^"_(9999999-ED)_"^"_$$VAL^XBDIQ1(9000010.18,I,.01)
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
 .S G="1"_"^"_V_"^"_$$VAL^XBDIQ1(9000010.33,I,.07)
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
LASTITEM(P,BD,ED,BDMT,BDMV) ;PEP - return last item APCLV OF TYPE APCLT DURING BD TO ED IN FORM APCLF
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(BDMT)="" Q ""
 I $G(BDMV)="" Q ""
 NEW BDMR,%,E,Y K R S %=P_"^LAST "_BDMT_" "_BDMV_";DURING "_BD_"-"_ED,E=$$START1^APCLDF(%,"BDMR(")
 I '$D(BDMR(1)) Q ""
 Q 1_U_$P(BDMR(1),U,1)_U_$P(BDMR(1),U,3)_U_$P(BDMR(1),U,2)
GETMEDS(P,BDMMBD,BDMMED,TAXM,TAXN,TAXC,BDMDNAME,BDMZ) ;EP
 S TAXM=$G(TAXM)
 S TAXN=$G(TAXN)
 S TAXC=$G(TAXC)
 K ^TMP($J,"MEDS"),BDMZ
 S BDMDNAME=$G(BDMDNAME)
 NEW BDMC1,BDMINED,BDMINBD,BDMMIEN,BDMD,X,Y,T,T1,D,G
 S BDMC1=0 K BDMZ
 S BDMINED=(9999999-BDMMED)-1,BDMINBD=(9999999-BDMMBD)
 F  S BDMINED=$O(^AUPNVMED("AA",P,BDMINED)) Q:BDMINED=""!(BDMINED>BDMINBD)  D
 .S BDMMIEN=0 F  S BDMMIEN=$O(^AUPNVMED("AA",P,BDMINED,BDMMIEN)) Q:BDMMIEN'=+BDMMIEN  D
 ..Q:'$D(^AUPNVMED(BDMMIEN,0))
 ..S BDMD=$P(^AUPNVMED(BDMMIEN,0),U)
 ..Q:BDMD=""
 ..Q:'$D(^PSDRUG(BDMD,0))
 ..S BDMC1=BDMC1+1
 ..S ^TMP($J,"MEDS","ORDER",(9999999-BDMINED),BDMC1)=(9999999-BDMINED)_U_$P(^PSDRUG(BDMD,0),U)_U_$P(^PSDRUG(BDMD,0),U)_U_BDMMIEN_U_$P(^AUPNVMED(BDMMIEN,0),U,3)
 ;reorder
 S BDMC1=0,X=0
 F  S X=$O(^TMP($J,"MEDS","ORDER",X)) Q:X'=+X  D
 .S Y=0 F  S Y=$O(^TMP($J,"MEDS","ORDER",X,Y)) Q:Y'=+Y  D
 ..S BDMC1=BDMC1+1
 ..S ^TMP($J,"MEDS",BDMC1)=^TMP($J,"MEDS","ORDER",X,Y)
 K ^TMP($J,"MEDS","ORDER")
 S T="" I TAXM]"" S T=$O(^ATXAX("B",TAXM,0)) I T="" W BDMBOMB
 S T1="" I TAXN]"" S T1=$O(^ATXAX("B",TAXN,0)) I T1="" W BDMBOMB
 S T2="" I TAXC]"" S T2=$O(^ATXAX("B",TAXC,0))
 S BDMC1=0,X=0 F  S X=$O(^TMP($J,"MEDS",X)) Q:X'=+X  S Y=+$P(^TMP($J,"MEDS",X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .S C=$P($G(^PSDRUG(D,0)),U,2)
 .I C]"",T2,$D(^ATXAX(T2,21,"B",C)) S G=1
 .S C=$P($G(^PSDRUG(D,2)),U,4)
 .I C]"",T1,$D(^ATXAX(T1,21,"B",C)) S G=1
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1
 .I BDMDNAME]"",$P(^PSDRUG(D,0),U)[BDMDNAME S G=1
 .I TAXM="",TAXN="",TAXC="" S G=1  ;WANTS ALL MEDS
 .I G=1 S BDMC1=BDMC1+1,BDMZ(BDMC1)=^TMP($J,"MEDS",X)
 .Q
 K ^TMP($J,"MEDS")
 K BDMINED,BDMINBD,BDMMBD,BDMMED,BDMD,BDMC1,BDMDNAME
 Q
CPTREFT(P,BDATE,EDATE,T) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,81,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..Q:'$$ICD^ATXCHK(I,T,1)
 ..S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)_"^"_$P(^ICPT(I,0),U)
 .Q
 Q G
