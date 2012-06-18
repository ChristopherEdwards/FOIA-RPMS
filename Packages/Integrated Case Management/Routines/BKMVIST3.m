BKMVIST3 ;PRXM/HC/BHS - Save 90459 data to V-Files and 90451.1 ; 08 Jul 2005  1:17 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;PRXM/HC/BHS - 04/12/2006 - Removed HMS* tags related to File 90451.1
 ;                            which was removed September 2005 as v-file data
 ;                            is always filed to PCC rather than in HMS as well.
 ;                            
 ; Update PCC, V-Files, Visit File, using HMS
 Q
 ;
RAD(DFN,VISIT,DATABASE) ; EP - File Radiology visit data from File 90459
 ; Input variables:
 ;  DFN - IEN for Patient
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Output variables: n/a
 ; Initialize
 N RADDATE,RADTYPE,RADCPT,ERFLAG,DA,DA0,DA1,IENS,RAD,RADABN,VISITDT,BKMTMP
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Radiology subfiles
 S RAD=""
 F  S RAD=$O(^BKM(90459,DA1,21,"B",RAD)) Q:RAD=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,21,"B",RAD,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S IENS=$$IENS^DILF(.DA)
 . . S RADDATE=RAD
 . . Q:RADDATE=""
 . . S RADTYPE=$$GET1^DIQ(90459.2121,IENS,.02,"I")
 . . Q:RADTYPE=""
 . . S RADABN=$$GET1^DIQ(90459.2121,IENS,.05,"I")
 . . ;PRXM/HC/BHS - 09/28/2005 - Abnormal/Normal flag not required for the PCC API
 . . ;Q:RADABN=""
 . . ; Following field is a 'computed' field in the V RAD file, so compute it for display purposes.
 . . ; Field might be stored in the intermediate file but it is never used.
 . . S RADCPT=$$GET1^DIQ(71,RADTYPE,9,"E")
 . . ; Add V-File Entry
 . . S VISITDT=$P(RAD,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Radiology V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("RAD",DFN,VISIT,RADTYPE,RADABN,RADDATE,"[APCDALVR 9000010.22 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELRAD ; EP - Delete 90459.2121 Radiology subfiles
 ; Input variables:  n/a
 ; Output variables: n/a
 ; Initialize
 N DA,DA1,DA0,DIK,RAD
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Radiology subfiles
 S RAD=""
 F  S RAD=$O(^BKM(90459,DA1,21,"B",RAD)) Q:RAD=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,21,"B",RAD,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",21,"
 . . D ^DIK
 Q
 ;
PRC(DFN,VISIT,DATABASE) ; EP - File Procedure Visit data from File 90459
 ; Input variables:
 ;  DFN - IEN for Patient
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Output variables: n/a
 ; Initialize
 N PRCDATE,PRCDT,PRCTYPE,PRCNAR,ERFLAG,DA,DA0,DA1,IENS,VISITDT,BKMTMP
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Procedure subfiles
 S PRCDT=""
 F  S PRCDT=$O(^BKM(90459,DA1,20,"B",PRCDT)) Q:PRCDT=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,20,"B",PRCDT,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S IENS=$$IENS^DILF(.DA)
 . . S PRCDATE=PRCDT
 . . Q:PRCDATE=""
 . . S PRCTYPE=$$GET1^DIQ(90459.22222,IENS,.02,"I")
 . . Q:PRCTYPE=""
 . . S PRCNAR=$$GET1^DIQ(90459.22222,IENS,.04,"E")
 . . ; Add V-File entry
 . . S VISITDT=$P(PRCDT,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Procedure V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("PRC",DFN,VISIT,PRCTYPE,PRCNAR,PRCDATE,"[APCDALVR 9000010.08 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELPRC ; EP - Delete 90459.2020 Procedure subfiles
 ; Input variables:  n/a
 ; Output variables: n/a
 ; Initialize
 N DA,DA1,DA0,DIK,PRC
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Procedure subfiles
 S PRC=""
 F  S PRC=$O(^BKM(90459,DA1,20,"B",PRC)) Q:PRC=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,20,"B",PRC,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",20,"
 . . D ^DIK
 Q
 ;
SKIN(DFN,VISIT,DATABASE) ; EP - File Skin Visit data stored in File 90459
 ; Input variables:
 ;  DFN - IEN for Patient
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Output variables: n/a
 ; Initialize
 N APCDADD,ERFLAG,DA,TIENS,DA1,DA0,SDATE,SKINDT,SREADG,SREADR,BKMTMP
 N STYPE,SVALUE,VISITDT
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Skin Test subfiles
 S SKINDT=""
 F  S SKINDT=$O(^BKM(90459,DA1,22,"B",SKINDT)) Q:SKINDT=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,22,"B",SKINDT,DA0)) Q:DA0=""  D
 . . S SDATE=SKINDT
 . . S DA=DA0,DA(1)=DA1
 . . S TIENS=$$IENS^DILF(.DA)
 . . S SVALUE=$$GET1^DIQ(90459.2222,TIENS,.04,"I")
 . . ;Q:SVALUE=""
 . . S STYPE=$$GET1^DIQ(90459.2222,TIENS,.02,"I")
 . . ;Q:STYPE=""
 . . S SREADG=$$GET1^DIQ(90459.2222,TIENS,.05,"I")
 . . S SREADR=$$GET1^DIQ(90459.2222,TIENS,.08,"I")
 . . ; Add V-File entry
 . . S VISITDT=$P(SKINDT,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Skin Test V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("SKIN",DFN,VISIT,STYPE,TIENS,SDATE,"[APCDALVR 9000010.12 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELSKIN ; EP - Delete 90459.2222 Skin subfiles
 ; Input variables:  n/a
 ; Output variables: n/a
 ; Initialize
 N DA,DA1,DA0,DIK,SKN
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Skin subfiles
 S SKN=""
 F  S SKN=$O(^BKM(90459,DA1,22,"B",SKN)) Q:SKN=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,22,"B",SKN,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",22,"
 . . D ^DIK
 Q
 ;
ELDER(DFN,VISIT,DATABASE) ; EP - File Elder Visit data from File 90459
 ; Input variables:
 ;  DFN - IEN for Patient
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Output variables: n/a
 ; Initialize
 N APCDALVR,DA,DA0,DA1,DATEOFR,ELDER,IENST,ELDDT,BKMTMP
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Elder subfiles
 S ELDER=""
 F  S ELDER=$O(^BKM(90459,DA1,16,"B",ELDER)) Q:ELDER=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,16,"B",ELDER,DA0)) Q:DA0=""  D
 . . S DA(1)=DA1,DA=DA0
 . . S IENST=$$IENS^DILF(.DA)
 . . S ELDDT=ELDER
 . . ; Add V-File entry
 . . S VISITDT=$P(ELDDT,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Elder V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("ELDER",DFN,VISIT,"IHS-1-865",IENST,ELDDT,"[APCDALVR 9000010.35 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELELDER ; EP - Delete 90459.1616 Elder subfiles
 ; Input variables:  n/a
 ; Output variables: n/a
 N DA,DA1,DA0,DIK,ELDER
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Elder subfiles
 S ELDER=""
 F  S ELDER=$O(^BKM(90459,DA1,16,"B",ELDER)) Q:ELDER=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,16,"B",ELDER,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",16,"
 . . D ^DIK
 Q
 ;
 ;
