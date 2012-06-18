ACDRLU2 ;IHS/ADC/EDE/KML - UTILITY ROUTINE;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
DATA(V,F,F1,F2) ;EP - get data item
 I $G(F)="" S F="E"
 NEW %,I
 S %=""
 I $G(F1)="" Q %
 I $G(F2)="" Q %
 I $D(^ACDIIF("C",V)) D  Q %
 .S I=$O(^ACDIIF("C",V,0))
 .S %=$S(F="I":$$VALI^XBDIQ1(9002170,I,F1),1:$$VAL^XBDIQ1(9002170,I,F1))
 .Q
 I $D(^ACDTDC("C",V)) D  Q %
 .S I=$O(^ACDTDC("C",V,0))
 .S %=$S(F="I":$$VALI^XBDIQ1(9002171,I,F2),1:$$VAL^XBDIQ1(9002171,I,F2))
 .Q
 Q %
DRUG ;EP
 K X
 NEW %,I,%1
 S %=""
 I $D(^ACDIIF("C",ACDR)) D  Q
 .S I=$O(^ACDIIF("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDIIF(I,2,%1)) Q:%1'=+%1  S X($P(^ACDIIF(I,2,%1,0),U))=""
 .Q
 I $D(^ACDTDC("C",ACDR)) D  Q
 .S I=$O(^ACDTDC("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDTDC(I,2,%1)) Q:%1'=+%1  S X($P(^ACDTDC(I,2,%1,0),U))=""
 .Q
 Q
DRUGP ;EP
 K ACDPRNM
 S ACDPCNT=0
 NEW %,I,%1
 S %=""
 I $D(^ACDIIF("C",ACDR)) D  Q
 .S I=$O(^ACDIIF("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDIIF(I,2,%1)) Q:%1'=+%1  S ACDPCNT=ACDPCNT+1,ACDPRNM(ACDPCNT)=$P(^ACDDRUG($P(^ACDIIF(I,2,%1,0),U),0),U)
 .Q
 I $D(^ACDTDC("C",ACDR)) D  Q
 .S I=$O(^ACDTDC("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDTDC(I,2,%1)) Q:%1'=+%1  S ACDPCNT=ACDPCNT+1,ACDPRNM(ACDPCNT)=$P(^ACDDRUG($P(^ACDTDC(I,2,%1,0),U),0),U)
 .Q
 Q
OTHPROB ;EP
 K X
 NEW %,I,%1
 S %=""
 I $D(^ACDIIF("C",ACDR)) D  Q
 .S I=$O(^ACDIIF("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDIIF(I,3,%1)) Q:%1'=+%1  S X($P(^ACDIIF(I,3,%1,0),U))=""
 .Q
 I $D(^ACDTDC("C",ACDR)) D  Q
 .S I=$O(^ACDTDC("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDTDC(I,3,%1)) Q:%1'=+%1  S X($P(^ACDTDC(I,3,%1,0),U))=""
 .Q
 Q
OTHPROBP ;EP
 K ACDPRNM
 S ACDPCNT=0
 NEW %,I,%1
 S %=""
 I $D(^ACDIIF("C",ACDR)) D  Q
 .S I=$O(^ACDIIF("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDIIF(I,3,%1)) Q:%1'=+%1  S ACDPCNT=ACDPCNT+1,ACDPRNM(ACDPCNT)=$P(^ACDPROB($P(^ACDIIF(I,3,%1,0),U),0),U)
 .Q
 I $D(^ACDTDC("C",ACDR)) D  Q
 .S I=$O(^ACDTDC("C",ACDR,0))
 .S %1=0 F  S %1=$O(^ACDTDC(I,3,%1)) Q:%1'=+%1  S ACDPCNT=ACDPCNT+1,ACDPRNM(ACDPCNT)=$P(^ACDPROB($P(^ACDTDC(I,3,%1,0),U),0),U)
 .Q
 Q
HOURS ;EP
 K X
 NEW %,I,%1
 S %=""
 I $D(^ACDIIF("C",ACDR)) D  Q
 .S I=$O(^ACDIIF("C",ACDR,0))
 .S X=$$VALI^XBDIQ1(9002170,I,102) I X S X(X)=""
 .Q
 I $D(^ACDTDC("C",ACDR)) D  Q
 .S I=$O(^ACDTDC("C",ACDR,0))
 .S X=$$VALI^XBDIQ1(9002171,I,29) I X S X(X)=""
 .Q
 I $D(^ACDCS("C",ACDR)) D
 .S I=0 F  S I=$O(^ACDCS("C",ACDR,I)) Q:I'=+I  S Y=$$VALI^XBDIQ1(9002172,I,3) I Y S X(Y)=""
HOURSP ;EP
 K X
 NEW %,I,%1
 S %=""
 I $D(^ACDIIF("C",ACDR)) D  Q
 .S I=$O(^ACDIIF("C",ACDR,0))
 .S X=$$VAL^XBDIQ1(9002170,I,102) I X S ACDPRNM(1)=X
 .Q
 I $D(^ACDTDC("C",ACDR)) D  Q
 .S I=$O(^ACDTDC("C",ACDR,0))
 .S X=$$VAL^XBDIQ1(9002171,I,29) I X S ACDPRNM(1)=X
 .Q
 I $D(^ACDCS("C",ACDR)) D
 .S I=0 F  S I=$O(^ACDCS("C",ACDR,I)) Q:I'=+I  S Y=$$VAL^XBDIQ1(9002172,I,3) I Y S ACDPCNT=ACDPCNT+1,ACDPRNM(ACDPCNT)=Y
 Q
PPPROB ;EP - called from patient lister
 ;sets X(ien of problem) equal to all primary problems this patient
 ;had between ACDBD and ACDED (beginning and ending dates)
 Q:'$G(DFN)  ;no patient passed
 K X
 NEW Y,V,I
 S V=0 F  S V=$O(^ACDVIS("D",DFN,V)) Q:V'=+V  S I=$P($P(^ACDVIS(V,0),U),".") I I'<ACDBD,I'>ACDED D
 .S Y=0 F  S Y=$O(^ACDIIF("C",V,Y)) Q:Y'=+Y  S X($P(^ACDIIF(Y,0),U))=""
 Q
PAPROB ;EP - called from patient list
 ;sets X(ien of problem) equal to all other problems this patient
 ;had between ACDBD and ACDED (beginning and ending dates)
 Q:'$G(DFN)  ;no patient passed
 K X
 NEW Y,V,I,A,B
 S V=0 F  S V=$O(^ACDVIS("D",DFN,V)) Q:V'=+V  S I=$P($P(^ACDVIS(V,0),U),".") I I'<ACDBD,I'>ACDED D
 .S I=0 F   S I=$O(^ACDIIF("C",V,I)) Q:I'=+I  D
 ..S %=0 F  S %=$O(^ACDIIF(I,3,%)) Q:%'=+%  S X($P(^ACDIIF(I,3,%,0),U))=""
 .S I=0 F  S I=$O(^ACDTDC("C",ACDR,I)) Q:I'=+I  D
 ..S %=0 F  S %=$O(^ACDTDC(I,3,%)) Q:%'=+%  S X($P(^ACDTDC(I,3,%,0),U))=""
 Q
PPPROV ;EP - called from patient lister
 ;sets X(ien of problem) equal to all primary providers this patient
 ;had between ACDBD and ACDED (beginning and ending dates)
 Q:'$G(DFN)  ;no patient passed
 K X
 NEW Y,V,I
 S V=0 F  S V=$O(^ACDVIS("D",DFN,V)) Q:V'=+V  S I=$P($P(^ACDVIS(V,0),U),".") I I'<ACDBD,I'>ACDED I $P(^ACDVIS(V,0),U,3) S X($P(^ACDVIS(V,0),U,3))=""
 Q
PCOMPC ;EP
 ;sets X(ien of problem) equal to all components this patient
 ;had between ACDBD and ACDED (beginning and ending dates)
 Q:'$G(DFN)  ;no patient passed
 K X
 NEW Y,V,I
 S V=0 F  S V=$O(^ACDVIS("D",DFN,V)) Q:V'=+V  S I=$P($P(^ACDVIS(V,0),U),".") I I'<ACDBD,I'>ACDED I $P(^ACDVIS(V,0),U,2)]"" S X($P(^ACDVIS(V,0),U,2))=""
 Q
PCOMPT ;EP
 ;sets X(ien of problem) equal to all component types this patient
 ;had between ACDBD and ACDED (beginning and ending dates)
 Q:'$G(DFN)  ;no patient passed
 K X
 NEW Y,V,I
 S V=0 F  S V=$O(^ACDVIS("D",DFN,V)) Q:V'=+V  S I=$P($P(^ACDVIS(V,0),U),".") I I'<ACDBD,I'>ACDED I $P(^ACDVIS(V,0),U,7)]"" S X($P(^ACDVIS(V,0),U,7))=""
 Q
PDRUG ;EP
 ;sets X(ien of problem) equal to all drug types this patient
 ;had between ACDBD and ACDED (beginning and ending dates)
 Q:'$G(DFN)  ;no patient passed
 K X
 NEW Y,V,I,A,B
 S V=0 F  S V=$O(^ACDVIS("D",DFN,V)) Q:V'=+V  S I=$P($P(^ACDVIS(V,0),U),".") I I'<ACDBD,I'>ACDED D
 .S I=0 F   S I=$O(^ACDIIF("C",V,I)) Q:I'=+I  D
 ..S %=0 F  S %=$O(^ACDIIF(I,2,%)) Q:%'=+%  S X($P(^ACDIIF(I,2,%,0),U))=""
 .S I=0 F  S I=$O(^ACDTDC("C",ACDR,I)) Q:I'=+I  D
 ..S %=0 F  S %=$O(^ACDTDC(I,2,%)) Q:%'=+%  S X($P(^ACDTDC(I,2,%,0),U))=""
 Q
