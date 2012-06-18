BQITRPAT ;VNGT/HS/ALA-Refresh Patient's Treatment Prompts ; 08 Aug 2008  12:08 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,DFN) ;EP - BQI REFRESH PAT TRMT PROMPTS
 ; Input
 ;   DFN - Patient internal entry number
 ;
 NEW UID,II,ERROR,BQIDFN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITRPAT",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITRPAT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT"_$C(30)
 S BQIDFN=$G(DFN,"")
 I BQIDFN="" S BMXSEC="No patient selected" Q
 ;
 D PAT^BQITRMT(BQIDFN)
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
