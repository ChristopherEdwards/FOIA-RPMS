PXRMXGPR ; SLC/PJH - Reminder Due print calls ;03-Nov-2005 13:28;MGH
 ;;1.5;CLINICAL REMINDERS;**6,11,1004**;Jun 19, 2000
 ;IHS/CIA/MGH Changes made to display primary care provider data for IHS
 ;Called from PXRMXPR
 ;
 ;Print Selection criteria
HEAD(PSTART) ;
 I SUB="TOTAL" N NAM S NAM="TOTAL REPORT"
 I PXRMTABS="Y" D  Q
 .N FFAC,FNAM
 .S FNAM=NAM
 .I "CES"[PXRMTABC S FNAM=$TR(FNAM,SEP,"_")
 .I PXRMFCMB="N","LT"[PXRMSEL D  Q
 ..S FFAC=$TR(FACPNAME,SEP,"_")
 ..W !,"0"_SEP_FFAC_"_"_FNAM_SEP_SEP
 .I PXRMFCMB="N","LT"'[PXRMSEL W !,"0"_SEP_FNAM_SEP_SEP Q
 .I PXRMFCMB="Y" W !,"0"_SEP_"COMBINED_REPORT_"_FNAM_SEP_SEP Q
 I "LT"[PXRMSEL D
 .I PXRMFCMB="N" W !,?PSTART,"Facility: ",FACPNAME Q
 .W !,?PSTART,"Combined Report: "
 .N FACN,LENGTH,TEXT
 .S FACN=0,LENGTH=17+PSTART
 .F  S FACN=$O(PXRMFACN(FACN)) Q:'FACN  D
 ..S TEXT=$P(PXRMFACN(FACN),U)_" ("_FACN_")"
 ..I $O(PXRMFACN(FACN)) S TEXT=TEXT_", "
 ..I (LENGTH+$L(TEXT))>80 S LENGTH=17+PSTART W !,?(17+PSTART)
 ..W TEXT S LENGTH=LENGTH+$L(TEXT)
 I "PTO"[PXRMSEL D
 .I SUB="TOTAL" W !,?PSTART,NAM Q
 .W !,?PSTART,"Reminders "_PXRMTX_" for ",NAM
 I PXRMSEL="L" W !,?PSTART,"Reminders "_PXRMTX_" "_SD_" - ",NAM
 I PXRMSEL="L" D
 .I "PF"[PXRMFD W " for ",BD," to ",ED
 .I PXRMFD="A" W " admissions from ",BD," to ",ED
 .I PXRMFD="C" W " for current inpatients"
 I PXRMSEL'="L" W " for ",SD
 W:PXRMSEL="I" !
 ;
 Q
 ;
 ;Set up literals for display
LITS I PXRMSEL="I" S PXRMFLD="Individual Patients"
 I PXRMSEL="P" S PXRMFLD="PCMM Provider"
 I PXRMSEL="O" S PXRMFLD="OE/RR Team"
 I PXRMSEL="T" S PXRMFLD="PCMM Team"
 ;IHS/CIA/MGH PATCH 1004 Added for IHS primary care provider
 I PXRMSEL="D" S PXRMFLD="Primary Care Provder"
 I PXRMSEL="L" D
 .S PXRMFLD="Location"
 .I $P(PXRMLCSC,U)="HS" S DES="Selected Hospital Locations"
 .I $P(PXRMLCSC,U)="HA" S DES="All Outpatient Locations"
 .I $P(PXRMLCSC,U)="HAI" S DES="All Inpatient Locations"
 .I $P(PXRMLCSC,U)="CS" S DES="Selected Clinic Stops"
 .I $P(PXRMLCSC,U)="CA" S DES="All Clinic Stops"
 .I $P(PXRMLCSC,U)="GS" S DES="Selected Clinic Groups"
 .I PXRMFD="P" S DES=DES_" (Prior Encounters)"
 .I PXRMFD="F" S DES=DES_" (Future Appoints.)"
 .I PXRMFD="A" S DES=DES_" (Admissions)"
 .I PXRMFD="C" S DES=DES_" (Current Inpatients)"
 I PXRMSEL="P" D
 .I PXRMPRIM="A" S CDES="All patients on list"
 .I PXRMPRIM="P" S CDES="Primary care assigned patients only"
 Q
 ;
 ;Output the provider report criteria
CRIT(PSTART) ;
 N RCCNT,RCDES,RICNT,RIDES,UNDL
 S UNDL=$TR($J("",79)," ","_") D LITS
 W !?(PSTART-8),"Report Criteria:"
 I PXRMTMP'="" W !?PSTART,"Report Title:",?32,$P(PXRMTMP,U,3)
 W !?PSTART,"Patient Sample:",?32,PXRMFLD
 I PXRMSEL'="L" W !,?PSTART,PXRMFLD,":" D DISP
 I PXRMSEL="L" D
 .W !?PSTART,PXRMFLD,":",?32,DES
 .I $E(PXRMLCSC,2)'="A" W ! D DISP
 I $D(PXRMRCAT) D
 .S RCCNT=0
 .F  S RCCNT=$O(PXRMRCAT(RCCNT)) Q:'RCCNT  D
 ..S RCDES=$P(PXRMRCAT(RCCNT),U,2) D CHECK(6)
 ..I RCCNT=1 W !?PSTART,"Reminder Category:",?32,RCDES
 ..I RCCNT>1 W !?32,RCDES
 .S RICNT=0
 .F  S RICNT=$O(PXRMREM(RICNT)) Q:'RICNT  D
 ..S RIDES=$P(PXRMREM(RICNT),U,2) D CHECK(6)
 ..I RICNT=1 W !?PSTART,"Individual Reminder:",?32,RIDES
 ..I RICNT>1 W !?32,RIDES
 D CHECK(6)
 I PXRMREP="D" D
 .W !,?PSTART,"Reminder:",?32,RDES
 .;Display future appointments for Reminder Due report only
 .I PXRMRT="PXRMX" W !,?PSTART,"Appointments:" D
 ..I PXRMFUT="Y" W ?32,"All Future Appointments"
 ..I PXRMFUT="N" W ?32,"Next Appointment only"
 I PXRMSEL="P" W !,?PSTART,"All/Primary:",?32,CDES
 ;IHS/CIA/MGH Added the "D" for IHS providers
 I PXRMSEL="L"!(PXRMSEL="D") D
 .W !?PSTART,"Date Range:",?32
 .I "PAF"[PXRMFD W BD," to ",ED Q
 .I PXRMFD="C" W "not applicable" Q
 W !?PSTART,"Effective Due Date:",?32,SD
 W !?PSTART,"Date run:",?32,RD
 I PXRMTMP'="" D
 .W !?PSTART,"Template Name:",?32,$P(PXRMTMP,U,2)
 .I PXRMUSER D CHECK(3) W !?PSTART,"Requested by:",?32,$P(^VA(200,DUZ,0),U)
 I (PXRMFCMB="Y")!(PXRMLCMB="Y") D
 .N LIT
 .S LIT=$S(PXRMSEL="P":"Providers","OT"[PXRMSEL:"Teams",1:"Locations")
 .W !?PSTART,"Combined report:",?32
 .I PXRMFCMB="Y",PXRMLCMB="Y" W "Combined Facility and Combined "_LIT
 .I PXRMFCMB="Y",PXRMLCMB="N" W "Combined Facility by Individual "_LIT
 .I PXRMLCMB="Y",PXRMFCMB="N" W "By Facility with Combined "_LIT
 .D CHECK(3)
 I PXRMREP="S","IRT"[PXRMTOT D
 .N LIT1,LIT2,LIT3
 .D LIT^PXRMXD
 .W !?PSTART,"Summary report:",?32
 .I PXRMTOT="I" W LIT1
 .I PXRMTOT="R" W LIT2
 .I PXRMTOT="T" W LIT3
 .D CHECK(3)
 I $D(PXRMSCAT),PXRMFD="P" D OSCAT(PXRMSCAT,PSTART)
 W !,UNDL,!
 Q
 ;
 ;Display selected teams/providers
DISP N IC
 S IC=""
 ;IHS/CIA/MGH PATCH 1004 Added "D" for IHS provider
 I PXRMSEL="P"!(PXRMSEL="D") F  S IC=$O(PXRMPRV(IC)) Q:IC=""  D
 .W:IC>1 ! W ?32,$P(PXRMPRV(IC),U,2)
 .D CHECK(3)
 I PXRMSEL="T" F  S IC=$O(PXRMPCM(IC)) Q:IC=""  D
 .W:IC>1 ! W ?32,$P(PXRMPCM(IC),U,2)
 .D CHECK(3)
 I PXRMSEL="O" F  S IC=$O(PXRMOTM(IC)) Q:IC=""  D
 .W:IC>1 ! W ?32,$P(PXRMOTM(IC),U,3)
 .D CHECK(3)
 I PXRMSEL="I" F  S IC=$O(PXRMPAT(IC)) Q:IC=""  D
 .W:IC>1 ! W ?32,$P(PXRMPAT(IC),U,2)
 .D CHECK(3)
 I PXRMSEL="L" D
 .I $E(PXRMLCSC)="H" F  S IC=$O(PXRMLCHL(IC)) Q:IC=""  D
 ..W:IC>1 ! W ?32,$P(PXRMLCHL(IC),U)
 ..D CHECK(3)
 .I $E(PXRMLCSC)="C" F  S IC=$O(PXRMCS(IC)) Q:IC=""  D
 ..W:IC>1 ! W ?32,$P(PXRMCS(IC),U)," ",$P(PXRMCS(IC),U,3)
 ..D CHECK(3)
 .I $E(PXRMLCSC)="G" F  S IC=$O(PXRMCGRP(IC)) Q:IC=""  D
 ..W:IC>1 ! W ?32,$P(PXRMCGRP(IC),U)," ",$P(PXRMCGRP(IC),U,2)
 ..D CHECK(3)
 Q
 ;
 ;Build array of locations/providers/teams with no patients
NOPATS N IC
 S IC=""
 I PXRMSEL="P" F  S IC=$O(PXRMPRV(IC)) Q:IC=""  D TEST(.PXRMPRV)
 I PXRMSEL="T" F  S IC=$O(PXRMPCM(IC)) Q:IC=""  D TEST(.PXRMPCM)
 I PXRMSEL="O" F  S IC=$O(PXRMOTM(IC)) Q:IC=""  D TEST(.PXRMOTM)
 I PXRMSEL="L" D
 .I $E(PXRMLCSC)="H" F  S IC=$O(PXRMLCHL(IC)) Q:IC=""  D TEST(.PXRMLCHL)
 .I $E(PXRMLCSC)="C" F  S IC=$O(PXRMCS(IC)) Q:IC=""  D TEST(.PXRMCS)
 .I $E(PXRMLCSC)="G" F  S IC=$O(PXRMCGRP(IC)) Q:IC=""  D TEST(.PXRMCGRP)
 Q
 ;
 ;Output the service categories
OSCAT(SCL,PSTART) ;
 N IC,CSTART,EM,SC,SCTEXT
 S CSTART=PSTART+3
 W !,?PSTART,"Service categories:",?32,SCL
 F IC=1:1:$L(SCL) D
 .S SC=$E(SCL,IC,IC)
 .S SCTEXT=$$EXTERNAL^DILFD(9000010,.07,"",SC,.EM)
 .D CHECK(3)
 .W !,?CSTART,SC," - ",SCTEXT
 Q
 ;
 ;If necessary, write the header
COL(NEWPAGE) ;
 I NEWPAGE D  Q:DONE
 .I PXRMTABS="N" D PAGE
 .I PXRMTABS="Y" W !!
 D CHECK(0) Q:DONE
 D HEAD(0)
 S HEAD=0
 I PXRMTABS="Y" Q
 I PXRMREP="D" D
 .N PNAM
 .S PNAM=$P(PXRMREM(1),U,4) I PNAM="" S PNAM=$P(PXRMREM(1),U,2)
 .W !!,PNAM,":  ",COUNT
 .W:COUNT>1 " patients have reminder "_PXRMTX
 .W:COUNT=1 " patient has reminder "_PXRMTX
 N IC F IC=0:1:2 W !,?PXRMT(IC),PXRMH(IC)
 Q
 ;
 ;form feed to new page
PAGE I ($E(IOST)="C")&(IO=IO(0))&(PAGE>0) D
 .S DIR(0)="E"
 .W !
 .D ^DIR K DIR
 I $D(DUOUT)!($D(DTOUT))!($D(DIROUT)) S DONE=1 Q
 W:$D(IOF)&(PAGE>0) @IOF
 S PAGE=PAGE+1,FIRST=0
 I $E(IOST)="C",IO=IO(0) W @IOF
 E  W !
 N TEMP,TEXTLEN
 S TEMP=$$NOW^XLFDT,TEMP=$$FMTE^XLFDT(TEMP,"P")
 S TEMP=TEMP_"  Page "_PAGE
 S TEXTLEN=$L(TEMP)
 W ?(IOM-TEXTLEN),TEMP
 S TEXTLEN=$L(PXRMOPT)
 I TEXTLEN>0 D
 .W !!
 .W ?((IOM-TEXTLEN)/2),PXRMOPT
 Q
 ;
 ;count of patients in sample
TOTAL N LIT
 I PXRMTABS="Y" D  Q
 .I PXRMREP="D" W !,"0"_SEP_"PATIENTS"_SEP_TOTAL_SEP_"APPLICABLE"_SEP_APPL Q
 .I PXRMREP="S" W !,"0"_SEP_"PATIENTS"_SEP_TOTAL_SEP_SEP_$TR(SUB,SEP,"_") Q
 I (PXRMRT="PXRMX")!(PXRMREP="S") W !
 S LIT=" patient."
 I TOTAL>1 S LIT=" patients."
 W !,"Report run on "_TOTAL_LIT
 I PXRMREP="D" D
 .S LIT=" patient."
 .I APPL>1 S LIT=" patients."
 .W !,"Applicable to "_APPL_LIT
 Q
 ;
 ;Null report prints if no patients found
NULL I PXRMSEL="L" D
 .I PXRMFD="P" W !!,"No patient visits found"
 .I PXRMFD="A" W !!,"No patient admissions found"
 .I PXRMFD="C" W !!,"No current inpatient found"
 .I PXRMFD="F" W !!,"No patient appointments found"
 I PXRMSEL="P" W !!,"No patients found for provider(s) selected"
 I "OT"[PXRMSEL W !!,"No patients found for team(s) selected"
 Q
 ;
 ;Null report if no patients due/satisfied - detailed report only
NONE D PAGE
 D HEAD(0)
 W !!,"No patients with reminders "_PXRMTX
 Q
 ;
 ;Report missed locations if report is partially successful
MATCH(PSTART) ;
 ;Delimited report from template
 I PXRMTABS="Y",PXRMTMP'="" D  Q
 .W !!?PSTART,"The following had no patients selected",!
 .N SUB
 .S SUB=""
 .F  S SUB=$O(MISSED(SUB)) Q:SUB=""  D
 ..W !?PSTART+10,SUB
 ;Other reports
 N LIT,SUB
 D CHECK(5) Q:DONE
 S LIT=PXRMFLD
 I PXRMSEL="L",$E(PXRMLCSC)="G" S LIT="Clinic Group"
 W !!?PSTART,"The following ",LIT,"(s) had no patients selected",!
 S SUB=""
 F  S SUB=$O(MISSED(SUB)) Q:SUB=""  D
 .D CHECK(3) Q:DONE
 .W !?PSTART+10,SUB
 Q
 ;
 ;Check for match on location
TEST(ARRAY) ;
 N SUB
 I $D(^XTMP(PXRMXTMP,"MARKED AS FOUND",IC)) Q
 S MATCH=1
 I PXRMSEL'="L" S SUB=$P(ARRAY(IC),U,2)
 I PXRMSEL="L" S SUB=$P(ARRAY(IC),U,1)
 I PXRMSEL="L",$E(PXRMLCSC)="H" D
 .N HLOCIEN,FACNAM,FACNUM
 .S HLOCIEN=$P(ARRAY(IC),U,2) Q:'HLOCIEN
 .S FACNUM=$$FACL^PXRMXAP(HLOCIEN) Q:'FACNUM
 .S FACNAM=$P($G(PXRMFACN(FACNUM)),U)
 .I FACNAM'="" S SUB=SUB_" ("_FACNAM_")"
 I PXRMSEL="L",$E(PXRMLCSC)="C" S SUB=SUB_" "_$P(ARRAY(IC),U,3)
 I PXRMSEL="L",$E(PXRMLCSC)="G" S SUB=SUB_" "_$P(ARRAY(IC),U,2)
 S MISSED(SUB)=""
 Q
 ;
 ;Check for page throw
CHECK(CNT) ;
 I PXRMTABS="N",$Y>(IOSL-BMARG-CNT) D PAGE
 Q
