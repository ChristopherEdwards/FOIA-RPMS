BIREPE2 ;IHS/CMI/MWR - REPORT, VAC ELIGIBILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**2**;MAY 15,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT VACCINE ELIGIBILITY REPORT.
 ;
 ;----------
HEAD(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT,BIU19) ;EP
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
 ;     9 - BIU19   (req) Include Adults parameter (1=yes,0=no).
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
 Q:'$D(BIU19)
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
 S X="*  Vaccine Eligibility Report  *" D CENTERT^BIUTL5(.X)
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
 S X=" (Historical "_$S(BIHIST:"In",1:"Ex")_"cluded"
 S X=X_", Adults "_$S(BIU19:"In",1:"Ex")_"cluded)"
 ;
 S X=X_$J("Total Immunizations: "_+$G(^TMP("BIDUL",$J,"TOTAL")),40)
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
 .;---> If specific Visit Types, print Visit  Type subheader.
 .D SUBH^BIOUTPT5("BIVT","Visit Type",,"9000010-.03",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .S X="   Date    Last,First Name   DOB    Eligibility  Vaccine      Lot#"
 .;S X=X_"65+  TOTAL"
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
GET(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIHIST,BIVT,BIU19,BIDELIM) ;EP
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
 ;     9 - BIU19   (req) Include Adults parameter (1=yes,0=no).
 ;    10 - BIDELIM (req) Deliniter (1="caret ^", 2="2 spaces").
 ;
 ;   * NOT USED FOR NOW
 ;     X - BIDLOT  (req) If BIDLOT=1, display by Lot Numbers.
 ;
 K ^TMP("BIREPE1",$J)
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
 I '$D(BIU19) D ERRCD^BIUTL2(682,.X) D WRITE(.BILINE,X) Q
 I '$D(BIDELIM) D ERRCD^BIUTL2(683,.X) D WRITE(.BILINE,X) Q
 ;I '$D(BIDLOT) D ERRCD^BIUTL2(681,.X) D WRITE(.BILINE,X) Q
 ;
 ;---> Gather data.
 D GETIMMS^BIREPE3(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT,BIU19)
 ;
 S BIDELIM=$S(BIDELIM=1:"^",1:"  ")
 N BILINE S BILINE=0
 ;S ^TMP("BIDUL",$J,BIDATE,BINAME,BIIIEN)=BIVAL
 N BIDATE S BIDATE=0
 F  S BIDATE=$O(^TMP("BIDUL",$J,BIDATE)) Q:'BIDATE  D
 .N BINAME S BINAME=""
 .F  S BINAME=$O(^TMP("BIDUL",$J,BIDATE,BINAME)) Q:(BINAME="")  D
 ..N BIIIEN S BIIIEN=0
 ..F  S BIIIEN=$O(^TMP("BIDUL",$J,BIDATE,BINAME,BIIIEN)) Q:'BIIIEN  D
 ...N W,X,Y,Z S Y=^TMP("BIDUL",$J,BIDATE,BINAME,BIIIEN)
 ...S Z=BIDELIM S X=$S(Z="  ":" ",1:"")
 ...;S X=X_$P(Y,U)_Z_$$PAD^BIUTL5($E($P(Y,U,2),1,14),14)_Z_$P(Y,U,3)
 ...;S X=X_Z_$$PAD^BIUTL5($P(Y,U,4),9)_Z_$$PAD^BIUTL5($P(Y,U,5),10)_Z_$P(Y,U,6)
 ...;
 ...S X=X_$P(Y,U)_Z
 ...S W=$E($P(Y,U,2),1,14) I Z'="^" S W=$$PAD^BIUTL5(W,14)
 ...S X=X_W_Z_$P(Y,U,3)_Z
 ...S W=$P(Y,U,4) I Z'="^" S W=$$PAD^BIUTL5(W,9)
 ...S X=X_W_Z
 ...S W=$P(Y,U,5) I Z'="^" S W=$$PAD^BIUTL5(W,10)
 ...S X=X_W_Z_$P(Y,U,6)
 ...;;
 ...;S X=X_Z_$$PAD^BIUTL5($P(Y,U,4),9)_Z_$$PAD^BIUTL5($P(Y,U,5),10)_Z_$P(Y,U,6)
 ...D WRITE(.BILINE,X)
 ;
 ;---> Set final VALMCNT (Listman line count).
 S VALMCNT=BILINE
 Q
 ;
 ;*** NOT USED ***
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
 ..;S X=$$SUML() D WRITE(.BILINE,X)
 ..S X="" N BIA
 ..F BIA=1:1:12 S X=X_$J($G(BITMP("STATS",BIG,BIV,"ALL",BIA)),6)
 ..;---> Now concat Total column (for this vaccine row).
 ..S X=X_$J($G(BITMP("STATS",BIG,BIV,"ALL","TOTAL")),7)
 ..D WRITE(.BILINE,X)
 ..D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ..;---> Now mark the top line of this vaccine to print as one record.
 ..D:$G(BILSAV) MARK^BIW(BILSAV,BILINE-BILSAV,"BIREPE1")
 ..;
 ..Q:'$G(BIDLOT)
 ..;---> Display rows by individual Lot Number.
 ..N BIL S BIL=0
 ..F  S BIL=$O(BITMP("STATS",BIG,BIV,BIL)) Q:BIL=""  D
 ...Q:(BIL="ALL")
 ...;---> Write Vaccine Name with Lot Number concatenated.
 ...S X=BIV_" - "_BIL D CENTERT^BIUTL5(.X)
 ...D WRITE(.BILINE,X) S BILSAV=BILINE
 ...;S X=$$SUML() D WRITE(.BILINE,X)
 ...S X="" N BIA
 ...F BIA=1:1:12 S X=X_$J($G(BITMP("STATS",BIG,BIV,BIL,BIA)),6)
 ...S X=X_$J($G(BITMP("STATS",BIG,BIV,BIL,"TOTAL")),7)
 ...D WRITE(.BILINE,X)
 ...D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ...D:$G(BILSAV) MARK^BIW(BILSAV,BILINE-BILSAV,"BIREPE1")
 ...;
 ...;---> Now mark the top line of this vaccine to print as one record.
 ...D:$G(BILSAV) MARK^BIW(BILSAV,BILINE-BILSAV,"BIREPE1")
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
 D WL^BIW(.BILINE,"BIREPE1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
