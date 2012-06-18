BDMP71B ; IHS/CMI/LAB - get dm audit values ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
TD(P,EDATE) ;EP
 NEW BDM,X,E,B,%DT,Y,TDD,D,LTD,G,C,Z,T
 K TDD
 S %DT="P",X=EDATE D ^%DT S E=Y  ;set E = ending date in fm format
 S B=$$FMADD^XLFDT(E,-3653)  ;b is 10 years back from end date in fm format
 I '$$BI D LASTTDO ;pre v7
 I $$BI D LASTTDN ;get td from v imm
 S LTD=$O(TDD(0))
 I LTD]"" S LTD=9999999-LTD
 ;now check cpt codes
 S T=$O(^ATXAX("B","DM AUDIT TD CPTS",0))
 K C I T S C=$$CPT^BDMP712(P,B,E,T,3) D
 .I C="" Q
 .Q:LTD>$P(C,U)
 .S LTD=$P(C,U)
 I LTD]"" Q "Yes - "_$$FMTE^XLFDT(LTD)
 S C=$$FMTE^XLFDT(B) ;external form of beginning date
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:9,1:"02"),0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:1,1:"03"),0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:28,1:34),0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:20,1:42),0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:35,1:04),0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 I '$$BI Q "No"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",22,0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",50,0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",106,0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",107,0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^BDMP717(P,9999999.14,$O(^AUTTIMM("C",110,0)),C,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
TDBI ;
 S G="" F Z=1,9,20,22,28,35,50,106,107,110 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:D<B
 .Q:D>E
 .S G=1
 I G Q "Refused"
 Q "No"
 ;
LASTTDN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=1 S TDD(9999999-D)="" Q
 .I Y=9 S TDD(9999999-D)="" Q
 .I Y=20 S TDD(9999999-D)="" Q
 .I Y=22 S TDD(9999999-D)="" Q
 .I Y=28 S TDD(9999999-D)="" Q
 .I Y=35 S TDD(9999999-D)="" Q
 .I Y=50 S TDD(9999999-D)="" Q
 .I Y=106 S TDD(9999999-D)="" Q
 .I Y=107 S TDD(9999999-D)="" Q
 .I Y=110 S TDD(9999999-D)="" Q
 Q
 ;;
LASTTDO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I Y="04" S TDD(9999999-D)="" Q
 .I Y=42 S TDD(9999999-D)="" Q
 .I Y=34 S TDD(9999999-D)="" Q
 .I Y="03" S TDD(9999999-D)="" Q
 .I Y="02" S TDD(9999999-D)="" Q
 Q
BI() ;
 Q $S($O(^AUTTIMM(0))>100:1,1:0)
