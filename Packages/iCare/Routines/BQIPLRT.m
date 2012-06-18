BQIPLRT ;PRXM/HC/DLS - Panel List Displays ; 26 Oct 2005  9:24 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
 ; NOTE: There are three types of lists you can generate here.
 ;     You can run:
 ;        LISTS  - to get a combined list (both owned & shared).  
 ;        OWNED  - to get Panels owned by the user.
 ;        SHARED - to get Panels shared by the user (owned by someone else).
 ;
LISTS(DATA,OWNR) ; PEP -- BQI GET PANEL LIST
 ;Description
 ;  Returns a list of panels owned by the user and shared by the user with another owner.
 ;  
 ;Input
 ;  OWNR - DUZ of the panel list owner (if not the current user)
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;
 ;Output
 ;  ^TMP("BQIPLRT") - name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,X,BQII,DA,OWNRNM,OWNRIEN,PLMSG,PLNME,PLIEN,IENS,PLDEFUPD
 N PLAUTO,PLLSTPOP,PLLSTUPD,PLCNT,PLDESC,PLRTS,PLCRBY,PLDATA,PLID,PLSTAT
 N SHSTDT,SHENDT,SHAXCS,AUTOSTAT,PLCRDT,PLDFUPBY,PLPOPBY,PLUPBY
 N BQIPREF,BQIFLAG
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S BQII=0
 S DATA=$NA(^TMP("BQIPLRT",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Default to DUZ if OWNR is not passed in
 S:$G(OWNR)="" OWNR=DUZ
 ;
 D HDR
 ;
 ; If there are no owned or shared panels, don't do anything.
 I '$D(^BQICARE(OWNR,1,"B")),'$D(^BQICARE("C",OWNR)) G DONE
 ;
 ; Get Panels Owned by User
 S OWNRNM=$$GET1^DIQ(90505,OWNR,.01,"E")
 D RET^BQIFLAG(OWNR,.BQIPREF)
 S PLIEN=0,DA(1)=OWNR
 F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 . I $G(^BQICARE(OWNR,1,PLIEN,0))="" K ^BQICARE(OWNR,1,PLIEN) Q
 . S DA=PLIEN,IENS=$$IENS^DILF(.DA)
 . S PLID=$$PLID^BQIUG1(OWNR,PLIEN)
 . D GETDATA(OWNR,PLIEN)
 . S BQII=BQII+1,@DATA@(BQII)=OWNR_PLDATA
 . I $O(^BQICARE(OWNR,1,PLIEN,30,0))'="" D
 .. S @DATA@(BQII)=OWNR_$P(PLDATA,$C(30))_"Y"_$C(30)
 ;
 ; Get Panels Shared with Another Owner
 S (OWNRIEN,PLIEN)=""
 F  S OWNRIEN=$O(^BQICARE("C",OWNR,OWNRIEN)) Q:'OWNRIEN  D
 . F  S PLIEN=$O(^BQICARE("C",OWNR,OWNRIEN,PLIEN)) Q:'PLIEN  D
 .. N DA
 .. S DA(2)=OWNRIEN,DA(1)=PLIEN,DA=OWNR
 .. S IENS=$$IENS^DILF(.DA)
 .. S SHAXCS=$$GET1^DIQ(90505.03,IENS,.02,"I")
 .. S SHSTDT=$$GET1^DIQ(90505.03,IENS,.03,"I")
 .. S SHENDT=$$GET1^DIQ(90505.03,IENS,.04,"I")
 .. ; IF shared user start date is not after today (or null) AND
 .. ; IF shared user  end  date is     after today (or null) AND
 .. ; IF shared user access is not 'I'nactive, THEN proceed.
 .. I SHSTDT'>DT,((SHENDT'<DT)!(SHENDT="")),SHAXCS'="I" D
 ... N DA
 ... S DA=PLIEN,DA(1)=OWNRIEN,IENS=$$IENS^DILF(.DA)
 ... S OWNRNM=$$GET1^DIQ(90505,OWNRIEN,.01,"E")
 ... S PLID=$$PLID^BQIUG1(OWNRIEN,PLIEN)
 ... NEW PLDEFUPD,PLDFUPBY,PLLSTPOP,PLLSTUPD,PLPOPBY,PLUPBY
 ... D GETDATA(OWNRIEN,PLIEN)
 ... S BQII=BQII+1,@DATA@(BQII)=OWNRIEN_$P(PLDATA,$C(30))_SHAXCS_$C(30)
 G DONE
 ;
OWNED(DATA,FAKE)  ;EP - BQI LIST OF OWNED PANELS OF A USER
 ;Description
 ;  Returns a list of panels owned by the user.
 ;  
 ;Input
 ;  DUZ - User internal entry number
 ;
 ;Output
 ;  ^TMP("BQIPLRT") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,X,BQII,DA,OWNRNM,OWNRIEN,PLMSG,PLNME,PLIEN,IENS,PLDEFUPD,PLAUTO,PLLSTPOP,PLLSTUPD
 N PLCNT,PLDESC,PLRTS,PLCRBY,PLDATA,PLID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLRT",UID))
 K ^TMP("BQIPLRT",UID)
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
 I '$D(^BQICARE(DUZ,1,"B")) G DONE
 ;
 S OWNRNM=$$GET1^DIQ(90505,DUZ,.01,"E")
 S PLIEN=0,DA(1)=DUZ
 F  S PLIEN=$O(^BQICARE(DUZ,1,PLIEN)) Q:'PLIEN  D
 . S DA=PLIEN,IENS=$$IENS^DILF(.DA)
 . S PLID=$$PLID^BQIUG1(DUZ,PLIEN)
 . D GETDATA(DUZ,PLIEN)
 . S BQII=BQII+1,@DATA@(BQII)=DUZ_PLDATA
 G DONE
 ;
SHARED(DATA,FAKE) ;EP - BQI LIST OF SHARED PANELS OF A USER
 ;Description
 ;  Returns a list of panels shared by the user with another owner.
 ;  
 ;Input
 ;  DUZ - User internal entry number
 ;
 ;Output
 ;  ^TMP("BQIPLRT") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,X,BQII,DA,OWNRNM,OWNRIEN,PLMSG,PLNME,PLIEN,IENS,PLDEFUPD,PLAUTO,PLLSTPOP,PLLSTUPD
 N PLCNT,PLDESC,PLRTS,PLCRBY,PLDATA,PLID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLRT",UID))
 K @DATA
 ;
 S BQII=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLRT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
 I '$D(^BQICARE("C",DUZ)) G DONE
 ;
 S (OWNRIEN,PLIEN)=""
 F  S OWNRIEN=$O(^BQICARE("C",DUZ,OWNRIEN)) Q:'OWNRIEN  D
 . F  S PLIEN=$O(^BQICARE("C",DUZ,OWNRIEN,PLIEN)) Q:'PLIEN  D
 .. S DA=PLIEN,DA(1)=OWNRIEN,IENS=$$IENS^DILF(.DA)
 .. S OWNRNM=$$GET1^DIQ(90505,OWNRIEN,.01,"E")
 .. S PLID=$$PLID^BQIUG1(OWNRIEN,PLIEN)
 .. D GETDATA(OWNRIEN,PLIEN)
 .. S BQII=BQII+1,@DATA@(BQII)=OWNRIEN_PLDATA
 G DONE
 ;
HDR ;
 N PLSTR
 S PLSTR="I00010OWNER^T00035OWNER_NAME^I00010PANEL_IEN^T00015PANEL_ID^T00120PANEL_NAME^T00250PANEL_DESCRIPTION^T00003FLAGS^I00006TOTAL_PATIENTS^"
 S PLSTR=PLSTR_"D00021DT_DEF_LAST_UPDATED^D00021DT_LAST_POPULATED^D00021DT_PATIENT_LIST_LAST_UPDATED^T00009AUTOPOPULATE_FLAG^T00035CREATED_BY^"
 S PLSTR=PLSTR_"T00001STATUS^T00035DEF_LAST_UPDATED_BY^T00035PAT_LIST_UPDATED_BY^T00035LAST_POPULATED_BY^T00001AUTO_STATUS^T00001SOURCE_TYPE^T00002SHARE_ACCESS"
 S @DATA@(BQII)=PLSTR_$C(30)
 Q
 ;
GETDATA(OWNR,PLIEN) ;EP
 ;Parameters
 ; PLNME    - Panel Name
 ; PLDEFUPD - Date/time panel definition last updated
 ; PLAUTO   - Autorefresh flag
 ; PLLSTPOP - Date/time panel last populated
 ; PLLSTUPD - Date/time patient list last updated
 ; PLUPBY   - Definition last updated by
 ; PLDFUPBY - Patient list last updated by
 ; PLCRDT   - Date/time panel created
 ; PLSTAT   - Status of panel while editing
 ; PLCNT    - Number of patients in panel
 ; PLDESC   - Panel description
 ; PLRTS    - Panel contains patients with flags
 ; PLCRBY   - Panel created by (owner)
 ; AUTOSTAT - Autopopulate status
 N BQITMP
 NEW PLNME,PLDEFUPD,PLAUTO,PLLSTPOP,PLLSTUPD,PLUPBY,PLDFUPBY,PLPOPBY,PLCRDT,PLSTAT,PLCNT
 NEW PLDESC,PLRTS,PLCRBY,AUTOSTAT,SRCTYP
 D GETS^DIQ(90505.01,IENS,".01;.02;.03;.04;.05;.06;.07;.08;.09;.1;.12;.13;1;3.4;3.5;3.6","IE","BQITMP")
 S PLNME=$G(BQITMP(90505.01,IENS,.01,"E"))
 S SRCTYP=$G(BQITMP(90505.01,IENS,.03,"I"))
 S PLDEFUPD=$$FMTE^BQIUL1(BQITMP(90505.01,IENS,.05,"I"))
 S PLAUTO=$G(BQITMP(90505.01,IENS,.06,"I"))
 I $G(BQITMP(90505.01,IENS,.07,"I"))'="" S PLLSTPOP=$$FMTE^BQIUL1(BQITMP(90505.01,IENS,.07,"I"))
 I $G(BQITMP(90505.01,IENS,.09,"I"))'="" S PLLSTUPD=$$FMTE^BQIUL1(BQITMP(90505.01,IENS,.09,"I"))
 S PLUPBY=$G(BQITMP(90505.01,IENS,.04,"E"))
 S PLDFUPBY=$G(BQITMP(90505.01,IENS,.08,"E"))
 S PLPOPBY=$G(BQITMP(90505.01,IENS,3.5,"E"))
 I $G(BQITMP(90505.01,IENS,.02,"I"))'="" S PLCRDT=$$FMTE^BQIUL1(BQITMP(90505.01,IENS,.02,"I"))
 S PLSTAT=$G(BQITMP(90505.01,IENS,.13,"I"))
 S PLCNT=$G(BQITMP(90505.01,IENS,.1,"E"))
 I PLCNT="" S PLCNT=0
 S PLDESC=$G(BQITMP(90505.01,IENS,1,"E"))
 S PLRTS=$G(BQITMP(90505.01,IENS,.12,"E"))
 ;
 NEW DFN
 S DFN=0,BQIFLAG=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D  Q:BQIFLAG
 . I $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)="R" Q
 . S BQIFLAG=$$FPAT^BQIFLAG(DFN,DUZ,.BQIPREF)
 S PLRTS=$S(BQIFLAG:"YES",1:"")
 S PLCRBY=OWNRNM
 S AUTOSTAT=$G(BQITMP(90505.01,IENS,3.4,"I"))
 S PLDATA="^"_OWNRNM_"^"_PLIEN_"^"_PLID_"^"_PLNME_"^"_PLDESC_"^"_PLRTS_"^"_PLCNT_"^"_PLDEFUPD_"^"
 S PLDATA=PLDATA_$G(PLLSTPOP)_"^"_$G(PLLSTUPD)_"^"_PLAUTO_"^"_PLCRBY_"^"_PLSTAT_"^"_PLUPBY_"^"_PLDFUPBY_"^"_PLPOPBY_"^"_AUTOSTAT_"^"_SRCTYP_"^"_$C(30)
 Q
 ;
DONE ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
