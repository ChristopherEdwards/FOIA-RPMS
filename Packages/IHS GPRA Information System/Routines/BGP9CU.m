BGP9CU ; IHS/CMI/LAB - calc CMS measures 26 Sep 2004 11:28 AM 04 May 2008 2:38 PM ;
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
CHESTXRY(P,BDATE,EDATE,BGPY) ;EP
 K BGPY
 I '$G(P) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW C,BD,ED,X,Y,D,G,V,I
 S C=0
 ;go through visits in a date range for this patient, check cpts
 S ED=(9999999-EDATE)-1,BD=9999999-BDATE,G=0
 S T=$O(^ATXAX("B","BGP CMS CHEST XRAY CPT",0))
 I 'T W BGPBOMB
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$CPT^ICPTCOD($P(^AUPNVCPT(X,0),U),(9999999-$P(ED,"."))),U,2)_"  "_$P($$CPT^ICPTCOD($P(^AUPNVCPT(X,0),U),(9999999-$P(ED,"."))),U,3)
 ..;now go through v rads
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X  D
 ...S I=$P(^AUPNVRAD(X,0),U) Q:I=""  S I=$P($G(^RAMIS(71,I,0)),U,9) Q:I=""
 ...I $$ICD^ATXCHK(I,T,1) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,2)_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,3)_" Impression: "_$P($G(^AUPNVRAD(X,11)),U,1)
 ..; now v tran
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S I=$P(^AUPNVTC(X,0),U,7)
 ...Q:I=""
 ...I $$ICD^ATXCHK(I,T,1) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,2)_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,3)
 ..;now check V PROCEDURE
 ..S T=$O(^ATXAX("B","BGP CMS CHEST XRAY PROC",0))
 ..I 'T W BGPBOMB
 ..S X=0 F  S X=$O(^AUPNVPRC("AD",V,X)) Q:X'=+X  D
 ...I $$ICD^ATXCHK($P(^AUPNVPRC(X,0),U),T,0) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$ICDOP^ICDCODE($P(^AUPNVPRC(X,0),U),(9999999-$P(ED,"."))),U,2)_"  "_$$VAL^XBDIQ1(9000010.08,X,.04)
 ..;now check V POV
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 ...S I=$P($G(^AUPNVPOV(X,0)),U)
 ...Q:'I
 ...I $P($$ICDDX^ICDCODE(I),U,2)="V72.5",$$UP^XLFSTR($$VAL^XBDIQ1(9000010.07,X,.04))["CHEST" S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$ICDDX^ICDCODE(I,(9999999-$P(ED,"."))),U,2)_"  "_$$VAL^XBDIQ1(9000010.07,X,.04)
 ...Q
 ..Q
 .Q
 Q
 ;
CTSCAN(P,BDATE,EDATE,BGPY) ;EP
 K BGPY
 I '$G(P) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW C,BD,ED,X,Y,D,G,V,I
 S C=0
 ;go through visits in a date range for this patient, check cpts
 S ED=(9999999-EDATE)-1,BD=9999999-BDATE,G=0
 S T=$O(^ATXAX("B","BGP CMS CT SCAN CPT",0))
 I 'T W BGPBOMB
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$CPT^ICPTCOD($P(^AUPNVCPT(X,0),U),(9999999-$P(ED,"."))),U,2)_"  "_$P($$CPT^ICPTCOD($P(^AUPNVCPT(X,0),U),(9999999-$P(ED,"."))),U,3)
 ..;now go through v rads
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X  D
 ...S I=$P(^AUPNVRAD(X,0),U) Q:I=""  S I=$P($G(^RAMIS(71,I,0)),U,9) Q:I=""
 ...I $$ICD^ATXCHK(I,T,1) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,2)_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,3)_" Impression: "_$P($G(^AUPNVRAD(X,11)),U,1)
 ..; now v tran
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S I=$P(^AUPNVTC(X,0),U,7)
 ...Q:I=""
 ...I $$ICD^ATXCHK(I,T,1) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,2)_"  "_$P($$CPT^ICPTCOD(I,(9999999-$P(ED,"."))),U,3)
 ..;now check V PROCEDURE
 ..S T=$O(^ATXAX("B","BGP CMS CT SCAN PROC",0))
 ..I 'T W BGPBOMB
 ..S X=0 F  S X=$O(^AUPNVPRC("AD",V,X)) Q:X'=+X  D
 ...I $$ICD^ATXCHK($P(^AUPNVPRC(X,0),U),T,0) S C=C+1,BGPY(ED,C)=$$DATE^BGP9UTL(9999999-$P(ED,"."))_"  "_$P($$ICDOP^ICDCODE($P(^AUPNVPRC(X,0),U),(9999999-$P(ED,"."))),U,2)_"  "_$$VAL^XBDIQ1(9000010.08,X,.04)
 .Q
 Q
 ;
ABGPO(P,BD,ED,BGPY) ;EP
 ;get all O2 measurements on or after admission date
 NEW BGPC,X,N,E,Y,T,D,C,BGPLT,L,J
 S BGPC=0
 K BGPG S Y="BGPG(",X=P_"^ALL MEAS O2;DURING "_$$FMTE^XLFDT(BD)_"-"_$$FMTE^XLFDT(ED) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$P(^AUPNVMSR(Y,0),U,4)
 .S BGPC=BGPC+1,BGPY(BGPC)="MEASUREMENT O2:  "_$$DATE^BGP9UTL($P(BGPG(X),U))_"  value: "_N
 .Q
 ;now check for cpts
 S T=$O(^ATXAX("B","BGP CMS ABG CPTS",0))
 S X=0 F  S X=$O(^AUPNVCPT("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S C=$P(^AUPNVCPT(X,0),U)
 .Q:'$$ICD^ATXCHK(C,T,1)
 .S D=$P(^AUPNVCPT(X,0),U,3),D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .Q:D<BD
 .Q:D>ED
 .S BGPC=BGPC+1,BGPY(BGPC)="CPT: "_$P($$CPT^ICPTCOD(C),U,2)_" "_$P($$CPT^ICPTCOD(C,D),U,3)_"  "_$$DATE^BGP9UTL(D)
 .Q
 ;now check v tran
 S T=$O(^ATXAX("B","BGP CMS ABG CPTS",0))
 S X=0 F  S X=$O(^AUPNVTC("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVTC(X,0))
 .S C=$P(^AUPNVTC(X,0),U,7)
 .Q:C=""
 .Q:'$$ICD^ATXCHK(C,T,1)
 .S D=$P(^AUPNVTC(X,0),U,3),D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .Q:D<BD
 .Q:D>ED
 .S BGPC=BGPC+1,BGPY(BGPC)="TRAN CODE CPT: "_$P($$CPT^ICPTCOD(C),U,2)_" "_$P($$CPT^ICPTCOD(C,D),U,3)_"  "_$$DATE^BGP9UTL(D)
 .Q
 ;now check for lab tests
 S T=$O(^ATXAX("B","BGP CMS ABG LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CMS ABG TESTS",0))
 S B=9999999-BD,E=9999999-ED S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPY(BGPC)="LAB:  "_$$VAL^XBDIQ1(9000010.09,X,.01)_"  "_$$DATE^BGP9UTL((9999999-D))_"  value: "_$P(^AUPNVLAB(X,0),U,4) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP9D21(J,T)
 ...S BGPC=BGPC+1,BGPY(BGPC)="LAB:  "_$$VAL^XBDIQ1(9000010.09,X,.01)_"  "_$$DATE^BGP9UTL((9999999-D))_"  value: "_$P(^AUPNVLAB(X,0),U,4)
 ...Q
 Q
ADMDX(H,T) ;EP
 S T=$O(^ATXAX("B",T,0))
 I 'T Q ""
 NEW I
 S I=$P($G(^AUPNVINP(H,0)),U,12)
 I '$$ICD^ATXCHK(I,T,9) Q ""
 Q 1_U_$P($$ICDDX^ICDCODE(I),U,2)
 ;
ERPNEU(P,BDATE,EDATE,T) ;EP - did patient have an er visit from bdate to edate without a DX in taxonomy T?
 S T=$O(^ATXAX("B",T,0))
 I 'T Q ""
 NEW BGPG,A,B,E,G,X,I,BGPC
 K BGPG,BGPY
 S BGPC=0
 S A="BGPG(",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(BGPG(1)) Q "0^Patient had no ER Visit"
 K BGPC S X=0,(G,E,B)="" F  S X=$O(BGPG(X)) Q:X'=+X  S V=$P(BGPG(X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:$$CLINIC^APCLV(V,"C")'=30
 .S B=1,BGPC(V)=""
 I 'B Q "0^Patient had no ER Visit"
 S (V,G,E)="" F  S V=$O(BGPC(V)) Q:V=""!(E)  D
 .S A=0,G="" F  S A=$O(^AUPNVPOV("AD",V,A)) Q:A'=+A  D
 ..S I=$P($G(^AUPNVPOV(A,0)),U) Q:'I
 ..I $$ICD^ATXCHK(I,T,9) S E=1 Q
 .I 'E S G=0_U_"ER Visit: "_$$DATE^BGP9UTL($P($P(^AUPNVSIT(V,0),U),"."))
 I E Q "1^No"
 Q G
 ;
PNEUMODX(V) ;EP
 NEW C,T,X,G,I,C
 S C=$$PRIMPOV^APCLV(V,"I")
 I C="" Q "" ;no primary dx
 S T=$O(^ATXAX("B","BGP CMS PNEUMONIA DXS",0))
 I $$ICD^ATXCHK(C,T,9) Q $P($$ICDDX^ICDCODE(C),U,2)_" (Primary) "_$$PRIMPOV^APCLV(V,"N")  ;primary dx of pneumonia
 ;PRIMARY of resp failure and seconday of pneumonia
 S T=$O(^ATXAX("B","BGP CMS SEPTI/RESP FAIL DXS",0))
 I '$$ICD^ATXCHK(C,T,9) Q ""   ;resp failure not primary pov
 S C=$P($$ICDDX^ICDCODE(C),U,2)_" (Primary) "_$$PRIMPOV^APCLV(V,"N")
 S T=$O(^ATXAX("B","BGP CMS PNEUMONIA DXS",0))
 S (X,G)="" F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G]"")  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S I=$P(^AUPNVPOV(X,0),U)
 .Q:'$$ICD^ATXCHK(I,T,9)
 .S G=$P($$ICDDX^ICDCODE(I),U,2)_" (Secondary) "_$$VAL^XBDIQ1(9000010.07,X,.04)
 .Q
 I G]"" Q C_U_G
 Q ""
 ;
LVADEX(P,BD,ED) ;EP
 NEW X
 S X=$$LASTPRC^BGP9UTL1(P,"BGP LVAD/HEART TRANSPLANT PROC",BD,ED)
 Q X
 ;
HFDX(V) ;EP
 NEW C,T
 S C=$$PRIMPOV^APCLV(V,"I")
 I C="" Q 0 ;no primary dx
 S T=$O(^ATXAX("B","BGP CMS HEART FAILURE DXS",0))
 I 'T Q
 Q $$ICD^ATXCHK(C,T,9)
 ;
COMFORT(P,BDATE,EDATE) ;EP - any V66.7 on this visit? or during hospital stay?
 NEW X
 S X=$$LASTDXI^BGP9UTL1(DFN,"V66.7",BDATE,EDATE)
 I X="" Q ""
 Q $P(X,U,2)_"  "_$$DATE^BGP9UTL($P(X,U,3))
 ;
DODA(V,H) ;EP was discharge day of or day after admission
 I $G(V)="" Q 0
 I $G(H)="" Q 0
 I $P($P(^AUPNVSIT(V,0),U),".")=$P($P(^AUPNVINP(H,0),U),".") Q 1
 NEW X
 S X=$$FMADD^XLFDT($P($P(^AUPNVSIT(V,0),U),"."),1)
 I X=$P($P(^AUPNVINP(H,0),U),".") Q 1
 Q 0
 ;
DDA(V,H) ;EP - was patient discharged on the day of arrival
 I $G(V)="" Q 0
 I $G(H)="" Q 0
 I $P($P(^AUPNVSIT(V,0),U),".")=$P($P(^AUPNVINP(H,0),U),".") Q 1
 Q 0
 ;
DEATHAMA(H) ;EP was discharge death or AMA?
 NEW X
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=3 Q 1
 I X=4 Q 1
 I X=5 Q 1
 I X=6 Q 1
 I X=7 Q 1
 Q 0
 ;
REGDSCH(H) ;EP
 NEW X
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=1 Q 1
 Q 0
 ;
AMA(H,D) ;EP
 NEW X
 I $P($P($G(^AUPNVINP(H,0)),U),".")=D Q 0
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=3 Q 1
 Q 0
 ;
AMIDX(V) ;EP - AMI DX?
 NEW C,T
 S C=$$PRIMPOV^APCLV(V,"I")
 I C="" Q 0 ;no primary dx
 S T=$O(^ATXAX("B","BGP CMS AMI DXS",0))
 I 'T Q
 Q $$ICD^ATXCHK(C,T,9)
 ;
EXPIRED(H,D) ;
 NEW X
 I $P($P($G(^AUPNVINP(H,0)),U),".")=D Q 0
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=4!(X=5)!(X=6)!(X=7) Q 1
 Q 0
 ;
DSCH(H) ;EP - RETURN DSCH DATE IN INTERNAL FORMAT
 Q $P($P(^AUPNVINP(H,0),U),".")
 ;
TRANSIN(H) ;EP
 NEW X
 S X=$P(^AUPNVINP(H,0),U,7)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=2!(X=3) Q 1
 Q 0
 ;
TRANS(H) ;EP - was this a transfer out?
 NEW X
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=2 Q 1
 Q 0
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:80)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
 ;
GETMEDS(P,BGPMBD,BGPMED,TAX1,TAX2,TAX3,EXP,ADM,BGPDNAME,BGPC,LAST) ;EP
 K ^TMP($J,"MEDS")
 S LAST=$G(LAST)
 NEW BGPC1,T,T1,T2,X,Y,G,D,C,BGPZ
 S BGPDNAME=$G(BGPDNAME)
 S BGPC1=0 K BGPZ
 S Y="^TMP($J,""MEDS"",",X=P_"^ALL MED;DURING "_$$FMTE^XLFDT(BGPMBD)_"-"_$$FMTE^XLFDT(BGPMED) S E=$$START1^APCLDF(X,Y)
 S T="" I TAX1]"" S T=$O(^ATXAX("B",TAX1,0))
 S T1="" I TAX2]"" S T1=$O(^ATXAX("B",TAX2,0))
 S T2="" I TAX3]"" S T2=$O(^ATXAX("B",TAX3,0))
 S X=0 F  S X=$O(^TMP($J,"MEDS",X)) Q:X'=+X  S Y=+$P(^TMP($J,"MEDS",X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .S C=$P($G(^PSDRUG(D,0)),U,2)
 .I C]"",T2,$D(^ATXAX(T2,21,"B",C)) S G=1
 .S C=$P($G(^PSDRUG(D,2)),U,4)
 .I C]"",T1,$D(^ATXAX(T1,21,"B",C)) S G=1
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1
 .I BGPDNAME]"",$P(^PSDRUG(D,0),U)[BGPDNAME S G=1
 .Q:'G
 .I $G(EXP) Q:$$EXP(Y,ADM)
 .I G=1 D
 ..S N=$P(^TMP($J,"MEDS",X),U,2)_"   "_$P(^AUPNVMED(Y,0),U,5)_"  qty: "_$P(^AUPNVMED(Y,0),U,6)_" days: "_$P(^AUPNVMED(Y,0),U,7)_" "_$$DATE^BGP7UTL($P(^TMP($J,"MEDS",X),U))
 ..I $P(^AUPNVMED(Y,0),U,8)]"" S N=N_"  D/C "_$$DATE^BGP9UTL($P(^AUPNVMED(Y,0),U,8))
 ..S BGPZ($P(^TMP($J,"MEDS",X),U,2),(9999999-$P(^TMP($J,"MEDS",X),U)))=N
 .Q
 I 'LAST D
 .S N="" F  S N=$O(BGPZ(N)) Q:N=""  D
 ..S D=0,D=$O(BGPZ(N,D)) I '$D(BGPY("B",N,D)) S BGPC=BGPC+1,BGPY(BGPC)=BGPZ(N,D),BGPY("B",N,D)=""
 I LAST D
 .S N="" F  S N=$O(BGPZ(N)) Q:N=""  D
 ..S D=0,D=$O(BGPZ(N,D)) S BGPY(D)=BGPZ(N,D)
 ..S X=$O(BGPY(0)) S X=BGPY(X)
 ..K BGPY
 ..S BGPY=X
 Q
EXP(Y,ADM) ;
 NEW G,V,N,Z,E
 S G=0  ;not expired
 S N=$P($G(^AUPNVMED(Y,0)),U,7) ;DAYS SUPPLY
 S V=$P(^AUPNVMED(Y,0),U,3)
 S Z=$S($D(^PSRX("APCC",Y)):$O(^(Y,0)),1:0) I Z D
 .S E=$P($G(^PSRX(Z,2)),U,6)
 .I E<ADM S G=1  ;prescription expired prior to admission date
 I $$FMADD^XLFDT($P($P(^AUPNVSIT(V,0),U),"."),N)<ADM S G=1
 Q G
DSCHINST(P,BDATE,EDATE) ;EP - discharge instructions
 ;patient ed code HF-DCHL
 NEW BGPG,X,Y,T,D,%,E
 S Y="BGPG("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG) Q ""
 S (X,D)=0,%="",T="" F  S X=$O(BGPG(X)) Q:X'=+X!(%]"")  D
 .S T=$P(^AUPNVPED(+$P(BGPG(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S E=$P(^AUTTEDT(T,0),U,2)
 .I E="HF-DCHL" S %=$P(^AUTTEDT(T,0),U,1)_"  "_$$DATE^BGP9UTL($P(BGPG(X),U)) Q
 Q %
