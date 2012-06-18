BGP1CU5 ; IHS/CMI/LAB - calc CMS measures 26 Sep 2004 11:28 AM 04 May 2010 2:38 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
SCIP(P,BDATE,EDATE,BGPY) ;EP - major surgical procedure during hospital stay?
 NEW X,BD,ED,C,T,Y
 S T=$O(^ATXAX("B","BGP CMS MAJOR SURGERY PROCS",0))
 S C=0
 S BD=9999999-BDATE,ED=9999999-EDATE-1
 F  S ED=$O(^AUPNVPRC("AA",P,ED)) Q:ED'=+ED!(ED>BD)  D
 .S X=0 F  S X=$O(^AUPNVPRC("AA",P,ED,X)) Q:X'=+X  D
 ..S Y=$P($G(^AUPNVPRC(X,0)),U)
 ..Q:$P(^AUPNVPRC(X,0),U,7)'="Y"  ;not principle procedure
 ..Q:'Y
 ..Q:'$$ICD^ATXCHK(Y,T,0)
 ..S C=C+1,BGPY(C)=$$VAL^XBDIQ1(9000010.08,X,.01)_"  "_$$VAL^XBDIQ1(9000010.08,X,.04)
 ..Q
 .Q
 Q
 ;
SCIP1(P,BDATE,EDATE,BGPY) ;EP - major surgical procedure during hospital stay?
 NEW X,BD,ED,C,T,Y,G
 S T=$O(^ATXAX("B","BGP CMS MAJOR SURGERY PROCS",0))
 S C=0
 S BD=9999999-BDATE,ED=9999999-EDATE-1
 F  S ED=$O(^AUPNVPRC("AA",P,ED)) Q:ED'=+ED!(ED>BD)  D
 .S X=0 F  S X=$O(^AUPNVPRC("AA",P,ED,X)) Q:X'=+X  D
 ..S Y=$P($G(^AUPNVPRC(X,0)),U)
 ..Q:$P(^AUPNVPRC(X,0),U,7)'="Y"  ;not principle procedure
 ..Q:'Y
 ..Q:'$$ICD^ATXCHK(Y,T,0)
 ..D  Q:'G
 ...S G=""
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS CABG PROCEDURES",0)),0) S G=1_U_"CABG"
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS OTHER CARDIAC PROCS",0)),0) S G=1_U_"Other Cardiac"
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS HIP ARTHROPLASTY PROCS",0)),0) S G=1_U_"Hip Arthroplasty"
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS KNEE ARTHROPLASTY PROC",0)),0) S G=1_U_"Knee Arthroplasty"
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS COLON SURGERY PROCS",0)),0) S G=1_U_"Colon Surgery"
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS ABD HYSTERECTOMY PROCS",0)),0) S G=1_U_"Hysterectomy"
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS VAG HYSTERECTOMY PROCS",0)),0) S G=1_U_"Hysterectomy"
 ...I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP CMS VASCULAR SURGERY PROCS",0)),0) S G=1_U_"Vascular Surgery"
 ..S C=C+1,BGPY(C)=$P(G,U,2)_"  "_$$VAL^XBDIQ1(9000010.08,X,.01)_"  "_$$VAL^XBDIQ1(9000010.08,X,.04)_U_Y_U_$S($P(^AUPNVPRC(X,0),U,6)]"":$P(^AUPNVPRC(X,0),U,6),1:9999999-ED)_U_$$VAL^XBDIQ1(9000010.08,X,.08)
 ..Q
 .Q
 Q
ADMPRIM(H,T) ;EP
 S T=$O(^ATXAX("B",T,0))
 I 'T Q ""
 NEW I
 S I=$P($G(^AUPNVINP(H,0)),U,12)
 I $$ICD^ATXCHK(I,T,9) Q 1_U_"Admitting DX, preoperative infectious disease: "_$$VAL^XBDIQ1(9000010.02,H,.12)
 S I=$$PRIMPOV^APCLV($P(^AUPNVINP(H,0),U,3),"I")
 I $$ICD^ATXCHK(I,T,9) Q 1_U_"Primary POV, preoperative infectious disease:  "_$$PRIMPOV^APCLV($P(^AUPNVINP(H,0),U,3),"C")_" - "_$$PRIMPOV^APCLV($P(^AUPNVINP(H,0),U,3),"N")
 Q ""
 ;
POSTINF(P,PD,PP) ;EP
 NEW DAYS
 S DAYS=$S($P(PP,U,1)["CABG":3,$P(PP,U,1)["Other Cardiac":3,1:2)
 S X=$$LASTDX^BGP1UTL1(P,"BGP CMS POST-OPERATIVE INF DXS",PD,$$FMADD^XLFDT(PD,DAYS))
 I X Q $P(X,U,2)_" "_$$VAL^XBDIQ1(9000010.07,$P(X,U,5),.04)_"  "_$$DATE^BGP1UTL($P(X,U,3))
 Q ""
