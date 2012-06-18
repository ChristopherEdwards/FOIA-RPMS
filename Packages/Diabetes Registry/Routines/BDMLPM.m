BDMLPM ; IHS/CMI/LAB - CALCULATE LAST PAP MAM ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**1,2**;JUN 14, 2007
 ;
 ;
LASTPAP(P) ;EP - return last pap date
 Q:$P($G(^DPT(+$G(P),0)),U,2)'="F" ""
 I $$HYSTER(P) Q ""
 N APCHY,%,LPAP,T
 S LPAP=""
 S %=P_"^LAST LAB PAP SMEAR"
 S E=$$START1^APCLDF(%,"APCHY(")
 S:$G(APCHY(1))>LPAP LPAP=+APCHY(1)
 ;
 K APCHY S %=P_"^LAST LAB [BGP PAP SMEAR TAX",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 ;
 K APCHY
 F X="V76.2" S %=P_"^LAST DX "_X D
 .S E=$$START1^APCLDF(%,"APCHY(")
 .S:$G(APCHY(1))>LPAP LPAP=+APCHY(1)
 K APCHY
 S %=P_"^LAST PROCEDURE 91.46"
 S E=$$START1^APCLDF(%,"APCHY(")
 S:$G(APCHY(1))>LPAP LPAP=+APCHY(1)
 K APCHY
 F X=88141:1:88148,88150,88152:1:88158,88164:1:88167 D
 .S T=$O(^ICPT("B",X,0))
 .Q:'T
 .S APCHY(1)=$O(^AUPNVCPT("AA",P,T,0))
 .Q:'APCHY(1)
 .S APCHY(1)=9999999-APCHY(1)
 .S:APCHY(1)>LPAP LPAP=$P(APCHY(1),U)
 Q $G(LPAP)
 ;
HYSTER(P) ;EP has patient had hysterectomy?
 I '$G(P) Q ""
 I '$D(^AUPNVPRC("AC",P)) Q ""
 ;NEW F,S,C S (F,S)=0 F  S F=$O(^AUPNVPRC("AC",P,F)) Q:F'=+F!(S)  S C=$P(^ICD0(+^AUPNVPRC(F,0),0),U) D  ;cmi/anch/maw 8/27/2007 orig line patch 1
 NEW F,S,C S (F,S)=0 F  S F=$O(^AUPNVPRC("AC",P,F)) Q:F'=+F!(S)  S C=$P($$ICDOP^ICDCODE(+^AUPNVPRC(F,0),0),U,2) D  ;cmi/anch/maw 8/27/2007 code set versioning patch 1
 .S:C=68.3!(C=68.4)!(C=68.5)!(C=68.6)!(C=68.7)!(C=68.9) S=1
 I S=1 Q 1
 S T="HYSTERECTOMY",T=$O(^BWPN("B",T,0))
 I T D  I X Q 1
 .S X=$$WH(P,$$DOB^AUPNPAT(P),DT,T,1)
 S T=$O(^ATXAX("B","BGP HYSTERECTOMY CPTS",0))
 I T D  I X Q 1
 .S X=$$CPT(P,$P(^DPT(P,0),U,3),DT,T,1)
 Q ""
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
 I F=5 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVCPT(G,0),U),0),U,2)
 Q ""
LASTMAM(P) ;EP
 Q:$P($G(^DPT(+$G(P),0)),U,2)'="F" ""
 N LMAM,T,APCHY,%
 S LMAM=""
 F X=76090:1:76092 S %=P_"^LAST RAD "_X D
 .S E=$$START1^APCLDF(%,"APCHY(")
 .S:$G(APCHY(1))>LMAM LMAM=+APCHY(1)
 K APCHY
 F X="V76.11","V76.12" S %=P_"^LAST DX "_X D
 .S E=$$START1^APCLDF(%,"APCHY(")
 .S:$G(APCHY(1))>LMAM LMAM=+APCHY(1)
 K APCHY
 F X=87.36,87.37 S %=P_"^LAST PROCEDURE "_X D
 .S E=$$START1^APCLDF(%,"APCHY(")
 .S:$G(APCHY(1))>LMAM LMAM=+APCHY(1)
 K APCHY
 F %=76090:1:76092 S T=$O(^ICPT("B",%,0)) D:T
 .S APCHY(1)=$O(^AUPNVCPT("AA",P,T,0))
 .Q:'APCHY(1)
 .S APCHY(1)=9999999-APCHY(1)
 .S:$G(APCHY(1))>LMAM LMAM=+APCHY(1)
 F %=76090:1:76092 S G=$$REFDF^APCHS9B3(P,71,$O(^RAMIS(71,"D",%,0)),$G(LMAM)) Q:G]""
 I $G(G)]"" Q $G(LMAM)_"^"_G
 Q $G(LMAM)
MAS(P,EDATE) ;EPmastectomy before end of time frame
 N BDMT
 K BDMT S %=P_"^LAST PROCEDURE 85.42;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BDMT(")
 I $D(BDMT(1)) Q 1
 K BDMT S %=P_"^LAST PROCEDURE 85.44;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BDMT(")
 I $D(BDMT(1)) Q 1
 K BDMT S %=P_"^LAST PROCEDURE 85.46;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BDMT(")
 I $D(BDMT(1)) Q 1
 K BDMT S %=P_"^LAST PROCEDURE 85.48;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BDMT(")
 I $D(BDMT(1)) Q 1
 ;check cpt codes for bilateral
 ;loop through all cpt codes up to Edate and if any match quit
 S (X,Y,Z,G)=0 K BDMTX
 S T=$O(^ICPT("B",19180,0)),T1=$O(^ICPT("B",19200,0)),T2=$O(^ICPT("B",19220,0)),T3=$O(^ICPT("B",19240,0))
 I T,$D(^AUPNVCPT("AA",P,T)) S %="" D  I %]"" Q 1
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>EDATE Q
 ..S Y=0 F  S Y=$O(^AUPNVCPT("AA",P,T,E,Y)) Q:Y'=+Y  D
 ...S BDMTX(E)=""
 ...S M=$P(^AUPNVCPT(Y,0),U,8) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ...S M=$P(^AUPNVCPT(Y,0),U,9) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ..Q
 .Q
 I T1,$D(^AUPNVCPT("AA",P,T1)) S %="" D  I %]"" Q 1
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T1,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>EDATE Q
 ..S Y=0 F  S Y=$O(^AUPNVCPT("AA",P,T1,E,Y)) Q:Y'=+Y  D
 ...S BDMTX(E)=""
 ...S M=$P(^AUPNVCPT(Y,0),U,8) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ...S M=$P(^AUPNVCPT(Y,0),U,9) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ..Q
 .Q
 I T2,$D(^AUPNVCPT("AA",P,T2)) S %="" D  I %]"" Q 1
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T2,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>EDATE Q
 ..S Y=0 F  S Y=$O(^AUPNVCPT("AA",P,T2,E,Y)) Q:Y'=+Y  D
 ...S BDMTX(E)=""
 ...S M=$P(^AUPNVCPT(Y,0),U,8) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ...S M=$P(^AUPNVCPT(Y,0),U,9) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ..Q
 .Q
 I T3,$D(^AUPNVCPT("AA",P,T3)) S %="" D  I %]"" Q 1
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T3,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>EDATE Q
 ..S Y=0 F  S Y=$O(^AUPNVCPT("AA",P,T3,E,Y)) Q:Y'=+Y  D
 ...S BDMTX(D)=""
 ...S M=$P(^AUPNVCPT(Y,0),U,8) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ...S M=$P(^AUPNVCPT(Y,0),U,9) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1
 ..Q
 .Q
 ;see if 2 on different dates
 K BDMT S %=P_"^ALL PROCEDURE [BGP MASTECTOMY PROCEDURES;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BDMT(")
 S X=0 F  S X=$O(BDMT(X)) Q:X'=+X  S BDMTX($P(BDMT(X),U))=""
 S %=0,X=0,C=0 F  S X=$O(BDMTX(X)) Q:X'=+X  S C=C+1
 I C>1 Q 1
 Q 0
DIETEDUC(P,BDATE,EDATE)  ;EP
 NEW D,BD,ED,X,Y,%DT,D,G,APCLVRD,V,APCL,RD,NRD
 S (RD,NRD)=""
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S D=9999999-ED,(RD,NRD)="",G="" ;is this right???
 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!(D>(9999999-BD))!(G]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:'$D(^AUPNVPOV("AD",V))
 ..Q:'$D(^AUPNVPRV("AD",V))
 ..Q:$$DNKA^BDMD917(V)
 ..Q:$P(^AUPNVSIT(V,0),U,3)="C"
 ..Q:$$CLINIC^APCLV(V,"C")=52
 ..I $$PRIMPROV^APCLV(V,"D")=29 S G=D Q
 ..I $$PRIMPROV^APCLV(V,"D")="07" S G=D Q
 ..I $$PRIMPROV^APCLV(V,"D")="34" S G=D Q
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  I $$VAL^XBDIQ1(9000010.07,X,.01)="V65.3" S G=D
 ..I G Q
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  S Z=$$VAL^XBDIQ1(9000010.07,X,.01) I Z=97802!(Z=97803)!(Z=97804) S G=D
 ..S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 ..I G Q
 ..S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVPED(X,0),U)
 ...I T,$D(^ATXAX(T,21,"AA",Y)) S G=D
 ...S J=$P(^AUTTEDT(Y,0),U,2)
 ...I $P(J,"-",2)="N" S G=D Q
 ...I $P(J,"-",2)="DT" S G=D Q
 ...I $P(J,"-",2)="MNT" S G=D Q
 ...I $P(J,"-",1)="MNT" S G=D Q
 .Q
 Q G
PC(V) ;return provider discipline of educ provider
 I 'V Q ""
 NEW X S X=$P(^AUPNVPED(V,0),U,5)
 I 'X Q ""
 I $P(^DD(9000010.16,.05,0),U,2)[200 Q $$PROVCLSC^XBFUNC1(X)
 NEW A S A=$P(^DIC(6,X,0),U,4)
 I 'A Q ""
 Q $P($G(^DIC(7,A,9999999)),U)
EXEDUC(P,BDATE,EDATE) ;EP
 NEW D,BD,ED,X,Y,%DT,D,G,APCLVRD,V,APCL,RD,NRD
 S (RD,NRD)=""
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S D=9999999-ED,(RD,NRD)="",G="" ;is this right???
 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!(D>(9999999-BD))!(G]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:'$D(^AUPNVPOV("AD",V))
 ..Q:'$D(^AUPNVPRV("AD",V))
 ..Q:$$DNKA^BDMD917(V)
 ..Q:$P(^AUPNVSIT(V,0),U,3)="C"
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  I $$VAL^XBDIQ1(9000010.07,X,.01)="V65.41" S G=D
 ..I G Q
 ..S T=$O(^ATXAX("B","DM AUDIT EXERCISE EDUC TOPICS",0))
 ..S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVPED(X,0),U)
 ...I T,$D(^ATXAX(T,21,"AA",Y)) S G=D
 ...S J=$P(^AUTTEDT(Y,0),U,2)
 ...I $P(J,"-",2)="EX" S G=D Q
 .Q
 Q G
OTHEDUC(P,BDATE,EDATE) ;EP
 NEW D,BD,ED,X,Y,%DT,D,G,APCLVRD,V,APCL,RD,NRD
 S (RD,NRD)=""
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S D=9999999-ED,(RD,NRD)="",G="" ;is this right???
 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!(D>(9999999-BD))!(G]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:'$D(^AUPNVPOV("AD",V))
 ..Q:'$D(^AUPNVPRV("AD",V))
 ..Q:$$DNKA^BDMD917(V)
 ..Q:$P(^AUPNVSIT(V,0),U,3)="C"
 ..S T=$O(^ATXAX("B","DM AUDIT OTHER EDUC TOPICS",0))
 ..S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVPED(X,0),U)
 ...S J=$P(^AUTTEDT(Y,0),U,2)
 ...I $P(J,"-",2)="EX" Q
 ...I $P(J,"-",2)="N" Q
 ...I $P(J,"-",2)="DT" Q
 ...I $P(J,"-",2)="MNT" Q
 ...I $P(J,"-",1)="MNT" Q
 ...I T,$D(^ATXAX(T,21,"AA",Y)) S G=D
 ...I $P(J,"-",1)="250" S G=D
 ...I $P(J,"-",1)="DM" S G=D
 ...I $P(J,"-",1)="DMC" S G=D
 .Q
 Q G
