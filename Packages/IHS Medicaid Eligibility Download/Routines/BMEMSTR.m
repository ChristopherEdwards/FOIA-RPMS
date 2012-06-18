BMEMSTR ; IHS/PHXAO/TMJ - Master Routine Population ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;
 ;
 ;This Routine Populates the Master List and is called from BMEMED
 ;If Patient is added 1st time to MEDICAID ELIGIBLE FILE, then Patient
 ;is also added 1st time to BME MEDICAID MASTER LIST File
 ;
 ;If Patient already Exists in MEDICAID ELIGIBLE File AND a
 ;Updated Date is entered into the Eligibility Dt Multiple
 ;then the Patient Record already exists in this file and only
 ;the Updated Date & Still Eligible Date fields are populated
 ;
 ;
 ;The FALL Line Tag is Only called from BMEMFALL Routine
 ;Only if an Ending Date has been added to an existing
 ;Beginning Elig Date in Medicaid Elig. File
 ;
 ;Adding New Patients to Master List-Called from NEW^BMEMED
NEW ;EP  -- create new entry in BME MEDICAID MASTER LIST File ^BMEMSTR(
 Q:$O(^BMEMASTR("B",+DFN,0))  ;Quit if already in Master List
 D ^XBFMK K DIADD,DINUM
 S X=DFN,DIC="^BMEMASTR(",DIC(0)="L",DLAYGO=90334
 S DIC("DR")=".02////"_DT_";.06////"_BMEMEED ;New Add DT - Triggers  Still Elig. DT
 D FILE^DICN S BMEIEN=+Y D ^XBFMK K DIADD,DINUM
 Q
 ;
UPDATES ;EP - Edit Existing BME MEDICAID MASTR LIST Entries
 ;Called from MED^BMEMED -Update Dates - Still Eligible Dates
 S BMEIEN=$O(^BMEMASTR("B",DFN,0)) D:'BMEIEN NEW ;Add Record to Master File if not there
 S BMEIEN=$O(^BMEMASTR("B",DFN,0)) Q:'BMEIEN  ;Quit if still not in Master
 S DIE="^BMEMASTR(",DA=BMEIEN,DR=".03////"_DT_";.06////"_BMEMEED
 D ^DIE K DIE,DR,DA
 ;
 Q
 ;
STILLACT ;EP - Still Active Tags ONLY - No Adds/No Updates - Fall throughs
 ;Called from MED^BMEMED -Update Dates - Still Eligible Dates
 S BMEIEN=$O(^BMEMASTR("B",DFN,0)) D:'BMEIEN NEW  ;Add Record to Master if missing
 S BMEIEN=$O(^BMEMASTR("B",DFN,0)) Q:'BMEIEN  ;Quit if still not in Master
 S DIE="^BMEMASTR(",DA=BMEIEN,DR=".04////"_DT_";.06////"_BMEMEED
 D ^DIE K DIE,DR,DA
 ;
 Q
 ;
FALL ;EP - Fall Off Date 
 ;Called from ^BMEMFALL - If Ending Date is added to Medicaid Eligible File
 Q:'$D(^BMEMASTR(BMEMAIEN,0))  ;Quit if still not in Master
 S DIE="^BMEMASTR(",DA=BMEMAIEN,DR=".05////"_DT
 D ^DIE K DIE,DR,DA
 ;
 Q
