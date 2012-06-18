BDMD81D ; IHS/CMI/LAB - BDM Continuation of BDMD81C 1/11/2008 1:54:57 PM ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;
 ;
MICRO ;EP
 NEW BDM,X,%,E,R,V,BDMLT,BDMOT,B,D,L,J,BDMC,BDMV,V
 K BDM S BDMC=0
 S BDMOT=$O(^ATXAX("B","DM AUDIT MICROALBUMIN LOINC",0))
 S BDMLT=$O(^ATXLAB("B","DM AUDIT MICROALBUMINURIA TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BDMLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BDMLT,21,"B",$P(^AUPNVLAB(X,0),U))) D SETV Q
 ...Q:'BDMOT
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,BDMOT)
 ...D SETV
 ...Q
 I '$D(BDM(1)) S %1="" D ACRATIOM^BDMD81C Q %1
 D SETN
 NEW % S %=$P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)
 S %1=$S(%="":"No result",%["+":"Pos ",%[">":"Pos ",$E(%)="P":"Pos ",$E(%)="p":"Pos ",$E(%)="c":"No result ",$E(%)="C":"No result ",+%>29:"Pos ",1:"Neg ")
 Q %1_%_" "_$$FMTE^XLFDT($P(BDM(N),U),"5")_" "_$P(BDM(N),U,3)
HGBA1C ;EP
 NEW BDM,X,%,E,R,V,BDMLT,BDMOT,B,D,L,J,BDMC,BDMV,V
 K BDM
 S BDMC=0
 S BDMOT=$O(^ATXAX("B","BGP HGBA1C LOINC CODES",0))
 S BDMLT=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BDMLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BDMLT,21,"B",$P(^AUPNVLAB(X,0),U))) D SETV Q
 ...Q:'BDMOT
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,BDMOT)
 ...D SETV
 ...Q
 D SET3
 K X S (%,C,R)="" F  S %=$O(BDM(%)) Q:%'=+%!(C>1)  S X(9999999-$P(BDM(%),U),1)=$P(^AUPNVLAB(+$P(BDM(%),U,4),0),U,4)
 S %=0,R="" F  S %=$O(X(%)) Q:%=""  S V=0 F  S V=$O(X(%,V)) Q:V=""  S R=R_X(%,V)_"^"_$$FMTE^XLFDT(9999999-%)_"^"_(9999999-%)_"^"
 Q R
BS ;EP
 NEW BDM,X,%,E,R,V,C
 K BDM
 S %=P_"^LAST 200 LAB [DM AUDIT GLUCOSE TESTS TAX;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 I '$D(BDM(1)) Q ""
 D SET3
 S (%,C,R)="" F  S %=$O(BDM(%)) Q:%=""!(C>2)  S R=R_$P(^AUPNVLAB(+$P(BDM(%),U,4),0),U,4)_$S($P(^AUPNVLAB(+$P(BDM(%),U,4),0),U,4)]"":" mg/dl ",1:"")_$$FMTE^XLFDT($P(BDM(%),U))_"^",C=C+1
 Q R
 ;
FGLUCOSE ;EP
 I $G(F)="" S F="E"
 NEW BDM,X,%,E,R,V,BDMLT,BDMOT,B,D,L,J,BDMC,BDMV,V
 K BDM
 S BDMC=0
 S BDMOT=$O(^ATXAX("B","DM AUDIT FASTING GLUC LOINC",0))
 S BDMLT=$O(^ATXLAB("B","DM AUDIT FASTING GLUCOSE TESTS",0))
 D GATHER
 I '$D(BDM(1)) Q ""
 D SETN
 I F="I" Q $P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)_"^"_$P(BDM(N),U)
 Q $P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)_$S($P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)]"":" mg/dl ",1:"")_$$FMTE^XLFDT($P(BDM(N),U),5)
G75 ;EP
 I $G(F)="" S F="E"
 NEW BDM,X,%,E,R,V,BDMLT,BDMOT,B,D,L,J,BDMC,BDMV,V
 K BDM
 S BDMC=0
 S BDMOT=$O(^ATXAX("B","DM AUDIT 75GM 2HR LOINC",0))
 S BDMLT=$O(^ATXLAB("B","DM AUDIT 75GM 2HR GLUCOSE",0))
 D GATHER
 I '$D(BDM(1)) Q ""
 D SETN
 I F="I" Q $P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)_"^"_$P(BDM(N),U)
 Q $P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)_$S($P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)]"":" mg/dl ",1:"")_$$FMTE^XLFDT($P(BDM(N),U),5)
 ;
GATHER ;
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!($D(BDM))  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BDMLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BDMLT,21,"B",$P(^AUPNVLAB(X,0),U))) D SETV Q
 ...Q:'BDMOT
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,BDMOT)
 ...D SETV
 ...Q
 I '$D(BDM(1)) Q
 S D=$P(BDM(1),U),D=9999999-D
 K BDM S BDMC=0
 S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVLAB(X,0))
 ..I BDMLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BDMLT,21,"B",$P(^AUPNVLAB(X,0),U))) D SETV Q
 ..Q:'BDMOT
 ..S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ..Q:'$$LOINC(J,BDMOT)
 ..D SETV
 ..Q
 Q
LOINC(A,B) ;EP - is loinc code A in taxonomy B
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
SETV ;
 S BDMC=BDMC+1
 S V=$P(^AUPNVLAB(X,0),U,3),BDMV=$P($P($G(^AUPNVSIT(V,0)),U),".") Q:'BDMV
 S BDM(BDMC)=BDMV_"^"_$S($P(^AUPNVLAB(X,0),U,4)]"":$P(^AUPNVLAB(X,0),U,4),1:"?")_"^"_$$VAL^XBDIQ1(9000010.09,X,.01)_"^"_X_";AUPNVLAB^"_V
 Q
SETN ;
 S N="" NEW A,G S (A,G)=0 F  S A=$O(BDM(A)) Q:A'=+A!(G)  S R=$P(^AUPNVLAB(+$P(BDM(A),U,4),0),U,4) I R]"",$$UP^XLFSTR(R)'="COMMENT" S G=A
 S N=$S(G:G,1:1)
 Q
SET3 ;
 NEW X,N1,N2,N3,A,T
 K A
 S X=0 F  S X=$O(BDM(X)) Q:X'=+X  S A($P(BDM(X),U),X)=""
 NEW D S D=0 F  S D=$O(A(D)) Q:D'=+D  D
 .S G=0,N=0 F  S N=$O(A(D,N)) Q:N'=+N  D
 ..I $P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)]"",$$UP^XLFSTR($P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4))'="COMMENT" S G=1 Q
 .I G S N=0 F  S N=$O(A(D,N)) Q:N'=+N  I $P(^AUPNVLAB(+$P(BDM(N),U,4),0),U,4)="" K BDM(N)
 .Q
 Q
