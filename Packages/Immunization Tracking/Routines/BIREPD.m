BIREPD ;IHS/CMI/MWR - REPORT, ADOLESCENT RATES; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADOLESCENT IMMUNIZATION RATES REPORT.
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for Adolescent Immunization Rates.
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
 ;---> Main entry point for BI REPORT ADOLESCENT RATES.
 D EN^VALM("BI REPORT ADOLESCENT RATES")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 K ^TMP("BIREPD",$J)
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"ADOLESCENT IMMUNIZATION RATES REPORT"
 D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Date.
 D WRITE(.BILINE)
 S:'$G(BIQDT) BIQDT=$G(DT)
 D DATE^BIREP(.BILINE,"BIREPD",1,$G(BIQDT),"Quarter Ending Date",,,,1)
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPD",.BICC,"Community",2,1)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPD",.BIHCF,A,3,2,,,,B) K A,B
 ;
 ;---> Case Manager.
 D DISP^BIREP(.BILINE,"BIREPD",.BICM,"Case Manager",4,3)
 ;
 ;---> Beneficiary Type.
 S:$O(BIBEN(0))="" BIBEN(1)=""
 D DISP^BIREP(.BILINE,"BIREPD",.BIBEN,"Beneficiary Type",5,4)
 ;
 ;---> User Population.
 D:($G(BIUP)="")
 .I $$GPRAIEN^BIUTL6 S BIUP="a" Q
 .S BIUP="u"
 ;
 S X="     6 - Patient Population Group...: "
 D
 .I BIUP="r" S X=X_"Registered Patients (All)" Q
 .I BIUP="i" S X=X_"Immunization Register Patients (Active)" Q
 .I BIUP="u" S X=X_"User Population (1 visit, 3 yrs)" Q
 .I BIUP="a" S X=X_"Active Users (2+ visits, 3 yrs)" Q
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPD"
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
 D WL^BIW(.BILINE,"BIREPD",$G(BIVAL),$G(BIBLNK))
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
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("ADOLESCENT IMM RATES - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP  vvv83
 ;;
 ;;Adolescent Report
 ;;
 ;;The Adolescent report follows the logic of the National
 ;;Immunization Survey to provide immunization coverage rates for
 ;;single vaccines and groups of vaccines in children  11-12 years,
 ;;13 years and 13-17 years of age by certain key ages  (i.e.
 ;;3 Hep B and 2 MMR and 1-Td/Tdap, 3-HepB, 2-MMR,1-Var) by the
 ;;the date of the report.  Current status is defined as 1-Tdap_Td
 ;;and 1-Mening.
 ;;
 ;;This report displays Active clinical users who are between 11
 ;;years 0 months and 17 years 11 months of age on the selected date
 ;;of the report.  (An Active clinical user is defined as a person
 ;;who has had at least two clinical visits in the past three years.)
 ;;
 ;;The key ages by which vaccines were received are listed across
 ;;the top of the report.  Total patients who received each dose
 ;;of the vaccines  for each age-group are listed in rows beside
 ;;each dose (e.g., the total patients (%) receiving 3-HepB by
 ;;11-12 years.  The date header on far left header signifies
 ;;"doses received by the report date" and includes all doses a
 ;;child received up to the "Quarter Ending Date" chosen.
 ;;All percentages represent a fraction of the total patients as
 ;;noted at the top and bottom of the report.
 ;;
 ;;The ADOLESCENT IMMUNIZATIONS RATES screen allows you to adjust
 ;;the report to your needs.
 ;;
 ;;There are 6 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-6) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the Adolescent Report or P to print it.
 ;;
 ;;If it customarily takes a long time for your computer to prepare
 ;;this report, it may be preferable to Print and Queue the report
 ;;to a printer, rather than Viewing it on screen.  (This would avoid
 ;;tying up your screen while the report is being prepared.)
 ;;
 ;;QUARTER ENDING DATE: The report will compile immunization rates
 ;;as of the date entered.  Typically, this date would be the end
 ;;of a Quarter.
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
 ;---> EOJ cleanup.
 D KILLALL^BIUTL8(1)
 K ^TMP("BIREPD",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
