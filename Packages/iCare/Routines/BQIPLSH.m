BQIPLSH ;PRXM/HC/ALA - Panel Sharing Update ; 07 Nov 2005  3:53 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN,WHO,ACTION,ACCESS,DTSTRT,DTEND,LTYPE,OVRRD) ; EP -- BQI UPDATE SHARE LIST BY PANEL
 ;Description
 ;  Add/Update/Remove a panel share, given the owner ien, panel ien, WHO ien, share action flag, and access.
 ;
 ;Input
 ;  OWNR  - Owner of the panel
 ;  PLIEN - Panel internal entry number
 ;  WHO   - internal entry number of who is being added as
 ;          a share person
 ;  ACTION - Action flag 'U' for update, 'D' for delete, 'A' for add
 ;  ACCESS - Access flag 'R' for read only, 'RW' for read/write
 ;           and 'I' for inactive
 ;  DTSTRT - Start share date
 ;  DTEND  - End share date
 ;  LTYPE  - Layout Type (Y-Share All,N-No Sharing,A-Asthma,D-Patient,H-HIV/AIDS,R-Reminder,G-Nat'l Measures)
 ;                       (Q-Queued,T-Tracked,P-Planned)
 ;  OVRRD  - Override Flag (1-Override Shared User Layout, 0/Null-Do not Override)
 ;  
 ;Output
 ;  RESULT - 1 for Success, 0 for Failure, <0 for Error.
 ;  
 NEW UID,II,DFN,X,RESULT,OACTION
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQISHARE",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLSH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 S DTSTRT=$$DATE^BQIUL1($G(DTSTRT))
 S DTEND=$$DATE^BQIUL1($G(DTEND))
 S LTYPE=$G(LTYPE,"") S:LTYPE="" LTYPE="N"
 S OVRRD=$G(OVRRD,"")
 ;
 ; Branch off to specific tag, depending on action.
 S OACTION=ACTION ; Save original action - add is reset to update
 I ACTION="A" S RESULT=$$ASHR() I RESULT>0 S ACTION="U"
 I ACTION="D"!(ACTION="U") S RESULT=$$USHR()
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ASHR() ;EP - Add a person to share a panel
 ;
 ;Description
 ;  Adds a person to a panel owned by someone else
 ; 
 ;Output
 ;  Y - if -1, then it wasn't successful, otherwise it should
 ;      be the same as the WHO since the field is DINUM'd
 ;
 NEW DA,X,DINUM,DIC,DIE,DLAYGO,NDA,ERROR,Y
 S DA(2)=OWNR,DA(1)=PLIEN,(X,DINUM)=WHO
 S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",30,",DIE=DIC
 S DLAYGO=90505.03,DIC(0)="L",DIC("P")=DLAYGO
 I '$D(^BQICARE(DA(2),1,DA(1),30,0)) S ^BQICARE(DA(2),1,DA(1),30,0)="^90505.03P^^"
 K DO,DD D FILE^DICN S NDA=+Y
 I NDA<1 Q NDA
 ;
 ; Update flags when sharing
 NEW DFN
 S DFN=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . D UPU^BQIFLAG(DFN,WHO)
 ;
 ; Layout Sharing
 ; 
 I LTYPE]"" D  I $D(ERROR) Q -1
 . ;
 . ;Update SHARE LAYOUTS field
 . N DA,IENS,BQISHARE
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=WHO
 . S IENS=$$IENS^DILF(.DA)
 . S BQISHARE(90505.03,IENS,.05)=$S(LTYPE="N":0,1:1)
 . D FILE^DIE("","BQISHARE","ERROR")
 . ;
 . ;Copy Layouts
 . I LTYPE="N" Q
 . I LTYPE="Y"!(LTYPE["D") D CPLAY(OWNR,PLIEN,WHO,"D",OVRRD)
 . I LTYPE="Y"!(LTYPE["R") D CPLAY(OWNR,PLIEN,WHO,"R",OVRRD)
 . I LTYPE="Y"!(LTYPE["G") D CPLAY(OWNR,PLIEN,WHO,"G",OVRRD)
 . I LTYPE="Y"!(LTYPE["A") D CPLAY(OWNR,PLIEN,WHO,"A",OVRRD)
 . I LTYPE="Y"!(LTYPE["H") D CPLAY(OWNR,PLIEN,WHO,"H",OVRRD)
 . I LTYPE="Y"!(LTYPE["Q") D CPLAY(OWNR,PLIEN,WHO,"Q",OVRRD)
 . I LTYPE="Y"!(LTYPE["T") D CPLAY(OWNR,PLIEN,WHO,"T",OVRRD)
 . I LTYPE="Y"!(LTYPE["P") D CPLAY(OWNR,PLIEN,WHO,"N",OVRRD) ;For Planned Events switch to 'N'
 ;
 ; Send notification
 NEW TEXT,DA,IENS
 S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 S TEXT="You have been added as a shared user for Panel "_$$GET1^DIQ(90505.01,IENS,.01,"E")_" by "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 I $G(DTSTRT)'="" S TEXT=TEXT_" temporarily from "_$$FMTE^BQIUL1(DTSTRT)_" thru "_$$FMTE^BQIUL1(DTEND)
 ;
 I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(WHO,TEXT)
 Q NDA
 ;
USHR() ;EP - Update a share record
 ;
 ;Description
 ;  Update a share record with data
 ;
 NEW DA,SIENS,BQISHRUP,ERROR,TEXT,IENS
 S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 S DA(2)=OWNR,DA(1)=PLIEN,DA=WHO
 S SIENS=$$IENS^DILF(.DA)
 I ACTION="D" D
 . S BQISHRUP(90505.03,SIENS,.01)="@"
 . I WHO=DUZ D  Q
 .. S TEXT=$$GET1^DIQ(200,DUZ_",",.01,"E")_" has been removed from sharing panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)
 .. I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(OWNR,TEXT)
 . S TEXT="You have been deleted from sharing panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 . I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(WHO,TEXT)
 ;
 I ACTION="U" D
 . I $G(ACCESS)="I",$$GET1^DIQ(90505.03,SIENS,.02,"I")'="I" D
 .. I WHO=DUZ D  Q
 ... S TEXT=$$GET1^DIQ(200,WHO_",",.01,"E")_" has been inactivated as a share for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 ... I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(OWNR,TEXT)
 .. S TEXT="You have been inactivated as a share for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 .. I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(WHO,TEXT)
 . I $G(ACCESS)'="I" D
 .. N ODTST,ODTEND
 .. S ODTST=$$GET1^DIQ(90505.03,SIENS,.03,"I")
 .. S ODTEND=$$GET1^DIQ(90505.03,SIENS,.04,"I")
 .. ; Date notifications should only be issued for an update
 .. I OACTION="U",ODTST'=$G(DTSTRT)!(ODTEND'=$G(DTEND)) D
 ... I ODTEND,ODTEND<$G(DTSTRT) D  Q  ; reinstated share
 .... I WHO=DUZ D  Q
 ..... S TEXT=$$GET1^DIQ(200,WHO_",",.01,"E")_" has been reactivated as a share for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 ..... I $G(DTSTRT)'="" S TEXT=TEXT_" temporarily from "_$$FMTE^BQIUL1(DTSTRT)_" thru "_$$FMTE^BQIUL1(DTEND)_"."
 ..... I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(OWNR,TEXT)
 .... S TEXT="You have been reactivated as a share for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 .... S TEXT=TEXT_" temporarily from "_$$FMTE^BQIUL1(DTSTRT)_" thru "_$$FMTE^BQIUL1(DTEND)_"."
 .... I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(WHO,TEXT)
 ... I WHO=DUZ D  Q
 .... S TEXT=$$GET1^DIQ(200,WHO_",",.01,"E")_"'s share dates have been changed for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 .... I $G(DTSTRT)'="" S TEXT=TEXT_".  The new dates are "_$$FMTE^BQIUL1(DTSTRT)_" thru "_$$FMTE^BQIUL1(DTEND)_"."
 .... I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(OWNR,TEXT)
 ... S TEXT="Your share dates have been changed for panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" for "_$$GET1^DIQ(90505,OWNR_",",.01,"E")
 ... S TEXT=TEXT_".  The new dates are "_$$FMTE^BQIUL1(DTSTRT)_" thru "_$$FMTE^BQIUL1(DTEND)_"."
 ... I $$GET1^DIQ(90505.01,IENS,.13,"I")'="T",$$GET1^DIQ(90505.01,IENS,.15,"I")="" D FIL^BQINOTF(WHO,TEXT)
 . S BQISHRUP(90505.03,SIENS,.02)=$G(ACCESS)
 . S BQISHRUP(90505.03,SIENS,.03)=$G(DTSTRT)
 . S BQISHRUP(90505.03,SIENS,.04)=$G(DTEND)
 D FILE^DIE("","BQISHRUP","ERROR")
 I $D(ERROR) Q 0
 Q 1
 ;
CKSHR(OWNR,PLIEN) ;EP -- Check the write rights of a shared person
 ;
 ;Description
 ;  This function checks the write status of a shared user
 ;Input
 ;  OWNR  - Owner of the panel
 ;  PLIEN - Panel internal entry number
 ;Output
 ;  1 - if okay to write to the panel
 ;  0 - if not okay to write to the panel
 ;
 NEW DA,IENS,ACCESS
 I DUZ=OWNR Q 1
 S DA(2)=OWNR,DA(1)=PLIEN,DA=DUZ
 S IENS=$$IENS^DILF(.DA)
 S ACCESS=$$GET1^DIQ(90505.03,IENS,.02,"I")
 I ACCESS="RW" Q 1
 Q 0
 ;
CPLAY(OWNR,PLIEN,WHO,LTYPE,OVRRD) ;EP -- Copy Owner Layout to Shared User
 ;
 ;Description
 ;  This function copies the desired panel layout from the panel owner to the selected shared user
 ;
 ;Input
 ;  OWNR  - Owner of the panel
 ;  PLIEN - Panel internal entry number
 ;  WHO   - DUZ of the shared user
 ;  LTYPE - Layout Type (P-Patient,R-Reminder,M-Nat'l Measures)
 ;                      (Q-Queued,T-Tracked,N-Planned)
 ;  OVRRD - Override Flag (1-Override Shared User Layout, 0/Null-Do not Override)
 ;
 N BQIUPD,ERROR,LAYDD,LAYFLD,OLAY,RESULT,SLAYDD,TMPIEN
 ;
 ;Make sure needed fields are populated
 I $G(OWNR)=""!($G(WHO))=""!'PLIEN Q "0^Required Fields Are Missing"
 ;
 ;Check for valid layout type
 I LTYPE'="D",LTYPE'="R",LTYPE'="G",LTYPE'="A",LTYPE'="H",LTYPE'="T",LTYPE'="Q",LTYPE'="N" Q "0^Invalid Layout Type"
 ;
 ;Set up dictionary/field values
 I LTYPE="D" S LAYFLD="20",LAYDD="90505.05",SLAYDD="90505.06"        ;Patient
 E  I LTYPE="R" S LAYFLD="22",LAYDD="90505.122",SLAYDD="90505.322"   ;Reminder
 E  I LTYPE="G" S LAYFLD="25",LAYDD="90505.125",SLAYDD="90505.325"   ;Nat'l Measures
 E  S LAYFLD=23,LAYDD="90505.1231",SLAYDD="90505.3231"               ;Care Management
 ;
 ;Check Override field
 S:$G(OVRRD)'=1 OVRRD=0
 ;
 ;Initialize Result Variable
 S RESULT=""
 ;
 ;Try to first pull from a template
 S TMPIEN=$O(^BQICARE(OWNR,1,PLIEN,4,"C",LTYPE,"")) I TMPIEN]"" D
 . N DA,FLD,IEN,TMPNM
 . S TMPNM=$P($G(^BQICARE(OWNR,1,PLIEN,4,TMPIEN,0)),U) Q:TMPNM=""
 . S TMPIEN=$$TPN^BQILYUTL(OWNR,TMPNM) Q:TMPIEN=""
 . S DA(1)=OWNR,DA=TMPIEN,IEN=$$IENS^DILF(.DA)
 . D GETS^DIQ(90505.015,IEN,"1*","I","OLAY")
 . ;
 . ;Re-Sort and convert field code to internal value
 . S IEN="" F  S IEN=$O(OLAY(90505.151,IEN)) Q:IEN=""  S FLD="" F  S FLD=$O(OLAY(90505.151,IEN,FLD)) Q:FLD=""  D
 .. N CD S CD=""
 .. I FLD=".01" D  Q:CD=""
 ... S CD=$P($G(OLAY(90505.151,IEN,FLD,"I")),U) Q:CD=""
 ... ;I (LTYPE="A")!(LTYPE="H")!(LTYPE="T")!(LTYPE="Q")!(LTYPE="N") S CD=$O(^BQI(90506.1,"B",CD,"")) Q:CD=""
 ... S $P(OLAY(90505.151,IEN,FLD,"I"),U)=CD
 .. S OLAY("O",$P(IEN,","),FLD)=$G(OLAY(90505.151,IEN,FLD,"I"))
 .. K OLAY(90505.151,IEN,FLD,"I")
 ;
 ;If no template, pull from custom layout
 I TMPIEN="" D
 . ;Pull Owner Layout Definition
 . N DA,FLD,IEN,ROOT,SRC
 . S DA(1)=OWNR,DA=PLIEN,IEN=$$IENS^DILF(.DA)
 . D GETS^DIQ(90505.01,IEN,LAYFLD_"*","I","OLAY")
 . ;
 . S ROOT=""
 . I LAYFLD=23 D
 .. S IEN="" F  S IEN=$O(OLAY(90505.123,IEN)) Q:'IEN  D  I ROOT]"" Q
 ... S SRC=$G(OLAY(90505.123,IEN,".01","I"))
 ... I SRC]"",SRC="Asthma",LTYPE="A" S ROOT=IEN Q
 ... I SRC]"",SRC="HIV/AIDS",LTYPE="H" S ROOT=IEN Q
 ... I SRC]"",SRC="Events",LTYPE="Q" S ROOT=IEN Q
 ... I SRC]"",SRC="Tracked Events",LTYPE="T" S ROOT=IEN Q
 ... I SRC]"",SRC="Followup Events",LTYPE="N" S ROOT=IEN Q
 . ;
 . ;Re-Sort To Preserve Original Order
 . S IEN="" F  S IEN=$O(OLAY(LAYDD,IEN)) Q:IEN=""  D
 .. I ROOT]"",IEN'[ROOT K OLAY(LAYDD,IEN) Q   ;If Care Mgmt only pull entries for that type
 .. S FLD="" F  S FLD=$O(OLAY(LAYDD,IEN,FLD)) Q:FLD=""  D
 ... S OLAY("O",$P(IEN,","),FLD)=$G(OLAY(LAYDD,IEN,FLD,"I"))
 ... K OLAY(LAYDD,IEN,FLD,"I")
 ;
 ;Pull Current Shared User Layout Definition
 N DA,CIENS,CLAY
 S DA(2)=OWNR,DA(1)=PLIEN,DA=WHO,CIENS=$$IENS^DILF(.DA)
 D GETS^DIQ(90505.03,CIENS,"**","","CLAY")
 ;
 ;Verify that share is defined
 I '$D(CLAY(90505.03,CIENS,.01)) Q "0^Shared User Not Defined Properly For Panel"
 ;
 ;Process Patient, Reminders, and Nat'l Measures
 I ",D,R,G,"[(","_LTYPE_",") D  Q RESULT
 . ;
 . ;Check if layout is defined - Quit if no Override
 . I $D(CLAY(SLAYDD)),OVRRD'=1 S RESULT="1^Shared User Custom Layout Already Defined" Q
 . ;
 . ;Remove Custom Definition If Already Defined
 . I $D(CLAY(SLAYDD)) D  I $D(ERROR) S RESULT="0^Cannot Remove Existing Shared User Custom Layout" Q
 .. N BQIDEL,DA,IEN
 .. S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=WHO,DA=0
 .. F  S DA=$O(^BQICARE(OWNR,1,PLIEN,30,WHO,LAYFLD,DA)) Q:'DA  D
 ... S IEN=$$IENS^DILF(.DA)
 ... S BQIDEL(SLAYDD,IEN,.01)="@"
 .. I $D(BQIDEL) D FILE^DIE("","BQIDEL","ERROR")
 .. K BQIDEL,DA,IEN
 . ;
 . ;Copy Into Shared User Section
 . I '$D(OLAY) S RESULT=1 Q
 . N BQIUPD,IEN
 . S IEN="" F  S IEN=$O(OLAY("O",IEN)) Q:IEN=""  D
 .. N DA,DD,DIC,DIE,DLAYGO,DO,IENS,X,Y
 .. S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=WHO
 .. S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_","_LAYFLD_",",DIE=DIC
 .. S DLAYGO=SLAYDD,DIC(0)="L",DIC("P")=DLAYGO
 .. S X=$G(OLAY("O",IEN,.01)) Q:X=""
 .. I '$D(^BQICARE(DA(3),1,DA(2),30,DA(1),LAYFLD,0)) S ^BQICARE(DA(3),1,DA(2),30,DA(1),LAYFLD,0)="^"_SLAYDD_$S(LAYFLD=20:"P",1:"")_"^^"
 .. K DO,DD D FILE^DICN
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. M BQIUPD(SLAYDD,IENS)=OLAY("O",IEN)
 . D FILE^DIE("","BQIUPD","ERROR")
 . I $D(ERROR) S RESULT="0^Problem Copying Owner Layout To Shared User" Q
 . S RESULT=1 Q
 ;
 ;Process CM Layouts
 ;
 N IEN,IENS,LAYMN
 S LAYMN=$S(LTYPE="A":"Asthma",LTYPE="H":"HIV/AIDS",LTYPE="Q":"Events",LTYPE="T":"Tracked Events",LTYPE="N":"Followup Events",1:"") I LAYMN="" Q "0^Invalid Layout Type"
 ;
 ;Check if layout is already defined - Quit if no Override
 S IEN=0 F  S IEN=$O(CLAY(90505.323,IEN)) Q:'IEN  I $G(CLAY(90505.323,IEN,".01"))=LAYMN D
 . N BQIDEL
 . S IENS="" F  S IENS=$O(CLAY(SLAYDD,IENS)) Q:IENS=""!(RESULT]"")  D
 ..;
 ..;Process Only Selected Layout
 ..Q:IENS'[IEN
 ..I OVRRD'=1 S RESULT="0^Cannot Remove Existing Shared User Custom Layout" Q
 ..;
 ..;Remove Custom Def
 ..N DA,IEN
 ..S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=WHO,DA(1)=$P(IENS,U,2),DA=$P(IENS,U),IEN=$$IENS^DILF(.DA)
 ..S BQIDEL(SLAYDD,IEN,.01)="@"
 . I $D(BQIDEL) D FILE^DIE("","BQIDEL","ERROR")
 I $D(ERROR) Q "0^Cannot Remove Existing Shared User Custom Layout"
 ;
 ;Quit if no layout to copy
 I '$D(OLAY) Q 1
 ;
 ;Copy Into Shared User Care Management Section
 ;
 ;First Define A Source Level Entry (if not defined)
 N BQIUPD,CRIEN,IEN
 S CRIEN=$O(^BQICARE(OWNR,1,PLIEN,30,WHO,23,"B",LAYMN,""))
 I CRIEN="" D
 . NEW DA,DIC,DLAYGO,X,Y
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=WHO,X=LAYMN
 . S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",23,",DIC(0)="L",DLAYGO=90505.323
 . K DO,DD D FILE^DICN
 . S CRIEN=+Y
 ;
 ;Loop through owner custom list and save
 S IEN="" F  S IEN=$O(OLAY("O",IEN)) Q:IEN=""  D  Q:RESULT]""
 . N DA,DINUM,DIC,DIE,DLAYGO,FLD,IENS,X,Y
 . S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=WHO,DA(1)=CRIEN
 . S DIC="^BQICARE("_DA(4)_",1,"_DA(3)_",30,"_DA(2)_",23,"_DA(1)_",1,",DIE=DIC
 . S DLAYGO=SLAYDD,DIC(0)="L",DIC("P")=DLAYGO
 . S X=$G(OLAY("O",IEN,".01")) Q:X=""
 . I $G(^BQICARE(DA(4),1,DA(3),30,DA(2),23,DA(1),0))="" S ^BQICARE(DA(4),1,DA(3),30,DA(2),23,DA(1),0)="^90505.321^^"
 . K DO,DD D FILE^DICN
 . S DA=+Y I DA<1 S RESULT="0^Problem Copying Owner Layout To Shared User" Q
 . S IENS=$$IENS^DILF(.DA)
 . M BQIUPD(SLAYDD,IENS)=OLAY("O",IEN)
 I RESULT]"" Q RESULT
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 I $D(ERROR) Q "0^Problem Copying Owner Layout To Shared User"
 Q 1
