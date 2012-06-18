AUPNVPLC ; cmi/anch/maw - LIST MANAGER API'S FOR FAMILY HISTORY AND API FOR REP FACTORS
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
INPUT ;EP - called from input transform on Stage field
 NEW A,T,C,H,L
 S C=$P($G(^AUPNPROB(DA,0)),U)
 S A=0 F  S A=$O(^APCDPLCL(A)) Q:A'=+A!('$D(X))  D
 .S T=$P(^APCDPLCL(A,0),U,2)
 .Q:T=""
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .S L=$P(^APCDPLCL(A,0),U,3)
 .S H=$P(^APCDPLCL(A,0),U,4)
 .I X<L!(X>H) K X
 .Q
 Q
 ;
HELP ;EP - Executable help from stage field of V POV
 NEW A,T,C,H,L,G
 S G=0
 S C=$P($G(^AUPNPROB(DA,0)),U)
 S A=0 F  S A=$O(^APCDPLCL(A)) Q:A'=+A!(G)  D
 .S T=$P(^APCDPLCL(A,0),U,2)
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .S G=1
 .S H=0 F  S H=$O(^APCDPLCL(A,12,H)) Q:H'=+H  D
 ..D EN^DDIOL($G(^APCDPLCL(A,12,H,0)))
 .Q
 Q
 ;
 ;
 ;
ASKCL(C) ;EP - called from data entry input templates to determine whether CLASSIFICATION should be prompted for this icd diagnosis
 ;C is ien of the icd9 entry
 I $G(C)="" Q 0
 NEW A,T,H
 S A=0,H=0 F  S A=$O(^APCDPLCL(A)) Q:A'=+A!(H)  D
 .S T=$P(^APCDPLCL(A,0),U,2)
 .Q:T=""
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .S H=1
 .Q
 Q H
 ;
OUT(IEN,VAL) ;EP called from output transform
 I 'IEN Q VAL
 I $G(VAL)="" Q ""
 I '$D(^AUPNPROB(IEN,0)) Q VAL
 NEW C,A,T,H,G,J
 S C=$P(^AUPNPROB(IEN,0),U)
 S A=0,H=0,G="" F  S A=$O(^APCDPLCL(A)) Q:A'=+A!(G)  D
 .S T=$P(^APCDPLCL(A,0),U,2)
 .Q:T=""
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .I $D(^APCDPLCL(A,11,"B",VAL)) D
 ..S J=$O(^APCDPLCL(A,11,"B",VAL,0))
 ..Q:'J
 ..Q:'$D(^APCDPLCL(A,11,J,0))
 ..S VAL=VAL_"-"_$P(^APCDPLCL(A,11,J,0),U,2),G=1
 Q VAL
 ;
CAT(C) ;EP - called from health summary to get category for this icd code
 ;C is ien of the icd9 entry
 I $G(C)="" Q 0
 NEW A,T,H
 S A=0,H="" F  S A=$O(^APCDPLCL(A)) Q:A'=+A!(H]"")  D
 .S T=$P(^APCDPLCL(A,0),U,2)
 .Q:T=""
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .S H=$P(^APCDPLCL(A,0),U,1)
 .Q
 Q H
 ;
