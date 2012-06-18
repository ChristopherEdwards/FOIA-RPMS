BGP0D722 ; IHS/CMI/LAB - measure AHR.A ;
 ;;10.0;IHS CLINICAL REPORTING;**1**;JUN 18, 2010
 ;
 ;
ACEALG(P,BDATE,EDATE) ;EP
 K BGPG
 D ACEIALG1^BGP0C11(P,EDATE,.BGPG)
 S X=$O(BGPG(X))
 I 'X Q ""
 Q 1_U_"ace/arb alleg: "_BGPG(X)
 ;
ACECONT(P,BDATE,EDATE,NMIB,NMIE,RPBD) ;EP ACEI contra
 NEW ED,BD,BGPG,BGPC,X,Y,Z,N,E
 S RPBD=$G(RPBD)
 K BGPG S Y="BGPG(",X=P_"^LAST DX [BGP CMS AORTIC STENOSIS DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"ACEI contra POV:  "_$$DATE^BGP0UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 ;
 ;nmi in refusal
 S BGPG=""
 S T=$O(^ATXAX("B","BGP HEDIS ACEI MEDS",0))
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not an ACEI
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D I Y<NMIB Q
 ..I Y>NMIE Q
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S BGPG=1_U_"NMI ACEI: "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP0UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I BGPG Q BGPG
 ;nmi
 S BGPG=""
 S T=$O(^ATXAX("B","BGP HEDIS ARB MEDS",0))
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D I Y<NMIB Q
 ..I Y>NMIE Q
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S BGPG=1_U_"NMI ARB: "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP0UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I BGPG Q BGPG
 ;PREGNANCY
 S X=$$PREG^BGP0D7(P,$S($G(RPBD):RPBD,1:NMIB),NMIE) I X Q 1_U_"contra ACEI - pregnant"
 ;breastfeeding
 K BGPG S Y="BGPG(",X=P_"^LAST DX V24.1;DURING "_$$FMTE^XLFDT($S(RPBD:RPBD,1:NMIB))_"-"_$$FMTE^XLFDT(NMIE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"ACEI contra POV:  "_$$DATE^BGP0UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 K BGPG
 S Y="BGPG("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT($S(RPBD:RPBD,1:NMIB))_"-"_$$FMTE^XLFDT(NMIE) S E=$$START1^APCLDF(X,Y)
 S (X,D)=0,%="",T="" F  S X=$O(BGPG(X)) Q:X'=+X!(%]"")  D
 .S T=$P(^AUPNVPED(+$P(BGPG(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I T="BF-BC" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-BP" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-CS" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-EQ" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-FU" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-HC" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-ON" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-M" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-MK" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-N" S %=T_U_$P(BGPG(X),U) Q
 I %]"" Q 1_U_"ACEI contra - "_%
 Q ""
ACERX(P,BDATE,EDATE,BGPNDAYS) ;EP
 K BGPMEDS1
 S K=0,R=""
 D GETMEDS^BGP0UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T=$O(^ATXAX("B","BGP HEDIS ACEI MEDS",0))
 S T1=$O(^ATXAX("B","BGP HEDIS ACEI NDC",0))
 S T2=$O(^ATXAX("B","BGP HEDIS ARB MEDS",0))
 S T3=$O(^ATXAX("B","BGP HEDIS ARB NDC",0))
 S X=0 F  S X=$O(BGPMEDS1(X)) Q:X'=+X  S Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1 G ACE1
 .I T2,$D(^ATXAX(T2,21,"B",D)) S G=1 G ACE1
 .S N=$P($G(^PSDRUG(D,2)),U,4)
 .I N]"",T1,$D(^ATXAX(T1,21,"B",N)) S G=1
 .I N]"",T3,$D(^ATXAX(T3,21,"B",N)) S G=1
 .Q:'G
ACE1 .;
 .S J=$P(^AUPNVMED(Y,0),U,8)
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .S S=$$DAYS^BGP0D82(Y,V,EDATE)
 .S K=S+K
 .I R]"" S R=R_";"
 .S R=R_$$DATE^BGP0UTL($P($P(^AUPNVSIT(V,0),U),"."))_"("_S_")"
 I K>BGPNDAYS Q 1_U_" total days ACE/ARB: "_K
ACEPRIO ;now add in any before
 K BGPMEDS1
 D GETMEDS^BGP0UTL2(P,$$FMADD^XLFDT(BDATE,-365),BDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S X=0 F  S X=$O(BGPMEDS1(X)) Q:X'=+X  S Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1 G ACE2
 .I T2,$D(^ATXAX(T2,21,"B",D)) S G=1 G ACE2
 .S N=$P($G(^PSDRUG(D,2)),U,4)
 .I N]"",T1,$D(^ATXAX(T1,21,"B",N)) S G=1 G ACE2
 .I N]"",T3,$D(^ATXAX(T3,21,"B",N)) S G=1
 .Q:'G
ACE2 .;
 .S J=$P(^AUPNVMED(Y,0),U,8)
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .;S IS DAYS SUPPLY, J IS DATE DISCONTINUED
 .Q:J]""
 .S D=$$FMDIFF^XLFDT(BDATE,$P($P(^AUPNVSIT(V,0),U),"."))
 .S S=$P(^AUPNVMED(Y,0),U,7)
 .S S=S-D  ;subtract the number of days used
 .S:S<0 S=0
 .S K=S+K  ;TOTAL DAYS SUPPLY
 .I R]"" S R=R_";"
 .S R=R_$$DATE^BGP0UTL($P($P(^AUPNVSIT(V,0),U),"."))_"("_S_")"
 I K>BGPNDAYS Q 1_U_" total ACE/ARB: "_K
 Q 0_U_R_" total days ACE/ARB: "_K
 ;
ACEREF(P,BDATE,EDATE) ;EP
 ;did patient have a refusal in time period?
 S T=$O(^ATXAX("B","BGP HEDIS ACEI MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented more than 1 year before edate
 ..I Y>EDATE Q
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="R"
 ...S G=1_U_"ACEI Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 I G Q G
 S T=$O(^ATXAX("B","BGP HEDIS ARB MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q
 ..I Y>EDATE Q  ;documented after end date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...;Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S G=1_U_"ARB Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 Q G
STATALG(P,BDATE,EDATE,RPB,RPE) ;EP
 ;get all visits and check for ALT/AST tests on 2 consecutive visits
 NEW BGPG,BGPY,Y,X,N,Z,BGPC
 S BGPC=""
 K BGPG,BGPY S Y="BGPG(",X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04) S N=$$UP^XLFSTR(N)
 .I N["STATIN"!(N["STATINS") S BGPC=1_U_"Alg Statin POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.9" S BGPC=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.9]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.9" S BGPC=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.9]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.9" S BGPC=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.9]  "_N Q
 .Q
 I BGPC Q BGPC
 K BGPG S BGPC=0 S Y="BGPG(",X=P_"^ALL DX V14.8;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["STATIN"!(N["STATINS") S BGPC=BGPC+1,BGPY(BGPC)=1_U_"alg statin POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 I BGPC Q BGPC
 ;problem list
 S BGPC=0
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .I Y="V14.8"!($$ICD^ATXCHK(I,T,9)),N["STATIN"!(N["STATINS") S BGPC=1_U_"alg statin PROBLEM LIST:  "_$$DATE^BGP0UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "_N
 .Q
 I BGPC Q BGPC
 ;now check allergy tracking
 S BGPC=0
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["STATIN" S BGPC=1_U_" alg statin ALLERGY TRACKING:  "_$$DATE^BGP0UTL($P(^GMR(120.8,X,0),U,4))_"  "_N
 I BGPC Q BGPC
 ;now go into the report period items
 K BGPG S Y="BGPG(",X=P_"^LAST DX [BGP MYOPATHY/MYALGIA;DURING "_$$FMTE^XLFDT(RPB)_"-"_$$FMTE^XLFDT(RPE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"Statin allergy POV:  "_$$DATE^BGP0UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 ;creatine lab value > 10,000 or 10x uln
 S BGPG=""
 S T=$O(^ATXAX("B","BGP CREATINE KINASE LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CREATINE KINASE TAX",0))
 S B=9999999-RPB,E=9999999-RPE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPG)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) I $$RESCK(X) S BGPG=1_U_"adr statin creat kinase of "_$P(^AUPNVLAB(X,0),U,4)_" on "_$$DATE^BGP0UTL((9999999-D)) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BGP0D2(J,T)
 ...I $$RESCK(X) S BGPG=1_U_"adr statin creat kinase of "_$P(^AUPNVLAB(X,0),U,4)_" on "_$$DATE^BGP0UTL((9999999-D)) Q
 ...Q
 I BGPG Q BGPG
 S T=$O(^ATXAX("B","BGP ALT LOINC",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT ALT TAX",0))
 S T2=$O(^ATXAX("B","BGP AST LOINC",0))
 S BGPLT2=$O(^ATXLAB("B","DM AUDIT AST TAX",0))
 S B=9999999-$$FMADD^XLFDT(EDATE,-365),E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPG)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC((9999999-D))=X_U_$P(^AUPNVLAB(X,0),U,4)_U_$P($G(^AUPNVLAB(X,11)),U,5) Q
 ...I BGPLT2,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT2,21,"B",$P(^AUPNVLAB(X,0),U))) S BGPC=BGPC+1,BGPC((9999999-D))=X_U_$P(^AUPNVLAB(X,0),U,4)_U_$P($G(^AUPNVLAB(X,11)),U,5) Q
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...I '$$LOINC^BGP0D2(J,T),'$$LOINC^BGP0D2(J,T2)
 ...S BGPC=BGPC+1,BGPC((9999999-D))=X_U_$P(^AUPNVLAB(X,0),U,4)_U_$P($G(^AUPNVLAB(X,11)),U,5) Q
 ...Q
 ;are they 2 consecutive
 S BGPG=""
 S X=0 F  S X=$O(BGPC(X)) Q:X'=+X!(BGPG)  D
 .Q:'$$RESAL(BGPC(X))
 .;is next one also bad?
 .S Y=$O(BGPC(X))
 .Q:Y=""  ;no next one
 .I $$RESAL(BGPC(Y)) S BGPG=1_U_"adr Statin - AST/ALT" Q
 .Q
 I BGPG Q BGPG
 Q 0
 ;
RESAL(Y) ;
 NEW V,ULN
 S V=+$P(Y,U,2),ULN=$P(Y,U,3)
 I ULN="" Q ""  ;no upper limit
 I V>(ULN*3) Q 1
 Q ""
RESCK(Y) ;
 NEW V,ULN
 S V=+$P(^AUPNVLAB(X,0),U,4)
 I V>10000 Q 1
 S ULN=$P($G(^AUPNVLAB(X,11)),U,5)
 I ULN="" Q 0  ;no upper limit
 I V>(ULN*10) Q 1
 Q 0
STATCON(P,BDATE,EDATE,NMIB,NMIE) ;EP does patient have an STATIN contra
 NEW ED,BD,BGPG,BGPC,X,Y,Z,N,E
 ;
 ;pregnant
 S X=$$PREG^BGP0D7(P,BDATE,EDATE) I X Q 1_U_"contra statin - pregnant"
 ;nmi
 S BGPG=""
 S T=$O(^ATXAX("B","BGP HEDIS STATIN MEDS",0))
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not an STATI
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D I Y<NMIB Q
 ..I Y>NMIE Q  ;documented after End date
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S BGPG=1_U_"NMI STATIN: "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP0UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I BGPG Q BGPG
 ;breastfeeding
 K BGPG S Y="BGPG(",X=P_"^LAST DX V24.1;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"STATIN contra POV:  "_$$DATE^BGP0UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 ;now check education
 K BGPG
 S Y="BGPG("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S (X,D)=0,%="",T="" F  S X=$O(BGPG(X)) Q:X'=+X!(%]"")  D
 .S T=$P(^AUPNVPED(+$P(BGPG(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I T="BF-BC" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-BP" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-CS" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-EQ" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-FU" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-HC" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-ON" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-M" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-MK" S %=T_U_$P(BGPG(X),U) Q
 .I T="BF-N" S %=T_U_$P(BGPG(X),U) Q
 .;I $P(T,"-")="V24.1" S %=T_U_$P(BGPG(X),U) Q
 I %]"" Q 1_U_"STATIN contra - "_%
 ;NOW CHECK ALCOHOL HEPATITIS
 K BGPG S Y="BGPG(",X=P_"^LAST DX 571.1;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"STATIN contra POV:  "_$$DATE^BGP0UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 Q ""
STATRX(P,BDATE,EDATE,BGPNDAYS) ;EP
 K BGPMEDS1 S K=0,R=""
 D GETMEDS^BGP0UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T=$O(^ATXAX("B","BGP HEDIS STATIN MEDS",0))
 S T1=$O(^ATXAX("B","BGP HEDIS STATIN NDC",0))
 S X=0 F  S X=$O(BGPMEDS1(X)) Q:X'=+X  S Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1 G STAT1
 .S N=$P($G(^PSDRUG(D,2)),U,4)
 .I N]"",T1,$D(^ATXAX(T1,21,"B",N)) S G=1
 .Q:'G
STAT1 .;
 .S J=$P(^AUPNVMED(Y,0),U,8)
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .S S=$$DAYS^BGP0D82(Y,V,EDATE)
 .S K=S+K  ;TOTAL DAYS SUPPLY
 .I R]"" S R=R_";"
 .S R=R_$$DATE^BGP0UTL($P($P(^AUPNVSIT(V,0),U),"."))_"("_S_")"
 I K>BGPNDAYS Q 1_U_" total days STATIN: "_K
STATPRIO ;now add in any before BEG DATE
 K BGPMEDS1
 D GETMEDS^BGP0UTL2(P,$$FMADD^XLFDT(BDATE,-365),BDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S X=0 F  S X=$O(BGPMEDS1(X)) Q:X'=+X  S Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1 G STAT2
 .S N=$P($G(^PSDRUG(D,2)),U,4)
 .I N]"",T1,$D(^ATXAX(T1,21,"B",N)) S G=1 G STAT2
 .Q:'G
STAT2 .;
 .S J=$P(^AUPNVMED(Y,0),U,8)
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .;S IS DAYS SUPPLY, J IS DATE DISCONTINUED
 .Q:J]""  ;don't use if discontinued
 .S D=$$FMDIFF^XLFDT(BDATE,$P($P(^AUPNVSIT(V,0),U),"."))  ;difference between dsch date and date prescribed
 .S S=$P(^AUPNVMED(Y,0),U,7)
 .S S=S-D  ;subtract the number of days used
 .S:S<0 S=0
 .S K=S+K  ;TOTAL DAYS SUPPLY
 .I R]"" S R=R_";"
 .S R=R_$$DATE^BGP0UTL($P($P(^AUPNVSIT(V,0),U),"."))_"("_S_")"
 I K>BGPNDAYS Q 1_U_" total STATIN: "_K
 Q 0_U_R_" total days STATIN: "_K
 ;
STATREF(P,BDATE,EDATE) ;EP
 ;did patient have a refusal in time period?
 S T=$O(^ATXAX("B","BGP HEDIS STATIN MEDS",0))
 S X=0,G="" F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",X))
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D!(G)  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented more than 1 year before edate
 ..I Y>EDATE Q
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N!(G)  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="R"
 ...S G=1_U_"Statin Refusal "_$$DATE^BGP0UTL(Y)
 ..Q
 .Q
 Q G
