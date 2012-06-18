ABSPOSAB ; IHS/FCS/DRS - various modem commands ;     [ 06/28/2002  5:28 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**2**;JUN 21, 2001
 Q
 ; Low-level IO routines which:
 ; *   take DIALOUT as an argument
 ; *   optionally ECHO as a second argument, passed along to LOG^POSU
 ; *  can be called as either DO ^ or as a $$ function
 ; *  preserve your current $IO
 ;
 ; T1 line should reach these for OPEN and FLUSH, only.
 ;
 ;
 ;IHS/SD/lwj  06/10/02  Changes made to make the open and
 ; use commands Cache compliant.  Open command for Cache must
 ; be in the format of:
 ;  O "|TCP|6802":(199.244.222.6:6802:"M"):3
 ; (the "M" is very important in extending the buffer for the
 ; large claims.)
 ; Changes tested on the Parker Cache test data base and will
 ; be incorporated in Patch 2 of POS V1.0.  Changes made
 ; to the ABSP Dial Out file (^ABSP(9002313.55) to include a
 ; Cache Device - this device will be used for the T1 connection
 ; (New field is 420.03 on the DEVICE node)
 ;
 ;
OPEN(DIALOUT) ;EP - return 0 if okay, nonzero if error  
 ; Error can be:  79 - $ZB=79, reproducible by telnet <server> <port>
 ;   or perhaps just due to a few seconds while port resets from prev
 ;   use.
 N IO,SERVER,PORT,BAUD,RETVAL ;,MSYSTEM
 ;S MSYSTEM=$$MSYSTEM
 S IO=$$IO^ABSPOSA(DIALOUT) ; Mumps IO device number
 N X S X=$T(+0)_" - MODEM - OPEN - device "_IO
 I $$TCP^ABSPOSA(DIALOUT) D  ; server type device; get server & port names
 . S SERVER=$$SERVER^ABSPOSA(DIALOUT),PORT=$$PORT^ABSPOSA(DIALOUT)
 . S X=X_" - "_SERVER_", port "_PORT
 E  D
 . S BAUD=$$GET55FLD^ABSPOSA(DIALOUT,208)
 . S:'BAUD BAUD=2400
 D LOG^ABSPOSL(X,$G(ECHO))
 I $$TCP^ABSPOSA(DIALOUT) D
 . ; IHS/SD/lwj 06/10/02 begin changes for Cache
 . I ^%ZOSF("OS")["OpenM" D  Q     ;Cache system
 .. S RETVAL=0
 .. O IO:(SERVER:PORT:"M"):3 ;O "|TCP|6802":("199.244.222.6":6802:"M"):3
 .. I '$T S RETVAL=1,X=$T(+0)_" - |TCP|:("_SERVER_":"_PORT_")" ;failed
 .. I 'RETVAL U IO
 .. Q
 . I ^%ZOSF("OS")'["OpenM" D  Q
 .. O IO:(:3) U IO::"TCP" W /SOCKET(SERVER,PORT)
 .. S RETVAL=$ZB
 .. I $ZB'=0 D
 ... S X=$T(+0)_" - MODEM - W /SOCKET("_SERVER_","_PORT_") - $ZB="_$ZB
 .. Q
 .. ; IHS/SD/lwj 06/10/02 end changes for Cache
 E  D  ; a plain old traditional modem
 . N PARAM S PARAM(1)=0 ; no echo
 . S PARAM(5)=8388608 ; don't interpret control characters
 . S PARAM(5)=PARAM(5)+2097152 ; CTRL/O is data, not usual CTRL/O
 . S PARAM(5)=PARAM(5)+4096 ; TAB not expanded
 . S PARAM(5)=PARAM(5)+1 ;no echo
 . S PARAM(8)=9*4096
 . S PARAM(8)=PARAM(8)+(0*256)
 . S PARAM(8)=PARAM(8)+(5*16)
 . S PARAM(8)=PARAM(8)+$S(BAUD=2400:11,BAUD=1200:9)
 . O IO:(PARAM(1)::::PARAM(5):::PARAM(8)):600
 . I '$T D
 . . S X=$T(+0)_" - MODEM - OPEN command timed out - could not get device "_IO
 . . S RETVAL=-1
 . E  S RETVAL=0
 I RETVAL D LOG^ABSPOSL(X,$G(ECHO))
 Q:$Q RETVAL Q
CLOSE(DIALOUT) ;EP - return 0 if okay, nonzero if error
 D FLUSH(DIALOUT,2) ; give it 2 secs to flush?
 N IO S IO=$$IO^ABSPOSA(DIALOUT)
 D LOG^ABSPOSL($T(+0)_" - MODEM - CLOSE - device "_IO,$G(ECHO))
 C IO Q:$Q 0 Q
FLUSH(DIALOUT,TO) ;EP - return 0 if okay, nonzero if error
 I '$D(TO) S TO=0
 N IO S IO=$$IO^ABSPOSA(DIALOUT)
 N X,I,FLUSHSTR,MAXI S FLUSHSTR="",MAXI=3000
 S X="FZE^"_$T(+0),@^%ZOSF("TRAP")
 U IO F I=0:1:MAXI+1 R *X:TO Q:'$T  D
 .I I'>60 S FLUSHSTR=FLUSHSTR_$C(X)
 .E  I I=60 S $E(FLUSHSTR,58,60)="..."
 ; I = how many characters were flushed
 I I D
 . N N F N=I:-1:1 I $E(FLUSHSTR,N)?1C D
 . . S FLUSHSTR=$E(FLUSHSTR,1,N-1)_"\"_$TR($J($A(FLUSHSTR,N),3)," ","0")_$E(FLUSHSTR,N+1,$L(FLUSHSTR))
 . D LOG^ABSPOSL($T(+0)_" - MODEM - FLUSH - "_I_" byte(s) - "_FLUSHSTR,$G(ECHO))
 I I>MAXI D  Q -1 ; runaway - error
 . D LOG^ABSPOSL($T(+0)_" - MODEM - FLUSH - runaway after "_MAXI_" bytes",$G(ECHO))
 Q:$Q 0 Q
 ; Error trap for FLUSH, still need this for <DSCON>
FZE D LOGZE("FLUSH") Q:$Q -1 Q
LOGZE(WHERE) D LOG^ABSPOSL($T(+0)_" - MODEM - "_WHERE_" - $ZE="_$$ZE^ABSPOS) Q
 ;
 ;  ECHOOFF  Issue the echo off command to the modem.
 ;   It is assumed that every modem type has the command E0.
 ;   If that changes, you need to build a field into 9002313.54.
 ;
ECHOOFF(DIALOUT)   ;
 N RETVAL
 D LOG^ABSPOSL($T(+0)_" - MODEM - E0 to turn echo off",$G(ECHO))
 D COMMAND^ABSPOSA(DIALOUT,"E0") ; hopefully same for all modem types?
 S RETVAL=$$WAITSTR^ABSPOSAW(DIALOUT,"OK",10) D FLUSH(DIALOUT,1)
 Q:$Q RETVAL Q
 ;
 ;  ATZ   Issue the ATZ (Reset) command to the modem.
 ;   It is assumed that every modem type has the command Z.
 ;   If that changes, you need to build a field into 9002313.54.
 ;
ATZ(DIALOUT) ;EP - return 0 if okay, nonzero if error
 ; added FLUSH calls to give a little cushion around the ATZ command
 N RETVAL
 D ECHOOFF(DIALOUT)
 D LOG^ABSPOSL($T(+0)_" - MODEM - INIT - ATZ command",$G(ECHO))
 D COMMAND^ABSPOSA(DIALOUT,"ATZ") ; hopefully same for all modem types?
 S RETVAL=$$WAITSTR^ABSPOSAW(DIALOUT,"OK",20) D FLUSH(DIALOUT,1)
 D ECHOOFF(DIALOUT) ; in case software reset turned it on again
 Q:$Q RETVAL Q
 ;
 ;  INIMODEM   Send the modem initialization command.
 ;    This varies a lot by modem type.
 ;
INIMODEM(DIALOUT) ;EP - return 0 if okay, nonzero if error
 N RETVAL
 N INI S INI=$P(^ABSP(9002313.54,$$MODEMTYP^ABSPOSA(DIALOUT),"INIT"),U)
 ; ANMC: "AT&FE0&Q1V1X1&E0&E3&E10&E12&E14$MB2400$SB2400#A3"
 D COMMAND^ABSPOSA(DIALOUT,INI)
 D LOG^ABSPOSL($T(+0)_" - MODEM - INIT - command "_INI,$G(ECHO))
 S RETVAL=$$WAITSTR^ABSPOSAW(DIALOUT,"OK",20) D FLUSH(DIALOUT,1)
 Q:$Q RETVAL Q
 ;
 ;    MODEMSTS - Issue the modem's query command and log the output.
 ;       The command comes from 9002313.54, since the query
 ;       command varies a lot from one modem to another.
 ;
MODEMSTS(DIALOUT) ;EP - return 0; or you can just DO it. 
 N IO,RETVAL,CMD,TIMEOUT,LOOK4OK,I,X,% S IO=$$IO^ABSPOSA(DIALOUT)
 N MODEMTYP S MODEMTYP=$$MODEMTYP^ABSPOSA(DIALOUT)
 S %=$G(^ABSP(9002313.54,MODEMTYP,"QUERY FOR STATUS"))
 S CMD=$P(%,U),TIMEOUT=$P(%,U,2),LOOK4OK=$P(%,U,3)
 I CMD="" Q:$Q 0 Q  ; no Inquiry command for this modem type??
 I 'TIMEOUT S TIMEOUT=1
 D LOG^ABSPOSL($T(+0)_" - MODEM - QUERY - command "_CMD,$G(ECHO))
 D COMMAND^ABSPOSA(DIALOUT,CMD)
 U IO
 F I=1:1 R X(I):TIMEOUT Q:'$T  Q:LOOK4OK&($TR(X(I),$C(13,10),"")="OK")
 D LOG^ABSPOSL($T(+0)_" - MODEM - QUERY - reply:",$G(ECHO))
 F I=1:1 Q:'$D(X(I))  D
 .D LOG^ABSPOSL($TR(X(I),$C(13,10),""),$G(ECHO))
 Q:$Q 0 Q
 ;
 ;  DIAL  -  Issue the command to dial the phone
 ;           and wait for the successful CONNECT 2400 response.
 ;
DIAL(DIALOUT) ;EP - return 0 if okay, nonzero if error
 N IO,RETVAL,DIAL S IO=$$IO^ABSPOSA(DIALOUT)
 N DIAL,MODEMTYP,CONNMSG
 S DIAL="ATDT"_$$PHONENUM(DIALOUT)
 S MODEMTYP=$$MODEMTYP^ABSPOSA(DIALOUT)
 S CONNMSG=$P($G(^ABSP(9002313.54,MODEMTYP,"CONNECT MESSAGE")),U)
 D LOG^ABSPOSL($T(+0)_" - MODEM - DIAL - command "_DIAL,$G(ECHO))
 D COMMAND^ABSPOSA(DIALOUT,DIAL)
 N X S X=$T(+0)_" - MODEM - DIAL - "
 I CONNMSG="" D  S RETVAL=0
 .D LOG^ABSPOSL(X_" but no CONNECT MESSAGE in 9002313.54",$G(ECHO))
 E  I '$$WAITSTR^ABSPOSAW(DIALOUT,CONNMSG,40) D  S RETVAL=0
 .D LOG^ABSPOSL(X_"successful",$G(ECHO))
 E  D  S RETVAL=1
 .D LOG^ABSPOSL(X_"did not receive expected "_CONNMSG,$G(ECHO))
 Q:$Q RETVAL Q 0
 ;
 ;   $$PHONENUM   Look up the phone number for this dial out.
 ;
PHONENUM(N)        ;
 N X,Y
 S X=$P($G(^ABSP(9002313.99,1,"OUTSIDE LINE")),U)
 ; If you do need to dial a number to get an outside line,
 ; tack on a comma if needed - modem will pause to wait for
 ; second dial tone.  (No parameter needed yet since apparently
 ; all modems have this feature.)
 I X]"",$E(X,$L(X))'="," S X=X_","
 S Y=$$GET55FLD^ABSPOSA(N,450.01)
 S X=$P(X,U,$S($E(Y)=1:1,1:2)) ; local or long distance?
 Q $S(Y]"":X_Y,1:"")
 ;
 ;   HANGUP  -  Issue the hang up command.
 ;
HANGUP(DIALOUT) ;EP -   this does nothing.
 ; The "W +" and timeout stuff wasn't effective.
 ; Just the CLOSE seems to take care of things okay at ANMC.
 ; This is probably the case at other sites, too.
 N IO S IO=$$IO^ABSPOSA(DIALOUT)
 G HANGUP99
 N TRY,I,ANS
 ;
 ;Make sure input variables are defined
 Q:$G(IO)=""
 ;
 ;Get modem into command mode, then hangup, try up to 3 times
 F TRY=1:1:3 D  Q:ANS=1
 .;O IO
 .H 1
 .F I=1:1:3 U IO W "+"
 .H 2
 .U IO W "ATH0",!
 .H 1
 . D IMPOSS^ABSPOSUE("P","T","Code not reachable","Obsolete subroutine/not used","HANGUP",$T(+0))
 .;need to ; S ANS=$$WaitFor(IO,"OK",2)
 ;
 ;Close input/output device
HANGUP99 ;D CLOSE^ABSPOSAB(DIALOUT)
 Q
