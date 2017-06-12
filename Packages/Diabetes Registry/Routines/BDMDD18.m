BDMDD18 ; IHS/CMI/LAB - 2016 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
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
 Q $$STRIP^XLFSTR(H," ")
 ;
WT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,ICD,BDMVF
 K BDM S BDMW="" S BDMX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMW]"")  D
 .S BDMVF=+$P(BDM(BDMN),U,4)
 .Q:$P($G(^AUPNVMSR(BDMVF,2)),U,1)  ;entered in error
 .S BDMZ=$P(BDM(BDMN),U,5)
 .I '$D(^AUPNVPOV("AD",BDMZ)) S BDMW=$P(BDM(BDMN),U,2) Q
 .S BDMD=0,G=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(G=1)  D
 ..S ICD=$$VALI^XBDIQ1(9000010.07,BDMD,.01) D  ;cmi/anch/maw 9/12/2007 csv
 ...I $$ICD^BDMUTL(ICD,"BGP PREGNANCY DIAGNOSES 2",9) S G=1  ;cmi/maw 05/15/2014 p8
 .I 'G S BDMW=$P(BDM(BDMN),U,2)
 Q BDMW
BMI(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,W,H,B,D,%DT,X
 S %=""
 D  Q %
 .S W=$$WT(P,BDATE,EDATE) Q:W=""  S W=W\1  ;S W=W+.5,W=$P(W,".")
 .S HDATE=$P(^DPT(P,0),U,3)
 .S H=$$HT(P,HDATE,EDATE) I H="" Q
 .;S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 .S H=H*H,%=(W/H)*703,%=$J(%,5,1)
 .Q
 Q
CREAT(P,BDATE,EDATE,F) ;EP
 G CREAT^BDMDD1C
CHOL(P,BDATE,EDATE,F) ;EP
 G CHOL^BDMDD1C
HDL(P,BDATE,EDATE,F) ;EP
 G HDL^BDMDD1C
LDL(P,BDATE,EDATE,F) ;EP
 G LDL^BDMDD1C
TRIG(P,BDATE,EDATE,F) ;EP
 G TRIG^BDMDD1C
URIN(P,BDATE,EDATE) ;EP
 G URIN^BDMDD1H
PROTEIN(P,BDATE,EDATE) ;EP
 G PROTEIN^BDMDD1C
MICRO(P,BDATE,EDATE) ;EP
 G MICRO^BDMDD1C
HGBA1C(P,BDATE,EDATE) ;EP
 G HGBA1C^BDMDD1D
SEMI(P,BDATE,EDATE) ;EP
 G SEMI^BDMDD1C
PPDS(P) ;
 NEW BDMS,E,X
 K BDMS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS) Q 1_U_$$DATE^BDMS9B1($P(BDMS(1),U))_"  HF: "_$P(BDMS(1),U,3)
PPDSPL ;CHECK PL
 N T S T=$O(^ATXAX("B","DM AUDIT TUBERCULOSIS DXS",0))
 I 'T Q ""
 ;N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=X
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^BDMUTL(Y,$P(^ATXAX(T,0),U),9) S I=X  ;cmi/maw 05/15/2014 p8
 I I Q 1_U_$$DATE^BDMS9B1($$VALI^XBDIQ1(9000011,I,.03))_"  Problem List: "_$$VAL^XBDIQ1(9000011,I,.01)
 ;check povs
 K BDMS S X=P_"^FIRST DX [DM AUDIT TUBERCULOSIS DXS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS(1)) Q 1_U_$$DATE^BDMS9B1($P(BDMS(1),U))_"  POV: "_$P(BDMS(1),U,3)
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
 ...Q:'$$LOINC^BDMDD1C(J,BDMOT)
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
 ..;S C=C_"||3  Unknown" Q
 Q "3  Unknown||"
 ;
LASTNP(P,EDATE) ;EP - last negative ppd
 I $E($P($$PPD(P,EDATE),"||",2))'="2" Q ""
 Q $$PPD(P,EDATE,"I")
 ;
FGLUCOSE(P,BDATE,EDATE,F) ;EP
 G FGLUCOSE^BDMDD1D
G75(P,BDATE,EDATE,F) ;EP
 G G75^BDMDD1D
 ;
STV(X,T,D) ;EP - strip hgba1c before epi export
 I X="" Q X  ;no value in X so don't bother
 I X="?" Q ""
 NEW A,B,L
 S L=$L(X)
 I $E(X)?1N S X=+X
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
 ;
CALCGFR(P,BDATE,EDATE) ;EP
 NEW R,C,X,Y,Z,D
 S R=$$CREAT^BDMDD18(P,BDATE,EDATE,"I"),D=$P(R,U,2),R=$P(R,U,1)
 I R="" Q ""
 ;CALCULATE IT
 S BDMSEX=$P(^DPT(P,0),U,2)
 S BDMAGE=$$AGE^AUPNPAT(P,D)
 S X=$$GFRSE1CU(P,R,BDMAGE,BDMSEX)
 Q D_U_X_"^ESTIMATED GFR (CALC)"
GFRSE1CU(DFN,CRET,BDMAGE,BDMSEX) ; EP
 ;D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("GFRSE1CU^BLREXEC2")
 ;
 S %X=$$CHKERRS             ; Check for Errors
 I %X'="OK" Q %X            ; If NOT OK, quit with error
 ;
 NEW CONSTA,CRETEXP,AGEEXP,SEXFACTR,RACEFACT
 D SETVARS1                 ; Setup constants & exponents
 ;
 S %X=CONSTA*(CRET**CRETEXP)*(BDMAGE**AGEEXP)*$G(SEXFACTR)*$G(RACEFACT)
 ;
 S %X=$TR($FN(%X,"",0)," ")          ;ROUND RESULT
 ;
 ; See www.nkdep.nih.gov/resources/laboratory_reporting.htm
 I %X>60 S %X=">60"
 ;
 Q %X
 ;
CHKERRS() ; EP
 N BDMERR
 S BDMERR="N/A"
 ;
 I $TR($G(CRET)," ")="" Q BDMERR   ; If creatinine null, then quit
 ;
 ; If 1st character not numeric, then quit
 ; I $E($G(CRET))'?1N Q BDMERR
 I $G(CRET)?1A.A S %X=BDMERR Q %X  ; IHS/OIT/MKK - LR*5.2*1026
 ;
 ; Following lines added to handle errors sent by some instruments
 ; Quit if any are true
 I $E($G(CRET))="" Q BDMERR        ; If Null
 I $E($G(CRET))="#" Q BDMERR       ; Out of Range
 I $E($G(CRET))="<" Q BDMERR       ; Vitros results with "<"
 I ($G(CRET))="-" Q BDMERR         ; Negative results
 ;
 I +$G(CRET)=0 Q BDMERR            ; If zero results, then quit
 ;
 ;I AGE["DYS"!(AGE["MOS")!(AGE<17) Q BDMERR  ; 16 & younger not done, quit
 I BDMAGE<18 Q BDMERR
 ;
 I BDMSEX="" Q BDMERR                 ; Cannot calculate without SEX
 I BDMSEX="U" Q BDMERR
 ;
 Q "OK"
 ;
SETVARS1 ; EP
 ;CONSTANTS, EXPONENTS
 S SEXFACTR=$S(BDMSEX="M":1,1:.742)   ; Sex Factor
 ;
 S RACEFACT=$S($$RACE(DFN)="B":1.21,1:1)
 ;
 S CONSTA=186       ; CONSTANT A
 S CRETEXP=-1.154   ; CREATININE EXPONENT
 S AGEEXP=-.203     ; AGE EXPONENT
 ;
 ;D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("SETVARS1^BLREXEC2")
 Q
RACE(DFN) ; EP
 NEW RACEPTR,RACEENT,V
 ;
 I $T(RACE^AGUTL)]"" D  Q V
 .S V=""
 .S RACEPTR=$$RACE^AGUTL(DFN)
 .I $P(RACEPTR,U)=1,$P(RACEPTR,U,2)["BLACK" S V="B"
 .S V="N"
 S RACEPTR=$P($G(^DPT(+$G(DFN),0)),U,6)
 Q:RACEPTR="" "N"             ; If no entry, consider non-black
 ;
 S RACEENT=$P($G(^DIC(10,RACEPTR,0)),U)
 Q:RACEENT[("BLACK") "B"      ; If RACEENT contains BLACK => race = Black
 Q "N"                        ; otherwise, non-black
 ;
