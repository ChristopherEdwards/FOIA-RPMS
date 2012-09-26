BGP2EO11 ; IHS/CMI/LAB - calc measures 29 Apr 2010 7:38 PM 14 Nov 2006 5:02 PM 12 Nov 2009 11:03 AM 02 Jul 2010 9:26 AM ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
ANTICOAG(P,BDATE,EDATE,BGPAD) ;EP - was there ANTICOAG
 NEW BGPD,X,N,E,Y,T,D,C,BGPLT,L,J,BGPG,S
 K BGPG S Y="BGPG(",X=P_"^ALL MED;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0,G="" F  S X=$O(BGPG(X)) Q:X'=+X!(G]"")  D
 .S N=+$P(BGPG(X),U,4)  ;ien of v med
 .S C=$$ANTIDRUG(N)  ;not one of the drugs
 .Q:'$P(C,U)
 .;c=1^category of drug
 .I $P(^AUPNVMED(N,0),U,8)]"",$P(^AUPNVMED(N,0),U,8)'>EDATE Q  ;discontinued before discharge date
 .S S=$P(^AUPNVMED(N,0),U,7)
 .I $P($P(^AUPNVSIT($P(^AUPNVMED(N,0),U,3),0),U),".")=EDATE S G=$$DATE^BGP2UTL(EDATE)_" MET: "_$P(C,U,2)_"^1"  ;PRESCRIBED ON DISCHARGE DATE
 .S V=$P(^AUPNVMED(N,0),U,3)
 .S V=$P($P(^AUPNVSIT(V,0),U),".")
 .I $$FMADD^XLFDT(V,S)<EDATE Q  ;not valid through discharge date
 .S G=$$DATE^BGP2UTL(V)_" MET: "_$P(C,U,2)_"^1"
 I G]"" Q G
 ;now check for cpts
 ;S G=$$CPTI^BGP2DU(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4073F"),,,"1P;2P;8P")
 ;I G Q $$DATE^BGP2UTL($P(G,U,2))_" MET: ANTI-PLT CPT [4073F]^1"
 ;S G=$$CPTI^BGP2DU(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4075F"),,,"1P;2P;8P")
 ;I G Q $$DATE^BGP2UTL($P(G,U,2))_" MET: ANTI-PLT CPT [4075F]^1"
 ;S G=$$CPTI^BGP2DU(P,EDATE,EDATE,+$$CODEN^ICPTCOD("G8006"))
 ;I G Q $$DATE^BGP2UTL($P(G,U,2))_" MET: ANTI-PLT CPT [G8006]^1"
 ;S G=$$TRANI^BGP2DU(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4073F"))
 ;I G Q $$DATE^BGP2UTL($P(G,U,2))_" MET: ANTI-PLT CPT/TRAN [4073F]^1"
 ;S G=$$TRANI^BGP2DU(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4075F"))
 ;I G Q $$DATE^BGP2UTL($P(G,U,2))_" MET: ANTI-PLT CPT/TRAN [4075F]^1"
 ;S G=$$TRANI^BGP2DU(P,EDATE,EDATE,+$$CODEN^ICPTCOD("G8006"))
 ;I G Q $$DATE^BGP2UTL($P(G,U,2))_" MET: ANTI-PLT CPT/TRAN [G8006]^1"
 ;now go get refusals of any of the above
 ;
 ;refusal of MEDS
 S T=$O(^ATXAX("B","BGP CMS WARFARIN MEDS",0))
 S G=$$REFTAX^BGP2UTL1(P,50,T,EDATE,EDATE)
 I G Q "NOT MET: REFUSAL WARF^2"
 S T=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 S G=$$REFTAX^BGP2UTL1(P,50,T,EDATE,EDATE)
 I G Q "NOT MET: REFUSAL ANTI-PLT^2"
 S T=$O(^ATXAX("B","D AUDIT ASPIRIN DRUGS",0))
 S G=$$REFTAX^BGP2UTL1(P,50,T,EDATE,EDATE)
 I G Q "NOT MET: REFUSAL ASA^2"
 ;CHECK BL700 CLASS REFUSALS
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,50,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,50,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,50,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D=EDATE D
 .Q:$P($G(^PSDRUG(I,0)),U,2)'="BL700"
 .S G="NOT MET: REFUSAL ANTI-PLT^2"
 I G]"" Q G
 ; S G=$$REFUSAL^BGP2UTL1(P,81,+$$CODEN^ICPTCOD("4073F"),EDATE,EDATE)
 ;I G Q $$DATE^BGP2UTL(EDATE)_" NOT MET: REFUSAL ANTI-PLT [4073F]^2"
 ;S G=$$REFUSAL^BGP2UTL1(P,81,+$$CODEN^ICPTCOD("4075F"),EDATE,EDATE)
 ;I G Q $$DATE^BGP2UTL(EDATE)_" NOT MET: REFUSAL ANTI-PLT [4075F]^2"
 ;S G=$$REFUSAL^BGP2UTL1(P,81,+$$CODEN^ICPTCOD("G8006"),EDATE,EDATE)
 ;I G Q $$DATE^BGP2UTL(EDATE)_" NOT MET: REFUSAL ANTI-PLT [G8006]^2"
 Q "NOT MET: NO THERAPY^3"
 ;
ANTIDRUG(N) ;
 NEW G,T,I
 I '$D(^AUPNVMED(N,0)) Q 0
 I $$UP^XLFSTR($P($G(^AUPNVMED(N,11)),U))["RETURNED TO STOCK" Q 0
 S I=$P($G(^AUPNVMED(N,0)),U)
 I 'I Q 0
 S G=0
 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 I T,$D(^ATXAX(T,21,"B",I)) Q "1^ASA"
 S T=$O(^ATXAX("B","BGP CMS WARFARIN MEDS",0))
 I T,$D(^ATXAX(T,21,"B",I)) Q "1^WARF"
 S T=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 I T,$D(^ATXAX(T,21,"B",I)) Q "1^ANTI-PLT"
 S G=$P(^PSDRUG(I,0),U,2)
 I G="BL700" Q "1^ANTI-PLT"
 I $P(^PSDRUG(I,0),U)["WARFARIN" Q "1^WARF"
 Q ""
