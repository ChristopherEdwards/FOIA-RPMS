BQIMURUN ;VNGT/HS/ALA-Get MU run date/times ; 13 Apr 2011  1:47 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**5**;Apr 18, 2012;Build 17
 ;
 Q
 ;
EN(DATA,FAKE) ; EP - BQI GET LAST MU RUN
 ;
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;  Get the beginning and ending times of the GPRA run
 NEW UID,II,BDT,EDT,X,DA,BUDT,BUEDT,HDR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMURUN",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMURUN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="D00030RUN_START_DATETIME^D00030RUN_END_DATETIME"
 S @DATA@(II)=HDR_$C(30)
 ;
 S DA=$O(^BQI(90508,0)) I 'DA G DONE
 ;
 S BDT=$$FMTE^BQIUL1($$GET1^DIQ(90508,DA_",",8.04,"I"))
 S EDT=$$FMTE^BQIUL1($$GET1^DIQ(90508,DA_",",8.05,"I"))
 S II=II+1,@DATA@(II)=BDT_"^"_EDT_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CQM(DATA,FAKE) ; EP - BQI GET LAST CQM RUN
 ;
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;  Get the beginning and ending times of the CQM run
 NEW UID,II,BDT,EDT,X,DA,BUDT,BUEDT,HDR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMURUN",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMURUN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="D00030RUN_START_DATETIME^D00030RUN_END_DATETIME"
 S @DATA@(II)=HDR_$C(30)
 ;
 S DA=$O(^BQI(90508,0)) I 'DA G DONE
 ;
 S BDT=$$FMTE^BQIUL1($$GET1^DIQ(90508,DA_",",4.19,"I"))
 S EDT=$$FMTE^BQIUL1($$GET1^DIQ(90508,DA_",",4.2,"I"))
 S II=II+1,@DATA@(II)=BDT_"^"_EDT_$C(30)
 ;
XCQM ;
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
