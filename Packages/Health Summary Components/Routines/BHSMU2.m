BHSMU2 ;IHS/CIA/MGH - Health Summary Utilities ;17-Mar-2009 16:21;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**2**;March 17, 2006
 ;===================================================================
 ;Taken from APCHSMU2
 ; IHS/CMI/LAB - utilities for hmr ;  [ 03/29/04  12:27 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**9,11,12**;JUN 24, 1997
 ;=================================================================
 ;Patch 2 CSV changes in CPT
 ;
LASTTD(P) ;EP
 NEW X,E,B,%DT,Y,TDD,D,BHSY
 K TDD
 I '$$BI^BHSMU1 D LASTTDO
 I $$BI^BHSMU1 D LASTTDN
 ;now check cpt codes
 F %=1:1 S T=$T(TDCPTS+%^BHSMU1) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S X=$O(^AUPNVCPT("AA",P,T,0)) I X]"" S TDD(X)=""
 I '$D(TDD) Q ""
 Q 9999999-$O(TDD(0))
LASTTDN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=1 S TDD(9999999-D)="" Q
 .I B=9 S TDD(9999999-D)="" Q
 .I B=20 S TDD(9999999-D)="" Q
 .I B=22 S TDD(9999999-D)="" Q
 .I B=28 S TDD(9999999-D)="" Q
 .I B=35 S TDD(9999999-D)="" Q
 .I B=50 S TDD(9999999-D)="" Q
 .I B=106 S TDD(9999999-D)="" Q
 .I B=107 S TDD(9999999-D)="" Q
 .I B=110 S TDD(9999999-D)="" Q
 Q
 ;;
LASTTDO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B="04" S TDD(9999999-D)="" Q
 .I B=42 S TDD(9999999-D)="" Q
 .I B=34 S TDD(9999999-D)="" Q
 .I B="03" S TDD(9999999-D)="" Q
 .I B="02" S TDD(9999999-D)="" Q
 Q
LASTPN(P) ;EP
 NEW X,E,B,%DT,Y,TDD,D,BHSY
 K TDD
 I '$$BI^BHSMU1 D LASTPNO
 I $$BI^BHSMU1 D LASTPNN
 ;now check cpt codes
 F %=1:1 S T=$T(PNCPTS+%^BHSMU1) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S X=$O(^AUPNVCPT("AA",P,T,0)) I X]"" S TDD(X)=""
 I '$D(TDD) Q ""
 Q 9999999-($O(TDD(0)))
 ;
LASTPNN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=33 S TDD(9999999-D)="" Q
 .I B=100 S TDD(9999999-D)="" Q
 .I B=109 S TDD(9999999-D)="" Q
 Q
 ;;
LASTPNO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=19 S TDD(9999999-D)="" Q
 Q
LASTFLU(P) ;EP
 NEW X,E,B,%DT,Y,TDD,D,BHSY
 K TDD
 I '$$BI^BHSMU1 D LASTFLO
 I $$BI^BHSMU1 D LASTFLN
 ;now check cpt codes
 F %=1:1 S T=$T(FLUCPTS+%^BHSMU1) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S X=$O(^AUPNVCPT("AA",P,T,0)) I X]"" S TDD(X)=""
 K BHSY S %=P_"^LAST DX V04.8",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S TDD(9999999-$P(BHSY(1),U))=""
 K BHSY S %=P_"^LAST DX V04.81",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S TDD(9999999-$P(BHSY(1),U))=""
 K BHSY S %=P_"^LAST DX V06.6",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S TDD(9999999-$P(BHSY(1),U))=""
 K BHSY S %=P_"^LAST PROCEDURE 99.52",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S TDD(9999999-$P(BHSY(1),U))=""
 I '$D(TDD) Q ""
 Q 9999999-($O(TDD(0)))
 ;
LASTFLN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=15 S TDD(9999999-D)="" Q
 .I B=16 S TDD(9999999-D)="" Q
 .I B=88 S TDD(9999999-D)="" Q
 .I B=111 S TDD(9999999-D)="" Q
 Q
 ;;
LASTFLO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=12 S TDD(9999999-D)="" Q
 Q
WH(P,BDATE,EDATE,T,F) ;EP
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through procedures in a date range for this patient, check proc type
 NEW D,X,Y,G,V
 S (G,V)=0 F  S V=$O(^BWPCD("C",P,V)) Q:V=""!(G)  D
 .Q:'$D(^BWPCD(V,0))
 .I $P(^BWPCD(V,0),U,4)'=T Q
 .S D=$P(^BWPCD(V,0),U,12)
 .Q:D<BDATE
 .Q:D>EDATE
 .S G=V
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S D=$P(^BWPCD(G,0),U,12) Q D
 I F=4 S D=$P(^BWPCD(G,0),U,12) Q $$FMTE^XLFDT(D)
 Q ""
CPT(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT
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
 ;Patch 2 cvs changes
 N APCHSVDT
 ;I F=5 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^ICPT($P(^AUPNVCPT(G,0),U),0),U)
 I F=5 S V=$P(^AUPNVCPT(G,0),U,3) I V S APCHSVDT=$P(+V,".") Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVCPT(G,0),U),APCHSVDT),U,2)
 Q ""
