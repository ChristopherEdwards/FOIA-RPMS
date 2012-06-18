BDMS9B7 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT 06 Jan 2005 5:09 PM ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3**;JUN 14, 2007
 ;
 ;
EKG(P) ;EP
 NEW BDMY,%,LEKG S LEKG="",%=P_"^LAST DIAGNOSTIC ECG SUMMARY",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY) S LEKG=$P(BDMY(1),U)_U_$$VAL^XBDIQ1(9000010.21,+$P(BDMY(1),U,4),.04)
 K BDMY S %=P_"^LAST PROCEDURE 89.50",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 89.51",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 89.52",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 89.53",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST DX 794.31",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 ;check CPT 
 S T=$O(^ATXAX("B","DM AUDIT EKG CPTS",0))
 K BDMY I T S BDMY(1)=$$CPT(P,,,T,3) D
 .I BDMY(1)="" K BDMY Q
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY I T S BDMY(1)=$$RAD(P,,,T,3) D
 .I BDMY(1)="" K BDMY Q
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 ;
 ;
 Q $$FMTE^XLFDT(LEKG)_U_$P(LEKG,U,2)
 ;
CPT(P,BDATE,EDATE,T,F) ;
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
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
 Q ""
RAD(P,BDATE,EDATE,T,F) ;return if a v rad entry in date range
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVRAD("AD",V))
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X!(G)  D
 ...Q:'$D(^AUPNVRAD(X,0))
 ...S Y=$P(^AUPNVRAD(X,0),U) Q:'Y  Q:'$D(^RAMIS(71,Y,0))
 ...S Y=$P($G(^RAMIS(71,Y,0)),U,9) Q:'Y
 ...Q:'$$ICD^ATXCHK(Y,T,1)
 ...S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 Q ""
