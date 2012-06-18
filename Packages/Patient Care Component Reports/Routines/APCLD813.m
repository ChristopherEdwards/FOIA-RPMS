APCLD813 ; IHS/CMI/LAB - 2008 DIABETES AUDIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;LORI - ADD V04,81
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning in PLDMDXS
 ;
FLU(P,BDATE,EDATE) ;EP
 NEW APCL,X,E,%,%DT,BD,B,D,C,Y,LFLU,TFLU,Z,G,T
 S X=EDATE,%DT="P" D ^%DT S (BD,E)=Y
 S (B,BD)=$$FMADD^XLFDT(BD,-(15*30)),BD=$$FMTE^XLFDT(BD)
 ;B-int fm beg
 ;E-int fm end
 S LFLU="" K TFLU
 I $$BI D LASTFLUN
 I '$$BI D LASTFLUO
 S LFLU=$O(TFLU(0))
 I LFLU]"" S LFLU=9999999-LFLU
 K APCL S %=P_"^LAST DX V04.8;DURING "_BD_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LFLU>$P(APCL(1),U)
 .S LFLU=$P(APCL(1),U)
 K APCL S %=P_"^LAST DX V04.81;DURING "_BD_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LFLU>$P(APCL(1),U)
 .S LFLU=$P(APCL(1),U)
 K APCL S %=P_"^LAST DX V06.6;DURING "_BD_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LFLU>$P(APCL(1),U)
 .S LFLU=$P(APCL(1),U)
 K APCL S %=P_"^LAST PROCEDURE 99.52;DURING "_BD_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) D
 .Q:LFLU>$P(APCL(1),U)
 .S LFLU=$P(APCL(1),U)
 ;check CPT codes in year prior to date range
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S X=BD,%DT="P" D ^%DT S BD=Y
 S T=$O(^ATXAX("B","DM AUDIT FLU CPTS",0))
 K APCL I T S APCL(1)=$$CPT^APCLD812(P,BD,ED,T,3) D
 .I APCL(1)="" K APCL Q
 .Q:LFLU>$P(APCL(1),U)
 .S LFLU=$P(APCL(1),U)
 I LFLU]"" Q "Yes  "_$$DATE(LFLU)
 ;
 NEW G S G=$$REFUSAL^APCLD817(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:88,1:12),0)),BD,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^APCLD817(P,9999999.14,$O(^AUTTIMM("C",15,0)),BD,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^APCLD817(P,9999999.14,$O(^AUTTIMM("C",16,0)),BD,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^APCLD817(P,9999999.14,$O(^AUTTIMM("C",111,0)),BD,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G="" F Z=15,16,88,111 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=1
 I G Q "Refused"
 Q "No"
PNEU(P,EDATE) ;EP
 NEW APCL,X,E,B,%DT,Y,TPN,D,LPN,G,C,Z,T
 K TPN
 S %DT="P",X=EDATE D ^%DT S E=Y  ;set E = ending date in fm format
 S B=$$DOB^AUPNPAT(P) ;b is DOB
 I '$$BI D LASTPNO ;pre v7
 I $$BI D LASTPNN ;get td from v imm
 S LPN=$O(TPN(0))
 I LPN]"" S LPN=9999999-LPN
 ;now check cpt codes
 S T=$O(^ATXAX("B","DM AUDIT PNEUMO CPTS",0))
 K C I T S C=$$CPT^APCLD812(P,B,E,T,3) D
 .I C="" Q
 .Q:LPN>$P(C,U)
 .S LPN=$P(C,U)
 I LPN]"" Q "Yes - "_$$DATE(LPN)
 S G=$$REFUSAL^APCLD817(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:33,1:19),0)),$$DOB^AUPNPAT(P,"E"),EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 I '$$BI Q "No"
 S G=$$REFUSAL^APCLD817(P,9999999.14,$O(^AUTTIMM("C",100,0)),$$DOB^AUPNPAT(P,"E"),EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S G=$$REFUSAL^APCLD817(P,9999999.14,$O(^AUTTIMM("C",109,0)),$$DOB^AUPNPAT(P,"E"),EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "No - Not Medically Indicated"
 S X=EDATE,%DT="P" D ^%DT S E=Y
 S G="" F Z=33,100,109 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=1
 I G Q "Refused"
 Q "No"
LASTFLUN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=88 S TFLU(9999999-D)="" Q
 .I Y=15 S TFLU(9999999-D)="" Q
 .I Y=16 S TFLU(9999999-D)="" Q
 .I Y=111 S TFLU(9999999-D)="" Q
 Q
LASTFLUO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=12 S TFLU(9999999-D)="" Q
 Q
LASTPNN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=33 S TPN(9999999-D)="" Q
 .I Y=100 S TPN(9999999-D)="" Q
 .I Y=109 S TPN(9999999-D)="" Q
 Q
LASTPNO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=19 S TPN(9999999-D)="" Q
 Q
BI() ;
 Q $S($O(^AUTTIMM(0))>100:1,1:0)
BPS(P,BDATE,EDATE,F) ;EP ;
 I $G(F)="" S F="E"
 NEW X,APCL,E,APCLL,APCLLL,APCLV
 S APCLLL=0,APCLV=""
 K APCL
 S X=P_"^LAST 50 MEAS BP;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 S APCLL=0 F  S APCLL=$O(APCL(APCLL)) Q:APCLL'=+APCLL!(APCLLL=3)  S APCLBP=$P($G(APCL(APCLL)),U,2) D
 .Q:$$CLINIC^APCLV($P(APCL(APCLL),U,5),"C")=30
 .S APCLLL=APCLLL+1
 .I F="E" S $P(APCLV,";",APCLLL)=APCLBP_"  "_$$FMTE^XLFDT($P(APCL(APCLL),U))
 .I F="I" S $P(APCLV,";",APCLLL)=$P(APCLBP," ")
 Q APCLV
HTNDX(P,EDATE) ;EP - is HTN on problem list
 I '$G(P) Q ""
 I '$D(^DPT(P)) Q ""
 NEW %,APCL,E,X
 K APCL
 S %=P_"^PROBLEM [DM AUDIT PROBLEM HTN DIAGNOSES" S E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) Q "Yes"
 K APCL
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(") I $D(APCL(3)) Q "Yes"
 Q "No"
LASTHT(P,EDATE,F) ;PEP - return last ht and date
 I 'P Q ""
 I $G(F)="" S F="E"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW %,APCLARRY,H,E,W,BDATE
 S %DT="P",X=EDATE D ^%DT S EDATE=Y
 S BDATE=$P(^DPT(P,0),U,3)
 S %=P_"^LAST MEAS HT;DURING "_BDATE_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"APCLARRY(") S H=$P($G(APCLARRY(1)),U,2)
 I H="" Q H
 I F="I" Q H
 S H=$J(H,5,2)
 Q H_" inches "_$$DATE($P(APCLARRY(1),U))
LASTWT(P,EDATE,F) ;PEP - return last wt
 I 'P Q ""
 I $G(F)="" S F="E"
 NEW %,APCLARRY,E,APCLW,X,APCLN,APCL,APCLD,APCLZ,APCLX,W,H
 S %DT="P",X=EDATE D ^%DT S EDATE=Y
 S BDATE=$$FMADD^XLFDT(EDATE,-(2*365))
 NEW APCLV221 S APCLV221=$O(^ICD9("BA","V22.1 ",""))
 K APCL S APCLW="" S APCLX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(APCLX,"APCL(")
 S APCLN=0 F  S APCLN=$O(APCL(APCLN)) Q:APCLN'=+APCLN!(APCLW]"")  D
 . S APCLZ=$P(APCL(APCLN),U,5)
 . I '$D(^AUPNVPOV("AD",APCLZ)) S APCLW=$P(APCL(APCLN),U,2)_" lbs "_$$DATE($P(APCL(APCLN),U)) Q
 . S APCLD=0 F  S APCLD=$O(^AUPNVPOV("AD",APCLZ,APCLD)) Q:'APCLD!(APCLW]"")  D
 .. I $P(^AUPNVPOV(APCLD,0),U)'=APCLV221 S APCLW=$P(APCL(APCLN),U,2)_" lbs "_$$DATE($P(APCL(APCLN),U))
 ..Q
 Q $S(F="E":APCLW,1:+APCLW)
CMSFDX(P,R,T) ;EP - return date/dx of dm in register
 I '$G(P) Q ""
 I '$G(R) Q ""
 I $G(T)="" Q ""
 NEW D1,Y,X,D,G S X=0,(D,Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X  I $P(^ACM(44,X,0),U,4)=R D
 .S D=$P($G(^ACM(44,X,"SV")),U,2),D1=D,D=$$FMTE^XLFDT(D)
 .S Y=$$VAL^XBDIQ1(9002244,X,.01)
 .I D1="" S D1=0
 .S G(9999999-D1)=D_"^"_D1_"^"_Y
 I '$O(G(0)) Q ""
 S Y=0,G=$O(G(Y))
 S D=$P(G(G),U),D1=$P(G(G),U,2),Y=$P(G(G),U,3)
 Q $S(T="D":$G(D),T="DX":$G(Y),T="ID":$G(D1),1:"")
 ;
PLDMDOO(P,F) ;EP
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 ..Q
 .Q
 S D=$O(D(0)) Q $S(F="E":$$FMTE^XLFDT(D),1:$O(D(0)))
PLDMDXS(P) ;EP - get all DM dxs from problem list
 I '$G(P) Q ""
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q "<diabetes taxonomy missing>"
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .;I $$ICD^ATXCHK(I,T,9) S:D]"" D=D_";" S D=D_$P(^ICD9(I,0),U)  ;cmi/anch/maw 9/12/2007 orig line
 .I $$ICD^ATXCHK(I,T,9) S:D]"" D=D_";" S D=D_$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .Q
 Q D
 ;
FRSTDMDX(P,F) ;EP return date of first dm dx
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW X,E,APCL,Y
 S Y="APCL("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y) S Y=$P($G(APCL(1)),U)
 Q $S(F="E":$$FMTE^XLFDT(Y),1:Y)
LASTDMDX(P,D) ;EP - last pcc dm dx
 I '$G(P) Q ""
 NEW X,E,APCL,Y
 S Y="APCL("
 S X=P_"^LAST DX [DM AUDIT TYPE II DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(APCL(1)) Q "Type 2"
 K APCL S X=P_"^LAST DX [DM AUDIT TYPE I DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(APCL(1)) Q "Type 1"
 Q ""
INCHES ;
 NEW F,FI,Z
 S (X,Z)=$$LASTHT^APCLD813(APCLPD,APCLRED,"I")
 Q:X=""
 S X=X/12  ;get feet
 S F=$P(X,".")
 S FI=F*12  ;GET INCHES
 S X=Z-FI
 S X=$J(X,5,2)
 ;W !,Z,"  ",F,"  ",FI,"  ",X H 1
 ;I X S X=X/12,X=$P(X,"."),X=X*12,X=Z=X,X=$J(X,5,2)
 Q
DATE(D) ;EP
 I D="" Q D
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
