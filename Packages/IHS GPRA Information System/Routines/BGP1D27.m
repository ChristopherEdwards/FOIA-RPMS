BGP1D27 ; IHS/CMI/LAB - measure I2 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
AMP(P,EDATE) ;EP - DID PATIENT HAVE AMPUTATION
 ;
 ;check cpt codes for bilateral
 ;loop through all cpt codes up to Edate and if any match quit
 S (X,Y,Z,G)=0 K BGPX
 S T=$O(^ATXAX("B","BGP FOOT AMP CPTS",0))
 I T S %="" D  I %]"" Q %
 .S Y=0 F  S Y=$O(^AUPNVCPT("AC",P,Y)) Q:Y'=+Y!(%]"")  D
 ..S D=$P($G(^AUPNVCPT(Y,0)),U,3)
 ..Q:D=""
 ..S D=$P($P($G(^AUPNVSIT(D,0)),U),".") ;date done
 ..Q:D=""
 ..I D>EDATE Q
 ..S X=$P(^AUPNVCPT(Y,0),U)
 ..Q:'$$ICD^ATXCHK(X,T,1)
 ..S BGPX(D)=""
 ..S M=$P(^AUPNVCPT(Y,0),U,8) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1_U_$$DATE^BGP1UTL(D)_" FOOT AMP "_$P(^ICPT(X,0),U,1)
 ..S M=$P(^AUPNVCPT(Y,0),U,9) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1_U_$$DATE^BGP1UTL(D)_" FOOT AMP "_$P(^ICPT(X,0),U,1)
 ..Q
 .Q
 ; now check tran codes
 I T,$D(^AUPNVTC("AC",P)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVTC("AC",P,E)) Q:E'=+E!(%]"")  D
 ..S D=$P($G(^AUPNVTC(E,0)),U,3) Q:'D  S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 ..Q:'$$ICD^ATXCHK($P(^AUPNVTC(E,0),U,7),T,1)
 ..S Y=$P(^AUPNVTC(E,0),U,7)
 ..I D>EDATE Q
 ..S BGPX(D)=""
 ..S M=$P(^AUPNVTC(E,0),U,12) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1_U_$$DATE^BGP1UTL(D)_" FOOT AMP "_$P(^ICPT(Y,0),U,1)
 ..S M=$P(^AUPNVTC(E,0),U,15) I M S M=$P($G(^AUTTCMOD(M,0)),U) I M=50 S %=1_U_$$DATE^BGP1UTL(D)_" FOOT AMP "_$P(^ICPT(Y,0),U,1)
 ..Q
 .Q
 ;see if 2 on different dates
 S %=0,X=0,C=0 F  S X=$O(BGPX(X)) Q:X'=+X  S C=C+1
 I C>1 Q 1
 ;S %=P_"^ALL PROCEDURE [BGP UNI MASTECTOMY PROCEDURES;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BGP(")
 S T=$O(^ATXAX("B","BGP FOOT AMP PROCEDURES",0))
 S (F,S)=0 F  S F=$O(^AUPNVPRC("AC",P,F)) Q:F'=+F  S C=$P(^AUPNVPRC(F,0),U) D
 .S G=0 S:$$ICD^ATXCHK(C,T,0) G=1
 .Q:G=0
 .S D=$P(^AUPNVPRC(F,0),U,6) I D="" S D=$P($P(^AUPNVSIT($P(^AUPNVPRC(F,0),U,3),0),U),".")
 .I D>EDATE Q
 .S BGPX(D)=""
 S %=0,X=0,C=0 F  S X=$O(BGPX(X)) Q:X'=+X  S C=C+1
 I C>1 Q 1
 Q 0
