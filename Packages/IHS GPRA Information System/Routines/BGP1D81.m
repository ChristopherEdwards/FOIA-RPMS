BGP1D81 ; IHS/CMI/LAB - measure C ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
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
 S BGPVALUE="UP"_$S(BGPD1:";AC",1:"")_" "_$P(BGPVAL,U,2)_"|||"_$S($P(BGPV,U)=1:"NUM: "_$P(BGPV,U,3)_" "_$P(BGPV,U,2),1:"")
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
 ;2011 - exclusion changed to be active problem with intermittent asthma
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
 I $D(BGPG(1)) Q $$DATE^BGP1UTL($P(BGPG(1),U))_" "_$P(BGPG(1),U,2)
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
 D GETMEDS^BGP1UTL2(P,BDATE,EDATE,,,,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""
 S T1=$O(^ATXAX("B","BGP ASTHMA INHALED STEROIDS",0))
 S T4=$O(^ATXAX("B","BGP ASTHMA INHALED STEROID NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(D]"")  S V=$P(BGPMEDS1(X),U,5),Y=+$P(BGPMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$D(^AUPNVMED(Y,0))
 .Q:$$UP^XLFSTR($P($G(^AUPNVMED(Y,11)),U))["RETURNED TO STOCK"
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),'$$STATDC(Y) S D=1_U_$P(^PSDRUG(Z,0),U)_U_$$DATE^BGP1UTL($P($P(^AUPNVSIT(V,0),U),".")) Q  ;it is an inhaled steroid that wasn't d/c'ed so 1 dispensing event
 Q D
STATDC(V) ;EP - is the prescription associated with this V MED discontinued?
 I '$G(V) Q ""
 I '$D(^AUPNVMED(V,0)) Q 0
 NEW P,S,X
 S P=$S($D(^PSRX("APCC",V)):$O(^(V,0)),1:0)
 I 'P Q 0
 S X=$P($G(^PSRX(P,0)),U,15)
 I X=12 Q 1
 I X=13 Q 1
 I X=14 Q 1
 I X=15 Q 1
 S X=$P($G(^PSRX(P,"STA")),U,1)
 I X=12 Q 1
 I X=13 Q 1
 I X=14 Q 1
 I X=15 Q 1
 Q 0
 ;
ASTHTHER ;EP
 S (BGPN1,BGPN2,BGPD1)=0
 I 'BGPACTCL S BGPSTOP=1 Q
 I BGPAGEB<5 S BGPSTOP=1 Q  ;not 5 or older
 I BGPAGEB>50 S BGPSTOP=1 Q  ;over 50
 S BGPVAL=$$V2ASTH(DFN,BGPBDATE,BGPEDATE) I 'BGPVAL S BGPSTOP=1 Q  ;no asthma visits or persistent in ats
 S BGPD1=1
 S BGPVALUE="AC,"_$P(BGPVAL,U,2)_"|||"
 S BGPSABA=$$SABA(DFN,BGPBDATE,BGPEDATE)      ;1 (HAD 4 CANISTERS)^1 (HAD CONTROLLER)^LIST DISPLAY
 K ^TMP($J,"A"),BGPMEDS1
 S BGPVALUE=BGPVALUE_$P(BGPSABA,U,3) I $P(BGPSABA,U,2) S BGPVALUE=BGPVALUE_"; "_$P(BGPSABA,U,4)
 I $P(BGPSABA,U,1) S BGPN1=1
 I $P(BGPSABA,U,1),'$P(BGPSABA,U,2) S BGPN2=1  ;HAD SABA BUT NO CONTROLLER
 K BGPSABA,BGPVAL
 Q
SABA(P,BDATE,EDATE) ;EP - any SABA?
 K ^TMP($J,"A")
 NEW A,B,E,Z,X,D,V,Y,G,M,T,T1,BGPMEDS1,C,BGPISD,BGPMP,DAYS,LEND,SD,DC,N,S,PER,GAP,Q,V1,V1D,M1,TQ,QG
 K BGPMEDS1
 D GETMEDS^BGP1UTL2(P,BDATE,EDATE,"BGP PQA SABA MEDS","BGP PQA SABA NDC",,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q ""  ; no beta blocker meds
 S BGPISD=""
 S (A,C)=0 F  S A=$O(BGPMEDS1(A)) Q:A'=+A  D
 .S M=$P(BGPMEDS1(A),U,4)  ;IEN OF V MED
 .Q:'$D(^AUPNVMED(M,0))
 .I $$UP^XLFSTR($P($G(^AUPNVMED(M,11)),U))["RETURNED TO STOCK" K BGPMEDS1(A) Q
 .I $$STATDC(M) K BGPMEDS1(A) Q  ;d/c'ed BY PROVIDER OR EDIT
 .S Q=$P(^AUPNVMED(M,0),U,6) I 'Q K BGPMEDS1(A) Q  ;no quantity
 ;now go through and see if there are a quantity of 4 in any 90 day period
 S Q=0,G=""
 S X=0 F  S X=$O(BGPMEDS1(X)) Q:X'=+X!(G)  D CHK90
 I 'G Q G
 ;CHECK FOR CONTROLLER BETWEEN SD AND E
 K BGPMEDS1,^TMP($J,"A")
 D GETMEDS^BGP1UTL2(P,SD,E,"BGP PQA CONTROLLER MEDS","BGP PQA CONTROLLER NDC",,,.BGPMEDS1)
 I '$D(BGPMEDS1) Q G  ; no CONTROLLER meds
 S BGPISD=""
 S A=0,C="" F  S A=$O(BGPMEDS1(A)) Q:A'=+A!(C)  D
 .S M=$P(BGPMEDS1(A),U,4)  ;IEN OF V MED
 .Q:'$D(^AUPNVMED(M,0))
 .I $$UP^XLFSTR($P($G(^AUPNVMED(M,11)),U))["RETURNED TO STOCK" K BGPMEDS1(A) Q
 .I $$STATDC(M) K BGPMEDS1(A) Q  ;d/c'ed BY PROVIDER OR EDIT
 .S V=$P(BGPMEDS1(A),U,5)
 .S V1D=$$VD^APCLV(V)
 .S C=1_U_"CONT: "_$$DATE^BGP1UTL(V1D)_" "_$$VAL^XBDIQ1(9000010.14,M,.01)
 I 'C Q G
 S $P(G,U,2)=1,$P(G,U,4)=$P(C,U,2)
 K BGPMEDS1,^TMP($J,"A")
 Q G
CANI(D,Q) ;get order unit from drug entry and divide by quantity.
 NEW O
 ;GET ORDER UNITS
 S O=$P($G(^PSDRUG(D,660)),U,5)
 I O="" Q Q
 Q Q/O
CHK90 ;
 ;get date of med and add 90 days
 S G=""
 K T
 S C=0
 S V=$P(BGPMEDS1(X),U,5)
 S SD=$$VD^APCLV(V)  ;start date of med
 S E=$$FMADD^XLFDT(SD,90)  ;add 90 days
 S M=$P(BGPMEDS1(X),U,4)
 S QG=$P(^AUPNVMED(M,0),U,6)  ;# of canisters
 S (TQ,Q)=$$CANI($P(^AUPNVMED(M,0),U,1),QG)
 S C=C+1,T(C)=$$DATE^BGP1UTL(SD)_U_$$VAL^XBDIQ1(9000010.14,M,.01)_U_"("_Q_")"
 S Y=X F  S Y=$O(BGPMEDS1(Y)) Q:Y'=+Y  D
 .S V1=$P(BGPMEDS1(Y),U,5)
 .S V1D=$$VD^APCLV(V1)
 .Q:V1D>E  ;after the 90 days
 .S M1=$P(BGPMEDS1(Y),U,4)
 .S QG=$P(^AUPNVMED(M1,0),U,6)  ;# of canisters
 .S Q=$$CANI($P(^AUPNVMED(M1,0),U,1),QG)
 .S C=C+1,T(C)=$$DATE^BGP1UTL(V1D)_U_$$VAL^XBDIQ1(9000010.14,M1,.01)_U_" ("_Q_")"
 .S TQ=TQ+Q
 Q:TQ<4
 S D=0,Z="" F  S D=$O(T(D)) Q:D'=+D  S Z=Z_$S(Z]"":" ",1:""),Z=Z_$P(T(D),U,1)_" "_$P(T(D),U,2)_$P(T(D),U,3)
 S G=1_U_0_U_"SABA: "_Z_U
 Q
