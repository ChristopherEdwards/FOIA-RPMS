BQIMUTSK ;GDIT/HS/ALA-MU Tasks ; 02 Dec 2011  11:44 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
STAT(DATA,TASK) ;EP -- BQI GET MU REPORT STATUS
 NEW UID,II,HDR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMUTSK",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIMURPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S HDR="T00030STATUS"
 S @DATA@(II)=HDR_$C(30)
 NEW ZTSK
 S ZTSK=TASK
 D STAT^%ZTLOAD
 S II=II+1,@DATA@(II)=$G(ZTSK(2))_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
