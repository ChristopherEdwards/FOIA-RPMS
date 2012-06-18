AZANSTR ;Master Routine Population [ 02/03/03  11:55 AM ]
 ;
 ;
 ;This Routine Populates the Master List and is called from AZAMED
 ;If Patient is added 1st time to MEDICAID ELIGIBLE FILE, then Patient
 ;is also added 1st time to AZA MEDICAID MASTER LIST File
 ;
 ;If Patient already Exists in MEDICAID ELIGIBLE File AND a
 ;Updated Date is entered into the Eligibility Dt Multiple
 ;then the Patient Record already exists in this file and only
 ;the Updated Date & Still Eligible Date fields are populated
 ;
 ;
 ;The FALL Line Tag is Only called from AZAMFALL Routine
 ;Only if an Ending Date has been added to an existing
 ;Beginning Elig Date in Medicaid Elig. File
 ;
 ;Adding New Patients to Master List-Called from NEW^AZAMED
NEW ; -- create new entry in AZA MEDICAID MASTER LIST File ^AZAMSTR(
 Q:$O(^AZAMSTR("B",+DFN,0))  ;Quit if already in Master List
 D ^XBFMK K DIADD,DINUM
 S X=DFN,DIC="^AZAMASTR(",DIC(0)="L",DLAYGO=1180007
 S DIC("DR")=".02////"_DT_";.06////"_EED ;New Add DT - Triggers  Still Elig. DT
 D FILE^DICN S IEN=+Y D ^XBFMK K DIADD,DINUM
 Q
 ;
UPDATES ;Edit Existing AZA MEDICAID MASTR LIST Entries
 ;Called from MED^AZAMED -Update Dates - Still Eligible Dates
 S IEN=$O(^AZAMASTR("B",DFN,0)) D:'IEN NEW ;Add Record to Master File if not there
 S IEN=$O(^AZAMASTR("B",DFN,0)) Q:'IEN  ;Quit if still not in Master
 S DIE="^AZAMASTR(",DA=IEN,DR=".03////"_DT_";.06////"_EED
 D ^DIE K DIE,DR,DA
 ;
 Q
 ;
STILLACT ;Still Active Tags ONLY - No Adds/No Updates - Fall throughs
 ;Called from MED^AZAMED -Update Dates - Still Eligible Dates
 S IEN=$O(^AZAMASTR("B",DFN,0)) D:'IEN NEW  ;Add Record to Master if missing
 S IEN=$O(^AZAMASTR("B",DFN,0)) Q:'IEN  ;Quit if still not in Master
 S DIE="^AZAMASTR(",DA=IEN,DR=".04////"_DT_";.06////"_EED
 D ^DIE K DIE,DR,DA
 ;
 Q
 ;
FALL ;Fall Off Date 
 ;Called from ^AZAMFALL - If Ending Date is added to Medicaid Eligible File
 Q:'$D(^AZAMASTR(MASIEN,0))  ;Quit if still not in Master
 S DIE="^AZAMASTR(",DA=MASIEN,DR=".05////"_DT
 D ^DIE K DIE,DR,DA
 ;
 Q
