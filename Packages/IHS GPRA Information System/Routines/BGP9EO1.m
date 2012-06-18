BGP9EO1 ; IHS/CMI/LAB - calc measures 29 Apr 2008 7:38 PM 14 Nov 2006 5:02 PM 12 Nov 2007 11:03 AM 07 Apr 2008 7:00 AM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
EODMG1 ;EP
 NEW BGPLHGB
 I 'BGPDMD2 S BGPSTOP=1 Q  ;don't process this measure, pt not diabetic
 S BGPD1=1  ;is active diabetic
 S BGPN1=0,BGPVALUE=""
 S BGPLHGB=$$HGBA1C(DFN,BGPBDATE,BGPEDATE)
 S BGPN1=$P(BGPLHGB,U)
 S BGPVALUE="AD||| "_$P(BGPLHGB,U,2)
 Q
 ;
 ;
EODMB1 ;EP
 NEW BGPBP,S,DS,BGPV
 I 'BGPDMD2 S BGPSTOP=1 Q  ;don't process this measure, pt not diabetic
 S BGPD1=1  ;is active diabetic
 S BGPN1=0,BGPVALUE="",BGPV=""
 S BGPBP=$$MEANBP^BGP9D2(DFN,BGPBDATE,BGPEDATE)
 I BGPBP="" S BGPBP=$$BPCPT(DFN,BGPBDATE,BGPEDATE) I BGPBP]"" D  G BPS
 .S BGPN1=$P(BGPBP,U),BGPV=$S(BGPN1:"BP: <140/90: BP: ",1:"")_$P(BGPBP,U,2)
 I BGPBP="" G BPS
 S S=$P(BGPBP," ",1)
 S DS=$P(S,"/",2),S=$P(S,"/",1)
 I S<140&(DS<90) S BGPN1=1,BGPV="BP: <140/90: BP: "_S_"/"_DS I 1
 E  S BGPV="BP: "_S_"/"_DS
BPS ;
 S BGPVALUE="AD||| "_BGPV
 Q
 ;
EODML1 ;EP
 NEW BGPLDL,S,DS,BGPV,BGPN3,BGPN4,BGPN5
 I 'BGPDMD2 S BGPSTOP=1 Q  ;don't process this measure, pt not diabetic
 S BGPD1=1  ;is active diabetic
 S BGPN1=0,BGPVALUE="",BGPV=""
 S BGPLDL=$$LDL^BGP9D2(DFN,BGPBDATE,BGPEDATE)
 ;now evaluate result
 S BGPN4=0 D CHKLDL^BGP9D2
 S BGPN1=BGPN4
 ;
 S BGPV="" I BGPLDL]"" S BGPV="LDL DONE: "_$$DATE^BGP9UTL($P(BGPLDL,U,2))_" "_$P(BGPLDL,U,3)
 S BGPVALUE="AD||| "_BGPV
 Q
 ;
EOOX ;
 NEW BGPOXV,BGPD,BGPN
 I 'BGPACTUP S BGPSTOP=1 Q  ;no active user pop
 I BGPAGEB<18 S BGPSTOP=1 Q  ;don't process this measure, pt under 18
 S BGPD1=0  ;Number of pneumonia visits
 S BGPN1=0,BGPVALUE=""
 K BGPOXV
 D PNEUOX(DFN,BGPBDATE,BGPEDATE,.BGPOXV)
 ;now evaluate result
 S BGPD1=BGPOXV("DENOM") ;number of pneumonia visits
 I 'BGPD1 S BGPSTOP=1 Q  ;no pneumonia visits
 S BGPN1=$P(BGPOXV(0),U,1)
 S BGPN2=$P(BGPOXV(0),U,2)
 S BGPN3=$P(BGPOXV(0),U,3)
 S BGPD="",BGPN=""
 S C=0 F  S C=$O(BGPOXV(C)) Q:C'=+C  D
 .S BGPD=BGPD_$S(BGPD]"":"; ",1:"")_$P(BGPOXV(C),U)
 .S BGPN=BGPN_$S(BGPN]"":"; ",1:"")_$P(BGPOXV(C),U,2)
 ;
 S BGPVALUE="UP "_BGPD_"||| "_BGPN
 Q
 ;
EOST ;
 NEW BGPOXV,BGPD,BGPN
 K BGPOXV
 I 'BGPACTUP S BGPSTOP=1 Q  ;no active user pop
 I BGPAGEB<18 S BGPSTOP=1 Q  ;don't process this measure, pt under 18
 S BGPD1=0  ;Number of pneumonia visits
 S BGPN1=0,BGPVALUE=""
 D TIAFIB(DFN,BGPBDATE,BGPEDATE,.BGPOXV)
 ;now evaluate result
 S BGPD1=BGPOXV("DENOM") ;number of pneumonia visits
 I 'BGPD1 S BGPSTOP=1 Q  ;no pneumonia visits
 S BGPN1=$P(BGPOXV(0),U,1)
 S BGPN2=$P(BGPOXV(0),U,2)
 S BGPN3=$P(BGPOXV(0),U,3)
 S BGPD="",BGPN=""
 S C=0 F  S C=$O(BGPOXV(C)) Q:C'=+C  D
 .S BGPD=BGPD_$S(BGPD]"":"; ",1:"")_$P(BGPOXV(C),U)
 .S BGPN=BGPN_$S(BGPN]"":"; ",1:"")_$P(BGPOXV(C),U,2)
 ;
 S BGPVALUE="UP "_BGPD_"||| "_BGPN
 Q
 ;
HGBA1C(P,BDATE,EDATE) ;EP
 NEW BGPG,BGPT,BGPC,E,%,L,T,BGPLT,D,X,J,C,G
 S BGPC=0
 S G=$$CPT^BGP9DU(P,BDATE,EDATE,$O(^ATXAX("B","BGP HGBA1C CPTS",0)),5)
 I G]"" S BGPC=BGPC+1,BGPT((9999999-$P(G,U,1)),BGPC)=U_"CPT "_$P(G,U,2)
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP HGBA1C LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPT(D,BGPC)=$P(^AUPNVLAB(X,0),U,4)_U_"LAB: "_$$VAL^XBDIQ1(9000010.09,X,.01) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP9D2(J,T)
 ...S BGPC=BGPC+1,BGPT(D,BGPC)=$P(^AUPNVLAB(X,0),U,4)_U_"LAB LOINC: "_$$VAL^XBDIQ1(9000010.09,X,.01)_" "_$P(^AUPNVLAB(X,11),U,13)
 ...Q
 ; now got though and set return value of done 1 or 0^numerator 2-7^date^value
 I '$D(BGPT) Q 1_U_"No documented HgbA1c"  ;no tests so is hit in numerator
 ; now get rid of all on same day where 1 has a result and the other doesn't
 K BGPC S D=0 F  S D=$O(BGPT(D)) Q:D'=+D  S C=0,G=0 F  S C=$O(BGPT(D,C)) Q:C'=+C  D
 .I $P(BGPT(D,C),U,1)]"" S BGPC(D,C)=""   ;=D_U_C
 .;I BGPC>0,$P(BGPT(D,C),U,1)="" K BGPT(D,C)
 I $D(BGPC) D
 .;loop through and get rid of all w/o results
 .S D=0 F  S D=$O(BGPT(D)) Q:D=""  D
 ..S C=0 F  S C=$O(BGPT(D,C)) Q:C=""  D
 ...I '$D(BGPC(D,C)) K BGPT(D,C)
 S D=0,G=""
 S D=$O(BGPT(D))
 S C=0,C=$O(BGPT(D,C))
 S X=$P(BGPT(D,C),U,1)
 I $$UP^XLFSTR(X)="COMMENT" Q 1_U_1_U_0_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D)_" (no result) "_X
 I X="" D  Q G
 .S G=""
 .I $P(BGPT(D,C),U,2)="CPT 3046F" S G=1_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D) Q
 .I $P(BGPT(D,C),U,2)="CPT 3047F"!($P(BGPT(D,C),U,2)="CPT 3044F")!($P(BGPT(D,C),U,2)="CPT 3045F") S G=0_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D) Q
 .S G=1_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D)_" (no result)" Q
 S X=$$STRIP^XLFSTR(X," ")  ;strip spaces
 I X[">9" Q 1_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D)_" "_X
 S X=$$STV(X)
 I X="" Q 1_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D)_" (no result) "_X
 I +X>9 Q 1_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D)_" "_X
 Q 0_U_$P(BGPT(D,C),U,2)_" "_$$DATE^BGP9UTL(9999999-D)_" result: "_X
 ;
STV(X) ;EP - strip all characters besides numbers and a "."
 I X="" Q X
 NEW A,B,L
 S L=$L(X)
 F B=1:1:L S A=$E(X,B) Q:A=""  I A'?1N,A'?1"." S X=$$STRIP^XLFSTR(X,A) S B=B-1
 Q X
 ;
BPCPT(P,BDATE,EDATE) ;EP
 NEW S,D,C,E,BGPG,X,Y,G,T
 K BGPG S Y="BGPG(",X=P_"^ALL VISIT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 ;go through and get all cpt codes in the 2 taxonomies and table by date using the lowest value on that day, skip ER visits
 S X=0,G="" F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S V=$P(BGPG(X),U,5)  ;visit ien
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:$$CLINIC^APCLV(V,"C")=30  ;clinic ER
 .Q:'$D(^AUPNVCPT("AD",V))  ;no cpt codes
 .S E=0 F  S E=$O(^AUPNVCPT("AD",V,E)) Q:E'=+E  D
 ..S C=$P($G(^AUPNVCPT(E,0)),U)
 ..I 'C Q
 ..S D=$P($P(^AUPNVSIT(V,0),U),"."),D=(9999999-D)_"."_$P(D,".",2)
 ..I $$ICD^ATXCHK(C,$O(^ATXAX("B","BGP SYSTOLIC BP CPTS",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(S(D)) S(D)=Y
 ...I +S(D)>+Y S S(D)=Y
 ..I $$ICD^ATXCHK(C,$O(^ATXAX("B","BGP DIASTOLIC BP CPTS",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(T(D)) T(D)=Y
 ...I +T(D)>+Y S T(D)=Y
 I '$D(S),'$D(T) Q ""
 S S=$O(S(0)) I S S S=S(S)
 S D=$O(T(0)) I D S D=T(D)
 I S=""!(D="") Q 0_U_S_"/"_$P(D,".")
 I S="3074F",D="3078F" Q 1_U_S_"/"_$P(D,".")
 I S="3074F",D="3079F" Q 1_U_S_"/"_$P(D,".")
 I S="3075F",D="3078F" Q 1_U_S_"/"_$P(D,".")
 I S="3075F",D="3079F" Q 1_U_S_"/"_$P(D,".")
 I S="3076F",D="3078F" Q 1_U_S_"/"_$P(D,".")
 I S="3076F",D="3079F" Q 1_U_S_"/"_$P(D,".")
 I S="3077F",D="3080F" Q 0_U_S_"/"_$P(D,".")
 Q 0_U_S_"/"_$P(D,".")
 ;
TIAFIB(P,BDATE,EDATE,BGPR) ;EP
 NEW A,X,V,BGPG,G,C,T,B,E,BGPX,BGPV,BGPD
 K BGPR,BGPG,BGPX
 S BGPR="",BGPR(0)=""
 S X=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 I '$D(BGPG(1)) S BGPR("DENOM")=0 Q
 ;now go through and get rid of H and CHS
 S T=$O(^ATXAX("B","BGP TIA DXS",0))
 S A=0 F  S A=$O(BGPG(A)) Q:A'=+A  D
 .S V=$P(BGPG(A),U,5)
 .I '$D(^AUPNVSIT(V,0)) K BGPG(A) Q
 .I $P(^AUPNVSIT(V,0),U,3)="C" K BGPG(A) Q
 .I $P(^AUPNVSIT(V,0),U,7)'="H" K BGPG(A) Q
 .S X=0,G=0,E=0,B=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 ..S C=$P($G(^AUPNVPOV(X,0)),U)
 ..Q:C=""
 ..I $$ICD^ATXCHK(C,T,9) S G=1,$P(BGPG(A),U,15)=$$VAL^XBDIQ1(9000010.07,X,.01)
 ..I $$VAL^XBDIQ1(9000010.07,X,.01)="427.31" S E=1
 .I G,E S B=1  ;have both
 .I 'B K BGPG(A)  ;no tia diagnosis
 I '$D(BGPG) S BGPR("DENOM")=0 Q
 ;reorder the diagnoses by visit date
 S A=0 F  S A=$O(BGPG(A)) Q:A'=+A  S V=$P(BGPG(A),U,5),D=$P($P($G(^AUPNVSIT(V,0)),U),"."),BGPX(D,V)=BGPG(A)
 ;now get the first one
 S BGPD=0,BGPC=0 F  S BGPD=$O(BGPX(BGPD)) Q:BGPD'=+BGPD  D
 .S BGPV=0 F  S BGPV=$O(BGPX(BGPD,BGPV)) Q:BGPV'=+BGPV  D
 ..S BGPC=BGPC+1,BGPR(BGPC)=BGPC_") "_$$DATE^BGP9UTL(BGPD)_" "_$P(BGPX(BGPD,BGPV),U,15)_"+427.31"  ;set denominator
 ..S G=$$ANTICOAG^BGP9EO11(P,$$FMADD^XLFDT(BGPD,-365),$$DSCHDATE^APCLV(BGPV),BGPD)  ; any ANTICOAG?
 ..S $P(BGPR(BGPC),U,2)=BGPC_") "_$P(G,U,1)  ;set numerator column
 ..S $P(BGPR(0),U,$P(G,U,2))=$P(BGPR(0),U,$P(G,U,2))+1
 S BGPR("DENOM")=BGPC
 Q
PNEUOX(P,BDATE,EDATE,BGPR) ;EP
 NEW A,B,C,D,E,F,G,BGPG,BGPX,BGPD,BGPV,BGPC
 K BGPG,BGPR
 S BGPR="",BGPR(0)=""
 S X=P_"^ALL DX [BGP CMS PNEUMONIA;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 I '$D(BGPG(1)) S BGPR("DENOM")=0 Q
 ;now go through and get rid of CHS or service category not A, O, S
 S A=0 F  S A=$O(BGPG(A)) Q:A'=+A  D
 .S V=$P(BGPG(A),U,5)
 .I '$D(^AUPNVSIT(V,0)) K BGPG(A)
 .I $P(^AUPNVSIT(V,0),U,3)="C" K BGPG(A)
 .I "AOS"'[$P(^AUPNVSIT(V,0),U,7) K BGPG(A)
 I '$D(BGPG) S BGPR("DENOM")=0 Q  ;got rid of them all
 ;reorder the diagnoses by visit date
 S A=0 F  S A=$O(BGPG(A)) Q:A'=+A  S V=$P(BGPG(A),U,5),D=$P($P($G(^AUPNVSIT(V,0)),U),"."),BGPX(D,V)=BGPG(A)
 ;now get the first one
 S BGPD=0,BGPC=0 F  S BGPD=$O(BGPX(BGPD)) Q:BGPD'=+BGPD  D
 .S BGPV=0 F  S BGPV=$O(BGPX(BGPD,BGPV)) Q:BGPV'=+BGPV  D
 ..S BGPC=BGPC+1,BGPR(BGPC)=BGPC_") "_$$DATE^BGP9UTL(BGPD)_" "_$P(BGPX(BGPD,BGPV),U,2)  ;set denominator
 ..S G=$$OXSAT(BGPV)  ; any o2 saturation on this visit?
 ..S $P(BGPR(BGPC),U,2)=BGPC_") "_$P(G,U,1)  ;set numerator column
 ..S $P(BGPR(0),U,$P(G,U,2))=$P(BGPR(0),U,$P(G,U,2))+1
 ..;now delete out all visits that are <46 days difference and all other visits on the same day
 ..S V=BGPV F  S V=$O(BGPX(BGPD,V)) Q:V'=+V  K BGPX(BGPD,V)
 ..S D=BGPD,V=BGPV F  S D=$O(BGPX(D)) Q:D'=+D  D
 ...S V=0 F  S V=$O(BGPX(D,V)) Q:V'=+V  I $$FMDIFF^XLFDT(D,BGPD)<46 K BGPX(D,V)
 S BGPR("DENOM")=BGPC
 Q
 ;
OXSAT(V) ;was there ox sat at the visit
 ;get all O2 measurements on or after admission date
 NEW BGPD,X,N,E,Y,T,D,C,BGPLT,L,J,BGPG,M,M1
 S BGPG=""
 S BGPD=$P($P(^AUPNVSIT(V,0),U),".")
 ;K BGPG S Y="BGPG(",X=P_"^ALL MEAS O2;DURING "_$$FMTE^XLFDT(BD)_"-"_$$FMTE^XLFDT(ED) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X!(BGPG]"")  I $$VAL^XBDIQ1(9000010.01,X,.01)="O2" S BGPG=$$DATE^BGP9UTL(BGPD)_" MET O2 SAT^1"
 I BGPG]"" Q BGPG
 ;now check for cpts
 S T=$O(^ATXAX("B","BGP CMS ABG CPTS",0))
 S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(BGPG]"")  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S C=$P(^AUPNVCPT(X,0),U)
 .Q:'$$ICD^ATXCHK(C,T,1)
 .S M=$$VAL^XBDIQ1(9000010.18,X,.08)
 .S M1=$$VAL^XBDIQ1(9000010.18,X,.09)
 .I $P(^ICPT(C,0),U)="3028F",(M="1P"!(M="2P")!(M="3P")!(M="4P")!(M="8P")) Q  ;3028f and has modifier
 .I $P(^ICPT(C,0),U)="3028F",(M1="1P"!(M="2P")!(M="3P")!(M="4P")!(M="8P")) Q  ;3028f and has modifier
 .S BGPG=$$DATE^BGP9UTL(BGPD)_" MET CPT ["_$P($$CPT^ICPTCOD(C),U,2)_"]^1"
 .Q
 I BGPG]"" Q BGPG
 ;now check v tran
 S T=$O(^ATXAX("B","BGP CMS ABG CPTS",0))
 S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X!(BGPG]"")  D
 .Q:'$D(^AUPNVTC(X,0))
 .S C=$P(^AUPNVTC(X,0),U,7)
 .Q:C=""
 .Q:'$$ICD^ATXCHK(C,T,1)
 .S BGPG=$$DATE^BGP9UTL(BGPD)_" MET CPT/TRAN ["_$P($$CPT^ICPTCOD(C),U,2)_"]^1"
 .Q
 I BGPG]"" Q BGPG
 ;now check for lab tests
 S T=$O(^ATXAX("B","BGP CMS ABG LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CMS ABG TESTS",0))
 S X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(BGPG]"")  D
 .Q:'$D(^AUPNVLAB(X,0))
 .I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPG=$$DATE^BGP9UTL(BGPD)_" MET "_$$VAL^XBDIQ1(9000010.09,X,.01)_"^1" Q
 .Q:'T
 .S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 .Q:'$$LOINC^BGP9D21(J,T)
 .S BGPG=$$DATE^BGP9UTL(BGPD)_" MET "_$$VAL^XBDIQ1(9000010.09,X,.01)_"^1" Q
 I BGPG]"" Q BGPG
 ;now go get refusals of any of the above
 ;
 S G=$$REFUSAL^BGP9UTL1(P,9999999.07,$O(^AUTTMSR("B","O2",0)),BGPD,BGPD)
 I G Q $$DATE^BGP9UTL(BGPD)_" NOT MET REFUSAL O2 SAT^2"
 ;refusal of lab tests
 S T=$O(^ATXLAB("B","BGP CMS ABG TESTS",0))
 S L=0 F  S L=$O(^ATXLAB(T,21,"B",L)) Q:L'=+L!(BGPG]"")  D
 .S G=$$REFUSAL^BGP9UTL1(P,60,L,BGPD,BGPD)
 .I G S BGPG=$$DATE^BGP9UTL(BGPD)_" NOT MET REFUSAL LAB^2"
 I BGPG]"" Q BGPG
 S G=$$CPTREFT^BGP9UTL1(P,BGPD,BGPD,$O(^ATXAX("B","BGP CMS ABG CPTS",0)))
 I G Q $$DATE^BGP9UTL(BGPD)_" NOT MET REFUSAL CPT^2"
 Q $$DATE^BGP9UTL(BGPD)_" NOT MET; NO ASSMT^3"
 ;
