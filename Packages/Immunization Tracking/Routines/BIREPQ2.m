BIREPQ2 ;IHS/CMI/MWR - REPORT, QUARTERLY IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW QUARTERLY IMMUNIZATION REPORT, GATHER DATA.
 ;
 ;
 ;----------
HEAD(BIQDT,BICC,BIHCF,BICM,BIBEN,BIUP) ;EP
 ;---> Produce Header array for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Check for required Variables.
 Q:'$G(BIQDT)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 S:$G(BIUP)="" BIUP="u"
 ;
 K VALMHDR
 N BILINE,X S BILINE=0
 ;
 N X S X=""
 ;---> If Header array is NOT being for Listmananger include version.  vvv83
 S:'$D(VALM("BM")) X=$$LMVER^BILOGO()
 ;
 D WH^BIW(.BILINE,X)
 S X=$$REPHDR^BIUTL6(DUZ(2)) D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="*  3-27 Month Immunization Report  *" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;S X="For Children 3-27 Months of Age" D CENTERT^BIUTL5(.X)  vvv83
 ;D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(30)_"End Date: "_$$SLDT1^BIUTL5(BIQDT)
 D WH^BIW(.BILINE,X,1)
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP) D WH^BIW(.BILINE,X)
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
 .S X=$$SP^BIUTL5(10)_"|"_$$SP^BIUTL5(21)_"Age in Months"
 .S X=X_$$SP^BIUTL5(24)_"|"
 .D WH^BIW(.BILINE,X)
 .S X=$$SP^BIUTL5(10)_"|"_$$SP^BIUTL5(58,"-")_"| Totals"
 .D WH^BIW(.BILINE,X)
 .S X="          |    3-4       5-6      7-15     16-18     19-23"
 .S X=X_"     24-27 |"
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
START(BIQDT,BICC,BIHCF,BICM,BIBEN,BIHPV,BIUP) ;EP
 ;---> Produce array for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIHPV  (opt) 1=Include Varicella & Pneumo.
 ;     7 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 K ^TMP("BIREPQ1",$J)
 N BILINE,BITMP,X S BILINE=0,BIPOP=0
 ;
 ;---> Check for required Variables.
 ;
 I '$G(BIQDT) D ERRCD^BIUTL2(623,.X) D WRITERR(BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITERR(BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITERR(BILINE,X) Q
 I '$D(BICM) D ERRCD^BIUTL2(615,.X) D WRITERR(BILINE,X) Q
 I '$D(BIBEN) D ERRCD^BIUTL2(662,.X) D WRITERR(BILINE,X) Q
 S:'$D(BIHPV) BIHPV=1
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Write Age Totals line.
 D AGETOT^BIREPQ3(.BILINE,.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BIHPV,BIUP,.BIPOP)
 Q:BIPOP
 ;
 ;---> Write lines that define minimum needs.
 D MNEED^BIREPQ3(.BILINE,BIHPV)
 ;
 ;---> Write Approp for Age and Vaccine Group lines.
 D APPROP^BIREPQ3(.BILINE)
 ;
 ;---> Write Statistics lines for each Vaccine Group (BIVGRP).
 F BIVGRP=1,2,6,3,4,7,9,11,15 D VGRP^BIREPQ3(.BILINE,BIVGRP)
 ;---> Per Ros Singleton, show HPV individual stats, even if not including
 ;---> them in the totals for Age Appropriate.
 ;F BIVGRP=1,2,6,3,4 D VGRP^BIREPQ3(.BILINE,BIVGRP)
 ;I $G(BIHPV) F BIVGRP=7,9,11 D VGRP^BIREPQ3(.BILINE,BIVGRP)
 ;
 ;---> Now write total patients considered who had refusals.
 N M,N S (M,N)=0 F  S M=$O(BITMP("REFUSALS",M)) Q:'M  S N=N+1
 S X="  Total Patients included who had Refusals on record"_$J(N,25)
 D WRITE^BIREPQ3(.BILINE,X),WRITE^BIREPQ3(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
WRITERR(BILINE,X) ;EP
 ;---> Write error line to report.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (req) Error text.
 ;
 S:'$D(X) X="No error text."
 S:'$D(BILINE) BILINE=1
 D WRITE^BIREPQ3(.BILINE,X) S VALMCNT=BILINE
 Q
