BUD0UTL2 ; IHS/CMI/LAB - utilities for BUD ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETRIEVE PATIENTS FOR DUE LISTS & LETTERS.
 ;;  PATCH 1: Correct test for Active Chart at site DUZ2.  INACTREG+11
 ;;           Also, add Street Address Line 2 aAPCLlity.  STREET+0
 ;;           Also, provide test for patient IneligiAPCLlity  INELIG+0
 ;
 ;----------
DOB(DFN) ;EP
 ;---> Return Patient's Date of APCLrth in Fileman format.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$P($G(^DPT(DFN,0)),U,3) "NOT ENTERED"
 Q $P(^DPT(DFN,0),U,3)
 ;
 ;
 ;
 ;----------
AGE(DFN,APCLZ,APCLDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - APCLZ  (opt) APCLZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - APCLDT (opt) Date on which Age should be calculated.
 ;
 N APCLDOB,X,X1,X2  S:$G(APCLZ)="" APCLZ=2
 Q:'$G(DFN) ""
 S APCLDOB=$$DOB(DFN)
 Q:'APCLDOB ""
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(APCLDT) APCLDT=DT
 Q:APCLDT<APCLDOB ""
 ;
 ;---> Age in Years.
 N APCLAGEY,APCLAGEM,APCLD1,APCLD2,APCLM1,APCLM2,APCLY1,APCLY2
 S APCLM1=$E(APCLDOB,4,7),APCLM2=$E(APCLDT,4,7)
 S APCLY1=$E(APCLDOB,1,3),APCLY2=$E(APCLDT,1,3)
 S APCLAGEY=APCLY2-APCLY1 S:APCLM2<APCLM1 APCLAGEY=APCLAGEY-1
 S:APCLAGEY<1 APCLAGEY="<1"
 Q:APCLZ=1 APCLAGEY
 ;
 ;---> Age in Months.
 S APCLD1=$E(APCLM1,3,4),APCLM1=$E(APCLM1,1,2)
 S APCLD2=$E(APCLM2,3,4),APCLM2=$E(APCLM2,1,2)
 S APCLAGEM=12*APCLAGEY
 I APCLM2=APCLM1&(APCLD2<APCLD1) S APCLAGEM=APCLAGEM+12
 I APCLM2>APCLM1 S APCLAGEM=APCLAGEM+APCLM2-APCLM1
 I APCLM2<APCLM1 S APCLAGEM=APCLAGEM+APCLM2+(12-APCLM1)
 S:APCLD2<APCLD1 APCLAGEM=APCLAGEM-1
 Q:APCLZ=2 APCLAGEM
 ;
 ;---> Age in Days.
 S X1=APCLDT,X2=APCLDOB
 D ^%DTC
 Q X
 ;
 ;
 ;----------
AGEF(DFN,APCLDT) ;EP
 ;---> Age formatted "35 Months" or "23 Years"
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - APCLDT (opt) Date on which Age should be calculated.
 ;
 N Y
 S Y=$$AGE(DFN,2,$G(APCLDT))
 Q:Y["DECEASED" Y
 Q:Y["NOT BORN" Y
 ;
 ;---> If over 60 months, return years.
 I Y>60 S Y=$$AGE(DFN,1,$G(APCLDT)) Q Y_$S(Y=1:"year",1:" yrs")
 ;
 ;---> If under 1 month return days.
 I Y<1 S Y=$$AGE(DFN,3,$G(APCLDT)) Q Y_$S(Y=1:" day",1:" days")
 ;
 ;---> Return months
 Q Y_$S(Y=1:" mth",1:" mths")
 ;
 ;
 ;----------
DECEASED(DFN,APCLDT) ;EP
 ;---> Return 1 if patient is deceased, 0 if not deceased.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - APCLDT (opt) If APCLDT=1 return Date of Death (Fileman format).
 ;
 Q:'$G(DFN) 0
 N X S X=+$G(^DPT(DFN,.35))
 Q:'X 0
 Q:'$G(APCLDT) 1
 Q X
 ;
 ;
GETMEDS(P,BUDMBD,BUDMED,TAXM,TAXN,TAXC,BUDDNAME,BUDZ) ;EP
 S TAXM=$G(TAXM)
 S TAXN=$G(TAXN)
 S TAXC=$G(TAXC)
 K ^TMP($J,"MEDS"),BUDZ
 S BUDDNAME=$G(BUDDNAME)
 NEW BUDC1,BUDINED,BUDINBD,BUDMIEN,BUDD,X,Y,T,T1,D,G
 S BUDC1=0 K BUDZ
 S BUDINED=(9999999-BUDMED)-1,BUDINBD=(9999999-BUDMBD)
 F  S BUDINED=$O(^AUPNVMED("AA",P,BUDINED)) Q:BUDINED=""!(BUDINED>BUDINBD)  D
 .S BUDMIEN=0 F  S BUDMIEN=$O(^AUPNVMED("AA",P,BUDINED,BUDMIEN)) Q:BUDMIEN'=+BUDMIEN  D
 ..Q:'$D(^AUPNVMED(BUDMIEN,0))
 ..S BUDD=$P(^AUPNVMED(BUDMIEN,0),U)
 ..Q:BUDD=""
 ..Q:'$D(^PSDRUG(BUDD,0))
 ..S BUDC1=BUDC1+1
 ..S ^TMP($J,"MEDS","ORDER",(9999999-BUDINED),BUDC1)=(9999999-BUDINED)_U_$P(^PSDRUG(BUDD,0),U)_U_$P(^PSDRUG(BUDD,0),U)_U_BUDMIEN_U_$P(^AUPNVMED(BUDMIEN,0),U,3)
 ;reorder
 S BUDC1=0,X=0
 F  S X=$O(^TMP($J,"MEDS","ORDER",X)) Q:X'=+X  D
 .S Y=0 F  S Y=$O(^TMP($J,"MEDS","ORDER",X,Y)) Q:Y'=+Y  D
 ..S BUDC1=BUDC1+1
 ..S ^TMP($J,"MEDS",BUDC1)=^TMP($J,"MEDS","ORDER",X,Y)
 K ^TMP($J,"MEDS","ORDER")
 S T="" I TAXM]"" S T=$O(^ATXAX("B",TAXM,0)) I T="" W BUDBOMB
 S T1="" I TAXN]"" S T1=$O(^ATXAX("B",TAXN,0)) I T1="" W BUDBOMB
 S T2="" I TAXC]"" S T2=$O(^ATXAX("B",TAXC,0))
 S BUDC1=0,X=0 F  S X=$O(^TMP($J,"MEDS",X)) Q:X'=+X  S Y=+$P(^TMP($J,"MEDS",X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .S C=$P($G(^PSDRUG(D,0)),U,2)
 .I C]"",T2,$D(^ATXAX(T2,21,"B",C)) S G=1
 .S C=$P($G(^PSDRUG(D,2)),U,4)
 .I C]"",T1,$D(^ATXAX(T1,21,"B",C)) S G=1
 .I T,$D(^ATXAX(T,21,"B",D)) S G=1
 .I BUDDNAME]"",$P(^PSDRUG(D,0),U)[BUDDNAME S G=1
 .I TAXM="",TAXN="",TAXC="" S G=1  ;WANTS ALL MEDS
 .I G=1 S BUDC1=BUDC1+1,BUDZ(BUDC1)=^TMP($J,"MEDS",X)
 .Q
 K ^TMP($J,"MEDS")
 K BUDINED,BUDINBD,BUDMBD,BUDMED,BUDD,BUDC1,BUDDNAME
 Q
