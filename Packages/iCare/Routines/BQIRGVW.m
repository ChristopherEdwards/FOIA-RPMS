BQIRGVW ;PRXM/HC/ALA-Register View ; 08 Nov 2007  1:04 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN(DATA,REG) ; EP -- BQI GET REGISTER VIEW
 ; Input
 ;   REG - Register name
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;Variables used
 ;  UID - TMP global subscript. Will be either $J or "Z" plus the
 ;        TaskMan Task ID
 ;        
 NEW UID,II,MVALUE,IEN,GIEN,SIEN,DISPLAY,SOR,SDIR,TEMPL,LYIEN,SUB
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGVW",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRGVW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T01024DISPLAY_ORDER^T00300SORT_ORDER^T00300SORT_DIRECTION"_$C(30)
 ;
 S REG=$G(REG,"") I REG="" G DONE
 S RGIEN=$O(^BQI(90506.3,"B",REG,"")) I RGIEN="" G DONE
 S ORD="",DISPLAY="",SOR="",SDIR=""
 F  S ORD=$O(^BQI(90506.3,RGIEN,10,"C",ORD)) Q:ORD=""  D
 . S RIEN=""
 . F  S RIEN=$O(^BQI(90506.3,RGIEN,10,"C",ORD,RIEN)) Q:RIEN=""  D
 .. I $P(^BQI(90506.3,RGIEN,10,RIEN,0),U,4)'="S" Q
 .. S CODE=$P(^BQI(90506.3,RGIEN,10,RIEN,0),U,7) I CODE="" Q
 .. S TYPE=$P($G(^BQI(90506.3,RGIEN,10,RIEN,1)),U,1)
 .. S DISPLAY=DISPLAY_CODE_$C(29)
 ;.. ; If this is a multiple, go to the subdefinition
 ;.. ;I TYPE="M" D
 ;... NEW SNAME,SRIEN,SORD
 ;... S SNAME=$P(^BQI(90506.3,RGIEN,10,RIEN,0),U,1),CODE=""
 ;... S SRIEN=$O(^BQI(90506.3,"B",SNAME,"")) I SRIEN="" Q
 ;... S SORD=""
 ;... F  S SORD=$O(^BQI(90506.3,SRIEN,10,"C",SORD)) Q:SORD=""  D
 ;.... S SIEN=""
 ;.... F  S SIEN=$O(^BQI(90506.3,SRIEN,10,"C",SORD,SIEN)) Q:SIEN=""  D
 ;..... I $P(^BQI(90506.3,SRIEN,10,SIEN,0),U,4)'="S" Q
 ;..... S CD=$P(^BQI(90506.3,SRIEN,10,SIEN,0),U,7) I CD="" Q
 ;..... S CODE=CODE_CD_$C(29)
 ;... S CODE=$$TKO^BQIUL1(CODE,$C(29))
 ;
 S SUB=$$GET1^DIQ(90506.3,RGIEN_",",.07,"I")
 S DISPLAY=$S('SUB:$$DFNC^BQIPLVW(),1:"")_$C(29)_$$TKO^BQIUL1(DISPLAY,$C(29))
 S SORT=$$SFNC^BQIPLVW()
 S II=II+1,@DATA@(II)=DISPLAY_U_SORT_"^A"_$C(30)
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
