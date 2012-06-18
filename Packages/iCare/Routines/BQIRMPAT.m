BQIRMPAT ;PRXM/HC/ALA-Recalculate a patient's reminders ; 15 Jun 2007  10:47 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,DFN) ;EP - BQI REFRESH PATIENT REMINDERS
 ; Input
 ;   DFN - Patient internal entry number
 ;
 NEW UID,II,ERROR,BQIDFN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRMPAT",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRMPAT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT"_$C(30)
 S BQIDFN=$G(DFN,"")
 I BQIDFN="" S BMXSEC="No patient selected" Q
 ;
 D PAT^BQIRMDR(BQIDFN,1)
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)="-1"_$C(30)
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
