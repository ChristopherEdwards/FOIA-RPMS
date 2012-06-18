BQIPLDL ;PRXM/HC/DLS - Delete Panel ; 14 Nov 2005  10:44 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN) ; EP - BQI DELETE PANEL
 ;Description
 ;  DELETE a panel (given an Owner IEN and a Panel IEN).
 ;  Panel must be owned by the user.
 ;
 ;Input
 ;  OWNR - Panel Owner IEN
 ;  PLIEN - Panel IEN
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQIPLDL"))
 ;
 N UID,X,BQII,RSLT,DA,DIK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLDL",UID))
 K @DATA
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLDL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
CHKS ; Do some checks here before proceeding.
 ;
 ; Make sure that the user and owner are the same.
 I DUZ'=OWNR D  Q:$G(BMXSEC)'=""
 . I $P(^BQICARE(OWNR,1,PLIEN,0),"^",13)="T" Q
 . S RSLT=0,BMXSEC="User Does Not Own Panel - Panel Not Deleted" G DONE
 ;
 ; Check if this panel is used as a filter
 NEW PLIDEN,POWNR,PPLIEN,TEXT,TEXT1
 S PLIDEN=OWNR_$C(26)_$P(^BQICARE(OWNR,1,PLIEN,0),"^",1)
 I $D(^BQICARE("AD",PLIDEN)) D  Q:$G(BMXSEC)'=""
 . S TEXT="Panel is used as a filter for: ",TEXT1=""
 . S POWNR=""
 . F  S POWNR=$O(^BQICARE("AD",PLIDEN,POWNR)) Q:POWNR=""  D
 .. S PPLIEN=""
 .. F  S PPLIEN=$O(^BQICARE("AD",PLIDEN,POWNR,PPLIEN)) Q:PPLIEN=""  D
 ... S TEXT1=TEXT1_$P(^BQICARE(POWNR,1,PPLIEN,0),U,1)_" (owned by "_$P(^VA(200,POWNR,0),U,1)_")"_";"
 . S TEXT1=$$TKO^BQIUL1(TEXT1,";")
 . S BMXSEC=TEXT_TEXT1_" - Cannot delete."
 ;
 ; Remove the panel.
 S DA=PLIEN,DA(1)=OWNR
 NEW TEXT,IENS
 S IENS=$$IENS^DILF(.DA)
 S TEXT="Panel "_$$GET1^DIQ(90505.01,IENS,.01,"E")_" has been deleted."
 ;  Send notification
 I $P(^BQICARE(OWNR,1,PLIEN,0),"^",13)'="T" D UPD^BQINOTF(OWNR,PLIEN,TEXT)
 ;
 S DIK="^BQICARE("_DA(1)_",1,"
 D ^DIK
 S RSLT=1
 ;
 ;  Refresh panel list
 D EVT^BQIPLRF("BQI REFRESH PANEL LIST",$$PLID^BQIUG1(OWNR,PLIEN))
 ; Drop down to DONE...
 ;
DONE ; Exit, stage right...
 S BQII=BQII+1,@DATA@(BQII)=RSLT_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
HDR ;
 S @DATA@(BQII)="I00001RESULT"_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S RSLT=-1,BQII=BQII+1,@DATA@(BQII)=RSLT_$C(30)
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
