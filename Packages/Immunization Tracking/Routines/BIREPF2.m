BIREPF2 ;IHS/CMI/MWR - REPORT, FLU IMM; AUG 10,2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW INFLUENZA IMMUNIZATION REPORT, GATHER DATA.
 ;;  PATCH 1: Add "Dose#" header to Doses column.  HEAD+86
 ;
 ;
 ;----------
HEAD(BIYEAR,BICC,BIHCF,BICM,BIBEN,BIFH,BIUP) ;EP
 ;---> Produce Header array for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIYEAR (req) Report Year.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIFH   (opt) F=report on Flu Vaccine Group (default), H=H1N1 group.
 ;     7 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Check for required Variables.
 Q:'$G(BIYEAR)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 S:($G(BIFH)="") BIFH="F"
 Q:'$D(BIUP)
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
 S X="*  "_$S($G(BIFH)="H":"H1N1",1:"Standard Flu")_" Immunization Report  *"
 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 N BIBEG,BIEND S BIBEG="09/15/"_$P(BIYEAR,U)
 D
 .I $P(BIYEAR,U,2)="m" S BIEND="03/31/"_($P(BIYEAR,U)+1) Q
 .S BIEND="12/31/"_$P(BIYEAR,U)
 S X=$$SP^BIUTL5(28)_"Date Range: "_BIBEG_" - "_BIEND
 D WH^BIW(.BILINE,X,1)
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP),X=$$PAD^BIUTL5(X,48)
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
 .S X=$$SP^BIUTL5(13)_"|"_$$SP^BIUTL5(4)_"      Age in months/years on "
 .S X=X_$$SLDT2^BIUTL5((BIYEAR-1700)_1231)_$$SP^BIUTL5(12)_"|"
 .D WH^BIW(.BILINE,X)
 .;
 .;********** PATCH 1, v8.4, AUG 01,2010, IHS/CMI/MWR
 .;---> Add "Dose#" header to Doses column.
 .;S X=$$SP^BIUTL5(13)_"|"_$$SP^BIUTL5(55,"-")_"| Totals"
 .S X="    Dose#    |"_$$SP^BIUTL5(55,"-")_"| Totals"
 .;**********
 .;
 .D WH^BIW(.BILINE,X)
 .S X="             | 10-23m    2-4y   5-17y  18-49y *18-49hr 50-64y  65+yrs"
 .S X=$$PAD^BIUTL5(X,69)_"|"
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
START(BIYEAR,BICC,BIHCF,BICM,BIBEN,BIFH,BIUP) ;EP
 ;---> Produce array for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIYEAR (req) Report Year^m (if 2nd pc="m", then End Date=March 31 of
 ;                      the report year; otherwise End Date=Dec 31 of BIYEAR)
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIFH   (opt) F=report on Flu Vaccine Group (default), H=H1N1 group.
 ;     7 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;
 K ^TMP("BIREPF1",$J)
 N BILINE,BITMP,X S BILINE=0,BIPOP=0
 ;
 ;---> Check for required Variables.
 ;
 I '$G(BIYEAR) D ERRCD^BIUTL2(679,.X) D WRITERR(BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITERR(BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITERR(BILINE,X) Q
 I '$D(BICM) D ERRCD^BIUTL2(615,.X) D WRITERR(BILINE,X) Q
 I '$D(BIBEN) D ERRCD^BIUTL2(662,.X) D WRITERR(BILINE,X) Q
 S:($G(BIFH)="") BIFH="F"
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Write Age Totals line.
 D AGETOT^BIREPF3(.BILINE,.BICC,.BIHCF,.BICM,.BIBEN,BIYEAR,.BIPOP,BIFH,BIUP)
 Q:BIPOP
 ;
 ;---> Write Approp for Age and Vaccine Group lines.
 ;D APPROP^BIREPF3(.BILINE)
 ;
 ;---> Write Statistics lines for each Vaccine Group (BIVGRP).
 ;F BIVGRP=1,2,6,3,4,7,9,11,15 D VGRP^BIREPF3(.BILINE,BIVGRP)
 ;---> If report is for H1N1, then display vaccine group 18; otherwise Flu (10).
 S BIVGRP=$S(BIFH="H":18,1:10)
 D VGRP^BIREPF3(.BILINE,BIVGRP,BIYEAR)
 ;
 ;---> For Flu Report (not H1N1) write Approp for Age and Vaccine Group lines.
 D:BIVGRP=10 APPROP^BIREPF3(.BILINE)
 ;
 ;---> Now write total patients considered who had refusals.
 N M,N S (M,N)=0 F  S M=$O(BITMP("REFUSALS",M)) Q:'M  S N=N+1
 S X="  Total Patients included who had Influenza Refusals on record"_$J(N,15)
 D WRITE^BIREPF3(.BILINE,X),WRITE^BIREPF3(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 S X="  *NOTE: The 18-49hr column tallies patients who are High Risk in that"
 D WRITE^BIREPF3(.BILINE,X)
 S X="         Age Group.  They are not included in the normal 18-49y column."
 D WRITE^BIREPF3(.BILINE,X),WRITE^BIREPF3(.BILINE,$$SP^BIUTL5(79,"-"))
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
 D WRITE^BIREPF3(.BILINE,X) S VALMCNT=BILINE
 Q
