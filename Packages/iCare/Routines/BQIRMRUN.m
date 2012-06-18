BQIRMRUN ;PRXM/HC/ALA-Get date/time reminders last ran ; 02 Apr 2007  5:00 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,FAKE) ; EP - BQI GET LAST REMINDER RUN
 ;
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;  
 ; Get the beginning and ending times of the Reminders run
 NEW UID,II,BDT,EDT,X,DA
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRMRUN",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRMRUN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="D00030LAST_RUN_START_DATETIME^D00030LAST_RUN_END_DATETIME"_$C(30)
 ;
 S DA=$O(^BQI(90508,0)) I 'DA G DONE
 ;
 S BDT=$$GET1^DIQ(90508,DA_",",3.1,"I"),EDT=$$GET1^DIQ(90508,DA_",",3.2,"I")
 S II=II+1,@DATA@(II)=$$FMTE^BQIUL1(BDT)_"^"_$$FMTE^BQIUL1(EDT)_$C(30)
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
