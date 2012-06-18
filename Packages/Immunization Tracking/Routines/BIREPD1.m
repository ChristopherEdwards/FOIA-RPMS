BIREPD1 ;IHS/CMI/MWR - REPORT, ADOLESCENT RATES; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT ADOLESCENT IMMUNIZATION RATES REPORT.
 ;
 ;
 ;----------
START(BIX) ;EP
 ;---> Prepare and display or print Adolescent Rates Report.
 ;---> Parameters:
 ;     1 - BIX    (req) If BIX="PRINT", then print Report.
 ;                      If BIX="VIEW", then view Report (default).
 ;---> Variables:
 ;     1 - BIQDT   (req) Quarter Ending Date.
 ;     2 - BIDAR   (opt) Adolescent Report Age Range: 11-17.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIUP    (req) User Population/Group
 ;                       (Registered, Imm Reg Active, User 1+, Active 2+).
 ;     8 - BIPOP   (ret) BIPOP=1 if error.
 ;
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERRCD^BIUTL2(622,,1) D RESET^BIREPD Q
 I '$D(BICC) D ERRCD^BIUTL2(614,,1) D RESET^BIREPD Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,,1) D RESET^BIREPD Q
 I '$D(BICM)  D ERRCD^BIUTL2(615,,1) D RESET^BIREPD Q
 I '$D(BIBEN) D ERRCD^BIUTL2(662,,1) D RESET^BIREPD Q
 I '$G(BISITE) S BISITE=$G(DUZ(2))
 I '$G(BISITE) D ERRCD^BIUTL2(109,,1) D RESET^BIREPD Q
 ;
 S:$G(BIUP)="" BIUP="u"
 S:'$G(BIDAR) BIDAR="11-17^1"
 S BIAGRPS="1112,1313,1317"
 ;
 ;---> BITOTPTS=Total Patients, used by HDR code after EN.
 N BITOTPTS,BITOTFPT,BITOTMPT
 ;
 D SETVARS^BIUTL5 N VALMCNT
 I $G(BIX)="PRINT" D PRINT,RESET^BIREPD Q
 ;
 ;
 ;---> Set BIAG for Age Range in header of report.
 ;---> Set BIRPDT for Report Date ("Quarterly, etc.).
 ;---> Set BIRTN in case user runs Patient List then needs to return
 ;---> to INIT here.
 ;---> Set BITITL for Report Name in Patient List, if called.
 N BIRPDT,BIRTN,BITITL
 S BIRPDT=BIQDT,BIRTN="BIREPD1",BITITL="ADOLESCENT"
 D EN
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Main entry point for printing the Adolescent Rates Report.
 D DEVICE(.BIPOP)
 Q:$G(BIPOP)
 ;
 D:$G(IO)'=$G(IO(0))
 .W !!?10,"This may take some time.  Please hold on...",!
 ;
 ;---> Prepare report.
 K ^TMP("BIREPD1",$J),^TMP("BIDUL",$J)
 N VALM,VALMHDR
 D START^BIREPD2(BIQDT,BIDAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BISITE,BIUP),HDR
 ;
 D PRTLST^BIUTL8("BIREPD1")
 D EXIT,RESET^BIREPD
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for List Template BI REPORT ADOLESCENT RATES1.
 D EN^VALM("BI REPORT ADOLESCENT RATES1")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 D HEAD^BIREPD2(BIQDT,BIDAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BIUP)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S VALM("TITLE")=$$LMVER^BILOGO
 W !!?10,"This may take some time.  Please hold on...",!
 K ^TMP("BIREPD1",$J),^TMP("BIDUL",$J)
 D START^BIREPD2(BIQDT,BIDAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BISITE,BIUP)
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
 D INIT,HDR Q
 ;
 ;
 ;----------
HELP ;EP
 N BIX S BIX=X
 D FULL^VALM1 N BIPOP
 D TITLE^BIUTL5("VIEW ADOLESCENT REPORT - HELP")
 D TEXT1,DIRZ^BIUTL3()
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;You have chosen to View the Adolescent Report rather than Print it.
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
 K ^TMP("BIREPD1",$J)
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
 S ZTRTN="DEQUEUE^BIREPD1"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;
 ;---> Prepare and print Two-Year-Old Report.
 K VALMHDR,^TMP("BIREPD1",$J)
 D HDR^BIREPD1
 D START^BIREPD2(BIQDT,BIDAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BISITE,BIUP)
 D PRTLST^BIUTL8("BIREPD1"),EXIT
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
