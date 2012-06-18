APCLSILU ; IHS/CMI/LAB - utilities for ili/h1n1 ;
 ;;3.0;IHS PCC REPORTS;**24,26,27**;FEB 05, 1997
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
