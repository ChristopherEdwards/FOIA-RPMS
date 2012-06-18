BISITE4 ;IHS/CMI/MWR - SELECT GPRA COMMUNITIES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  SELECT COMMUNITIES TO BE INCLUDED IN GPRA GROUPS AND REPORTS.
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
GETGPRA(BIGPRA,BIDUZ,BIERR) ;PEP - Return GPRA Communities Array.
 ;---> Retrieve GPRA Communities Array of IEN's for this DUZ(2).
 ;---> Parameters:
 ;     1 - BIGPRA (ret) Array of GPRA IEN's in the COMMUNITY file - ^AUTTCOM(.
 ;     2 - BIDUZ  (req) Site IEN or DUZ(2).
 ;     3 - BIERR  (ret) Error text, if any.
 ;
 I '$G(BIDUZ) S BIDUZ=$G(DUZ(2))
 I '$G(BIDUZ) D ERRCD^BIUTL2(109,.BIERR) Q
 I '$O(^BISITE(DUZ(2),2,0)) D ERRCD^BIUTL2(110,.BIERR) Q
 N N S N=0
 F  S N=$O(^BISITE(DUZ(2),2,N)) Q:'N  S BIGPRA(N)=""
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
 D FULL^VALM1,TITLE^BIUTL5("ENABLE/DISABLE INPATIENT VISIT CHECK"),TEXT1
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
 ;----------
RISKP ;EP
 ;---> Edit the parameter that determines whether the Risk Status
 ;---> for patients with regard to Flu and Pneumo should be checked
 ;---> (in the Visit files) when forecasting those vaccines.
 ;---> Called by Protocol BI SITE INPATIENT CHECK ENABLE.
 ;
 Q:$$BISITE^BISITE2
 D FULL^VALM1,TITLE^BIUTL5("ENABLE/DISABLE RISK FACTOR CHECK"),TEXT2
 N BIERR,BIDFLT,DIR,DIRUT,Y
 S BIDFLT=$$RISKP^BIUTL2(BISITE)
 S DIR(0)="SOA^E:Enable;D:Disable"
 S DIR("A")="     Please select either Enable or Disable: "
 S DIR("B")=$S(BIDFLT:"Enable",1:"Disable")
 D ^DIR
 I $D(DIRUT) D RESET^BISITE Q
 ;
 N BIFLD,BIERR S BIFLD(.19)=$G(Y)
 D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3() D RESET^BISITE Q
 ;
 D:(BIFLD(.19)="E")
 .D FULL^VALM1,TITLE^BIUTL5("INCLUDE SMOKING AS A PNEUMO RISK FACTOR"),TEXT21
 .W !!,"     Do you wish to include a history of SMOKING in the criteria for"
 .W !,"     the High Risk Pneumo group?",!
 .S DIR("?",1)="     Enter YES to include SMOKING as a Pneumo High Risk Factor, "
 .S DIR("?")="     enter NO to disregard it as a High Risk Factor."
 .S DIR(0)="Y",DIR("A")="     Enter Yes or No"
 .S DIR("B")=$S(BIDFLT=3:"YES",1:"NO")
 .D ^DIR W !
 .Q:$D(DIRUT)  Q:'Y
 .N BIFLD,BIERR S BIFLD(.19)="I"
 .D FDIE^BIFMAN(9002084.02,BISITE,.BIFLD,.BIERR,1)
 .I BIERR]"" W !!?3,BIERR D DIRZ^BIUTL3()
 ;
 D RESET^BISITE
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;When forecasting immunizations for a patient, this program is able
 ;;to look at the patient's medical history of visits and attempt to
 ;;determine if the patient has an increased risk for influenza or
 ;;pneumococcal disease.  If the patient fits the High Risk criteria,
 ;;the program will forecast the patient as due for one or both of
 ;;those immunizations.
 ;;
 ;;This parameter either Enables or Disables that feature.
 ;;
 D PRINTX("TEXT2")
 Q
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
