BQIPLSH ;PRXM/HC/ALA - Panel Sharing Update ; 07 Nov 2005  3:53 PM
 ;;2.4;ICARE MANAGEMENT SYSTEM;**3**;Apr 01, 2015;Build 5
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
 NEW UID,II,DFN,X,RESULT,OACTION,NDA
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
 NEW DA,X,DINUM,DIC,DIE,DLAYGO,ERROR,Y
 S DA(2)=OWNR,DA(1)=PLIEN,(X,DINUM)=WHO
 S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",30,",DIE=DIC
 S DLAYGO=90505.03,DIC(0)="LN",DIC("P")=DLAYGO
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
 I LTYPE]"" D  I $D(ERROR) Q -1
 . ;Update SHARE LAYOUTS field
 . N DA,IENS,BQISHARE
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=WHO
 . S IENS=$$IENS^DILF(.DA)
 . S BQISHARE(90505.03,IENS,.05)=$S(LTYPE="N":0,1:1)
 . D FILE^DIE("","BQISHARE","ERROR")
 . ;
 . ;Copy Layouts
 . I LTYPE="N" Q
 . D CPLAY
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
CPLAY ;EP -- Copy Owner Layout to Shared User
 ;
 ;Description
 ;  This function copies the layouts from the panel owner to the selected shared user
 ;
 ;N BQIUPD,ERROR,LAYDD,LAYFLD,OLAY,RESULT,SLAYDD,TMPIEN
 ;
 ;Set up dictionary/field values
 ; Templates
 NEW TMPIEN,VWN
 S TMPIEN=0
 I $G(^BQICARE(OWNR,1,PLIEN,4,TMPIEN))'="",$G(^BQICARE(OWNR,1,PLIEN,30,NDA,4,TMPIEN))="" D
 . S ^BQICARE(OWNR,1,PLIEN,30,NDA,4,TMPIEN)=^BQICARE(OWNR,1,PLIEN,4,TMPIEN)
 . F  S TMPIEN=$O(^BQICARE(OWNR,1,PLIEN,4,TMPIEN)) Q:'TMPIEN  D
 .. S TMPNM=$P($G(^BQICARE(OWNR,1,PLIEN,4,TMPIEN,0)),U) Q:TMPNM=""
 .. I TMPNM'[" Default" Q
 .. S ^BQICARE(OWNR,1,PLIEN,30,NDA,4,TMPIEN,0)=^BQICARE(OWNR,1,PLIEN,4,TMPIEN,0)
 ; Patient
 S VWN=0
 I $G(^BQICARE(OWNR,1,PLIEN,20,VWN))'="",$G(^BQICARE(OWNR,1,PLIEN,30,NDA,20,VWN))="" D
 . S ^BQICARE(OWNR,1,PLIEN,30,NDA,20,VWN)=^BQICARE(OWNR,1,PLIEN,20,VWN)
 . F  S VWN=$O(^BQICARE(OWNR,1,PLIEN,20,VWN)) Q:'VWN  D
 .. S ^BQICARE(OWNR,1,PLIEN,30,NDA,20,VWN,0)=^BQICARE(OWNR,1,PLIEN,20,VWN,0)
 ; Reminder
 S VWN=0
 I $G(^BQICARE(OWNR,1,PLIEN,22,VWN))'="",$G(^BQICARE(OWNR,1,PLIEN,30,NDA,22,VWN))="" D
 . S ^BQICARE(OWNR,1,PLIEN,30,NDA,22,VWN)=^BQICARE(OWNR,1,PLIEN,22,VWN)
 . F  S VWN=$O(^BQICARE(OWNR,1,PLIEN,22,VWN)) Q:'VWN  D
 .. S ^BQICARE(OWNR,1,PLIEN,30,NDA,22,VWN,0)=^BQICARE(OWNR,1,PLIEN,22,VWN,0)
 ; Natl Measures
 S VWN=0
 I $G(^BQICARE(OWNR,1,PLIEN,25,VWN))'="",$G(^BQICARE(OWNR,1,PLIEN,30,NDA,25,VWN))="" D
 . S ^BQICARE(OWNR,1,PLIEN,30,NDA,25,VWN)=^BQICARE(OWNR,1,PLIEN,25,VWN)
 . F  S VWN=$O(^BQICARE(OWNR,1,PLIEN,25,VWN)) Q:'VWN  D
 .. S ^BQICARE(OWNR,1,PLIEN,30,NDA,25,VWN,0)=^BQICARE(OWNR,1,PLIEN,25,VWN,0)
 ; Care Management
 S VWN=0
 I $G(^BQICARE(OWNR,1,PLIEN,23,VWN))'="",$G(^BQICARE(OWNR,1,PLIEN,30,NDA,23,VWN))="" D
 . S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,VWN)=^BQICARE(OWNR,1,PLIEN,23,VWN)
 . F  S VWN=$O(^BQICARE(OWNR,1,PLIEN,23,VWN)) Q:'VWN  D
 .. S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,VWN,0)=^BQICARE(OWNR,1,PLIEN,23,VWN,0)
 .. S CVN=0
 .. S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,VWN,1,CVN)=^BQICARE(OWNR,1,PLIEN,23,VWN,1,CVN)
 .. F  S CVN=$O(^BQICARE(OWNR,1,PLIEN,23,VWN,1,CVN)) Q:'CVN  D
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,VWN,1,CVN,0)=^BQICARE(OWNR,1,PLIEN,23,VWN,1,CVN,0)
 ;
 NEW DA,DIK
 S DA=NDA,DA(1)=PLIEN,DA(2)=OWNR,DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",30,"
 D IX1^DIK
 ;
 ;Non-default templates turn into customized
 NEW TMPIEN,TMPNM,TN,TYP,CN,CMN,FILE,CVN
 S TMPIEN=0
 F  S TMPIEN=$O(^BQICARE(OWNR,1,PLIEN,4,TMPIEN)) Q:'TMPIEN  D
 . S TMPNM=$P($G(^BQICARE(OWNR,1,PLIEN,4,TMPIEN,0)),"^",1) Q:TMPNM=""
 . I TMPNM[" Default" Q
 . S TN=$O(^BQICARE(OWNR,15,"B",TMPNM,"")) I TN="" Q
 . S TYP=$P(^BQICARE(OWNR,15,TN,0),"^",2)
 . S CN=$O(^BQI(90506.5,"C",TYP,"")) I CN="" Q
 . S CMN=$P(^BQI(90506.5,CN,0),"^",1)
 . S FILE=$P($G(^BQI(90506.5,CN,2)),"^",5) I FILE="" Q
 . I FILE=90505.3231 D
 .. S CNM=$O(^BQICARE(OWNR,1,PLIEN,30,NDA,23,"B",CMN,""))
 .. I CNM'="" S CVN=CNM I $O(^BQICARE(OWNR,1,PLIEN,30,NDA,23,CVN,1,0))'="" Q
 .. I CNM="" S CVN=$O(^BQICARE(OWNR,1,PLIEN,30,NDA,23,"B"),-1),CVN=CVN+1
 .. ;copy over the template into customized
 .. I $G(^BQICARE(OWNR,1,PLIEN,30,NDA,23,0))="" S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,0)="^90505.123^"_CVN_"^"_CVN
 .. S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,CVN,0)=CMN
 .. S N=0 F  S N=$O(^BQICARE(OWNR,15,TN,1,N)) Q:'N  D
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,CVN,1,N,0)=^BQICARE(OWNR,15,TN,1,N,0)
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,23,CVN,1,0)="^90505.1231^"_N_"^"_N
 . I FILE=90505.322 D
 .. S CMN=$O(^BQICARE(OWNR,1,PLIEN,30,NDA,22,0)) I CMN'="" Q
 .. S N=0 F  S N=$O(^BQICARE(OWNR,15,TN,1,N)) Q:'N  D
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,22,N,0)=^BQICARE(OWNR,15,TN,1,N,0)
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,22,0)="90505.322^"_N_"^"_N
 . I FILE=90505.06 D
 .. S CMN=$O(^BQICARE(OWNR,1,PLIEN,30,NDA,20,0)) I CMN'="" Q
 .. S N=0 F  S N=$O(^BQICARE(OWNR,15,TN,1,N)) Q:'N  D
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,20,N,0)=^BQICARE(OWNR,15,TN,1,N,0)
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,20,0)="90505.06^"_N_"^"_N
 . I FILE=90505.325 D
 .. S CMN=$O(^BQICARE(OWNR,1,PLIEN,30,NDA,25,0)) I CMN'="" Q
 .. S N=0 F  S N=$O(^BQICARE(OWNR,15,TN,1,N)) Q:'N  D
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,25,N,0)=^BQICARE(OWNR,15,TN,1,N,0)
 ... S ^BQICARE(OWNR,1,PLIEN,30,NDA,25,0)="^90505.125^"_N_"^"_N
 ;
 ; Cross-reference
 NEW DA,DIK
 S DA=NDA,DA(1)=PLIEN,DA(2)=OWNR,DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",30,"
 D IX1^DIK
 ;Check Override field
 S:$G(OVRRD)'=1 OVRRD=0
 ;
 ;Initialize Result Variable
 S RESULT=1
 Q
