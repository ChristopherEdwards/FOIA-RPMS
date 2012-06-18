BIREPH2 ;IHS/CMI/MWR - REPORT, H1N1 ACCOUNTABILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT H1N1 ACCOUNTABILITY REPORT.
 ;;  PATCH 3: BIREPH* routines are completely new for H1N1 Report.
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
 S X="*  H1N1 Accountability Report  *" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(28)_"Date Range: "_$$SLDT1^BIUTL5(BIBEGDT)_" - "_$$SLDT1^BIUTL5(BIENDDT)
 D WH^BIW(.BILINE,X,1)
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
 .S X="  Dose  |  6-23m   24-59m    5-18y   19-24y   25-49y   50-64y   "
 .S X=X_" 65+y  |  TOTAL"
 .D WH^BIW(.BILINE,X)
 .;S X=$$SUML("  Dose")
 .;D WH^BIW(.BILINE,X)
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
GET(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT) ;EP
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
 ;
 K ^TMP("BIREPH1",$J),^TMP("BIDFN",$J)
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
 ;
 ;---> Gather data.
 D GETIMMS^BIREPH3(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT)
 ;
 ;---> Write Stats lines for each Vaccine Group.
 ;---> BIG=Vaccine Group, BIV=Vaccine Name, BIA=Age.
 ;
 N BILINE S BILINE=0
 N BIDATE S BIDATE=0
 F  S BIDATE=$O(BITMP("STATS",BIDATE)) Q:'BIDATE  D
 .;---> S BIDATEX=External Date format of BIDATE
 .N BIDATEX,BILSAV D
 ..N Y S Y=BIDATE D DD^%DT S BIDATEX=" "_$P(Y,",")
 .;---> Write Date line.
 .S X=$$SUML(BIDATEX) D WRITE(.BILINE,X) S BILSAV=BILINE
 .;
 .N BIDOSE
 .F BIDOSE=1:1:2 D
 ..;---> Write Dose line.
 ..;S X=BIDOSE D CENTERT^BIUTL5(.X)
 ..;---> Save this line# for marking as a single record to print.
 ..;D WRITE(.BILINE,X) S BILSAV=BILINE
 ..;
 ..;---> Build Age Totals line for this date & dose.
 ..;I BIDOSE>1 S X=$$SUML(BIDATEX) D WRITE(.BILINE,X) ;S BILSAV=BILINE
 ..N X S X="     #"_BIDOSE_" |" N BIA
 ..F BIA=1:1:6 S X=X_$J($G(BITMP("STATS",BIDATE,BIDOSE,"AGE",BIA)),7,0)_"  "
 ..;---> Last line special just to concat "|".
 ..S X=X_$J($G(BITMP("STATS",BIDATE,BIDOSE,"AGE",7)),7,0)_" |"
 ..;
 ..;---> Now concat Total column (for this dose).
 ..S X=X_$J($G(BITMP("STATS",BIDATE,BIDOSE,"TOTAL")),7,0)
 ..D WRITE(.BILINE,X) I BIDOSE=1 S BILSAV=BILINE
 .;
 .D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 .;
 .;---> Now mark the top line of this vaccine to print as one record.
 .D:$G(BILSAV) MARK^BIW(BILSAV,BILINE-BILSAV,"BIREPH1")
 ;
 ;---> Now write totals.
 S X=" Total H1N1 First Doses"
 S X=X_$$SP^BIUTL5(48)_"|"_$J(+$G(BITMP("STATS","DOSES",1,"TOTAL")),7,0)
 D WRITE(.BILINE,X)
 ;
 S X=" Total H1N1 Second Doses"
 S X=X_$$SP^BIUTL5(47)_"|"_$J(+$G(BITMP("STATS","DOSES",2,"TOTAL")),7,0)
 D WRITE(.BILINE,X),WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 S X=" Total H1N1 Immunizations"
 S X=X_$$SP^BIUTL5(46)_"|"_$J(+$G(BITMP("STATS","ALL","TOTAL")),7,0)
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
 D WL^BIW(.BILINE,"BIREPH1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
SUML(Y) ;EP
 ;---> Produce Header array for Vaccine Accountability Report.
 ;---> Parameters:
 ;     1 - Y (opt) Y=text, such as Date (Aug 23) or "Dose" or other text.
 I $L($G(Y))=0 S Y="       "
 S Y=$E(Y,1,7) S Y=$$PAD^BIUTL5(Y,7)
 N X
 S X=Y_" |                                                              |"
 ;   " Date   |  6-23m   24-59m    5-18y   19-25y   25-49y   50-64y     "
 ;S X=Y_" | ------   ------   ------   ------   ------   ------   --"
 ;   "65+y    TOTAL"
 ;Q X_"---- | ------"
 Q X
