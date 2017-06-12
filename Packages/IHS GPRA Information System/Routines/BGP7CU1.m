BGP7CU1 ; IHS/CMI/LAB - calc CMS measures 26 Sep 2004 11:28 AM 04 May 2010 2:38 PM 30 Oct 2009 11:26 AM ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
ASAALLEG(P,BDATE,EDATE) ;EP does patient have an aspirin allergy documented on or before EDATE
 NEW BGPG,G,X,N,Z,Y,T,I
 K BGPG
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 S G=""
 S X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X!(G)  D
 .S Y=+$P(BGPG(X),U,4)
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ASPIRIN"!(N["ASA") S G=1_U_$$DATE^BGP7UTL($P(BGPG(X),U))_" POV "_$$VAL^XBDIQ1(9000010.07,Y,.01) Q
 .S T=$O(^ATXAX("B","BGP ADV EFF SALICYLATES",0))
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .Q
 I G Q G  ;found pov
 S G=""
 K BGPG S BGPG=$$LASTDX^BGP7UTL1(P,"BGP ADV EFF SALICYLATES 10",$$DOB^AUPNPAT(P),EDATE)
 I BGPG S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG,U,3))_"  ["_$P(BGPG,U,2)_"]"
 I G Q G
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP HX DRUG ALLERGY NEC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X!(G)  D
 .S Y=+$P(BGPG(X),U,4)
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ASPIRIN"!(N["ASA") S G=1_U_$$DATE^BGP7UTL($P(BGPG(X),U))_" POV "_$$VAL^XBDIQ1(9000010.07,Y,.01)
 .Q
 I G Q G
 ;now check problem list for these codes
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^BGP7UTL2(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)<BDATE
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;added after DIS DATE
 .I $P(^AUPNPROB(X,0),U,13)]"",$P(^AUPNPROB(X,0),U,13)>EDATE Q  ;doo
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .;Q:$P(^AUPNPROB(X,0),U,12)="I"
 .I $$ICD^BGP7UTL2(I,$O(^ATXAX("B","BGP HX DRUG ALLERGY NEC",0)),9)!($$ICD^BGP7UTL2(I,T,9)),N["ASPIRIN"!(N["ASA") S G=1_U_$$DATE^BGP7UTL($P(^AUPNPROB(X,0),U,8))_" Problem List "_$$VAL^XBDIQ1(9000011,X,.01) Q
 .I $$ICD^BGP7UTL2(I,$O(^ATXAX("B","BGP ADV EFF SALICYLATES 10",0)),9) S G=1_U_"PROBLEM LIST:  "_$$DATE^BGP7UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  " Q
 .S S=$$VAL^XBDIQ1(9000011,X,80001)
 .I S]"",$D(^XTMP("BGPSNOMEDSUBSET",$J,"PXRM BGP ADR ASA",S)) S G=1_U_"PROBLEM LIST:  "_$$DATE^BGP7UTL($P(^AUPNPROB(X,0),U,8))_" ["_S_"] " Q
 I G Q G
 ;now check allergy tracking
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X!(G)  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")<BDATE
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["ASPIRIN" S G=1_U_$$DATE^BGP7UTL($P($P($G(^GMR(120.8,X,0)),U,4),"."))_" Allergy Tracking "_N
 Q G
 ;
ACEALLEG(P,BDATE,EDATE) ;EP
 NEW ED,BD,BGPG,G,X,Y,Z,N
 S G=""
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04) S N=$$UP^XLFSTR(N)
 .I N["ACEI"!(N["ACE I") S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N Q
 .S T=$O(^ATXAX("B","BGP ADV EFF ANTIHYPERTEN AGT",0))
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .Q
 I G Q G
 S G=""
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP ADV EFF ANTIHYPER 10;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(1),U))_"  ["_$P(BGPG(1),U,2)_"]"
 I G Q G
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP HX DRUG ALLERGY NEC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ACEI"!(N["ACE I") S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 I G Q G
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^BGP7UTL2(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)<BDATE
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;added after discharge date
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .I $$ICD^BGP7UTL2(I,$O(^ATXAX("B","BGP HX DRUG ALLERGY NEC",0)),9)!($$ICD^BGP7UTL2(I,T,9)),N["ACEI"!(N["ACE I") S G=1_U_"PROBLEM LIST:  "_$$DATE^BGP7UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "_N Q
 .I $$ICD^BGP7UTL2(I,$O(^ATXAX("B","BGP ADV EFF ANTIHYPER 10",0)),9) S G=1_U_"PROBLEM LIST:  "_$$DATE^BGP7UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "
 .Q
 I G Q G
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")<BDATE
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after discharge date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["ACEI"!(N["ACE INHIBITOR") S G=1_U_"ALLERGY TRACKING:  "_$$DATE^BGP7UTL($P(^GMR(120.8,X,0),U,4))_"  "_N
 Q G
 ;
ARBALLEG(P,BDATE,EDATE) ;EP
 NEW ED,BD,BGPG,G,X,Y,Z,N
 S G=""
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04) S N=$$UP^XLFSTR(N)
 .I N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N Q
 .S T=$O(^ATXAX("B","BGP ADV EFF ANTIHYPERTEN AGT",0))
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$$ICD^BGP7UTL2(Z,T,9) S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + "_$P($$ICDDX^BGP7UTL2(Z),U,2)_"]  "_N Q
 .Q
 I G Q G
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP HX DRUG ALLERGY NEC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 I G Q G
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^BGP7UTL2(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)<BDATE
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;added after discharge date
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .I $$ICD^BGP7UTL2(I,$O(^ATXAX("B","BGP HX DRUG ALLERGY NEC",0)),9)!($$ICD^BGP7UTL2(I,T,9)),N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"PROBLEM LIST:  "_$$DATE^BGP7UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "_N
 .Q
 I G Q G
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")<BDATE
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after discharge date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"ALLERGY TRACKING:  "_$$DATE^BGP7UTL($P(^GMR(120.8,X,0),U,4))_"  "_N
 Q G
 ;
SAORSTEN(P,BDATE,EDATE) ;EP
 NEW BGPG,Y,E,X
 K BGPG S Y="BGPG(",X=P_"^LAST DX [BGP CMS AORTIC STENOSIS DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"POV:  "_$$DATE^BGP7UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 Q ""
NMIDRUG(P,BDATE,EDATE,BGPY,TAX,C) ;EP ;nmi in Refusal file for aspirin or cpt/tran
 ;array returned is BGPY
 NEW T,Z,Y,D,N
 I $G(C)="" S C=0
 S T=$O(^ATXAX("B",TAX,0))
 I T="" Q
 S X=0 F  S X=$O(^AUPNPREF("AA",P,50,X)) Q:X'=+X  D
 .Q:'$D(^ATXAX(T,21,"B",X))  ;not an aspirin
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,50,X,D)) Q:D'=+D  D
 ..S Y=9999999-D I Y<BDATE Q  ;documented before bdate
 ..I Y>EDATE Q  ;documented after discharge
 ..S N=0 F  S N=$O(^AUPNPREF("AA",P,50,X,D,N)) Q:N'=+N  D
 ...Q:$P($G(^AUPNPREF(N,0)),U,7)'="N"
 ...S C=C+1,BGPY(C)="NMI Refusal of:  "_$$VAL^XBDIQ1(9000022,N,.04)_"   "_$$DATE^BGP7UTL($P(^AUPNPREF(N,0),U,3))_"  "_$$VAL^XBDIQ1(9000022,X,1101)
 ..Q
 .Q
 I TAX'["ASPIRIN" Q
 ;now check for CPT code G8008
 S X=$$CPTI^BGP7DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G8008"))
 I X S C=C+1,BGPY(C)="CPT G8008: "_$$DATE^BGP7UTL($P(X,U,2))
 S X=$$TRANI^BGP7DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G8008"))
 I X S C=C+1,BGPY(C)="CPT (tran code) G8008: "_$$DATE^BGP7UTL($P(X,U,2))
 Q
 ;
LASTMED(P,BDATE,EDATE,T,T1,T2) ;EP - last rx prescription for taxonomy T
 K BGPY
 S T=$G(T)
 S T1=$G(T1)
 S T2=$G(T2)
 D GETMEDS^BGP7CU(P,BDATE,EDATE,T,T1,T2,0,"","",0,1)
 I '$D(BGPY) Q ""
 Q BGPY
 ;
LASTASPC(P,BDATE,EDATE) ;EP - last G8006
 NEW X
 S X=$$CPTI^BGP7DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G8006"))
 I X="" Q ""
 Q "G8006  "_$$DATE^BGP7UTL($P(X,U,2))
 ;
ALLALGA1(P,EDATE,BGPY) ;EP - all allergies from the allergy tracking system
 ;
 ;now check allergy tracking
 S BGPC=0
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after END date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .S BGPC=BGPC+1,BGPY(BGPC)=N_"  "_$$DATE^BGP7UTL($P(^GMR(120.8,X,0),U,4))
 Q
IVUD(P,BD,ED,TAX,BGPY,TAXN,TAXC) ;EP
 ;p - patient
 ;bd - beg date
 ;ed - ending date
 ;BGPY - return array
 ;tax - taxonomy ien
 NEW C,X,E,D,S,I,A,B,F,Z,V,BGPE
 K BGPY,BGPE
 S TAX=$G(TAX),TAXN=$G(TAXN),TAXC=$G(TAXC)
 S C=0
 S X=0 F  S X=$O(^PS(55,P,5,X)) Q:X'=+X  D
 .S E=$P($P($G(^PS(55,P,5,X,2)),U,2),".",1)
 .Q:E>ED
 .Q:E<BD
 .S D="",G="",Z=0 F  S Z=$O(^PS(55,P,5,X,1,Z)) Q:Z'=+Z  D
 ..S D=$P(^PS(55,P,5,X,1,Z,0),U)
 ..Q:D=""
 ..Q:'$D(^PSDRUG(D,0))
 ..I '$$WTD(D,TAX,TAXN,TAXC) Q
 ..S G=G_$S(G]"":"; ",1:"")_$P(^PSDRUG(D,0),U)
 .S S=$P(^PS(55,P,5,X,0),U,9),S=$$EXTSET^XBFUNC(55.06,28,S)
 .S A=$$FMTE^XLFDT($P($G(^PS(55,P,5,X,2)),U,2),2)
 .S B=$$FMTE^XLFDT($P($G(^PS(55,P,5,X,2)),U,4),2)
 .S F=$$FMTE^XLFDT($P($G(^PS(55,P,5,X,2)),U,3),2)
 .I G]"" S C=C+1,BGPE((9999999-E),C)="Unit Dose:  "_G_"  Date: "_$$DATE^BGP7UTL(E)_" Status: "_S_" Start: "_A_" Stop: "_B_" Previous Stop: "_F
 .Q
 S X=0 F  S X=$O(^PS(55,P,"IV",X)) Q:X'=+X  D
 .S E=$P(^PS(55,P,"IV",X,0),U,2),E=$P(E,".")
 .Q:E>ED
 .Q:E<BD
 .S D="",G="",Z=0 F  S Z=$O(^PS(55,P,"IV",X,"AD",Z)) Q:Z'=+Z  D
 ..S D=$P(^PS(55,P,"IV",X,"AD",Z,0),U)
 ..Q:D=""
 ..S D=$P($G(^PS(52.6,D,0)),U,2)
 ..I D="" Q
 ..I '$$WTD(D,TAX,TAXN,TAXC) Q
 ..S G=G_$S(G]"":"; ",1:"")_$P(^PSDRUG(D,0),U)
 .S S=$P(^PS(55,P,"IV",X,0),U,17),S=$$EXTSET^XBFUNC(55.01,100,S)
 .S A=$$FMTE^XLFDT($P($G(^PS(55,P,"IV",X,0)),U,2),2)
 .S B=$$FMTE^XLFDT($P($G(^PS(55,P,"IV",X,0)),U,3),2)
 .S F=$$FMTE^XLFDT($P($G(^PS(55,P,"IV",X,2)),U,7),2)
 .I G]"" S C=C+1,BGPE((9999999-E),C)="IV:  "_G_"  Date: "_$$DATE^BGP7UTL(E)_" Status: "_S_" Start: "_A_" Stop: "_B_" Previous Stop: "_F
 .Q
 S (D,C,A)=0 F  S D=$O(BGPE(D)) Q:D'=+D  S C=0 F  S C=$O(BGPE(D,C)) Q:C'=+C  S A=A+1,BGPY(A)=BGPE(D,C)
 Q
WTD(D,TD,TN,TC) ;
 S TD=$G(TD)
 S TN=$G(TN)
 S TC=$G(TC)
 NEW V
 I 'TD,'TN,'TC Q 1  ;no taxonomies so quit
 I TD,$D(^ATXAX(TD,21,"B",D)) Q 1
 S V=$P($G(^PSDRUG(D,0)),U,2)
 I V]"",TC,$D(^ATXAX(TC,21,"B",V)) Q 1
 S V=$P($G(^PSDRUG(D,2)),U,4)
 I V]"",TN,$D(^ATXAX(TN,21,"B",V)) Q 1
 Q ""
LVSD(P,BDATE,EDATE,BGPY,BGPC) ;EP
 NEW X,Y,I,T,V,BGPG
 K BGPG
 I $G(BGPC)="" S BGPC=0
 S X=P_"^ALL DX 429.71;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 ;S X=$$LASTDXI^BGP7UTL(P,"429.71",BDATE,EDATE) I X]"" D
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP7UTL($P(BGPG(X),U,1))_" ["_$P(BGPG(X),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(X),U,4),.04)
 .Q
 Q
EJECFRAC(P,BDATE,EDATE,BGPY,BGPC) ;EP - now get all measurements CEF
 NEW X,Y,BGPG,N,E,V,T
 I $G(BGPC)="" S BGPC=0
 K BGPG S Y="BGPG(",X=P_"^ALL MEAS CEF;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .Q:$P($G(^AUPNVMSR(Y,2)),U,1)
 .S N=$P(^AUPNVMSR(Y,0),U,4)
 .;Q:N>39
 .S BGPC=BGPC+1,BGPY(BGPC)="MEASUREMENT CEF:  "_$$DATE^BGP7UTL($P(BGPG(X),U))_"  value: "_N
 .Q
 ;now see if any procedures
 S X=0 F  S X=$O(^AUPNVPRC("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPRC(X,0))
 .S I=$P($G(^AUPNVPRC(X,0)),U) Q:'I
 .S Y=$P($$ICDOP^BGP7UTL2(I),U,2)
 .S T="",T=$O(^ATXAX("B","BGP CMS EJECTION FRACTION PROC",0))
 .I $$ICD^BGP7UTL2(I,T,0) D
 ..S V=$P(^AUPNVPRC(X,0),U,3)
 ..S V=$P($P($G(^AUPNVSIT(V,0)),U),".")
 ..I V<BDATE Q
 ..I V>EDATE Q  ;after discharge
 ..S BGPC=BGPC+1,BGPY(BGPC)="CEF PROCEDURE:  "_$$DATE^BGP7UTL(V)_"  ["_Y_"]  "_$$VAL^XBDIQ1(9000010.08,X,.04)
 ;now get all cpts
 S X=0 F  S X=$O(^AUPNVCPT("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S I=$P($G(^AUPNVCPT(X,0)),U) Q:'I
 .S Y=$P($$CPT^ICPTCOD(I),U,2)
 .S T="",T=$O(^ATXAX("B","BGP CMS EJECTION FRACTION CPTS",0))
 .I $$ICD^BGP7UTL2(I,T,1) D
 ..S V=$P(^AUPNVCPT(X,0),U,3)
 ..S V=$P($P($G(^AUPNVSIT(V,0)),U),".")
 ..I V<BDATE Q
 ..I V>EDATE Q  ;after discharge
 ..S BGPC=BGPC+1,BGPY(BGPC)="CEF CPT:  "_$$DATE^BGP7UTL(V)_"  ["_Y_"]  "_$P($$CPT^ICPTCOD(I,V),U,3)
 Q
