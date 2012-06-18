BIREPP ;IHS/CMI/MWR - REPORT, PCV; AUG 10,2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW PCV REPORT.
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
 D EN^VALM("BI REPORT PCV")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 K ^TMP("BIREPP",$J),^TMP("BIDUL",$J)
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"PCV REPORT"
 D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Date Range.
 D
 .;---> Quit if dates have already been selected.
 .Q:$G(BIBEGDT)
 .;---> Default: year prior to today.
 .N X,X1,X2
 .S (BIENDDT,X)=DT
 .S X1=X,X2=-365 D C^%DTC S BIBEGDT=X
 ;
 D DATERNG^BIREP(.BILINE,"BIREPP",1,BIBEGDT,BIENDDT,2,1,1)
 ;
 ;---> User Population.
 D:($G(BIUP)="")
 .I $$GPRAIEN^BIUTL6 S BIUP="a" Q
 .S BIUP="u"
 ;
 S X="     2 - Patient Population Group...: "_$$BIUPTX^BIUTL6(BIUP)
 D WRITE(.BILINE,X,2) K X
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPP",.BICC,"Community",3,1)
 ;
 ;---> Health Care Facility.
 ;N A,B S A="Health Care Facility",B="Facilities"
 ;D DISP^BIREP(.BILINE,"BIREPP",.BIHCF,A,3,2,,,,B)
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPP",BITITL="PCV"
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
 D WL^BIW(.BILINE,"BIREPP",$G(BIVAL),$G(BIBLNK))
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
 D START^BIHELP("PCV REPORT - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;The PCV Report provides "doses administered" by age group.
 ;;This report can be printed for any time period, and can be
 ;;limited to reporting for patients in one or more communities.
 ;;Note: Historical immunizations are included in this report
 ;;(those immunizations given at other sites and entered at this
 ;;site for completeness of records).
 ;;
 ;;There are 3 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-3) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the PCV Report or P to print it.
 ;;
 ;;If it customarily takes a long time for your computer to prepare
 ;;this report, it may be preferable to Print and Queue the report
 ;;to a printer, rather than Viewing it on screen.  (This would avoid
 ;;tying up your screen while the report is being prepared.)
 ;;
 ;;DATE RANGE: Only immunizations given within the Date Range you
 ;;select will be included in the "Total Doses in Date Range" row
 ;;at the bottom of the report. (All other rows include PCV doses
 ;;given throughout patients' histories.
 ;;
 ;;PATIENT POPULATION GROUP: You may select one of four patient groups
 ;;to be considered in the report: Registered Patients (All),
 ;;Immunization Register Patients (Active), User Population (1+ visits
 ;;in 3 yrs), or Active Clinical Users (2+ visits in 3 yrs).
 ;;Active Clinical Users is the default.
 ;;
 ;;COMMUNITIES: If you select for specific Communities, only patients
 ;;whose Current Community matches one of the Communities selected will
 ;;be included in the report.  "Current Community" is refers to Item 6
 ;;on Page 1 of the RPMS Patient Registration.
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
 K ^TMP("BIREPP",$J),^TMP("BIDFN",$J),^TMP("BIDUL",$J)
 D CLEAR^VALM1
 Q
