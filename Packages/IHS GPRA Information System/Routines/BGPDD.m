BGPDD ; IHS/CMI/LAB - indicator D ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
ID ;EP ;EP - indicator D
 ;Q:'$D(BGPIND(30))
 Q:'$$DM^BGPD1(DFN,BGPEDATE)
 S BGPP=$$EYE(DFN,BGPEDATE)
 I BGPP]"" D S(BGPRPT,$S(BGPTIME=1:17,BGPTIME=0:47,BGPTIME=8:87,1:999),4,1)
 I $D(BGPLIST(30)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",30,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=BGPP
 Q
S(R,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(^BGPD(R,N),U,P)=$P($G(^BGPD(R,N)),U,P)+V
 Q
 ;
REFR(V) ;
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D="367.89"!(D="367.9")!($E(D,1,5)=372.0)!($E(D,1,5)=372.1) Q 1
 Q 0
DNKA(V) ;is this a DNKA visit?
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D=".0860" Q 1
 S N=$$PRIMPOV^APCLV(V,"N")
 I $E(D)="V",N["DNKA" Q 1
 I $E(D)="V",N["DID NOT KEEP APPOINTMENT" Q 1
 I $E(D)="V",N["DID NOT KEEP APPT" Q 1
 Q 0
EYE(P,EDATE) ;
 NEW BDATE,BGPG,%,E,T,T1,T2,T3 K BGPG S BDATE=$$FMADD^XLFDT(EDATE,-365),%=P_"^LAST EXAM DIABETIC EYE EXAM;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q "Yes-Diabetic Eye Exam"
 S BD=BDATE
 S ED=EDATE
 S T=+$$CODEN^ICPTCOD(92250),T1=+$$CODEN^ICPTCOD(92012),T2=+$$CODEN^ICPTCOD(92014),T3=+$$CODEN^ICPTCOD(92015)
 I T,$D(^AUPNVCPT("AA",P,T)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-Fundus Photography"
 ..Q
 .Q
 I T1,$D(^AUPNVCPT("AA",P,T1)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T1,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-Eye Exam/Est Pat"
 ..Q
 .Q
 I T2,$D(^AUPNVCPT("AA",P,T2)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T2,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-Comp eye exam"
 ..Q
 .Q
 I T3,$D(^AUPNVCPT("AA",P,T3)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T3,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-CPT 92015"
 ..Q
 .Q
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 NEW X,Y,R S (X,Y)=0 F  S X=$O(BGPG(X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(BGPG(X),U,5),"D") I (R=24!(R=79)!(R="08")),'$$DNKA($P(BGPG(X),U,5)) S Y=1
 I Y Q "Yes-Optometrist/Opthamalogist Visit"
 S X=0,Y=0 F  S X=$O(BGPG(X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(BGPG(X),U,5),"C") I (R=17!(R=18)!(R=64)!(R="A2")),'$$DNKA($P(BGPG(X),U,5)) S Y=1
 I Y Q "Yes-Optometry/Opthamology Clinic"
 Q ""
