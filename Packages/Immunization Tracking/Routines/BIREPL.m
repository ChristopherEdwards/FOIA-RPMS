BIREPL ;IHS/CMI/MWR - REPORT, ADULT IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADULT IMMUNIZATION REPORT: PARAMETERS VIEW MENU
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
 D EN^VALM("BI REPORT ADULT IMM")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"ADULT IMMUNIZATION REPORT" D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Date.
 D WRITE(.BILINE)
 S:'$G(BIQDT) BIQDT=$G(DT)
 D DATE^BIREP(.BILINE,"BIREPL",1,BIQDT,"Quarter Ending Date",,,,1)
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPL",.BICC,"Community",2,1)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPL",.BIHCF,A,3,2,,,,B) K A,B
 ;
 ;---> Beneficiary Type.
 S:$O(BIBEN(0))="" BIBEN(1)=""   ;vvv83
 D DISP^BIREP(.BILINE,"BIREPL",.BIBEN,"Beneficiary Type",4,4)
 ;
 ;---> Include CPT Coded Visits.
 S:'$D(BICPTI) BICPTI=0
 S X="     5 - Include CPT Coded Visits...: "
 S X=X_$S($G(BICPTI):"YES",1:"NO")
 D WRITE(.BILINE,X,1)
 K X
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
 S BIRTN="BIREPL"
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
 D WL^BIW(.BILINE,"BIREPL",$G(BIVAL),$G(BIBLNK))
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
 D START^BIHELP("ADULT IMMUNIZATION REPORT - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;This report will provide statistics on Adult Immunizations.
 ;;The population of patients reviewed are those 19 years and older.
 ;;
 ;;Criteria:
 ;;Tetanus:  The patient must have had a tetanus immunization documented
 ;;in the past 10 years.  This includes any of the following CVX Codes:
 ;;1, 9, 20, 22, 28, 50, 106, 107, 110, 113, 115.
 ;;If parameter 5 "Include CPT Coded Visits" is set to "yes", then any
 ;;of the following codes will count: 90701,90718,90700,90720,90702,
 ;;90703,90721,90723.
 ;;
 ;;Pneumovax:  Adults 65 years and older must have had a pneumococcal
 ;;immunization documented at or after age 65 years.  This includes any
 ;;of the following CVX Codes: 33, 100, 109.
 ;;
 ;;When VIEWING the report on-screen, you will be able to view the
 ;;lists of patients who were "Current" or "Not Current."
 ;;In this context, the list of "Current" adults includes those who
 ;;are current for Td/Tdap (within the last 10 years) and for pneumo
 ;;vaccines on the date of the report.
 ;;
 ;;The IMMUNIZATION ADULT REPORT screen allows you to adjust the
 ;;report to your needs.
 ;;
 ;;There are 6 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-6) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like more information on the parameter you are changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the Adult Report or P to print it.
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
 ;;COMMUNITIES: If you select for specific Communities, only patients
 ;;whose Current Community matches one of the Communities selected will
 ;;be included in the report.  "Current Community" is refers to Item 6
 ;;on Page 1 of the RPMS Patient Registration.
 ;;NOTE: You may want to select the GPRA set of Communities, in order
 ;;to more closely match the GPRA report produced by the CRS module
 ;;(RPMS Clinical Reporting System).
 ;;
 ;;HEALTH CARE FACILITIES: If you select for specific Health Care
 ;;Facilities, only Patients who have active Chart#'s at one or more
 ;;of the selected Facilities will be included in the report.
 ;;
 ;;BENEFICIARY TYPES: If you select for specific Beneficiary Types,
 ;;only patients whose Beneficiary Type is one of those you select
 ;;will be included in the report.  "Beneficiary Type" refers to
 ;;Item 3 on Page 2 of the RPMS Patient Registration.
 ;;
 ;;INCLUDE CPT CODED VISITS: If you answer "YES" to this question
 ;;the report will search for any immunizations that were only entered
 ;;as CPT Codes, and it will include those immunizations in the
 ;;statistical results of this report.
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
 ;---> End of job cleanup.
 D KILLALL^BIUTL8(1)
 K ^TMP("BIREPL",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
