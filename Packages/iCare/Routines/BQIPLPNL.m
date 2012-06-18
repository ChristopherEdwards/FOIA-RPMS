BQIPLPNL ;PRXM/HC/ALA-Get list of Panels used as Filters ; 28 Dec 2006  11:22 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN) ;EP -- BQI GET FILTER PANELS
 ;Description
 ;  Get the user's panels containing panel filters
 ;Input
 ;  PLIEN - If checking a specific panel
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Expects
 ;  DUZ - the internal entry number of the person signed on
 ;
 NEW UID,II,VALUE,PLNME,POWNR,PPLIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLPNL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLPNL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010OWNER^I00010PANEL_IEN^I00010PANEL_ID^T00120PANEL_NAME"_$C(30)
 ;
 S PLIEN=$G(PLIEN,"") I PLIEN="" G DONE
 S OWNR=$G(OWNR,DUZ)
 S PLNME=$P(^BQICARE(OWNR,1,PLIEN,0),U,1)
 S VALUE=OWNR_$C(26)_PLNME
 ;
 S POWNR=""
 F  S POWNR=$O(^BQICARE("AD",VALUE,POWNR)) Q:POWNR=""  D
 . S PPLIEN=""
 . F  S PPLIEN=$O(^BQICARE("AD",VALUE,POWNR,PPLIEN)) Q:PPLIEN=""  D
 .. S II=II+1,@DATA@(II)=POWNR_"^"_PPLIEN_"^"_$$PLID^BQIUG1(POWNR,PPLIEN)_"^"_$P(^BQICARE(POWNR,1,PPLIEN,0),U,1)_$C(30)
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
