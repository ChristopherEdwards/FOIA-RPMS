BGPD8 ; IHS/CMI/LAB - indicator 8 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I8 ;EP ;EP - indicator 8
 ;Q:'$D(BGPIND(18))
 S BGPAMON=$$MON(DFN,BGPBDATE,BGPEDATE)
 I BGPAMON D
 .D S(BGPRPT,$S(BGPTIME=1:15,BGPTIME=0:45,BGPTIME=8:85,1:999),10,1)
 .S BGPP=$$WCV(DFN)
 .I BGPP>3 D S(BGPRPT,$S(BGPTIME=1:15,BGPTIME=0:45,BGPTIME=8:85,1:999),11,1)
 .I $D(BGPLIST(18)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",18,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=BGPP
 Q
S(R,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(^BGPD(R,N),U,P)=$P($G(^BGPD(R,N)),U,P)+V
 Q
 ;
WCPV(V) ;
 I '$G(V) Q ""
 NEW X,I,G S (X,G)=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G)  S I=$P(^AUPNVPOV(X,0),U),I=$P($$ICDDX^ICDCODE(I),U,2) I I="V20.1"!(I="V20.2") S G=1
 Q G
WCV(P) ;
 ;return # of well child visits between dob and 27 month birthday
 NEW C S C=0
 I '$D(^AUPNVSIT("AA",P)) Q C
 NEW B S B=$P(^DPT(P,0),U,3)
 I B="" Q C
 NEW X,E S E=$$FMADD^XLFDT(B,(27*30.42))
 S X=0 F  S X=$O(^AUPNVSIT("AC",P,X)) Q:X'=+X  S D=$P($P(^AUPNVSIT(X,0),U),".") I D<E,'$$DNKA(X),$$CLINIC^APCLV(X,"C")=24!($$CLINIC^APCLV(X,"C")=27)!($$CLINIC^APCLV(X,"C")=57)!($$WCPV(X)) S C=C+1
 Q C
DNKA(V) ;is this a DNKA visit?
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D=".0860" Q 1
 S N=$$PRIMPOV^APCLV(V,"N")
 I $E(D)="V",N["DNKA" Q 1
 I $E(D)="V",N["DID NOT KEEP APPOINTMENT" Q 1
 I $E(D)="V",N["DID NOT KEEP APPT" Q 1
 Q 0
MON(P,BDATE,EDATE) ;EP
 ;is patient's 27 month BD during time frame
 NEW D,X
 S D=$P(^DPT(DFN,0),U,3)
 S D=$$FMADD^XLFDT(D,(30.42*27)) ;d=date turning 27 months
 I BDATE>D Q ""
 I EDATE<D Q ""
 Q 1
