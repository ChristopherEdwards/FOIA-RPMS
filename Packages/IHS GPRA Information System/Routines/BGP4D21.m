BGP4D21 ; IHS/CMI/LAB - indicator 6 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I5 ;EP
 K BGPN1,BGPN2,BPGN3,BPGN4,BGPVALUE,BGPUP,BGPGFR
 S (BGPN1,BGPN2,BGPN3)=0
 I 'BGPDM1 S BGPSTOP=1 Q
 S BGPUP=$$POSUR(DFN,BGP365,BGPEDATE)
 ;S BGPGFR=$$GFR(DFN,BGP365,BGPEDATE)
 ;S BGPN3=0 I $P(BGPUP,U)=1 S BGPN3=1
 ;S BGPN2=0 I $P(BGPGFR,U) S BGPN2=1
 S BGPN1=0 I $P(BGPUP,U)=1 S BGPN1=1
 S BGPVALUE=$S(BGPDMD1:"UP",1:"")_$S(BGPDMD2:",AD",1:"")_$S(BGPDMD3:",AAD",1:"")_"; "_$$DATE^BGP4UTL($P(BGPUP,U,4))_" "_$P(BGPUP,U,2)_" "_$P(BGPUP,U,3)    ;_"  "_$S(BGPGFR:"GFR",1:"")
 Q
 ;
I6 ;EP
 K BGPN1,BGPN2,BGPN3,BGPN4,BGPVALUE,BGPEYE
 I 'BGPDM1 S BGPSTOP=1 Q  ;don't process this indicator, pt not diabetic
 S BGPEYE=$$EYE(DFN,BGP365,BGPEDATE)
 S BGPN2=0 I $P(BGPEYE,U)=1 S BGPN2=1
 S BGPN3=0 I $P(BGPEYE,U)=2 S BGPN3=1
 S BGPN1=0 I BGPN3!(BGPN2) S BGPN1=1
 S BGPVALUE=$S(BGPDMD1:"UP",1:"")_$S(BGPDMD2:",AD",1:"")_$S(BGPDMD3:",AAD",1:"")_";"_$$DATE^BGP4UTL($P(BGPEYE,U,2))_" "_$P(BGPEYE,U,3)
 K BGPG
 K ^TMP($J,"A")
 Q
I7 ;EP DM AND MH
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9)=0
 I 'BGPDMD2 S BGPSTOP=1 Q
 S BGPN2=$$DEP(DFN,BGP365,BGPEDATE)
 S BGPN1=$$DEPSCR(DFN,BGP365,BGPEDATE)
 S BGPVALUE=""
 Q
I8 ;EP
 K BGPN1,BGPVALUE,BGPN2,BGPN3,BGPN4,BGPN5
 S BGPN1=0
 I '$G(BGPDMD2) S BGPSTOP=1 Q  ;not in denominator so don't bother
 S BGPVALUE=$$DENTSRV(DFN,BGPEDATE)
 S BGPN1=0 I $P(BGPVALUE,U)=1 S BGPN1=1
 I BGPVALUE]"" S BGPVALUE=$$DATE^BGP4UTL($P(BGPVALUE,U,2))_";"_$P(BGPVALUE,U,3)
 Q
I9 ;EP
 K BGPN1,BGPVALUE,BGPN2,BGPN3,BGPN4,BGPN5
 I '$G(BGPACTUP) S BGPSTOP=1 Q  ;not in denominator so don't bother
 S BGPVALUE=$$DENTSRV(DFN,BGPEDATE)
 S BGPN1=0 I $P(BGPVALUE,U)=1 S BGPN1=1
 I BGPVALUE]"" S BGPVALUE=$$DATE^BGP4UTL($P(BGPVALUE,U,2))_";"_$P(BGPVALUE,U,3)
 Q
DENTSRV(P,EDATE) ;
 K BGPG
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 S BGPC="",%=P_"^LAST ADA 0000;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S BGPC=$P(BGPG(1),U)_"^"_$P(BGPG(1),U,2)
 K BGPG
 S %=P_"^LAST ADA 0190;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)),$P(BGPG(1),U)>$P(BGPC,U) S BGPC=$P(BGPG(1),U)_"^"_$P(BGPG(1),U,2)
 K BGPG S %=P_"^LAST EXAM DENTAL;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)),$P(BGPG(1),U)>$P(BGPC,U) S BGPC=$P(BGPG(1),U)_"^"_$P(BGPG(1),U,3)
 I BGPC]"" Q "1^"_BGPC
 Q ""
DEP(P,BDATE,EDATE) ;is there a dx of depression?
 I $G(P)="" Q ""
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST 2 DX [BGP DEPRESSIVE DISORDERS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(2)) Q 1
 S BGPC=0 I $D(BGPG(1)) S BGPC=1
 ;go through BH record file and find up to 2 visits in date range
 S E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(BGPC>1)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(BGPC>1)  D
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(BGPC>1)  S BGPP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'BGPP
 ..S BGPP=$P($G(^AMHPROB(BGPP,0)),U)
 ..I BGPP=14 S BGPC=BGPC+1 Q
 ..I BGPP=15 S BGPC=BGPC+1 Q
 ..I BGPP=18 S BGPC=BGPC+1 Q
 ..I BGPP=24 S BGPC=BGPC+1 Q
 ..I $E(BGPP,1,3)=296 S BGPC=BGPC+1 Q
 ..I $E(BGPP,1,3)=300 S BGPC=BGPC+1 Q
 ..I $E(BGPP,1,3)=309 S BGPC=BGPC+1 Q
 ..I BGPP="301.13" S BGPC=BGPC+1 Q
 ..I BGPP=308.3 S BGPC=BGPC+1 Q
 ..I BGPP="311." S BGPC=BGPC+1 Q
 ..Q
 I BGPC>1 Q 1
 Q ""
DEPSCR(P,BDATE,EDATE) ;is there a dx of depression?
 I $G(P)="" Q ""
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX V79.0;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1
 ;check patient education
 S Y="BGPG("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG(1)) G BHSCR
 S (X,D,E)=0,%="",T="" F  S X=$O(BGPG(X)) Q:X'=+X!(D)  D
 .S T=$P(^AUPNVPED(+$P(BGPG(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I $P(T,"-",1)="DEP"!($P(T,"-",1)="BH")!($P(T,"-",1)="GAD") S D=1
 K BGPG
 I D Q 1
BHSCR ;
 S BGPC="",E=9999999-BDATE,D=9999999-EDATE-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(BGPC)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(BGPC)  D
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(BGPC)  S BGPP=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'BGPP
 ..S BGPP=$P($G(^AMHPROB(BGPP,0)),U)
 ..I BGPP=14.1 S BGPC=BGPC+1 Q
 ..I '$D(^AMHREDU("AD",V)) Q
 ..S Y=0 F  S Y=$O(^AMHREDU("AD",V,Y)) Q:Y'=+Y!(BGPC)  D
 ...S T=$P(^AMHREDU(Y,0),U)
 ...Q:'T
 ...Q:'$D(^AUTTEDT(T,0))
 ...S T=$P(^AUTTEDT(T,0),U,2)
 ...I $P(T,"-",1)="DEP" S BGPC=1
 ...Q
 Q BGPC
EYE(P,BDATE,EDATE) ;EP
 K BGPG S %=P_"^LAST EXAM DIABETIC EYE EXAM;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q "1^"_$P(BGPG(1),U)_"^Diab Eye Ex"
 S BD=BDATE
 S ED=EDATE
 S T=+$$CODEN^ICPTCOD(92250),T1=+$$CODEN^ICPTCOD(92012),T2=+$$CODEN^ICPTCOD(92014),T3=+$$CODEN^ICPTCOD(92015),T4=+$$CODEN^ICPTCOD(92004),T5=+$$CODEN^ICPTCOD(92002)
 I T,$D(^AUPNVCPT("AA",P,T)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="2^"_D_"^CPT 92250"
 ..Q
 .Q
 I T1,$D(^AUPNVCPT("AA",P,T1)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T1,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="2^"_D_"^CPT 92012"
 ..Q
 .Q
 I T2,$D(^AUPNVCPT("AA",P,T2)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T2,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="2^"_D_"^CPT 92014"
 ..Q
 .Q
 I T3,$D(^AUPNVCPT("AA",P,T3)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T3,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="2^"_D_"^CPT 92015"
 ..Q
 .Q
 I T4,$D(^AUPNVCPT("AA",P,T4)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T4,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="2^"_D_"^CPT 92004"
 ..Q
 .Q
 I T5,$D(^AUPNVCPT("AA",P,T5)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T5,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="2^"_D_"^CPT 92002"
 ..Q
 .Q
 K ^TMP($J,"A")
 S A="^TMP($J,""A"","
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,A)
 S X=0,Y=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(^TMP($J,"A",X),U,5),"C") I (R=17!(R=18)!(R=64)!(R="A2")),'$$DNKA($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y Q $S(R="A2":1,1:2)_"^"_D_"^Cl: "_R
 S (X,Y)=0,D="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(^TMP($J,"A",X),U,5),"D") I (R=24!(R=79)!(R="08")),'$$DNKA($P(^TMP($J,"A",X),U,5)) S Y=1,D=$P(^TMP($J,"A",X),U)
 I Y Q "2^"_D_"^Prv: "_R
 ;now check for refusal of diabetic eye exam
 S G=$$REFUSAL^BGP4UTL1(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0)),BDATE,EDATE)
 I $P(G,U)=1 Q "1^"_$P(G,U,2)_"^Refused"
 Q ""
DNKA(V) ;EP - is this a DNKA visit?
 NEW D,N
 S D=$$PRIMPOV^APCLV(V,"C")
 I D=".0860" Q 1
 S N=$$PRIMPOV^APCLV(V,"N")
 I $E(D)="V",N["DNKA" Q 1
 I $E(D)="V",N["DID NOT KEEP APPOINTMENT" Q 1
 I $E(D)="V",N["DID NOT KEEP APPT" Q 1
 Q 0
GFR(P,BDATE,EDATE) ;
 S BGPC=""
 S T=$O(^LAB(60,"B","ESTIMATED GFR",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I T,$P(^AUPNVLAB(X,0),U)=T S BGPC=1 Q
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...S %=$P($G(^LAB(95.3,J,9999999)),U,2)
 ...I %="33914-3" S BGPC=1 Q
 ...S J=$P($G(^LAB(95.3,J,0)),U)_"-"_$P($G(^LAB(95.3,J,0)),U,15)
 ...I J="33914-3" S BGPC=1 Q
 ...Q
 Q BGPC
POSUR(P,BDATE,EDATE) ;EP
 K BGPC
 S BGPC=""
 S %="",E=+$$CODEN^ICPTCOD(82043),%=$$CPTI^BGPDU(P,BDATE,EDATE,E)
 I %]"" I %]"" Q "1^M-CPT^^"_$P(%,U,2)
 S %="",E=+$$CODEN^ICPTCOD(82044),%=$$CPTI^BGPDU(P,BDATE,EDATE,E)
 I %]"" I %]"" Q "1^M-CPT^^"_$P(%,U,2)
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP MICROALBUM LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT MICROALBUMINURIA TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC="1^M^^"_(9999999-D) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S BGPC="1^M^^"_(9999999-D) Q
 ...Q
 I BGPC]"" Q BGPC
 ;now check urine protein taxonomy - last one entered
 K BGPG S %=P_"^LAST LAB [DM AUDIT URINE PROTEIN TAX;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 S (%,R)="" I $D(BGPG(1)) D  Q R_"^"_"U"_"^"_%_"^"_$P(BGPG(1),U)
 .S %=$P(^AUPNVLAB(+$P(BGPG(1),U,4),0),U,4)
 .S R=$S(%="":"",%["+":1,%[">":1,$E(%)="P":1,$E(%)="p":1,$E(%)="c":"",$E(%)="C":"",+%>29:1,1:"")
 S T=$O(^ATXAX("B","BGP URINE PROTEIN LOINC CODES",0))
 S BGPC="",B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BGPC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BGPC]"")  D
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S %=$P(^AUPNVLAB(X,0),U,4)
 ...S R=$S(%="":"",%["+":1,%[">":1,$E(%)="P":1,$E(%)="p":1,$E(%)="c":"",$E(%)="C":"",+%>29:1,1:"")
 ...S BGPC=R_"^U^"_%_"^"_(9999999-D)
 Q BGPC
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
