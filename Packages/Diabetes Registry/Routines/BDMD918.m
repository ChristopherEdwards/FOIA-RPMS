BDMD918 ; IHS/CMI/LAB - 2009 DIABETES AUDIT ; [ 02/23/2009 7:59 PM ]
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning in WT
 ;
HT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,BDMARRY,H,E
 S %=P_"^LAST MEAS HT;DURING "_BDATE_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"BDMARRY(") S H=$P($G(BDMARRY(1)),U,2)
 I H="" Q H
 I H["?" Q ""
 S H=$J(H,5,2)
 Q H
WT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,ICD
 K BDM S BDMW="" S BDMX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMW]"")  D
 .S BDMZ=$P(BDM(BDMN),U,5)
 .I '$D(^AUPNVPOV("AD",BDMZ)) S BDMW=$P(BDM(BDMN),U,2) Q
 . S BDMD=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(BDMW]"")  D
 .. ;S ICD=$P(^ICD9($P(^AUPNVPOV(BDMD,0),U),0),U) D  ;cmi/anch/maw 9/12/2007 orig line
 .. S ICD=$P($$ICDDX^ICDCODE($P(^AUPNVPOV(BDMD,0),U)),U,2) D  ;cmi/anch/maw 9/12/2007 csv
 ...I $E(ICD,1,3)="V22" Q
 ...I $E(ICD,1,3)="V23" Q
 ...I $E(ICD,1,3)="V27" Q
 ...I $E(ICD,1,3)="V28" Q
 ...I ICD>629.9999&(ICD<676.95) Q
 ...I ICD>61.49&(ICD<61.71) Q
 ...S BDMW=$P(BDM(BDMN),U,2)
 ..Q
 Q BDMW
BMI(P,BDATE,EDATE) ;EP
 I 'P Q -1
 NEW %,W,H,B,D,%DT,X
 S %DT="P",X=EDATE D ^%DT S D=Y
 S %=""
 ;W !,$$HRN^AUPNPAT(P,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)))
 D  Q %
 .S W=$$WT(P,$$FMADD^XLFDT(D,-(2*365)),EDATE) Q:W=""  S W=W+.5,W=$P(W,".")
 .;S HDATE=$$FMTE^XLFDT($$FMADD^XLFDT($P(^DPT(P,0),U,3),(19*365)))
 .S HDATE=$P(^DPT(P,0),U,3)
 .S H=$$HT(P,HDATE,EDATE) I H="" Q
 .;W U,W,U,H
 .S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 .Q
 Q
 ;S X=$$HTWTSD(P,BDATE,EDATE)
 ;I '$P(X,"^") Q %
 ;I '$P(X,"^",2) Q %
 ;S W=$P(X,"^"),H=$P(X,"^",2),W=W+.5,W=$P(W,"."),H=$J(H,5,2)
 ;W U,W,U,H
 ;S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 ;W U,%
 ;Q %
HTWTSD(P,BDATE,EDATE) ;get last ht / wt on same day
 I '$G(P) Q ""
 NEW BDMWTS,BDMHTS,%,X,BDMWTS1,BDMHTS1
 ;get all hts during time frame
 S %=P_"^ALL MEAS HT;DURING "_BDATE_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"BDMHTS(")
 ;set the array up by date
 K BDMHTS1 S X=0 F  S X=$O(BDMHTS(X)) Q:X'=+X  S BDMHTS1($P(BDMHTS(X),U))=X
 ;get all wts during time frame
 S %=P_"^ALL MEAS WT;DURING "_BDATE_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"BDMWTS(")
 ;set the array up by date
 K BDMWTS1 S X=0 F  S X=$O(BDMWTS(X)) Q:X'=+X  S BDMWTS1($P(BDMWTS(X),U))=X
 NEW BDMCHT S BDMCHT="",X=9999999 F  S X=$O(BDMWTS1(X),-1) Q:X=""!(BDMCHT]"")  I $D(BDMHTS1(X)) S BDMCHT=$P(BDMWTS(BDMWTS1(X)),U,2)_U_$P(BDMHTS(BDMHTS1(X)),U,2)
 Q BDMCHT
CREAT(P,BDATE,EDATE,F) ;EP
 G CREAT^BDMD91C
CHOL(P,BDATE,EDATE,F) ;EP
 G CHOL^BDMD91C
HDL(P,BDATE,EDATE,F) ;EP
 G HDL^BDMD91C
LDL(P,BDATE,EDATE,F) ;EP
 G LDL^BDMD91C
TRIG(P,BDATE,EDATE,F) ;EP
 G TRIG^BDMD91C
URIN(P,BDATE,EDATE) ;EP
 G URIN^BDMD91H
PROTEIN(P,BDATE,EDATE) ;EP
 G PROTEIN^BDMD91C
MICRO(P,BDATE,EDATE) ;EP
 G MICRO^BDMD91C
HGBA1C(P,BDATE,EDATE) ;EP
 G HGBA1C^BDMD91D
SEMI(P,BDATE,EDATE) ;EP
 G SEMI^BDMD91C
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
 I $G(F)="" S F="E"
 NEW BDM,X,E,G,BDATE,Y,%DT,D,R,R1,R2,ED
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S G=$$PPDS(P) I G Q "1  POS  "_$P(G,U,2)
 K BDM
 S X=$O(^AUTTSK("B","PPD",0)) I 'X Q ""
 S G=0,D=9999999-ED-1 F  S D=$O(^AUPNVSK("AA",P,X,D)) Q:D=""  S G=0 F  S G=$O(^AUPNVSK("AA",P,X,D,G)) Q:G'=+G  S BDM(D,G)=$P($P(^AUPNVSIT($P(^AUPNVSK(G,0),U,3),0),U),".")_U_$P(^AUPNVSK(G,0),U,5)_U_$P(^AUPNVSK(G,0),U,4)
 I '$O(BDM(0)) D  Q $S(G:"3  Refused "_$P(G,U,3)_" "_$P(G,U,4)_" "_$P(G,U,5),1:"4  Unknown")
 .S X=EDATE,%DT="P" D ^%DT S BDATE=$$FMADD^XLFDT(Y,-365),BDATE=$$FMTE^XLFDT(BDATE),G=0 S X=$$REFUSAL^BDMD917(P,9999999.28,$O(^AUTTSK("B","PPD",0)),BDATE,EDATE) I X S G=X
 ;go through all ppds and find last reading or result
 S G="",D=0,X=0 F  S D=$O(BDM(D)) Q:D'=+D!(G)  S X=0 F  S X=$O(BDM(D,X)) Q:X'=+X  S R=$P(BDM(D,X),U,2),R1=$P(BDM(D,X),U,3) I R]""!(R1]"") S G=1,R2=9999999-D
 I F="I",(R]""!(R1]"")) Q R2
 I R]"",R>9 Q "1  POS  "_$$FMTE^XLFDT(R2)_" Reading: "_R_"  Result: "_R1
 I R]"",R<10 Q "2  NEG  "_$$FMTE^XLFDT(R2)_" Reading: "_R_"  Result: "_R1
 I R1]"",R1="P" Q "1  POS  "_$$FMTE^XLFDT(R2)_" Reading: "_R_"  Result: "_R1
 I R1]"",R1="N" Q "2  NEG  "_$$FMTE^XLFDT(R2)_" Reading: "_R_"  Result: "_R1
 Q "4  Unknown"
 ;
LASTNP(P,EDATE) ;EP - last negative ppd
 I $E($$PPD(P,EDATE))'="2" Q ""
 Q $$PPD(P,EDATE,"I")
 ;
FGLUCOSE(P,BDATE,EDATE,F) ;EP
 G FGLUCOSE^BDMD91D
G75(P,BDATE,EDATE,F) ;EP
 G G75^BDMD91D
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
