BQIPLRP ;PRXM/HC/KJH-Replace Panel Functions ; 24 Jan 2006  5:38 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN,ASSOC,PLNM) ; EP - BQI REPLACE PANEL
 ; Description
 ;   Replaces the original panel (PLIEN) with the new associated panel (ASSOC).
 ;   Various data is copied from the original panel to the new panel and then
 ;   the original panel is deleted. The new panel may optionally be renamed
 ;   during the process. Otherwise, it will assume the name of the original.
 ; Input:
 ;   OWNR   - Owner of the panel
 ;   PLIEN  - Original panel IEN
 ;   ASSOC  - New associated panel IEN
 ;   PLNM   - New panel name (optional)
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ;   RESULT = 1 if the process completed
 ; or
 ;   BMXSEC - if records can't be locked or if $D(ERROR)
 ;            when filing or M error encountered
 ;            
 N UID,X,BQII
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLRP",UID))
 K ^TMP("BQIPLRP",UID)
 ;
 ; Check if share and has write access
 I '$$CKSHR^BQIPLSH(OWNR,PLIEN) S BMXSEC="You do not have write access" Q
 I '$$CKSHR^BQIPLSH(OWNR,ASSOC) S BMXSEC="You do not have write access" Q
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S BQII=0,^TMP("BQIPLRP",UID,BQII)="I00010RESULT"_$C(30)
 ;
 NEW DA,DIK,OIENS,IENS,BQIOLD,BQINEW,ERROR,TEXT,TMP
 ;
 ; Get information to be copied from 'original' panel
 S DA=PLIEN,DA(1)=OWNR,OIENS=$$IENS^DILF(.DA)
 ;D GETS^DIQ(90505.01,OIENS,".01;.02","I","BQIOLD")
 D GETS^DIQ(90505.01,OIENS,"*","I","BQIOLD")
 ;
 D SHARE ; Send shared notifications
 ;
 ; Delete 'original' panel
 S DIK="^BQICARE("_DA(1)_",1,"
 D ^DIK
 ;
 ; Update information for 'new' panel
 S DA=ASSOC,DA(1)=OWNR,IENS=$$IENS^DILF(.DA)
 NEW FLDS
 F FLDS=.03:.01:.12,.14,.16 I $$GET1^DIQ(90505.01,IENS,FLDS,"I")="",$G(BQIOLD(90505.01,OIENS,FLDS,"I"))'="" S BQINEW(90505.01,IENS,FLDS)=$G(BQIOLD(90505.01,OIENS,FLDS,"I"))
 F FLDS=3.3:.1:3.7 I $$GET1^DIQ(90505.01,IENS,FLDS,"I")="",$G(BQIOLD(90505.01,OIENS,FLDS,"I"))'="" S BQINEW(90505.01,IENS,FLDS)=$G(BQIOLD(90505.01,OIENS,FLDS,"I"))
 I $G(BQIOLD(90505.01,OIENS,.01,"I"))'="" S BQINEW(90505.01,IENS,.01)=$G(BQIOLD(90505.01,OIENS,.01,"I"))
 I $G(BQIOLD(90505.01,OIENS,.02,"I"))'="" S BQINEW(90505.01,IENS,.02)=$G(BQIOLD(90505.01,OIENS,.02,"I"))
 ;
 ; Change name if new name was supplied.
 ; If new name is currently in use on another panel then just leave the old name.
 I $G(PLNM)]"" D
 . N DA,PIENS,ERROR
 . S DA(1)=OWNR,DA=""
 . S PIENS=$$IENS^DILF(.DA)
 . S TMP=$$FIND1^DIC(90505.01,PIENS,"X",PLNM,"","","ERROR")
 . I TMP'=0 Q  ; Name currently in use
 . S BQINEW(90505.01,IENS,.01)=PLNM
 . Q
 ;
 ; Remove 'associated IEN' and 'status' information
 S BQINEW(90505.01,IENS,.13)="@"
 S BQINEW(90505.01,IENS,.15)="@"
 ;
 ; Save information to 'new' panel
 D FILE^DIE("","BQINEW","ERROR")
 I $D(ERROR) S BMXSEC="Error encountered while replacing panel." Q
 ;
 ; Update message notification
 S TEXT="Panel "_$$GET1^DIQ(90505.01,IENS,.01,"E")_" has been modified"
 I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T" D UPD^BQINOTF(OWNR,ASSOC,TEXT)
 ; Report success
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)="1"_$C(30)
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
SHARE ; Compare share status from original and new panels and issue notifications
 ;   PLIEN  - Original panel IEN
 ;   ASSOC  - New associated panel IEN
 N DA,SHR,SIENS,OSTA,NSTA,TEXT
 S DA(2)=OWNR
 S SHR=0
 F  S SHR=$O(^BQICARE(OWNR,1,PLIEN,30,SHR)) Q:'SHR  D  ; Shared node is DINUM'd
 . I '$D(^BQICARE(OWNR,1,ASSOC,30,SHR)) D  Q
 .. ; Shared user was deleted
 .. I SHR=DUZ D  Q
 ... S TEXT=$$GET1^DIQ(200,SHR_",",.01,"E")_" has been removed from sharing panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)
 ... D FIL^BQINOTF(OWNR,TEXT)
 .. S TEXT="You have been deleted from sharing panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 .. D FIL^BQINOTF(SHR,TEXT)
 . ;
 . S DA=SHR,DA(1)=PLIEN,SIENS=$$IENS^DILF(.DA)
 . S OSTA=$$GET1^DIQ(90505.03,SIENS,.02,"I")
 . S DA=SHR,DA(1)=ASSOC,SIENS=$$IENS^DILF(.DA)
 . S NSTA=$$GET1^DIQ(90505.03,SIENS,.02,"I")
 . I NSTA="I",NSTA'=OSTA D
 .. ; Inactive status notification
 .. I SHR=DUZ D  Q
 ... S TEXT=$$GET1^DIQ(200,SHR_",",.01,"E")_" has been inactivated as a share for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 ... D FIL^BQINOTF(OWNR,TEXT)
 .. S TEXT="You have been inactivated as a share for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 .. D FIL^BQINOTF(SHR,TEXT)
 .. ;
 S SHR=0
 F  S SHR=$O(^BQICARE(OWNR,1,ASSOC,30,SHR)) Q:'SHR  D  ; Shared node is DINUM'd
 . I '$D(^BQICARE(OWNR,1,PLIEN,30,SHR)) D  Q
 .. ; Shared user was added
 .. S TEXT="You have been added as a shared user for Panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" by "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 .. I $P(^BQICARE(OWNR,1,ASSOC,30,SHR,0),U,3)'="" D
 ... NEW DTSTRT,DTEND
 ... S DTSTRT=$P(^BQICARE(OWNR,1,ASSOC,30,SHR,0),U,3)
 ... S DTEND=$P(^BQICARE(OWNR,1,ASSOC,30,SHR,0),U,4)
 ... S TEXT=TEXT_" temporarily from "_$$FMTE^BQIUL1(DTSTRT)_" thru "_$$FMTE^BQIUL1(DTEND)
 .. D FIL^BQINOTF(SHR,TEXT)
 Q
 ;
ERR ;
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
