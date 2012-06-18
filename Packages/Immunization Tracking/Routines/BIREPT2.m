BIREPT2 ;IHS/CMI/MWR - REPORT, TWO-YR-OLD RATES; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW TWO-YR-OLD IMMUNIZATION RATES REPORT, GATHER DATA.
 ;
 ;
 ;----------
HEAD(BIQDT,BITAR,BIAGRPS,BICC,BIHCF,BICM,BIBEN,BIUP) ;EP
 ;---> Produce Header array for Two-Yr-Old Report.
 ;---> Parameters:
 ;     1 - BIQDT   (req) Quarter Ending Date.
 ;     2 - BITAR   (req) Two-Yr-Old Report Age Range, default="19-35".
 ;     3 - BIAGRPS (req) String of Age Groups (e.g., 3,5,7,16,19,24,36)
 ;     4 - BICC    (req) Current Community array.
 ;     5 - BIHCF   (req) Health Care Facility array.
 ;     6 - BICM    (req) Case Manager array.
 ;     7 - BIBEN   (req) Beneficiary Type array.
 ;     8 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Check for required Variables.
 Q:'$G(BIQDT)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$D(BITAR)
 Q:'$G(BIAGRPS)
 S:$G(BIUP)="" BIUP="u"
 ;
 K VALMHDR
 N BILINE,X S BILINE=0
 ;
 N X S X=""
 ;---> If Header array is NOT being for Listmananger include version.
 S:'$D(VALM("BM")) X=$$LMVER^BILOGO()
 ;
 D WH^BIW(.BILINE,X)
 S X=$$REPHDR^BIUTL6(DUZ(2)) D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="*  Two-Yr-Old Immunization Report ("_$P(BITAR,"-")_"-35 mths)  *"
 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(30)_"End Date: "_$$SLDT1^BIUTL5(BIQDT)
 D WH^BIW(.BILINE,X,1)
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP)
 I BIUP="i" S X=" "_$$BIUPTX^BIUTL6(BIUP,1)_" (Active)"
 S X=$$PAD^BIUTL5(X,54)
 ;
 S X=X_$J("Total Patients: "_$G(BITOTPTS),24)
 D WH^BIW(.BILINE,X)
 ;
 D WH^BIW(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 D
 .;---> If specific Communities were selected (not ALL), then print
 .;---> the Communities in a subheader at the top of the report.
 .D SUBH^BIOUTPT5("BICC","Community",,"^AUTTCOM(",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Health Care Facilities, print subheader.
 .D SUBH^BIOUTPT5("BIHCF","Facility",,"^DIC(4,",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Case Managers, print Case Manager subheader.
 .D SUBH^BIOUTPT5("BICM","Case Manager",,"^VA(200,",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Beneficiary Types, print Beneficiary Type subheader.
 .D SUBH^BIOUTPT5("BIBEN","Beneficiary Type",,"^AUTTBEN(",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .S X=" Received by |    3 mo     5 mo     7 mo    16 mo    19 mo"
 .S:BIAGRPS["24" X=X_"    24 mo"
 .S X=X_"   "_$$SLDT2^BIUTL5(BIQDT,1)
 .D WH^BIW(.BILINE,X)
 .S X="             |    # %      # %      # %      # %      # %"
 .S X=X_"      # %"
 .S:BIAGRPS["24" X=X_"      # %"
 .D WH^BIW(.BILINE,X)
 ;
 ;---> If Header array is being built for Listmananger,
 ;---> reset display window margins for Communities, etc.
 D:$D(VALM("BM"))
 .S VALM("TM")=BILINE+3
 .S VALM("LINES")=VALM("BM")-VALM("TM")+1
 .;---> Safeguard to prevent divide/0 error.
 .S:VALM("LINES")<1 VALM("LINES")=1
 Q
 ;
 ;
 ;----------
START(BIQDT,BITAR,BIAGRPS,BICC,BIHCF,BICM,BIBEN,BISITE,BIUP) ;EP
 ;---> Produce array for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT   (req) Quarter Ending Date.
 ;     2 - BITAR   (opt) Two-Yr-Old Report Age Range, default="19-35".
 ;     3 - BIAGRPS (req) String of Age Groups (e.g., 3,5,7,16,19,24,36)
 ;     4 - BICC    (req) Current Community array.
 ;     5 - BIHCF   (req) Health Care Facility array.
 ;     6 - BICM    (req) Case Manager array.
 ;     7 - BIBEN   (req) Beneficiary Type array.
 ;     8 - BISITE  (req) Site IEN.
 ;     9 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 K ^TMP("BIREPT1",$J)
 N BILINE,BITMP,X S BILINE=0
 ;
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERRCD^BIUTL2(623,.X) D WRITE^BIREPT3(.BILINE,X) Q
 I '$D(BITAR)  D ERRCD^BIUTL2(613,.X) D WRITE^BIREPT3(.BILINE,X) Q
 I '$G(BIAGRPS) D ERRCD^BIUTL2(677,.X) D WRITE^BIREPT3(.BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITE^BIREPT3(.BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITE^BIREPT3(.BILINE,X) Q
 I '$D(BICM) D ERRCD^BIUTL2(615,.X) D WRITE^BIREPT3(.BILINE,X) Q
 I '$D(BIBEN)  D ERRCD^BIUTL2(662,.X) D WRITE^BIREPT3(.BILINE,X) Q
 I '$G(BISITE) S BISITE=$G(DUZ(2))
 I '$G(BISITE) D ERRCD^BIUTL2(109,.X) D WRITE^BIREPT3(.BILINE,X) Q
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Gather data.
 D GETDATA^BIREPT3(.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BITAR,BIAGRPS,BISITE,BIUP,.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPT3(.BILINE,BIERR) Q
 ;
 ;---> Write Statistics lines for each Vaccine Group (BIVGRP).
 F BIVGRP=1,2,3,4,6,7,9,10,11,15 D VGRP^BIREPT3(.BILINE,BIVGRP,BIAGRPS,.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPT3(.BILINE,BIERR) Q
 ;
 ;---> Write Statistics lines for each Vaccine Combinations.
 ;---> NOTE: These Combo strings are also used to set BITMP("STATS"
 ;---> nodes beginning at +130^BIREPT4.  vvv83
 D VCOMB^BIREPT3(.BILINE,"1|1^2|1^3|1^4|1",BIAGRPS,.BIERR)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1",BIAGRPS,.BIERR)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3",BIAGRPS,.BIERR)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3^4|3",BIAGRPS,.BIERR)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3^4|3^7|1",BIAGRPS,.BIERR)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3^4|3^7|1^11|3",BIAGRPS,.BIERR)
 ;---> Next combo is up to date (UTD); send 5th parameter=1.
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3^4|3^7|1^11|4",BIAGRPS,.BIERR,1)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3^4|3^7|1^11|4^9|1",BIAGRPS,.BIERR)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3^4|3^7|1^11|4^9|2^15|3",BIAGRPS,.BIERR)
 D VCOMB^BIREPT3(.BILINE,"1|4^2|3^6|1^3|3^4|3^7|1^11|4^9|2^15|3^10|2",BIAGRPS,.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPT3(.BILINE,BIERR) Q
 ;
 ;---> BITOTPTS (total patients) not newed here because it is also
 ;---> used in the Header.
 S BITOTPTS=+$G(BITMP("STATS","TOTLPTS"))
 S X=" Total Active Patients reviewed"_$J(BITOTPTS,44)
 D WRITE^BIREPT3(.BILINE,X)
 D WRITE^BIREPT3(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Now write total patients considered who had refusals.
 N M,N S (M,N)=0 F  S M=$O(BITMP("REFUSALS",M)) Q:'M  S N=N+1
 S X=" Total Patients included who had Refusals on record"_$J(N,24)
 D WRITE^BIREPT3(.BILINE,X),WRITE^BIREPT3(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Set final VALMCNT (Listman line count).
 S VALMCNT=BILINE
 Q
