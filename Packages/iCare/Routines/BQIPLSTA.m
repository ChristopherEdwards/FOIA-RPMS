BQIPLSTA ;PRXM/HC/ALA-Set panel status ; 12 Dec 2006  1:56 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN,STATUS) ; EP -- BQI SET PANEL STATUS
 ;
 ;Description
 ;   Set the panel's autopopulation status
 ;Input
 ;  OWNR   - owner of the panel
 ;  PLIEN  - panel internal entry number
 ;  STATUS - Status to be set
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;
 NEW UID,II,ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLSTA",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLSTA D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 S STATUS=$G(STATUS,""),OWNR=$G(OWNR,""),PLIEN=$G(PLIEN,"")
 I OWNR="" S OWNR=DUZ
 D STA^BQIPLRF(OWNR,PLIEN,STATUS)
 I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 I '$D(ERROR) S II=II+1,@DATA@(II)="1"_$C(30)
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
