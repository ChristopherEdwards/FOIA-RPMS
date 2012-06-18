BIOUTPT3 ;IHS/CMI/MWR - PROMPTS FOR REPORTS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PROMPTS FOR REPORT PARAMETERS.
 ;;  PATCH 1: Clarify Date Range on Imms Received with added prompt.  IMMRCV+20
 ;
 ;
 ;----------
MINDAYS(BIMD,BIPOP) ;EP
 ;---> Select Minimum Number of days since last letter sent.
 ;---> Called by routine BIDUPLT.
 ;---> Parameters:
 ;     1 - BIMD (ret) Minimum Days since Last Letter.
 ;     2 - BIPOP  (ret) BIPOP=1 if DTOUT or DUOUT
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT MINIMUM DAYS SINCE LAST LETTER")
 W !!?3,"Please specify the minimum number of days between a patient's"
 W !?3,"previous letter and today's letter."
 W !?3,"Type ""?"" (no quotes) for further explanation.",!!
 N DIR,DIRUT D HELP2
 S DIR(0)="NOA^0:9999:0"
 S DIR("A")="   Enter Number of Days: "
 S DIR("B")=$$MINDAYS^BIUTL2(DUZ(2))
 D FULL^VALM1
 D ^DIR
 I $D(DIRUT) S BIPOP=1 Q
 S BIMD=+Y S:BIMD<0 BIMD=$$MINDAYS^BIUTL2(DUZ(2))
 Q
 ;
 ;
 ;----------
HELP2 ;EP
 ;;The Minimum Days Since Last Letter is the least number of days that
 ;;must elapse--after a letter has been sent to a patient--before the
 ;;software will automatically send another letter to that same patient.
 ;;
 ;;For example, if a patient received a letter 2 weeks ago and
 ;;the Minimum Days Last Letter is 60 days, then this software will
 ;;not generate a new letter for that patient today, even if the patient
 ;;fits the other criteria you have selected for Age, Community,
 ;;Immunizations Due, etc.
 D HELPTX("HELP2")
 Q
 ;
 ;
 ;----------
LOTNUM(BILOT,BIRTN) ;EP
 ;---> Select Lot Numbers.
 ;---> Called by Protocol BI OUTPUT LOT NUMBER.
 ;---> Parameters:
 ;     1 - BILOT (ret) Local array of Lot Number IENs.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select cases for one or more LOT NUMBERS (OR ALL).
 N BIID S BIID="2;I $G(X) S:$D(^AUTTIMAN(X,0)) X=$P(^(0),U);17"
 N BICOL S BICOL="    #  Lot Number  Manufacturer"
 D SEL^BISELECT(9999999.41,"BILOT","Lot Number",,,,BIID,BICOL,.BIPOP)
 ;
 ;
 D:('$D(BILOT("ALL")))
 .D TITLE^BIUTL5("FULL OR LIMITED HISTORY")
 .D TEXT7
 .S B=$S($D(BI):"Yes",1:"No")
 .D DIR^BIFMAN("YAO",.Y,,"     Limit histories to selected lot numbers? (Yes/No): ",B)
 .I 'Y K BIMMLF Q
 .N N S N=0
 .F  S N=$O(BILOT(N)) Q:'N  D
 ..N M S M=$$LOTTX^BIUTL6(N)
 ..S:M BIMMLF(M)=""
 ;
 ;
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
PGROUP2(BIPG,BIRTN) ;EP
 ;---> Selecting Patient Group (instead of individually).
 ;---> Called by Protocol BI OUTPUT IMMUNIZATION DUE.
 ;---> Parameters:
 ;     1 - BIPG  (ret) Patient Group.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select group of patients to be exported.
 S:'$G(BIPG) BIPG=1
 N DIR,X
 D FULL^VALM1
 D TITLE^BIUTL5("SELECT PATIENT GROUP"),TEXT1,HELP1
 S X="SO^1:Active only;2:Active + Inactive"
 S X=X_";3:All who have had an Immunization Visit"
 S DIR(0)=X,DIR("B")=BIPG
 D ^DIR
 S:'$D(DIRUT) BIPG=+Y
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;Please select a Patient Group from the following:
 ;;
 ;; 1) Only patients who were ACTIVE in the Immunization Register on
 ;;    the Survey Date.
 ;;
 ;; 2) BOTH Active and Inactive patients in the Immunization Register.
 ;;
 ;; 3) ALL patients who have had an Immunization at the selected
 ;;    facility(s), including those NOT in the Immunization Register.
 ;;
 D PRINTX("TEXT1",3)
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;;
 ;;
 ;;Choose a number 1-3 that represents the group of Patients whose
 ;;data you wish to export.
 ;;
 ;;NOTE: This group will be subject to the other selections you make
 ;;      regarding Age Range, Community, Health Care Facility, etc.
 ;;
 D HELPTX("HELP1")
 Q
 ;
 ;
 ;----------
IMMRCV(BIMMR,BIRDT,BIIMMRF,BIRTN) ;EP
 ;---> Select Immunizations Received.
 ;---> Called by Protocol BI OUTPUT IMMUNIZATION RECEIVED.
 ;---> Parameters:
 ;     1 - BIMMR (ret) Local array of Vaccine IENs.
 ;     2 - BIRDT (ret) Date Range for Imms received: BeginDate_":"_EndDate
 ;     3 - BIMMR (ret) Local array of Vaccine IENs.
 ;     4 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select cases for one or more IMMUNIZATIONS RECEIVED (OR ALL).
 N BICOL S BICOL="    #  Vaccine Received   HL7 Code"
 D SEL^BISELECT(9999999.14,"BIMMR","Vaccine",,,2,"3;;24",BICOL,.BIPOP)
 ;
 D:'$G(BIPOP)
 .N BIBEGDT,BIENDDT,BIBEGDF,BIENDDF,X
 .S X=$G(BIRDT) S BIBEGDF=$P(X,":"),BIENDDF=$P(X,":",2)
 .S:'BIBEGDF BIBEGDF=2000101 S:'BIENDDF BIENDDF=$G(DT)
 .D TITLE^BIUTL5("SELECT IMMUNIZATION RECEIVED DATE RANGE")
 .D TEXT4
 .;
 .W !!,"   Do you wish to specify a date range for immunizations received?"
 .N DIR S DIR("?")="     Enter YES to specify a date range; NO to ignore dates."
 .S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 .D ^DIR W !
 .I ($D(DIRUT)!'$G(Y)) S BIRDT="" Q
 .;
 .D TITLE^BIUTL5("SELECT IMMUNIZATION RECEIVED DATE RANGE")
 .D TEXT5
 .D ASKDATES^BIUTL3(.BIBEGDT,.BIENDDT,.BIPOP,BIBEGDF,BIENDDF)
 .Q:$G(BIPOP)
 .S:'BIBEGDT BIBEGDT=2000101 S:'BIENDDT BIENDDT=$G(DT)
 .S BIRDT=BIBEGDT_":"_BIENDDT
 ;
 D:('$D(BIMMR("ALL")))
 .D TITLE^BIUTL5("FULL OR LIMITED HISTORY")
 .D TEXT6
 .S B=$S($D(BI):"Yes",1:"No")
 .D DIR^BIFMAN("YAO",.Y,,"     Limit histories to selected vaccines? (Yes/No): ",B)
 .I 'Y K BIMMRF Q
 .N N S N=0
 .F  S N=$O(BIMMR(N)) Q:'N  D
 ..N M S M=$$CODE^BIUTL2(N)
 ..S:M BIMMRF(M)=""
 ;
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;You may limit this list to patients who have received the vaccines
 ;;you selected within a specific date range.  This date range will
 ;;apply to your list, whether you have chosen just one vaccine or
 ;;several vaccines or all vaccines.
 ;;
 ;;NOTE: If you selected "ALL" vaccines and do NOT specify a date range,
 ;;then this filter becomes essentially inactive and will have no effect
 ;;on your list (patients will not be excluded on the basis of immunizations
 ;;received, even if they have never received any immunization).
 ;;
 ;;However, if you selected "ALL" vaccines and you DO specify a date range,
 ;;then only patients who have received AT LEAST ONE immunization during
 ;;your date range will be included. (Patients who did not receive ANY
 ;;immunizations during your date range will be excluded from the report.)
 ;;
 D PRINTX("TEXT4")
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;By default, the date range is from 1/1/1900 to today (essentially
 ;;not limited by date).  However, you can specify a different date
 ;;range below.  Only patients who have received the specified vaccines
 ;;within the date range you select will be included in the list.
 ;;
 D PRINTX("TEXT5")
 Q
 ;
 ;
 ;----------
TEXT6 ;EP
 ;;You have limited your list to patients who have received one or more
 ;;specific vaccines.
 ;;
 ;;If you print their immunization histories in a list, would you like
 ;;to display only the history of the vaccines you selected?
 ;;
 D PRINTX("TEXT6")
 Q
 ;
 ;
 ;----------
TEXT7 ;EP
 ;;You have limited your list to patients who have received one or more
 ;;specific lot numbers.
 ;;
 ;;If you print their immunization histories in a list, would you like
 ;;to display only the history of the lot numbers you selected?
 ;;
 D PRINTX("TEXT7")
 Q
 ;
 ;
 ;----------
IMMDUE(BIMMD,BIRTN) ;EP
 ;---> Select Immunizations Due.
 ;---> Called by Protocol BI OUTPUT IMMUNIZATION DUE.
 ;---> Parameters:
 ;     1 - BIMMD (ret) Local array of Vaccine IENs.
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Select cases for one or more IMMUNIZATIONS DUE (OR ALL).
 N BICOL S BICOL="    #  Vaccine Due   HL7 Code"
 D SEL^BISELECT(9999999.14,"BIMMD","Vaccine",,,2,"3;;19",BICOL,.BIPOP)
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
HISTORC(BIHIST,BIRTN) ;EP
 ;---> Select whether to include Historical Visits.
 ;---> Called by Protocol BI OUTPUT HISTORICAL.
 ;---> Parameters:
 ;     1 - BIHIST  (req) Include Historical (1=yes,0=no).
 ;     2 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("INCLUDE HISTORICAL VISITS"),TEXT2
 N A,B,Y S:'$G(BIHIST) BIHIST=1
 S A="     Include Historical Visits (Yes/No): "
 S B=$S(BIHIST:"YES",1:"NO")
 D DIR^BIFMAN("YA",.Y,,A,B)
 S BIHIST=+Y
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;Should Historical Visits be included in this report?
 ;;
 ;;"Historical" refers to the Category field of a Visit as displayed and
 ;;edited on the ADD/EDIT IMMUNIZATION Screen for Immunization Visits.
 ;;
 ;;A Visit may be given a Category of "Historical Event" rather than
 ;;"Ambulatory" or "Inpatient" for a variety of reasons, for example:
 ;;An immunization that was not administered at the current clinic but
 ;;merely added to the record for completeness might be "Historical".
 ;;Immunizations not intended to be picked up by Billing could be
 ;;given a Category of "Historical".
 ;;
 ;;Please select whether to include Historical Visits in this report.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
DISBLOT(BIDLOT,BIRTN) ;EP
 ;---> Select whether to display VAC Report by Lot Number.
 ;---> Called by Protocol BI OUTPUT DISPLAY BY LOT NUMBER.
 ;---> Parameters:
 ;     1 - BIDLOT (req) Display by Lot Number (1=yes,0=no).
 ;     2 - BIRTN  (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("DISPLAY REPORT BY LOT NUMBERS"),TEXT3
 N A,B,Y S:'$G(BIDLOT) BIDLOT=0
 S A="     Display by Lot Numbers (Yes/No): "
 S B=$S(BIDLOT:"YES",1:"NO")
 D DIR^BIFMAN("YA",.Y,,A,B)
 S BIDLOT=+Y
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;Should the vaccines in this report to be displayed by lot number?
 ;;
 ;;By default, this report lists the statistics by age for each vaccine.
 ;;However, you may elect to display the statistics for each separate
 ;;lot number under each vaccine.  The totals for all lot numbers of
 ;;each vaccine will also be displayed.
 ;;
 ;;Please select whether to display the report by Lot Numbers.
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
HELPTX(BILINL,BITAB) ;EP
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
