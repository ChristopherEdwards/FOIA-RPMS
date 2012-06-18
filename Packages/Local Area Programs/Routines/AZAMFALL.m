BMEMFALL ;Roster Fall Offs [ 06/11/03  3:29 PM ]
 ;
 ;This routine $ORDER's through the RPMS Master File &
 ;checks for all records who's Still Active Date is not
 ;equal to the current month's Download Date.  If these
 ;patients also do not have a Fall Off Date Recorded
 ;The MEDICAID ELIGIBILITY File will be populated/updated
 ;with an ending date ONLY if one does not exist for the
 ;last entry.
 ;
 ;
START ;
 S FALLCT=0
 D AZAG ;Get Last Download Log IEN #
 D MAST
 D LOG
 D END
 Q
 ;
 ;
 ;
AZAG ; -- this sets up the device and sets the file name
 S AZALSTN="" ;Last Log IEN # for Last File processed
 S AZALSTNM="" ;Actual File Name in Log
 S AZALSTN=$P($G(^AZAMEDLG(0)),U,3)
 I AZALSTN="" W !,"No Date Exists on Last Download Run",! G END
 S LOGDT=$P($G(^AZAMEDLG(AZALSTN,0)),U,2) ;Run Stop Date
 S LOGDT=$P(LOGDT,".",1) ;Strip Time off Date
 ;S AZALSTNM=$P($G(^AZAMEDLG(AZALSTN,0)),U,8)
 ;I AZALSTNM="" W !!,"Last File Name does NOT exist in Log.  Contact Site Manager!" S AZAERROR=1 Q
 S AZAMSTDT=$P($G(^AZAMEDLG(AZALSTN,0)),U,1) ;START DT/TIME
 Q:'$G(AZAMSTDT)
 S AZAMSTDT=$P(AZAMSTDT,".",1) ;Strip Time off Start Date
 Q:AZAMSTDT'=LOGDT ;Quite if Start and Stop Date do not match
 ;
 ;
 Q
 ;
 ;
 ;
MAST ;Begin $O through RPMS Master File ^AZAMASTR(
 S MASIEN=0 F  S MASIEN=$O(^AZAMASTR(MASIEN)) Q:'MASIEN  D
 . S RECORD=^AZAMASTR(MASIEN,0)
 . S STILLDT=$P(RECORD,U,4) ;Still Eligible Date
 . Q:'STILLDT
 . S DFN=$P(RECORD,U,1) ;Patient DFN #
 . Q:'DFN
 . S FALLDT=$P(RECORD,U,5) ; Fall Off Date
 . Q:FALLDT'=""  ;Quit if a Fall Date already exists
 . S LSTENDT=$P(RECORD,U,6) ;Last Roster End Date
 . S LSTENDT=$S(LSTENDT'="":LSTENDT,1:DT) ;If No Roster End Date - End with Todays Date
 . I STILLDT'=LOGDT  D MED
 ;
 ;
MED ; -- add eligiblity date(s)/data
 S IEN=$O(^AUPNMCD("B",DFN,0)) Q:'IEN
 Q:'$D(^AUPNMCD(IEN,11,0))  ;Quit if Multiple Zero Node does not exist
 S LSTEBD=$P($G(^AUPNMCD(IEN,11,0)),U,3) ;Last Beg Date IEN entered
 I LSTEBD'="" D
 . S SENDDT=$P($G(^AUPNMCD(IEN,11,LSTEBD,0)),U,2) ;End Date
 . I SENDDT="" S DR=".02///"_LSTENDT S DIE="^AUPNMCD("_IEN_",11,",DA(1)=IEN,DA=LSTEBD D ^DIE K DIE,DR,DA,DINUM D FALL^AZAMSTR S FALLCT=FALLCT+1
 Q
 ;
 ;
LOG ;Populate Download Run Log with # of Fall Off's
 ;
 Q:AZALSTN=""
 Q:FALLCT<0
 S DIE="^AZAMEDLG(",DA=AZALSTN,DR="2////"_FALLCT
 D ^DIE K DIE,DA,DR
 Q
 ;
 ;
END ;End of Run
 K AZALSTN,AZALSTNM,LOGDT,MASIEN,RECORD,STILLDT,DFN,FALLDT,LSTEBD,SENDDT,FALLCT
 Q
