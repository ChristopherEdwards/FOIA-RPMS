BQIPLUSR ;PRXM/HC/ALA-User Preferences ; 19 Oct 2005  6:29 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 Q
 ;
OWNR(USR) ;EP -- Check owner
 ;
 ;Description
 ;  Check if this user who has signed into iCare is already
 ;  in ICARE USER File #90505
 ;Input
 ;  DUZ - User internal entry number signed into iCare
 ;Output
 ;   1 - if user exists or if user added okay
 ;   0 - if there was an error adding user
 ;
 I $G(^BQICARE(USR,0))'="" Q 1
 I $D(^BQICARE(USR)),$G(^BQICARE(USR,0))="" D  Q 1
 . S DIE="^BQICARE(",DA=USR,DR=".01///^S X=USR" D ^DIE
 ;
CR ;  Create new entry
 NEW IENARRY,BQIUSR,ERROR
 S IENARRY(1)=USR
 S BQIUSR(90505,"+1,",.01)=USR
 D UPDATE^DIE("","BQIUSR","IENARRY","ERROR")
 I $D(ERROR) Q 0
 Q 1
 ;
USPF(DATA,FAKE) ;EP -- BQI GET USER PREFS
 ;
 ;Description
 ;  Get the user's preferences
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 I '$$OWNR(DUZ) S BMXSEC="Unable to access user record" Q
 ;
 NEW UID,II,COD,NAME,PLIEN,PLNM,PLID,PTSRCH,X,PTVIEW,RCVIEW,CMVIEW,MUVIEW
 NEW CHLOC,FLLOC,TLLOC,IPCVIEW,PNVIEW,PNSIZE,IPTTIP,IPTFIL,IPVTIP,IPVFIL,MPQTIP,MPQFIL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLUSR",UID))
 K @DATA
 ;
 S II=0
 S @DATA@(II)="T00001DEFAULT_VIEW^I00010OWNER^I00099PANEL_IEN^I00010PANEL_ID^T00001PAT_SEARCH^"
 S @DATA@(II)=@DATA@(II)_"I00010PATIENT_VIEW^T00001RECORD_VIEW^T00001CMET_VIEW^T00001EVENT_TIP^"
 S @DATA@(II)=@DATA@(II)_"T00001EVENT_FILTER^T00001TRACKED_TIP^T00001TRACKED_FILTER^"
 S @DATA@(II)=@DATA@(II)_"T00001FOLLOWUP_TIP^T00001FOLLOWUP_FILTER^T00001MU_VIEW^"
 S @DATA@(II)=@DATA@(II)_"T00045CHRT_LOC^T00045FOL_LOC^T00045TEL_LOC^T00002IPC_VIEW^"
 S @DATA@(II)=@DATA@(II)_"T00010PANEL_VIEW^T00001PANEL_SIZE^T00001IPC_PT_TIP^T00001IPC_PT_FILTER^"
 S @DATA@(II)=@DATA@(II)_"T00001IPC_PV_TIP^T00001IPC_PV_FILTER^T00001MPQTIP^T00001MPQFIL"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S PLIEN="",PLID=""
 S COD=$$GET1^DIQ(90505,DUZ_",",.02,"E")
 S NAME=$$GET1^DIQ(90505,DUZ_",",.02,"E")
 S PLNM=$$GET1^DIQ(90505,DUZ_",",.03,"E")
 S OWNR=$$GET1^DIQ(90505,DUZ_",",.04,"I")
 S PTSRCH=$$GET1^DIQ(90505,DUZ_",",.05,"I")
 S PTVIEW=$$GET1^DIQ(90505,DUZ_",",.07,"I") S:PTVIEW="" PTVIEW=$O(^BQI(90506.4,"B","Cover Sheet",""))
 S RCVIEW=$$GET1^DIQ(90505,DUZ_",",.08,"I") S:RCVIEW="" RCVIEW="N"
 S CMVIEW=$$GET1^DIQ(90505,DUZ_",",.09,"I")
 S CMTIP=$$GET1^DIQ(90505,DUZ_",",.1,"I") S:CMTIP="" CMTIP="S"
 S CMFIL=$$GET1^DIQ(90505,DUZ_",",.11,"I") S:CMFIL="" CMFIL="S"
 S TRTIP=$$GET1^DIQ(90505,DUZ_",",.12,"I") S:TRTIP="" TRTIP="S"
 S TRFIL=$$GET1^DIQ(90505,DUZ_",",.13,"I") S:TRFIL="" TRFIL="S"
 S FLTIP=$$GET1^DIQ(90505,DUZ_",",.14,"I") S:FLTIP="" FLTIP="S"
 S FLFIL=$$GET1^DIQ(90505,DUZ_",",.15,"I") S:FLFIL="" FLFIL="S"
 S MUVIEW=$$GET1^DIQ(90505,DUZ_",",.16,"I") S:MUVIEW="" MUVIEW="E"
 S CHLOC=$$GET1^DIQ(90505,DUZ_",",.18,"I")
 S FLLOC=$$GET1^DIQ(90505,DUZ_",",.19,"I")
 S TLLOC=$$GET1^DIQ(90505,DUZ_",",.2,"I")
 S IPCVIEW=$$GET1^DIQ(90505,DUZ_",",.21,"I") S:IPCVIEW="" IPCVIEW="PD"
 S PNVIEW=$$GET1^DIQ(90505,DUZ_",",2.05,"I")
 S PNSIZE=$$GET1^DIQ(90505,DUZ_",",2.06,"I") S:PNSIZE="" PNSIZE="N"
 S IPTTIP=$$GET1^DIQ(90505,DUZ_",",2.07,"I") S:IPTTIP="" IPTTIP="S"
 S IPTFIL=$$GET1^DIQ(90505,DUZ_",",2.08,"I") S:IPTFIL="" IPTFIL="S"
 S IPVTIP=$$GET1^DIQ(90505,DUZ_",",2.09,"I") S:IPVTIP="" IPVTIP="S"
 S IPVFIL=$$GET1^DIQ(90505,DUZ_",",2.1,"I") S:IPVFIL="" IPVFIL="S"
 S MPQTIP=$$GET1^DIQ(90505,DUZ_",",2.11,"I") S:MPQTIP="" MPQTIP="S"
 S MPQFIL=$$GET1^DIQ(90505,DUZ_",",2.12,"I") S:MPQFIL="" MPQFIL="S"
 I PTSRCH="" S PTSRCH="A"
 I OWNR="" S OWNR=DUZ
 ;
 I PLNM'="" D
 . NEW DIC,DA
 . S DA(1)=OWNR,DIC="^BQICARE("_DA(1)_",1,",X=PLNM,DIC(0)="Z"
 . D ^DIC
 . S PLIEN=+Y
 . S PLID=$$PLID^BQIUG1(OWNR,PLIEN)
 ;
 S II=II+1,@DATA@(II)=COD_U_OWNR_U_PLIEN_U_PLID_U_PTSRCH_U_PTVIEW_U_RCVIEW_U_CMVIEW_U
 S @DATA@(II)=@DATA@(II)_CMTIP_U_CMFIL_U_TRTIP_U_TRFIL_U_FLTIP_U_FLFIL_U_MUVIEW_U
 S @DATA@(II)=@DATA@(II)_CHLOC_U_FLLOC_U_TLLOC_U_IPCVIEW_U_PNVIEW_U_PNSIZE_U_IPTTIP_U
 S @DATA@(II)=@DATA@(II)_IPTFIL_U_IPVTIP_U_IPVFIL_U_MPQTIP_U_MPQFIL_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
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
SVUP(DATA,TYPE,PARMS) ;EP -- BQI SET USER PREFS
 ; (DATA,TYPE,VIEW,OWNR,PLIEN,CMVIEW,SEARCH,PTVIEW,RCVIEW,CMTIP,CMFIL,TRTIP,TRFIL,FLTIP,FLFIL,MUVIEW,CHLOC,FLLOC,TLLOC,IPCVIEW,PNVIEW,PNSIZE,IPTTIP,IPTFIL,IPVTIP,IPVFIL) ;EP -- BQI SET USER PREFS
 ;
 ; Input
 ;  TYPE   - the type of save (S-Startup View, P-Patient View, CE-CMET Events,
 ;           CT-CMET Tracked, CF-CMET Followups,PN-Panel View,IP-Pat Det Tips/Filters,IR-Prv Det Tips/Filters)
 ;  VIEW   - the default view code
 ;  OWNR   - the owner
 ;  PLIEN  - the panel ien (if default view is specified panel)
 ;  CMVIEW - the default CMET view (if default view is CMET or Split View CMET)
 ;  SEARCH - Patient search criteria
 ;  PTVIEW - Patient View opens with this tab
 ;  RCVIEW - View is opened maximized or minimized
 ;  CMTIP  - Queued Tip show or hide
 ;  CMFIL  - Queued Filter show or hide
 ;  TRTIP  - Tracked Tip show or hide
 ;  TRFIL  - Tracked Filter show or hide
 ;  FLTIP  - Followup Tip show or hide
 ;  FLFIL  - Followup Filter show or hide
 ;  MUVIEW - the default MU view (if default view is MU or Split MU)
 ;  CHLOC  - DEFAULT CHART REV LOCATION
 ;  FLLOC  - DEFAULT FOLLOWUP LTR LOCATION
 ;  TLLOC  - DEFAULT TELEPHONE LOCATION
 ;  IPCVIEW - DEFAULT IPC View (if default view is IPC or SIPC)
 ;  PNVIEW - Panel View opens with this tab
 ;  PNSIZE - Panel Size is opened maximized or minimized
 ;  IPTTIP - IPC Patient Detail Tip show or hide
 ;  IPTFIL - IPC Patient Detail Filter show or hide
 ;  IPVTIP - IPC Provider Detail Tip show or hide
 ;  IPVFIL - IPC Provider Detail Filter show or hide
 ;  MPQTIP - MU PCQ Tips show or hide
 ;  MPQFIL - MU PCQ Filters show or hide
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Assumes DUZ the user signed onto iCare
 ;
 NEW VIEW,OWNR,PLIEN,CMVIEW,SEARCH,PTVIEW,RCVIEW,CMTIP,CMFIL,TRTIP,TRFIL,FLTIP,FLFIL,MUVIEW,CHLOC,FLLOC,TLLOC,IPCVIEW,PNVIEW,PNSIZE,IPTTIP,IPTFIL,IPVTIP,IPVFIL
 NEW UID,II,X,BJ,MPQTIP,MPQFIL
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLUSR",UID))
 K @DATA
 ;
 I '$$OWNR(DUZ) S BMXSEC="There is a problem with your entry." Q
 ;
 S II=0
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S VIEW=$G(VIEW,""),OWNR=$G(OWNR,""),PLIEN=$G(PLIEN,""),CMVIEW=$G(CMVIEW,""),SEARCH=$G(SEARCH,"")
 S PTVIEW=$G(PTVIEW,""),RCVIEW=$G(RCVIEW,""),CMTIP=$G(CMTIP,""),CMFIL=$G(CMFIL,""),TRTIP=$G(TRTIP,"")
 S TRFIL=$G(TRFIL,""),FLTIP=$G(FLTIP,""),FLFIL=$G(FLFIL),MUVIEW=$G(MUVIEW),CHLOC=$G(CHLOC,""),FLLOC=$G(FLLOC,"")
 S TLLOC=$G(TLLOC,""),IPCVIEW=$G(IPCVIEW,""),PNVIEW=$G(PNVIEW,""),PNSIZE=$G(PNSIZE,""),IPTTIP=$G(IPTTIP,"")
 S IPTFIL=$G(IPTFIL,""),IPVTIP=$G(IPVTIP,""),IPVFIL=$G(IPVFIL,""),TYPE=$G(TYPE,""),PARMS=$G(PARMS,"")
 S MPQTIP=$G(MPQTIP,""),MPQFIL=$G(MPQFIL,"")
 ;
 ;Re-Assemble PARMS list string
 I PARMS="" D
 . N LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 ;Define variables from PARMS string
 F BJ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 .N PDATA,NAME,VALUE,BP,BV
 .S PDATA=$P(PARMS,$C(28),BJ) Q:PDATA=""
 .S NAME=$P(PDATA,"=",1) Q:NAME=""
 .S VALUE=$P(PDATA,"=",2,99) Q:VALUE=""
 .F BP=1:1:$L(VALUE,$C(29)) S BV=$P(VALUE,$C(29),BP),@NAME=$G(@NAME)_$S(BP=1:"",1:$C(29))_BV
 ;
 S:PTVIEW="" PTVIEW=$O(^BQI(90506.4,"B","Cover Sheet",""))
 S:RCVIEW="" RCVIEW="N"
 ;
 ;Convert Default View back to internal
 I VIEW]"" D
 . N X,Y,DIC
 . S X=VIEW,DIC="^BQI(90506.7," D ^DIC
 . I +Y>0 S VIEW=+Y
 ;
 ;Save Startup View information
 I TYPE="S" D
 . S BQIUPD(90505,DUZ_",",.02)=VIEW
 . S BQIUPD(90505,DUZ_",",.05)=SEARCH
 . S BQIUPD(90505,DUZ_",",.16)=MUVIEW
 . ;
 . ;Save default panel information
 . I $G(PLIEN)'="" D
 .. NEW DA,IENS
 .. S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505,DUZ_",",.03)=$$GET1^DIQ(90505.01,IENS,.01,"E")
 .. S BQIUPD(90505,DUZ_",",.04)=OWNR
 . ;
 . ;Save the Default CMET view
 . S:CMVIEW]"" BQIUPD(90505,DUZ_",",.09)=CMVIEW
 . ;
 . ;Save the Default IPC view
 . S:IPCVIEW]"" BQIUPD(90505,DUZ_",",.21)=IPCVIEW
 ;
 ;Save Patient View information
 I TYPE="P" D
 . S BQIUPD(90505,DUZ_",",.07)=PTVIEW
 . S BQIUPD(90505,DUZ_",",.08)=RCVIEW
 . S BQIUPD(90505,DUZ_",",.18)=CHLOC
 . S BQIUPD(90505,DUZ_",",.19)=FLLOC
 . S BQIUPD(90505,DUZ_",",.2)=TLLOC
 ;
 ;Save Panel View information
 I TYPE="PN" D
 . S BQIUPD(90505,DUZ_",",2.05)=PNVIEW
 . S BQIUPD(90505,DUZ_",",2.06)=PNSIZE
 ;
 ;Save CMET Events information
 I TYPE="CE" D
 . S BQIUPD(90505,DUZ_",",.1)=CMTIP
 . S BQIUPD(90505,DUZ_",",.11)=CMFIL
 ;
 ;Save CMET Tracked Events information
 I TYPE="CT" D
 . S BQIUPD(90505,DUZ_",",.12)=TRTIP
 . S BQIUPD(90505,DUZ_",",.13)=TRFIL
 ;
 ;Save CMET Followup Events information
 I TYPE="CF" D
 . S BQIUPD(90505,DUZ_",",.14)=FLTIP
 . S BQIUPD(90505,DUZ_",",.15)=FLFIL
 ;
 ;Save Patient Detail Tips/Filters
 I TYPE="IP" D
 . S BQIUPD(90505,DUZ_",",2.07)=IPTTIP
 . S BQIUPD(90505,DUZ_",",2.08)=IPTFIL
 ;
 ;Save Provider Detail Tips/Filters
 ;
 I TYPE="IR" D
 . S BQIUPD(90505,DUZ_",",2.09)=IPVTIP
 . S BQIUPD(90505,DUZ_",",2.1)=IPVFIL
 ;
 ;Save MU PCQ Tips/Filters
 I TYPE="MPQ" D
 . S BQIUPD(90505,DUZ_",",2.11)=MPQTIP
 . S BQIUPD(90505,DUZ_",",2.12)=MPQFIL
 ;
 K ERROR
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 S II=II+1
 I '$D(ERROR) S @DATA@(II)="1"_$C(30)
 I $D(ERROR) S @DATA@(II)="-1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
UGVMCH(DATA,FAKE) ;EP -- BQI GET USER VERSION
 ;
 ;Description
 ;  Determine if user iCare version does not match iCare server version
 ;  
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  Returns user GUI version, server version, and whether versions match (1-Match/0-Do Not Match)
 ;          
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 NEW UID,II,BQIDA,MVRSN,UVRSN,SVRSN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLUSR",UID))
 K @DATA
 ;
 I '$$OWNR(DUZ) S BMXSEC="There is a problem with your entry." Q
 ;
 S II=0
 S @DATA@(II)="T00001MATCHING_VERSION^T00020USER_VERSION^T00020SERVER_VERSION"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S BQIDA=$$SPM^BQIGPUTL()
 ;
 S UVRSN=$$GET1^DIQ(90505,DUZ_",",.17,"E")
 S SVRSN=$$GET1^DIQ(90508,BQIDA_",",.08,"E")
 S MVRSN=0 I UVRSN=SVRSN S MVRSN=1
 ;
 S II=II+1,@DATA@(II)=MVRSN_U_UVRSN_U_SVRSN_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
USVMCH(DATA,FAKE) ;EP -- BQI SET USER VERSION
 ;
 ;Description
 ;  Set the user's iCare GUI version to match the iCare server GUI version
 ;  
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  Returns 1-Successful save/-1 - Unsuccessful save
 ;          
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 NEW UID,II,BQIDA,SVRSN,BQIUPD,ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLUSR",UID))
 K @DATA
 ;
 I '$$OWNR(DUZ) S BMXSEC="There is a problem with your entry." Q
 ;
 S II=0
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLUSR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S BQIDA=$$SPM^BQIGPUTL()
 S SVRSN=$$GET1^DIQ(90508,BQIDA_",",.08,"E")
 ;
 S BQIUPD(90505,DUZ_",",.17)=SVRSN
 ;
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 S II=II+1
 I '$D(ERROR) S @DATA@(II)="1"_$C(30)
 I $D(ERROR) S @DATA@(II)="-1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
