BIREPF ;IHS/CMI/MWR - REPORT, FLU IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW INFLUENZA IMMUNIZATION REPORT.
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for printing Immunization Due Letters.
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
 ;---> Main entry point for BI LETTER PRINT DU
 D EN^VALM("BI REPORT FLU IMM")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.  vvv83
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"INFLUENZA IMMUNIZATION REPORT" D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 D WRITE(.BILINE,,1)
 ;---> Year.
 I '$G(BIYEAR),$G(DT) D
 .;---> If today is Jan=Aug, set default year=last year.
 .I +$E(DT,4,5)<9 S BIYEAR=1700+$E(DT,1,3)-1 Q
 .;---> If today is Sept=Dec, set default year=this year.
 .S BIYEAR=1700+$E(DT,1,3)
 ;
 S X="     1 - Report Year (Flu Season).......: "_+BIYEAR_"/"_(BIYEAR+1)
 S X=X_"  (09/01/"_$E(BIYEAR,3,4)
  D
  .I $P(BIYEAR,U,2)="m" S X=X_" - 03/31/"_$E((BIYEAR+1),3,4)_")" Q
  .S X=X_" - 12/31/"_$E(BIYEAR,3,4)_")"
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPF",.BICC,"Community",2,1,,,40)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPF",.BIHCF,A,3,2,,,40,B) K A,B
 ;
 ;---> Case Manager.
 D DISP^BIREP(.BILINE,"BIREPF",.BICM,"Case Manager",4,3,,,40)
 ;
 ;---> Beneficiary Type.
 S:$O(BIBEN(0))="" BIBEN(1)=""
 D DISP^BIREP(.BILINE,"BIREPF",.BIBEN,"Beneficiary Type",5,4,,,40)
 ;
 ;---> User Population.
 D:($G(BIUP)="")
 .I $$GPRAIEN^BIUTL6 S BIUP="a" Q
 .S BIUP="u"
 ;
 S X="     6 - Patient Population Group.......: "
 D
 .I BIUP="r" S X=X_"Registered Patients (All)" Q
 .I BIUP="i" S X=X_"Immunization Register Patients (Active)" Q
 .I BIUP="u" S X=X_"User Population (1 visit, 3 yrs)" Q
 .I BIUP="a" S X=X_"Active Users (2+ visits, 3 yrs)" Q
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Report Type.
 S:($G(BIFH)="") BIFH="F"
 S X="     7 - Report Type (Standard or H1N1).: "_$S(BIFH="H":"H1N1",1:"Standard Flu")
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPF"
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPF",$G(BIVAL),$G(BIBLNK))
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT Q
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
 ;----> Explanation of this report.  vvv83
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("INFLUENZA IMMUNIZATION REPORT - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;INFLUENZA IMMUNIZATION REPORT
 ;;
 ;;This Influenza Report is designed to comply with influenza vaccination
 ;;recommendations for patients of all ages.  The report examines the
 ;;influenza season (9/1 - 12/31) for the year selected. (An end date of
 ;;3/31 may also be selected.)
 ;;
 ;;
 ;;Report Columns
 ;;--------------_
 ;;The "Age in Months" is calculated on 12/31 of the year selected,
 ;;in order to include children who were at least 6 months of age during
 ;;entire influenza season (9/1 - 12/31).
 ;;
 ;;The first column, 10-23 months, includes children who were 6-23 months
 ;;old during the influenza season of the selected year.
 ;;
 ;;The second column, 24-59 months, includes children who were 24-59
 ;;months during the entire influenza season of the selected year, and
 ;;so on for the remaining age groups.
 ;;
 ;;NOTE: The column headed "18-49hr" represents patients whose history
 ;;puts them in the High Risk category.  Patient statistics in this
 ;;column are NOT include in the "18-49y" column.
 ;;
 ;;
 ;;Report Rows
 ;;------------
 ;;The "Denominator" row of the report is the number of patients within
 ;;that age group who are included in the report.
 ;;    NOTE: Any patient who was Inactivated prior to 12/31 of the year
 ;;          selected will not be included in the report.
 ;;
 ;;The "1-Influenza year season" row of the report includes all patients
 ;;who received at least one dose during the influenza season of the year
 ;;selected (Sept-Dec).
 ;;
 ;;The "Fully immunized" row of the report includes children ages who are:
 ;;
 ;;  10-23 Months Old:
 ;;    1) Received 2 doses during the influenza season of the year selected.
 ;;       (Sept 1 - Dec 31 or Mar 31, whichever is selected),
 ;;   or
 ;;    2) Received 1+ dose before Sept 1 and 1+ dose during Sept-Dec/March.
 ;;
 ;;  24-59 Months Old:
 ;;    1) Received 2 doses during the influenza season of the year selected.
 ;;       (Sept 1 - Dec 31 or Mar 31, whichever is selected),
 ;;   or
 ;;    2) Received 2+ dose before Sept 1 and 1+ dose during Sept-Dec/March.
 ;;
 ;;All other age columns reflect patients who were fully immunized by
 ;;receiving a signal dose in the current season.
 ;;
 ;;The INFLUENZA IMMUNIZATION REPORT screen allows you to adjust the
 ;;report to your needs.
 ;;
 ;;There are 7 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-7) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the Influenza Report or P to print it.
 ;;
 ;;If it customarily takes a long time for your computer to prepare
 ;;this report, it may be preferable to Print and Queue the report
 ;;to a printer, rather than Viewing it on screen.  (This would avoid
 ;;tying up your screen while the report is being prepared.)
 ;;
 ;;REPORT YEAR: The report will compile influenza immunization rates
 ;;for the year entered, in the date range of 9/1 to 12/31.  An optional
 ;;End Date of 3/31 following the selected report year is also available.
 ;;
 ;;COMMUNITY: If you select for specific Communities, only patients
 ;;whose Current Community matches one of the Communities selected will
 ;;be included in the report.  "Current Community" is refers to Item 6
 ;;on Page 1 of the RPMS Patient Registration.
 ;;
 ;;HEALTH CARE FACILITY: If you select for specific Health Care
 ;;Facilities, only Patients who have active Chart#'s at one or more
 ;;of the selected Facilities will be included in the report.
 ;;
 ;;CASE MANAGER: If you select for specific Case Managers, only
 ;;patients who have the selected Case Managers will be included
 ;;in the report.
 ;;
 ;;BENEFICIARY TYPE: If you select for specific Beneficiary Types,
 ;;only patients whose Beneficiary Type is one of those you select
 ;;will be included in the report.  "Beneficiary Type" refers to
 ;;Item 3 on Page 2 of the RPMS Patient Registration.
 ;;
 ;;PATIENT POPULATION GROUP: You may select one of four patient groups
 ;;to be considered in the report: Registered Patients (All),
 ;;Immunization Register Patients (Active), User Population (1+ visits
 ;;in 3 yrs), or Active Clinical Users (2+ visits in 3 yrs).
 ;;Active Clinical Users is the default.
 ;;
 ;;REPORT TYPE: If you select Standard Report, the report will display
 ;;statistics for standard influenza immunizations (excluding H1N1).
 ;;If you select H1N1, then only statistics for H1N1 immunizations
 ;;will be displayed.
 ;;
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
 K ^TMP("BIREPF",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
