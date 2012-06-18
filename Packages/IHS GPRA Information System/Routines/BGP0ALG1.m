BGP0ALG1 ; IHS/CMI/LAB - measure AHR.A ;
 ;;10.0;IHS CLINICAL REPORTING;**1**;JUN 18, 2010
 ;
 ;
BETA ;EP - BETA BLOCKER CONTRAINDICATION/NMI REFUSAL
 I $G(P)="" Q ""
 S EDATE=$G(EDATE)
 I EDATE="" S EDATE=DT
 NEW BGPC,BGPG,BGPY,Y,E,X,N,Z,T
 ;get all povs with 995.0-995.3 with ecode of e935.3 up to discharge date
 S BGPC=0
BETAPOV ;
 K BGPG,BGPY S Y="BGPG(",X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04) S N=$$UP^XLFSTR(N)
 .I N["BETA BLOCK"!(N["BBLOCK")!(N["B BLOCK") S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.0" S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.0]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.0" S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.0]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.0" S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.0]  "_N Q
 .Q
 I BGPC>0 Q 1_U_BGPY(BGPC)
 K BGPG S BGPC=0 S Y="BGPG(",X=P_"^ALL DX V14.8;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["BETA BLOCK"!(N["BBLOCK")!(N["B BLOCK") S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 I BGPC>0 Q 1_U_BGPY(BGPC)
 ;now check problem list for these codes
 S BGPC=0
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .I Y="V14.8"!($$ICD^ATXCHK(I,T,9)),N["BETA BLOCK"!(N["BBLOCK")!(N["B BLOCK") S BGPC=BGPC+1,BGPY(BGPC)="PROBLEM LIST:  "_$$DATE^BGP0UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "_N
 .Q
 I BGPC>0 Q 1_U_BGPY(BGPC)
 ;now check allergy tracking
 S BGPC=0
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after end date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["BETA BLOCK" S BGPC=BGPC+1,BGPY(BGPC)="ALLERGY TRACKING:  "_$$DATE^BGP0UTL($P(^GMR(120.8,X,0),U,4))_"  "_N
 I BGPC>0 Q 1_U_BGPY(BGPC)
 Q ""
 ;
ASA ;EP does patient have an aspirin allergy documented on or before EDATE
 ;get all povs with 995.0-995.3 with ecode of e935.3 up to EDATE
 I $G(P)="" Q ""
 S EDATE=$G(EDATE)
 I EDATE="" S EDATE=DT
 NEW BGPG,G,X,N,Z,Y,T,I,E
 K BGPG
 S G=""
 S X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X!(G)  D
 .S Y=+$P(BGPG(X),U,4)
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ASPIRIN"!(N["ASA") S G=1_U_$$DATE^BGP0UTL($P(BGPG(X),U))_" POV code "_$$VAL^XBDIQ1(9000010.07,Y,.01)_" "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E935.3" S G=1_U_$$DATE^BGP0UTL($P(BGPG(X),U,1))_" POV: "_$$VAL^XBDIQ1(9000010.07,Y,.01)_" w/E935.3 " Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E935.3" S G=1_U_$$DATE^BGP0UTL($P(BGPG(X),U,1))_" POV: "_$$VAL^XBDIQ1(9000010.07,Y,.01)_" w/E935.3 " Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E935.3" S G=1_U_$$DATE^BGP0UTL($P(BGPG(X),U,1))_" POV: "_$$VAL^XBDIQ1(9000010.07,Y,.01)_" w/E935.3 " Q
 .Q
 I G Q G  ;found pov with ecode or narrative
 K BGPG S Y="BGPG(",X=P_"^ALL DX V14.8;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X!(G)  D
 .S Y=+$P(BGPG(X),U,4)
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ASPIRIN"!(N["ASA") S G=1_U_$$DATE^BGP0UTL($P(BGPG(X),U))_" POV code "_$$VAL^XBDIQ1(9000010.07,Y,.01)_" "_N
 .Q
 I G Q G
 ;now check problem list for these codes
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;added after EDATE
 .I Y="V14.8"!($$ICD^ATXCHK(I,T,9)),N["ASPIRIN"!(N["ASA") S G=1_U_$$DATE^BGP0UTL($P(^AUPNPROB(X,0),U,8))_" Problem List code "_$$VAL^XBDIQ1(9000011,X,.01)_" "_N
 .Q
 I G Q G
 ;now check allergy tracking
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X!(G)  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after EDATE
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["ASPIRIN" S G=1_U_$$DATE^BGP0UTL($P($P($G(^GMR(120.8,X,0)),U,4),"."))_"  Allergy Tracking: "_N
 Q G
 ;
 ;
ACEI ;EP - ACE ALLERGY
 I $G(P)="" Q ""
 S EDATE=$G(EDATE)
 I EDATE="" S EDATE=DT
 NEW ED,BD,BGPG,G,X,Y,Z,N,T,E,I
 S G=""
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04) S N=$$UP^XLFSTR(N)
 .I N["ACEI"!(N["ACE I") S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.6" S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.6]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.6" S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.6]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.6" S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.6]  "_N Q
 .Q
 I G Q G
 K BGPG S Y="BGPG(",X=P_"^ALL DX V14.8;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ACEI"!(N["ACE I") S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 I G Q G
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;added after discharge date
 .I Y="V14.8"!($$ICD^ATXCHK(I,T,9)),N["ACEI"!(N["ACE I") S G=1_U_"PROBLEM LIST:  "_$$DATE^BGP0UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "_N
 .Q
 I G Q G
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after discharge date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["ACEI"!(N["ACE INHIBITOR") S G=1_U_"ALLERGY TRACKING:  "_$$DATE^BGP0UTL($P(^GMR(120.8,X,0),U,4))_"  "_N
 I G Q G
 Q ""
ARB ;EP - ARB ALLERGIES
 I $G(P)="" Q ""
 S EDATE=$G(EDATE)
 I EDATE="" S EDATE=DT
 NEW ED,BD,BGPG,G,X,Y,Z,N,T,E,I,D,B
 S G=""
 K BGPG S Y="BGPG(",X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04) S N=$$UP^XLFSTR(N)
 .I N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.6" S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.6]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,18) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.6" S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.6]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,19) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.6" S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.6]  "_N Q
 .Q
 I G Q G
 K BGPG S Y="BGPG(",X=P_"^ALL DX V14.8;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 I G Q G
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;added after discharge date
 .I Y="V14.8"!($$ICD^ATXCHK(I,T,9)),N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"PROBLEM LIST:  "_$$DATE^BGP0UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "_N
 .Q
 I G Q G
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after discharge date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["ARB"!(N["ANGIOTENSIN RECEPTOR BLOCKER") S G=1_U_"ALLERGY TRACKING:  "_$$DATE^BGP0UTL($P(^GMR(120.8,X,0),U,4))_"  "_N
 Q G
 ;
STATIN ;EP
 I $G(P)="" Q ""
 S EDATE=$G(EDATE)
 I EDATE="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 NEW BGPC,BGPG,BGPY,Y,X,E,N,T,I,BGPLT,D,B,L,T2,BGPLT2
 S BGPC=""
 K BGPG,BGPY S Y="BGPG(",X=P_"^ALL DX [BGP ASA ALLERGY 995.0-995.3;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04) S N=$$UP^XLFSTR(N)
 .I N["STATIN"!(N["STATINS") S BGPC=1_U_"Alg Statin POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.9" S BGPC=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.9]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.9" S BGPC=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.9]  "_N Q
 .S Z=$P(^AUPNVPOV(Y,0),U,9) I Z]"",$P($$ICDDX^ICDCODE(Z),U,2)="E942.9" S BGPC=1_U_"POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_" + E942.9]  "_N Q
 .Q
 I BGPC Q BGPC
 K BGPG S BGPC=0 S Y="BGPG(",X=P_"^ALL DX V14.8;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S Y=+$P(BGPG(X),U,4) D
 .S N=$$VAL^XBDIQ1(9000010.07,Y,.04),N=$$UP^XLFSTR(N)
 .I N["STATIN"!(N["STATINS") S BGPC=1_U_"alg statin POV:  "_$$DATE^BGP0UTL($P(BGPG(X),U))_"  ["_$P(BGPG(X),U,2)_"]  "_N
 I BGPC Q BGPC
 ;now check problem list for these codes
 S BGPC=0
 S T="",T=$O(^ATXAX("B","BGP ASA ALLERGY 995.0-995.3",0))
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNPROB(X,0)),U),Y=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000011,X,.05),N=$$UP^XLFSTR(N)
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;added after discharge date
 .I Y="V14.8"!($$ICD^ATXCHK(I,T,9)),N["STATIN"!(N["STATINS") S BGPC=1_U_"alg statin PROBLEM LIST:  "_$$DATE^BGP0UTL($P(^AUPNPROB(X,0),U,8))_"  ["_Y_"]  "_N
 .Q
 I BGPC Q BGPC
 ;now check allergy tracking
 S BGPC=0
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after discharge date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .I N["STATIN" S BGPC=1_U_" alg statin ALLERGY TRACKING:  "_$$DATE^BGP0UTL($P(^GMR(120.8,X,0),U,4))_"  "_N
 I BGPC Q BGPC
 ;now go into the report period items
 K BGPG S Y="BGPG(",X=P_"^LAST DX [BGP MYOPATHY/MYALGIA;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q 1_U_"Statin allergy POV:  "_$$DATE^BGP0UTL($P(BGPG(1),U))_" ["_$P(BGPG(1),U,2)_"]    "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(1),U,4),.04)
 ;creatine lab value > 10,000 or 10x uln
 ;now get all loinc/taxonomy tests
 S BGPG=""
 S T=$O(^ATXAX("B","BGP CREATINE KINASE LOINC",0))
 S BGPLT=$O(^ATXLAB("B","BGP CREATINE KINASE TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BGPG)  D
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
 Q ""
 ;
RESAL(Y) ;
 NEW V,ULN
 S V=+$P(Y,U,2),ULN=$P(Y,U,3)
 I ULN="" Q ""  ;no upper limit so can't check
 I V>(ULN*3) Q 1
 Q ""
RESCK(Y) ;
 NEW V,ULN
 S V=+$P(^AUPNVLAB(X,0),U,4)
 I V>10000 Q 1
 S ULN=$P($G(^AUPNVLAB(X,11)),U,5)
 I ULN="" Q 0  ;no upper limit, can't check
 I V>(ULN*10) Q 1
 Q 0
