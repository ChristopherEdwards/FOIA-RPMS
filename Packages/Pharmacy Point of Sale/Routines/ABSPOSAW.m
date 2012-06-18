ABSPOSAW ; IHS/FCS/DRS - Modem - wait for char,str ;     [ 09/12/2002  10:06 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ;
 ; Utilities for waiting for certain characters or strings
 ;  Beware, WAITOK, WAITSTR have different return values!
 ;  WAITOK(DIALOUT,TIMEOUT)
 ;  WAITSTR(DIALOUT,STRING,TIMEOUT)
 ;  WAITCHAR(DIALOUT,CHAR,TIMEOUT)
 ;  WAIT1(STRING,TIMEOUT) ; on current device
 ;  WAIT2(CHARSTRING,TIMEOUT) ; on current device
 ;  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
 ;
 ; WAITOK(DIALOUT,TIMEOUT)
 ;     Wait for the "OK" response to a modem command
 ;     Returns true if received, false if timed out.
 ;
WAITOK(DIALOUT,TIMEOUT)       ;  returns 1 if you got "OK", 0 if you didn't,
 N IO S IO=$$IO^ABSPOSA(DIALOUT)
 N RETVAL
 I $$WAITSTR(DIALOUT,"OK",$S($G(TIMEOUT):TIMEOUT,1:20)) D  S RETVAL=1
 .D LOG^ABSPOSL($T(+0)_" - MODEM - WAITOK - Success",$G(ECHO))
 E  D  S RETVAL=0
 .D LOG^ABSPOSL($T(+0)_" - MODEM - WAITOK - Failure",$G(ECHO))
 Q:$Q RETVAL Q
 ;
 ;
 ; WAITSTR(DIALOUT,STRING,TIMEOUT)
 ;      Wait for some expected string.
 ;      TIMEOUT defaults to 60 seconds.
 ;      Returns 0 if string was received, success
 ;      Returns -1 if NOT received, failure.
 ;
WAITSTR(DIALOUT,STR,TIMEOUT) ;EP - wait for a given string
 ; returns 0 if okay, nonzero if not received
 N IO,RETVAL S IO=$$IO^ABSPOSA(DIALOUT) U IO
 D LOG^ABSPOSL($T(+0)_" - MODEM - Waiting for string "_STR,$G(ECHO))
 N RET S RET=$$WAIT1(STR,$S($G(TIMEOUT):TIMEOUT,1:60))
 N X S X=$T(+0)_" - MODEM - WAITSTR - "
 I RET D  S RETVAL=0
 . S X=X_"Received expected "_STR
 . D LOG^ABSPOSL(X,$G(ECHO))
 E  D  S RETVAL=-1
 . S X=X_"Did NOT receive expected "_STR
 . N RECD S RECD=$P(RET,U,2,$L(RET,U))
 . I RECD="" S X=X_" - Received nothing"
 . D LOG^ABSPOSL(X,$G(ECHO))
 . I RECD]"" D
 . . N I F I=$L(RECD):-1:1 Q:$L(RECD)>250  D
 . . . I $E(RECD,I)?1C D
 . . . . S RECD=$E(RECD,1,I-1)_"\"_$A(RECD,I)_"\"_$E(RECD,I+1,$L(RECD))
 . . S X=$T(+0)_" - MODEM - WAITSTR - Received instead: "_RECD
 . . D LOG^ABSPOSL(X,$G(ECHO))
 Q:$Q RETVAL Q
 ;
 ;  WAIT1(STRING,TIMEOUT,MAXCHAR)
 ;     Wait for the given string.
 ;     Returns true for success, false for failure.
 ;     Returns 0^$ZE if error happened (most likely disconnect).
 ;     (Note!  Different return value types than WAITSTR has!)
 ;
 ;  To protect against terminal server overflowing with $C(0),
 ;  we impose MAXCHAR, default 3000 characters
 ;
WAIT1(WAITTXT,TIMEOUT,MAXCHAR) ;
 ;returns 1 for success 0 for failure (diff. from WAITSTR)
 ; Appended to the return value:  "^" and the message it received
 N START,END,FLAG,CHAR,MSG,TIMEOUTA,X,NCHAR
 I '$D(MAXCHAR) S MAXCHAR=3000
 S TIMEOUTA=0 ; counts up to TIMEOUT and then you've got a real timeout
 ;Read input buffer until WAITTXT has been received or timeout
 S (FLAG,MSG)=""
 S X="W1ZE^"_$T(+0),@^%ZOSF("TRAP")
 F NCHAR=1:1:MAXCHAR D  Q:TIMEOUTA'<TIMEOUT!(FLAG'="")
 .S CHAR=""
 .R *CHAR:1 S TIMEOUTA=$S($T:0,1:TIMEOUTA+1) Q:TIMEOUTA
 .S:CHAR>127 CHAR=CHAR-128 ; 7-Bit communications
 .S:$L(MSG)=255 MSG=$E(MSG,1,254)
 .S MSG=MSG_$C(CHAR)
 .S FLAG=$S(MSG[WAITTXT:1,1:"")
 Q $S(MSG[WAITTXT:1,1:0)_U_MSG
W1ZE D LOGZE("WAIT1") Q 0_U_$$ZE^ABSPOS
 ; 
 ; Waiting for a particular control charcter
WAITCHAR(DIALOUT,CHARS,TIMEOUT) ;EP -
 ; returns 0 if okay, nonzero if not received
 I '$G(TIMEOUT) S TIMEOUT=60
 N IO,RETVAL S IO=$$IO^ABSPOSA(DIALOUT) U IO
 N X S X=$T(+0)_" - MODEM - Waiting for"
 I $L(CHARS)>1 S X=X_" any of"
 S X=X_":"
 N I F I=1:1:$L(CHARS) S X=X_" $C("_$A(CHARS,I)_")"
 S X=X_" timeout "_$G(TIMEOUT)
 D LOG^ABSPOSL(X,$G(ECHO))
 S RETVAL=$$WAIT2(CHARS,TIMEOUT)
 N X S X=$T(+0)_" - MODEM - WAITCHAR - "
 I RETVAL]"" D
 . S X=X_"Received "_RETVAL
 . D LOG^ABSPOSL(X,$G(ECHO))
 . I RETVAL="EOT" D  D HANGUP^ABSPOSAB(DIALOUT) S RETVAL="+++"
 . . D LOG^ABSPOSL($T(+0)_" - MODEM - Received EOT from host")
 E  D
 . S X=X_"Did NOT receive what was expected."
 . D LOG^ABSPOSL(X,$G(ECHO))
 Q:$Q RETVAL Q
 ;---------------------------------------------------------------------
 ;Monitors a port and waits for particular control characters within a
 ;specified time frame
 ;             WCHARS   - String of control characters
 ;             TIMEOUT  - Time frame (in seconds) - at least 1
 ; Returns "STX" or "ETX" or "EOT" or "ENQ" or "ACK" or "NAK" or ""
 ; or it may return "RUNAWAY"
 ;--------------------------------------------------------------------
WAIT2(WCHARS,TIMEOUT) ;
 N I,MAXI,START,END,FLAG,ACH,CCH,EOT,TIMEOUTA,X
 S EOT=$C(4),TIMEOUTA=0
 I WCHARS'[EOT S WCHARS=WCHARS_EOT ; always be on the lookout for EOT
 S FLAG="",MAXI=3000
 S X="W2ZE^"_$T(+0),@^%ZOSF("TRAP")
 F I=1:1:MAXI D  Q:TIMEOUTA'<TIMEOUT!(FLAG'="")
 . S (ACH,CCH)=""
 . R *ACH:1 S TIMEOUTA=$S($T:0,1:TIMEOUTA+1) Q:TIMEOUTA
 . S:ACH>127 ACH=ACH-128 Q:'ACH
 . S CCH=$C(ACH)
 . S:WCHARS[CCH FLAG=ACH
 I I=MAXI Q "RUNAWAY" ; runaway byte stream?!
 ;D LOG^ABSPOSL("TEMPORARY: Stopped with END="_END_",$H="_$H_",FLAG="_FLAG)
 Q $P(",STX,ETX,EOT,ENQ,ACK,,,,,,,,,,,,,,,NAK",",",FLAG)
W2ZE D LOGZE("WAIT2") Q ""
LOGZE(WHERE) D LOG^ABSPOSL($T(+0)_" - MODEM - "_WHERE_" - $ZE="_$$ZE^ABSPOS) Q
