BQIPTPNL ;PRXM/HC/ALA-Get Panels for a Patient ; 09 Nov 2005  10:41 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
GET(DATA,DFN,OWNR) ; EP -- BQI GET PANELS BY PATIENT
 ;
 ;Description
 ;   Get a list of all panels that a patient is on
 ;Input
 ;   DFN  - Patient internal entry number
 ;   OWNR - If only valid for a specific owner
 ;
 NEW UID,BQI,PLIEN,PLNM,PLID,X,SHRS
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),BQI=0
 S DATA=$NA(^TMP("BQIPTPNL",UID))
 K @DATA
 ;
 ;Set error trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTPNL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQI)="I00010PANEL_IEN^T00015PANEL_ID^T00120PANEL_NAME^T00250PANEL_DESCRIPTION^I00010OWNER^T00035OWNER_NAME"_$C(30)
 I $G(OWNR)'="" D PNL G DONE
 S OWNR=""
 F  S OWNR=$O(^BQICARE("AB",DFN,OWNR)) Q:OWNR=""  D PNL
DONE ;
 S BQI=BQI+1,@DATA@(BQI)=$C(31)
 Q
 ;
PNL ; Find panels
 S PLIEN=""
 F  S PLIEN=$O(^BQICARE("AB",DFN,OWNR,PLIEN)) Q:PLIEN=""  D
 . I $G(^BQICARE(OWNR,1,PLIEN,40,DFN,0))="" K ^BQICARE("AB",DFN,OWNR,PLIEN) Q
 . NEW DA,IENS,PLID
 . S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 . I $$GET1^DIQ(90505.01,IENS,.13,"I")]"" Q
 . ; Exclude panel if patient was "removed"
 . I $$GET1^DIQ(90505.04,DFN_","_IENS,.02,"I")="R" Q
 . S PLID=$$PLID^BQIUG1(OWNR,PLIEN)
 . S BQI=BQI+1,@DATA@(BQI)=PLIEN_"^"_PLID_"^"_$$GET1^DIQ(90505.01,IENS,.01,"E")_"^"_$$GET1^DIQ(90505.01,IENS,1,"E")_"^"_OWNR_"^"_$$GET1^DIQ(90505,OWNR_",",.01,"E")_$C(30)
 ;
 ;  if patient is on a panel that is shared with the owner, get those panels too
 S SHRS=""
 F  S SHRS=$O(^BQICARE("C",OWNR,SHRS)) Q:SHRS=""  D
 . S PLIEN=""
 . F  S PLIEN=$O(^BQICARE("C",OWNR,SHRS,PLIEN)) Q:PLIEN=""  D
 .. NEW DA,IENS,PLID
 .. S DA(1)=SHRS,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. I $$GET1^DIQ(90505.04,DFN_","_IENS,.01,"I")="" Q
 .. I $$GET1^DIQ(90505.04,DFN_","_IENS,.02,"I")="R" Q
 .. S PLID=$$PLID^BQIUG1(SHRS,PLIEN)
 .. S BQI=BQI+1,@DATA@(BQI)=PLIEN_"^"_PLID_"^"_$$GET1^DIQ(90505.01,IENS,.01,"E")_"^"_$$GET1^DIQ(90505.01,IENS,1,"E")_"^"_SHRS_"^"_$$GET1^DIQ(90505,SHRS_",",.01,"E")_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQI),$D(DATA) S BQI=BQI+1,@DATA@(BQI)=$C(31)
 Q
