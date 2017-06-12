BISITE4 ;IHS/CMI/MWR - SELECT GPRA COMMUNITIES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**13**;AUG 01,2016
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  SELECT COMMUNITIES TO BE INCLUDED IN GPRA GROUPS AND REPORTS.
 ;;  PATCH 8: Update Help Text to exclude influenza.  TEXT2+3
 ;;  PATCH 9: Update options to include Hep B. TEXT1+24
 ;;  PATCH 12: Use BIDUZ2.  GETGPRA+9
 ;;  PATCH 13: Add Flu Season Date Range parameter. FLUDATS+0
 ;
 ;
 ;----------
GPRA ;EP
 ;---> Select Communities for GPRA.
 ;---> Called by Protocol BI SITE GPRA COMS.
 ;
 Q:$$BISITE^BISITE2
 N BIITEM S BIITEM="Community"
 N BITITEM S BITITEM="GPRA Community"
 N BICOL S BICOL="    #  Community                  State"
 N BIID S BIID="3;I $G(X) S:$D(^DIC(5,X,0)) X=$P(^(0),U);32"
 N BIGPRA,BIGPRAD,BIPOP
 ;
 ;---> Use previous GPRA List for this site as default.
 D GETGPRA(.BIGPRAD,DUZ(2))
 D SEL^BISELECT(9999999.05,"BIGPRA",BIITEM,,,,BIID,BICOL,.BIPOP,1,,.BIGPRAD,BITITEM)
 ;
 ;---> Now replace the previous list for this site with the newly selected list.
 D
 .Q:$G(BIPOP)
 .;---> If user tried to select ALL Communities for GPRA, don't change.
 .I $D(BIGPRA("ALL")) D  Q
 ..W !!,"                    * GPRA Communities *"
 ..W !!!,"   You may not select ""ALL"" for your set of GPRA Communities."
 ..D DIRZ^BIUTL3()
 .;
 .N BIK S BIK="^BISITE("_DUZ(2)_",2)" K @BIK
 .S ^BISITE(DUZ(2),2,0)="^9002084.04PA"
 .N N S N=0
 .F  S N=$O(BIGPRA(N)) Q:'N  D
 ..S ^BISITE(DUZ(2),2,N,0)=N,^BISITE(DUZ(2),2,"B",N,N)=""
 ..N X S X=$P($G(^BISITE(DUZ(2),2,0)),U,4)+1
 ..S ^BISITE(DUZ(2),2,0)="^9002084.04PA^"_N_U_X
 ;
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
GETGPRA(BIGPRA,BIDUZ2,BIERR) ;PEP - Return GPRA Communities Array.
 ;---> Retrieve GPRA Communities Array of IEN's for this DUZ(2).
 ;---> Parameters:
 ;     1 - BIGPRA (ret) Array of GPRA IEN's in the COMMUNITY file - ^AUTTCOM(.
 ;     2 - BIDUZ2 (req) Site IEN or DUZ(2).
 ;     3 - BIERR  (ret) Error text, if any.
 ;
 I '$G(BIDUZ2) S BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(109,.BIERR) Q
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> Use BIZUZ2 as passed rather than DUZ(2).
 ;I '$O(^BISITE(DUZ(2),2,0)) D ERRCD^BIUTL2(110,.BIERR) Q
 I '$O(^BISITE(BIDUZ2,2,0)) D ERRCD^BIUTL2(110,.BIERR) Q
 N N S N=0
 ;F  S N=$O(^BISITE(DUZ(2),2,N)) Q:'N  S BIGPRA(N)=""
 F  S N=$O(^BISITE(BIDUZ2,2,N)) Q:'N  S BIGPRA(N)=""
 Q
 ;
 ;
 ;----------
INPTCHK ;EP
 ;---> Edit the parameter that determines whether Inpatient Status
 ;---> is checked (and changed, if necessary) when storing Visits.
 ;---> Called by Protocol BI SITE INPATIENT CHECK ENABLE.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("ENABLE/DISABLE INPATIENT VISIT CHECK"),TEXT5
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^E:Enable;D:Disable"
 S DIR("A")="     Please select either Enable or Disable: "
 S DIR("B")=$S($$INPTCHK^BIUTL2(BISITE):"Enable",1:"Disable")
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.23)=Y
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 ;---> Flu Season Date Range.
 ;----------
FLUDATS ;EP
 ;---> Edit the parameters that determines the start and end of the Flu
 ;---> forecasting season.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("FLU SEASON START & END DATES"),TEXT5
 ;
 N BIDATES,BISTART,BIEND
 S BIDATES=$$FLUDATS^BIUTL8(BISITE)
 N BIPOP,DIRUT
 ;---> Edit Start Date.
 D FLUDATS1("START",BIDATES,.BISTART,.DIRUT)
 ;
 ;---> If user ^'d out, quit.
 I $G(DIRUT) D  Q
 .W !!?10,"No changes made." D DIRZ^BIUTL3(),RESET^BISITE
 ;
 ;---> Edit End Date.
 D FLUDATS1("END",BIDATES,.BIEND,.DIRUT)
 ;
 ;---> If user ^'d out, quit.
 I $G(DIRUT) D  Q
 .W !!?10,"No changes made." D DIRZ^BIUTL3(),RESET^BISITE
 ;
 ;---> Save new (or unchanged) values for this site.
 N BIFLD,BIERR S BIFLD(.31)=BISTART,BIFLD(.32)=BIEND
 D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3(),RESET^BISITE Q
 ;
 W !!?5,"Flu Season dates are now: ",BISTART," to ",BIEND
 D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
FLUDATS1(BIMODE,BIDATES,BIRESULT,DIRUT) ;EP
 ;---> Edit Start/End date.
 ;     1 - BIMODE   (req) Equals START or END.
 ;     2 - BIDATES  (req) Default Start & End Dates from Site Parmeter.
 ;     3 - BIRESULT (ret) Selected date in the form mm/dd.
 ;     4 - DIRUT    (RET) =1 if user ^'d out.
 ;
 F  D  Q:BIPOP
 .N DIR,Y S BIPOP=0
 .S DIR("?")="     Enter the "_BIMODE_" Date of the Flu Season as mm/dd"
 .S DIR(0)="FA^3:5",DIR("A")="     Enter "_BIMODE_" Date: "
 .N BIDEFLT S BIDFLT=$S(BIMODE="START":$P(BIDATES,"%"),1:$P(BIDATES,"%",2))
 .S DIR("B")=BIDFLT
 .D ^DIR
 .I $D(DIRUT) S BIPOP=1 Q
 .;
 .;---> Add leading zeros if necessary.
 .I $L($P(Y,"/"))=1,$P(Y,"/")>0 S Y="0"_Y
 .I $L($P(Y,"/",2))=1,$P(Y,"/",2)>0 S Y=$P(Y,"/")_"/"_"0"_$P(Y,"/",2)
 .;
 .;---> Check pattern match.
 .I Y'?2N1"/"2N D  S BIPOP=0 Q
 ..W !!?10,"Using numbers, please enter the month, then a slash, then the day.",!
 .;
 .;---> Check valid month.
 .I (+$P(Y,"/")<1)!(+$P(Y,"/")>12) D  S BIPOP=0 Q
 ..W !!?10,$P(Y,"/")," is not a valid MONTH."
 ..W !?10,"Using numbers, please enter the month, then a slash, then the day.",!
 .;
 .;---> Check valid day.
 .I (+$P(Y,"/",2)<1)!(+$P(Y,"/",2)>31) D  S BIPOP=0 Q
 ..W !!?10,$P(Y,"/",2)," is not a valid DAY."
 ..W !?10,"Using numbers, please enter the month, then a slash, then the day.",!
 .;
 .;---> Check for legit day, given the month.
 .I +$P(Y,"/")=2,+$P(Y,"/",2)>29 D  S BIPOP=0 Q
 ..W !!?10,Y, " is not a valid date",!
 .N Z S Z=+$P(Y,"/") I (Z=4)!(Z=6)!(Z=9)!(Z=11) I +$P(Y,"/",2)>30 D  S BIPOP=0 Q
 ..W !!?10,Y, " is not a valid date",!
 .;
 .;---> If START is earlier than 07/01 or the END is later than 6/30, reject.
 .I BIMODE="START",+$P(Y,"/")<7 D  S BIPOP=0 Q
 ..W !!?10,"START Date cannot be before 07/01.",!
 .I BIMODE="END",+$P(Y,"/")>6 D  S BIPOP=0 Q
 ..W !?5,"END Date cannot be after 06/30.",!
 .;
 .;---> Set new Date.
 .S BIRESULT=Y,BIPOP=1
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;Please select the Start and End Dates for the Influenza Season.
 ;;
 ;;Enter the dates in the numeric form: mm/dd
 ;;For example, August 15 would be entered as 08/15.
 ;;             April 1st would be entered as 04/01.
 ;;
 D PRINTX("TEXT5")
 Q
 ;**********
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;When an Immunization Visit or Skin Test Visit is stored, the default
 ;;Category of Visit is "Ambulatory" (Outpatient).
 ;;However, if the RPMS PIMS (Patient Information Management System) or
 ;;various Billing applications are in use, the patient may have the
 ;;Status of "Inpatient" at the time of the visit.
 ;;
 ;;In order to avoid conflicts that might arise from Inpatient and
 ;;Ambulatory Visits being listed for the same day, this software
 ;;can check the Inpatient Status of the patient at the time of the
 ;;immunization or skin test.  If the patient is listed as an Inpatient
 ;;at the time of the immunization, the software can automatically
 ;;change the Category from Ambulatory to Inpatient for the immunization.
 ;;
 ;;This feature is turned on by setting "Inpatient Visit Check" to ENABLE.
 ;;If the "Inpatient Visit Check" feature is causing problems, however,
 ;;(such as conflicts with third-party Billing software), then set the
 ;;parameter to DISABLE and no Inpatient check will occur.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Update options to include Hep B.
 ;----------
RISKP ;EP
 ;---> Edit the parameter that determines whether the Risk Status
 ;---> for patients with regard to Flu and Pneumo should be checked
 ;---> (in the Visit files) when forecasting those vaccines.
 ;---> Called by Protocol BI SITE INPATIENT CHECK ENABLE.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("ENABLE/DISABLE RISK FACTOR CHECKS"),TEXT2
 N BIERR,BIDFLT,BIDFLT1,BISEL,DIR,DIRUT,Y
 S BIDFLT=$$RISKP^BIUTL2(BISITE)
 S DIR(0)="SO^0:None;1:Hep B only;2:Pneumo only;3:Both"
 S DIR("A")="     High Risk option"
 D
 .I BIDFLT=1 S BIDFLT1="Hep B only" Q
 .I (BIDFLT=2)!(BIDFLT=23) S BIDFLT1="Pneumo only" Q
 .I (BIDFLT=12)!(BIDFLT=123) S BIDFLT1="Both" Q
 .S BIDFLT1="None"
 S DIR("B")=BIDFLT1
 D ^DIR
 I $D(DIRUT) D RESET^BISITE Q
 ;---> Save user selection.
 S BISEL=Y S:Y=3 BISEL=12
 ;
 N BISMOK S BISMOK=0
 D:(BISEL[2)
 .D FULL^VALM1,TITLE^BIUTL5("INCLUDE SMOKING AS A PNEUMO RISK FACTOR"),TEXT21
 .W !!,"     Do you wish to include a history of SMOKING in the criteria for"
 .W !,"     the High Risk Pneumo group?",!
 .S DIR("?",1)="     Enter YES to include SMOKING as a Pneumo High Risk Factor, "
 .S DIR("?")="     enter NO to disregard it as a High Risk Factor."
 .S DIR(0)="Y",DIR("A")="     Enter Yes or No"
 .S DIR("B")=$S(BIDFLT[3:"YES",1:"NO")
 .D ^DIR
 .I Y S BISMOK=1
 ;
 Q:$D(DIRUT)
 D
 .I BISEL<2 Q
 .I (BISEL=2)&(BISMOK=0) Q
 .I (BISEL=2)&(BISMOK=1) S BISEL=23 Q
 .I (BISEL=12)&(BISMOK=0) Q
 .I (BISEL=12)&(BISMOK=1) S BISEL=123 Q
 ;
 N BIFLD,BIERR S BIFLD(.19)=BISEL
 D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 ;
 D RESET^BISITE
 Q
 ;**********
 ;
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Update Help TEXT2 to no longer include influenza.
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Update Help TEXT2 to include Hep B.
 ;----------
TEXT2 ;EP
 ;;When forecasting immunizations for a patient, this program is able
 ;;to look at the patient's medical history of visits and attempt to
 ;;determine if the patient has an increased risk for pneumococcal disease
 ;;and/or Hepatitis B due to Diabetes.  If the patient fits the High Risk
 ;;criteria, the program will forecast the patient as due for those
 ;;immunizations.
 ;;
 ;;This parameter allows you to select which, if any, High Risk forecasting
 ;;should be enabled on your system.
 D PRINTX("TEXT2")
 Q
 ;**********
 ;
 ;
 ;----------
TEXT21 ;EP
 ;;You have the option to include smoking in the High Risk factors for
 ;;Pneumococcal disease.  Specifically, the Health Factors looked for will
 ;;be either "Current Smoker" or "Current Smoker and Smokeless" within
 ;;the last two years.
 ;;
 D PRINTX("TEXT21")
 Q
 ;
 ;
 ;----------
IMPCPT ;EP
 ;---> Edit the parameter that determines whether the CPT-coded Visits
 ;---> should be imported into the V Immunization File if they have
 ;---> not already been entered.
 ;---> Called by Protocol BI SITE CPT VISITS IMPORT.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("ENABLE/DISABLE IMPORT OF CPT-CODED VISITS"),TEXT3
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^E:Enable;D:Disable"
 S DIR("A")="     Please select either Enable or Disable: "
 S DIR("B")=$S($$IMPCPT^BIUTL2(BISITE):"Enable",1:"Disable")
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.2)=$G(Y)
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;In RPMS it is possible for some immunizations to be entered by
 ;;CPT Code into the CPT Visit File, rather than into the true
 ;;Immunization Visit File.  These "CPT-coded immunizations"
 ;;do NOT appear on the patient's Immunization Profile, nor are
 ;;they always included in the Immunization Package Reports.
 ;;
 ;;When the "Import CPT-coded Visits" site parameter is enabled,
 ;;those immunizations that are entered only as CPT Visits will be
 ;;checked and automatically entered into the proper Immunization
 ;;Visits File if they do not already exist there.
 ;;
 ;;If this parameter is disabled, the program will make no attempt
 ;;to bring CPT-coded Visits into the Immunization files.
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
VISMNU ;EP
 ;---> Edit the parameter that determines whether the Risk Status
 ;---> for patients with regard to Flu and Pneumo should be checked
 ;---> (in the Visit files) when forecasting those vaccines.
 ;---> Called by Protocol BI SITE INPATIENT CHECK ENABLE.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("ENABLE/DISABLE VISIT SELECTION MENU"),TEXT4
 N BIDFLT,DIR,DIRUT,Y
 S DIR(0)="SOA^E:Enable;D:Disable"
 S DIR("A")="     Please select either Enable or Disable: "
 S DIR("B")=$S($$VISMNU^BIUTL2(BISITE):"Enable",1:"Disable")
 D ^DIR
 D:'$D(DIRUT)
 .N BIFLD,BIERR S BIFLD(.28)=$G(Y)
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;When adding or editing immunizations, this program will either
 ;;create a NEW Visit or link the immunization to an EXISTING Visit.
 ;;This process can be occur automatically, or it can be controlled
 ;;by the user at the time the immunization is being entered.
 ;;
 ;;If the Visit Selection Menu is DISABLED, the program will look for
 ;;similar Visits for the patient on that day and attempt to link with
 ;;one if enough information matches.  If no such Visits exist, a new
 ;;Visit will be created automatically.  (This can sometimes lead to
 ;;Visits that are incorrectly linked and must be corrected manually.)
 ;;
 ;;If the Visit Selection Menu is ENABLED, the program will look for
 ;;similar Visits--and if any exist--a Visit Selection Menu will pop up.
 ;;The Visit Selection Menu will allow the user to either create a new
 ;;Visit or select from existing Visits for that day.  (If there are no
 ;;existing Visits, a new Visit will be created automatically.)
 ;;
 D PRINTX("TEXT4")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
