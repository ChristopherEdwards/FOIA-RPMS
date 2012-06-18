BQIPTBTL ;PRXM/HC/ALA-Patient Barriers to Learning ; 07 Nov 2005  2:27 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
GET(DATA,DFN) ; EP -- BQI PAT BARRIERS TO LEARNING
 ;
 ;Description
 ;  Returns all of the Barriers to Learning for a patient
 ;Input
 ;   DFN - Patient internal entry number
 ;
 NEW UID,II,TEXT,XTEXT,IEN,BQIHF,RVDT,VDTM,X,BDATA
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTBTL",UID))
 S BDATA=$NA(^TMP("BQIBARR",UID))
 K @DATA,@BDATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTBTL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00040TITLE^D00018EVENT_DT"_$C(30)
 ;
 S (XTEXT,TEXT)="BARRIERS"
 F  S XTEXT=$O(^AUTTHF("B",XTEXT)) Q:XTEXT=""!($E(XTEXT,1,$L(TEXT))'=TEXT)  D
 . S IEN=""
 . F  S IEN=$O(^AUTTHF("B",XTEXT,IEN)) Q:IEN=""  D
 .. I $$GET1^DIQ(9999999.64,IEN_",",.1,"I")="C" Q
 .. S @BDATA@(IEN)=$P(XTEXT,"-",2)
 ;
 S BQIHF=""
 F  S BQIHF=$O(^AUPNVHF("AA",DFN,BQIHF)) Q:BQIHF=""  D
 . I $D(@BDATA@(BQIHF)) D
 .. S RVDT=""
 .. F  S RVDT=$O(^AUPNVHF("AA",DFN,BQIHF,RVDT)) Q:RVDT=""  D
 ... S IEN=""
 ... F  S IEN=$O(^AUPNVHF("AA",DFN,BQIHF,RVDT,IEN)) Q:IEN=""  D
 .... S VDTM=$$GET1^DIQ(9000010.23,IEN_",",.03,"E")
 .... S II=II+1,@DATA@(II)=@BDATA@(BQIHF)_"^"_$P(VDTM,"@",1)_$C(30)
 ;
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
