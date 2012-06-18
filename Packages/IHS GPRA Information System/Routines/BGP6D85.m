BGP6D85 ; IHS/CMI/LAB - measure C ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I28 ;EP
 ;3 denominators, 24 numerators
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7,BGPN8,BGPN9,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9,BGPN10,BGPN11,BGPN12,BGPN13,BGPN14,BGPN15,BGPN16,BGPN17,BGPN18,BGPN19,BGPN20,BGPN21,BGPN22,BGPN23,BGPN24,BGPN25)=0
 S (BGPI1,BGPI2,BGPI3,BGPI4,BGPI5,BGPI6)=0
 S BGPVALUE=""
 K BGPDTAP,BGPOPV,BGPMMR,BGPD,BGPT,BGPPER,BGPTET,BGPM,BGPMU,BGPME,BGPHIB,BGPHEP,BGPVAR
 I 'BGPACTUP S BGPSTOP=1 Q
 I $$AGE^AUPNPAT(DFN,BGPBDATE)'=13 S BGPSTOP=1 Q  ;not 13 at beginning of time period
 I BGPACTUP S BGPD2=1
 I BGPACTCL S BGPD1=1
 ;I BGPACTUP,$$ACTIM(DFN,BGPBDATE,BGPEDATE),BGPTIME=1 S BGPD3=1
 K ^TMP($J,"CPT")
 S BGPVAL=$$MMR(DFN,BGPEDATE)
 I $P(BGPVAL,U,1) S BGPN7=1  ;any hit
 I $P(BGPVAL,U,1)=1 S BGPI3=1
 I $P(BGPVAL,U,1)=3 S BGPN8=1 ;refusal
 I $P(BGPVAL,U,1)=4 S BGPN9=1 ;evid disease, nmi, contraindication
 I $P(BGPVAL,U,1) S BGPVALUE=BGPVALUE_";"_$P(BGPVAL,U,2)
 S BGPVAL=$$HEP^BGP6D35(DFN,BGPEDATE)
 I $P(BGPVAL,U,1) S BGPN13=1  ;any hit
 I $P(BGPVAL,U,1)=1 S BGPI5=1
 I $P(BGPVAL,U,1)=3 S BGPN14=1 ;refusal
 I $P(BGPVAL,U,1)=4 S BGPN15=1 ;evid disease, nmi, contraindication
 I $P(BGPVAL,U,1) S BGPVALUE=BGPVALUE_";"_$P(BGPVAL,U,2)
 S BGPVAL=$$VAR^BGP6D35(DFN,BGPEDATE)
 I $P(BGPVAL,U,1) S BGPN16=1  ;any hit
 I $P(BGPVAL,U,1)=1 S BGPI6=1
 I $P(BGPVAL,U,1)=3 S BGPN17=1 ;refusal
 I $P(BGPVAL,U,1)=4 S BGPN18=1 ;evid disease, nmi, contraindication
 I $P(BGPVAL,U,1) S BGPVALUE=BGPVALUE_";"_$P(BGPVAL,U,2)
 I BGPN7,BGPN13,BGPN16 S BGPN19=1  ;15.1.1
 I BGPN8!(BGPN17)!(BGPN14) S BGPN22=1  ;15.1.2
 I BGPN9!(BGPN18)!(BGPN15) S BGPN23=1  ;15.1.3
 I BGPN1,BGPN4,BGPN7 S BGPN20=1
 I BGPN1,BGPN4,BGPN7,BGPN10,BGPN13 S BGPN21=1  ;4:3:1:3:3
 I BGPI1,BGPI2,BGPI3,BGPI4,BGPI5,BGPI6 S BGPN24=1
 ;I BGPI1,BGPI2,BGPI3 S BGPN25=1
 I BGPI1,BGPI2,BGPI3,BGPI4,BGPI5 S BGPN25=1
 I BGPRTYPE=3,'BGPN19 S BGPVALUE="DID NOT HAVE: " D
 .I 'BGPN7 S BGPVALUE=BGPVALUE_"MMR;"
 .I 'BGPN13 S BGPVALUE=BGPVALUE_"HEP;"
 .I 'BGPN16 S BGPVALUE=BGPVALUE_"VAR"
 S D=""
 I BGPD1 S D="UP;AC"
 E  S D="UP"
 ;I BGPD3 S D=D_";IMM"
 S BGPVALUE=D_"|||"_BGPVALUE
 ;I BGPN19 S BGPVALUE=$P(BGPVALUE,"|||",1)_"|||4:3:1:3:3:1"
 ;I BGPN21,'BGPN19 S $P(BGPVALUE,"|||",2)="4:3:1:3:3"
 K BGPTET,BGPDTAP,BGPDT,BGPTD,BGPPER,BGPDIP,BGPMU,BGPME,BGPMMR,BGPMR,BGPRM,BGPOPV,BGPRUB,BGPHIB,BGPHEB,BGPVAR,BGPI1,BGPI2,BGPI3,BGPI4,BGPI5,BGPI6,BGPVAL
 Q
ACTIM(P,BDATE,EDATE) ;EP is patient active on imm register as of EDATE?
 I '$G(P) Q ""
 I '$D(^BIP(P)) Q ""
 I $P(^BIP(P,0),U,8)="" Q 1
 I $P(^BIP(P,0),U,8)<EDATE Q ""
 I $P(^BIP(P,0),U,8)=EDATE Q ""
 Q 1
GETIMMS(P,EDATE,C,BGPX) ;EP
 K BGPX
 NEW X,Y,I,Z,V
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVIMM(X,0))  ;happens
 .S Y=$P(^AUPNVIMM(X,0),U)
 .Q:'Y  ;happens too
 .S I=$P($G(^AUTTIMM(Y,0)),U,3)  ;get HL7/CVX code
 .F Z=1:1:$L(C,U) I I=$P(C,U,Z) S V=$P(^AUPNVIMM(X,0),U,3) I V S D=$P($P($G(^AUPNVSIT(V,0)),U),".") I D]"",D'>EDATE S BGPX(D)=Y
 .Q
 Q
IMMREF(P,IMM,BD,ED) ;EP
 NEW X,Y,G,D,R
 I 'IMM Q ""
 S (X,G)=0,Y=$O(^AUTTIMM("C",IMM,0))
 I 'Y Q ""
 F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=G+1
 Q G
MMR(P,EDATE) ;EP
 K BGPC,BGPG,BGPX,BGPMMR
 K ^TMP($J,"CPT")
 ;first gather up all cpt codes that relate in any way to dtap and store in ^TMP
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=+Y,$T(@Y)]"" S ^TMP($J,"CPT",9999999-ED,Y)=""
 S BGPMMR=0
 ;get all immunizations
 S C="3^94"
 K BGPX D GETIMMS^BGP6D32(P,EDATE,C,.BGPMMR)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPMMR(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90707!(Y=90710) S BGPMMR(D)=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMMR(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMMR=0,X=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S BGPMMR=BGPMMR+1
 I BGPMMR>1 Q 1_U_"2 MMR"
MR ;see if one M/R, Mumps or R/M
 S (BGPMR,BGPRM,BGPME,BGPMU,BGPRUB)=0
 S C=4
 K BGPX D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPMR(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90708 S BGPMR(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMR(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPMR(X)) Q:X'=+X  S BGPMR=BGPMR+1
RM ;
 S C=38
 K BGPX D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPRM(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90709 S BGPRM(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPRM(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRM(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPRM(X)) Q:X'=+X  S BGPRM=BGPRM+1
ME S C=5
 K BGPX D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPME(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90705 S BGPME(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPME(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPME(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPME(X)) Q:X'=+X  S BGPME=BGPME+1
MU S C=7
 K BGPX D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPMU(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90704 S BGPMU(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMU(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S BGPMU=BGPMU+1
RUB S C=6
 K BGPX D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPRUB(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90706 S BGPRUB(D)=""
  ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRUB(X) Q
 .S Y=X
 ;count them
 S X=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S BGPRUB=BGPRUB+1
 I BGPMR>1,BGPMU>1 Q 1_U_"2 m/r 2 mu"
 I BGPRM>1,BGPME>1 Q 1_U_"2 r/m 2 me"
 I BGPME>1,BGPMU>1,BGPRUB>1 Q 1_U_"2 me 2 mu 2 rub"
 ;now add diagnoses and proc codes for code 2
PVS ;
 K BGPG S %=P_"^ALL DX V06.4;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMMR($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMMR(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMMR=0,X=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S BGPMMR=BGPMMR+1
 I BGPMMR>1 Q 2_U_"2 MMR (DX/IMM)"
 K BGPG S %=P_"^ALL PROCEDURE 99.48;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMMR($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMMR(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMMR=0,X=0 F  S X=$O(BGPMMR(X)) Q:X'=+X  S BGPMMR=BGPMMR+1
 I BGPMMR>1 Q 2_U_"2 MMR (PROC/IMM)"
MEPV ;
 K BGPG S %=P_"^ALL DX V04.2;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPME($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPME(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPME(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPME=0,X=0 F  S X=$O(BGPME(X)) Q:X'=+X  S BGPME=BGPME+1
 K BGPG S %=P_"^ALL PROCEDURE 99.45;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPME($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPME(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPME(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPME=0,X=0 F  S X=$O(BGPME(X)) Q:X'=+X  S BGPME=BGPME+1
MUPV ;
 K BGPG S %=P_"^ALL DX V04.6;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMU($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMU(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMU=0,X=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S BGPMU=BGPMU+1
 K BGPG S %=P_"^ALL PROCEDURE 99.46;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPMU($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPMU(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPMU=0,X=0 F  S X=$O(BGPMU(X)) Q:X'=+X  S BGPMU=BGPMU+1
RUBPV ;
 K BGPG S %=P_"^ALL DX V04.3;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPRUB($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRUB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPRUB=0,X=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S BGPRUB=BGPRUB+1
 K BGPG S %=P_"^ALL PROCEDURE 99.47;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPRUB($P(BGPG(X),U))=""
 S X="",Y="",C=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPRUB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPRUB=0,X=0 F  S X=$O(BGPRUB(X)) Q:X'=+X  S BGPRUB=BGPRUB+1
 ;
 I BGPMR>1,BGPMU>1 Q 2_U_"m/r mu"
 I BGPRM>1,BGPME>1 Q 2_U_"r/m me"
 I BGPME>1,BGPMU>1,BGPRUB>1 Q 2_U_"me mu rub"
REF ;
 ;now get a refusal of MMR if there is one
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",BGPMMR=0,R=""
 F BGPIMM=3,94 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI MMR",1:"ref MMR")
 ;now check refusals in imm pkg
 S R="" F BGPIMM=3,94 S R=$$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q 3_U_"ref mmr"
MMRC K BGPG S %=P_"^LAST DX [BGP MMR CONTRAINDICATIONS;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 4_U_"contra mmr"
 I $$PLTAX^BGP6DU(P,"BGP MMR CONTRAINDICATIONS") Q 4_U_"contra MMR"
REFMR ;
 I BGPMR=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI=""
 .F BGPIMM=4 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPMR=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:3)
 ;now check refusals in imm pkg
 F BGPIMM=4 I $$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPMR=3
REFRM I BGPRM=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=38 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPRM=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:3)
 F BGPIMM=38 I $$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPRM=3
MEX ;
 I BGPME=0 K BGPG S %=P_"^LAST DX [BGP MEASLES EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(") I $D(BGPG(1)) S BGPME=1
 I $$PLTAX^BGP6DU(P,"BGP MEASLES EVIDENCE") S BGPME=1
 I BGPME=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=5 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPME=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:3)
 F BGPIMM=7 I $$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPME=3
MUX ;
 I BGPMU=0 K BGPG S %=P_"^LAST DX [BGP MUMPS EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(") I $D(BGPG(1)) S BGPMU=1
 I $$PLTAX^BGP6DU(P,"BGP MUMPS EVIDENCE") S BGPMU=1
 I BGPMU=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=7 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPMU=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:3)
 ;now check refusals in imm pkg
 F BGPIMM="7" I $$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPMU=3
RUBX ;
 I BGPRUB=0 K BGPG S %=P_"^LAST DX [BGP RUBELLA EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(") I $D(BGPG(1)) S BGPRUB=1
 I $$PLTAX^BGP6DU(P,"BGP RUBELLA EVIDENCE") S BGPRUB=1
 I BGPRUB=0 D
 .S B=$$DOB^AUPNPAT(P),E=EDATE
 .F BGPIMM=6 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S BGPRUB=$S($P(^AUPNPREF(Y,0),U,7)="N":4,1:3)
 F BGPIMM=6 I $$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE) S BGPMU=3
 I BGPMR,BGPMU S X=1 S:BGPMR=3 X=3 S:BGPMU=3 X=3 S:BGPMR=4 X=4 S:BGPMU=4 X=4 Q X_U_"mr & mu"_$S(X=4:" NMI",X=3:" ref",1:"")
 I BGPRM,BGPME S X=1 S:BGPRM=3 X=3 S:BGPME=3 X=3 S:BGPRM=4 X=4 S:BGPME=4 X=4 Q X_U_"RM & ME"_$S(X=4:" NMI",X=3:" ref",1:"")
 I BGPME,BGPMU,BGPRUB S X=1 S:BGPME=3 X=3 S:BGPMU=3 X=3 S:BGPRUB=3 X=3 S:BGPME=4 X=4 S:BGPMU=4 X=4 S:BGPRUB=4 X=4 Q X_U_"ME&MU&RUB"_$S(X=4:" NMI",X=3:" ref",1:"")
 Q ""
90707 ;;
90710 ;;
90708 ;;
90709 ;;
90705 ;;
90704 ;;
90706 ;;
