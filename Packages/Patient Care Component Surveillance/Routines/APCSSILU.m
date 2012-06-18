APCSSILU ; IHS/CMI/LAB - utilities for ili/h1n1 ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETRIEVE PATIENTS FOR DUE LISTS & LETTERS.
 ;;  PATCH 1: Correct test for Active Chart at site DUZ2.  INACTREG+11
 ;;           Also, add Street Address Line 2 aAPCSlity.  STREET+0
 ;;           Also, provide test for patient IneligiAPCSlity  INELIG+0
 ;
 ;----------
DOB(DFN) ;EP
 ;---> Return Patient's Date of APCSrth in Fileman format.
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
AGE(DFN,APCSZ,APCSDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - APCSZ  (opt) APCSZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - APCSDT (opt) Date on which Age should be calculated.
 ;
 N APCSDOB,X,X1,X2  S:$G(APCSZ)="" APCSZ=2
 Q:'$G(DFN) ""
 S APCSDOB=$$DOB(DFN)
 Q:'APCSDOB ""
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(APCSDT) APCSDT=DT
 Q:APCSDT<APCSDOB ""
 ;
 ;---> Age in Years.
 N APCSAGEY,APCSAGEM,APCSD1,APCSD2,APCSM1,APCSM2,APCSY1,APCSY2
 S APCSM1=$E(APCSDOB,4,7),APCSM2=$E(APCSDT,4,7)
 S APCSY1=$E(APCSDOB,1,3),APCSY2=$E(APCSDT,1,3)
 S APCSAGEY=APCSY2-APCSY1 S:APCSM2<APCSM1 APCSAGEY=APCSAGEY-1
 S:APCSAGEY<1 APCSAGEY="<1"
 Q:APCSZ=1 APCSAGEY
 ;
 ;---> Age in Months.
 S APCSD1=$E(APCSM1,3,4),APCSM1=$E(APCSM1,1,2)
 S APCSD2=$E(APCSM2,3,4),APCSM2=$E(APCSM2,1,2)
 S APCSAGEM=12*APCSAGEY
 I APCSM2=APCSM1&(APCSD2<APCSD1) S APCSAGEM=APCSAGEM+12
 I APCSM2>APCSM1 S APCSAGEM=APCSAGEM+APCSM2-APCSM1
 I APCSM2<APCSM1 S APCSAGEM=APCSAGEM+APCSM2+(12-APCSM1)
 S:APCSD2<APCSD1 APCSAGEM=APCSAGEM-1
 Q:APCSZ=2 APCSAGEM
 ;
 ;---> Age in Days.
 S X1=APCSDT,X2=APCSDOB
 D ^%DTC
 Q X
 ;
 ;
 ;----------
AGEF(DFN,APCSDT) ;EP
 ;---> Age formatted "35 Months" or "23 Years"
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - APCSDT (opt) Date on which Age should be calculated.
 ;
 N Y
 S Y=$$AGE(DFN,2,$G(APCSDT))
 Q:Y["DECEASED" Y
 Q:Y["NOT BORN" Y
 ;
 ;---> If over 60 months, return years.
 I Y>60 S Y=$$AGE(DFN,1,$G(APCSDT)) Q Y_$S(Y=1:"year",1:" yrs")
 ;
 ;---> If under 1 month return days.
 I Y<1 S Y=$$AGE(DFN,3,$G(APCSDT)) Q Y_$S(Y=1:" day",1:" days")
 ;
 ;---> Return months
 Q Y_$S(Y=1:" mth",1:" mths")
 ;
 ;
 ;----------
DECEASED(DFN,APCSDT) ;EP
 ;---> Return 1 if patient is deceased, 0 if not deceased.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - APCSDT (opt) If APCSDT=1 return Date of Death (Fileman format).
 ;
 Q:'$G(DFN) 0
 N X S X=+$G(^DPT(DFN,.35))
 Q:'X 0
 Q:'$G(APCSDT) 1
 Q X
 ;
 ;
