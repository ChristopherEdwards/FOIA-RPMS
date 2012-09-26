BGP2D31 ; IHS/CMI/LAB - measure C 01 Jun 2012 12:51 PM ; 01 Nov 2011  6:34 PM
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
II ;EP
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7,BGPN8,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9,BGPHOSP,BGPSEV,BGPNER)=0
 I 'BGPACTUP S BGPSTOP=1 Q
 I BGPACTUP S BGPD1=1
 I BGPACTCL S BGPD2=1
 I 'BGPD2 S BGPSTOP=1 Q
 S BGPN1=$$V2ASTH(DFN,BGPBDATE,BGPEDATE)
 I BGPN1 S BGPHOSP=$$HOSP(DFN,BGPBDATE,BGPEDATE) I BGPHOSP S BGPN2=1
 S BGPNER=$$ERURG(DFN,BGPBDATE,BGPEDATE)
 I $P(BGPNER,U,1) S BGPN3=1
 S BGPSEV=$$SEV(DFN,$$DOB^AUPNPAT(DFN),BGPEDATE)
 I BGPSEV=1 S BGPN4=1
 I BGPSEV=2 S BGPN5=1
 I BGPSEV=3 S BGPN6=1
 I BGPSEV=4 S BGPN7=1
 I BGPSEV="" S BGPN8=1
 S Z=$P(BGPN1,U,2)
 S BGPVALUE=$S(BGPD2:"AC",1:"")_"|||" I BGPN1 S BGPVALUE=BGPVALUE_Z_$S(BGPHOSP:"; Hospital: "_$$DATE^BGP2UTL($P(BGPHOSP,U,2)),1:"")_$S(BGPN3:"; "_$P(BGPNER,U,2),1:"")_$S(BGPSEV:"; Severity: "_BGPSEV,1:"")
 K X,Y,Z,%,A,B,C,D,E,H,BDATE,EDATE,P,V,S,F,T
 Q
ERURG(P,BDATE,EDATE) ;EP
 NEW A,E,T,X,G,V,D
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 I 'T Q ""
 S X=0,G=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"AORS"'[$P(^AUPNVSIT(V,0),U,7)
 .S C=$$CLINIC^APCLV(V,"C")
 .I C'=30,C'=80 Q  ;er and urgent only
 .S %=$$PRIMPOV^APCLV(V,"I") I $$ICD^ATXCHK(%,T,9) S G=1,H=$P($P(^AUPNVSIT(V,0),U),".")
 .Q
 I G Q 1_U_"ER/UC:"_$$DATE^BGP1UTL(H)
 Q ""
V2ASTH(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 I 'T Q ""
 S X=0,G=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>1)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXCHK(%,T,9) S D=1
 .Q:'D
 .S $P(G,U)=$P(G,U)+1,$P(G,U,2)=$P(G,U,2)_$S(G>1:", ",1:" ")_$$DATE^BGP2UTL($P(^TMP($J,"A",X),U))
 .Q
 I G>1 Q 1_U_"2 Dx PCC:"_$P(G,U,2)
 ;
 NEW S,A,B,T,X,G,V,Y
 S G=""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;if added to pl after end of time period
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .Q:$P(^AUPNPROB(X,0),U,15)=""
 .Q:$P(^AUPNPROB(X,0),U,15)<2
 .S G=1_U_"Severity "_$P(^AUPNPROB(X,0),U,15)_" on PL"
 .Q
 I G Q G
 S EDATE1=9999999-EDATE-1
 S D=$O(^AUPNVAST("AS",P,EDATE1))
 I 'D Q ""
 ;I D>(9999999-BDATE) Q ""
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AS",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST Q ""
 S S=^AUPNVAST("AS",P,D,LAST)
 I S>1 Q 1_U_"Severity "_S_" on visit "_$$DATE^BGP2UTL(9999999-D)
 Q ""
 ;
SEV(P,BDATE,EDATE) ;EP
 NEW S,A,B,T,X,G,V,Y
 S G=""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S X=0,G="" F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;if added to pl after end of time period
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .Q:$P(^AUPNPROB(X,0),U,15)=""
 .S G(9999999-$P(^AUPNPROB(X,0),U,3))=$P(^AUPNPROB(X,0),U,15)
 .Q
 S X=$O(G(0)) I X Q G(X)
 S EDATE1=9999999-EDATE-1
 S D=$O(^AUPNVAST("AS",P,EDATE1))
 I 'D Q ""
 ;I D>(9999999-BDATE) Q ""
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AS",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST Q ""
 S S=^AUPNVAST("AS",P,D,LAST)
 Q S
 ;I S>1 Q 1_U_"Severity "_S_" on visit "_$$DATE^BGP2UTL(9999999-D)
 ;Q ""
LAST(P,BDATE,EDATE) ;EP last asthma dx
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX [BGP ASTHMA DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q $$DATE^BGP2UTL($P(BGPG(1),U))_" "_$P(BGPG(1),U,2)
 Q ""
HOSP(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 I 'T Q ""
 S (X,G,H)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:$P(^AUPNVSIT(V,0),U,7)'="H"
 .S %=$$PRIMPOV^APCLV(V,"I") I $$ICD^ATXCHK(%,T,9) S G=1,H=$P($P(^AUPNVSIT(V,0),U),".")
 .Q
 Q G_"^"_H
BI() ;
 Q $S($O(^AUTTIMM(0))>100:1,1:0)
PNEU(P,BDATE,EDATE,FORE) ;EP
 K BGPG
 S BGPLPNU=""
 S BD=BDATE
 S ED=EDATE
 S EDATE=$$FMTE^XLFDT(EDATE)
 S BDATE=$$FMTE^XLFDT(BDATE)
 S X=P_"^LAST IMM "_$S($$BI:33,1:19)_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)) S BGPLPNU=$P(BGPG(1),U)_U_"Imm 33"
 S X=P_"^LAST IMM 100;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 100"
 S X=P_"^LAST IMM 109;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 109"
 S X=P_"^LAST IMM 133;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 133"
 K BGPG S BGPG(1)=$$LASTPRC^BGP2UTL1(P,"BGP PNEUMO IZ PROCEDURES",BDATE,EDATE)
 I BGPG(1)]"",$P(BGPLPNU,U,1)<$P(BGPG(1),U,3) S BGPLPNU=$P(BGPG(1),U,1)_U_"Proc "_$P(BGPG(1),U,2)
 K BGPG S %=P_"^LAST DX [BGP PNEUMO IZ DXS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"POV "_$P(BGPG(1),U,2)
 S %=$$CPT^BGP2DU(P,BD,ED,$O(^ATXAX("B","BGP PNEUMO IZ CPTS",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)
 S %=$$TRAN^BGP2DU(P,BD,ED,$O(^ATXAX("B","BGP PNEUMO IZ CPTS",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)
 I BGPLPNU]"" Q BGPLPNU_U_1
 ;NOW CHECK FOR CONTRAINDICATION (NEW IN 8.0)
 F BGPZ=33,100,109,133 S X=$$ANCONT(P,BGPZ,ED) Q:X]""
 I X]"" Q X_U_3
 ;NMI Refusal
 S G=$$NMIREF^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",33,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",100,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",109,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",133,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 I $G(FORE) Q ""
 S G=$$REFUSAL^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",33,0)),$$FMTE^XLFDT($$FMADD^XLFDT(ED,-365)),EDATE)
 I $P(G,U)=1 I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_" Refused"_U_2
 S G=$$REFUSAL^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",100,0)),$$FMTE^XLFDT($$FMADD^XLFDT(ED,-365)),EDATE)
 I $P(G,U)=1 I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_" Refused"_U_2
 S G=$$REFUSAL^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",109,0)),$$FMTE^XLFDT($$FMADD^XLFDT(ED,-365)),EDATE)
 I $P(G,U)=1 I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_" Refused"_U_2
 S G=$$REFUSAL^BGP2UTL1(P,9999999.14,$O(^AUTTIMM("C",133,0)),$$FMTE^XLFDT($$FMADD^XLFDT(ED,-365)),EDATE)
 I $P(G,U)=1 I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_" Refused"_U_2
 S BGPRBEG=$$FMADD^XLFDT(ED,-365)
 S T=$$CPTREFT^BGP2UTL1(P,BGPRBEG,ED,$O(^ATXAX("B","BGP PNEUMO IZ CPTS",0)))
 I T S T=$P(T,U,2)_"^Refused CPT "_$P(T,U,4)_U_2 Q T
 S (X,G)=0,Y=$O(^AUTTIMM("C",33,0)) F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BGPRBEG
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=1
 I G I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_"Refusal Imm pkg"_U_2
 S (X,G)=0,Y=$O(^AUTTIMM("C",100,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BGPRBEG
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=1
 I G I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_"Refusal Imm pkg"_U_2
 S (X,G)=0,Y=$O(^AUTTIMM("C",133,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BGPRBEG
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=1
 I G I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_"Refusal Imm pkg"_U_2
 S (X,G)=0,Y=$O(^AUTTIMM("C",109,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:$P(^BIPC(X,0),U,4)<BGPRBEG
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=1
 I G I $P(BGPLPNU,U,1)<$P(G,U,2) S BGPLPNU=$P(G,U,2)_U_"Refusal Imm pkg"_U_2
 Q BGPLPNU
 ;
ANCONT(P,C,ED) ;EP - ANALPHYLAXIS CONTRAINDICATION
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contra Anaphylaxis"
 Q G
ANNECONT(P,C,ED) ;EP - ANALPHYLAXIS/NEOMYCIN CONTRAINDICATION
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contra Anaphylaxis"
 .I $P(^BICONT(R,0),U,1)="Neomycin Allergy" S G=D_U_"Contra: Neomycin Allergy"
 Q G
MMRCONT(P,C,ED) ;EP - ANApHYLAXIS/NEOMYCIN/IMMUNE CONTRAINDICATION
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contra Anaphylaxis"
 .I $P(^BICONT(R,0),U,1)="Neomycin Allergy" S G=D_U_"Contra: Neomycin Allergy"
 .I $P(^BICONT(R,0),U,1)="Immune Deficiency" S G=D_U_"Contra: Immune Deficiency"
 .I $P(^BICONT(R,0),U,1)["Immune Deficient" S G=D_U_"Contra: Immune Deficient"
 Q G
ANIMCONT(P,C,ED) ;EP - ANApHYLAXIS/IMMUNE CONTRAINDICATION
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contra Anaphylaxis"
 .I $P(^BICONT(R,0),U,1)="Immune Deficiency" S G=D_U_"Contra: Immune Deficiency"
 .I $P(^BICONT(R,0),U,1)["Immune Deficient" S G=D_U_"Contra: Immune Deficient"
 Q G
ANEGCONT(P,C,ED) ;EP - ANALPHYLAXIS/EGG CONTRAINDICATION
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contra Anaphylaxis"
 .I $P(^BICONT(R,0),U,1)="Egg Allergy" S G=D_U_"Contra: Egg Allergy"
 Q G
