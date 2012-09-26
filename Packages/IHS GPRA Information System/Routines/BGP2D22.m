BGP2D22 ; IHS/CMI/LAB - measure I2 ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
I2 ;EP
 K BGPN1,BGPN2,BGPN3,BGPN4,BGPVALUE,BGPLHGB,BGPN5,BGPN6,BGPN7,BGPN8,BGPD7
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7,BGPN8)=0
 S BGPD1=0,BGPD7=1  ;D7 FOOT DENOM
 I 'BGPDMD2 S BGPSTOP=1 Q
 I BGPDMD2 S BGPD1=1
 I 'BGPDM1 S BGPSTOP=1 Q
 I 'BGPD1 S BGPSTOP=1 Q
 S BGPLHGB=$$HGBA1C^BGP2D2(DFN,BGPBDATE,BGPEDATE)
 S BGPN1=$P(BGPLHGB,U)
 S BGPVALUE=""
 I BGPN1 S BGPVALUE=BGPVALUE_"A1c: "_$$DATE^BGP2UTL($P(BGPLHGB,U,3))_" "_$P(BGPLHGB,U,4)
 K X,Y,Z,%,A,B,C,D,E,H,BDATE,EDATE,P,V,S,F,J,K,G,I,L,T,BGPG
22 ;BPS to set numr 2
 S BGPV=""
 S BGPBP=$$MEANBP^BGP2D2(DFN,BGPBDATE,BGPEDATE)
 I BGPBP="" S BGPBP=$$BPCPT(DFN,BGPBDATE,BGPEDATE) I BGPBP]"" S BGPN2=1 D  G BPS
 .S BGPN7=$P(BGPBP,U),BGPV=$S(BGPN7:"BP: <130/80: BP: ",BGPN2:"BP: ",1:"")_$P(BGPBP,U,2)
 I BGPBP="" G BPS
 S BGPN2=1
 S S=$P(BGPBP," ",1)
 S DS=$P(S,"/",2),S=$P(S,"/",1)
 I S<130&(DS<80) S BGPN7=1,BGPV="BP: <130/80: BP: "_S_"/"_DS I 1
 E  S BGPV="BP: "_S_"/"_DS
BPS ;
 I BGPV]"" S BGPVALUE=BGPVALUE_$S(BGPVALUE]"":"; ",1:"")_BGPV
 ;
23 ;
 S BGPLDL=$$LDL^BGP2D2(DFN,BGP365,BGPEDATE,1)
 S BGPN3=$P(BGPLDL,U)
 I BGPN3 S BGPVALUE=BGPVALUE_$S(BGPVALUE]"":"; ",1:"")_"LDL: "_$$DATE^BGP2UTL($P(BGPLDL,U,2))_" "_$P(BGPLDL,U,3)
 K X,Y,Z,%,A,B,C,D,E,H,BDATE,EDATE,P,V,S,F,BGPLDL,BGPHDL,BGPTRI,BGPLP
24 ;micro or pos urine & GFR
 S BGPGFR=$$GFR^BGP2D211(DFN,BGP365,BGPEDATE)
 S BGPESRD=$$ESRD^BGP2D211(DFN,$P(^DPT(DFN,0),U,3),BGPEDATE)
 S BGPQUP=$$QUANTUP^BGP2D211(DFN,BGPBDATE,BGPEDATE)
 I $P(BGPESRD,U) S BGPN4=1
 I BGPGFR&(BGPQUP) S BGPN4=1
 I BGPN4 D
 .I BGPESRD S BGPVALUE=BGPVALUE_$S(BGPVALUE]"":"; ",1:"")_$S(BGPESRD]"":"ESRD: "_$$DATE^BGP2UTL($P(BGPESRD,U,3))_" "_$P(BGPESRD,U,2),1:"") Q
 .S BGPVALUE=BGPVALUE_$S(BGPVALUE]"":"; ",1:"")_"GFR: "_$$DATE^BGP2UTL($P(BGPGFR,U,2))
 .S BGPVALUE=BGPVALUE_" & QUANT UP: "_$$DATE^BGP2UTL($P(BGPQUP,U,3))_" "_$P(BGPQUP,U,2)
 K BGPX,BGPC
25 ;
 S BGPEYE=$$EYE^BGP2D21(DFN,BGP365,BGPEDATE,1)
 S A=0 I $P(BGPEYE,U)=1 S A=1
 S B=0 I $P(BGPEYE,U)=2 S B=1
 S C=0 I $P(BGPEYE,U)=3 S C=1
 S BGPN5=0 I A!(B)!(C) S BGPN5=1
 I BGPN5 S BGPVALUE=BGPVALUE_$S(BGPVALUE]"":"; ",1:"")_"EYE: "_$$DATE^BGP2UTL($P(BGPEYE,U,2))_" "_$P(BGPEYE,U,3)
 K BGPG
 K ^TMP($J,"A")
26 ;FOOT EXAM
 S X=$$AMP^BGP2D27(DFN,BGPEDATE) I X S BGPD7=0,BGPVALUE=BGPVALUE_$S(BGPVALUE]"":"; ",1:"")_"FOOT AMPUTATION" G ALL ;if had amputation don't put in d7 denom
 S BGPFOOT=$$FOOT(DFN,BGPBDATE,BGPEDATE,1)
 S BGPN8=$P(BGPFOOT,U)
 I BGPN8 S BGPVALUE=BGPVALUE_$S(BGPVALUE]"":"; ",1:"")_"FOOT EXAM: "_$$DATE^BGP2UTL($P(BGPFOOT,U,2))_" "_$P(BGPFOOT,U,3)
ALL I BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,$S(BGPD7:BGPN8,1:1) S BGPN6=1
 S BGPVALUE="AD|||"_BGPVALUE I BGPN6 S BGPVALUE=$P(BGPVALUE,"|||")_"|||*ALL* "_$P(BGPVALUE,"|||",2)
 K BGPBP,BGPLDL,BGPEYE,BGPUP,BGPLHGB,BGPG,BGPX,BGPC,BGPGFR,BGPFOOT
 K ^TMP($J,"A")
 Q
IOMW ;EP
 S (BGPD1,BGPD2,BGPD3,BGPD4,BGPD5)=0
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7)=0
 I BGPAGEB<67 S BGPSTOP=1 Q
 I $P(^DPT(DFN,0),U,2)'="F" S BGPSTOP=1 Q
 S BGPFRAC=$$FRACTURE^BGP2EL3(DFN,$$FMADD^XLFDT(BGPBDATE,-182),$$FMADD^XLFDT(BGPBDATE,182))
 I '$P(BGPFRAC,U) S BGPSTOP=1 Q
 I BGPACTCL S BGPD1=1
 I BGPACTUP S BGPD2=1
 S BGPISD=$P(BGPFRAC,U,2),BGPISV=$P(BGPFRAC,U,3),BGPISV=$P(BGPFRAC,U,4)
 S BGPBMD=""
 I $P(BGPFRAC,U,3)="H" S BGPBMD=$$TXBMD^BGP2EL4(DFN,$P($P(^AUPNVSIT(BGPISV,0),U),"."),$$DSCHDATE^APCLV(BGPISV,"I"),1)
 I $P(BGPFRAC,U,3)'="H" S BGPBMD=$$TXBMD^BGP2EL4(DFN,BGPISD,$$FMADD^XLFDT(BGPISD,182))
 I $P(BGPBMD,U) S BGPN1=1
 S BGPVALUE=$S(BGPRTYPE=3:"AC",BGPD1:"UP,AC",1:"UP")
 S Y=""
 F X=5,6,7 S V=$P(BGPFRAC,U,X) I V]"" S:Y]"" Y=Y_";" S Y=Y_V
 S BGPVALUE=BGPVALUE_" FX: "_$$DATE^BGP2UTL($P(BGPFRAC,U,2))_" "_Y_"|||"_$S($P(BGPBMD,U,2)]"":"TX: "_$P(BGPBMD,U,2),1:"")
 K X,Y,Z,%,A,B,C,D,E,H,BDATE,EDATE,P,V,S,F,T,FBD,FED
 Q
IAS ;EP
 S (BGPN1,BGPN2,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8)=0
 I BGPAGEB<5 S BGPSTOP=1 Q
 I BGPAGEB>56 S BGPSTOP=1 Q
 I $$EMP(DFN,$$DOB^AUPNPAT(DFN),BGPEDATE) S BGPSTOP=1 Q
 I $$COPD(DFN,$$DOB^AUPNPAT(DFN),BGPEDATE) S BGPSTOP=1 Q
 S (BGPASTH1,BGPASTH2)=$$ASSEV(DFN,BGPEDATE)
 I BGPASTH1="" S BGPASTH1=$$PERASTH(DFN,$$FMADD^XLFDT(BGPBDATE,-365),BGPBDATE)
 I BGPASTH2="" S BGPASTH2=$$PERASTH(DFN,BGPBDATE,BGPEDATE)
 I 'BGPASTH1!('BGPASTH2) K ^TMP($J,"A") S BGPSTOP=1 Q  ;not asthma in both time periods
 K ^TMP($J,"A")
 I BGPACTCL S BGPD1=1
 I BGPACTUP S BGPD2=1
 I BGPACTCL,BGPAGEB>4,BGPAGEB<10 S BGPD3=1
 I BGPACTCL,BGPAGEB>9,BGPAGEB<18 S BGPD4=1
 I BGPACTCL,BGPAGEB>17,BGPAGEB<57 S BGPD5=1
 I BGPACTUP,BGPAGEB>4,BGPAGEB<10 S BGPD6=1
 I BGPACTUP,BGPAGEB>9,BGPAGEB<18 S BGPD7=1
 I BGPACTUP,BGPAGEB>17,BGPAGEB<57 S BGPD8=1
 S BGPVALUE=$$ASTHTHER(DFN,BGPBDATE,BGPEDATE)
 I $P(BGPVALUE,U)=1 S BGPN1=1
 S BGPVALUE=$S(BGPRTYPE=3:"",BGPD2:"UP",1:"")_$S(BGPD1:",AC",1:"")_","_$P(BGPASTH1,U,2)_","_$S(BGPASTH1'=BGPASTH2:$P(BGPASTH2,U,2),1:"")_"|||"_$S($P(BGPVALUE,U,1):"NUM: "_$P(BGPVALUE,U,3)_", "_$P(BGPVALUE,U,2),1:"")
 K ^TMP($J,"A")
 Q
IL ;EP
 S (BGPN1,BGPN2,BGPN3,BGPD1,BGPD2)=0
 I BGPAGEB<18 S BGPSTOP=1 Q
 I BGPACTCL S BGPD1=1
 I BGPACTUP S BGPD2=1
 I '(BGPD1+BGPD2) S BGPSTOP=1 Q
 S X=$$CREAT(DFN,BGP365,BGPEDATE) I 'X S BGPSTOP=1 Q  ;no serum creatinine test
 S BGPGFR=$$GFRV(DFN,BGP365,BGPEDATE)
 I $P(BGPGFR,U) D
 .S BGPN1=1
 .S V=$P(BGPGFR,U,2)
 .I V]"" D
 ..I V[">" S BGPN3=1 Q
 ..I V["<" S BGPN2=1 Q
 .S V=+V I V,V<60 S BGPN2=1 Q
 .I V S BGPN3=1
 .Q
 S BGPVALUE=$S(BGPD2:"UP",1:"")_$S(BGPD1:",AC",1:"")_"|||"
 I $P(BGPGFR,U) S BGPVALUE=BGPVALUE_$$DATE^BGP2UTL($P(BGPGFR,U,3))_" GFR: "_$P(BGPGFR,U,2)
 K BGPGFR
 Q
CREAT(P,BDATE,EDATE) ;EP
 K BGPC
 S BGPC=0
 S T=$O(^ATXAX("B","BGP CREATININE CPTS",0))
 I T D  I X Q 1
 .S X=$$CPT^BGP2DU(P,BDATE,EDATE,T,1) I X]"" Q
 .S X=$$TRAN^BGP2DU(P,BDATE,EDATE,T,1)
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CREATININE LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT CREATININE TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC)  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC)  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S BGPC=1_U_(9999999-D)
 ...Q
 Q BGPC
GFRV(P,BDATE,EDATE) ;
 S BGPC=""
 S T=$O(^LAB(60,"B","ESTIMATED GFR",0))
 S T1=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I T,$P(^AUPNVLAB(X,0),U)=T S BGPC=1_U_$P(^AUPNVLAB(X,0),U,4)_U_(9999999-D) Q
 ...I T1,$D(^ATXLAB(T1,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_$P(^AUPNVLAB(X,0),U,4)_U_(9999999-D) Q
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...S %=$P($G(^LAB(95.3,J,9999999)),U,2)
 ...I %="33914-3" S BGPC=1_U_$P(^AUPNVLAB(X,0),U,4)_U_(9999999-D) Q
 ...S J=$P($G(^LAB(95.3,J,0)),U)_"-"_$P($G(^LAB(95.3,J,0)),U,15)
 ...I J="33914-3" S BGPC=1_U_$P(^AUPNVLAB(X,0),U,4)_U_(9999999-D) Q
 ...Q
 Q BGPC
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
EMP(P,BDATE,EDATE) ;EP
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX [BGP EMPHYSEMA DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1
 Q 0
COPD(P,BDATE,EDATE) ;EP
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX [BGP COPD DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1
 Q 0
PERASTH(P,BDATE,EDATE) ;EP
 ;item 1 - one visit to er w/493 OR hosp
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q 0
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S K=0
 .I $P(^AUPNVSIT(V,0),U,7)="H" S K=1
 .I $$CLINIC^APCLV(V,"C")=30 S K=1
 .Q:'K
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S Y=$$PRIMPOV^APCLV(V,"I")
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S G=1_U_$$DATE^BGP2UTL($P($P(^AUPNVSIT(V,0),U),".")) ;got one
 ;
 I G Q 1_U_"DX ON HOSP/OR ER ON "_$P(G,U,2)  ;had prim dx on 30 or H so meets denom
PER3 ;
 ;meds
 S BGPT=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S T=$O(^ATXAX("B","BGP HEDIS ASTHMA MEDS",0))
 S T3=$O(^ATXAX("B","BGP HEDIS ASTHMA NDC",0))
 S T1=$O(^ATXAX("B","BGP HEDIS ASTHMA INHALED MEDS",0))
 S T4=$O(^ATXAX("B","BGP HEDIS ASTHMA INHALED NDC",0))
 S T2=$O(^ATXAX("B","BGP HEDIS ASTHMA LEUK MEDS",0))
 S T5=$O(^ATXAX("B","BGP HEDIS ASTHMA LEUK NDC",0))
 S (X,G,M,D,E)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"AOS"'[$P(^AUPNVSIT(V,0),U,7)
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXCHK(%,BGPT,9) S D=1
 .I D S G=G+1 ;got one visit
 .S Y=0 F  S Y=$O(^AUPNVMED("AD",V,Y)) Q:Y'=+Y  D
 ..S S=0
 ..Q:'$D(^AUPNVMED(Y,0))
 ..Q:$$UP^XLFSTR($P($G(^AUPNVMED(Y,11)),U))["RETURNED TO STOCK"
 ..S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 ..I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),$P(^AUPNVMED(Y,0),U,8)="" S M=M+1 Q  ;it is an inhaled steroid that wasn't d/c'ed so 1 dispensing event
 ..I $D(^ATXAX(T,21,"B",Z))!($$NDC(Z,T3)) D
 ...Q:$$LEUK(Z,T2,T5)  ;don't count if it is a leukotriene
 ...S J=$P(^AUPNVMED(Y,0),U,8)
 ...I J]"" S S=$$FMDIFF^XLFDT(J,$P($P(^AUPNVSIT(V,0),U),"."))
 ...I J="" S S=$P(^AUPNVMED(Y,0),U,7)
 ...;S K=S/30,M=M+K
 ...S K=S\30 S:K<1 K=1 S M=M+K
 ..I $D(^ATXAX(T2,21,"B",Z))!($$NDC(Z,T5)) D  Q
 ...S J=$P(^AUPNVMED(Y,0),U,8)
 ...I J]"" S S=$$FMDIFF^XLFDT(J,$P($P(^AUPNVSIT(V,0),U),"."))
 ...I J="" S S=$P(^AUPNVMED(Y,0),U,7)
 ...S K=S\30 S:K<1 K=1 S M=M+K,E=E+K
 I G>3,M>1 Q 1_U_"4 POVS AND 2 MEDS"
 I M>3,E<M Q 1_U_"4 meds"  ;had 4 meds, not all were leuko
 I M>3,E=M,G>0 Q 1_U_"LEUKOTRIENE AND 1 DX"  ;had all leuk and 1 dx
 Q ""
 ;
ASSEV(P,EDATE) ;EP - NOW CHECK ASTHMA PACKAGE SEV
 ;find problem list active for asthma with 2, 3 or 4 in 15th piece
 NEW S,A,B,T,X,G,V,Y
 S G=""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;if added to pl after end
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .Q:$P(^AUPNPROB(X,0),U,15)=""
 .Q:$P(^AUPNPROB(X,0),U,15)<2
 .S G=1_U_"Severity >1 on PL for "_$P(^ICD9(Y,0),U)
 .Q
 I G Q G
 S D=9999999-EDATE-1,G=""
 S D=$O(^AUPNVAST("AS",P,D)) I D]""  D
 .S I="" F  S I=$O(^AUPNVAST("AS",P,D,I)) Q:I'=+I  D
 ..S S=^AUPNVAST("AS",P,D,I)
 ..I S>1 S G="1^Severity "_S_" in V Asthma "_$$DATE^BGP2UTL((9999999-D))
 Q G
 ;
NDC(A,B) ;
 ;a is drug ien
 ;b is taxonomy ien
 S BGPNDC=$P($G(^PSDRUG(A,2)),U,4)
 I BGPNDC]"",B,$D(^ATXAX(B,21,"B",BGPNDC)) Q 1
 Q 0
LEUK(A,B,C) ;
 ;a drug ien
 ;b tax ien
 ;c tax ien for ndc
 I $D(^ATXAX(B,21,"B",A)) Q 1
 I $$NDC(A,C) Q 1
 Q ""
ASTHTHER(P,BDATE,EDATE) ;EP
 ;get number of asthma medication events
 K BGPMEDS1
 D GETMEDS^BGP2UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T=$O(^ATXAX("B","BGP HEDIS PRIMARY ASTHMA MEDS",0))
 S T3=$O(^ATXAX("B","BGP HEDIS PRIMARY ASTHMA NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(D]"")  S V=$P(BGPMEDS1(X),U,5),Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$D(^AUPNVMED(Y,0))
 .Q:$$UP^XLFSTR($P($G(^AUPNVMED(Y,11)),U))["RETURNED TO STOCK"
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .I $D(^ATXAX(T,21,"B",Z))!($$NDC(Z,T3)),$P(^AUPNVMED(Y,0),U,8)="" S D=1_U_$P(^PSDRUG(Z,0),U)_U_$$DATE^BGP2UTL($P($P(^AUPNVSIT(V,0),U),".")) Q
 Q D
FOOT(P,BDATE,EDATE,REFUSAL) ;
 NEW BGPG,%,E,A,Y,X,R,G
 S REFUSAL=$G(REFUSAL)  ;if =1 then don't look for Refusal
 K BGPG S %=P_"^LAST EXAM DIABETIC FOOT EXAM;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q "1^"_$P(BGPG(1),U)_"^Diab Foot Ex"
 K ^TMP($J,"A")
 S A="^TMP($J,""A"","
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,A)
 S X=0,Y=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(^TMP($J,"A",X),U,5),"C") I R=65,'$$DNKA^BGP2D21($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y Q 1_"^"_D_"^Cl "_R
 S (X,Y)=0,D="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(^TMP($J,"A",X),U,5),"D") I (R=33!(R=84)!(R=25)),'$$DNKA^BGP2D21($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y Q "1^"_D_"^Prv "_R
 ;now check for Refusal
 S G=$$CPTI^BGP2DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("2028F"))
 I G Q G_"^CPT: 2028F"
 I $G(REFUSAL) Q ""
 S G=$$REFUSAL^BGP2UTL1(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0)),BDATE,EDATE)
 I $P(G,U)=1 Q "1^"_$P(G,U,2)_"^Refused"
 Q ""
BPCPT(P,BDATE,EDATE,GDEV) ;EP
 NEW S,D,C,E,BGPG,X,Y,G,T,M,A,Z,L
 K BGPG S Y="BGPG(",X=P_"^ALL VISIT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 ;go through and get all cpt codes in the 2 taxonomies and table by date using the lowest value on that day, skip ER visits
 S X=0,G="" F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S V=$P(BGPG(X),U,5)  ;visit ien
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:$$CLINIC^APCLV(V,"C")=30  ;clinic ER
 .I $G(GDEV) Q:$$GDEV^BGP2D2(V)
 .S E=0 F  S E=$O(^AUPNVCPT("AD",V,E)) Q:E'=+E  D
 ..S C=$P($G(^AUPNVCPT(E,0)),U)
 ..I 'C Q
 ..S D=$P($P(^AUPNVSIT(V,0),U),"."),D=(9999999-D)_"."_$P(D,".",2)
 ..I $$ICD^ATXCHK(C,$O(^ATXAX("B","BGP SYSTOLIC BP CPTS",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(S(D)) S(D)=Y,A(D)=Y_U_"S"
 ...I +S(D)>+Y S S(D)=Y
 ..I $$ICD^ATXCHK(C,$O(^ATXAX("B","BGP DIASTOLIC BP CPTS",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(T(D)) T(D)=Y,A(D)=Y_U_"T"
 ...I +T(D)>+Y S T(D)=Y
 ..I $$ICD^ATXCHK(C,$O(^ATXAX("B","BGP BP MEASURED CPT",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(M(D)) M(D)=Y,A(D)=Y_U_"M"
 .S E=0 F  S E=$O(^AUPNVPOV("AD",V,E)) Q:E'=+E  D
 ..S Y=$$VAL^XBDIQ1(9000010.07,E,.01)
 ..I Y="" Q
 ..Q:'$$ICD^ATXCHK($$VALI^XBDIQ1(9000010.07,E,.01),$O(^ATXAX("B","BGP HYPERTENSION SCREEN DXS",0)),9)
 ..S D=$P($P(^AUPNVSIT(V,0),U),"."),D=(9999999-D)_"."_$P(D,".",2)
 ..S:'$D(M(D)) M(D)=Y,A(D)=Y_U_"M"
 I '$D(S),'$D(T),'$D(M) Q ""  ;
 S L=$O(A(0)),Z=$P(A(L),U,2) I Z="M" Q 0_U_$P(A(L),U,1)
 S S=$O(S(0)) I S S S=S(S)
 S D=$O(T(0)) I D S D=T(D)
 I S=""!(D="") Q 0_U_S_"/"_D
 I S="3074F",D="3078F" Q 1_U_S_"/"_D
 Q 0_U_S_"/"_D
