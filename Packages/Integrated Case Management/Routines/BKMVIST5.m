BKMVIST5 ;PRXM/HC/JGH - Save 90459 data to V-Files and 90451.1 ; 10 Jun 2005  4:05 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; Update PCC, V-Files, Visit File, using HMS
 Q
IMMUN(DFN,VISIT,DATABASE) ; EP - File Immun Visit data from File 90459
 ; Input vars:
 ;  DFN - Pat IEN
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Output vars: n/a
 ; Init
 N APCDADD,DA1,DA0,DA,IIENS,ERFLAG,LOT,REACT,SERIES,TYPE,VISITDT,BKMTMP
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Immun subfiles
 S IMMUN=""
 F  S IMMUN=$O(^BKM(90459,DA1,23,"B",IMMUN)) Q:IMMUN=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,23,"B",IMMUN,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S IIENS=$$IENS^DILF(.DA)
 . . S TYPE=$$GET1^DIQ(90459.2323,IIENS,.015,"I")
 . . Q:TYPE=""
 . . S SERIES=$$GET1^DIQ(90459.2323,IIENS,.04,"I")
 . . S LOT=$$GET1^DIQ(90459.2323,IIENS,.05,"I")
 . . S REACT=$$GET1^DIQ(90459.2323,IIENS,.06,"I")
 . . ; Add V-File entry
 . . S VISITDT=$P(IMMUN,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Immun V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("IMMUN",DFN,VISIT,TYPE,IIENS,IMMUN,"[APCDALVR 9000010.11 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELIMMUN ; EP - Delete 90459.2323 Immun subfiles
 ; Input vars:  n/a
 ; Output vars: n/a
 ; Init
 N IMMUN,DA,DA0,DA1,DIK
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Immun subfiles
 S IMMUN=""
 F  S IMMUN=$O(^BKM(90459,DA1,23,"B",IMMUN)) Q:IMMUN=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,23,"B",IMMUN,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",23,"
 . . D ^DIK
 Q
 ;
LAB(DFN,VISIT,DATABASE)   ; EP - File Lab Visit data from File 90459
 ; Input vars:
 ;  DFN - Pat IEN
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Output vars: n/a
 ; Init
 N DA,DA0,DA1,LABDT,LABDATE,LABTYPE,LIENS,ERFLAG,BKMTMP
 N LABLOW,LABRESL,LABUNIT,VISITDT,LABHIGH
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Lab subfiles
 S LABDT=""
 F  S LABDT=$O(^BKM(90459,DA1,13,"B",LABDT)) Q:LABDT=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,13,"B",LABDT,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S LIENS=$$IENS^DILF(.DA)
 . . S LABDATE=LABDT
 . . S LABTYPE=$$GET1^DIQ(90459.1313,LIENS,.02,"I")
 . . Q:LABTYPE?." "
 . . S LABRESL=$$GET1^DIQ(90459.1313,LIENS,.03,"I")
 . . S LABUNIT=$$GET1^DIQ(90459.1313,LIENS,1101,"I")
 . . S LABLOW=$$GET1^DIQ(90459.1313,LIENS,1104,"I")
 . . S LABHIGH=$$GET1^DIQ(90459.1313,LIENS,1105,"I")
 . . ; Add V-File entry
 . . S VISITDT=$P(LABDT,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Lab V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("LAB",DFN,VISIT,LABTYPE,LIENS,LABDATE,"[APCDALVR 9000010.09 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELLAB ; EP - Delete 90459.1313 Lab subfiles
 ; Input vars:  n/a
 ; Output vars: n/a
 ; Init
 N DA,DA1,DA0,DIK,LAB
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Lab subfiles
 S LAB=""
 F  S LAB=$O(^BKM(90459,DA1,13,"B",LAB)) Q:LAB=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,13,"B",LAB,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",13,"
 . . D ^DIK
 Q
 ;
MED(DFN,VISIT,DATABASE) ; EP - File Med Visit data from File 90459
 ; Input vars:
 ;  DFN - Pat IEN
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Output vars: n/a
 ; Init
 N APCDADD,DA,DA1,DA0,MED,MEDTYPE,MEDDATE,MEDTYPE,X,G,ERFLAG,BKMTMP
 N MEDDAYS,MEDDT,MEDQTY,MEDSIQ,MIENS,MSRDATE,MSRTYPE,MSRVALUE,VISITDT
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Med subfiles
 S MEDDT=""
 F  S MEDDT=$O(^BKM(90459,DA1,14,"B",MEDDT)) Q:MEDDT=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,14,"B",MEDDT,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S MIENS=$$IENS^DILF(.DA)
 . . S MEDDATE=MEDDT
 . . S MEDTYPE=$$GET1^DIQ(90459.1414,MIENS,.02,"I")
 . . Q:MEDTYPE?." "
 . . S MEDQTY=$$GET1^DIQ(90459.1414,MIENS,.03,"I")
 . . S MEDSIQ=$$GET1^DIQ(90459.1414,MIENS,.04,"I")
 . . S MEDDAYS=$$GET1^DIQ(90459.1414,MIENS,.07,"I")
 . . ; Add V-File entry
 . . S VISITDT=$P(MEDDT,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Med V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("MED",DFN,VISIT,MEDTYPE,MIENS,MEDDATE,"[APCDALVR 9000010.14 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELMED ; EP - Delete 90459.1414 Med subfiles
 ; Input vars:  n/a
 ; Output vars: n/a
 ; Init
 N DA,DA1,DA0,DIK,MED
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Med subfiles
 S MED=""
 F  S MED=$O(^BKM(90459,DA1,14,"B",MED)) Q:MED=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,14,"B",MED,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",14,"
 . . D ^DIK
 Q
 ;
XAM(DFN,VISIT,DATABASE) ; EP - File Exam Visit data from File 90459
 ; Input vars:
 ;  DFN - Pat IEN
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Init
 N APCDADD,XAMDATE,XAMTYPE,XAMVALUE,ERFLAG,DA,DA0,DA1,IENS,VISITDT,XAM,BKMTMP
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Exam subfiles
 S XAM=""
 F  S XAM=$O(^BKM(90459,DA1,17,"B",XAM)) Q:XAM=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,17,"B",XAM,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S IENS=$$IENS^DILF(.DA)
 . . S XAMDATE=XAM
 . . Q:XAMDATE=""
 . . S XAMTYPE=$$GET1^DIQ(90459.1717,IENS,.02,"I")
 . . Q:XAMTYPE=""
 . . S XAMVALUE=$$GET1^DIQ(90459.1717,IENS,.04,"I")
 . . ;PRXM/HC/BHS - Remove as field is not required to file
 . . ;Q:XAMVALUE=""
 . . ; Add V-File entry
 . . S VISITDT=$P(XAM,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Exam V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("XAM",DFN,VISIT,XAMTYPE,XAMVALUE,XAMDATE,"[APCDALVR 9000010.13 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELXAM ; EP - Delete 90459.1717 Exam subfiles
 ; Input vars:  n/a
 ; Output vars: n/a
 ; Init
 N DA,DA1,DA0,DIK,XAM
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Exam subfiles
 S XAM=""
 F  S XAM=$O(^BKM(90459,DA1,17,"B",XAM)) Q:XAM=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,17,"B",XAM,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",17,"
 . . D ^DIK
 Q
 ;
MSR(DFN,VISIT,DATABASE) ; EP - File Measurement Visit data from File 90459
 ; Input vars:
 ;  DFN - Pat IEN
 ;  VISIT - Visit ID
 ;  DATABASE - 'PCC'
 ; Init
 N APCDADD,DMSR,MSR,DA0,DA,DA1,IENS,MSRDATE,MSRVALUE,MSRTYPE,ERFLAG,VISITDT,BKMTMP
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Init
 K ^TMP("BKMVIST4 DATES",$J)
 ; Measurement subfiles
 S DMSR=""
 F  S DMSR=$O(^BKM(90459,DA1,19,"B",DMSR)) Q:DMSR=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,19,"B",DMSR,DA0)) Q:DA0=""  D
 . . S DA=DA0,DA(1)=DA1
 . . S IENS=$$IENS^DILF(.DA)
 . . S MSRVALUE=$$GET1^DIQ(90459.1919,IENS,.04,"I")
 . . S MSRDATE=DMSR
 . . S MSRTYPE=$$GET1^DIQ(90459.1919,IENS,.02,"I")
 . . I MSRVALUE?." "!(MSRDATE?." ")!(MSRTYPE?." ") Q
 . . ; Add V-File entry
 . . S VISITDT=$P(DMSR,".",1)
 . . S VISIT=$G(^TMP("BKMVIST4 DATES",$J,VISITDT))
 . . ; Create PCC Visit
 . . I VISIT="" S APCDADD=1,(^TMP("BKMVIST4 DATES",$J,VISITDT),VISIT)=$$CRVISIT3^BKMVIST4(VISITDT,DFN)
 . . I VISIT="" W !,"Unable to create PCC Visit!" S BKMTMP=$$PAUSE^BKMIXX3() Q
 . . ; File PCC Measurement V-File entry
 . . S:DATABASE="PCC" ERFLAG=$$CRVFILE2^BKMVIST4("MSR",DFN,VISIT,MSRTYPE,MSRVALUE,MSRDATE,"[APCDALVR 9000010.01 (ADD)]")
 . . I ERFLAG="" W !,"Unable to create V-File entry!" S BKMTMP=$$PAUSE^BKMIXX3()
 K ^TMP("BKMVIST4 DATES",$J)
 Q
 ;
DELMSR ; EP - Delete 90459.1919 Measurement subfiles
 ; Input vars:  n/a
 ; Output vars: n/a
 ; Init
 N DA,DA1,DA0,DIK,MSR
 ; PCC Buffer IEN
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; Measurement subfiles
 S MSR=""
 F  S MSR=$O(^BKM(90459,DA1,19,"B",MSR)) Q:MSR=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90459,DA1,19,"B",MSR,DA0)) Q:DA0=""  D
 . . K DA
 . . S DA(1)=DA1,DA=DA0
 . . ; Delete subfile
 . . S DIK="^BKM(90459,"_DA(1)_",19,"
 . . D ^DIK
 Q
 ;
 ;
