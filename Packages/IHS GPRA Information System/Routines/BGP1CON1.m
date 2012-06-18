BGP1CON1 ; IHS/CMI/LAB - measure AHR.A 30 May 2010 9:32 AM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
BETA ;EP - BETA BLOCKER CONTRAINDICATION/NMI REFUSAL
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 S NMIB=$G(NMIB)
 S NMIE=$G(NMIE)
 I NMIE="" S NMIE=DT
 I NMIB="" S NMIB=$$FMADD^XLFDT($S(NMIE]"":NMIE,1:DT),-365)
 ;
 NEW BGPG,BGPD,X,G,T,D,Y,N
 S X=P_"^ALL DX [BGP ASTHMA DXS;DURING "_BDATE_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S (X,G)=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPD($P(BGPG(X),U))=""
 S (X,G)=0 F  S X=$O(BGPD(X)) Q:X'=+X  S G=G+1
 I G>1 Q 1_U_"2 DX asthma-Beta Blocker contraindication"
 K BGPG
 S BGPG=$$LASTDX^BGP1UTL1(P,"BGP HYPOTENSION DXS",BDATE,EDATE)
 I $P(BGPG,U)=1 Q 1_U_"Hypotension dx-Beta Blocker contraindication"  ;has hypotension dx
 S BGPG=$$LASTDX^BGP1UTL1(P,"BGP CMS 2/3 HEART BLOCK DXS",BDATE,EDATE)
 I $P(BGPG,U)=1 Q 1_U_"heart blk dx-Beta Blocker contraindication"  ;has heart block dx
 S BGPG=$$LASTDXI^BGP1UTL1(P,"427.81",BDATE,EDATE)
 I $P(BGPG,U)=1 Q 1_U_"sinus bradycardia-Beta Blocker contraindication"
 K BGPG,BGPD
 S X=P_"^ALL DX [BGP COPD DXS BB CONT;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S (X,G)=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPD($P(BGPG(X),U))=""
 S (X,G)=0 F  S X=$O(BGPD(X)) Q:X'=+X  S G=G+1
 I G>1 Q 1_U_"COPD dx-Beta Blocker contraindication"
 ;
 ;now check for NMI of beta blocker NMIB-NMIE
 ;
 S T=$O(^ATXAX("B","BGP HEDIS BETA BLOCKER MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not a Beta Blocker
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<NMIB Q  ;documented more than 1 year before edate
 ..I Y>NMIE Q  ;documented after edate
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S G=1_U_"Beta Blocker contra NMI med "_$$DATE^BGP1UTL(Y)
 ..Q
 .Q
 I G Q G
 ;now cpt 8011 BETWEEN NMIB,NMIE
 S X=$$CPTI^BGP1DU(P,NMIB,NMIE,+$$CODEN^ICPTCOD("G8011"))
 I X Q "1^Beta Blocker contra CPT code G8011: "_$$DATE^BGP1UTL($P(X,U,2))
 S X=$$TRANI^BGP1DU(P,NMIB,NMIE,+$$CODEN^ICPTCOD("G8011"))
 I X Q "1^Beta Blocker contra TRAN code G8011: "_$$DATE^BGP1UTL($P(X,U,2))
 Q ""
 ;
ASA ;EP - ASA CONTRAINDICATIONS
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 S NMIB=$G(NMIB)
 S NMIE=$G(NMIE)
 I NMIE="" S NMIE=DT
 I NMIB="" S NMIB=$$FMADD^XLFDT($S(NMIE]"":NMIE,1:DT),-365)
 ;
 ;
 NEW BGPMEDS1,K,R,BGPG,T,X,Y,D,G,N,J,V,S,E
 K BGPMEDS1
 S K=0,R="",BGPG=""
 D GETMEDS^BGP1UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T=$O(^ATXAX("B","BGP CMS WARFARIN MEDS",0))
 S X=0 F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(BGPG)  S Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1 G WAR71
 .S N=$P($G(^PSDRUG(D,0)),U,1)
 .I N["WARFARIN" S G=1 G WAR71
 .Q:'G
WAR71 .;
 .S J=$P(^AUPNVMED(Y,0),U,8)
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .;S IS DAYS SUPPLY, J IS DATE DISCONTINUED
 .I J]"" Q:J<BDATE  ;discontinued before beginning date
 I BGPG Q 1_U_"asa contra warfarin rx "_$P(BGPG,U,2)_" "_$P(BGPG,U,3)
 ;now check for dx 459
 K BGPG S BGPG=$$LASTDXI^BGP1UTL1(P,"459.0",$$DOB^AUPNPAT(P),EDATE)
 I BGPG Q 1_U_"asa contra 459.0 "_$$DATE^BGP1UTL($P(BGPG,U,3))
 ;
 ;nmi in refusal file for aspirin
 S BGPG=""
 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not an aspirin
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..I Y<NMIB Q  ;before date
 ..I Y>NMIE Q  ;after date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S BGPG=1_U_"asa contra NMI Aspirin:  "_$$VAL^XBDIQ1(9000022,N,.04)_" "_$$DATE^BGP1UTL($P(^AUPNPREF(N,0),U,3))_" "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I BGPG Q BGPG
 ;now check for CPT code G8008
 S X=$$CPTI^BGP1DU(P,NMIB,NMIE,+$$CODEN^ICPTCOD("G8008"))
 I X Q 1_U_"asa contra CPT code G8008: "_$$DATE^BGP1UTL($P(X,U,2))
 S X=$$TRANI^BGP1DU(P,NMIB,NMIE,+$$CODEN^ICPTCOD("G8008"))
 I X Q 1_U_"asa contra Tran Code G8008: "_$$DATE^BGP1UTL($P(X,U,2))
 Q ""
 ;
ACEI ;EP does patient have an ACEI contraidication
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 S NMIB=$G(NMIB)
 S NMIE=$G(NMIE)
 I NMIE="" S NMIE=DT
 I NMIB="" S NMIB=$$FMADD^XLFDT($S(NMIE]"":NMIE,1:DT),-365)
 ;
 NEW BGPG,BGPC,X,Y,Z,N,E
 K BGPG S Y="BGPG(",X=P_"^LAST DX [BGP CMS AORTIC STENOSIS DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"ACEI contra POV:  "_$$DATE^BGP1UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 ;
 ;nmi in refusal file for ACEI
 S BGPG=""
 S T=$O(^ATXAX("B","BGP HEDIS ACEI MEDS",0))
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not an ACEI
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D I Y<NMIB Q  ;documented more than 1 year before discharge
 ..I Y>NMIE Q  ;documented after End date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S BGPG=1_U_"NMI ACEI: "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP1UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I BGPG Q BGPG
 ;nmi in refusal file for ACEI
 S BGPG=""
 S T=$O(^ATXAX("B","BGP HEDIS ARB MEDS",0))
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not an ACEI
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D I Y<NMIB Q
 ..I Y>NMIE Q  ;documented after End date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S BGPG=1_U_"NMI ARB: "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP1UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I BGPG Q BGPG
 Q ""
 ;
STATIN ;EP does patient have an STATIN contraidication
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 S NMIB=$G(NMIB)
 S NMIE=$G(NMIE)
 I NMIE="" S NMIE=DT
 I NMIB="" S NMIB=$$FMADD^XLFDT($S(NMIE]"":NMIE,1:DT),-365)
 ;
 NEW ED,BD,BGPG,BGPC,X,Y,Z,N,E,T
 ;
 ;pregnant
 S X=$$PREG^BGP1D7(P,BDATE,EDATE,0,1) I X Q 1_U_"contra statin - pregnant"
 ;nmi in refusal file for STATI
 S BGPG=""
 S T=$O(^ATXAX("B","BGP HEDIS STATIN MEDS",0))
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not an STATI
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D I Y<NMIB Q  ;documented more than 1 year before discharge
 ..I Y>NMIE Q  ;documented after End date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S BGPG=1_U_"NMI STATIN: "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP1UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I BGPG Q BGPG
 ;breastfeeding
 K BGPG S Y="BGPG(",X=P_"^LAST DX V24.1;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"STATIN contra POV:  "_$$DATE^BGP1UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 ;now check education
 K BGPG
 S Y="BGPG("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S (X,D)=0,%="",T="" F  S X=$O(BGPG(X)) Q:X'=+X!(%]"")  D
 .S T=$P(^AUPNVPED(+$P(BGPG(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I T="BF-BC" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-BP" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-CS" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-EQ" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-FU" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-HC" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-ON" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-M" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-MK" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .I T="BF-N" S %=T_" "_$$DATE^BGP1UTL($P(BGPG(X),U)) Q
 .;I $P(T,"-")="V24.1" S %=T_U_$P(BGPG(X),U) Q
 I %]"" Q 1_U_"Statin contra - "_%
 ;NOW CHECK ALCOHOL HEPATITIS
 K BGPG S Y="BGPG(",X=P_"^LAST DX 571.1;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"STATIN contra POV:  "_$$DATE^BGP1UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 Q ""
