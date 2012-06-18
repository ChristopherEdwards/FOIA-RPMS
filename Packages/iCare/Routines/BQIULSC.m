BQIULSC ;PRXM/HC/BWF - Security Utilities ; 20 Dec 2005  3:54 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
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
