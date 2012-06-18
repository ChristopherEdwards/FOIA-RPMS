BIREPA2 ;IHS/CMI/MWR - REPORT, VAC ACCOUNTABILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT VACCINE ACCOUNTABILITY REPORT.
 ;
 ;----------
HEAD(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT) ;EP
 ;---> Produce Header array for Vaccine Accountability Report.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin date of report.
 ;     2 - BIENDDT (req) End date of report.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIHIST  (req) Include Historical (1=yes,0=no).
 ;     8 - BIVT    (req) Visit Type array.
 ;
 ;---> Check for required Variables.
 Q:'$G(BIBEGDT)
 Q:'$G(BIENDDT)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$D(BIHIST)
 Q:'$D(BIVT)
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
 S X="*  Vaccine Accountability Report  *" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 ;S X=$$TXDT1^BIUTL5(DT) D CENTERT^BIUTL5(.X)
 ;D WH^BIW(.BILINE,X,1)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(28)_"Date Range: "_$$SLDT1^BIUTL5(BIBEGDT)_" - "_$$SLDT1^BIUTL5(BIENDDT)
 D WH^BIW(.BILINE,X,1)
 ;
 ;
 S X=" (Historical "_$S(BIHIST:"In",1:"Ex")_"cluded)"
 D WH^BIW(.BILINE,X)
 S X=$$SP^BIUTL5(79,"-")
 D WH^BIW(.BILINE,X)
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
 .;---> If specific Beneficiary Types, print Beneficiary Type subheader.
 .D SUBH^BIOUTPT5("BIVT","Visit Type",,"9000010-.03",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .S X="   <1    -1-   -2-   3-5   -6-  7-10 11-12 13-18 19-24 25-44 45-64   "
 .S X=X_"65+  TOTAL"
 .D WH^BIW(.BILINE,X)
 .;
 .S X=$$SUML()
 .D WH^BIW(.BILINE,X)
 ;
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
GET(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT,BIDLOT) ;EP
 ;----------
 ;---> Produce array for Vaccine Accountability Report.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin date of report.
 ;     2 - BIENDDT (req) End date of report.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIHIST  (req) Include Historical (1=yes,0=no).
 ;     8 - BIVT    (req) Visit Type array.
 ;     9 - BIDLOT  (req) If BIDLOT=1, display by Lot Numbers.
 ;
 K ^TMP("BIREPA1",$J)
 N BILINE,BITMP,X S BILINE=0
 ;
 ;---> Check for required Variables.
 I '$G(BIBEGDT) D ERRCD^BIUTL2(626,.X) D WRITE(.BILINE,X) Q
 I '$G(BIENDDT) D ERRCD^BIUTL2(627,.X) D WRITE(.BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITE(.BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITE(.BILINE,X) Q
 I '$D(BICM) D ERRCD^BIUTL2(615,.X) D WRITE(.BILINE,X) Q
 I '$D(BIBEN) D ERRCD^BIUTL2(662,.X) D WRITE(.BILINE,X) Q
 I '$D(BIHIST) D ERRCD^BIUTL2(663,.X) D WRITE(.BILINE,X) Q
 I '$D(BIVT) D ERRCD^BIUTL2(664,.X) D WRITE(.BILINE,X) Q
 I '$D(BIDLOT) D ERRCD^BIUTL2(681,.X) D WRITE(.BILINE,X) Q
 ;
 ;---> Gather data.
 D GETIMMS^BIREPA3(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT)
 ;
 ;---> Write Stats lines for each Vaccine Group.
 ;---> BIG=Vaccine Group, BIV=Vaccine Name, BIA=Age.
 N BILINE S BILINE=0
 N BIG S BIG=0
 F  S BIG=$O(BITMP("STATS",BIG)) Q:'BIG  D
 .N BIV S BIV=0
 .F  S BIV=$O(BITMP("STATS",BIG,BIV)) Q:BIV=""  D
 ..;
 ..N BILSAV,X
 ..;
 ..;---> Write Vaccine Name line.
 ..S X=BIV
 ..I $G(BIDLOT) S X=X_" - All Lots"
 ..D CENTERT^BIUTL5(.X)
 ..;---> Save this line# for marking as a single record to print.
 ..D WRITE(.BILINE,X) S BILSAV=BILINE
 ..;
 ..;---> Build Age Totals line for this vaccine.
 ..S X=$$SUML() D WRITE(.BILINE,X)
 ..S X="" N BIA
 ..F BIA=1:1:12 S X=X_$J($G(BITMP("STATS",BIG,BIV,"ALL",BIA)),6)
 ..;---> Now concat Total column (for this vaccine row).
 ..S X=X_$J($G(BITMP("STATS",BIG,BIV,"ALL","TOTAL")),7)
 ..D WRITE(.BILINE,X)
 ..D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ..;---> Now mark the top line of this vaccine to print as one record.
 ..D:$G(BILSAV) MARK^BIW(BILSAV,BILINE-BILSAV,"BIREPA1")
 ..;
 ..Q:'$G(BIDLOT)
 ..;---> Display rows by individual Lot Number.
 ..N BIL S BIL=0
 ..F  S BIL=$O(BITMP("STATS",BIG,BIV,BIL)) Q:BIL=""  D
 ...Q:(BIL="ALL")
 ...;---> Write Vaccine Name with Lot Number concatenated.
 ...S X=BIV_" - "_BIL D CENTERT^BIUTL5(.X)
 ...D WRITE(.BILINE,X) S BILSAV=BILINE
 ...S X=$$SUML() D WRITE(.BILINE,X)
 ...S X="" N BIA
 ...F BIA=1:1:12 S X=X_$J($G(BITMP("STATS",BIG,BIV,BIL,BIA)),6)
 ...S X=X_$J($G(BITMP("STATS",BIG,BIV,BIL,"TOTAL")),7)
 ...D WRITE(.BILINE,X)
 ...D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ...D:$G(BILSAV) MARK^BIW(BILSAV,BILINE-BILSAV,"BIREPA1")
 ...;
 ...;---> Now mark the top line of this vaccine to print as one record.
 ...D:$G(BILSAV) MARK^BIW(BILSAV,BILINE-BILSAV,"BIREPA1")
 ;
 ;---> Now write total in .
 S X=" TOTAL IMMUNIZATIONS (for all vaccines in this report)"
 S X=X_$$SP^BIUTL5(16)_$J(+$G(BITMP("STATS","ALL","TOTAL")),9)
 D WRITE(.BILINE,X),WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Now write total patients considered who had refusals.
 ;---> Not desired on this report, per Ros 10-12-05
 ;N M,N S (M,N)=0 F  S M=$O(BITMP("REFUSALS",M)) Q:'M  S N=N+1
 ;S X=" Total Patients included who had Refusals on record"_$J(N,28)
 ;D WRITE(.BILINE,X),WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Set final VALMCNT (Listman line count).
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPA1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
SUML() ;EP
 ;---> Produce Header array for Vaccine Accountability Report.
 ;---> Parameters:
 ;     1 - Y (opt) If Y=1 write line for subtotals instead of header.
 N X
 ;S X=$S($G(Y):" ----",1:" ----")_"| ----  ---  ---  ---  ---  ----"
 ;Q X_" ----- ----- ----- ----- ----- ----- -----"
 S X="  ----  ----  ----  ----  ----  ---- ----- ----- ----- ----- "
 Q X_"----- -----  -----"
