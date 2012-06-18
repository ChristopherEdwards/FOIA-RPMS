BIREPQ1 ;IHS/CMI/MWR - REPORT, QUARTERLY IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT QUARTERLY IMMUNIZATION REPORT.
 ;
 ;
 ;----------
START(BIX) ;EP
 ;---> VIEW Quarterly Report.
 ;---> Prepare and display Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIX    (req) If BIX="PRINT", then print Qtr Report.
 ;                      If BIX="VIEW", then view Qtr Report (default).
 ;---> Variables:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIHPV  (opt) 1=Include Varicella & Pneumo.
 ;     7 - BIPOP  (ret) BIPOP=1 if error.
 ;
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERROR(622) D RESET^BIREPQ Q
 I '$D(BICC) D ERROR(614) D RESET^BIREPQ Q
 I '$D(BIHCF) D ERROR(625) D RESET^BIREPQ Q
 I '$D(BICM)  D ERROR(615) D RESET^BIREPQ Q
 I '$D(BIBEN) D ERROR(662) D RESET^BIREPQ Q
 S:'$D(BIHPV) BIHPV=1
 S:$G(BIUP)="" BIUP="u"
 ;
 D SETVARS^BIUTL5 N VALMCNT
 I $G(BIX)="PRINT" D PRINT,RESET^BIREPQ Q
 ;
 ;---> Set BIAG for Age Range in header of report.
 ;---> Set BIRPDT for Report Date ("Quarterly, etc.).
 ;---> Set BIRTN in case user runs Patient List then needs to return
 ;---> to INIT here.
 ;---> Set BITITL for Report Name in Patient List, if called.  vvv83
 N BIAG,BIRPDT,BIRTN,BITITL
 S BIAG="3-27",BIRPDT=BIQDT,BIRTN="BIREPQ1",BITITL="3-27 MONTH"
 D EN
 D RESET^BIREPQ
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Main entry point for printing the Quarterly Immunization Report.
 D DEVICE(.BIPOP)
 Q:$G(BIPOP)
 ;
 D:$G(IO)'=$G(IO(0))
 .W !!?10,"This may take some time.  Please hold on...",!
 ;
 ;---> Prepare report.
 K ^TMP("BIREPQ1",$J),^TMP("BIDUL",$J)
 N VALM,VALMHDR
 D HDR,START^BIREPQ2(BIQDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHPV,BIUP)
 ;
 D PRTLST^BIUTL8("BIREPQ1")
 D EXIT,RESET^BIREPQ
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for List Template BI REPORT QUARTERLY IMM1.
 D EN^VALM("BI REPORT QUARTERLY IMM1")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 D HEAD^BIREPQ2(BIQDT,.BICC,.BIHCF,.BICM,.BIBEN,BIUP)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 K ^TMP("BIREPQ1",$J),^TMP("BIDUL",$J)
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="To view patient rosters, select a group below:"
 W !!?10,"This may take some time.  Please hold on...",!
 D START^BIREPQ2(BIQDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHPV,BIUP)
 ;---> Set up ZTSAVE in case user Queues from PL in List.
 D ZSAVES^BIUTL3
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR
 Q
 ;
 ;
 ;----------
RESET1 ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="To view patient lists, select a group below:"
 D HDR
 Q
 ;
 ;  vvv83
 ;----------
HELP ;EP
 N BIX S BIX=X
 D FULL^VALM1 N BIPOP
 D TITLE^BIUTL5("VIEW 3-27 MONTH REPORT - HELP, page 1 of 1")
 D TEXT1,DIRZ^BIUTL3()
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;  vvv83
 ;----------
TEXT1 ;EP
 ;;You have chosen to View the 3-27 Month Report rather than Print it.
 ;;(You may print the report from here as well by entering "PL".)
 ;;
 ;;Also, you may:
 ;;
 ;;Enter "N" to view the list of Patients who were NOT Current
 ;;          or "NOT up-to-date" with their immunizations, according
 ;;          to recommendeded guidelines for their age.
 ;;
 ;;Enter "C" to view the list of Patients who were CURRENT or
 ;;          "up-to-date" with their immunizations, according to
 ;;          recommendeded guidelines for their age.
 ;;
 ;;Enter "B" to view a list of both groups of patients combined.
 ;;
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> Cleanup, EOJ.
 K ^TMP("BIREPQ1",$J),^TMP("BIDUL",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
DEVICE(BIPOP) ;EP
 ;---> Get Device and possibly queue to Taskman.
 ;---> Parameters:
 ;     1 - BIPOP (ret) If error or Queue, BIPOP=1
 ;
 K %ZIS,IOP S BIPOP=0
 S ZTRTN="DEQUEUE^BIREPQ1"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;
 ;---> Prepare and print Quarterly Report.
 K VALMHDR,^TMP("BIREPQ1",$J)
 D HDR^BIREPQ1,START^BIREPQ2(BIQDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHPV,BIUP)
 D PRTLST^BIUTL8("BIREPQ1"),EXIT
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
ERROR(BIERR) ;EP
 ;---> Report error, either to screen or print.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 D ERRCD^BIUTL2($G(BIERR),,1) S BIPOP=1
 Q
