APCLD512 ; IHS/CMI/LAB - 2005 DIABETES AUDIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in DEPDX
 ;
SETN ;
 S N="" NEW A,G S (A,G)=0 F  S A=$O(APCL(A)) Q:A'=+A!(G)  I $P(^AUPNVLAB(+$P(APCL(A),U,4),0),U,4)]"" S G=A
 S N=$S(G:G,1:1)
 Q
TBTX(P) ;EP
 I '$G(P) Q ""
 NEW APCL,E,X
 K APCL
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"APCL(")
 I E Q ""
 I $D(APCL(1)) Q $P(APCL(1),U,3)_U_$S($P(APCL(1),U,3)["TX COMPLETE":"1 Yes",$P(APCL(1),U,3)["TX INCOMPLETE"!($P(APCL(1),U,3)["TX UNTREATED"):"2 No",1:"4 Unknown")
 N T,Y S T=$O(^ATXAX("B","DM AUDIT TB HEALTH FACTORS",0))
 I 'T Q ""
 N G S G="",X=0 F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X!(G]"")  I $D(^ATXAX(T,21,"B",X)) S G=$P(^AUTTHF(X,0),U)
 I G]"" Q G_U_$S(G["TX COMPLETE":"1 Yes",G["TX INCOMPLETE"!(G["TX UNTREATED"):"2 No",1:"4 Unknown")
 Q ""
CPT(P,BDATE,EDATE,T,F) ;EP return ien of CPT entry if patient had this CPT
 NEW X
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 Q ""
RAD(P,BDATE,EDATE,T,F) ;EP return if a v rad entry in date range
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVRAD("AD",V))
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X!(G)  D
 ...Q:'$D(^AUPNVRAD(X,0))
 ...S Y=$P(^AUPNVRAD(X,0),U) Q:'Y  Q:'$D(^RAMIS(71,Y,0))
 ...S Y=$P($G(^RAMIS(71,Y,0)),U,9) Q:'Y
 ...Q:'$$ICD^ATXCHK(Y,T,1)
 ...S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 Q ""
EKG(P,EDATE,F) ;EP
 I $G(F)="" S F="E"
 S %DT="P",X=EDATE D ^%DT S ED=Y
 NEW APCL,X,%,E,LEKG S LEKG="",%=P_"^LAST DIAGNOSTIC ECG SUMMARY;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL) S LEKG=$P(APCL(1),U)
  K APCL S %=P_"^LAST PROCEDURE 89.51;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_EDATE,E=$$START1^APCLDF(%,"APCL("),E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LEKG>$P(APCL(1),U)
 .S LEKG=$P(APCL(1),U)
 K APCL S %=P_"^LAST PROCEDURE 89.52;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_EDATE,E=$$START1^APCLDF(%,"APCL("),E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LEKG>$P(APCL(1),U)
 .S LEKG=$P(APCL(1),U)
 K APCL S %=P_"^LAST PROCEDURE 89.53;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_EDATE,E=$$START1^APCLDF(%,"APCL("),E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LEKG>$P(APCL(1),U)
 .S LEKG=$P(APCL(1),U)
 ;check CPT codes in year prior to date range
 S T=$O(^ATXAX("B","DM AUDIT EKG CPTS",0))
 K APCL I T S APCL(1)=$$CPT^APCLD512(P,,ED,T,3) D
 .I APCL(1)="" K APCL Q
 .Q:LEKG>$P(APCL(1),U)
 .S LEKG=$P(APCL(1),U)
 K APCL I T S APCL(1)=$$RAD^APCLD512(P,,ED,T,3) D
 .I APCL(1)="" K APCL Q
 .Q:LEKG>$P(APCL(1),U)
 .S LEKG=$P(APCL(1),U)
 Q $S(F="E":$$FMTE^XLFDT(LEKG),1:LEKG)
 ;
REFMED(P,BDATE,EDATE) ;EP
 S T=$O(^ATXAX("B","DM AUDIT INSULIN DRUGS",0))
 S T1=$O(^ATXAX("B","DM AUDIT SULFONYLUREA DRUGS",0))
 S T2=$O(^ATXAX("B","DM AUDIT METFORMIN DRUGS",0))
 S T3=$O(^ATXAX("B","DM AUDIT ACARBOSE DRUGS",0))
 S T4=$O(^ATXAX("B","DM AUDIT GLITAZONE DRUGS",0))
 S G=0
 NEW %DT S X=BDATE,%DT="P" D ^%DT S B=Y
 S X=EDATE,%DT="P" D ^%DT S E=Y
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",APCLPD,50,I)) Q:I'=+I!(G)  D
 .S A=0
 .I $D(^ATXAX(T,21,"B",I)) S A=1
 .I $D(^ATXAX(T1,21,"B",I)) S A=1
 .I $D(^ATXAX(T2,21,"B",I)) S A=1
 .I $D(^ATXAX(T3,21,"B",I)) S A=1
 .I $D(^ATXAX(T4,21,"B",I)) S A=1
 .Q:'A
 .S X=0 F  S X=$O(^AUPNPREF("AA",APCLPD,50,I,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNPREF("AA",APCLPD,50,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) I $P(^AUPNPREF(Y,0),U,7)="R" S G=1
 Q G
INSULIN(P,BDATE,EDATE) ;EP
 NEW X,APCL,E
 S X=P_"^LAST MEDS [DM AUDIT INSULIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "X"
 Q ""
 ;
SULF(P,BDATE,EDATE) ;EP
 NEW X,APCL,E
 S X=P_"^LAST MEDS [DM AUDIT SULFONYLUREA DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "X"
 Q ""
MET(P,BDATE,EDATE) ;EP
 NEW X,APCL,E
 S X=P_"^LAST MEDS [DM AUDIT METFORMIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "X"
 Q ""
 ;
ACAR(P,BDATE,EDATE) ;EP
 NEW X,APCL,E
 S X=P_"^LAST MEDS [DM AUDIT ACARBOSE DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "X"
 Q ""
 ;
TROG(P,BDATE,EDATE) ;EP
 NEW X,APCL,E
 S X=P_"^LAST MEDS [DM AUDIT GLITAZONE DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "X"
 Q ""
TXNAME(V) ;EP
 I $G(V)="" Q ""
 S V=$$TXNAMES(V)
 Q $E(V,1,16)
TXNAMES(Y) ;
 I Y=9 Q "REFUSED"
 I Y=1 Q "DIET"
 I Y=2 Q "INSULIN"
 I Y=3 Q "SULFONYLUREA"
 I Y=4 Q "METFORMIN (GLUCOPHAGE)"
 I Y=5 Q "ACARBOSE OR MIGLITOL"
 I Y=6 Q "GLITAZONE"
 I Y=9 Q "UNKNOWN/REFUSED"
 I Y=23 Q "INSULIN+S'UREA"
 I Y=24 Q "INSULIN+MET"
 I Y=25 Q "INSULIN+ACAR"
 I Y=26 Q "INSULIN+GLITAZONE"
 I Y=34 Q "S'UREA+MET"
 I Y=35 Q "S'UREA+ACAR"
 I Y=36 Q "S'UREA+GLITAZONE"
 I Y=45 Q "MET+ACAR"
 I Y=46 Q "MET+GLITAZONE"
 I Y=56 Q "ACAR+GLITAZONE"
 I Y=234 Q "INS+S'UREA+MET"
 I Y=235 Q "INS+S'UREA+ACAR"
 I Y=236 Q "INS+S'UREA+GLIT"
 I Y=245 Q "INS+MET+ACAR"
 I Y=246 Q "INS+MET+GLITAZONE"
 I Y=256 Q "INS+ACAR+GLITAZONE"
 I Y=345 Q "S'UREA+MET+ACAR"
 I Y=346 Q "S'UREA+MET+GLIT"
 I Y=356 Q "S'UREA+ACAR+GLIT"
 I Y=456 Q "MET+ACAR+GLIT"
 Q ""
 ;
DEPDX(P,BDATE,EDATE) ;EP
 NEW APCL,X
 K APCL
 S (G,X,I)=""
 ;is depression on the problem list?
 S T=$O(^ATXAX("B","DM AUDIT DEPRESSIVE DISORDERS",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .S I=$P($G(^AUPNPROB(X,0)),U)
 .Q:'$$ICD^ATXCHK(I,T,9)
 .;S G="Yes - Problem List "_$P(^ICD9(I,0),U)  ;cmi/anch/maw 9/10/2007 orig line
 .S G="Yes - Problem List "_$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/10/2007 csv
 .Q
 I G]"" Q G
 S (G,X,I)=""
 ;is depression on the BH problem list?
 S T=$O(^ATXAX("B","DM AUDIT DEPRESSIVE DISORDERS",0))
 S X=0 F  S X=$O(^AMHPPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .S I=$P($G(^AMHPPROB(X,0)),U)
 .S I=$P($G(^AMHPROB(I,0)),U,5)
 .Q:I=""
 .S I=+$$CODEN^ICDCODE(I,80)
 .Q:I=""
 .Q:'$$ICD^ATXCHK(I,T,9)
 .;S G="Yes - BH Problem List "_$P(^ICD9(I,0),U)  ;cmi/anch/maw 9/10/2007 orig line
 .S G="Yes - BH Problem List "_$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/10/2007 csv
 .Q
 I G]"" Q G
 ;now check for 2 dxs in past year
 S Y="APCL(",APCLV=""
 S X=P_"^LAST 2 DX [DM AUDIT DEPRESSIVE DISORDERS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(APCL(2)) Q "Yes 2 dxs in PCC"
 S APCL=0 I $D(APCL(1)) S APCL=1
 ;S X=BDATE,%DT="P" D ^%DT S BD=Y
 ;S X=EDATE,%DT="P" D ^%DT S ED=Y
 ;go through BH record file and find up to 2 visits in date range
 S E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(APCL>1)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(APCL>1)  D
 .Q:'$D(^AMHREC(V,0))
 .I $P(^AMHREC(V,0),U,16)]"",APCLV]"",$P(^AMHREC(V,0),U,16)=APCLV Q
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(APCL>1)  S APCLP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'APCLP
 ..S APCLP=$P($G(^AMHPROB(APCLP,0)),U)
 ..I APCLP=14 S APCL=APCL+1 Q
 ..I APCLP=15 S APCL=APCL+1 Q
 ..I APCLP=18 S APCL=APCL+1 Q
 ..I APCLP=24 S APCL=APCL+1 Q
 ..I $E(APCLP,1,3)=296 S APCL=APCL+1 Q
 ..I $E(APCLP,1,3)=300 S APCL=APCL+1 Q
 ..I $E(APCLP,1,3)=309 S APCL=APCL+1 Q
 ..I APCLP="301.13" S APCL=APCL+1 Q
 ..I APCLP=308.3 S APCL=APCL+1 Q
 ..I APCLP="311." S APCL=APCL+1 Q
 ..Q
 I APCL>1 Q "Yes 2 dx PCC/BH"
 Q "No"
DEPSCR(P,BDATE,EDATE) ;EP
 NEW X
 I $G(P)="" Q ""
 K APCL
 S Y="APCL("
 S X=P_"^LAST DX V79.0;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(APCL(1)) Q "Yes V79.0"_" "_$$DATE^APCLD510($P(APCL(1),U))
 ;check patient education
 S Y="APCL("
 S X=P_"^LAST EXAM 36;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(APCL(1)) Q "Yes Exam 36-Dep Screen "_$$DATE^APCLD510($P(APCL(1),U))
 S Y="APCL("
 S X=P_"^ALL EDUC;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I '$D(APCL(1)) G BHSCR
 S (X,E)=0,%="",T="",D="" F  S X=$O(APCL(X)) Q:X'=+X!(D)  D
 .S T=$P(^AUPNVPED(+$P(APCL(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I $P(T,"-",1)="DEP"!($P(T,"-",1)="BH")!($P(T,"-",1)="GAD")!($P(T,"-",1)="SB")!($P(T,"-",1)="PDEP") S D="Yes pt ed "_T_" "_$$DATE^APCLD510($P(APCL(X),U))
 K APCL
 I $P(D,U)]"" Q D
BHSCR ;
 S D=0,APCLC="",E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(APCLC)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(APCLC)  D
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(APCLC)  S APCLP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'APCLP
 ..S APCLP=$P($G(^AMHPROB(APCLP,0)),U)
 ..I APCLP=14.1 S APCLC="Yes BH 14.1 "_$$DATE^APCLD510(9999999-D) Q
 ..I '$D(^AMHREDU("AD",V)) Q
 ..S Y=0 F  S Y=$O(^AMHREDU("AD",V,Y)) Q:Y'=+Y!(APCLC)  D
 ...S T=$P(^AMHREDU(Y,0),U)
 ...Q:'T
 ...Q:'$D(^AUTTEDT(T,0))
 ...S T=$P(^AUTTEDT(T,0),U,2)
 ...I $P(T,"-",1)="DEP"!($P(T,"-",1)="BH")!($P(T,"-",1)="GAD")!($P(T,"-",1)="SB")!($P(T,"-",1)="PDEP") S APCLC="Yes BH pt ed "_T_" "_$$DATE^APCLD510(9999999-D)
 ...Q
 I APCLC]"" Q APCLC
 Q "No"
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
