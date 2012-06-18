ABSPOSAD ; IHS/FCS/DRS - JWS ;    [ 09/12/2002  10:05 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;---------------------------------------------------------------------
 Q
 ;
 ;---------------------------------------------------------------------
 ;Longitudinal Redundancy Checker routines
 ;
 ;
 ;Parameters:  STRING - STRING of characters (eg: message to be sent
 ;                      to or received from host)
 ;
 ;Returns:     LRC    - CHARacter representing the cumlative XOR of
 ;                      each character in the STRING
 ;---------------------------------------------------------------------
LRC(STRING) ;EP -
 N LRC,CHAR,INDEX,LEN
 ;
 ;Loop through STRING and calculate LRC by doing a cumlative XOR
 S LRC=$C(0),LEN=$L(STRING)
 F INDEX=1:1:LEN D
 .S CHAR=$E(STRING,INDEX)
 .S LRC=$ZBOOLEAN(LRC,CHAR,6) ;- for MSM System /GTI
 .;S LRC=$ZCRC($C(LRC)_CHAR,1)
 Q LRC   ;- for MSM System /GTI
 ;Q $C(LRC)
 ;---------------------------------------------------------------------
 ;Test if LRC character received from host for a message is correct
 ;
 ;Parameters:  GETMSG   - Message received from host
 ;             LRC      - LRC character received from host
 ;
 ;Returns:     1        - LRC is correct
 ;             0        - LRC is not correct
 ;---------------------------------------------------------------------
TESTLRC(GETMSG,LRC) ;EP - from ABSPOSAM
 N XLRC
 S XLRC=$$LRC(GETMSG)
 Q $S(LRC=XLRC:1,1:0)
