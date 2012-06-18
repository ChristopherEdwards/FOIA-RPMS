BIREPH ;IHS/CMI/MWR - REPORT, H1N1 ACCOUNTABILITY; AUG 10,2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW H1N1 ACCOUNTABILITY REPORT.
 ;;  v8.3 PATCH 3: BIREPH* routines are completely new for H1N1 Report.
 ;;  v8.4 PATCH 1: EXPLAIN time frame of report: 8/1/09 to 8/31/10.  TEXT1+21
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for viewing Vaccine Accountability Report.
 D SETVARS^BIUTL5 N BIRTN
 ;
 ;---> If Vaccine Table is not standard, display Error Text and quit.
 I $D(^BISITE(-1)) D ERRCD^BIUTL2(503,,1) Q
 ;
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for BI REPORT VAC ACCOUNTABILITY.
 D EN^VALM("BI REPORT H1N1")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 K ^TMP("BIREPH",$J)
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"H1N1 ACCOUNTABILITY REPORT"
 D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Date Range.
 D
 .;---> Quit if dates have already been selected.
 .Q:$G(BIBEGDT)
 .;---> Default: A week before the previous Sunday to the next Saturday.
 .N X,X1,X2 S X=DT D H^%DTC
 .S X1=DT,X2=-(%Y+7) D C^%DTC S BIBEGDT=X
 .S X1=X,X2=6 D C^%DTC S BIENDDT=X
 ;
 ;D DATERNG^BIREP(.BILINE,"BIREPH",1,BIBEGDT,BIENDDT)
 ;
 D DATERNG^BIREP(.BILINE,"BIREPH",1,BIBEGDT,BIENDDT,1,1,1)
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPH",.BICC,"Community",2,1)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPH",.BIHCF,A,3,2,,,,B)
 ;
 ;---> Case Manager.
 D DISP^BIREP(.BILINE,"BIREPH",.BICM,"Case Manager",4,3)
 ;
 ;---> Beneficiary Type.
 D DISP^BIREP(.BILINE,"BIREPH",.BIBEN,"Beneficiary Type",5,4)
 ;
 ;---> Visit Type.
 D VTYPE^BIREP(.BILINE,"BIREPH",.BIVT,6)
 ;
 ;---> Include Historical.
 N BIHIST1 S BIHIST1=""
 S:'$D(BIHIST) BIHIST=1
 S BIHIST1=$S(BIHIST:"YES",1:"NO")
 S X="     7 - Include Historical.........: "_BIHIST1
 D WRITE(.BILINE,X)
 K X
 ;
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPH"
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
 D WL^BIW(.BILINE,"BIREPH",$G(BIVAL),$G(BIBLNK))
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 ;
 ;---> NOT USED.  Could be used to correct margins.
 ;K VALMHDR S VALM("BM")=15,VALM("LINES")=14,VALM("TM")=2
 D INIT
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""V"" to view this report on screen, ""P"" to print it,"
 W !?5,"or ""H"" to view the Help Text for this report and its parameters."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("VACCINE ACCOUNTABILITY REPORT - HELP",.BITEXT)
 Q
 ;
 ;
 ;
 ;********** PATCH 1, v8.4, AUG 01,2010, IHS/CMI/MWR
 ;---> Explain time frame of report from 8/1/09 to 8/31/10. TEXT1+21
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;The H1n1 Accountability Report provides "doses administered"
 ;;by age group.  This report can be printed for any time period,
 ;;for a given facility, visit type, or community(s).
 ;;
 ;;There are 7 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-7) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the Vaccine Acct Report or P to print it.
 ;;
 ;;If it customarily takes a long time for your computer to prepare
 ;;this report, it may be preferable to Print and Queue the report
 ;;to a printer, rather than Viewing it on screen.  (This would avoid
 ;;tying up your screen while the report is being prepared.)
 ;;
 ;;DATE RANGE: Only immunizations given within the Date Range you
 ;;select will be included in the report. The maximum date range that
 ;;will be examined is 8/1/09 to 8/31/10.
 ;;
 ;;COMMUNITIES: If you select for specific Communities, only patients
 ;;whose Current Community matches one of the Communities selected will
 ;;be included in the report.  "Current Community" is refers to Item 6
 ;;on Page 1 of the RPMS Patient Registration.
 ;;
 ;;HEALTH CARE FACILITIES: If you select for specific Health Care
 ;;Facilities, only immunizations given at the selected Health Care
 ;;Facilities will be included in the report.
 ;;
 ;;CASE MANAGERS: If you select for specific Case Managers, only
 ;;patients who have the selected Case Managers will be included
 ;;in the report.
 ;;
 ;;BENEFICIARY TYPES: If you select for specific Beneficiary Types,
 ;;only patients whose Beneficiary Type is one of those you select
 ;;will be included in the report.  "Beneficiary Type" refers to
 ;;Item 3 on Page 2 of the RPMS Patient Registration.
 ;;
 ;;VISIT TYPES: If you select for specific Visit Types, only visits
 ;;that are classifed with one of the Visit Types you select will
 ;;included in the report.
 ;;
 ;;INCLUDE HISTORICAL: If this parameter is set to "YES", then Visits
 ;;with a Category of "Historical" will be counted in the H1N1
 ;;Accountability Report.  (Category is displayed and edited on the
 ;;ADD/EDIT IMMUNIZATION VISIT Screen.)  If set to "NO", they will
 ;;not be counted in the report.
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> End of job cleanup.
 D KILLALL^BIUTL8(1)
 K ^TMP("BIREPH",$J),^TMP("BIDFN",$J)
 D CLEAR^VALM1
 Q
