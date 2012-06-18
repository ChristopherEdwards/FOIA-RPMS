PXRMXSEL ; SLC/PJH - Process Visits/Appts Reminder Due report;11/20/2001
 ;;1.5;CLINICAL REMINDERS;**6**;Jun 19, 2000
 ;
 ; Called from PXRMXSE
 ;
TMP(INP) ;Update ^TMP("PXRMX"
 I PXRMFCMB="Y" N FACILITY S FACILITY="COMBINED FACILITIES"
 I PXRMLCMB="Y" N NAM S NAM="COMBINED LOCATIONS"
 S ^TMP("PXRMX",$J,FACILITY,NAM,DFN)=INP
 Q
 ;
 ;Mark location as found
MARK S ^XTMP(PXRMXTMP,"MARKED AS FOUND",IC)=""
 Q
 ;
 ;Build list of Current inpatients
INP N FACILITY,HLOCIEN,IC,NAM,DFN,FOUND
 ;Default for HA/HAI options
 S NAM="All Locations"
 ;For all wards build temporary array
 I $E(PXRMLCSC,2)="A" N PXRMLCHL,PXRMLOCN D LCHL^PXRMXAP(1,.PXRMLCHL)
 ;Get Current inpatients for each selected location
 F IC=1:1 Q:'$D(PXRMLCHL(IC))  D
 .S HLOCIEN=$P(PXRMLCHL(IC),U,2) Q:HLOCIEN=""
 .S FACILITY=$$FACL^PXRMXAP(HLOCIEN) Q:FACILITY=""
 .Q:'$D(PXRMFACN(FACILITY))
 .;Get WARDIEN,WARDNAM and return DFN's in PATS
 .N PATS D WARD^PXRMXAP(HLOCIEN,.PATS)
 .;Split report by location
 .I PXRMLCMB="N" S NAM=$P(PXRMLCHL(IC),U)
 .;Build ^TMP for selected patients 
 .S DFN="",FOUND=0
 .F  S DFN=$O(PATS(DFN)) Q:DFN=""  D TMP(HLOCIEN) I 'FOUND S FOUND=1
 .I FOUND D MARK
 Q
 ;
 ;Build list of inpatients admissions
ADM N FACILITY,HLOCIEN,IC,NAM,DFN,FOUND,BD,ED
 ;Default for HA/HAI options
 S NAM="All Locations"
 ;For all wards build temporary array
 I $E(PXRMLCSC,2)="A" N PXRMLCHL,PXRMLOCN D LCHL^PXRMXAP(1,.PXRMLCHL)
 ;Get admissions for each selected location
 F IC=1:1 Q:'$D(PXRMLCHL(IC))  D
 .S HLOCIEN=$P(PXRMLCHL(IC),U,2) Q:HLOCIEN=""
 .S FACILITY=$$FACL^PXRMXAP(HLOCIEN) Q:FACILITY=""
 .Q:'$D(PXRMFACN(FACILITY))
 .; Get admissions from patient movements and return DFN's in PATS
 .S BD=PXRMBDT-.0001
 .S ED=PXRMEDT+.2359
 .N PATS D ADM^PXRMXAP(HLOCIEN,.PATS,BD,ED)
 .;Split report by location
 .I PXRMLCMB="N" S NAM=$P(PXRMLCHL(IC),U)
 .;Build ^TMP for selected patients 
 .S DFN="",FOUND=0
 .F  S DFN=$O(PATS(DFN)) Q:DFN=""  D TMP(HLOCIEN) I 'FOUND S FOUND=1
 .I FOUND D MARK
 Q
 ;
 ;Scan visit file to build list of patients
VISITS N BD,CLINIEN,ED,HLOCIEN,HLOCNAM,FOUND,FACILITY,CGRPIEN
 N PRVCNT,PRVIEN,VIEN,VISIT,IC
 N DFN,PNAM,NAM
 S NAM="All Locations"
 ;
 S BD=PXRMBDT-.0001
 S ED=PXRMEDT+.2359
 ;Get Date ; DBIA 2028
 F  S BD=$O(^AUPNVSIT("B",BD)) Q:BD>ED  Q:BD=""  Q:ZTSTOP=1  D
 .;Display busy 
 .I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) D SPIN^PXRMXBSY("Sorting Encounters",.BUSY)
 .S VIEN=0
 .;Get individual visit
 .F  S VIEN=$O(^AUPNVSIT("B",BD,VIEN)) Q:VIEN=""  Q:ZTSTOP=1  D
 ..;Check if stop task requested
 ..I $$S^%ZTLOAD S ZTSTOP=1 Q
 ..D SCREEN
 Q
 ;
 ;Screen Individual Visit
SCREEN S VISIT=$G(^AUPNVSIT(VIEN,0)) Q:VISIT=""
 ;Facility
 S FACILITY=$P(VISIT,U,6) S:FACILITY="" FACILITY=+$P($$SITE^VASITE,U,3)
 Q:FACILITY=""  Q:'$D(PXRMFACN(FACILITY))
 ;
 ;
 ;Service categories (ex-PXRR)
 I PXRMSCAT'[$P(VISIT,U,7) Q
 ;
 S FOUND=0
 ;
 ;Selected Clinic stops
 I PXRMSEL="L",($E(PXRMLCSC)="C") D  Q:'FOUND
 .S CLINIEN=$P(VISIT,U,8) Q:CLINIEN=""
 .I $P(PXRMLCSC,U,1)="CS" D  Q:'FOUND
 ..S IC=$G(PXRMCSN(CLINIEN)) Q:IC=""
 ..;Mark the clinic as matched
 ..S FOUND=1 D MARK
 ..S HLOCNAM=$P(^DIC(40.7,CLINIEN,0),U,1)_U_CLINIEN ; DBIA 557
 ..S NAM=$P(HLOCNAM,U,1)_" "_$P(PXRMCS(IC),U,3)
 .S FOUND=1
 ;
 ;Selected Clinic Groups
 I PXRMSEL="L",($E(PXRMLCSC)="G") D  Q:'FOUND
 .S HLOCIEN=$P(VISIT,U,22) Q:HLOCIEN=""
 .; Check if location is in clinic group ; DBIA 2804
 .S CGRPIEN=$P($G(^SC(HLOCIEN,0)),U,31) Q:CGRPIEN=""
 .I $P(PXRMLCSC,U,1)="GS" D  Q:'FOUND
 ..S IC=$G(PXRMCGRN(CGRPIEN)) Q:IC=""
 ..;Mark the clinic as matched
 ..S FOUND=1 D MARK
 ..S HLOCNAM=$P(^SC(HLOCIEN,0),U,1)_U_HLOCIEN
 ..S NAM=$P(HLOCNAM,U,1)
 .S FOUND=1
 ;
 ;Selected Locations
 I PXRMSEL="L",($E(PXRMLCSC)="H") D  Q:'FOUND
 .S HLOCIEN=$P(VISIT,U,22) Q:HLOCIEN=""
 .;All inpatient locations - location must be a ward
 .I $P(PXRMLCSC,U)="HAI" S:$D(^SC(HLOCIEN,42)) FOUND=1 Q
 .;All outpatient locations - location cannot be a ward
 .I $P(PXRMLCSC,U)="HA" D  Q
 ..I '$D(^SC(HLOCIEN,42)) S FOUND=1,NAM=$P(^SC(HLOCIEN,0),U,1)
 .;Selected locations
 .I $P(PXRMLCSC,U,1)="HS" D  Q:'FOUND
 ..S IC=$G(PXRMLOCN(HLOCIEN)) Q:IC=""
 ..;Mark the location as matched
 ..S FOUND=1 D MARK
 ..S CLINIEN=$P(^SC(HLOCIEN,0),U,7)
 ..S HLOCNAM=$P(^SC(HLOCIEN,0),U,1)_U_HLOCIEN
 ..S NAM=$P(HLOCNAM,U,1)
 .S FOUND=1
 ;
 S DFN=$P(VISIT,U,5)
 ;Build patient list in ^TMP
 I $E(PXRMLCSC)="C" D TMP(CLINIEN)
 I $E(PXRMLCSC)="G" D TMP(CGRPIEN)
 I $E(PXRMLCSC)="H" D TMP(HLOCIEN)
 Q
 ;
 ;Scan Future Appointments
APPTS N II,IC,HLOCIEN,CLINIEN,BD,ED,NAM,FACILITY,DFN,PNAM
 S NAM="All Locations"
 ;
 ;If all locations/clinics selected
 I $E(PXRMLCSC,2)="A" D
 .S HLOCIEN=0
 .F  S HLOCIEN=$O(^SC(HLOCIEN)) Q:'HLOCIEN  D  Q:ZTSTOP=1  ; DBIA 2804
 ..I $E(PXRMLCSC)="C" D
 ...S CLINIEN=$P(^SC(HLOCIEN,0),U,7)
 ..D SC
 ;If selected locations
 I $P(PXRMLCSC,U,1)="HS" D  Q:ZTSTOP=1
 .F IC=1:1:NHL D
 ..S HLOCIEN=$P(PXRMLCHL(IC),U,2)
 ..S NAM=$P(^SC(HLOCIEN,0),U,1)
 ..D SC
 ;If selected clinics
 I $P(PXRMLCSC,U,1)="CS" D
 .F IC=1:1:NCS D  Q:ZTSTOP=1
 ..S CLINIEN=$P(PXRMCS(IC),U,2)
 ..S NAM=$P(^DIC(40.7,CLINIEN,0),U)_" "_$P(PXRMCS(IC),U,3)
 ..S HLOCIEN=0
 ..;Get all Locations for this CLINIC STOP
 ..F  S HLOCIEN=$O(^SC(HLOCIEN)) Q:'HLOCIEN  D
 ...;Get appointments for the location
 ...I $P(^SC(HLOCIEN,0),U,7)=CLINIEN D SC
 ;If selected clinic groups
 I $P(PXRMLCSC,U,1)="GS" D
 .F IC=1:1:NCGRP D  Q:ZTSTOP=1
 ..S CGRPIEN=$P(PXRMCGRP(IC),U)
 ..S HLOCIEN=0
 ..;Get all Locations for this CLINIC GROUP
 ..F  S HLOCIEN=$O(^SC(HLOCIEN)) Q:'HLOCIEN  D
 ...S NAM=$P(^SC(HLOCIEN,0),U,1)
 ...;Get appointments for the location
 ...I $P(^SC(HLOCIEN,0),U,31)=CGRPIEN D SC
 Q
 ;
 ;Appointments for date amd location selected
SC N FIRST
 S BD=PXRMBDT-.0001,ED=PXRMEDT+.2359,FIRST=1
 F  S BD=$O(^SC(HLOCIEN,"S",BD)) Q:(BD>ED)!(BD="")  D
 .I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) D SPIN^PXRMXBSY("Sorting appointments",.BUSY)
 .S II=0
 .F  S II=$O(^SC(HLOCIEN,"S",BD,1,II)) Q:+II=0  D  Q:ZTSTOP=1
 ..;End task requested
 ..I $$S^%ZTLOAD S ZTSTOP=1 Q
 ..;Ignore cancelled/rescheduled appointments
 ..I $P(^SC(HLOCIEN,"S",BD,1,II,0),U,9)="C" Q
 ..S DFN=$P(^SC(HLOCIEN,"S",BD,1,II,0),U,1)
 ..;Mark location/clinic stop as matched
 ..I $E(PXRMLCSC,1,2)="HS" S $P(PXRMLCHL(IC),U,5)="M"
 ..I $E(PXRMLCSC,1,2)="CS" S $P(PXRMCS(IC),U,5)="M"
 ..I $E(PXRMLCSC,1,2)="GS" S $P(PXRMCGRP(IC),U,5)="M"
 ..;Build patient list
 ..S FACILITY=$P(^SC(HLOCIEN,0),U,4)
 ..I FACILITY="" S FACILITY=+$P($$SITE^VASITE,U,3)
 ..Q:FACILITY=""  Q:'$D(PXRMFACN(FACILITY))
 ..I $E(PXRMLCSC,2)="S",FIRST D MARK S FIRST=0
 ..I $E(PXRMLCSC)="C" D TMP(CLINIEN)
 ..I $E(PXRMLCSC)="G" D TMP(CGRPIEN)
 ..I $E(PXRMLCSC)="H" D TMP(HLOCIEN)
 Q
