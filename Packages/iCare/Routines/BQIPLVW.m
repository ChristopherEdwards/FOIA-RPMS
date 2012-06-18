BQIPLVW ;PRXM/HC/ALA-Panel View ; 17 Oct 2005  1:19 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
LST(DATA,FAKE) ; EP - BQI GET PANEL VIEW
 ;Description
 ;  This returns the standard display and sort order list
 ;Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Variables used
 ;  UID - TMP global subscript. Will be either $J or "Z" plus the
 ;        TaskMan Task ID
 ;        
 NEW UID,II,IEN,DOR,DVALUE,SOR,SVALUE,X,STVCD
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLVW",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLVW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00120DISPLAY_ORDER^T00120SORT_ORDER^T00120SORT_DIRECTION"_$C(30)
 ;
 S II=II+1
 S @DATA@(II)=$$DFNC()_"^"_$$SFNC()_"^A"_$C(30)
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
DFNC() ;EP - Get the standard display order
 S DVALUE=""
 S DOR="" F  S DOR=$O(^BQI(90506.1,"AD","D",DOR)) Q:DOR=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD","D",DOR,IEN)) Q:IEN=""  D
 .. ;I $$GET1^DIQ(90506.1,IEN_",",.04,"I")'="O" D
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVCD=$$GET1^DIQ(90506.1,IEN_",",.01,"E")
 ... S DVALUE=DVALUE_STVCD_$C(29)
 S DVALUE=$$TKO^BQIUL1(DVALUE,$C(29))
 Q DVALUE
 ;
SFNC() ;EP - Get the standard sort order
 S SVALUE=""
 S SOR="" F  S SOR=$O(^BQI(90506.1,"AE","D",SOR)) Q:SOR=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AE","D",SOR,IEN)) Q:IEN=""  D
 .. ;I $$GET1^DIQ(90506.1,IEN_",",.04,"I")'="O" D
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVCD=$$GET1^DIQ(90506.1,IEN_",",.01,"E")
 ... S SVALUE=SVALUE_STVCD_$C(29)
 S SVALUE=$$TKO^BQIUL1(SVALUE,$C(29))
 Q SVALUE
