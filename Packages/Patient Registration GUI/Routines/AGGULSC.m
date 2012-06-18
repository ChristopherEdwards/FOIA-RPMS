AGGULSC ;VNGT/HS/ALA - Security Key Check ; 13 May 2010  6:12 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
 Q
 ;
 ; This function will return information on whether or not a user has a given key. 
 ; The user and the key to be tested are parameters that are passed into the function.
 ; 
 ; INPUT:
 ;       KEY - The is the key that we are validating under the user's DUZ.
 ;       - This may be passed by IEN or key name.
 ;       DUZ - The DUZ of the user
 ;
 ;
 ; OUTPUT:
 ;       1  - User has security key
 ;       0  - User does not have security key
 ;       -1 - Unable to process request (an error has occurred) such as,
 ;            the key does not exist, calling routine should not be checking
 ;            for a key that does not exist.
 ;
KEYCHK(DATA,KEY)   ;EP -- AGG VALIDATE KEY
 NEW UID,II
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGULSC",UID))
 K @DATA
 ;
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGVER D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^T00120MSG"_$C(30)
 ; If security key is not numeric, it is assumed that the key was passed by name.
 NEW KEYIEN,VAL,MSG,RESULT
 S VAL=1,MSG=""
 I KEY'?1N.N D
 . I '$D(^DIC(19.1,"B",KEY)) S VAL=-1,MSG="Key does not exist" Q
 . S KEYIEN=$O(^DIC(19.1,"B",KEY,0))
 . I '$D(^VA(200,DUZ,51,KEYIEN)) S VAL=-1 Q
 . S VAL=1
 I VAL'=1,'$D(^XUSEC(KEY,DUZ)) S VAL=-1,MSG="User does not have key "_KEY
 S RESULT=VAL_U_MSG
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
