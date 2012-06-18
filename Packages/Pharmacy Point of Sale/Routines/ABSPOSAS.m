ABSPOSAS ; IHS/FCS/DRS - Low-level SEND claim ;   [ 08/21/2002  9:13 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**2**;JUN 21, 2001
 Q
 ;
 ;  Modem - low-level message send
 ;  SENDREQ is main
 ;
 ;IHS/SD/lwj  6/7/02  need to add a line feed when the system is 
 ; Cache.
 ;
 ;IHS/SD/lwj  8/19/02 we were getting "invalid version" and 
 ;"corrupted" response messages after the switch to Cache and
 ; only at the Cache sites.  From the research, it appeared that
 ; the buffer was not being cleared all the way.  David Slauenwhite,
 ; Hoarce Whitt, and Intersystems, determined that rather than a
 ; "!" (cr/lf) we needed to W *-3 after each send.  The code
 ; has been changed, and it appears has solved the problems.
 ;
 ;
SENDREQ(DIALOUT,MSG) ;EP -
 ; (Don't modify MSG; caller may have called with .MSG)
 N IO S IO=$$IO^ABSPOSA(DIALOUT) U IO
 I $$T1DIRECT^ABSPOSA(DIALOUT) D
 . W $TR($J($L(MSG),4)," ","0"),MSG ; write message length, then msg
 . ;I ^%ZOSF("OS")["OpenM" W !  ;IHS/SD/lwj  6/7/02 LF for Cache
 . I ^%ZOSF("OS")["OpenM" W *-3  ;IHS/SD/lwj  8/19/02 for Cache
 . D LOG^ABSPOSL($T(+0)_" - T1 LINE - SEND - "_$L(MSG)_"+4 characters")
 E  D
 . N STX,ETX S STX=$C(2),ETX=$C(3)
 . N X S X="SENDZE^"_$T(+0),@^%ZOSF("TRAP")
 . W STX,MSG,ETX,$$LRC^ABSPOSAD(MSG_ETX)
 . D LOG^ABSPOSL($T(+0)_" - MODEM - SEND - "_$L(MSG)_"+3 characters")
 ; SAVECOPY - uncomment for development debugging
 ;D SAVECOPY^ABSPOSAY(MSG,"C")
 Q:$Q 0 Q
SENDZE D LOGZE("SENDREQ") Q
SENDCHAR(DIALOUT,CHAR)  N IO S IO=$$IO^ABSPOSA(DIALOUT) U IO W CHAR Q
SENDACK(DIALOUT) ;EP -
 D SENDCHAR(DIALOUT,$C(6)) Q
SENDNAK(DIALOUT) ;EP -
 D SENDCHAR(DIALOUT,$C(21)) Q
SENDEOT(DIALOUT)   D SENDCHAR(DIALOUT,$C(4)) Q
SENDETB(DIALOUT) ;EP -
 D SENDCHAR(DIALOUT,$C(23)) Q
LOGZE(WHERE) D LOG^ABSPOSL($T(+0)_" - MODEM - "_WHERE_" - $ZE="_$$ZE^ABSPOS) Q
