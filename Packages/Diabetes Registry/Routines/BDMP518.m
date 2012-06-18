BDMP518 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in WT
 ;
HT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,BDMARRY,H,E
 S %=P_"^LAST MEAS HT;DURING "_BDATE_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"BDMARRY(") S H=$P($G(BDMARRY(1)),U,2)
 I H="" Q H
 I H["?" Q ""
 S H=$J(H,4,1)
 Q H
WT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,ICD
 K BDM S BDMW="" S BDMX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMW]"")  D
 .S BDMZ=$P(BDM(BDMN),U,5)
 .I '$D(^AUPNVPOV("AD",BDMZ)) S BDMW=$P(BDM(BDMN),U,2) Q
 . S BDMD=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(BDMW]"")  D
 .. ;S ICD=$P(^ICD9($P(^AUPNVPOV(BDMD,0),U),0),U) D  ;cmi/anch/maw 9/10/2007 orig line
 .. S ICD=$P($$ICDDX^ICDCODE($P(^AUPNVPOV(BDMD,0),U)),U,2) D  ;cmi/anch/maw 9/10/2007 csv
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
 NEW %,W,H,B,D,%DT
 S %DT="P",X=EDATE D ^%DT S D=Y
 S %=""
 I $$AGE^AUPNPAT(P,D)>19 D  Q %
 .S W=$$WT(P,BDATE,EDATE) I W="" Q
 .S HDATE=$$FMTE^XLFDT($$FMADD^XLFDT($P(^DPT(P,0),U,3),(19*365)))
 .S H=$$HT(P,HDATE,EDATE) I H="" Q
 .S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S X=$$HTWTSD(P,BDATE,EDATE)
 I '$P(X,"^") Q %
 I '$P(X,"^",2) Q %
 S W=$P(X,"^"),H=$P(X,"^",2)
 S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 Q %
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
