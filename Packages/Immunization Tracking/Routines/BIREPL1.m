BIREPL1 ;IHS/CMI/MWR - REPORT, ADULT IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT ADULT IMMUNIZATION REPORT.
 ;
 ;
 ;----------
START(BIX) ;EP
 ;---> VIEW ADULT Report.
 ;---> Prepare and display Adult Immunization Report.
 ;---> Parameters:
 ;     1 - BIX    (req) If BIX="PRINT", then print Adult Report.
 ;                      If BIX="VIEW", then view Adult Report (default).
 ;---> Variables:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BIBEN  (req) Beneficiary Type array.
 ;     5 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT (default).
 ;     6 - BIUP   (req) User Population/Group
 ;                      (Registered, Imm Reg Active, User 1+, Active 2+).
 ;
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERROR(622) D RESET^BIREPL Q
 I '$D(BICC) D ERROR(614) D RESET^BIREPL Q
 I '$D(BIHCF) D ERROR(625) D RESET^BIREPL Q
 I '$D(BIBEN) D ERROR(662) D RESET^BIREPL Q
 I '$D(BICPTI) S BICPTI=0
 S:$G(BIUP)="" BIUP="u"
 ;
 D SETVARS^BIUTL5 N VALMCNT
 I $G(BIX)="PRINT" D PRINT,RESET^BIREPL Q
 ;
 ;---> Set BIRTN in case user runs Patient List then needs to return
 ;---> to INIT here.
 ;---> Set BITITL for Report Name in Patient List, if called.
 ;---> Set BIAG for Age Range in header of report.
 N BIAG,BIRTN,BITITL S BIRTN="BIREPL1",BITITL="ADULT",BIAG="19+^1"
 D EN
 D RESET^BIREPL
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Main entry point for printing the ADULT Immunization Report.
 D DEVICE(.BIPOP)
 Q:$G(BIPOP)
 ;
 D:$G(IO)'=$G(IO(0))
 .W !!?10,"This may take some time.  Please hold on...",!
 ;
 ;---> Prepare report.
 K ^TMP("BIREPL1",$J),^TMP("BIDUL",$J)
 N VALM,VALMHDR
 D HDR,START^BIREPL2(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP)
 ;
 D PRTLST^BIUTL8("BIREPL1")
 D EXIT,RESET^BIREPL
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for List Template BI REPORT ADULT IMM1.
 D EN^VALM("BI REPORT ADULT IMM1")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 D HEAD^BIREPL2(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 K ^TMP("BIREPL1",$J),^TMP("BIDUL",$J)
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="To view patient rosters, select a group below:"
 W !!?10,"This may take some time.  Please hold on...",!
 D START^BIREPL2(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP)
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
 ;
 ;----------
HELP ;EP
 N BIX S BIX=X
 D FULL^VALM1 N BIPOP
 D TITLE^BIUTL5("VIEW ADULT REPORT - HELP")
 D TEXT1,DIRZ^BIUTL3()
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;You have chosen to View the Adult Report rather than Print it.
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
 K ^TMP("BIREPL1",$J),^TMP("BIDUL",$J)
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
 S ZTRTN="DEQUEUE^BIREPL1"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;
 ;---> Prepare and print ADULT Report.
 K VALMHDR,^TMP("BIREPL1",$J)
 D HDR^BIREPL1,START^BIREPL2(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP)
 D PRTLST^BIUTL8("BIREPL1"),EXIT
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
