BQIPLCR ;PRXM/HC/ALA-Create Panel Functions ; 18 Oct 2005  3:45 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
APTM(DFN) ;EP - Add patient record manually
 NEW DIC,DIE,BQIPTUP,IENS,DA
 S DA(2)=OWNR,DA(1)=PLIEN
 S (X,DINUM)="`"_DFN
 S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",40,",DIC(0)="LN"
 S DLAYGO=90505.04,DIC(0)="LN"
 I '$D(^BQICARE(DA(2),1,DA(1),40,0)) S ^BQICARE(DA(2),1,DA(1),40,0)="^90505.04P^^"
 D ^DIC
 I +Y=-1 S RESULT=-1 Q
 ;  Update the user for flags for this patient
 I '$D(^BQICARE(DA(2),1,"AB",DFN)) D UPU^BQIFLAG(DFN,OWNR)
 ;  Update the patient record in panel
 S DA=DFN,IENS=$$IENS^DILF(.DA)
 S BQIPTUP(90505.04,IENS,.02)="A"
 S BQIPTUP(90505.04,IENS,.03)=DUZ
 S BQIPTUP(90505.04,IENS,.04)=$$NOW^XLFDT()
 S BQIPTUP(90505.04,IENS,.08)=$S($$FLG^BQIULPT(OWNR,PLIEN,DFN)="Y":1,1:0)
 D FILE^DIE("","BQIPTUP","ERROR")
 I $D(ERROR) S RESULT=-1 Q
 S RESULT=1
 Q
 ;
RPTM(DFN) ;EP - Remove patient record manually
 NEW DA,IENS,BQIPTUP
 S DA(2)=OWNR,DA(1)=PLIEN
 S DA=DFN,IENS=$$IENS^DILF(.DA)
 S BQIPTUP(90505.04,IENS,.02)="R"
 S BQIPTUP(90505.04,IENS,.05)=DUZ
 S BQIPTUP(90505.04,IENS,.06)=$$NOW^XLFDT()
 S BQIPTUP(90505.04,IENS,.08)=0
 D FILE^DIE("","BQIPTUP","ERROR")
 I $D(ERROR) S RESULT=-1 Q
 S RESULT=1
 Q
 ;
APT(DFN) ;EP - Add patient
 NEW DIC,DIE,BQIPTUP,DA,IENS,X
 S DA(2)=OWNR,DA(1)=PLIEN,(X,DINUM)=DFN
 S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",40,",DIE=DIC
 S DLAYGO=90505.04,DIC(0)="L",DIC("P")=DLAYGO
 I '$D(^BQICARE(DA(2),1,DA(1),40,0)) S ^BQICARE(DA(2),1,DA(1),40,0)="^90505.04P^^"
 K DO,DD D FILE^DICN
 I +Y=-1 Q
 S DA=+Y,IENS=$$IENS^DILF(.DA)
 S BQIPTUP(90505.04,IENS,.07)=$$NOW^XLFDT()
 D FILE^DIE("","BQIPTUP","ERROR")
 ;  Update the user for flags for this patient
 D UPU^BQIFLAG(DFN,OWNR)
 Q
 ;
DPT(DFN) ;EP - Delete patient
 ;
 ;Input
 ;  DFN - Patient internal entry number
 NEW DIK,DA
 S DA(2)=OWNR,DA(1)=PLIEN
 S DA=DFN,DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",40,"
 D ^DIK
 Q
 ;
CNTP(OWNR,PLIEN) ;EP - Count patients and file the total
 ;
 ;Input
 ;  OWNR  - Owner of the panel
 ;  PLIEN - Panel internal entry number
 ;
 NEW DA,PIENS,DFN,IENS,CNT,BQIUP,SFLG
 S DA(1)=OWNR,DA=PLIEN,PIENS=$$IENS^DILF(.DA)
 S DFN=0,CNT=0,SFLG=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=DFN,IENS=$$IENS^DILF(.DA)
 . I $$GET1^DIQ(90505.04,IENS,.02,"I")="R" Q
 . S CNT=CNT+1
 . ;  Check for sensitive patient
 . I $$SENS^BQIULPT(DFN)="Y" S SFLG=1
 . ;  Set flags for patient
 . D UPU^BQIFLAG(DFN,OWNR)
 ;
 S BQIUP(90505.01,PIENS,.1)=CNT
 S BQIUP(90505.01,PIENS,.07)=$$NOW^XLFDT()
 S BQIUP(90505.01,PIENS,3.5)=DUZ
 S BQIUP(90505.01,PIENS,3.6)=SFLG
 D FILE^DIE("I","BQIUP")
 ;
 ; Count flags for panel
 D CNTP^BQIFLG(OWNR,PLIEN)
 Q
 ;
CRPNL(DATA,OWNR,PLIEN,PLNM,PLDES,SRCNM,SRC,FSOURCE,AUFL,STATUS,ASSOC) ; Create/Update a new panel
 ; EP - BQI SET PANEL DEF
 ; Description
 ;   Adds/updates a panel using the user defined panel name and description.
 ;   If no name is passed, generates a temporary name which is a composite
 ;   of "TEMP PANEL " and the last assigned panel ien plus 1.
 ;   If no Panel IEN is passed then it generates a new one.
 ; Input:
 ;   OWNR    - Owner of the panel
 ;   PLIEN   - Panel internal entry number (if blank, a new panel is being created)
 ;   PLNM    - User defined panel name (optional)
 ;   PLDES   - User defined panel description (optional)
 ;   SRCNM   - Source name (optional)
 ;   SRC     - Source type (optional)
 ;   FSOURCE - Filter source name (optional)
 ;   AUFL    - Autopopulate flag
 ;   STATUS  - I=in progress, T=temporary, @=remove status flag
 ;   ASSOC   - associated panel IEN (either existing to TEMP or vice versa), @=remove association
 ; Output:
 ;   PLIEN   - panel IEN
 ;   PLID    - panel ID (owner and panel ien)
 ;   PLNM    - panel name
 ; or
 ;   BMXSEC - if record can't be locked or if $D(ERROR)
 ;            when filing or M error encountered
 ;
 N UID,X,BQII,PLID,TMP
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLCR",UID))
 K ^TMP("BQIPLCR",UID)
 ;
 S AUFL=$G(AUFL),SRCNM=$G(SRCNM),SRC=$G(SRC),FSOURCE=$G(FSOURCE)
 S PLNM=$G(PLNM),PLDES=$G(PLDES),PLIEN=$G(PLIEN),STATUS=$G(STATUS)
 S ASSOC=$G(ASSOC)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLCR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create owner if new to iCare - If unable to do so - error
 I '$$OWNR^BQIPLUSR(OWNR) S BMXSEC="Unable to create panel" Q
 ;
 ; Check that panel name is unique
 I PLNM'="" D  Q:$G(BMXSEC)'=""
 . N DA,IENS,ERROR
 . S DA(1)=OWNR,DA=""
 . S IENS=$$IENS^DILF(.DA)
 . S TMP=$$FIND1^DIC(90505.01,IENS,"X",PLNM,"","","ERROR")
 . I TMP=0 Q  ; Name not currently in use
 . I PLIEN=TMP Q  ; Name in use on the panel being edited
 . S BMXSEC="Panel name already exists" ; Name in use on another panel
 . Q
 ;
 ; Create header record
 S BQII=0,^TMP("BQIPLCR",UID,BQII)="I00010PANEL_IEN^T00020PANEL_ID^T00120PANEL_NAME"_$C(30)
 ;
 ;If no panel IEN entered, assign a new one
 I PLIEN="" D  Q:$G(BMXSEC)'=""
 . L +^BQICARE(OWNR,1,0):5
 . I '$T S BMXSEC="Unable to create panel" Q  ; Error - unable to assign next panel IEN
 . I '$D(^BQICARE(OWNR,1,0)) S ^BQICARE(OWNR,1,0)="^90505.01^^"
 . ;If no panel name entered, assign a temporary name
 . I PLNM="" D
 .. N PLN
 .. S PLN=$P(^BQICARE(OWNR,1,0),"^",3)+1
 .. S PLNM=$$TMPNM(PLN)
 .. I $D(^BQICARE(OWNR,1,"B",PLNM)) D
 ... S PLN=$O(^BQICARE(OWNR,1,"B","TEMP PANEL A"),-1)
 ... S PLN=$P(PLNM,"TEMP PANEL ",2)+1,PLNM=$$TMPNM(PLN)
 . ;Filing is included in structured do to allow locks to frame the
 . ;assignment of the IEN and the record filing
 . D FILE
 . ;
 . ;Copy User Templates into Panel
 . D TMPL(OWNR,PLIEN)
 . ;
 . L -^BQICARE(OWNR,1,0)
 D UPD Q:$G(BMXSEC)'=""
 G DONE
 ;
FILE ;File new panel
 N DA,X,DINUM,DIC,DIE,DLAYGO
 S DA(1)=OWNR,X=PLNM,DLAYGO=90505.01
 S DIC="^BQICARE("_DA(1)_",1,",DIE=DIC
 S DIC(0)="L",DIC("P")=DLAYGO
 K DO,DD D FILE^DICN
 S (DA,PLIEN)=+Y
 I PLIEN=-1 S BMXSEC="Error encountered while filing panel." Q
 ;I $G(ASSOC)'="" D CPY^BQIPLCP(OWNR,ASSOC,.PLIEN,1)
 I $G(ASSOC)'="" D CPY(OWNR,PLIEN,ASSOC)
 Q
 ;
UPD ;  Update panel definition values
 NEW DA,IENS,BQIPLUP,ERROR
 S DA(1)=OWNR,DA=PLIEN
 S IENS=$$IENS^DILF(.DA)
 ;
 D CHK
 ;
 I $$GET1^DIQ(90505.01,IENS,.02,"I")="" S BQIPLUP(90505.01,IENS,.02)=$$NOW^XLFDT()
 S BQIPLUP(90505.01,IENS,.04)=DUZ
 S BQIPLUP(90505.01,IENS,.05)=$$NOW^XLFDT()
 S BQIPLUP(90505.01,IENS,3.7)=DUZ(2)
 ;
 I ASSOC'="" S OPLNM=$P(^BQICARE(OWNR,1,ASSOC,0),U,1)
 I ASSOC="" S OPLNM=$$GET1^DIQ(90505.01,IENS,.01,"E")
 ;
 I PLNM]"" D
 . I OPLNM="" S BQIPLUP(90505.01,IENS,.01)=PLNM Q
 . S BQIPLUP(90505.01,IENS,.01)=PLNM
 . ;  Check if panel is a specified panel and update with new panel name
 . I $D(^BQICARE("SPNL",OPLNM,OWNR)) S BQIPLUP(90505,OWNR_",",.03)=PLNM
 . ;  Check if any filters have this panel name
 . I STATUS="T"!(ASSOC'="") Q
 . NEW PLIDEN,TUSR,TPNL,TN,NPLIDEN,TNN
 . S PLIDEN=OWNR_$C(26)_OPLNM,TUSR="",NPLIDEN=OWNR_$C(26)_PLNM
 . F  S TUSR=$O(^BQICARE("AD",PLIDEN,TUSR)) Q:TUSR=""  D
 .. S TPNL=""
 .. F  S TPNL=$O(^BQICARE("AD",PLIDEN,TUSR,TPNL)) Q:TPNL=""  D
 ... S TN=""
 ... F  S TN=$O(^BQICARE("AD",PLIDEN,TUSR,TPNL,TN)) Q:TN=""  D
 .... I $P(^BQICARE(TUSR,1,TPNL,15,TN,0),U,2)=PLIDEN D  Q
 ..... S $P(^BQICARE(TUSR,1,TPNL,15,TN,0),U,2)=NPLIDEN
 ..... K ^BQICARE("AD",PLIDEN,TUSR,TPNL,TN)
 ..... S ^BQICARE("AD",NPLIDEN,TUSR,TPNL,TN)=""
 .... S TNN=0
 .... F  S TNN=$O(^BQICARE(TUSR,1,TPNL,15,TN,1,TNN)) Q:'TNN  D
 ..... I $P(^BQICARE(TUSR,1,TPNL,15,TN,1,TNN,0),U,1)=PLIDEN D
 ...... S $P(^BQICARE(TUSR,1,TPNL,15,TN,1,TNN,0),U,1)=NPLIDEN
 ...... K ^BQICARE(TUSR,1,TPNL,15,TN,1,"B",PLIDEN,TNN)
 ...... S ^BQICARE(TUSR,1,TPNL,15,TN,1,"B",NPLIDEN,TNN)=""
 ;
 I PLNM="" D
 . I ASSOC'="" S PLNM=OPLNM
 ;
 I PLDES]"" S BQIPLUP(90505.01,IENS,1)=PLDES
 I SRC]"" S BQIPLUP(90505.01,IENS,.03)=SRC
 I SRCNM]"" S BQIPLUP(90505.01,IENS,.11)=SRCNM
 I FSOURCE]"" S BQIPLUP(90505.01,IENS,.14)=FSOURCE
 I AUFL]"" S BQIPLUP(90505.01,IENS,.06)=AUFL
 I STATUS]"" S BQIPLUP(90505.01,IENS,.13)=STATUS
 I ASSOC]"" S BQIPLUP(90505.01,IENS,.15)=ASSOC
 D FILE^DIE("","BQIPLUP","ERROR")
 I $D(ERROR) S BMXSEC="Error encountered while filing panel." Q
 ;
 ; Send notification
 I $G(STATUS)'="T" D
 . NEW TEXT
 . I OPLNM'=PLNM S TEXT="Panel name changed from "_OPLNM_" to "_PLNM_"."
 . E  S TEXT="Panel Definition for "_OPLNM_" has been modified."
 . D UPD^BQINOTF(OWNR,PLIEN,TEXT)
 ;
 ; Return panel IEN, ID, and NAME on success
 S PLID=$$PLID^BQIUG1(OWNR,PLIEN)
 S BQII=BQII+1,^TMP("BQIPLCR",UID,BQII)=PLIEN_"^"_PLID_"^"_PLNM_$C(30)
 Q
 ;
TMPNM(NM) ;EP -- Return temporary panel name
 S NM=$E("0000000000",1,10-$L(NM))_NM
 Q "TEMP PANEL "_NM
 ;
ERR ;
 L -^BQICARE(OWNR,1,0)
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 ; If a temporary panel was created when an error occurred, delete it
 I $G(ASSOC)'="" D
 . NEW DA,DIK
 . S DA(1)=OWNR,DA=PLIEN
 . S DIK="^BQICARE("_DA(1)_",1,"
 . D ^DIK
 Q
 ;
DONE ; -- exit code
 S BQII=BQII+1,^TMP("BQIPLCR",UID,BQII)=$C(31)
 Q
 ;
CHK ;  Check Source Type changed to Manual
 ;  If the panel is already Manual and is changed to manual, quit
 I $$GET1^DIQ(90505.01,IENS,.03,"I")="M",SRC="M" Q
 ;  If the panel is not manual and is not being changed to manual, quit
 I $$GET1^DIQ(90505.01,IENS,.03,"I")'="M",SRC'="M" Q
 ;  If changing a panel to a manual from any other definition type,
 ;  set all users not having a manual flag, the manual flag of 'Add'.
 NEW DFN
 S DFN=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . I $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)'="" Q
 . S $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)="A"
 . S $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,4)=$$NOW^XLFDT()
 Q
 ;
CPY(OWNR,PLIEN,OPLIEN) ;EP - Copy a temporary panel
 S $P(^BQICARE(OWNR,1,PLIEN,0),U,2,14)=$P(^BQICARE(OWNR,1,OPLIEN,0),U,2,14)
 ;
 ; Copy PANEL DESCRIPTION
 I $D(^BQICARE(OWNR,1,OPLIEN,1)) M ^BQICARE(OWNR,1,PLIEN,1)=^BQICARE(OWNR,1,OPLIEN,1)
 ;
 ; Copy Panel information
 I $D(^BQICARE(OWNR,1,OPLIEN,3)) M ^BQICARE(OWNR,1,PLIEN,3)=^BQICARE(OWNR,1,OPLIEN,3)
 ;
 ; Copy GENERATED DESCRIPTION
 I $D(^BQICARE(OWNR,1,OPLIEN,5)) M ^BQICARE(OWNR,1,PLIEN,5)=^BQICARE(OWNR,1,OPLIEN,5)
 ;
 ; Copy PARAMETER DEFINITION
 I $D(^BQICARE(OWNR,1,OPLIEN,10)) M ^BQICARE(OWNR,1,PLIEN,10)=^BQICARE(OWNR,1,OPLIEN,10)
 ;
 ; Copy FILTER DEFINITION
 I $D(^BQICARE(OWNR,1,OPLIEN,15)) M ^BQICARE(OWNR,1,PLIEN,15)=^BQICARE(OWNR,1,OPLIEN,15)
 ;
 ; Copy CUSTOMIZED VIEW
 I $D(^BQICARE(OWNR,1,OPLIEN,20)) M ^BQICARE(OWNR,1,PLIEN,20)=^BQICARE(OWNR,1,OPLIEN,20)
 ;
 ; Copy SHARED USERS
 I $D(^BQICARE(OWNR,1,OPLIEN,30)) M ^BQICARE(OWNR,1,PLIEN,30)=^BQICARE(OWNR,1,OPLIEN,30)
 ;
 ; Copy PATIENT LIST
 I $D(^BQICARE(OWNR,1,OPLIEN,40)) M ^BQICARE(OWNR,1,PLIEN,40)=^BQICARE(OWNR,1,OPLIEN,40)
 ;
 ; Update cross references for merged entries
 S DIK="^BQICARE("_DA(1)_",1,"
 D IX^DIK
 Q
 ;
 ;Copy template information into new panels
TMPL(OWNR,PLIEN) ;EP - Copy template information into new panel
 ;
 I $G(OWNR)="" Q  ;Quit if no owner
 I $G(PLIEN)="" Q  ;Quit if no panel ien
 ;
 ;Quit if template node has already been set up
 I $O(^BQICARE(OWNR,1,PLIEN,4,0))]"" Q
 ;
 ;Quit if user has no defined templates
 I $O(^BQICARE(OWNR,15,0))="" Q
 ;
 ;Set top node
 I '$D(^BQICARE(OWNR,1,PLIEN,4,0)) S ^BQICARE(OWNR,1,PLIEN,4,0)="^90505.14^^"
 ;
 ;Loop through user templates and move to panel
 S IEN=0 F  S IEN=$O(^BQICARE(OWNR,15,IEN)) Q:'IEN  D
 . ;
 . N BQDATA,DA,DIC,ERROR,IENS,TMPLT,TMPLN,X,Y
 . ;
 . ;Get the template
 . S DA(1)=OWNR,DA=IEN
 . S IENS=$$IENS^DILF(.DA)
 . S TMPLN=$$GET1^DIQ(90505.015,IENS,.01,"E")
 . ;
 . ;Get the code
 . S TMPLT=$$GET1^DIQ(90505.015,IENS,.02,"I")
 . ;
 . ;Lookup/Define new entry
 . S DA(2)=OWNR,DA(1)=PLIEN
 . S X=TMPLN
 . S DIC(0)="L",DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",4,"
 . D ^DIC
 . S:+Y>0 DA=+Y
 . S IENS=$$IENS^DILF(.DA)
 . ;
 . ;Insert TYPE
 . S BQDATA(90505.14,IENS,".02")=TMPLT
 . ;
 . ;File update
 . I $D(BQDATA) D FILE^DIE("","BQDATA","ERROR")
