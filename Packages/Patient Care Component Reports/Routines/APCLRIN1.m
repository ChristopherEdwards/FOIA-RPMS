APCLRIN1 ; IHS/CMI/LAB - INTERNET ACCESS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
ALL(P,EDATE,T,B) ;EP - is this patient in user pop?
 S T=$G(T)
 S B=$G(B)
 I B=1,$$BEN^AUPNPAT(P,"C")'="01" Q 0  ;must be Indian/Alaskan Native
 I B=2,$$BEN^AUPNPAT(P,"C")="01" Q 0  ;must not be I/A
 S DOD=$$DOD^AUPNPAT(P) I DOD]"",DOD<EDATE Q 0
 I 'T Q 1
 S X=$P($G(^AUPNPAT(P,11)),U,18) I X="" Q 0
 I '$D(^ATXAX(T,21,"B",($P(^AUPNPAT(P,11),U,18)))),'$D(^ATXAX(T,21,"AA",$P(^AUPNPAT(P,11),U,18),$P(^AUPNPAT(P,11),U,18))) Q 0
 Q 1
 ;
UP(P,BDATE,EDATE,T,B) ;EP - is this patient in user pop?
 S T=$G(T)
 S B=$G(B)
 I B=1,$$BEN^AUPNPAT(P,"C")'="01" Q 0  ;must be Indian/Alaskan Native
 I B=2,$$BEN^AUPNPAT(P,"C")="01" Q 0  ;must not be I/A
 S DOD=$$DOD^AUPNPAT(P) I DOD]"",DOD<EDATE Q 0
 I T D  I X="" Q 0
 .S X=$P($G(^AUPNPAT(P,11)),U,18) I X="" Q
 .I '$D(^ATXAX(T,21,"B",($P(^AUPNPAT(P,11),U,18)))),'$D(^ATXAX(T,21,"AA",$P(^AUPNPAT(P,11),U,18),$P(^AUPNPAT(P,11),U,18))) S X="" Q
 S X=$$LASTVD(P,BDATE,EDATE)
 Q $S(X:1,1:0)
 ;
ACTCL(P,BDATE,EDATE,APCLTAXI,APCLBEN,CHS) ;EP - clinical user
 NEW X,GY,F,S,V
 S T=$G(T)
 S B=$G(B)
 I B=1,$$BEN^AUPNPAT(P,"C")'="01" Q 0  ;must be Indian/Alaskan Native
 I B=2,$$BEN^AUPNPAT(P,"C")="01" Q 0  ;must not be I/A
 S DOD=$$DOD^AUPNPAT(P) I DOD]"",DOD<EDATE Q 0
 I T D  I X="" Q 0
 .S X=$P($G(^AUPNPAT(P,11)),U,18) I X="" Q
 .I '$D(^ATXAX(T,21,"B",($P(^AUPNPAT(P,11),U,18)))),'$D(^ATXAX(T,21,"AA",$P(^AUPNPAT(P,11),U,18),$P(^AUPNPAT(P,11),U,18))) S X="" Q
 S X=$$LASTVD(P,BDATE,EDATE)
 I CHS G CHSACTCL
 NEW GY
 S X=0 F  S X=$O(^BGPCTRL("B",X)) Q:X'=+X  S GY=X
 S GY=$O(^BGPCTRL("B",GY,0))
 S (X,G,F,S)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(F)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(APCLMFIY),'$D(^ATXAX(APCLMFIY,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S B=$$CLINIC^APCLV(V,"C")
 .Q:B=""
 .I 'G,$D(^BGPCTRL(GY,11,"B",B)) S G=V  ;must be a primary clinic S G=V
 .I V'=G,$D(^BGPCTRL(GY,12,"B",B)) S S=1
 .I G,S S F=1
 .Q
 Q $S(F:1,1:0)
 ;
LASTVD(P,BDATE,EDATE) ;
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(APCLMFIY),'$D(^ATXAX(APCLMFIY,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S G=1
 .Q
 Q G
 ;
CHSACTCL ;chs only sites active clinical defintion
 ;2 chs visits in past 3 years
 S (X,G,F,S)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(F>1)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHOI"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"C"'[$P(^AUPNVSIT(V,0),U,3)
 .S F=F+1
 Q $S(F>1:1,1:0)
 ;
