BTPWPEVO ;VNGT/HS/BEE-CMET Event Utilities ; 04 Feb 2009  2:55 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
ROPEN(DATA,CMIEN,COMMENT) ;EP -- BTPW REOPEN CLOSED EVENT
 ; Input Parameters
 ;   CMIEN   - IENs of the file 90620 entry or entries to be reopened
 ;   COMMENT - New Comment
 ;
 ; Output Value
 ;   RESULT = Piece 1 - (1) - Successful/(-1) - Unsuccessful
 ;          = Piece 2 - Error Message
 ;
 NEW UID,II,PIEN,PC
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPEVO",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPEVO D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^I00010CMET_IEN^T01024MSG^T00060EVENT^D00015EVENT_DATE^T00050PATIENT_NAME^T00030HRN"_$C(30)
 ;
 ;Make sure IEN is populated
 I $TR($G(CMIEN),$C(29))="" S II=II+1,@DATA@(II)="-1^^Event IEN is required^^^^"_$C(30) G DONE
 ;
 ;Loop through entries and close
 F PC=1:1:$L(CMIEN,$C(29)) S PIEN=$P(CMIEN,$C(29),PC) I PIEN]"" D REOP(PIEN,COMMENT)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
REOP(PIEN,COMMENT) ;EP - Reopen Individual Record
 ;
 N STATE,LN,I,P,BTPUPD,ERROR,CMTVAR,COM,DTTM
 ;
 ;Make sure event exists
 I $$GET1^DIQ(90620,PIEN_",",".01","I")="" S II=II+1,@DATA@(II)=$$EMSG(PIEN,"Could not find event corresponding to provided IEN")_$C(30) Q
 ;
 ;Make sure event is in a closed state
 S STATE=$$GET1^DIQ(90620,PIEN_",",1.01,"I")
 I STATE'="C" S II=II+1,@DATA@(II)=$$EMSG(PIEN,"Event is not in a closed state")_$C(30) Q
 ;
 ;Set up comment for processing
 S COMMENT=$G(COMMENT,"")
 S LN=0 F I=1:1:$L(COMMENT,$C(13)_$C(10)) S P=$P(COMMENT,$C(13)_$C(10),I) S LN=LN+1,COM(LN)=P
 I '$D(COM(1)) S CMTVAR="@"
 E  S CMTVAR="COM"
 ;
 S DTTM=$$NOW^XLFDT()
 S BTPUPD(90620,PIEN_",",1.01)="O"
 S BTPUPD(90620,PIEN_",",1.09)=DTTM
 S BTPUPD(90620,PIEN_",",1.1)=DUZ
 S BTPUPD(90620,PIEN_",",1.04)="@"
 S BTPUPD(90620,PIEN_",",1.08)="@"
 ;
 ;Save History
 D RLOG^BTPWHIST(.BTPUPD,DUZ,DTTM,"Event Reopen")
 ;
 ;Reopen event
 D FILE^DIE("","BTPUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)=$$EMSG(PIEN,"Unable to reopen event")_$C(30) Q
 ;
 ;Save Comment History
 D WLOG^BTPWHIST(.COM,"90620:3",PIEN_",",DUZ,DTTM,"Event Reopened")
 ;
 ;Save comments
 D WP^DIE(90620,PIEN_",",3,"",CMTVAR)
 ;
 S II=II+1,@DATA@(II)="1^"_PIEN_"^^^^^"_$C(30)
 ;
 Q
 ;
CLOSE(DATA,CMIEN,CREASON,COMMENT) ;EP -- BTPW CLOSE EVENT
 ; Input Parameters
 ;   CMIEN    - IENs of the file 90620 entry or entries to be closed
 ;   CREASON - Close Reason
 ;   COMMENT - New Comment
 ;
 ; Output Value
 ;   RESULT = Piece 1 - (1) - Successful/(-1) - Unsuccessful
 ;          = Piece 2 - Error Message
 ;
 NEW UID,II,ERROR,PC,PIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPEVO",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPEVO D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^I00010CMET_IEN^T01024MSG^T00060EVENT^D00015EVENT_DATE^T00050PATIENT_NAME^T00030HRN"_$C(30)
 ;
 ;Make sure IEN is populated
 I $TR($G(CMIEN),$C(29))="" S II=II+1,@DATA@(II)="-1^^Event IEN is required^^^^"_$C(30) G XDONE
 ;
 ;Loop through entries and close
 F PC=1:1:$L(CMIEN,$C(29)) S PIEN=$P(CMIEN,$C(29),PC) I PIEN]"" D CLS(PIEN,CREASON,COMMENT)
 ;
XDONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CLS(PIEN,CREASON,COMMENT) ;EP - Close individual record
 N STATE,LN,I,P,CMTVAR,COM,BTPUPD,DTTM
 ;
 ;Make sure event exists
 I $$GET1^DIQ(90620,PIEN_",",".01","I")="" S II=II+1,@DATA@(II)=$$EMSG(PIEN,"Could not find event corresponding to provided IEN")_$C(30) Q
 ;
 ;Make sure event is not in a closed state
 S STATE=$$GET1^DIQ(90620,PIEN_",",1.01,"I")
 I STATE="C" S II=II+1,@DATA@(II)=$$EMSG(PIEN,"Event is already in a closed state")_$C(30) Q
 ;
 ;Check for valid Close Reason
 I CREASON]"",CREASON'=1,CREASON'=2,CREASON'=3,CREASON'=4 S II=II+1,@DATA@(II)=$$EMSG(PIEN,"Invalid Close Reason")_$C(30) Q
 S:CREASON="" CREASON="@"  ;If blank, clear out what is in field
 ;
 ;Set up comment for processing
 S COMMENT=$G(COMMENT,"")
 S LN=0 F I=1:1:$L(COMMENT,$C(13)_$C(10)) S P=$P(COMMENT,$C(13)_$C(10),I) S LN=LN+1,COM(LN)=P
 I '$D(COM(1)) S CMTVAR="@"
 E  S CMTVAR="COM"
 ;
 S DTTM=$$NOW^XLFDT()
 S BTPUPD(90620,PIEN_",",1.01)="C"
 S BTPUPD(90620,PIEN_",",1.09)=DTTM
 S BTPUPD(90620,PIEN_",",1.1)=DUZ
 S BTPUPD(90620,PIEN_",",1.04)=CREASON
 S BTPUPD(90620,PIEN_",",1.08)="@"
 ;
 ;Save History
 D RLOG^BTPWHIST(.BTPUPD,DUZ,DTTM,"Event Closed")
 ;
 ;Close the event
 D FILE^DIE("","BTPUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)=$$EMSG(PIEN,"Unable to close event")_$C(30) Q
 ;
 ;Save Comment History
 D WLOG^BTPWHIST(.COM,"90620:3",PIEN_",",DUZ,DTTM,"Event Close")
 ;
 ;Save comments
 D WP^DIE(90620,PIEN_",",3,"",CMTVAR)
 ;
 S II=II+1,@DATA@(II)="1^"_PIEN_"^^^^^"_$C(30)
 ;
 Q
 ;
EMSG(PIEN,MSG) ; EP - Compose Return Error Message
 N RET,TDATA,DFN,PNAM,PROC,PROCNM,PRCDT,HRN
 S TDATA=$G(^BTPWP(PIEN,0)),DFN=$P(TDATA,U,2),PNAM=$P(^DPT(DFN,0),"^",1)
 S PROC=$P(TDATA,U,1),PROCNM=$P(^BTPW(90621,PROC,0),U,1)  ;Procedure/Name (Event)
 S PRCDT=$$FMTE^BQIUL1($P(TDATA,U,3))  ;Event Date
 S HRN=$TR($$HRNL^BQIULPT(DFN),";",$C(10))   ;HRN
 S RET="-1"_U_PIEN_U_MSG_U_PROCNM_U_PRCDT_U_PNAM_U_HRN
 Q RET
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
EIE(DATA,CMIEN,TYPE,IENS) ;EP -- BTPW EVENT ENT IN ERROR
 ; Input Parameters
 ;   CMIEN   - IENs of the file 90620 entry
 ;   TYPE    - Type of Entry - 'Finding'
 ;                             'Follow-up'
 ;                             'Notification'
 ;   IENS (OPT) - Specific entries to mark entered in error
 ;
 ; Output Value
 ;   RESULT = Piece 1 - (1) - Successful/(-1) - Unsuccessful
 ;          = Piece 2 - Error Message
 ;
 NEW UID,II,PIEN,DTTM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPEVO",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPEVO D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^I00010IEN^T01024MSG"_$C(30)
 S IENS=$G(IENS)
 ;
 ;Make sure IEN is populated
 I $TR($G(CMIEN),$C(29))="" S II=II+1,@DATA@(II)="-1^^Event IEN is required"_$C(30) G EDONE
 ;
 ;Make sure TYPE is defined
 I TYPE'="Finding",TYPE'="Follow-up",TYPE'="Notification" S II=II+1,@DATA@(II)="-1^^Event TYPE is required"_$C(30) G EDONE
 ;
 ;Pull current date/time
 S DTTM=$$NOW^XLFDT()
 ;
 ;Findings
 I TYPE="Finding" D  G EDONE
 . N IEN
 . ;
 . ;Process Individual Findings
 . I IENS]"" D  Q
 .. N I
 .. F I=1:1:$L(IENS,$C(29)) S IEN=$P(IENS,$C(29),I) D EFND(CMIEN,IEN,DTTM)
 . ;
 . ;Process All Findings
 . S IEN=0 F  S IEN=$O(^BTPWP(CMIEN,10,IEN)) Q:'IEN  D EFND(CMIEN,IEN,DTTM)
 ;
 ;Follow-ups
 I TYPE="Follow-up" D  G EDONE
 . N IEN
 . ;
 . ;Process Individual Follow-ups
 . I IENS]"" D  Q
 .. N I
 .. F I=1:1:$L(IENS,$C(29)) S IEN=$P(IENS,$C(29),I) D EFOL(CMIEN,IEN,DTTM)
 . ;
 . ;Process All Follow-ups
 . S IEN=0 F  S IEN=$O(^BTPWP(CMIEN,10,IEN)) Q:'IEN  D EFOL(CMIEN,IEN,DTTM)
 ;
 ;Notifications
 I TYPE="Notification" D  G EDONE
 . N IEN
 . ;
 . ;Process Individual Notifications
 . I IENS]"" D  Q
 .. N I
 .. F I=1:1:$L(IENS,$C(29)) S IEN=$P(IENS,$C(29),I) D ENOT(CMIEN,IEN,DTTM)
 . ;
 . ;Process All Notifications
 . S IEN=0 F  S IEN=$O(^BTPWP(CMIEN,10,IEN)) Q:'IEN  D ENOT(CMIEN,IEN,DTTM)
 ;
EDONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
 ;Mark Findings as ENTERED IN ERROR
EFND(CMIEN,IEN,DTTM) ;
 N BTPWDTA,DA,IENS,ERROR
 ;
 S DA(1)=CMIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 S BTPWDTA(90620.01,IENS,.08)="Y"
 S BTPWDTA(90620.01,IENS,.04)=DTTM
 S BTPWDTA(90620.01,IENS,.05)=DUZ
 S BTPWDTA(90620,CMIEN_",",1.09)=DTTM
 S BTPWDTA(90620,CMIEN_",",1.1)=DUZ
 ;
 ;Save History
 D RLOG^BTPWHIST(.BTPWDTA,DUZ,DTTM,"Entered In Error")
 ;
 D FILE^DIE("","BTPWDTA","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^"_IEN_"^Could not set finding to ENTERED IN ERROR"_$C(30) G XEFND
 S II=II+1,@DATA@(II)="1^"_IEN_"^"_$C(30)
 ;
XEFND Q
 ;
 ;Mark Follow-ups as ENTERED IN ERROR
EFOL(CMIEN,IEN,DTTM) ;
 N BTPWDTA,DA,IENS,ERROR,FTIEN
 ;
 S DA(1)=CMIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 S BTPWDTA(90620.012,IENS,.07)="Y"
 S BTPWDTA(90620.012,IENS,.03)=DTTM
 S BTPWDTA(90620.012,IENS,.04)=DUZ
 S BTPWDTA(90620,CMIEN_",",1.09)=DTTM
 S BTPWDTA(90620,CMIEN_",",1.1)=DUZ
 ;
 ;Save History
 D RLOG^BTPWHIST(.BTPWDTA,DUZ,DTTM,"Entered In Error")
 ;
 D FILE^DIE("","BTPWDTA","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^"_IEN_"^Could not set Follow-up to ENTERED IN ERROR"_$C(30) G XEFND
 S II=II+1,@DATA@(II)="1^"_IEN_"^"_$C(30)
 ;
 ;Process Future Record
 ; 
 ;Delete if still in a FUTURE state
 S FTIEN=$$GET1^DIQ(90620.012,IENS,.06,"I") Q:FTIEN=""
 I $$GET1^DIQ(90620,FTIEN_",",1.01,"I")="F" D  Q
 . N DA,DIK
 . S DA=FTIEN,DIK="^BTPWP(" D ^DIK Q
 ;
 ;Future record no longer in FUTURE state, remove pointer
 N BTPWUPD
 S BTPWUPD(90620,FTIEN_",",.11)="@"
 D FILE^DIE("","BTPWUPD","ERROR")
 ;
 Q
 ;
 ;Mark Notifications as ENTERED IN ERROR
ENOT(CMIEN,IEN,DTTM) ;
 N BTPWDTA,DA,IENS,ERROR
 ;
 S DA(1)=CMIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 S BTPWDTA(90620.011,IENS,.09)="Y"
 S BTPWDTA(90620.011,IENS,.03)=DTTM
 S BTPWDTA(90620.011,IENS,.04)=DUZ
 S BTPWDTA(90620,CMIEN_",",1.09)=DTTM
 S BTPWDTA(90620,CMIEN_",",1.1)=DUZ
 ;
 ;Save History
 D RLOG^BTPWHIST(.BTPWDTA,DUZ,DTTM,"Entered In Error")
 ;
 D FILE^DIE("","BTPWDTA","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^"_IEN_"^Could not set Notification to ENTERED IN ERROR"_$C(30) G XEFND
 S II=II+1,@DATA@(II)="1^"_IEN_"^"_$C(30)
 ;
 Q
