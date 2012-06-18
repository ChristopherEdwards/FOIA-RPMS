ABSPOSAQ ; IHS/FCS/DRS - CONNECT ;   [ 09/12/2002  10:06 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ;
 ;  CONNECT - subroutine of ABSPOSAM
 ;
CONNECT(DIALOUT) ;EP - connect to DIALOUT = pointer to 9002313.55
 ; Returns 0 if success, nonzero error code if failure
 ; Future:  we want this to be able to try multiple devices
 ; Today, it's one device per destination
 ; Future: (Intermediate term) a utility to switch the device
 N ECODE S ECODE=$$CONNECT^ABSPOSAA(DIALOUT) I 'ECODE Q 0
 N X S X=$T(+0)_" - Error "_ECODE_" returned from $$CONNECT^ABSPOSAA"
 D LOG^ABSPOSL(X)
 I +ECODE'=20999 D  ; if OPEN succeeded, hangup phone and close device
 . D HANGUP^ABSPOSAB(DIALOUT)
 . D CLOSE^ABSPOSAB(DIALOUT)
 S ^ABSP(9002313.55,DIALOUT,"ERROR")=$$NOW_U_ECODE
 Q ECODE
NOW() N %,%H,%I,X D NOW^%DTC Q %
