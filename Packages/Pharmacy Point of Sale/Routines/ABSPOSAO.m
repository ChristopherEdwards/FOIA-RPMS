ABSPOSAO ; IHS/FCS/DRS - INITIATE ;   [ 09/12/2002  10:05 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ;
 ; Future: extra parameter to WAITCHAR to tell it "no big deal if
 ; the character doesn't come in" - it looks like an error message
 ; when you don't get the ACK after the ENQ but then again, it's
 ; rare.
 ;
 ; 
INITIATE() ;EP - wait for the host to initiate communications
 ; usually, this is an ENQ
 ; sometimes, it may be ACK/ENQ or ENQ/ACK (Envoy 4.1 page 6)
 ; Returns 0 if success, error code if failure
 ; Error code 30101 - disconnected
 ;    This probably means that the host system only gives us one
 ;    transaction per phone call, and we were hoping for an ENQ to
 ;    let us send a second transaction, but the host sent EOT instead.
 ; Error code 30102 - nothing received and we hung up
 ;
 D LOG("1 - Waiting for host to initiate with ENQ")
 N CH S CH=$$WAITCHAR^ABSPOSAM(ENQ_ACK,30)
 N RET,OK ; variable OK can probably be gotten rid of
 I CH="ENQ" D
 . ; the usual case is ENQ, not ENQ ACK, right?  so only give 1 sec.
 . S CH=$$WAITCHAR^ABSPOSAM(ACK,1)
 . I CH="ACK" D  S OK=1
 . . D LOG("1 - Host sent ENQ ACK to initiate")
 . . S RET=0
 . E  I CH="" D  S OK=1
 . . D LOG("1 - Host sent ENQ to initiate")
 . . S RET=0
 . ;E  leave RET undef and CH = retval from WAITCHAR
 E  I CH="ACK" D
 . S CH=$$WAITCHAR^ABSPOSAM(ENQ,30)
 . I CH="ENQ" D  S OK=1
 . . D LOG("1 - Host sent ACK ENQ to initiate")
 . . S RET=0
 . E  D  ; leave RET undef and CH = retval from WAITCHAR
 . . D LOG("1 - Received ACK but not expected ENQ")
 I '$D(RET) D  ; if RET not set, then something went wrong
 . D LOG("1 - Last WAITCHAR returned "_CH)
 . I CH="+++" S RET=30101 ; modem disconnected
 . E  S RET=30102 D HANGUP ; nothing received
 I RET D LOG("1 - Unsuccessful attempt to initiate - "_RET)
 Q RET
LOG(X) D LOG^ABSPOSL($T(+0)_" - "_X) Q
HANGUP D HANGUP^ABSPOSAB(DIALOUT) Q
