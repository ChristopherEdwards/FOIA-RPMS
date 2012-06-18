BQIRRHSP ;APTIV/HC/ALA-HMS Supplement RPC ; 05 Feb 2008  6:23 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN(DATA,DFN) ; EP - BQI HMS PATIENT SUPPL
 ;Description
 ;  Generates a Patient Supplement for a given DFN and the HMS Supplement
 ;
 ;Input
 ;  DFN  - Patient Internal ID
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQIRRHSP"))
 ;
 NEW UID,II,SUPL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRRHSP",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRRHSP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S SUPL=$O(^APCHSUP("B","HMS PATIENT CARE SUPPLEMENT",""))
 I SUPL="" S BMXSEC="RPC Call Failed: HMS Supplement not found" Q
 D EN^BQIRSPMT(.DATA,DFN,SUPL)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
