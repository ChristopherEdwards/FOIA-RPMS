BGP0D36 ; IHS/CMI/LAB - measure C 06 Nov 2008 2:03 PM ; 28 May 2010  4:23 PM
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
MEN(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPMENI
 ;get all immunizations
 S C="32^108^114^136"
 D GETIMMS^BGP0D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 I $O(BGPX(0)) Q 1_U_"meningococcal"
 ;now get cpts
 S ED=9999999-EDATE-1,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90733!(Y=90734) S BGPMENI(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90733!(Y=90734) S BGPMENI(9999999-$P(ED,"."))=""
 I $D(BGPMENI) Q 1_U_"meningococcal"
 ;check for evidence of desease and contraindications and if yes, then quit
 F BGPZ=32,108,114 S X=$$ANCONT^BGP0D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra meningococcal"
 ;now go to refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=32,108,114,136  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI meni",1:"ref meni")
 ;now check refusals in imm pkg
 F BGPIMM=32,108,114 S R=$$IMMREF^BGP0D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q 3_U_"ref imm pkg meni"
 Q ""
 ;
HPV(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHPV
 ;get all immunizations
 S C="62^118^137"
 D GETIMMS^BGP0D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHPV(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90649!(Z=90650) S BGPHPV(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90649!(Z=90650) S BGPHPV(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHPV(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHPV(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHPV=0,X=0 F  S X=$O(BGPHPV(X)) Q:X'=+X  S BGPHPV=BGPHPV+1
 I BGPHPV>2 Q 1_U_"3 HPV"
 ;check for evidence of desease and contraindications and if yes, then quit
 ;now go to refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=62,118,137  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" HPV"
 ;now check refusals in imm pkg
 F BGPIMM=62,118 S R=$$IMMREF^BGP0D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" HPV"
 F BGPZ=62,118 S X=$$ANCONT^BGP0D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"contra - HPV"
 Q ""
H1N1 ;EP - called from measure
 NEW BGPMONA,BGPH1N1
 S (BGPN1,BGPN2,BGPN3,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8)=0
 S BGPMONA=$$AGE(DFN,2,BGPBDATE)
 I 'BGPACTCL S BGPSTOP=1 Q  ;must be active clinical
 I BGPMONA>5,BGPMONA<60 S BGPD1=1  ;1st denominator
 I BGPAGEB>4,BGPAGEB<10 S BGPD2=1  ;2nd denominator
 I BGPAGEB>9,BGPAGEB<19 S BGPD3=1
 I BGPAGEB>18,BGPAGEB<25 S BGPD4=1
 I BGPAGEB>24,BGPAGEB<65 S BGPD5=1
 I BGPAGEB>64 S BGPD6=1
 I $$ACTPREG(DFN,BGPEDATE) S BGPD7=1
 S T=($E(BGPBDATE,1,3)-3)_$E(BGPBDATE,4,7)
 I $$HIGHRISK(DFN,T,BGPEDATE,BGPAGEB) S BGPD8=1
 I '(BGPD1+BGPD2+BGPD3+BGPD4+BGPD5+BGPD6+BGPD7+BGPD8) S BGPSTOP=1 Q  ;pt in ANY denominator so skip this patient
 S BGPH1N1=$$H1N1VAC(DFN,BGPBDATE,BGPEDATE)  ;will be returned as date of 1st H1N1 dose^date of second H1N1 dose
 I $P(BGPH1N1,U) S BGPN1=1
 I $P(BGPH1N1,U,3) S BGPN2=1
 S BGPVALUE="AC"
 I BGPD7 S BGPVALUE=BGPVALUE_";PREG"
 I BGPD8 S BGPVALUE=BGPVALUE_";HIGHRISK"
 S BGPVALUE=BGPVALUE_"|||"
 I BGPN1!(BGPN2) S BGPVALUE=BGPVALUE_$S($P(BGPH1N1,U,1):$$DATE^BGP0UTL($P(BGPH1N1,U,1))_" "_$P(BGPH1N1,U,2),1:"")
 I $P(BGPH1N1,U,3) S BGPVALUE=BGPVALUE_"; "_$$DATE^BGP0UTL($P(BGPH1N1,U,3))_" "_$P(BGPH1N1,U,4)  ;:"2 doses",$P(BGPH1N1,U,1):"1 dose",1:"")_" "_$$DATE^BGP0UTL($P(BGPH1N1,U))_" "_$$DATE^BGP0UTL($P(BGPH1N1,U,2))
 Q
H1N1VAC(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 NEW C,X,Y,Z,T,L,M,D,V,ED,BD
 S T=$O(^ATXAX("B","SURVEILLANCE H1N1 CVX CODES",0))
 S C=0,X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  S Y=$P($G(^AUPNVIMM(X,0)),U) D
 .Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Z=$P(^AUTTIMM(Y,0),U,3)
 .Q:'$D(^ATXAX(T,21,"B",Z))
 .S D=$$VD^APCLV($P(^AUPNVIMM(X,0),U,3))
 .Q:D<BDATE
 .Q:D>EDATE
 .S C=C+1,M(D)=$$VAL^XBDIQ1(9000010.11,X,.01)
 .Q
 S T=$O(^ATXAX("B","SURVEILLANCE CPT H1N1",0))
 ;GET ALL CPT CODES AND SET BY DATE
 S ED=(9999999-EDATE),BD=9999999-BDATE
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) S C=C+1,M($$VD^APCLV(V))=$$VAL^XBDIQ1(9000010.18,X,.01)
 ...Q
 ..Q
 .Q
 I '$D(M) Q ""
 S (X,D,F,S)=""
 F  S D=$O(M(D)) Q:D'=+D  D
 .I F="" S F=D_U_M(D) Q  ;first one
 .I $$FMDIFF^XLFDT(D,F)<21 Q
 .S S=D_U_M(D)
 .Q
 Q F_U_S
AGE(P,BGPZ,BGPDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - APCLZ  (opt) APCLZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - APCLDT (opt) Date on which Age should be calculated.
 ;
 N BGPDOB,X,X1,X2  S:$G(APCLZ)="" APCLZ=2
 Q:'$G(P) ""
 I '$D(^DPT(P,0)) Q ""
 S BGPDOB=$P(^DPT(P,0),U,3)
 Q:'BGPDOB ""
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(BGPDT) BGPDT=DT
 Q:BGPDT<BGPDOB ""
 ;
 ;---> Age in Years.
 N BGPAGEY,BGPAGEM,BGPD1,BGPD2,BGPM1,BGPM2,BGPY1,BGPY2
 S BGPM1=$E(BGPDOB,4,7),BGPM2=$E(BGPDT,4,7)
 S BGPY1=$E(BGPDOB,1,3),BGPY2=$E(BGPDT,1,3)
 S BGPAGEY=BGPY2-BGPY1 S:BGPM2<BGPM1 BGPAGEY=BGPAGEY-1
 S:BGPAGEY<1 BGPAGEY="<1"
 Q:BGPZ=1 BGPAGEY
 ;
 ;---> Age in Months.
 S BGPD1=$E(BGPM1,3,4),BGPM1=$E(BGPM1,1,2)
 S BGPD2=$E(BGPM2,3,4),BGPM2=$E(BGPM2,1,2)
 S BGPAGEM=12*BGPAGEY
 I BGPM2=BGPM1&(BGPD2<BGPD1) S BGPAGEM=BGPAGEM+12
 I BGPM2>BGPM1 S BGPAGEM=BGPAGEM+BGPM2-BGPM1
 I BGPM2<BGPM1 S BGPAGEM=BGPAGEM+BGPM2+(12-BGPM1)
 S:BGPD2<BGPD1 BGPAGEM=BGPAGEM-1
 Q:BGPZ=2 BGPAGEM
 ;
 ;---> Age in Days.
 S X1=BGPDT,X2=BGPDOB
 D ^%DTC
 Q X
 ;
 ;
ACTPREG(P,ED) ;EP
 I $P(^DPT(P,0),U,2)'="F" Q ""
 NEW T,X,Y,Q,BD,APCL,LPD,%,G
 S BD=3091001  ;MEASURE IN H1N1 YEAR ONLY ****LORI CHANGE TO 309
 S G=""
 S T=$O(^ATXAX("B","SURVEILLANCE H1N1 PREGNANCY DX",0))
 D ALLV^APCLAPIU(P,BD,ED,"APCL")
 I '$D(APCL) Q ""
 ;now get rid of non-amb, non-H visits, and those whose primary dx is not pregnancy
 NEW APCLJ
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AOSHI"'[$P(^AUPNVSIT(V,0),U,7)
 .S (G,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S G=1
 ..S APCLJ(9999999-$P(APCL(X),U,1))=$P(APCL(X),U,1)  ;set by date to eliminate 2 on same day
 .Q
 S LPD=$O(APCLJ(0))  ;get date of latest
 I LPD="" Q ""
 S LPD=9999999-LPD  ;date of prenatal dx, find miscarriage, abortion or delivery between this date and ED
 NEW APCLF
 S APCLF=""
 ;check abortion / misc dxs
 K APCL S X=P_"^LAST DX [BGP MISCARRIAGE/ABORTION DXS;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 K APCL S X=P_"^LAST PROC [BGP ABORTION PROCEDURES;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT ABORTION","D")
 I %]"" Q ""
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT MISCARRIAGE","D")
 I %]"" Q ""
 ;K APCL S X=P_"^LAST DX [SURVEILLANCE H1N1 DELIVERY DX;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 ;I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;K APCL S X=P_"^LAST PROC [SURVEILLANCE H1N1 DEL PROC;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 ;I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 ;S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"SURVEILLANCE H1N1 DELIVERY CPT","D")
 ;I %]"" Q ""
 Q 1
HIGHRISK(P,BDATE,EDATE,AGEB) ;
 I AGEB<25 Q ""
 I AGEB>64 Q ""
 ;get all povs that meet definition in past 3 years, remove those on same date and count for 2
 NEW BGPDX,BGPG,CNT
 K BGPG
 S Y="BGPG(",CNT=0
 S X=P_"^ALL DX [BGP H1N1 HIGH RISK;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 ;now reorder by date of diagnosis and eliminate all on same date
 I '$D(BGPG) G PROB  ;no diagnoses
 S B=0,X=0 F  S X=$O(BGPG(X)) Q:X'=+X!(CNT=2)  D
 .;get date
 .S D=$P(BGPG(X),U,1)
 .Q:$D(BGPDX(D))
 .S BGPDX(D)="",CNT=CNT+1 I CNT=2 S BGPD=D
 .Q
 I CNT>1 Q 1  ;is high risk
PROB ;
 S T=$O(^ATXAX("B","BGP H1N1 HIGH RISK",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .Q:$P(^AUPNPROB(X,0),U,8)<BDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S G=$P(^AUPNPROB(X,0),U,8)
 .Q
 Q G
