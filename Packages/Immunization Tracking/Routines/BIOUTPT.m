BIOUTPT ;IHS/CMI/MWR - HEADERS & PROMPTS FOR REPORTS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  COMMON HEADERS FOR REPORTS AND PROMPTS FOR REPORT PARAMETERS.
 ;
 ;
 ;----------
FDATE(BIFDT,BIRTN) ;EP
 ;---> Ask Forecast Date.  Called by Protocol BI OUTPUT FORECAST DATE.
 ;---> Parameters:
 ;     1 - BIFDT (ret) Forecast Date, Fileman format.
 ;               (opt) Default Date.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
FDATE1 ;EP
 S:$G(BIFDT)="" BIFDT=DT
 N BIDFLT,DIR S BIDFLT=$$TXDT^BIUTL5(BIFDT)
 S DIR(0)="DA^::FEX"
 S DIR("A")="     Please enter a Forecast Date: ",DIR("B")=BIDFLT
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT FORECAST DATE")
 D TEXT1
 D ^DIR W !
 I $D(DIRUT) D @("RESET^"_BIRTN) Q
 S BIFDT=$P(Y,".")
 I BIFDT<DT D  G FDATE1
 .W !?5,"The date may not be in the past.  "
 .W "It must be today or in the future."
 .K BIFDT D DIRZ^BIUTL3()
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;The "Forecast Date" (or "Clinic Date") is the date that will
 ;;be used for calculating which immunizations patients are due for.
 ;;
 ;;For example, if you choose today, the letter or report will
 ;;list the immunizations that patients are due for today.
 ;;If you choose a future date (the date of a clinic), the letter
 ;;or report will list immunizations due on that future date.
 ;;
 ;;NOTE: If you select a Forecast date in the future, some patients
 ;;      may appear as PAST DUE for that date in the future, even
 ;;      though they are not PAST DUE today.
 ;;
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
QDATE(BIQDT,BIRTN) ;EP
 ;---> Ask Quarter Ending Date.
 ;---> Called by Protocol BI OUTPUT QUARTER DATE.
 ;---> Parameters:
 ;     1 - BIQDT (ret) Quarter Ending Date, Fileman format.
 ;               (opt) Default Date.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 N DIR
 S:$G(BIQDT) DIR("B")=$$TXDT^BIUTL5(BIQDT)
 S DIR(0)="DA^::PE"
 S DIR("A")="   Please enter a Quarter Ending Date: "
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT QUARTER ENDING DATE")
 D TEXT2 W !
 D ^DIR W !
 I $D(DIRUT) D @("RESET^"_BIRTN) Q
 S BIQDT=$P(Y,".")
 I $E(BIQDT,6,7)="00" D
 .N X S X=$E(BIQDT,4,5) D
 ..I +X=2 S X=28 Q
 ..I +X=1 S X=31 Q
 ..I 94611[+X S X=30 Q
 ..S X=31
 .S BIQDT=BIQDT+X
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;The "Quarter Ending Date" should be the last day of the quarter
 ;;being reported on.  Typically, this date is either March 31,
 ;;June 30, September 30, or December 31.  However, you may enter
 ;;any date you choose and the report will generate immunization
 ;;statistics based on the date entered.  NOTE: The patient ages
 ;;(3 months, 5 months, 91 years, etc.) will be calculated as of
 ;;the Quarter Ending Date you enter here.
 ;;
 ;;For convenience's sake, if you enter only month/year, such as 9/98,
 ;;the program will automatically assign the report to the last day
 ;;of that month, such as 9/30/1998.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
DTRANGE(BIBEGDT,BIENDDT,BIPOP,BIRTN,BIBEGDF,BIENDDF) ;EP
 ;---> Ask date range.
 ;---> Called by Protocol BI OUTPUT DATE RANGE.
 ;---> Parameters:
 ;     1 - BIBEGDT (ret) Begin Date, Fileman format.
 ;     2 - BIENDDT (ret) End Date, Fileman format.
 ;     3 - BIPOP   (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;     4 - BIRTN   (req) Calling routine for reset.
 ;     5 - BIBEGDF (opt) Begin Date default, Fileman format.
 ;     6 - BIENDDF (opt) End Date default, Fileman format.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D TITLE^BIUTL5("SELECT DATE RANGE")
 D TEXT3 W !
 D ASKDATES^BIUTL3(.BIBEGDT,.BIENDDT,.BIPOP,$G(BIBEGDT),$G(BIENDDT))
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;Please enter the beginning and ending dates for the period you
 ;;wish this report to cover.  (NOTE: The ending date must be after
 ;;the beginning date.)
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
AGE(BIAG,BIRTN) ;EP
 ;---> Select age range.  Called by Protocol BI OUTPUT AGE.
 ;---> If not limited to an age range, BIAG="".
 ;---> Parameters:
 ;     1 - BIAG  (ret) Age Range in months.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D AGERNG^BIAGE(.BIAG,.BIPOP,"1-72",0)
 I $G(BIPOP) S BIAG="" D @("RESET^"_BIRTN) Q
 S:BIAG="" BIAG="ALL"
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TAR(BITAR,BIRTN) ;EP
 ;---> Select Two-Yr-Old Age Range for same Report.
 ;---> Called by Protocol BI OUTPUT TWO-YR-OLD REPORT AGE RANGE.
 ;---> Parameters:
 ;     1 - BITAR (ret) Two-Yr-Old Age Range in months;
 ;                     either "19-35" or "24-35".
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("TWO-YR-OLD AGE RANGE")
 D TEXT6
 N A,X,Y S A="     Choose either 1 or 2"
 S X="SO^1:19-35 months;2:24-35 months"
 D DIR^BIFMAN(X,.Y,.BIPOP,A,$G(BITAR))
 S BITAR=$S(Y=2:"24-35",1:"19-35")
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT6 ;EP
 ;;This parameter allows you to select the Age Range of Patients for
 ;;the Two-Yr-Old Report.
 ;;
 ;;Selecting "19-35 months" will include in the report all children who
 ;;were between those ages on the date entered in the "Quarter Ending Date"
 ;;parameter.
 ;;
 ;;Selecting "24-35 months" will only include children who were between
 ;;those ages on the date entered in the "Quarter Ending Date" parameter.
 ;;
 D PRINTX("TEXT6")
 Q
 ;
 ;
 ;----------
CC(BICC,BIRTN,BIPOP) ;EP
 ;---> Select Current Community(s).
 ;---> Called by Protocol BI OUTPUT COMMUNITY.
 ;---> Parameters:
 ;     1 - BICC  (ret) Local array of Current Community IENs.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;     3 - BIPOP (opt) BIQUIT=1 if user quit, ^-arrowed.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 S BIPOP=0
 D TITLE^BIUTL5("SELECTION OF COMMUNITIES")
 D TEXT8
 ;
 N DIR S DIR("A")="     Select G, L, or P: ",DIR("B")="Load"
 S DIR(0)="SAM^G:GPRA;L:LOAD;P:PREVIOUS"
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) D @("RESET^"_BIRTN) S BIPOP=1 Q
 ;
 K BICC
 ;---> Load GPRA Set of Communities.
 I "GL"[Y D GETGPRA^BISITE4(.BICC,$G(DUZ(2)))
 ;
 D:Y'="G"
 .;---> Select cases for one or more CURRENT COMMUNITY (OR ALL).
 .N BIID S BIID="3;I $G(X) S:$D(^DIC(5,X,0)) X=$P(^(0),U);25"
 .N BICOL S BICOL="    #  Community           State"
 .D SEL^BISELECT(9999999.05,"BICC","Community",,,,BIID,BICOL,.BIPOP)
 ;
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT8 ;EP
 ;;You have the opportunity here to use the GPRA set of Communities.
 ;;
 ;;* Enter "G" to automatically use the GPRA set and proceed.
 ;;* Enter "L" to LOAD the GPRA set and then edit your list before proceeding.
 ;;* Enter "P" to load the PREVIOUS set of Communities you used.
 ;;
 D PRINTX("TEXT8")
 Q
 ;
 ;
 ;----------
HCF(BIHCF,BIRTN) ;EP
 ;---> Select Health Care Facility(s).
 ;---> Called by Protocol BI OUTPUT FACILITY.
 ;---> Parameters:
 ;     1 - BIHCF (ret) Local array of Health Care Facility IENs.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Default Facilty=DUZ(0); but if user decides to select more than
 ;---> DUZ(0) site, goes to ^BISELECT and get user's previous list
 ;---> (by killing the single BIHCF(DUZ(0))).
 N M,N S (M,N)=0
 F  S N=$O(BIHCF(N)) Q:'N  S M=M+1
 K:M=1 BIHCF
 ;
 ;---> Code to display Area as an identifier.
 N BIID
 S BIID="1;I $G(BIIEN) S X=$P($G(^AUTTLOC(BIIEN,0)),U,4)"
 S BIID=BIID_" I X S:$D(^AUTTAREA(X,0)) X=""  ""_$P(^(0),U);28"
 N BICOL S BICOL="    #  Health Care Facility     IHS Area"
 D SEL^BISELECT(4,"BIHCF","Health Care Facility",,,,BIID,BICOL,.BIPOP)
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
CMGR(BICM,BIRTN) ;EP
 ;---> Select Case Managers.
 ;---> Called by Protocol BI OUTPUT CASE MANAGER.
 ;---> Parameters:
 ;     1 - BICM   (ret) Local array of Current Community IENs.
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select cases for one or more CASE MANAGERS (OR ALL).
 N BISCRN S BISCRN="I $D(^BIMGR(Y,0))"
 D SEL^BISELECT(9002084.01,"BICM","Case Manager",BISCRN,,,,,.BIPOP)
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
DPRV(BIDPRV,BIRTN) ;EP
 ;---> Select Designated Provider.
 ;---> Called by Protocol BI OUTPUT DESIGNATED PROVIDER.
 ;---> Parameters:
 ;     1 - BIDPRV (ret) Designated Provider IENs.
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select cases for one or more DESIGNATED PROVIDERS (OR ALL).
 N BISCRN S BISCRN="I $D(^XUSEC(""PROVIDER"",Y))"
 D SEL^BISELECT(200,"BIDPRV","Designated Provider",BISCRN,,,,,.BIPOP)
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
BEN(BIBEN,BIRTN) ;EP
 ;---> Select Types of Beneficiaries.
 ;---> Called by Protocol BI OUTPUT CASE MANAGER.
 ;---> Parameters:
 ;     1 - BIBEN  (ret) Local array of Beneficiary Types.
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select cases for one or more BENEFICIARY TYPES (OR ALL).
 N BINAM S BINAM="Beneficiary Type"
 N BIID S BIID="2;;34"
 N BICOL S BICOL="    #  Beneficiary Type             Code"
 D SEL^BISELECT(9999999.25,"BIBEN",BINAM,,,,BIID,BICOL,.BIPOP)
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
VTYPE(BIVT,BIRTN) ;EP
 ;---> Select Visit Types.
 ;---> Called by Protocol BI OUTPUT CASE MANAGER.
 ;---> Parameters:
 ;     1 - BIBEN  (ret) Local array of VISIT Types.
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select cases for one or more VISIT TYPES (OR ALL).
 N BINAM S BINAM="Visit Type"
 N BICOL S BICOL="    #  Visit Type                     Code"
 D SEL^BISELECT(9000010,"BIVT",BINAM,,,,,BICOL,.BIPOP,,".03")
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
INCLHPV(BIHPV,BIRTN) ;EP
 ;---> Answer Yes/No to include Hepatitis A in Quarterly Report.
 ;---> Called by Protocol BI OUTPUT INCLUDE HPV.
 ;---> Parameters:
 ;     1 - BIHPV  (ret) 1=YES, 0=NO.
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("INCLUDE VARICELLA & PNEUMO IN REPORT")
 D TEXT4 W ! N Y
 D DIR^BIFMAN("YAO",.Y,,"   Include Varicella & Pneumo? (YES/NO): ","YES")
 S:Y=0 BIHPV=0 S:Y=1 BIHPV=1
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;This option allows you to include Varicella and Pneumo
 ;;in the statistics of the "Appropriate for Age" row at the
 ;;top of the report.
 ;;
 ;;If you answer "YES,"  Varicella & Pneumo will appear in the
 ;;Minimum needs header row at the top of the report and will
 ;;count when computing whether patients are Appropriate for Age.
 ;;
 ;;Answer "NO" in order to exclude Varicella & Pneumo from the
 ;;Minimum Needs when computing Appropriate for Age statistics.
 ;;
 ;;In both cases, the statistics for Varicella & Pneumo will be
 ;;displayed individually in additional rows at the bottom of the
 ;;report.
 ;;
 D PRINTX("TEXT4")
 Q
 ;
 ;
 ;----------
INCLCPT(BICPT,BIRTN) ;EP
 ;---> Answer Yes/No to include CPT Coded Visits in report.
 ;---> Called by Protocol BI OUTPUT INCLUDE CPT.
 ;---> Parameters:
 ;     1 - BICPT  (ret) 1=YES, 0=NO.
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("INCLUDE CPT CODED VISITS IN REPORT")
 D TEXT5 W ! N Y
 D DIR^BIFMAN("YAO",.Y,,"   Include CPT Coded Visits in report? (YES/NO): ")
 S:Y=0 BICPT=0 S:Y=1 BICPT=1
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;This option allows you to include CPT Coded Visits in the report.
 ;;
 ;;Explanation: Most immunizations will be recorded as Immunization
 ;;Visits and will be included in this report.  However, it is possible
 ;;that some immunizations were recorded only by CPT Code for the
 ;;patient's visit and not actually recorded in the Immunization Files;
 ;;in other words, not entered via the Immunization Package.
 ;;
 ;;Answer "YES" to this question if you wish to have the report search
 ;;for any immunizations that were only entered as CPT Codes, and to
 ;;include those immunizations in the statistical results of this report.
 ;;NOTE: Including CPT Coded visits may cause some patients to appear on
 ;;the report's patient roster who do not have immunizations recorded in
 ;;the Immunization Package.
 ;;
 ;;Answer "NO" to ignore any immunizations that might have been recorded
 ;;only by CPT Coding.
 D PRINTX("TEXT5")
 Q
 ;
 ;
 ;----------
DISP24M(BIAGRPS,BIRTN) ;EP
 ;---> Answer Yes/No to display the 24-month column in the Two-Yr-Old Report.
 ;---> Called by Protocol BI OUTPUT DISPLAY 24-MO COLUMN.
 ;---> Parameters:
 ;     1 - BIAGRPS (ret) 1=Display 24-Month Column, 0=Do not.
 ;     2 - BIRTN   (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("DISPLAY 24-MONTH COLUMN")
 D TEXT7 W ! N Y
 D DIR^BIFMAN("YAO",.Y,,"     Display 24-Month column on report? (YES/NO): ")
 S:Y=0 BIAGRPS="3,5,7,16,19,36" S:Y=1 BIAGRPS="3,5,7,16,19,24,36"
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT7 ;EP
 ;;This option allows you to specifiy whether the 24-Month Column
 ;;should appear in the Two-Yr-Old Report.  The final totals in the
 ;;report will not be affected by this choice.
 ;;
 D PRINTX("TEXT7")
 Q
 ;
 ;
 ;----------
HELPTX(BILINL,BITAB) ;EP
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
