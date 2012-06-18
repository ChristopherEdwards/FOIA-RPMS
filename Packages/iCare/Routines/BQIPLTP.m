BQIPLTP ;VNGT/HC/KML-Reassign Panel Functions ; 2 Feb 2006  4:05 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,OPLIEN,NOWNR) ; EP - BQI REASSIGN PANEL
 ; Description
 ;   Transfers ownership of a panel specified by OWNR and PLIEN
 ;   under the New Owner.
 ;
 ; Input:
 ;   OWNR  - Owner of the panel (DUZ)
 ;   OPLIEN - Original panel IEN
 ;   NOWNR  - New OWNER (DUZ)
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
 N UID,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLTP",UID))
 K @DATA
 ;
 N $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLCP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I '$$KEYCHK^BQIULSC("BQIZMGR",DUZ) S BMXSEC="You do not have the security access to REASSIGN a panel."_$C(10)_"Please see your supervisor or program manager." Q
 ;
 ; Create owner (DUZ) if new to iCare - If unable to do so - error
 I '$$OWNR^BQIPLUSR(DUZ) S BMXSEC="Unable to reassign panel" Q
 ;
 N DA,DIK,OIENS,PLNM,II
 S II=0
 ; Create header record
 S @DATA@(II)="I00010RESULT^T00100MSG"_$C(30)
 ;
 S RESULT=1,MSG=""
 ; Get panel name from 'original' panel
 S DA=OPLIEN,DA(1)=OWNR,OIENS=$$IENS^DILF(.DA)
 S PLNM=$$GET1^DIQ(90505.01,OIENS,".01","I")
 I PLNM']"" S RESULT=-1,MSG="Panel Does Not Exist for Original Owner." G DONE
 ;
 D CREATE(OWNR,NOWNR,PLNM,OPLIEN,.PLIEN)  G DONE:$G(MSG)]""  ; create stub entry and 0 node of reassigned panel for new owner
 D CPY(OWNR,NOWNR,OPLIEN,PLIEN) ; copy data from remaining subscripts
 D DELPNL(OWNR,OPLIEN)  ; remove panel from previous owner
 ;
DONE ;
 S II=II+1,@DATA@(II)=RESULT_U_MSG_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CREATE(ODUZ,NDUZ,PLNM,OPIEN,NPIEN) ; create stub panel entry under new owner
 ; ODUZ = DUZ of the old owner
 ; NDUZ = DUZ of the new owner
 ; PLNM = name of panel to be reassigned
 ; OPIEN  - previous panel IEN
 ; NPIEN  - panel IEN for New Owner
 L +^BQICARE(NDUZ,1,0):5
 ; NOTE: It is possible that the lock should be extended around the whole copy procedure.
 ;       Potential problem is that the panel could become available to a shared user during
 ;       the IX^DIK process but before the panel x-ref completes. This is a very small
 ;       period of time, but should still be tested.
 I '$T S BMXSEC="Unable to create panel" Q  ; Error - unable to assign next panel IEN
 N PIENS,ERROR,II
 D
 . ; First try to create a new name for the panel using "Copy of "_OldName.
 . S DA(1)=NDUZ,DA=""
 . S PIENS=$$IENS^DILF(.DA)
 . Q:'$$FIND1^DIC(90505.01,PIENS,"X",PLNM,"","","ERROR")  ; Reassigned panel name not currently in use by new owner.
 . ; Otherwise create a new name for the panel using "Copy (n) of "_OldName.
 . F II=1:1 D  I PLNM]"" Q
 .. S PLNM="Reassigned Copy ("_II_") of "_PLNM
 .. S PIENS=$$IENS^DILF(.DA)
 .. Q:'$$FIND1^DIC(90505.01,PIENS,"X",PLNM,"","","ERROR")  ; Reassigned panel name not currently in use by new owner.
 .. S PLNM="" ; Clear panel name if currently in use
 . Q
 ; File new panel
 N X,DINUM,DIC,DIE,DLAYGO
 S DA(1)=NDUZ,X=PLNM,DLAYGO=90505.01
 S DIC="^BQICARE("_DA(1)_",1,",DIE=DIC
 S DIC(0)="L",DIC("P")=DLAYGO
 K DO,DD D FILE^DICN
 S (DA,NPIEN)=+Y
 I NPIEN=-1 S RESULT=-1,MSG="Error encountered while filing panel."
 L -^BQICARE(NDUZ,1,0)
 K DA
 Q:$G(MSG)]""
 ;
 N BQINEW
 M ^BQICARE(NDUZ,1,NPIEN,0)=^BQICARE(ODUZ,1,OPIEN,0)
 ; Update panel name, creation date/time, last updated by
 ; and updated date/time for 'new' panel
 S DA(1)=NDUZ,DA=NPIEN,PIENS=$$IENS^DILF(.DA)
 S BQINEW(90505.01,PIENS,.01)=PLNM
 I $$GET1^DIQ(90505.01,PIENS,.02,"I")="" S BQINEW(90505.01,IENS,.02)=$$NOW^XLFDT()
 S BQINEW(90505.01,PIENS,.04)=NDUZ
 S BQINEW(90505.01,PIENS,.05)=$$NOW^XLFDT()
 D FILE^DIE("","BQINEW","ERROR")
 ;
 ; If an error occurred, remove the half-filed panel and return BMXSEC.
 I $D(ERROR) D
 . S DIK="^BQICARE("_DA(1)_",1,"
 . D ^DIK
 . S RESULT=-1,MSG=$G(ERROR("DIERR",1,"TEXT",1))
 . ;S BMXSEC="Error encountered while copying panel definition."
 Q
 ;
CPY(ODUZ,NDUZ,OPIEN,NPIEN) ;EP -- Copy remaining panel data from previous owner to new owner
 ; Input
 ;   ODUZ   - DUZ of the previous owner of panel
 ;   NDUZ   - DUZ of the new owner of panel
 ;   OPIEN  - previous panel IEN
 ;   NPIEN  - New panel IEN
 ; description of nodes to be merged
 ;^BQICARE(D0,1,D1,1) = panel description
 ;^BQICARE(D0,1,D1,3)= panel definition node
 ;^BQICARE(D0,1,D1,5)= panel definition node
 ;^BQICARE(D0,1,D1,4)= Template References
 ;^BQICARE(D0,1,D1,10)= parameter definition
 ;^BQICARE(D0,1,D1,15)= filter defintion
 ;^BQICARE(D0,1,D1,20)= patient  layout
 ;^BQICARE(D0,1,D1,22)= reminders
 ;^BQICARE(D0,1,D1,23)= Care Mgmt Layouts (Asthma and HIV/AIDS)
 ;^BQICARE(D0,1,D1,25)= Nat'l Meas
 ;^BQICARE(D0,1,D1,30)= shared users
 ;^BQICARE(D0,1,D1,40)= patient list
 ;
 N I,DIK,DA,SUBSTR,SUB,SHRDUSR
 S SHRDUSR=0
 ;
 ; if the new owner was a shared user on the orignal panel then move to subscripts
 ; reprsenting new owner's layouts
 I $D(^BQICARE("C",NDUZ,ODUZ,OPIEN,NDUZ)) S SHRDUSR=1 D
 . M ^BQICARE(NDUZ,1,NPIEN,4)=^BQICARE(ODUZ,1,OPIEN,30,NDUZ,4)
 . S $P(^BQICARE(NDUZ,1,NPIEN,4,0),U,2)="90505.14"
 . M ^BQICARE(NDUZ,1,NPIEN,20)=^BQICARE(ODUZ,1,OPIEN,30,NDUZ,20)
 . S $P(^BQICARE(DUZ,1,NPIEN,20,0),U,2)="90505.05P"
 . M ^BQICARE(NDUZ,1,NPIEN,22)=^BQICARE(ODUZ,1,OPIEN,30,NDUZ,22)
 . S $P(^BQICARE(NDUZ,1,NPIEN,22,0),U,2)="90505.122"
 . M ^BQICARE(NDUZ,1,NPIEN,23)=^BQICARE(ODUZ,1,OPIEN,30,NDUZ,23)
 . S $P(^BQICARE(NDUZ,1,NPIEN,23,0),U,2)="90505.123"
 . N I S I=0 F  S I=$O(^BQICARE(NDUZ,1,PLIEN,23,I)) Q:'I  S $P(^BQICARE(NDUZ,1,PLIEN,23,I,1,0),U,2)="90505.1231"
 . M ^BQICARE(NDUZ,1,NPIEN,25)=^BQICARE(ODUZ,1,OPIEN,30,NDUZ,25)
 . S $P(^BQICARE(NDUZ,1,NPIEN,25,0),U,2)="90505.125"
 . D DELPNL(ODUZ,OPIEN,NDUZ)  ; need to delete new owner from the shared user sub-file
 ;
 ;
 I SHRDUSR S SUBSTR="1,3,5,10,15,30,40"   ; only merge remaining subscripts
 E  S SUBSTR="1,3,4,5,10,15,20,22,23,25,30,40"  ; merge all panel subscripts
 F I=1:1:$L(SUBSTR,",") S SUB=$P(SUBSTR,",",I) D
 . M ^BQICARE(NDUZ,1,NPIEN,SUB)=^BQICARE(ODUZ,1,OPIEN,SUB)
 ;
 ; Update cross references for merged entries
 S DIK="^BQICARE(",DA=NDUZ
 D IX^DIK
 S DA(1)=NDUZ
 S DIK="^BQICARE("_DA(1)_",1,"
 D IX^DIK
 ;
 ;  Handle "My Patient" Lists
 N IENS,SRCTYP
 S DA(1)=NDUZ,DA=NPIEN,IENS=$$IENS^DILF(.DA)
 S SRCTYP=$$GET1^DIQ(90505.01,IENS,.03,"I")
 I SRCTYP'="Y" Q
 S BQIUPD(90505.01,IENS,.03)="M"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 K DESC
 D PEN^BQIPLDSC(NDUZ,NPIEN,.DESC)
 D WP^DIE(90505.01,IENS,5,"","DESC")
 K DESC
 N DFN
 S DFN=0
 F  S DFN=$O(^BQICARE(NDUZ,1,NPIEN,40,DFN)) Q:'DFN  D
 . I $P(^BQICARE(NDUZ,1,NPIEN,40,DFN,0),U,2)'="" Q
 . S $P(^BQICARE(NDUZ,1,NPIEN,40,DFN,0),U,2)="A"
 . S $P(^BQICARE(NDUZ,1,NPIEN,40,DFN,0),U,4)=$$NOW^XLFDT()
 Q
 ;
DELPNL(ODUZ,OPIEN,NDUZ) ; EP - delete panel entry from previous owner
 ;   ODUZ   - DUZ of the previous owner of panel
 ;   NDUZ   - DUZ of the new owner of panel
 ;   OPIEN  - previous panel IEN
 S DA(1)=ODUZ,DA=OPIEN
 S DIK="^BQICARE("_DA(1)_",1,"
 I $G(NDUZ) D  ; delete new owner from shared panel
 . S DA=NDUZ,DA(1)=OPIEN,DA(2)=ODUZ
 . S DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",30,"
 D ^DIK
 ;   
 Q
 ;
ERR ;
 L -^BQICARE(DUZ,1,0)
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
