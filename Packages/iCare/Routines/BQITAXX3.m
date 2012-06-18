BQITAXX3 ;PRXM/HC/DB - Determine if User has Taxonomy Access ; 26 May 2006  1:32 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
ACC(DATA,FAKE) ; EP -- BQI GET TAXONOMY ACCESS
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;  
 ; Output
 ; 1 - User has security key to edit site specific taxonomy
 ; 0 - User does not have security key to edit site specific taxonomy
 ; 
 NEW UID,II,RESULT,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITXACC",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITAXX3 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT"_$C(30)
 S RESULT=$$KEYCHK^BQIULSC("BGPZ TAXONOMY EDIT",DUZ)
 S II=II+1,@DATA@(II)=RESULT_$C(30)
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
LST(DATA,REG,REP) ; EP -- BQI GET TAX LIST BY REPORT
 ; Input
 ;  REG - Retrieves taxonomies for a particular registry and 
 ;  REP - report
 ;
 ;  Gets the list of taxonomies defined for iCare
 ;
 NEW UID,II,TIEN,TTXT,BQIH,TAXV,X,RPNM,REPNM,QFL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITXRLST",UID))
 K @DATA
 ;
 S REG=$G(REG,""),REP=$G(REP,"")
 I REG="" S BMXSEC="RPC Failed: No register selected." Q
 I REP="" S BMXSEC="RPC Failed: No report selected." Q
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITAXX D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00030TAXONOMY_NAME^T00003TAX_ITEMS"_$C(30)
 ;
RGS ; Get taxonomies for register reports
 S REG=$O(^BQI(90507,"B",REG,"")) I REG="" G DONE
 S REPNM=$G(REP)
 S REP=$O(^BQI(90507,REG,20,"B",REPNM,""))
 I REP="" S QFL=1 D  G DONE:'QFL
 . S RPNM=""
 . F  S RPNM=$O(^BQI(90507,REG,20,"B",RPNM)) Q:RPNM=""  D
 .. I $$UP^XLFSTR(RPNM)'=REPNM Q
 .. S REP=$O(^BQI(90507,REG,20,"B",RPNM,""))
 .. I REP="" S QFL=0
 ;
 I REP="" G DONE
 ;
 S TTXT=""
 F  S TTXT=$O(^BQI(90507,REG,20,REP,10,"B",TTXT)) Q:TTXT=""  D
 . S TIEN=""
 . F  S TIEN=$O(^BQI(90507,REG,20,REP,10,"B",TTXT,TIEN)) Q:TIEN=""  D
 .. NEW DA,IENS
 .. S DA(2)=REG,DA(1)=REP,DA=TIEN,IENS=$$IENS^DILF(.DA)
 .. S II=II+1
 .. S @DATA@(II)=TTXT_"^"_$S($$GET1^DIQ(90507.03,IENS,.02,"I")="":"MIS",$$GET1^DIQ(90507.03,IENS,.03,"I")=1:"YES",'$$ENTRS^BQITAXX($$GET1^DIQ(90507.03,IENS,.02,"I")):"NO",1:"YES")_$C(30)
 G DONE
 ;
TAG(DATA,TAG) ;EP -- BQI GET TAX LIST BY DX CAT
 ; Input
 ;   TAG - Diagnostic tag
 ;
 ;  Gets the list of taxonomies defined for iCare
 ;
 NEW UID,II,TIEN,TTXT,BQIH,TAXV,X,RPNM,REPNM,QFL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITXDLST",UID))
 K @DATA
 ;
 S TAG=$G(TAG,"")
 I TAG'="",TAG'?.N S TAG=$$GDXN^BQITUTL(TAG)
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITAXX D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00030TAXONOMY_NAME^T00020TAX_CATEGORY^T00003TAX_ITEMS^T00003TAX_SITE_DEFINED"_$C(30)
 ;
 ;
 S TTXT=""
 F  S TTXT=$O(^BQI(90506.2,"AE",TTXT)) Q:TTXT=""  D
 . I TAG'="",'$D(^BQI(90506.2,"AE",TTXT,TAG)) Q
 . S TXIEN=$O(^BQI(90508,1,10,"B",TTXT,"")) I TXIEN="" Q
 . NEW DA,IENS
 . S DA(1)=1,DA=TXIEN,IENS=$$IENS^DILF(.DA)
 . S II=II+1
 . S @DATA@(II)=TTXT_U_$$GET1^DIQ(90508.03,IENS,.03,"E")_U_$S('$$ENTRS^BQITAXX($$GET1^DIQ(90508.03,IENS,.02,"I")):"NO",1:"YES")_U_$S($$GET1^DIQ(90508.03,IENS,.04,"I")=1:"YES",1:"NO")_$C(30)
 G DONE
