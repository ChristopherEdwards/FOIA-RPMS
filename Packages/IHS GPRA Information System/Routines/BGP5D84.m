BGP5D84 ; IHS/CMI/LAB - measure C ;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
HEDURI ;EP
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9,BGPD10,BGPD11,BGPD12)=0
 I 'BGPACTUP S BGPSTOP=1 Q
 S A=$$FMDIFF^XLFDT($$FMADD^XLFDT(BGPBDATE,-182),$P(^DPT(DFN,0),U,3))
 I A<91 S BGPSTOP=1 Q  ;less than 3 months old
 ;S A=$$AGE^AUPNPAT(DFN,$$FMADD^XLFDT(BGPBDATE,-180))
 ;I A<2 S BGPSTOP=1  ;must be at least 2
 S A=$$AGE^AUPNPAT(DFN,$$FMADD^XLFDT(BGPBDATE,182))
 I A>18 S BGPSTOP=1 Q   ;must not be older than 18 on this date
 S BGPDN=$$URI(DFN,$$FMADD^XLFDT(BGPBDATE,-182),$$FMADD^XLFDT(BGPBDATE,182)) I 'BGPDN S BGPSTOP=1 Q  ;no URI DX
 I BGPACTCL S BGPD1=1
 I BGPACTUP S BGPD2=1
 S BGPN=$$CANTI(DFN,BGPDN,$$FMADD^XLFDT(BGPDN,3))
 S BGPN1=$S('$P(BGPN,U):1,1:0)
 S BGPVALUE=$S(BGPRTYPE'=3:"UP",1:"")_$S(BGPD1:",AC",1:"")_"|||"_$P(BGPN,U,2)_" "_$P(BGPN,U,3)_$S(BGPN1:" MEETS MEASURE",1:"DOES NOT MEET MEASURE")
 K A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z,BDATE,EDATE,BGPDN,BGPN,BGPG,BGPC
 K ^TMP($J,"A")
 Q
 ;
URI(P,BDATE,EDATE) ;
 NEW BGPG,Y,X,G,V,E,C,H
 S Y="BGPG("
 S X=P_"^ALL DX [BGP URI DXS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG(1)) Q 0
 S X=0,G=0 F  S X=$O(BGPG(X)) Q:X'=+X!(G)  D
 .S V=$P(BGPG(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .I "ASO"'[$P(^AUPNVSIT(V,0),U,7) Q  ;not outpatient
 .S (C,E)=0 F  S E=$O(^AUPNVPOV("AD",V,E)) Q:E'=+E  S C=C+1
 .Q:C>1  ;can't have any other diagnoses
 .I $$CLINIC^APCLV(V,"C")=30 D  Q:H  ;if H is 1 then there was a hosp stay so don't use this visit
 ..S H=0
 ..S E=$O(^AUPNVER("AD",V,0)) I E,"ATLM"[$P($G(^AUPNVER(E,0)),U,11) S H=1 Q  ;er visit with admission
 ..S H=$$HOSPURI(P,$P($P(^AUPNVSIT(V,0),U),"."))
 .;NOW CHECK FOR ITEM #4 - NO NEW OR REFILL OF ANTIBIOTICS 30 DAYS PRIOR
 .S BGPD=$P($P(^AUPNVSIT(V,0),U),".")
 .Q:$$NEWRFA(P,$$FMADD^XLFDT(BGPD,-30),$$FMADD^XLFDT(BGPD,-1))
 .Q:$$ACTA(P,$$FMADD^XLFDT(BGPD,-30),$$FMADD^XLFDT(BGPD,-1))
 .;Q:'$$CANTI(P,BGPD,$$FMADD^XLFDT(BGPD,3))
 .S G=BGPD
 .Q
 Q G
NDC(A,B) ;
 ;a is drug ien
 ;b is taxonomy ien
 NEW BGPNDC
 S BGPNDC=$P($G(^PSDRUG(A,2)),U,4)
 I BGPNDC]"",B,$D(^ATXAX(B,21,"B",BGPNDC)) Q 1
 Q 0
NEWRFA(P,BDATE,EDATE) ;
 K ^TMP($J,"A")
 NEW A,B,E,Z,X,D,V,Y,G,M,T,T1
 K BGPMEDS1
 D GETMEDS^BGP5UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) G NEWFRAP
 S T1=$O(^ATXAX("B","BGP HEDIS ANTIBIOTICS MEDS",0))
 S T4=$O(^ATXAX("B","BGP HEDIS ANTIBIOTICS NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(D)  S V=$P(BGPMEDS1(X),U,5),Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),$P(^AUPNVMED(Y,0),U,8)="" S D=1
 K ^TMP($J,"A")
 I D Q D
NEWFRAP ;check V PROCEDURE
 S D=$$LASTPRC^BGP5UTL1(P,"BGP INJECTION ANTIBIOTIC PROCS",BDATE,EDATE)
 Q $P(D,U)
CANTI(P,BDATE,EDATE) ;
 K ^TMP($J,"A")
 NEW A,B,E,Z,X,D,V,Y,G,M,T,T1
 K BGPMEDS1
 D GETMEDS^BGP5UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) G CANTIP
 S T1=$O(^ATXAX("B","BGP HEDIS ANTIBIOTICS MEDS",0))
 S T4=$O(^ATXAX("B","BGP HEDIS ANTIBIOTICS NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(D)  S V=$P(BGPMEDS1(X),U,5),Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:$$UP^XLFSTR($P($G(^AUPNVMED(Y,11)),U))["RETURNED TO STOCK"
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S D=1_U_"antibiotic: "_$$DATE^BGP5UTL($P($P(^AUPNVSIT(V,0),U),"."))
 K ^TMP($J,"A")
 I D Q D
CANTIP ;check V PROCEDURE
 S D=$$LASTPRC^BGP5UTL1(P,"BGP INJECTION ANTIBIOTIC PROCS",BDATE,EDATE)
 Q $P(D,U)_$S(D:"^antibiotic injection: "_$$DATE^BGP5UTL($P(D,U,3)),1:"")
ACTA(P,BDATE,EDATE) ;
 K ^TMP($J,"A")
 NEW A,B,E,Z,X,D,V,Y,G,M,T,T1
 K BGPMEDS1
 D GETMEDS^BGP5UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) G ACTAP
 S T1=$O(^ATXAX("B","BGP HEDIS ANTIBIOTICS MEDS",0))
 S T4=$O(^ATXAX("B","BGP HEDIS ANTIBIOTICS NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(D)  S V=$P(BGPMEDS1(X),U,5),Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .S B=$$FMDIFF^XLFDT(EDATE,$P($P(^AUPNVSIT(V,0),U),"."))
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),$P(^AUPNVMED(Y,0),U,8)="" I $P(^AUPNVMED(Y,0),U,6)'<B S D=1
 K ^TMP($J,"A")
 I D Q D
ACTAP ;check V PROCEDURE
 S D=$$LASTPRC^BGP5UTL1(P,"BGP INJECTION ANTIBIOTIC PROCS",$$FMADD^XLFDT(EDATE,-30),$$FMADD^XLFDT(EDATE,-1))
 Q $P(D,U)_$S(D:"^antibiotic injection: "_$$DATE^BGP5UTL($P(D,U,3)),1:"")
HOSPURI(P,D) ;is there a hosp with pharyngitis on date D or 1 day later
 S (I,J,K,Q)=0
 F  S I=$O(^AUPNVSIT("AAH",P,I)) Q:I'=+I  D
 .S J=0 F  S J=$O(^AUPNVSIT("AAH",P,I,J)) Q:J'=+J  D
 ..Q:'$D(^AUPNVSIT(J,0))
 ..S K=$P($P(^AUPNVSIT(J,0),U),".")
 ..I K<D Q  ;before outpatient visit
 ..I K>$$FMADD^XLFDT(D,1) Q  ;more than 1 day after outpatient visit date
 ..;now must have a pharyngitis dx
 ..S (R,S,T)=0
 ..F  S R=$O(^AUPNVPOV("AD",J,R)) Q:R'=+R  D
 ...S T=$P($G(^AUPNVPOV(R,0)),U)
 ...Q:T=""
 ...S T=$P($$ICDDX^BGP5UTL2(T),U,2)
 ...Q:T=""
 ...Q:'$$ICD^BGP5UTL2(T,$O(^ATXAX("B","BGP URI DXS",0)),9)
 ...S S=1
 ..Q:'S
 ..S Q=1
 .Q
 Q Q
STREP(P,BDATE,EDATE) ;EP
 K BGPC
 S BGPC=0
 S %=$$CPT^BGP5DU(P,BDATE,EDATE,$O(^ATXAX("B","BGP GROUP A STREP CPT",0)))
 I %]"" Q 1_U_%
 S %=$$TRAN^BGP5DU(P,BDATE,EDATE,$O(^ATXAX("B","BGP GROUP A STREP CPT",0)))
 I %]"" Q 1_U_%
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP GROUP A STREP LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP GROUP A STREP TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_(9999999-D)_U_"LAB" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP5D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"LOINC"
 ...Q
 I BGPC Q BGPC
 ;now check v microbiology
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVMIC("AE",P,D)) Q:D'=+D!(D>B)!($P(BGPC,U))  D
 .S L=0 F  S L=$O(^AUPNVMIC("AE",P,D,L)) Q:L'=+L!($P(BGPC,U))  D
 ..S X=0 F  S X=$O(^AUPNVMIC("AE",P,D,L,X)) Q:X'=+X!($P(BGPC,U))  D
 ...Q:'$D(^AUPNVMIC(X,0))
 ...I BGPLT,$P(^AUPNVMIC(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVMIC(X,0),U))) S BGPC=1_U_(9999999-D)_U_"MICRO" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVMIC(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP5D21(J,T)
 ...S BGPC=1_U_(9999999-D)_U_"MICRO LOINC"
 ...Q
 Q BGPC
HEPC ;
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPD1,BGPD2)=0
 ;BGPD1 - PTS WITH NO HEP C
 ;BGPD2 - PTS WITH HEP C
 ;BGPN1 - PTS SCREENED IF IN BGPD1
 ;BGPN2 - PTS WITH CONF TEST IF IN BGPD2
 ;BGPN3 - PTS IN BGPN2 WITH POS RESULT
 ;BGPN4 - PTS IN BGPN2 WITH NEG RESULT
 ;BGPN5 - PTS IN BGPN2 WITH NO RESULT
 NEW BGPHSCR
 S BGPVALUE=""
 I 'BGPACTUP S BGPSTOP=1 Q
 Q:$$DOB^AUPNPAT(DFN)<2450101
 Q:$$DOB^AUPNPAT(DFN)>2651231
 I $$HEPCDX(DFN,BGPEDATE) S BGPD2=1
 I 'BGPD2 S BGPD1=1
 S BGPHSCR=""
 I BGPD1 S BGPHSCR=$$HEPCSCR(DFN,BGPEDATE) I $P(BGPHSCR,U,1) S BGPN1=1
 I BGPD2 S BGPHSCR=$$HEPCCON(DFN,BGPEDATE) D
 .I $P(BGPHSCR,U,1) S BGPN2=1
 .I $P(BGPHSCR,U,5)="POS" S BGPN3=1 Q
 .I $P(BGPHSCR,U,5)="NEG" S BGPN4=1 Q
 .S BGPN5=1
 I BGPD1 S BGPVALUE="UP|||" I BGPN1 S BGPVALUE=BGPVALUE_"Screen: "_$P(BGPHSCR,U,2)_" "_$P(BGPHSCR,U,3)
 I BGPD2 S BGPVALUE="UP,HEP|||" I BGPN2 S BGPVALUE=BGPVALUE_"Conf "_$P(BGPHSCR,U,2)_" "_$P(BGPHSCR,U,3)_" result="_$P(BGPHSCR,U,5)
 Q
HEPCDX(P,EDATE) ;
 NEW T,X,G
 ;now check problem list
 S T=$O(^ATXAX("B","BGP HEPATITIS C DXS",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;if added to pl after end of time period, no go
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .Q:'$$ICD^BGP5UTL2(Y,T,9)
 .S G=1
 .Q
 I G Q G
 S X=$$LASTDX^BGP5UTL1(P,"BGP HEPATITIS C DXS")
 I X Q 1
 Q ""
HEPCSCR(P,EDATE) ;
 NEW X,G,T,%,BGPC,BGPLT,L,D,J
 S %="",E=+$$CODEN^ICPTCOD(86803),%=$$CPTI^BGP5DU(P,$$DOB^AUPNPAT(P),EDATE,E)
 I % Q 1_U_$$DATE^BGP5UTL($P(%,U,2))_" CPT 86803"
 ;now get all loinc/taxonomy tests
 S BGPC=""
 S T=$O(^ATXAX("B","BGP HEP C TEST LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","BGP HEP C TESTS TAX",0))
 S E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(BGPC)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC)  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC)  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=1_U_$$DATE^BGP5UTL((9999999-D))_" Lab Test" Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP5D2(J,T)
 ...S BGPC=1_U_$$DATE^BGP5UTL((9999999-D))_" Lab Test (Loinc "_$$VAL^XBDIQ1(9000010.09,X,1113)_")"
 ...Q
 Q BGPC
HEPCCON(P,EDATE) ;
 ;return first test with a valid result
 ;if none with a valid result, return 1st one
 NEW BGPG,BGPT,BGPLT
 ;GET ALL LABS INTO ARRAY BGPG
 S BGPLT=$O(^ATXAX("B","BGP HEP C CONF LOINC",0))
 S BGPT=$O(^ATXLAB("B","BGP HEP C CONF TEST TAX",0))
 NEW D,V,G,X,J,B,E,C,Y,R,I
 S C=0,E=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1,D=D_".9999" F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y  D
 ...I BGPT,$D(^ATXLAB(BGPT,21,"B",X)) D SETLAB Q
 ...Q:'BGPLT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP5D21(J,BGPLT)
 ...D SETLAB Q
 ...Q
 ..Q
 .Q
 ;NOW SET UP ARRAY AS DATE^ITEM^RESULT
 ;ADD IN CPT CODES
 S X=$$FIRSTCPT^BGP5UTL1(P,"BGP HEP C CONF CPTS",$$DOB^AUPNPAT(P),EDATE)
 I X D
 .S C=C+1
 .S BGPG($P(X,U,1),C)=$P(X,U,1)_U_$P(X,U,2)
 ;FIND FIRST WITH A VALID RESULT
 I '$O(BGPG(0)) Q ""  ;NO TESTS
 S D=0,G="" F  S D=$O(BGPG(D)) Q:D'=+D!(G)  D
 .S C=0
 .F  S C=$O(BGPG(D,C)) Q:C'=+C!(G)  D
 ..;Q:$P(BGPG(D,C),U,3)=""  ;NO RESULT
 ..S R=$P(BGPG(D,C),U,3)
 ..S I="" I $P(BGPG(D,C),U,2)["Lab" S I=$P(BGPG(D,C),U,4)
 ..S Y=$$GOODRES(R,I) I Y]"" S G=1_U_$$DATE^BGP5UTL($P(BGPG(D,C),U,1))_U_$P(BGPG(D,C),U,2)_U_$P(BGPG(D,C),U,3)_U_Y
 ; IF NO RESULT TAKE FIRST ONE
 I G Q G
 S D=$O(BGPG(0)),C=$O(BGPG(D,0))
 Q 1_U_$$DATE^BGP5UTL($P(BGPG(D,C),U,1))_U_$P(BGPG(D,C),U,2)_U_U_"No Result"
SETLAB ;
 S C=C+1
 S BGPG($$VDTM^APCLV($P(^AUPNVLAB(Y,0),U,3)),C)=$$VD^APCLV($P(^AUPNVLAB(Y,0),U,3))_"^"_"Lab"_"^"_$$VAL^XBDIQ1(9000010.09,Y,.04)_"^"_Y_"^"_$P(^AUPNVLAB(Y,0),U,3)
 Q
CD4RES(P,BDATE,EDATE,NORES) ;EP
 NEW BGPG,BGPT,BGPC,BGPLT,T,B,E,D,L,X,R,G,C,%
 K BGPG,BGPT,BGPC
 S BGPC=0
 S NORES=$G(NORES)
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP CD4 LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","BGP CD4 TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPT(D,BGPC)=$P(^AUPNVLAB(X,0),U,4) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP5D2(J,T)
 ...S R=$P(^AUPNVLAB(X,0),U,4)
 ...I 'R S R=""
 ...S BGPC=BGPC+1,BGPT(D,BGPC)=R
 ...Q
 ; now got though and set return value of done 1 or 0^VALUE^date
 S D=0,G="" F  S D=$O(BGPT(D)) Q:D'=+D!(G]"")  D
 .S C=0 F  S C=$O(BGPT(D,C)) Q:C'=+C!(G]"")  D
 ..S X=BGPT(D,C)
 ..I X="" Q
 ..S G=(9999999-D)_U_X
 ..Q
 I G="" D  ;now get one with no result
 .S D=0,G="" F  S D=$O(BGPT(D)) Q:D'=+D!(G]"")  D
 ..S C=0 F  S C=$O(BGPT(D,C)) Q:C'=+C!(G]"")  D
 ...S X=BGPT(D,C)
 ...I X="" Q
 ...S G=(9999999-D)_U_X
 ..Q
 ;
 I 'NORES,G]"" Q 1_U_G  ;IF WANT A RESULT AND THERE IS ONE QUIT
 S %=$$CPT^BGP5DU(P,BDATE,EDATE,$O(^ATXAX("B","BGP CD4 CPTS",0)),5)
 I %]"" S BGPC=BGPC+1,BGPT(9999999-$P(%,U,1),BGPC)="CPT "_$P(%,U,2)
 S %=$$TRAN^BGP5DU(P,BDATE,EDATE,$O(^ATXAX("B","BGP CD4 CPTS",0)),5)
 I %]"" S BGPC=BGPC+1,BGPT(9999999-$P(%,U,1),BGPC)="CPT "_$P(%,U,2)
 I '$O(BGPT(0)) Q ""
 S %=$O(BGPT(0)) S C=$O(BGPT(%,0)) Q 1_"^"_(9999999-%)_"^"_BGPT(%,C)
 Q ""
 ;
GOODRES(R,I) ;EP
 ;is this a good result
 ;Positive confirmation test result defined as any number greater than 
 ;zero, "Pos", "Positive", "Detected", a result starting with ">", or a 
 ;result starting with a number.
 ;Negative confirmation test result defined as a result starting with "<", "Neg", "Negative", "None detected", "None Detec", or "Not detected".
 S R=$G(R)
 I R="" Q ""
 S R=$$UP^XLFSTR(R)
 I $E(R)="<" Q "NEG"
 I R["NEGATIVE" Q "NEG"
 I R["NEG" Q "NEG"
 I R["NONE DETECTED" Q "NEG"
 I R["NONE DETEC" Q "NEG"
 I R["NOT DETECTED" Q "NEG"
 I R["NOTDETECTED" Q "NEG"
 I R["NOT DETECT" Q "NEG"
 I $E(R)=">" Q "POS"
 I R["POSITIVE" Q "POS"
 I R["DETECTED" Q "POS"
 I R["POS" Q "POS"
 I +R>0 Q "POS"
 Q ""
GOODRES1 ;
 I '$G(I) Q ""
 ;comments field
 I $$UP^XLFSTR($G(^AUPNVLAB(I,13)))["NOT DETECTED" Q "NEG"
 NEW J,K,T
 S T=""
 S J=0,K="" F  S J=$O(^AUPNVLAB(I,21,J)) Q:J'=+J  D
 .S K=K_$G(^AUPNVLAB(I,21,J,0))
 I $$UP^XLFSTR(K)["NOT DETECTED" Q "NEG"
 I $$UP^XLFSTR(K)["NOTDETECTED" Q "NEG"
 Q ""
