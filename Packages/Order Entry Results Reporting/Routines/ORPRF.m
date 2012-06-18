ORPRF ;SLC/JLI-Patient record flag ;2/28/03
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**173,187,190**;Dec 17, 1997
 ;
 ; ^TMP("ORPRF",$J,NN) store the flag array.
 ;
FMT(ROOT) ; Convert record flag data to displayable data
 N IDX,IX,CNT
 S (IDX,IX,CNT)=0
 F  S IDX=$O(ROOT(IDX)) Q:'IDX  D
 . S ^TMP("ORPRF",$J,IDX,"FLAG")=$P($G(ROOT(IDX,"FLAG")),U,2)
 . S ^TMP("ORPRF",$J,IDX,"CATEGORY")=$P($G(ROOT(IDX,"CATEGORY")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Flag Name:               "_$P($G(ROOT(IDX,"FLAG")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Flag Type:               "_$P($G(ROOT(IDX,"FLAGTYPE")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Flag Category:           "_$P($G(ROOT(IDX,"CATEGORY")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Assignment Status:       "_"Active"
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Initial Assigned Date:   "_$P($G(ROOT(IDX,"ASSIGNDT")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Approved by:             "_$P($G(ROOT(IDX,"APPRVBY")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Next Review Date:        "_$P($G(ROOT(IDX,"REVIEWDT")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Owner Site:              "_$P($G(ROOT(IDX,"OWNER")),U,2)
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Originating Site:        "_$P($G(ROOT(IDX,"ORIGSITE")),U,2)
 . Q:'$D(ROOT(IDX,"NARR"))
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="            "
 . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)="Assignment Narratives:   "
 . F  S IX=$O(ROOT(IDX,"NARR",IX)) Q:'IX  D
 . . S CNT=CNT+1,^TMP("ORPRF",$J,IDX,CNT)=$G(ROOT(IDX,"NARR",IX,0))
 K ROOT
 Q
 ;
HASFLG(ORY,PTDFN) ;If patient has record flag
 ;DBIA 3860: $$GETACT^DGPFAPI(PTDFN,.FLGDATA)
 I '$L($TEXT(GETACT^DGPFAPI)) S ORY=0 Q
 N IDY
 K ^TMP("ORPRF",$J)
 S ORY=$$GETACT^DGPFAPI(PTDFN,"PRFARR")
 Q:'ORY
 D FMT(.@("PRFARR"))
 K PRFARR
 S IDY=0 F  S IDY=$O(^TMP("ORPRF",$J,IDY)) Q:'IDY  D
 . S ORY(IDY)=IDY_U_$G(^TMP("ORPRF",$J,IDY,"FLAG"))
 Q
 ;
HASCAT1(ORY) ;If patient has Category I flag
 ;
 Q:'$D(^TMP("ORPRF",$J))
 N ID,IX,CNT,TOT S (ID,CNT,TOT)=0
 F  S ID=$O(^TMP("ORPRF",$J,ID)) Q:'ID  D
 . ;I $P($G(^TMP("ORPRF",$J,ID,"CATEGORY"))," ")'="I" Q
 . S TOT=TOT+1
 . S CNT=CNT+1
 . S ORY(CNT)="~"_ID_U_$G(^TMP("ORPRF",$J,ID,"FLAG"))
 . S IX=0 F  S IX=$O(^TMP("ORPRF",$J,ID,IX)) Q:'IX  D
 . . S CNT=CNT+1,ORY(CNT)=$G(^TMP("ORPRF",$J,ID,IX))
 S:TOT ORY(0)="TOT"_U_TOT
 Q
 ;
GETFLG(ORY,PTDFN,FLAGID) ;Return detail flag information
 I '$D(^TMP("ORPRF",$J,FLAGID)) Q
 N IX,CNT
 S (IX,CNT)=0
 F  S IX=$O(^TMP("ORPRF",$J,FLAGID,IX)) Q:'IX  D
 . S CNT=CNT+1,ORY(CNT)=$G(^TMP("ORPRF",$J,FLAGID,IX))
 Q
 ;
CLEAR(ORY) ;Clear up the temp globe
 K ^TMP("ORPRF",$J)
 Q
 ;
