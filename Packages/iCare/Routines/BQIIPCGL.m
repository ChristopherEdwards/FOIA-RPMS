BQIIPCGL ;VANGENT/HC/BEE-IPC Glossary ; 22 Feb 2008  1:27 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
GLS(DATA,FAKE) ;EP -- BQI GET IPC GLOSSARY
 ;
 NEW UID,II,GLIEN,IEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIIPCGL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPCGL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T32767TEXT"_$C(30)
 S GLIEN=$O(^BQI(90508.2,"B","IPC","")) I GLIEN="" S BMXSEC="Problem with IPC definition in file 90508.2" G DONE
 S IEN=0 F  S IEN=$O(^BQI(90508.2,GLIEN,1,IEN)) Q:'IEN  D
 . S II=II+1,@DATA@(II)=$G(^BQI(90508.2,GLIEN,1,IEN,0))
 S @DATA@(II)=@DATA@(II)_$C(30)
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