BTPWPHIS ;VNGT/HS/ALA-CMET Event History ; 01 Sep 2009  5:01 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 ;
EN(DATA,CMIEN) ; EP -- BTPW GET EVENT HISTORY
 NEW UID,II
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPHIS",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPHIS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010CMET_IEN^T00030EVENT_NAME^D00015EVENT_DATE^T00005STATE"_$C(30)
 I $P(^BTPWP(CMIEN,0),U,11)'="" D REC
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
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
REC ;EP - Recursive check
 S PRIEN=$P(^BTPWP(CMIEN,0),U,11) I PRIEN="" Q
 S NAME=$$GET1^DIQ(90620,PRIEN_",",.01,"E"),EVDT=$$GET1^DIQ(90620,PRIEN_",",.03,"I")
 S STATE=$$GET1^DIQ(90620,PRIEN_",",1.01,"E")
 S II=II+1,@DATA@(II)=PRIEN_U_NAME_U_$$FMTE^BQIUL1(EVDT)_U_STATE_$C(30)
 S CMIEN=PRIEN
 G REC