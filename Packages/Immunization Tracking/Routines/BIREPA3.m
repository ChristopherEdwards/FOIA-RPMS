BIREPA3 ;IHS/CMI/MWR - REPORT, VAC ACCOUNTABILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT VACCINE ACCOUNTABILITY REPORT.
 ;
 ;
 ;----------
GETIMMS(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT) ;EP
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
 ;
 ;---> Set begin and end dates for search through V Immunization File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)
 N N S N=BIBEGDT-.9999
 F  S N=$O(^AUPNVIMM("ADT",N)) Q:(N>(BIENDDT+.9999)!('N))  D
 .N M S M=0
 .F  S M=$O(^AUPNVIMM("ADT",N,M)) Q:'M  D
 ..N P S P=0
 ..F  S P=$O(^AUPNVIMM("ADT",N,M,P)) Q:'P  D
 ...D CHKSET(N,M,P,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT)
 Q
 ;
 ;
 ;----------
CHKSET(BIDATE,BIVIEN,BIIIEN,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT) ;EP
 ;---> Check if this visit fits criteria; if so, set it
 ;---> in ^TMP("BIREPA1".
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
 ;
 N BIAGRP,BIDFN,BIIMM,BILOT,BIVGRP,BIVNAM,BIDOSE,Y
 S Y=^AUPNVIMM(BIIIEN,0)
 S BIDFN=$P(Y,U,2),BIIMM=$P(Y,U),BILOT=$P(Y,U,5) ;,BIDOSE=$P(Y,U,4)
 ;
 I BILOT S BILOT=$P($G(^AUTTIML(BILOT,0)),U)
 S:BILOT="" BILOT="No Lot Number"
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
 S BIVNAM=$$VNAME^BIUTL2(BIIMM)
 ;S:BIDOSE<1 BIDOSE=1 S:BIDOSE>4 BIDOSE=4
 S BIAGRP=$$AGEGRP(BIDFN,BIDATE)
 S BIVGRP=$$IMMVG^BIUTL2(BIIMM,4)
 ;
 N Z
 ;---> Now store in stats arrays.
 ;
 ;---> Add for this Vaccine, Lot, Age.
 S Z=$G(BITMP("STATS",BIVGRP,BIVNAM,BILOT,BIAGRP))
 S BITMP("STATS",BIVGRP,BIVNAM,BILOT,BIAGRP)=Z+1
 ;
 ;---> Add for this Vaccine, Lot, Total.
 S Z=$G(BITMP("STATS",BIVGRP,BIVNAM,BILOT,"TOTAL"))
 S BITMP("STATS",BIVGRP,BIVNAM,BILOT,"TOTAL")=Z+1
 ;
 ;---> Add for this Vaccine, ALL Lots, Age.
 S Z=$G(BITMP("STATS",BIVGRP,BIVNAM,"ALL",BIAGRP))
 S BITMP("STATS",BIVGRP,BIVNAM,"ALL",BIAGRP)=Z+1
 ;
 ;---> Add for this Vaccine, Total.
 S Z=$G(BITMP("STATS",BIVGRP,BIVNAM,"ALL","TOTAL"))
 S BITMP("STATS",BIVGRP,BIVNAM,"ALL","TOTAL")=Z+1
 ;
 ;---> Add for ALL Vaccines, Total.
 S Z=$G(BITMP("STATS","ALL","TOTAL"))
 S BITMP("STATS","ALL","TOTAL")=Z+1 K Z
 ;
 ;---> Add refusals, if any.
 ;---> Not desired on this report, per Ros 10-12-05
 ;D CONTRA^BIUTL11(BIDFN,.Z,1) I $O(Z(0)) S BITMP("REFUSALS",BIDFN)=""
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
