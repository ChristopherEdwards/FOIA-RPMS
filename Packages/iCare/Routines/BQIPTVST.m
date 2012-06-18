BQIPTVST ;PRXM/HC/ALA-Visit Record ; 14 Jun 2006  5:41 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
GET(DATA,VISIT) ; EP -- BQI GET VISIT RECORD
 ;
 ;Description
 ;  Returns a visit record for a patient's visit
 ;Input
 ;   DFN - Patient internal entry number
 ;
 NEW UID,II,JJ,LJ,FJ,KK,BQITEMP,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S BQITEMP=$NA(^TMP("BQIVISIT",UID))
 S DATA=$NA(^TMP("BQIPTVST",UID))
 K @BQITEMP,@DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTVST D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I $G(VISIT)="" S BMXSEC="No visit record sent" Q
 ;
 D EN^APCDVDSG(VISIT,BQITEMP,1)
 S @DATA@(II)="T00120REPORT_TEXT"_$C(30)
 ;
 S JJ=0
 F  S JJ=$O(@BQITEMP@(JJ)) Q:'JJ  S II=II+1,@DATA@(II)=@BQITEMP@(JJ,0)_$C(13)_$C(10)
 S II=II+1,@DATA@(II)=$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 ;
 K @BQITEMP
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
