BDMDA18 ; IHS/CMI/LAB - 2013 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**6**;JUN 14, 2007;Build 6
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning in WT
 ;
HT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,BDMARRY,H,E,D,W
 S E=$O(^AUTTMSR("B","HT",0))
 S H=""
 S D=0 F  S D=$O(^AUPNVMSR("AA",P,E,D)) Q:D'=+D!(H]"")  D
 .S W=0 F  S W=$O(^AUPNVMSR("AA",P,E,D,W)) Q:W'=+W!(H]"")  D
 ..Q:'$D(^AUPNVMSR(W,0))
 ..Q:$P($G(^AUPNVMSR(W,2)),U,1)  ;entered in error
 ..S H=$P(^AUPNVMSR(W,0),U,4)
 ..S BDMARRAY(1)=$$VD^APCLV($P(^AUPNVMSR(W,0),U,3))
 I H="" Q H
 I H["?" Q ""
 S H=$J(H,5,2)
 Q H
WT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,ICD,BDMVF
 K BDM S BDMW="" S BDMX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMW]"")  D
 .S BDMVF=+$P(BDM(BDMN),U,4)
 .Q:$P($G(^AUPNVMSR(BDMVF,2)),U,1)  ;entered in error
 .S BDMZ=$P(BDM(BDMN),U,5)
 .I '$D(^AUPNVPOV("AD",BDMZ)) S BDMW=$P(BDM(BDMN),U,2) Q
 . S BDMD=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(BDMW]"")  D
 .. S ICD=$P($$ICDDX^ICDCODE($P(^AUPNVPOV(BDMD,0),U)),U,2) D  ;cmi/anch/maw 9/12/2007 csv
 ...I $E(ICD,1,3)="V22" Q
 ...I $E(ICD,1,3)="V23" Q
 ...I $E(ICD,1,3)="V27" Q
 ...I $E(ICD,1,3)="V28" Q
 ...I ICD>629.9999&(ICD<676.95) Q
 ...S BDMW=$P(BDM(BDMN),U,2)
 ..Q
 Q BDMW
BMI(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,W,H,B,D,%DT,X
 S %=""
 D  Q %
 .S W=$$WT(P,BDATE,EDATE) Q:W=""  S W=W+.5,W=$P(W,".")
 .S HDATE=$P(^DPT(P,0),U,3)
 .S H=$$HT(P,HDATE,EDATE) I H="" Q
 .S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 .Q
 Q
CREAT(P,BDATE,EDATE,F) ;EP
 G CREAT^BDMDA1C
CHOL(P,BDATE,EDATE,F) ;EP
 G CHOL^BDMDA1C
HDL(P,BDATE,EDATE,F) ;EP
 G HDL^BDMDA1C
LDL(P,BDATE,EDATE,F) ;EP
 G LDL^BDMDA1C
TRIG(P,BDATE,EDATE,F) ;EP
 G TRIG^BDMDA1C
URIN(P,BDATE,EDATE) ;EP
 G URIN^BDMDA1H
PROTEIN(P,BDATE,EDATE) ;EP
 G PROTEIN^BDMDA1C
MICRO(P,BDATE,EDATE) ;EP
 G MICRO^BDMDA1C
HGBA1C(P,BDATE,EDATE) ;EP
 G HGBA1C^BDMDA1D
SEMI(P,BDATE,EDATE) ;EP
 G SEMI^BDMDA1C
PPDS(P) ;
 NEW BDMS,E,X
 K BDMS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS) Q 1_U_$$FMTE^XLFDT($P(BDMS(1),U))_"  HF: "_$P(BDMS(1),U,3)
PPDSPL ;CHECK PL
 N T S T=$O(^ATXAX("B","SURVEILLANCE TUBERCULOSIS",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=X
 I I Q 1_U_$$VAL^XBDIQ1(9000011,I,.03)_"  Problem List: "_$$VAL^XBDIQ1(9000011,I,.01)
 ;check povs
 K BDMS S X=P_"^FIRST DX [SURVEILLANCE TUBERCULOSIS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS(1)) Q 1_U_$$FMTE^XLFDT($P(BDMS(1),U))_"  POV: "_$P(BDMS(1),U,3)
 Q ""
PPD(P,EDATE,F) ;EP
 ;f 1=tb test done
 ;f 2=tb result
 S F=$G(F)
 ;RETURN 1^1  Skin Test||1  Positive
 NEW BDM,X,E,G,BDATE,Y,%DT,D,R,R1,R2,ED,LD,LR
 S LD="",LR=""
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S G=$$PPDS(P) I G Q "1  TB Positive  "_$P(G,U,2)_"||1  Positive TB "_$P(G,U,2)  ;IF HAD HF or dx or pl of TB use it as positive
 K BDM
 ;get, in reverse order all skin tests and lab tests for TB testing  (BDM(inverse date,#)=ST or LAB^ien^result^reading
 S X=$O(^AUTTSK("B","PPD",0))
 S D=9999999-ED-1,C=0 F  S D=$O(^AUPNVSK("AA",P,X,D)) Q:D=""  D
 .S G=0 F  S G=$O(^AUPNVSK("AA",P,X,D,G)) Q:G'=+G  D
 ..Q:'$D(^AUPNVSK(G,0))
 ..S C=C+1 S BDM(D,C)="ST"_U_G_U_$P(^AUPNVSK(G,0),U,5)_U_$S($P(^AUPNVSK(G,0),U,4)="D":"",$P(^AUPNVSK(G,0),U,4)="O":"",1:$P(^AUPNVSK(G,0),U,4))
 S BDMC=0
 S BDMLT=$O(^ATXLAB("B","DM AUDIT TB LAB TESTS",0))
 S BDMOT=$O(^ATXAX("B","DM AUDIT TB TEST LOINC",0))
 S G="",E=9999999-ED S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...Q:$P(^AUPNVLAB(X,0),U,4)=""
 ...Q:$$UP^XLFSTR($P(^AUPNVLAB(X,0),U,4))["CANC"
 ...I BDMLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BDMLT,21,"B",$P(^AUPNVLAB(X,0),U))) D
 ....S C=C+1,BDM(D,C)="LAB^"_X_U_$P(^AUPNVLAB(X,0),U,4),G=1
 ...Q:'BDMOT
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BDMDA1C(J,BDMOT)
 ...S C=C+1,BDM(D,C)="LAB^"_X_U_$P(^AUPNVLAB(X,0),U,4),G=1
 ...Q
 ;now get latest with a result and use it, if none with a result take latest one
 ;if none, quit on value
 S (D,C)=0,G=""
 F  S D=$O(BDM(D)) Q:D'=+D!(G]"")  D
 .S C=0 F  S C=$O(BDM(D,C)) Q:C'=+C!(G]"")  D
 ..I $P(BDM(D,C),U,3)]""!($P(BDM(D,C),U,4)]"") S G=BDM(D,C)
 I F="I" Q $S($P(G,U,1)="LAB":$$VD^APCLV($P(^AUPNVLAB($P(G,U,2),0),U,3)),1:$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3)))
 I G]"" S C="" D  Q C   ;C=1 skin test||result value
 .S C=$S($P(G,U,1)="ST":"1 Skin test (PPD)",1:"2 Blood Test (QFT-G, T SPOT-TB)")
 .;GET RESULT VALUE
 .I $P(G,U,1)="LAB" S R=$P(G,U,3) D  Q
 ..I $E($$UP^XLFSTR(R))="P" S C=C_"||1  Positive "_$$VD^APCLV($P(^AUPNVLAB($P(G,U,2),0),U,3),"S")_" lab result: "_R Q
 ..I $E($$UP^XLFSTR(R))="N" S C=C_"||2  Negative "_$$VD^APCLV($P(^AUPNVLAB($P(G,U,2),0),U,3),"S")_" lab result: "_R Q
 ..S C=C_"||3  Unknown" Q
 .I $P(G,U,1)="ST" D  Q
 ..S R=$P(G,U,3),R1=$P(G,U,4)
 ..I R]"",R>9 S C=C_"||1  Positive "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 ..I R]"",R<10 S C=C_"||2  Negative "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 ..I R1]"",R1="P" S C=C_"||1  Positive "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 ..I R1]"",R1="N" S C=C_"||2  Negative "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 Q "3  Unknown||"
 ;
LASTNP(P,EDATE) ;EP - last negative ppd
 I $E($P($$PPD(P,EDATE),"||",2))'="2" Q ""
 Q $$PPD(P,EDATE,"I")
 ;
FGLUCOSE(P,BDATE,EDATE,F) ;EP
 G FGLUCOSE^BDMDA1D
G75(P,BDATE,EDATE,F) ;EP
 G G75^BDMDA1D
 ;
STV(X,T,D) ;EP - strip hgba1c before epi export
 I X="" Q X  ;no value in X so don't bother
 I X="?" Q ""
 NEW A,B,L
 S L=$L(X)
 F B=1:1:L S A=$E(X,B) Q:A=""  I A'?1N,A'?1"." S X=$$STRIP^XLFSTR(X,A) S B=B-1
 I X="" Q ""
 I $G(D),X["." S X=$J(X,T,D)
 S X=$$STRIP^XLFSTR(X," ")
 Q $E(X,1,T)
STE(X,T,D) ;EP - strip hgba1c before epi export
 I X="" Q X  ;no value in X so don't bother
 I X="?" Q ""
 NEW A,B,L
 S L=$L(X)
 F B=1:1:L S A=$E(X,B) Q:A=""  I A'?1N,A'?1".",X'?1"+",X'?1"-",X'?1">",X'?1"<" S X=$$STRIP^XLFSTR(X,A) S B=B-1
 I X="" Q ""
 I $G(D),X["." S X=$J(X,T,D)
 S X=$$STRIP^XLFSTR(X," ")
 Q $E(X,1,T)
AS(X) ;EP
 I $E(X)="<" S X=$E(X,2,99),X=X-1 Q X
 I $E(X)=">" S X=$E(X,2,99),X=X+1 Q X
 Q X
