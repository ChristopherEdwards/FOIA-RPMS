BQIPLCP ;PRXM/HC/KJH-Copy Panel Functions ; 2 Feb 2006  4:05 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,OPLIEN,NPLNM,LYOUT) ; EP - BQI COPY PANEL
 ; Description
 ;   Creates a copy of the original panel specified by OWNR and PLIEN
 ;   under the current user (DUZ). All data is copied, except that the
 ;   new panel name will be "Copy of "_OldPanelName if this is the first
 ;   copy or "Copy (n) of "_OldPanelName if this is a subsequent copy.
 ;
 ;   All data is copied from the original panel except the panel creation
 ;   date/time (which is set to NOW). If the panel OWNR and the DUZ are
 ;   different then the shared access information will also not be copied.
 ; Input:
 ;   OWNR   - Owner of the panel
 ;   OPLIEN - Original panel IEN
 ;   NPLNM  - New panel name
 ;   LYOUT  - Flag to indicate whether to copy the layouts as well
 ; Output:
 ;   DATA   = name of global (passed by reference) in which the data is stored
 ;
 ;   PLIEN  - panel IEN (for the new panel)
 ;   PLID   - panel ID (DUZ of new owner and panel ien)
 ;   PLNM   - panel name (new panel name)
 ; or
 ;   BMXSEC - if record can't be locked or if $D(ERROR)
 ;            when filing or M error encountered
 ;            
 NEW UID,X,BQII
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLCP",UID))
 K ^TMP("BQIPLCP",UID)
 S LYOUT=$S($G(LYOUT)="Y":1,1:0)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLCP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create owner (DUZ) if new to iCare - If unable to do so - error
 I '$$OWNR^BQIPLUSR(DUZ) S BMXSEC="Unable to create panel" Q
 ;
 ; Create header record
 S BQII=0,^TMP("BQIPLCP",UID,BQII)="I00010PANEL_IEN^T00020PANEL_ID^T00120PANEL_NAME"_$C(30)
 ;
 N DA,DIK,OIENS,IENS,BQINEW,ERROR,OPLNM,SRCTYP
 ;
 ; Get panel name from 'original' panel
 S DA=OPLIEN,DA(1)=OWNR,OIENS=$$IENS^DILF(.DA)
 S OPLNM=$$GET1^DIQ(90505.01,OIENS,".01","I")
 ;
 ; Create a new panel and name
 D FILE I $G(BMXSEC)]"" Q
 ;
 ; Copy PANEL DEFINITION (0 node)
 M ^BQICARE(DUZ,1,PLIEN,0)=^BQICARE(OWNR,1,OPLIEN,0)
 ;
 ; Update panel name, creation date/time, last updated by
 ; and updated date/time for 'new' panel
 S DA(1)=DUZ,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 S BQINEW(90505.01,IENS,.01)=PLNM
 I $$GET1^DIQ(90505.01,IENS,.02,"I")="" S BQINEW(90505.01,IENS,.02)=$$NOW^XLFDT()
 S BQINEW(90505.01,IENS,.04)=DUZ
 S BQINEW(90505.01,IENS,.05)=$$NOW^XLFDT()
 D FILE^DIE("","BQINEW","ERROR")
 ;
 ; If an error occurred, remove the half-filed panel and return BMXSEC.
 I $D(ERROR) D  Q
 . S DIK="^BQICARE("_DA(1)_",1,"
 . D ^DIK
 . S BMXSEC="Error encountered while copying panel definition."
 . Q
 ;
 ;  Copy data
 D CPY(OWNR,OPLIEN,PLIEN)
 ;
 ;  Check type of panel if moving a share
 I OWNR'=DUZ D
 . NEW DA,IENS
 . S DA(1)=DUZ,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 . S SRCTYP=$$GET1^DIQ(90505.01,IENS,.03,"I")
 . I SRCTYP'="Y" Q
 . S BQIUPD(90505.01,IENS,.03)="M"
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD
 . K DESC
 . D PEN^BQIPLDSC(DUZ,PLIEN,.DESC)
 . D WP^DIE(90505.01,IENS,5,"","DESC")
 . K DESC
 . NEW DFN
 . S DFN=0
 . F  S DFN=$O(^BQICARE(DUZ,1,PLIEN,40,DFN)) Q:'DFN  D
 .. I $P(^BQICARE(DUZ,1,PLIEN,40,DFN,0),U,2)'="" Q
 .. S $P(^BQICARE(DUZ,1,PLIEN,40,DFN,0),U,2)="A"
 .. S $P(^BQICARE(DUZ,1,PLIEN,40,DFN,0),U,4)=$$NOW^XLFDT()
 ;
 ; if user selected to copy the layout
 I LYOUT D LAY(OWNR,OPLIEN,PLIEN)
 ;
 ; Return panel IEN, ID, and NAME on success
 S PLID=$$PLID^BQIUG1(DUZ,PLIEN)
 S BQII=BQII+1,^TMP("BQIPLCP",UID,BQII)=PLIEN_"^"_PLID_"^"_PLNM_$C(30)
 S BQII=BQII+1,^TMP("BQIPLCP",UID,BQII)=$C(31)
 K PLID,PLNM
 Q
 ;
FILE ; Create name and file new panel under current DUZ
 L +^BQICARE(DUZ,1,0):5
 ; NOTE: It is possible that the lock should be extended around the whole copy procedure.
 ;       Potential problem is that the panel could become available to a shared user during
 ;       the IX^DIK process but before the panel x-ref completes. This is a very small
 ;       period of time, but should still be tested.
 I '$T S BMXSEC="Unable to create panel" Q  ; Error - unable to assign next panel IEN
 D
 . ; First try to create a new name for the panel using "Copy of "_OldName.
 . N DA,PIENS,ERROR,II
 . S PLNM=$S($G(NPLNM)'="":NPLNM,1:"Copy of "_OPLNM)
 . S DA(1)=DUZ,DA=""
 . S PIENS=$$IENS^DILF(.DA)
 . I $$FIND1^DIC(90505.01,PIENS,"X",PLNM,"","","ERROR")=0 Q  ; New panel name not currently in use.
 . ; Otherwise create a new name for the panel using "Copy (n) of "_OldName.
 . F II=1:1 D  I PLNM]"" Q
 .. N DA,PIENS,ERROR
 .. S PLNM="Copy ("_II_") of "_OPLNM
 .. S DA(1)=DUZ,DA=""
 .. S PIENS=$$IENS^DILF(.DA)
 .. I $$FIND1^DIC(90505.01,PIENS,"X",PLNM,"","","ERROR")=0 Q  ; New panel name not currently in use.
 .. S PLNM="" ; Clear panel name if currently in use
 . Q
 ; File new panel
 N DA,X,DINUM,DIC,DIE,DLAYGO
 S DA(1)=DUZ,X=PLNM,DLAYGO=90505.01
 S DIC="^BQICARE("_DA(1)_",1,",DIE=DIC
 S DIC(0)="L",DIC("P")=DLAYGO
 K DO,DD D FILE^DICN
 S (DA,PLIEN)=+Y
 I PLIEN=-1 S BMXSEC="Error encountered while filing panel."
 L -^BQICARE(DUZ,1,0)
 Q
 ;
ERR ;
 L -^BQICARE(DUZ,1,0)
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
 ;
CPY(OWNR,OPLIEN,PLIEN) ;EP -- Copy data from one panel to another
 ; Input
 ;   OWNR   - Owner of panel
 ;   OPLIEN - Original panel IEN
 ;   PLIEN  - New panel IEN
 ;
 ; Copy PANEL DEFINITION (remaining nodes)
 ;
 I $D(^BQICARE(OWNR,1,OPLIEN,3)) M ^BQICARE(DUZ,1,PLIEN,3)=^BQICARE(OWNR,1,OPLIEN,3)
 I $D(^BQICARE(OWNR,1,OPLIEN,5)) M ^BQICARE(DUZ,1,PLIEN,5)=^BQICARE(OWNR,1,OPLIEN,5)
 ;
 ; Copy PARAMETER DEFINITION
 I $D(^BQICARE(OWNR,1,OPLIEN,10)) M ^BQICARE(DUZ,1,PLIEN,10)=^BQICARE(OWNR,1,OPLIEN,10)
 ;
 ; Copy FILTER DEFINITION
 I $D(^BQICARE(OWNR,1,OPLIEN,15)) M ^BQICARE(DUZ,1,PLIEN,15)=^BQICARE(OWNR,1,OPLIEN,15)
 ;
 ; Copy PATIENT LIST
 I $D(^BQICARE(OWNR,1,OPLIEN,40)) M ^BQICARE(DUZ,1,PLIEN,40)=^BQICARE(OWNR,1,OPLIEN,40)
 ;
 ; Update cross references for merged entries
 S DIK="^BQICARE("_DA(1)_",1,"
 D IX^DIK
 Q
 ;
LAY(OWNR,OPLIEN,PLIEN) ;EP - Copy the layouts
 NEW LYI,TMPLNM,DIK,DA,TMIEN,TMTYP
 ;
 ; if the user is the owner
 ; 
 I OWNR=DUZ D
 . M ^BQICARE(DUZ,1,PLIEN,4)=^BQICARE(OWNR,1,OPLIEN,4)    ;Template References
 . M ^BQICARE(DUZ,1,PLIEN,20)=^BQICARE(OWNR,1,OPLIEN,20)  ;Patient Layout
 . M ^BQICARE(DUZ,1,PLIEN,22)=^BQICARE(OWNR,1,OPLIEN,22)  ;Reminders
 . M ^BQICARE(DUZ,1,PLIEN,25)=^BQICARE(OWNR,1,OPLIEN,25)  ;Nat'l Meas
 . M ^BQICARE(DUZ,1,PLIEN,23)=^BQICARE(OWNR,1,OPLIEN,23)  ;Care Mgmt Layouts (Asthma and HIV/AIDS)
 ;
 ; if the user is not the owner, create customized
 I OWNR'=DUZ D
 . M ^BQICARE(DUZ,1,PLIEN,4)=^BQICARE(OWNR,1,OPLIEN,30,DUZ,4)
 . S $P(^BQICARE(DUZ,1,PLIEN,4,0),U,2)="90505.14"
 . M ^BQICARE(DUZ,1,PLIEN,20)=^BQICARE(OWNR,1,OPLIEN,30,DUZ,20)
 . S $P(^BQICARE(DUZ,1,PLIEN,20,0),U,2)="90505.05P"
 . M ^BQICARE(DUZ,1,PLIEN,22)=^BQICARE(OWNR,1,OPLIEN,30,DUZ,22)
 . S $P(^BQICARE(DUZ,1,PLIEN,22,0),U,2)="90505.122"
 . M ^BQICARE(DUZ,1,PLIEN,23)=^BQICARE(OWNR,1,OPLIEN,30,DUZ,23)
 . S $P(^BQICARE(DUZ,1,PLIEN,23,0),U,2)="90505.123"
 . N I S I=0 F  S I=$O(^BQICARE(DUZ,1,PLIEN,23,I)) Q:'I  S $P(^BQICARE(DUZ,1,PLIEN,23,I,1,0),U,2)="90505.1231"
 . M ^BQICARE(DUZ,1,PLIEN,25)=^BQICARE(OWNR,1,OPLIEN,30,DUZ,25)
 . S $P(^BQICARE(DUZ,1,PLIEN,25,0),U,2)="90505.125"
 ;
 ; Update cross references for merged entries
 S DIK="^BQICARE(",DA=DUZ
 D IX^DIK
 Q
