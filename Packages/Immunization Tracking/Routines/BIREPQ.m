BIREPQ ;IHS/CMI/MWR - REPORT, QUARTERLY IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW QUARTERLY IMMUNIZATION REPORT.
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
 D EN^VALM("BI REPORT QUARTERLY IMM")
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
 S X=IOUON_"3-27 MONTH IMMUNIZATION REPORT" D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 D WRITE(.BILINE)
 ;---> Date.
 S:'$G(BIQDT) BIQDT=$G(DT)
 D DATE^BIREP(.BILINE,"BIREPQ",1,$G(BIQDT),"Quarter Ending Date",,,,1)
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPQ",.BICC,"Community",2,1)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPQ",.BIHCF,A,3,2,,,,B) K A,B
 ;
 ;---> Case Manager.
 D DISP^BIREP(.BILINE,"BIREPQ",.BICM,"Case Manager",4,3)
 ;
 ;---> Beneficiary Type.
 S:$O(BIBEN(0))="" BIBEN(1)=""
 D DISP^BIREP(.BILINE,"BIREPQ",.BIBEN,"Beneficiary Type",5,4)
 ;
 ;---> User Population.
 D:($G(BIUP)="")
 .I $$GPRAIEN^BIUTL6 S BIUP="i" Q
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
 ;---> Include Hep A, Pneumo.
 S:'$D(BIHPV) BIHPV=1
 S X="     7 - Include Varicella & Pneumo.: "
 S X=X_$S($G(BIHPV):"YES",1:"NO")
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPQ"
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
 D WL^BIW(.BILINE,"BIREPQ",$G(BIVAL),$G(BIBLNK))
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
 D START^BIHELP("3-27 MONTH IMMUNIZATION REPORT - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;3-27 Month Immunization Report
 ;;
 ;;The IHS and Tribal programs report the current age-appropriate
 ;;immunization rate of active children 3-27 months of age.
 ;;NOTE: Any child who was Inactivated at any point during the 90 days
 ;;prior to the Quarter Ending Date will not be included in the report.
 ;;
 ;;The criteria listed below are used by IHS to determine the
 ;;up-to-date status of children in each age group, and the specific
 ;;age group rates are combined into a total rate.  Varicella and Pneumo
 ;;can be excluded from the report totals by entering "NO" in Option 6.
 ;;However, for Headquarters Reports enter "YES" for Option 6 in order to
 ;;include Varicella and Pneumo (PCV) in the totals.
 ;;The criteria for the Headquarters Report are listed below:
 ;;
 ;;       3-4 months old     1-DTaP 1-IPV 1-Hib 1-HepB 1-PCV
 ;;       5-6 months old     2-DTaP 2-IPV 2-Hib 2-HepB 2-PCV
 ;;      7-15 months old     3-DTaP 2-IPV 2-Hib 2-HepB 3-PCV
 ;;     16-18 months old     3-DTaP 2-IPV 3-Hib 2-HepB 3-PCV 1-MMR 1-VAR
 ;;     19-23 months old     4-DTaP 3-IPV 3-Hib 3-HepB 4-PCV 1-MMR 1-VAR
 ;;     24-27 months old     4-DTaP 3-IPV 3-Hib 3-HepB 4-PCV 1-MMR 1-VAR
 ;;
 ;;In Version 8.5 we have revised the 3-27 month report to have
 ;;manufacturer-specific logic:
 ;;
 ;;   PedvaxHib (PRP-OMP) requires 3 doses
 ;;   ActHib (PRP-T0 requires 4 doses
 ;;   RotaTeq (Rota-5) requires 3 doses
 ;;   RotaRix (Rota-1) requires 2 doses
 ;;
 ;;Version 8.5 also adjusts for catch-up schedules to require fewer doses
 ;;of Hib and PCV13 in children who start late:
 ;;
 ;;   Hib:   16-27 months - requires 3 doses, or 2 doses >=12 months,
 ;;          or 1 dose >=15 months
 ;;
 ;;   PCV13: 16-27 months - requires 4 doses, or 3 doses >=7 months,
 ;;          or 2 doses >=12 months, or 1 dose >=24 months
 ;;
 ;;
 ;;The 3-27 MONTH IMMUNIZATION REPORT screen allows you to adjust
 ;;the report to your needs.
 ;;
 ;;There are 7 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-7) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like more information on the parameter you are changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the Quarterly Report or P to print it.
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
 ;;INCLUDE VARICELLA & PNEUMO: Answer "YES" if you wish to have Varicella
 ;;and Pneumo included in the statistics of the "Appropriate for Age" row
 ;;at the top of the report.  If you answer "NO", Varicella and Pneumo will
 ;;NOT appear in the Minimum needs header row at the top of the report.
 ;;In both cases, the statistics for Varicella and Pneumo will be displayed
 ;;individually in additional rows at the bottom of the report.
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
 K ^TMP("BIREPQ",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
