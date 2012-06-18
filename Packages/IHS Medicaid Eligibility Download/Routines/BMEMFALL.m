BMEMFALL ; IHS/PHXAO/TMJ - Roster Fall Offs ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
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
 S BMEFCNT=0
 D GETLOG ;Get Last Download Log IEN #
 D MAST
 D LOG
 D END
 Q
 ;
 ;
 ;
GETLOG ; -- this sets up the device and sets the file name
 S BMELSTN="" ;Last Log IEN # for Last File processed
 S BMELSTNM="" ;Actual File Name in Log
 S BMELSTN=$P($G(^BMEMLOG(0)),U,3)
 I BMELSTN="" W !,"No Date Exists on Last Download Run",! G END
 S BMELOGDT=$P($G(^BMEMLOG(BMELSTN,0)),U,2) ;Run Stop Date
 S BMELOGDT=$P(BMELOGDT,".",1) ;Strip Time off Date
 ;S BMELSTNM=$P($G(^BMEMLOG(BMELSTN,0)),U,8)
 ;I BMELSTNM="" W !!,"Last File Name does NOT exist in Log.  Contact Site Manager!" S BMEERROR=1 Q
 S BMEMSTDT=$P($G(^BMEMLOG(BMELSTN,0)),U,1) ;START DT/TIME
 Q:'$G(BMEMSTDT)
 S BMEMSTDT=$P(BMEMSTDT,".",1) ;Strip Time off Start Date
 Q:BMEMSTDT'=BMELOGDT  ;Quit if Start and Stop Date do not match
 ;
 ;
 Q
 ;
 ;
 ;
MAST ;Begin $O through RPMS Master File ^BMEMASTR(
 S BMEMAIEN=0 F  S BMEMAIEN=$O(^BMEMASTR(BMEMAIEN)) Q:'BMEMAIEN  D
 . S BMEMREC=^BMEMASTR(BMEMAIEN,0)
 . S BMESTILL=$P(BMEMREC,U,4) ;Still Eligible Date
 . Q:'BMESTILL
 . S DFN=$P(BMEMREC,U,1) ;Patient DFN #
 . Q:'DFN
 . S BMEFALL=$P(BMEMREC,U,5) ; Fall Off Date
 . Q:BMEFALL'=""  ;Quit if a Fall Date already exists
 . S BMELSTDT=$P(BMEMREC,U,6) ;Last Roster End Date
 . S BMELSTDT=$S(BMELSTDT'="":BMELSTDT,1:DT) ;If No Roster End Date - End with Todays Date
 . I BMESTILL'=BMELOGDT  D MED
 ;
 ;
MED ; -- add eligiblity date(s)/data
 S IEN=$O(^AUPNMCD("B",DFN,0)) Q:'IEN
 Q:'$D(^AUPNMCD(IEN,11,0))  ;Quit if Multiple Zero Node does not exist
 S BMELEBD=$P($G(^AUPNMCD(IEN,11,0)),U,3) ;Last Beg Date IEN entered
 I BMELEBD'="" D
 . S BMELEED=$P($G(^AUPNMCD(IEN,11,BMELEBD,0)),U,2) ;End Date
 . I BMELEED="" S DR=".02///"_BMELSTDT S DIE="^AUPNMCD("_IEN_",11,",DA(1)=IEN,DA=BMELEBD D ^DIE K DIE,DR,DA,DINUM D FALL^BMEMSTR S BMEFCNT=BMEFCNT+1
 Q
 ;
 ;
LOG ;Populate Download Run Log with # of Fall Off's
 ;
 Q:BMELSTN=""
 Q:BMEFCNT<0
 S DIE="^BMEMLOG(",DA=BMELSTN,DR="2////"_BMEFCNT
 D ^DIE K DIE,DA,DR
 Q
 ;
 ;
END ;End of Run
 K BMELSTN,BMELSTNM,BMELOGDT,BMEMAIEN,BMEMREC,BMESTILL,DFN,BMEFALL,BMELEBD,BMELEED,BMEFCNT
 Q
