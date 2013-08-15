BIREPE3 ;IHS/CMI/MWR - REPORT, VAC ELIGIBILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**3**;SEP 10,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT VACCINE ELIGIBILITY REPORT.
 ;;  PATCH 3: Return Eligibility values from BI TABLE ELIGIBILITY File. ELIGC+5
 ;
 ;
 ;----------
GETIMMS(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT,BIU19) ;EP
 ;---> Get Immunizations from V Files.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin Visit Date.
 ;     2 - BIENDDT (req) End Visit Date.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIHIST  (req) Include Historical (1=yes,0=no).
 ;     8 - BIVT    (req) Visit Type array.
 ;     9 - BIU19   (req) Include Adults parameter (1=yes,0=no).
 ;
 ;---> Set begin and end dates for search through V Immunization File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)
 S ^TMP("BIDUL",$J,"TOTAL")=0
 N N S N=BIBEGDT-.9999
 F  S N=$O(^AUPNVIMM("ADT",N)) Q:(N>(BIENDDT+.9999)!('N))  D
 .N M S M=0
 .F  S M=$O(^AUPNVIMM("ADT",N,M)) Q:'M  D
 ..N P S P=0
 ..F  S P=$O(^AUPNVIMM("ADT",N,M,P)) Q:'P  D
 ...D CHKSET(N,M,P,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT,BIU19)
 Q
 ;
 ;
 ;----------
CHKSET(BIDATE,BIVIEN,BIIIEN,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT,BIU19) ;EP
 ;---> Check if this visit fits criteria; if so, set it
 ;---> in ^TMP("BIREPE1".
 ;---> Parameters:
 ;     1 - BIDATE (req) Date of Visit.
 ;     2 - BIVIEN (req) VISIT IEN.
 ;     3 - BIIIEN (req) V IMMUNIZAITON IEN.
 ;     4 - BICC   (req) Current Community array.
 ;     5 - BIHCF  (req) Health Care Facility array.
 ;     6 - BICM   (req) Case Manager array.
 ;     7 - BIBEN  (req) Beneficiary Type array.
 ;     8 - BIHIST (req) Include Historical (1=yes,0=no).
 ;     9 - BIVT   (req) Visit Type array.
 ;    10 - BIU19  (req) Include Adults parameter (1=yes,0=no).
 ;
 Q:'$G(BIDATE)
 Q:'$G(BIVIEN)
 Q:'$G(BIIIEN)
 Q:'$D(^AUPNVSIT(BIVIEN,0))
 Q:'$D(^AUPNVIMM(BIIIEN,0))
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$D(BIVT)
 Q:'$D(BIU19)
 ;
 N BIVIMM,BIIMM,BIVNAME,BIDFN,BILOT,BIELIG
 S BIVIMM=^AUPNVIMM(BIIIEN,0)
 S BIIMM=$P(BIVIMM,U),BIVNAME=$$VNAME^BIUTL2(BIIMM)
 S BIDFN=$P(BIVIMM,U,2)
 S BILOT=$P(BIVIMM,U,5)
 S BIELIG=$P(BIVIMM,U,14)
 ;
 I BILOT S BILOT=$P($G(^AUTTIML(BILOT,0)),U)
 S:BILOT="" BILOT="Not Entered"
 ;
 ;---> Quit if this Vaccine should not be included in this report.
 ;---> As of v8.4, include all vaccines given during the selected time.
 ;Q:'$P($G(^AUTTIMM(BIIMM,0)),U,17)   ;vvv8.4
 ;
 ;---> Quit if Current Community doesn't match.
 Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 ;
 ;---> Quit if Health Care Facility doesn't match.
 N BIVDATA S BIVDATA=^AUPNVSIT(BIVIEN,0)
 Q:$$HCF(BIVDATA,.BIHCF)
 ;
 ;---> Quit if Visit Type doesn't match.
 Q:$$VT(BIVDATA,.BIVT)
 ;
 ;---> Quit if not including Historical Visits and this Visit has
 ;---> a Category of "Historical".
 I '$G(BIHIST) Q:$$HIST(BIVDATA)
 ;
 ;---> Quit if Case Manager doesn't match.
 Q:$$CMGR^BIDUR(BIDFN,.BICM)
 ;
 ;---> Quit if Beneficiary Type doesn't match.
 Q:$$BENT^BIDUR1(BIDFN,.BIBEN)
 ;
 ;---> Quit if EXcluding adults and this patient was >19 on date of Visit.
 I 'BIU19 Q:($$AGE^BIUTL1(BIDFN,1,BIDATE)>18)
 ;
 ;S BIVNAM=$$VNAME^BIUTL2(BIIMM)
 ;S BIAGRP=$$AGEGRP(BIDFN,BIDATE)
 ;S BIVGRP=$$IMMVG^BIUTL2(BIIMM,4)
 ;
 ;N Z
 ;---> Now store in stats arrays.
 ;
 ;---> Add for this Vaccine, Lot, Age.
 ;S Z=$G(BITMP("STATS",BIVGRP,BIVNAM,BILOT,BIAGRP))
 ;S BITMP("STATS",BIVGRP,BIVNAM,BILOT,BIAGRP)=Z+1
 ;
 ;---> Add for this Vaccine, Lot, Total.
 ;S Z=$G(BITMP("STATS",BIVGRP,BIVNAM,BILOT,"TOTAL"))
 ;S BITMP("STATS",BIVGRP,BIVNAM,BILOT,"TOTAL")=Z+1
 ;
 N BINAME S BINAME=$$NAME^BIUTL1(BIDFN)
 N BIDOB S BIDOB=$$DOBF^BIUTL1(BIDFN,,1,1,,1)
 N BIELIGC S BIELIGC=$$ELIGC^BIELIG(BIELIG,6)
 N BIVAL S BIVAL=$$SLDT2^BIUTL5(BIDATE,1)_U_$E(BINAME,1,20)_U_BIDOB_U_BIELIGC_U_BIVNAME_U_BILOT
 S ^TMP("BIDUL",$J,BIDATE,BINAME,BIIIEN)=BIVAL
 S ^TMP("BIDUL",$J,"TOTAL")=^TMP("BIDUL",$J,"TOTAL")+1
 ;
 Q
 ;
 ;
 ;
 ;----------
AGEGRP(BIDFN,BIDATE) ;EP
 ;---> Return Patient's Age Group.
 ;---> Parameters:
 ;     1 - BIDFN  (req) IEN in PATIENT File.
 ;     2 - BIDATE (req) Date of Visit.
 ;
 N X S X=$$AGE^BIUTL1(BIDFN,1,BIDATE)
 Q:X<1 1
 Q:X=1 2
 Q:X=2 3
 Q:X<6 4
 Q:X=6 5
 Q:X<11 6
 Q:X<13 7
 Q:X<19 8
 Q:X<25 9
 Q:X<45 10
 Q:X<65 11
 Q 12
 ;
 ;
 ;----------
HCF(BIVDATA,BIHCF) ;EP
 ;---> Return Health Care Facility indicator.
 ;---> Return 1 if not selecting all Health Care Facilities (Locations)
 ;---> and if the Health Care Facility of this visit is not one of the
 ;---> ones selected.
 ;---> Parameters:
 ;     1 - BIVDATA (req) Data in ^AUPNVSIT(BIVIEN,0).
 ;     2 - BIHCF   (req) Health Care Facility array.
 ;
 Q:$D(BIHCF("ALL")) 0
 Q:'$G(BIVDATA) 1
 N BILOC S BILOC=$P(BIVDATA,U,6)
 Q:'BILOC 1
 Q:'$D(BIHCF(BILOC)) 1
 Q 0
 ;
 ;
 ;----------
VT(BIVDATA,BIVT) ;EP
 ;---> Return Visit Type indicator.
 ;---> Return 1 if not selecting all Visit Types and if this Visit Type
 ;---> is not one of the ones selected.
 ;---> Parameters:
 ;     1 - BIVDATA (req) Data in ^AUPNVSIT(BIVIEN,0).
 ;     2 - BIVT    (req) Health Care Facility array.
 ;
 Q:$D(BIVT("ALL")) 0
 Q:'$G(BIVDATA) 1
 N BIVTYPE S BIVTYPE=$P(BIVDATA,U,3)
 Q:BIVTYPE="" 1
 Q:'$D(BIVT(BIVTYPE)) 1
 Q 0
 ;
 ;
 ;----------
HIST(BIVDATA) ;EP
 ;---> Return Historical Visit indicator.
 ;---> Return 1 if this Visit has a Category of "Historical".
 ;---> Parameters:
 ;     1 - BIVDATA (req) Data in ^AUPNVSIT(BIVIEN,0).
 ;
 Q:'$G(BIVDATA) 1
 Q:$P(BIVDATA,U,7)="E" 1
 Q 0
 ;
 ;
 ;----------
ELIGC(IEN,FORM) ;EP
 ;---> Return Eligibility Code or text.
 ;
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Return Eligibility values from BI TABLE ELIGIBILITY File.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Elig Code.
 ;     2 - FORM (opt) FORM of Code to return:
 ;                        1=Actual Code (also default)
 ;                        2=Label Text of Code
 ;                        3=Active/Inactive Status (1
 ;                        4=Local Text
 ;                        5=Local Report Abbreviation
 ;
 Q:'$G(IEN) ""
 Q:'$D(^BIELIG(IEN,0)) "NO GLOBAL"
 N Y S Y=^BIELIG(IEN,0)
 ;
 Q:$G(FORM)=2 $P(Y,U,2)
 Q:$G(FORM)=3 $P(Y,U,3)
 Q:$G(FORM)=4 $P(Y,U,4)
 Q:$G(FORM)=5 $P(Y,U,5)
 Q:$G(FORM)=6 $S($P(Y,U,5)]"":$P(Y,U,5),1:$P(Y,U))
 Q $P(Y,U)
 ;**********
 ;
 Q:(X=0) "Unknown"
 Q:(X=1) "NotElig"
 Q:(X=2) "Medicaid"
 Q:(X=3) "Uninsured"
 Q:(X=4) "AmIn/AKNa"
 Q:(X=5) "Under/Fed"
 Q:(X=6) "State"
 Q:(X=7) "Local"
 Q "Unknown"
