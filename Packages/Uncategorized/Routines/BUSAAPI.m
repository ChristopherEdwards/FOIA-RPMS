BUSAAPI ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Utility API Program ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
 Q
 ;
LOG(TYPE,CAT,ACTION,CALL,DESC,DETAIL) ;PEP - Log Security Audit Entries
 ;
 ; Required variables:
 ;   DUZ - Pointer to NEW PERSON (#200) file
 ;
 ;Input Parameters:
 ;   TYPE - (Optional) - The type of entry to log (R:RPC Call;W:Web Service
 ;                       Call;A:API Call;O:Other)
 ;                       (Default - A)
 ;    CAT - (Required) - The category of the event to log (S:System Event;
 ;                       P:Patient Related;D:Definition Change;
 ;                       O:Other Event)
 ; ACTION - (Required for CAT="P") - The action of the event to log
 ;                       (A:Additions;D:Deletions;Q:Queries;P:Print;
 ;                       E:Changes;C:Copy)
 ;   CALL - (Required) - Free text entry describing the call which 
 ;                       originated the audit request (Maximum length
 ;                       200 characters)
 ;                       Examples could be an RPC value or calling
 ;                       routine
 ;   DESC - (Required) - Free text entry describing the call action
 ;                       (Maximum length 250 characters)
 ;                       Examples could be 'Patient demographic update',
 ;                       'Copied iCare panel to clipboard' or 'POV Entry'
 ;
 ; DETAIL - Array of patient/visit records to log. Required for patient 
 ;          related events. Optional for other event types
 ;
 ; Format: DETAIL(#)=DFN^VIEN^EVENT DESCRIPTION^NEW VALUE^ORIGINAL VALUE
 ;
 ; Where:
 ; # - Record counter (1,2,3...)
 ; DFN - (Optional for non-patient related calls) - Pointer to VA PATIENT file (#2)
 ; VIEN - (Optional for non-visit related calls) - Pointer to VISIT file (#9000010)
 ; EVENT DESCRIPTION -(Optional) - Additional detail to log for this entry
 ; NEW VALUE - (Optional) - New value after call completion, if applicable
 ; ORIGINAL VALUE - (Optional) - Original value prior to call execution, if applicable
 ;
 NEW STS,SIEN,BUSAUPD,ERROR,BUSAII
 S STS=""
 ;
 ;Make sure logging switch is on
 I '+$$STATUS^BUSAOPT("M") S STS="0^Master audit logging switch is off" G XLOG
 ;
ALTENT ;Entry point from bypass call
 ; 
 ;Check for DUZ (USER filed)
 I +$G(DUZ)<1 S STS="0^Invalid DUZ value" G XLOG
 ;
 ;Check for TYPE (ENTRY TYPE field)
 S TYPE=$G(TYPE,"") S:TYPE="" TYPE="A"
 ;
 ;Check for CAT (CATEGORY field)
 I $G(CAT)="" S STS="0^Invalid CAT value" G XLOG
 ;
 ;Action
 S ACTION=$G(ACTION,"") I ACTION="",CAT="P" S STS="0^Action required if Patient Category" G XLOG
 ;
 ;Check for CALL (ORIGINATING CALL field)
 I $G(CALL)="" S STS="0^Invalid CALL value" G XLOG
 ;
 ;Check for DESC (ENTRY DESCRIPTION field)
 I $G(DESC)="" S STS="0^Invalid DESC value" G XLOG
 ;
 ;Log new BUSA AUDIT LOG SUMMARY entry
 S SIEN=$$NEWS() I 'SIEN S STS="0^Unable to create summary entry" G XLOG
 ;
 ;Log remaining summary fields
 S BUSAUPD(9002319.01,SIEN_",",.02)=DUZ  ;USER
 S BUSAUPD(9002319.01,SIEN_",",.03)=CAT  ;CATEGORY
 S BUSAUPD(9002319.01,SIEN_",",.04)=TYPE ;ENTRY TYPE
 S BUSAUPD(9002319.01,SIEN_",",.05)=ACTION  ;ACTION
 S BUSAUPD(9002319.01,SIEN_",",.06)=$E(CALL,1,200)  ;ORIGINATING CALL
 S BUSAUPD(9002319.01,SIEN_",",1)=$E(DESC,1,250)  ;ENTRY DESCRIPTION
 D FILE^DIE("","BUSAUPD","ERROR") I $D(ERROR) S STS="0^"_$G(ERROR) G XLOG
 ;
 ;Log BUSA AUDIT LOG DETAIL entries
 I $G(DETAIL)]"" S BUSAII=0 F  S BUSAII=$O(@DETAIL@(BUSAII)) Q:BUSAII=""  D  Q:STS]""
 . NEW DIEN,BUSADET,ND
 . ;
 . ;Log detail entry
 . S ND=$G(@DETAIL@(BUSAII))
 . S DIEN=$$NEWD(SIEN) I 'DIEN S STS="0^Unable to create detail entry" Q
 . ;
 . ;Plug in DFN using VIEN (if DFN is blank)
 . I $P(ND,U)="",$P(ND,U,2)]"" S $P(ND,U)=$$GET1^DIQ(9000010,$P(ND,U,2)_",",".05","I")
 . ;
 . ;Log remaining detail fields
 . S:$P(ND,U)]"" BUSADET(9002319.02,DIEN_",",.02)=$P(ND,U)
 . S:$P(ND,U,2)]"" BUSADET(9002319.02,DIEN_",",.03)=$P(ND,U,2)
 . S:$P(ND,U,3)]"" BUSADET(9002319.02,DIEN_",",.04)=$E($P(ND,U,3),1,200)
 . ;
 . ;New value
 . I $P(ND,U,4)]"" D
 .. N TXT,VAR
 .. D WRAP^BUSAUTIL(.TXT,$P(ND,U,4),220)
 .. S VAR="TXT"
 .. D WP^DIE(9002319.02,DIEN_",",1,"",VAR)
 . ;
 . ;Original value
 . I $P(ND,U,5)]"" D
 .. N TXT,VAR
 .. D WRAP^BUSAUTIL(.TXT,$P(ND,U,5),220)
 .. S VAR="TXT"
 .. D WP^DIE(9002319.02,DIEN_",",2,"",VAR)
 . D FILE^DIE("","BUSADET","ERROR") I $D(ERROR) S STS="0^"_$G(ERROR)
 I STS]"" G XLOG
 ;
 ;Successful log
 S STS=1
 ;
 ;Log Exit Point
XLOG Q STS
 ;
BYPSLOG(TYPE,CAT,ACTION,CALL,DESC,DETAIL) ;EP - Log Security Audit Entries
 ;
 ;This API makes the call to log an audit entry but bypasses the check
 ;to see if the master audit is turned on
 ;
 NEW STS,SIEN,BUSAUPD,ERROR,BUSAII
 S STS=""
 ;
 G ALTENT
 ;
NEWS() ;EP - Create new BUSA AUDIT LOG SUMMARY entry stub
 N DIC,X,Y,DA,DLAYGO,%
 S DIC(0)="L",DIC="^BUSAS(",DLAYGO=DIC
 D NOW^%DTC
 S X=%
 K DO,DD D FILE^DICN
 Q +Y
 ;
NEWD(SIEN) ;EP - Create new BUSA AUDIT LOG DETAIL entry stub
 N DIC,X,Y,DA,DLAYGO
 S DIC(0)="L",DIC="^BUSAD(",DLAYGO=DIC
 S X=SIEN
 K DO,DD D FILE^DICN
 Q +Y
