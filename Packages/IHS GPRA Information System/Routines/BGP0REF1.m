BGP0REF1 ; IHS/CMI/LAB - measure AHR.A ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
BETA ;EP
 I $G(P)="" Q ""
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW T,X,G,D,Y,N
 S T=$O(^ATXAX("B","BGP HEDIS BETA BLOCKER MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not a Beta Blocker
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q
 ..I Y>EDATE Q  ;documented after edate
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="R"
 ...S G=1_U_"Beta Blocker Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 Q G
 ;
ASA ;EP
 ;did patient have a refusal in time period?
 I $G(P)="" Q ""
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW T,G,X,D,Y,N
 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented more than 1 year before edate
 ..I Y>EDATE Q  ;documented after end date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="R"
 ...S G=1_U_"Aspirin Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 I G Q G
 S T=$O(^ATXAX("B","BGP ANTI-PLATELET DRUGS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented more than 1 year before edate
 ..I Y>EDATE Q  ;documented after end date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="R"
 ...S G=1_U_"Anti-Platelet Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 Q G
ACEI ;EP
 ;did patient have a refusal in time period?
 I $G(P)="" Q ""
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW T,G,X,D,Y,N
 S T=$O(^ATXAX("B","BGP HEDIS ACEI MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented more than 1 year before edate
 ..I Y>EDATE Q  ;documented after end date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="R"
 ...S G=1_U_"ACEI Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 Q G
 ;
ARB ;EP
 ;did patient have a refusal in time period?
 I $G(P)="" Q ""
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW T,G,X,D,Y,N
 S T=$O(^ATXAX("B","BGP HEDIS ARB MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented more than 1 year before edate
 ..I Y>EDATE Q  ;documented after end date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...;Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S G=1_U_"ARB Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 Q G
 ;
STATIN ;EP
 ;did patient have a refusal in time period?
 I $G(P)="" Q ""
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW T,G,X,D,Y,N
 S T=$O(^ATXAX("B","BGP HEDIS STATIN MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented more than 1 year before edate
 ..I Y>EDATE Q  ;documented after end date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="R"
 ...S G=1_U_"Statin Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 Q G
