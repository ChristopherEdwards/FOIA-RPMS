BGPD14 ; IHS/CMI/LAB - indicator 14 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I14 ;EP ;EP - indicator 14
 ;Q:'$D(BGPIND(19))
 Q:'BGPDMPAT
 S BGPP=$$DENT00(DFN,BGPEDATE)
 I BGPP]"" D S(BGPRPT,$S(BGPTIME=1:15,BGPTIME=0:45,BGPTIME=8:85,1:999),17,1)
 I $D(BGPLIST(21)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",21,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=BGPP
 Q
S(R,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(^BGPD(R,N),U,P)=$P($G(^BGPD(R,N)),U,P)+V
 Q
 ;
DNKA(V) ;is this a DNKA visit?
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D=".0860" Q 1
 S N=$$PRIMPOV^APCLV(V,"N")
 I $E(D)="V",N["DNKA" Q 1
 I $E(D)="V",N["DID NOT KEEP APPOINTMENT" Q 1
 I $E(D)="V",N["DID NOT KEEP APPT" Q 1
 Q 0
DENT00(P,EDATE) ;
 NEW BGPG,X,%,E,R,V,BDATE
 K BGPG
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 S %=P_"^LAST ADA 0000;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q "Yes - "_$$FMTE^XLFDT($P(BGPG(1),U))
 ;look for dental clinic or dental provider visit date
 K BGPG
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 NEW X,Y S X=0,Y="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y]"")  I $$CLINIC^APCLV($P(^TMP($J,"A",X),U,5),"C")=56,'$$DNKA($P(^TMP($J,"A",X),U,5)) S Y="Yes - "_$$FMTE^XLFDT($P(^TMP($J,"A",X),U))
 I Y]"" Q Y
 S X=0,Y="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(Y]"")  I $$PRIMPROV^APCLV($P(^TMP($J,"A",X),U,5),"D")=52,'$$DNKA($P(^TMP($J,"A",X),U,5)) S Y="Yes - "_$$FMTE^XLFDT($P(^TMP($J,"A",X),U))
 Q Y
 Q ""
