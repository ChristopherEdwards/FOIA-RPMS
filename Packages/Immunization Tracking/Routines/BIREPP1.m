BIREPP1 ;IHS/CMI/MWR - REPORT, PCV; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT PCV REPORT.
 ;
 ;
 ;----------
START(BIX) ;EP
 ;---> Prepare and display or print PCV Report.
 ;---> Parameters:
 ;     1 - BIX    (req) If BIX="PRINT", then print Report.
 ;                      If BIX="VIEW", then view Report (default).
 ;---> Variables:
 ;     1 - BIBEGDT (req) Begin date of report.
 ;     2 - BIENDDT (req) End date of report.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIUP    (req) User Population/Group (r,i,u,a).
 ;                       (Registered, Imm Reg Active, User 1+, Active 2+).
 ;
 ;         NOT USED FOR NOW.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIHIST  (req) Include Historical (1=yes,0=no).
 ;     8 - BIVT    (req) Visit Type array.
 ;     9 - BIPOP   (ret) BIPOP=1 if error.
 ;
 ;---> Check for required Variables.
 I '$G(BIBEGDT) D ERROR(626) D RESET^BIREPP Q
 I '$G(BIENDDT) D ERROR(627) D RESET^BIREPP Q
 I '$D(BICC) D ERROR(614) D RESET^BIREPP Q
 ;I '$D(BIHCF) D ERROR(625) D RESET^BIREPP Q
 ;
 ;
 S:$G(BIUP)="" BIUP="u"
 S BIAGRPS="0059,0223,2459,0611,1223"
 ;
 ;---> BITOTPTS=Total Patients, used by HDR code after EN.
 N BINOUP,BIRTN,BITOTPTS,BITOTFPT
 S BIRTN="BIREPP1"
 ;
 D SETVARS^BIUTL5
 N VALMCNT
 I $G(BIX)="PRINT" D PRINT,RESET^BIREPP Q
 D EN
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
 K VALMHDR,^TMP("BIREPP1",$J),^TMP("BIDUL",$J)
 N VALM,VALMHDR
 D HDR
 D GET^BIREPP2(BIBEGDT,BIENDDT,.BICC,BIUP)
 D DISPLAY^BIREPP2
 D PRTLST^BIUTL8("BIREPP1")
 D EXIT  ;,RESET^BIREPP
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for List Template BI REPORT QUARTERLY IMM1.
 D EN^VALM("BI REPORT PCV1")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 D HEAD^BIREPP2(BIBEGDT,BIENDDT,.BICC,BIUP)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;---> Local Variable:
 ;     1 - BINOUP  (opt) If BINOUP=1, then do NOT update.
 ;
 S VALM("TITLE")=$$LMVER^BILOGO
 W !!?10,"This may take some time.  Please hold on...",!
 D:'$G(BINOUP) GET^BIREPP2(BIBEGDT,BIENDDT,.BICC,BIUP)
 D DISPLAY^BIREPP2
 ;---> Set up ZTSAVE in case user Queues from PL in List.
 D ZSAVES^BIUTL3
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 ;---> Local Variable:
 ;     1 - BINOUP  (opt) If BINOUP=1, then do NOT update.
 ;
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Use arrow keys to scroll up and down through the report, or"
 W !?5,"type ""??"" for more actions, such as Search and Print List."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> Cleanup, EOJ.
 K ^TMP("BIREPP1",$J),^TMP("BIDFN",$J),^TMP("BIDUL",$J)
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
 S ZTRTN="DEQUEUE^BIREPP1"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Prepare and print Quarterly Report.
 K VALMHDR,^TMP("BIREPP1",$J),^TMP("BIDUL",$J)
 D HDR
 D GET^BIREPP2(BIBEGDT,BIENDDT,.BICC,BIUP)
 D DISPLAY^BIREPP2
 D PRTLST^BIUTL8("BIREPP1"),EXIT
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
