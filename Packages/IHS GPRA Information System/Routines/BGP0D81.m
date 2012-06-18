BGP0D81 ; IHS/CMI/LAB - measure C ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
IAST1 ;EP
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9,BGPD10,BGPD11,BGPD12)=0
 I 'BGPACTUP S BGPSTOP=1 Q
 I BGPAGEB<1 S BGPSTOP=1 Q  ;not 1 or older
 S BGPVAL=$$V2ASTH(DFN,BGPBDATE,BGPEDATE) I 'BGPVAL S BGPSTOP=1 Q  ;no asthma visits or persistent in ats
 I BGPACTCL S BGPD1=1
 I BGPACTCL,BGPAGEB>0,BGPAGEB<5 S BGPD2=1
 I BGPACTCL,BGPAGEB>4,BGPAGEB<20 S BGPD3=1
 I BGPACTCL,BGPAGEB>19,BGPAGEB<45 S BGPD4=1
 I BGPACTCL,BGPAGEB>44,BGPAGEB<65 S BGPD5=1
 I BGPACTCL,BGPAGEB>64 S BGPD6=1
 I BGPACTUP S BGPD7=1
 I BGPACTUP,BGPAGEB>0,BGPAGEB<5 S BGPD8=1
 I BGPACTUP,BGPAGEB>4,BGPAGEB<20 S BGPD9=1
 I BGPACTUP,BGPAGEB>19,BGPAGEB<45 S BGPD10=1
 I BGPACTUP,BGPAGEB>44,BGPAGEB<65 S BGPD11=1
 I BGPACTUP,BGPAGEB>64 S BGPD12=1
 S BGPV=$$INHALED(DFN,BGPBDATE,BGPEDATE)
 S BGPN1=+BGPV
 S BGPVALUE="UP"_$S(BGPD1:";AC",1:"")_" "_$P(BGPVAL,U,2)_"|||"_$S($P(BGPV,U)=1:$P(BGPV,U,2)_" on "_$P(BGPV,U,3),1:"")
 K X,Y,Z,%,A,B,C,D,E,H,BDATE,EDATE,P,V,S,F,T
 Q
V2ASTH(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 I $$ASEX(P,EDATE) Q ""  ;exclusion
 ;find problem list active for asthma with 2, 3 or 4 in 15th piece
 NEW S,A,B,T,X,G,V,Y,EDATE1
 S G=""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;if added to pl after end of time period
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .Q:$P(^AUPNPROB(X,0),U,15)=""
 .Q:$P(^AUPNPROB(X,0),U,15)<2
 .S G=1_U_"PL "_$P(^ICD9(Y,0),U)_"=Pers: "_$P(^AUPNPROB(X,0),U,15)
 .Q
 I G Q G
 ;I $P($G(^BATREG(P,0)),U,2)'="A" G DXS  ;not active on asthma register
 S S=""
 S EDATE1=9999999-EDATE-1
 S D=$O(^AUPNVAST("AS",P,EDATE1))
 I 'D G DXS
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AS",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST G DXS
 S S=^AUPNVAST("AS",P,D,LAST)
 I S>1 Q 1_U_"V Asthma=Pers"
DXS I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 I 'T Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>2)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXCHK(%,T,9) S D=1
 .Q:'D
 .S G=G+1
 .Q
 I G>1 Q 1_U_"2 DXs"
 Q ""
ASEX(P,EDATE) ;
 ;2010 - exclusion changed to be active problem with intermittent asthma
 ;now check problem list
 NEW T,G,X,Y
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE  ;if added to pl after end of time period
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .Q:$P(^AUPNPROB(X,0),U,15)'=1
 .S G=1
 .Q
 I G Q G
 ;I $P($G(^BATREG(P,0)),U,2)'="A" Q ""  ;not active on asthma register
 NEW EDATE1,D
 S EDATE1=9999999-EDATE-1
 S D=$O(^AUPNVAST("AS",P,EDATE1))
 I 'D Q ""
 ;I D>(9999999-BDATE) Q ""
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AS",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST Q ""
 S S=^AUPNVAST("AS",P,D,LAST)
 I S=1 Q 1
 Q ""
LAST(P,BDATE,EDATE) ;EP last asthma dx
 K BGPG
 S Y="BGPG("
 S X=P_"^LAST DX [BGP ASTHMA DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) Q $$DATE^BGP0UTL($P(BGPG(1),U))_" "_$P(BGPG(1),U,2)
 Q ""
NDC(A,B) ;
 ;a is drug ien
 ;b is taxonomy ien
 S BGPNDC=$P($G(^PSDRUG(A,2)),U,4)
 I BGPNDC]"",B,$D(^ATXAX(B,21,"B",BGPNDC)) Q 1
 Q 0
LEUK(A,B,C) ;
 ;a drug ien
 ;b tax ien
 ;c tax ien for ndc
 I $D(^ATXAX(B,21,"B",A)) Q 1
 I $$NDC(A,C) Q 1
 Q ""
INHALED(P,BDATE,EDATE) ;EP - any inhaled steroid?
 K BGPMEDS1
 D GETMEDS^BGP0UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T1=$O(^ATXAX("B","BGP ASTHMA INHALED STEROIDS",0))
 S T4=$O(^ATXAX("B","BGP ASTHMA INHALED STEROID NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(D]"")  S V=$P(BGPMEDS1(X),U,5),Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),$P(^AUPNVMED(Y,0),U,8)="" S D=1_U_$P(^PSDRUG(Z,0),U)_U_$$DATE^BGP0UTL($P($P(^AUPNVSIT(V,0),U),".")) Q  ;it is an inhaled steroid that wasn't d/c'ed so 1 dispensing event
 Q D
