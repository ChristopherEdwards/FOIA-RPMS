BQIULSC ;PRXM/HC/BWF - Security Utilities ; 20 Dec 2005  3:54 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 Q
 ;
 ; NOTE: This function is not currently used, but may be activated at a later date.
 ;
 ; This function will return information on whether or not a user has a given key. 
 ; The user and the key to be tested are parameters that are passed into the function.
 ; 
 ; INPUT:
 ;       KEY - The is the key that we are validating under the user's DUZ.
 ;       - This may be passed by IEN or key name.
 ;       USER - The DUZ of the user selecting the Health summaries.
 ;
 ;
 ; OUTPUT:
 ;       1  - User has security key
 ;       0  - User does not have security key
 ;       -1 - Unable to process request (an error has occurred) such as,
 ;            the key does not exist, calling routine should not be checking
 ;            for a key that does not exist.
 ;
KEYCHK(KEY,USER)   ;EP
 ; If security key is not numeric, it is assumed that the key was passed by name.
 N KEYIEN,VAL
 I KEY'?1N.N D  Q VAL
 .I '$D(^DIC(19.1,"B",KEY)) S VAL=-1 Q
 .S KEYIEN=$O(^DIC(19.1,"B",KEY,0))
 .I '$D(^VA(200,USER,51,KEYIEN)) S VAL=0 Q
 .S VAL=1
 I '$D(^VA(200,USER,51,KEY)) S VAL=0 Q VAL
 S VAL=1
 Q VAL
 ;
VLDPSW(DATA,PSW) ;EP -- BQI CHECK VERIFY CODE
 NEW UID,II,RESULT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIULSC",UID))
 K @DATA
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIULSC D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S II=0,@DATA@(II)="I00010RESULT^T00080MESSAGE"_$C(30)
 S PSW=$$DECRYP^XUSRB1(PSW)
 S:'$$GET^XPAR("SYS","XU VC CASE SENSITIVE") PSW=$$UP^XLFSTR(PSW)
 S RESULT=$$EN^XUSHSH(PSW)=$P($G(^VA(200,+DUZ,.1)),U,2)
 ;
 I RESULT=1 S II=II+1,@DATA@(II)="1^"_$C(30)
 E  S II=II+1,@DATA@(II)="-1^Incorrect VERIFY CODE"_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
