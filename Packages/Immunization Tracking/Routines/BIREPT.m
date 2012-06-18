BIREPT ;IHS/CMI/MWR - REPORT, TWO-YR-OLD RATES; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW TWO-YR-OLD IMMUNIZATION RATES REPORT.
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for Listman Two-Yr-Old Immunization Rates.
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
 ;---> Main entry point for BI REPORT TWO-YR-OLD RATES.
 D EN^VALM("BI REPORT TWO-YR-OLD RATES")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 K ^TMP("BIREPT",$J)
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"TWO-YR-OLD IMMUNIZATION RATES REPORT"
 D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Date.
 D WRITE(.BILINE)
 S:'$G(BIQDT) BIQDT=$G(DT)
 D DATE^BIREP(.BILINE,"BIREPT",1,$G(BIQDT),"Quarter Ending Date",,,,1)
 ;
 ;---> Two-Yr-Old Age Range.
 S:'$G(BITAR) BITAR="19-35"
 S X="     2 - Age Range..................: "
 S X=X_BITAR_" months"
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPT",.BICC,"Community",3,1)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPT",.BIHCF,A,4,2,,,,B) K A,B
 ;
 ;---> Case Manager.
 D DISP^BIREP(.BILINE,"BIREPT",.BICM,"Case Manager",5,3)
 ;
 ;---> Beneficiary Type.
 S:$O(BIBEN(0))="" BIBEN(1)=""
 D DISP^BIREP(.BILINE,"BIREPT",.BIBEN,"Beneficiary Type",6,4)
 ;
 ;---> User Population.
 D:($G(BIUP)="")
 .I $$GPRAIEN^BIUTL6 S BIUP="i" Q
 .S BIUP="u"
 ;
 S X="     7 - Patient Population Group...: "
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
 S BIRTN="BIREPT"
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
 D WL^BIW(.BILINE,"BIREPT",$G(BIVAL),$G(BIBLNK))
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
 D START^BIHELP("TWO-YR-OLD IMM RATES - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;Two-Yr-Old Report
 ;;
 ;;The Two-Yr-Old report follows the logic of the National
 ;;Immunization Survey to provide immunization coverage rates for
 ;;single vaccines and groups of vaccines in children 19 to 35 months
 ;;of age by certain key ages (i.e., DTaP by 3 months, by 5 months,
 ;;by 7 months, by 16 months, by 19 months, by 24 months and by the
 ;;date of the report).  A nationally reported parameter is the
 ;;percent of children 19-35 months of age who had ever received
 ;;4-DTP, 3-Polio, 1-MMR, 3-Hib, 3-HepB (43133).
 ;;
 ;;This report displays Active children who are between 19 and 35
 ;;months of age on the selected date of the report.  The key ages
 ;;by which vaccines were received are listed across the top of the
 ;;report.  Total patients who received each dose of the vaccines
 ;;are listed in rows beside each dose and are cumulative from left
 ;;to right (e.g., the total patients receiving 1-DTaP by 16 months
 ;;includes those who received it by 3, 5 and 7 months).
 ;;
 ;;The date header on far right column signifies "received by the
 ;;report date" and includes all doses a child received up to the
 ;;"Quarter Ending Date" chosen.  This is the column that compares with
 ;;the National Immunization Survey and Year 2010 Health Objectives.
 ;;All percentages represent a fraction of the total patients as
 ;;noted at the top and bottom of the report.
 ;;
 ;;
 ;;The TWO-YR-OLD IMMUNIZATIONS RATES screen allows you to adjust
 ;;the report to your needs.
 ;;
 ;;There are 7 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-7) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the Two-Year-Old Report or P to print it.
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
 ;;
 ;;HEALTH CARE FACILITIES: If you select for specific Health Care
 ;;Facilities, only Patients who have active Chart#'s at one or more
 ;;of the selected Facilities will be included in the report.
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
 ;;PATIENT POPULATION GROUP: You may select one of four patient groups
 ;;to be considered in the report: Registered Patients (All),
 ;;Immunization Register Patients (Active), User Population (1+ visits
 ;;in 3 yrs), or Active Clinical Users (2+ visits in 3 yrs).
 ;;Immunization Register Patients (Active) is the default.
 ;;
 ;;INCLUDE VARICELLA & PNEUMO: This option allows you to include Varicella
 ;;and Pneumo in the statistics of the "Appropriate for Age" row at the
 ;;top of the report.
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
 K ^TMP("BIREPT",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
