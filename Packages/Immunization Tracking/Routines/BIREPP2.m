BIREPP2 ;IHS/CMI/MWR - REPORT, PCV; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT PCV REPORT.
 ;
 ;----------
HEAD(BIBEGDT,BIENDDT,BICC,BIUP) ;EP
 ;---> Produce Header array for PCV Report.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin date of report.
 ;     2 - BIENDDT (req) End date of report.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIUP    (req) User Population/Group (r,i,u,a).
 ;
 ;---> Check for required Variables.
 Q:'$G(BIBEGDT)
 Q:'$G(BIENDDT)
 Q:'$D(BICC)
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
 S X="*  PCV Report  *" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(28)_"Date Range: "_$$SLDT1^BIUTL5(BIBEGDT)_" - "_$$SLDT1^BIUTL5(BIENDDT)
 D WH^BIW(.BILINE,X,1)
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP)
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
 .S X=" # of Children  |     0-59m      2-23m     24-59m      6-11m     12-23m"
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
GET(BIBEGDT,BIENDDT,BICC,BIUP) ;EP
 ;---> Produce temp global for PCV Report.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin date of report.
 ;     2 - BIENDDT (req) End date of report.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIUP    (req) User Population/Group (r,i,u,a).
 ;
 K ^TMP("BIREPP1",$J),^TMP("BIDFN",$J)
 N BILINE,BITMP,X S BILINE=0
 ;
 ;---> Check for required Variables.
 I '$G(BIBEGDT) D ERRCD^BIUTL2(626,.X) D WRITE(.BILINE,X) Q
 I '$G(BIENDDT) D ERRCD^BIUTL2(627,.X) D WRITE(.BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITE(.BILINE,X) Q
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Gather data.
 D GETIMMS^BIREPP3(BIBEGDT,BIENDDT,.BICC,BIUP)
 D TALLY^BIREPP3
 Q
 ;
 ;
 ;----------
DISPLAY ;EP
 ;---> Create Listman display global for PCV Report.
 ;---> Parameters:
 ;---> Write Denominator line.
 N BILINE S BILINE=0
 N X S X="  Denominator   |  "
 N N F N=1:1:5 S X=X_$J(+$G(^TMP("BIREPP1",$J,"TOTALPATS",N)),8,0)_"   "
 D WRITE(.BILINE,X)
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Write Doses lines.
 N BIAGRP,BIDOSE
 F BIDOSE=1,3,4 D
 .N X,Y S X=" "_BIDOSE_"+ doses PCV13 |  "
 .;---> Next line without percents%.
 .;F BIAGRP=1:1:5 S X=X_$J(+$G(^TMP("BIREPP1",$J,"TALLY",BIDOSE,BIAGRP)),8,0)_"   "
 .F BIAGRP=1:1:5 S Y=+$G(^TMP("BIREPP1",$J,"TALLY",BIDOSE,BIAGRP)),X=X_$J(Y,8,0)_"   "
 .D WRITE(.BILINE,X)
 .S X="                |  "
 .F BIAGRP=1:1:5 D
 ..N Y,Z S Y=+$G(^TMP("BIREPP1",$J,"TALLY",BIDOSE,BIAGRP))
 ..S Z=+$G(^TMP("BIREPP1",$J,"TOTALPATS",BIAGRP))
 ..S X=X_$J(100*$S(Z:Y/Z,1:0),8,0)_"%  "
 .D WRITE(.BILINE,X)
 .D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Write PCV13 Totals line.
 S X=" Total Doses    |  "
 D WRITE(.BILINE,X) D MARK^BIW(BILINE,2,"BIREPP1")
 S X=" in Date Range  |  "
 F N=1:1:5 S X=X_$J(+$G(^TMP("BIREPP1",$J,"TOTALPCV13",N)),8,0)_"   "
 D WRITE(.BILINE,X)
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Set final VALMCNT (Listman line count).
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
EXPORT ;EP
 ;---> Export PCV Report patients to Excel(csv) File, and return to PCV Report.
 D EXPORT1
 ;---> BINOUP=1 means do not update report.
 S BINOUP=1
 D RESET^BIREPP1
 Q
 ;
 ;
 ;----------
EXPORT1 ;EP
 ;---> Export PCV Report patients to Excel(csv) File.
 ;
 I '$O(^TMP("BIREPP1",$J,"BIDFN",0)) D  Q
 .W !!?3,"There is no patient data to export." D DIRZ^BIUTL3()
 ;
 N BIDT,BIDUZ2,BIFLNM,BINOW,BIPATH,BIPOP,BISITE
 D NOW^%DTC S BIDT=$E(%,4,7)_"_"_$E(%,9,12)
 S BIFLNM="PCV Export "_BIDT_".csv"
 D HFS^BIEXPRT8(BIFLNM,.BIPATH,1,.BIPOP)
 I $G(BIPOP) D ^%ZISC W !!?3,"Failure to open Host File." D DIRZ^BIUTL3() Q
 ;---> Host file is open.
 ;
 ;---> Use "," for CSV delimiter.
 N Q,D S Q="""",D=Q_","_Q
 ;---> Write Title Header row.
 ;---> Date String, BINOW
 D
 .N %,X,Y D NOW^%DTC S Y=$E(%,1,12) D DD^%DT S BINOW=Y
 ;---> Facility String, BIDUZ2
 S BIDUZ2=$$INSTTX^BIUTL6($G(DUZ(2)))
 N Y S Y=Q_"PCV Report Patient Export"_D_"at "_BIDUZ2_D_"on "_BINOW
 I $G(BIUP)]"" S Y=Y_D_"User Population: "_$$BIUPTX^BIUTL6(BIUP)_Q
 W Y,!
 ;
 ;---> Write Column Headers row.
 S Y=Q_"Patient Name"_D_"Date of Birth"_D_"Chart#"_D_"Current Community"
 S Y=Y_D_"CVX#1"_D_"Date"_D_"Invalid Code"
 S Y=Y_D_"CVX#2"_D_"Date"_D_"Invalid Code"
 S Y=Y_D_"CVX#3"_D_"Date"_D_"Invalid Code"
 S Y=Y_D_"CVX#4"_D_"Date"_D_"Invalid Code"
 S Y=Y_D_"CVX#5"_D_"Date"_D_"Invalid Code"
 S Y=Y_D_"CVX#6"_D_"Date"_D_"Invalid Code"_Q
 W Y,!
 ;
 ;---> Write data records.
 N BIDFN S BIDFN=0
 F  S BIDFN=$O(^TMP("BIREPP1",$J,"BIDFN",BIDFN)) Q:'BIDFN  D
 .Q:'$D(^TMP("BIREPP1",$J,"BIDFN",BIDFN,"EXPORT"))
 .N BIDATA,BIPNAME,BICC
 .S BIDATA=^TMP("BIREPP1",$J,"BIDFN",BIDFN,"EXPORT")
 .S BIPNAME=$$NAME^BIUTL1(BIDFN)
 .S BIDOB=$$DOBF^BIUTL1(BIDFN,,1,1)
 .S BIHRCN=$$HRCN^BIUTL1(BIDFN,$G(DUZ(2)),1)
 .S BICC=$$CURCOM^BIUTL11(BIDFN,1)
 .S Q="""",D=Q_","_Q
 .W Q_BIPNAME_D_BIDOB_D_BIHRCN_D_BICC_D_BIDATA_Q,!
 ;
 ;---> Close the host file and report its location.
 D ^%ZISC
 D TITLE^BIUTL5("EXPORT PCV PATIENT DATA TO EXCEL FILE")
 W !!?5,"The PCV Report patient data has been exported to:"
 W !!?10,BIPATH_BIFLNM
 D TEXT3^BIEXP
 D DIRZ^BIUTL3()
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
 D WL^BIW(.BILINE,"BIREPP1",$G(BIVAL),$G(BIBLNK))
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
