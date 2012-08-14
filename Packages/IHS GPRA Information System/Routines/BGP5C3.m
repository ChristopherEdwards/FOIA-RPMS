BGP5C3 ; IHS/CMI/LAB - calc CMS indicators 26 Sep 2004 11:28 AM ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
PNEU ;
 ;was there an PNEU pov on this visit
 I '$$PNEUDX(BGPVSIT) Q
 ;
 S BGPX=$P(^DPT(DFN,0),U)_U_$$HRN^AUPNPAT(DFN,DUZ(2))_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,$P($P(BGPVSIT0,U),"."))
 S $P(BGPX,U,5)=$$DATE^BGP5UTL($P($P(BGPVSIT0,U),"."))_"-"_$$DATE^BGP5UTL($$DSCH(BGPVINP))
 S $P(BGPX,U,6)=$$PRIMPOV^APCLV(BGPVSIT,"C")_"  "_$$PRIMPOV^APCLV(BGPVSIT,"N")
 S BGPSKIP=0 K BGPZ
 I $$AGE^AUPNPAT(DFN,$P($P(BGPVSIT0,U),"."))<18 S BGPX="*"_BGPX,BGPSKIP=1,BGPZ(1)="under 18 yrs of age"
 S Z=$$VAL^XBDIQ1(9000010.02,BGPVINP,.06)
 S $P(BGPX,U,7)=Z
 I $$TRANSIN(BGPVINP) S:'BGPSKIP BGPX="*"_BGPX S BGPSKIP=1,BGPZ(2)="transferred in from another hospital"
 S Z=$$VAL^XBDIQ1(9000010.02,BGPVINP,.07)
 S $P(BGPX,U,8)=Z
 Q:$D(^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 1",$P(^DPT(DFN,0),U),DFN,BGPVSIT))
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 1",$P(^DPT(DFN,0),U),DFN,BGPVSIT)=BGPX  ;a hit on list 1
 K BGPZ1 I $D(BGPZ) S X=0 F  S X=$O(BGPZ(X)) Q:X'=+X  S:$G(BGPZ1)]"" BGPZ1=BGPZ1_", " S BGPZ1=$G(BGPZ1)_BGPZ(X)
 I $D(BGPZ1) S BGPZ1="Exclusions: "_BGPZ1 S $P(^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 1",$P(^DPT(DFN,0),U),DFN,BGPVSIT),U,12)=BGPZ1
 S BGPCOUNT("L1",BGPIND)=$G(BGPCOUNT("L1",BGPIND))+1
 ;set up second list after applying exclusions
 Q:BGPSKIP
 S BGPX=$P(^DPT(DFN,0),U)_U_$$HRN^AUPNPAT(DFN,DUZ(2))_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,$P($P(BGPVSIT0,U),"."))
 S $P(BGPX,U,5)=$$DATE^BGP5UTL($P($P(BGPVSIT0,U),"."))_"-"_$$DATE^BGP5UTL($$DSCH(BGPVINP))
 S $P(BGPX,U,6)=$$PRIMPOV^APCLV(BGPVSIT,"C")_"  "_$$PRIMPOV^APCLV(BGPVSIT,"N")
 S $P(BGPX,U,7)=$$VAL^XBDIQ1(9000010.02,BGPVINP,.06)
 S $P(BGPX,U,8)=$$VAL^XBDIQ1(9000010.02,BGPVINP,.07)
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT)=BGPX
 S BGPCOUNT("L2",BGPIND)=$G(BGPCOUNT("L2",BGPIND))+1
 ;get other povs
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,1,"Other Discharge POVs:")=""
 S (X,C)=0 F  S X=$O(^AUPNVPOV("AD",BGPVSIT,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S I=$P(^AUPNVPOV(X,0),U),I=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000010.07,X,.04),N=$$UP^XLFSTR(N)
 .S C=C+1
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,1,"Other Discharge POVs:",C)=I,$E(^(C),9)=N
 .Q
ABIRX ;
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,2,"Recent Antibiotic Rx Status?")=""
 K BGPDATA
 D ABRX1(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH(BGPVINP),.BGPDATA)
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,2,"Recent Antibiotic Rx Status?",X)=BGPDATA(X)
PNEUVAX ;
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,3,"Pneumovax Status?")=""
 K BGPDATA
 D PNEUVAX1(DFN,.BGPDATA)
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,3,"Pneumovax Status?",X)=BGPDATA(X)
ABGPO ;
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,4,"ABG/PO Status?")=""
 K BGPDATA
 D ABGPO1(DFN,$P($P(BGPVSIT0,U),"."),.BGPDATA)
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,4,"ABG/PO Status?",X)=BGPDATA(X)
 D EN^BGP5C12
 Q
ABGPO1(P,BGPA,BGPY) ;
 ;get all O2 measurements on or after admission date
 S BGPC=0
 K BGPG S Y="BGPG(",X=P_"^ALL MEAS O2;DURING "_$$FMTE^XLFDT(BGPA)_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$P(^AUPNVMSR(Y,0),U,4)
 .S BGPC=BGPC+1,BGPY(BGPC)="MEASUREMENT O2:  "_$$DATE^BGP5UTL($P(BGPG(X),U))_"  value: "_N
 .Q
 ;now check for cpts
 S T=$O(^ATXAX("B","BGP CMS ABG CPTS",0))
 S X=0 F  S X=$O(^AUPNVCPT("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S C=$P(^AUPNVCPT(X,0),U)
 .Q:'$$ICD^ATXCHK(C,T,1)
 .S D=$P(^AUPNVCPT(X,0),U,3),D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .S BGPC=BGPC+1,BGPY(BGPC)="CPT: "_$P($$CPT^ICPTCOD(C),U,2)_" "_$P($$CPT^ICPTCOD(C),U,3)_"  "_$$DATE^BGP5UTL(D)
 .Q
 K BGPG S Y="BGPG(",X=P_"^ALL LAB [BGP CMS ABG TESTS;DURING "_$$FMTE^XLFDT(BGPA)_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$P(^AUPNVLAB(Y,0),U,4)
 .S BGPC=BGPC+1,BGPY(BGPC)="LAB:  "_$$VAL^XBDIQ1(9000010.09,Y,.01)_"  "_$$DATE^BGP5UTL($P(BGPG(X),U))_"  value: "_N
 .Q
 Q
ABRX1(P,BGPA,BGPD,BGPY) ;EP
 ;get last aspirin rx before date of adm
 NEW BGPG,BGPC,X,Y,Z,E,BD,ED
 S BGPC=0
 S ED=$$FMADD^XLFDT(BGPA,-1)
 S BD=$$FMADD^XLFDT(BGPA,-365)
 D GETMEDS^BGP5C1(P,BD,ED,"BGP CMS ANTIBIOTIC MEDS","BGP CMS ANTIBIOTIC MEDS NDC","BGP CMS ANTIBIOTICS MEDS CLASS")
 S BD=BGPA
 S ED=$$FMADD^XLFDT(BGPD,30)
 D GETMEDS^BGP5C1(P,BD,ED,"BGP CMS ANTIBIOTIC MEDS","BGP CMS ANTIBIOTIC MEDS NDC","BGP CMS ANTIBIOTICS MEDS CLASS")
 Q
SET ;
 S BGPX(D)=C1_" "_C_"  "_$$DATE^BGP5UTL(D)
 Q
PNEUVAX1(P,BGPY) ;
 K BGPG,BGPX
 S BGPC=0
 S X=P_"^ALL IMM 33" S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:'$D(^AUPNVIMM(Y,0))
 .S Y=$P(^AUPNVIMM(Y,0),U,1)
 .Q:'Y
 .S C=$P($G(^AUTTIMM(Y,0)),U)
 .Q:C=""
 .S D=$P(BGPG(X),U),C1=$P(^AUTTIMM(Y,0),U,3)
 .D SET
 .Q
 K BGPG S X=P_"^ALL IMM 100" S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:'$D(^AUPNVIMM(Y,0))
 .S Y=$P(^AUPNVIMM(Y,0),U,1)
 .Q:'Y
 .S C=$P($G(^AUTTIMM(Y,0)),U)
 .Q:C=""
 .S D=$P(BGPG(X),U),C1=$P(^AUTTIMM(Y,0),U,3)
 .D SET
 .Q
 K BGPG S X=P_"^ALL IMM 109" S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:'$D(^AUPNVIMM(Y,0))
 .S Y=$P(^AUPNVIMM(Y,0),U,1)
 .Q:'Y
 .S C=$P($G(^AUTTIMM(Y,0)),U)
 .Q:C=""
 .S D=$P(BGPG(X),U),C1=$P(^AUTTIMM(Y,0),U,3)
 .D SET
 .Q
 K BGPG S %=P_"^ALL PROCEDURE 99.55",E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:'$D(^AUPNVPRC(Y,0))
 .S Y=$P(^AUPNVPRC(Y,0),U,1)
 .Q:'Y
 .S D=$P(BGPG(X),U)
 .S C=$P($$ICDOP^ICDCODE(Y,D),U,4)
 .Q:C=""
 .S C1=$P($$ICDOP^ICDCODE(Y,D),U,2)
 .D SET
 .Q
 K BGPG S %=P_"^ALL DX V03.82",E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:'$D(^AUPNVPOV(Y,0))
 .S Y=$P(^AUPNVPOV(Y,0),U,1)
 .Q:'Y
 .S D=$P(BGPG(X),U)
 .S C=$P($$ICDDX^ICDCODE(Y,D),U,4)
 .Q:C=""
 .S C1=$P($$ICDDX^ICDCODE(Y,D),U,2)
 .D SET
 .Q
 K BGPG S %=P_"^ALL DX V03.89",E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:'$D(^AUPNVPOV(Y,0))
 .S Y=$P(^AUPNVPOV(Y,0),U,1)
 .Q:'Y
 .S D=$P(BGPG(X),U)
 .S C=$P($$ICDDX^ICDCODE(Y,D),U,4)
 .Q:C=""
 .S C1=$P($$ICDDX^ICDCODE(Y,D),U,2)
 .D SET
 .Q
 K BGPG S %=P_"^ALL DX V06.6",E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:'$D(^AUPNVPOV(Y,0))
 .S Y=$P(^AUPNVPOV(Y,0),U,1)
 .Q:'Y
 .S D=$P(BGPG(X),U)
 .S C=$P($$ICDDX^ICDCODE(Y,D),U,4)
 .Q:C=""
 .S C1=$P($$ICDDX^ICDCODE(Y,D),U,2)
 .D SET
 .Q
 ;now check for cpts
 S X=0 F  S X=$O(^AUPNVCPT("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S C1=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I C1'=90732,C1'=90669 Q
 .S C=$$VAL^XBDIQ1(9000010.18,X,.019)
 .S D=$P(^AUPNVCPT(X,0),U,3)
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .D SET
 .Q
 ;refusals?
 K BGPI F X=33,100,109 S Y=$O(^AUTTIMM("C",X,0)) I Y S BGPI(Y)=""
 S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,X)) Q:X'=+X  D
 .Q:'$D(BGPI(X))  ;not an ACEI
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D
 ..Q:$D(BGPX(Y))  S BGPX(Y)="REFUSAL: "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP5UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 S (X,G)=0,Y=$O(^AUTTIMM("C",33,0)) F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$D(BGPX(D))  S BGPX(D)="REFUSAL: Immunization Package  "_$$DATE^BGP5UTL(D)
 S (X,G)=0,Y=$O(^AUTTIMM("C",100,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$D(BGPX(D))  S BGPX(D)="REFUSAL: Immunization Package  "_$$DATE^BGP5UTL(D)
 S (X,G)=0,Y=$O(^AUTTIMM("C",109,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$D(BGPX(D))  S BGPX(D)="REFUSAL: Immunization Package  "_$$DATE^BGP5UTL(D)
 S D=0 F  S D=$O(BGPX(D)) Q:D'=+D  S BGPC=BGPC+1,BGPY(BGPC)=BGPX(D)
 K BGPX,BGPC,BGPI,X,Y,D
 Q
AMA(H) ;
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=3 Q 1
 Q 0
PNEUDX(V) ;
 S C=$$PRIMPOV^APCLV(V,"I")
 I C="" Q 0 ;no primary dx
 S T=$O(^ATXAX("B","BGP CMS PNEUMONIA DXS",0))
 I $$ICD^ATXCHK(C,T,9) Q 1  ;primary dx of pneumonia
 ;PRIMARY of resp failure and seconday of pneumonia
 S T=$O(^ATXAX("B","BGP CMS SEPTI/RESP FAIL DXS",0))
 I '$$ICD^ATXCHK(C,T,9) Q 0   ;resp failure not primary pov
 S T=$O(^ATXAX("B","BGP CMS PNEUMONIA DXS",0))
 S (X,G)=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S I=$P(^AUPNVPOV(X,0),U)
 .Q:'$$ICD^ATXCHK(I,T,9)
 .S G=1
 .Q
 Q G
EXPIRED(H) ;
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=4!(X=5)!(X=6)!(X=7) Q 1
 Q 0
DSCH(H) ;
 Q $P($P(^AUPNVINP(H,0),U),".")
TRANSIN(H) ;
 S X=$P(^AUPNVINP(H,0),U,7)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=2!(X=3) Q 1
 Q 0
TRANS(H) ;
 S X=$P(^AUPNVINP(H,0),U,6)
 I X="" Q 0
 S X=$P($G(^DG(405.1,X,"IHS")),U,1)
 I X=2 Q 1
 Q 0