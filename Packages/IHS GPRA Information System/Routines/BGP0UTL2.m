BGP0UTL2 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 30 Jun 2010 9:01 AM ; 
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
GETDIR() ;EP - get default directory
 NEW D
 S D=""
 S D=$P($G(^AUTTSITE(1,1)),"^",2)
 I D]"" Q D
 S D=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 I D]"" Q D
 I $P(^AUTTSITE(1,0),U,21)=1 S D="/usr/spool/uucppublic/"
 Q D
GETMEDS(P,BGPMBD,BGPMED,TAXM,TAXN,TAXC,BGPDNAME,BGPZ) ;EP
 S TAXM=$G(TAXM)
 S TAXN=$G(TAXN)
 S TAXC=$G(TAXC)
 K ^TMP($J,"MEDS"),BGPZ
 S BGPDNAME=$G(BGPDNAME)
 NEW BGPC1,BGPINED,BGPINBD,BGPMIEN,BGPD,X,Y,T,T1,D,G
 S BGPC1=0 K BGPZ
 S BGPINED=(9999999-BGPMED)-1,BGPINBD=(9999999-BGPMBD)
 F  S BGPINED=$O(^AUPNVMED("AA",P,BGPINED)) Q:BGPINED=""!(BGPINED>BGPINBD)  D
 .S BGPMIEN=0 F  S BGPMIEN=$O(^AUPNVMED("AA",P,BGPINED,BGPMIEN)) Q:BGPMIEN'=+BGPMIEN  D
 ..Q:'$D(^AUPNVMED(BGPMIEN,0))
 ..S BGPD=$P(^AUPNVMED(BGPMIEN,0),U)
 ..Q:BGPD=""
 ..Q:'$D(^PSDRUG(BGPD,0))
 ..S BGPC1=BGPC1+1
 ..S ^TMP($J,"MEDS","ORDER",(9999999-BGPINED),BGPC1)=(9999999-BGPINED)_U_$P(^PSDRUG(BGPD,0),U)_U_$P(^PSDRUG(BGPD,0),U)_U_BGPMIEN_U_$P(^AUPNVMED(BGPMIEN,0),U,3)
 ;reorder
 S BGPC1=0,X=0
 F  S X=$O(^TMP($J,"MEDS","ORDER",X)) Q:X'=+X  D
 .S Y=0 F  S Y=$O(^TMP($J,"MEDS","ORDER",X,Y)) Q:Y'=+Y  D
 ..S BGPC1=BGPC1+1
 ..S ^TMP($J,"MEDS",BGPC1)=^TMP($J,"MEDS","ORDER",X,Y)
 K ^TMP($J,"MEDS","ORDER")
 S T="" I TAXM]"" S T=$O(^ATXAX("B",TAXM,0)) I T="" W BGPBOMB
 S T1="" I TAXN]"" S T1=$O(^ATXAX("B",TAXN,0)) I T1="" W BGPBOMB
 S T2="" I TAXC]"" S T2=$O(^ATXAX("B",TAXC,0))
 S BGPC1=0,X=0 F  S X=$O(^TMP($J,"MEDS",X)) Q:X'=+X  S Y=+$P(^TMP($J,"MEDS",X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .S C=$P($G(^PSDRUG(D,0)),U,2)
 .I C]"",T2,$D(^ATXAX(T2,21,"B",C)) S G=1
 .S C=$P($G(^PSDRUG(D,2)),U,4)
 .I C]"",T1,$D(^ATXAX(T1,21,"B",C)) S G=1
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1
 .I BGPDNAME]"",$P(^PSDRUG(D,0),U)[BGPDNAME S G=1
 .I TAXM="",TAXN="",TAXC="" S G=1  ;WANTS ALL MEDS
 .I G=1 S BGPC1=BGPC1+1,BGPZ(BGPC1)=^TMP($J,"MEDS",X)
 .Q
 K ^TMP($J,"MEDS")
 K BGPINED,BGPINBD,BGPMBD,BGPMED,BGPD,BGPC1,BGPDNAME
 Q
RCIS(P,BDATE,EDATE,ICDC,CPTC) ;EP
 I '$G(P) Q ""
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 S ICDC=$G(ICDC)
 S CPTC=$G(CPTC)
 ;find a referral in date range BDATE to EDATE
 NEW ICDCAT,CPTCAT,X,Y,D,A,B,G
 F X=1:1 S Y=$P(ICDC,";",X) Q:Y=""  S Y=$O(^BMCTDXC("B",Y,0)) I Y S ICDCAT(Y)=""
 F X=1:1 S Y=$P(CPTC,";",X) Q:Y=""  S Y=$O(^BMCTSVC("B",Y,0)) I Y S CPTCAT(Y)=""
 S X=0,G="" F  S X=$O(^BMCREF("D",P,X)) Q:X'=+X!(G)  D
 .Q:'$D(^BMCREF(X,0))  ;bad xref
 .S D=$P(^BMCREF(X,0),U,1),D=$P(D,".")
 .Q:D<BDATE  ;before date range
 .Q:D>EDATE  ;after end date
 .S Y=$P(^BMCREF(X,0),U,12)
 .I $D(ICDCAT),Y="" Q  ;want certain categories and this one blank
 .I $D(ICDCAT),'$D(ICDCAT(Y)) Q  ;want certain categories and this one doesn't match
 .S Y=$P(^BMCREF(X,0),U,13)
 .I $D(CPTCAT),Y="" Q  ;want certain categories and this one blank
 .I $D(CPTCAT),'$D(CPTCAT(Y)) Q  ;want certain categories and this one doesn't match
 .S G=X
 I 'G Q ""
 S X="" F Y=.07,.08,.09 S A=$$VAL^XBDIQ1(90001,G,Y) I A]"" S:X]"" X=X_"; "
 Q 1_"^"_$P($P(^BMCREF(G,0),U),".")_"^"_$$DATE^BGP0UTL($P($P(^BMCREF(G,0),U),"."))_"^"_"RCIS referral"_"^"_X_"^"_"90001"_"^"_G
