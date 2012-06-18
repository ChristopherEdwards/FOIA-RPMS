INHVTMT2 ; KAC ; 02 Nov 1999 17:54 ; Multi-threaded TCP/IP socket utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
RECEIVE(INCHNL,INIP,INERR,INMEM) ; Function - Read messages from
 ; TCP bfr and process into GIS.  Once in this routine, reading is
 ; atomic (the transceiver may be told to stop, but RECEIVE will
 ; finish to a logical conclusion instead of throwing away data
 ; in the buffer or INREC).
 ;
 ; Called by: INHVTMT
 ;
 ; Input:
 ;  INCHNL - (req) Socket from which to read
 ;  INIP   - (pbr) Array of parameters
 ;  INERR  - (pbr) Error array
 ;  INMEM  - not used (placeholder.  %INET secondary memory)
 ;
 ; Function returns:
 ;  0=ok
 ;  1=no response at all
 ;  2=failure in middle of receive
 ;  3=remote system disconnected
 ;
 ;  Note: The check for remote system disconnect is based on a string
 ;  match from utility routine %INET. If that utility is changed, this
 ;  must also be changed.
 ;
 N I,INBFR,INCLRMSG,INDELIM,INDONE,INEOL,INEOM,INFIRST,INFRMPOS,INFS,INIVBLD,INLOGMSG,INMSG,INMSGCNT,INNORESP,INNULLRD,INPOS,INREC,INRECCNT,INRSTATE,INSMIN,INSOD,INSOM,INV,REC,X,Y,Z
 ;
 ; Constants
 S INEOL=INIP("EOL"),INSOM=INIP("SOM"),INEOM=INIP("EOM")
 S:$D(INIP("SOD")) INSOD=INIP("SOD")
 S:$D(INIP("FS")) INFS=INIP("FS")
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 S INDELIM=$$FIELD^INHUT()
 ;
 ; Variables
 S (INBFR,INIVBLD,INMSG)="",(INDONE,INMSGCNT,INNORESP,INNULLRD,INRECCNT)=0
 S INREC="REC" K @INREC
 S INRSTATE="SOM"  ; looking for SOM
 S INFIRST=1 ; 1st time thru decryptor per msg
 S INCLRMSG='$G(INIP("CRYPT")) ; 1 = do not decrypt rcv'd msg
 ;
 ; Main Loop
 F  D  Q:INDONE!INNORESP   ; til no response or disconnect
 . D:$G(INDEBUG) LOG^INHVCRA1("Reading from buffer.",5)
 .; read input bfr (up to 512 bytes)
 . D RECV^%INET(.INBFR,.INCHNL,INIP("RTO"),1)
 .;
 .; Disconnect
 . I $G(INBFR(0))["Remote end disconnect" D  Q
 .. S INDISCNT=INDISCNT+1
 .. I INIP("DTRY")'>INDISCNT D  Q  ; shutdwn xceiver
 ... S INRUNMT=0,INDONE=1
 ... S INLOGMSG="Disconnect retries exceeded for background process "_INBPNM
 ... D:$G(INDEBUG) LOG^INHVCRA1(INLOGMSG,7)
 ... D ENR^INHE(INBPN,INLOGMSG)
 .. S INDONE=3 ; retries not exceeded
 .;
 .; No response (on 1st or subsequent reads, therefore a 1 or 2 error)
 .; Read retries prevent dropping 1st part of msg cos 2nd part was delayed
 . I INBFR="" D  Q
 ..; stop reading if not expecting any responses
 ..; pend que empty, not expecting HB response, not in middle of building msg
 .. I '$D(^INLHDEST(INDSTR,"PEND",INBPN)),(INSTATE'="HB"),'INRECCNT,'$D(INRSTATE("SOMFRAG")) S INPEND=0,INDONE=1 Q
 .. S INNULLRD=INNULLRD+1
 .. I INIP("RTRY")'>INNULLRD S INNORESP=1 Q  ; read tries exceeded
 .. D WAIT^INHUVUT2(INBPN,INIP("RHNG"),"Waiting "_INIP("RHNG")_" seconds to read buffer",.INRUNMT)
 .. S INRUNMT='INRUNMT  ; wait rtns opposite
 ..; if signalled to stop xceiver, stop if not in middle of building msg
 .. I 'INRUNMT,'INRECCNT,'$D(INRSTATE("SOMFRAG")) S INDONE=1 Q
 . S (INNULLRD,INDISCNT)=0 ; reset upon receipt
 .;
 .; Ck for bfr continuation (SOM frags).  If no frags found, continue
 .; search for current state in this new bfr.
 . I $D(INRSTATE("SOMFRAG")) D  ; SOM frags exist from prev read
 .. S X=$L(INSOM)-$L(INRSTATE("SOMFRAG")) ; # SOM chars expected @ start of in this bfr
 .. I (INRSTATE("SOMFRAG")_$E(INBFR,1,X)=INSOM) D
 ...; found frag completion at start of new bfr
 ... D:$G(INRECCNT) DATAFRAG^INHVTMT3(@INREC@(INRECCNT),0,$L(@INREC@(INRECCNT))) ; log msg in progress as data frag
 ... S INBFR=$E(INBFR,X+1,999999) ; remove SOM from msg
 ... S INRSTATE="SOD"  ; SOM found - look for SOD
 .. K INRSTATE("SOMFRAG")
 .;
 .; create array (INFRMPOS) of framing chars in this bfr subscripted by position
 . K INFRMPOS
 . D GETFRAME^INHVTMT3(INBFR,INSOM,.INFRMPOS)
 . D:$D(INSOD) GETFRAME^INHVTMT3(INBFR,INSOD,.INFRMPOS)
 . D GETFRAME^INHVTMT3(INBFR,INEOM,.INFRMPOS)
 .;
 . S INPOS=0,INPOS("PREV")=0  ; must be remembered while reading bfr
 .;
 . F  D  Q:'INPOS  ; scan for multiple msgs til bfr exhausted
 ..;
 ..; Scan bfr for single msg (or portion of msg)
 .. F I="SOM","SOD","EOM" S INPOS(I)=0
 .. F  S INPOS=$O(INFRMPOS(INPOS)) Q:'INPOS  D  Q:INPOS("EOM")
 ... I (INRSTATE="SOM"),(INFRMPOS(INPOS)=INSOM) D  Q
 .... S INPOS("SOM")=INPOS
 .... S INRSTATE=$S($D(INSOD):"SOD",1:"EOM") ; SOD may not be used
 ... I $D(INSOD),(INRSTATE="SOD"),(INFRMPOS(INPOS)=INSOD) D  Q
 .... S INPOS("SOD")=INPOS
 .... S INRSTATE="EOM"
 ... I (INRSTATE="EOM"),(INFRMPOS(INPOS)=INEOM) D  Q
 .... S INPOS("EOM")=INPOS
 .... S INRSTATE="SOM"
 ....; last position this bfr after which to log data frags
 .... S INPOS("PREV")=INPOS
 ...;
 ...; Data Fragmentation (possibly across bfrs)
 ... D DATAFRAG^INHVTMT3(INBFR,INPOS("PREV")+1,INPOS)
 ... S INPOS("PREV")=INPOS
 ...; incorrectly placed SOM may be start of good msg
 ... I INFRMPOS(INPOS)=INSOM D  Q
 .... S INPOS("SOM")=INPOS
 .... S INRSTATE=$S($D(INSOD):"SOD",1:"EOM") ; SOD may not be used
 ...;
 ..; Scanning complete - ck for bfr continuation or SOM fragments
 ..; Scan returns incomplete msg
 .. I 'INPOS D  Q  ; reached end of bfr during scan before finding complete msg
 ...; SOM frags @ end of bfr?
 ... I $L(INSOM)>1,($E(INBFR,$L(INBFR)-$L(INSOM)+1,$L(INBFR))'=INSOM) D
 .... S X=$L(INBFR)+1,Y=$L(INSOM)-1
 .... F I=1:1:Y S Z=$E(INBFR,X-I,$L(INBFR)) I Z=$E(INSOM,1,I) S INRSTATE("SOMFRAG")=Z Q  ; save frags
 ...;
 ... I "^SOD^EOM^"[(U_INRSTATE_U) D  Q  ; bfr continuation
 .... S INMSG=$E(INBFR,INPOS("SOM"),$L(INBFR))
 .... D PUTINREC^INHVTMT3(INMSG)
 ...;
 ...; If looking for SOM, log data frag (if any) thru end of bfr
 ... I (INRSTATE="SOM") D  Q
 .... S X=INPOS("PREV"),Y=$L(INBFR)-$L($G(INRSTATE("SOMFRAG")))
 .... D:((Y-X)>0) DATAFRAG^INHVTMT3(INBFR,INPOS("PREV")+1,Y)
 ..;
 ..; Scan returns complete msg (EOM found)
 .. I INPOS D
 ... I $G(INRECCNT) D  ; multiple-bfrs of data in INREC
 .... S INMSG=$E(INBFR,1,INPOS("EOM"))
 .... D PUTINREC^INHVTMT3(INMSG)
 ... I '$G(INRECCNT) D  ; msg all in 1 bfr (includes SOM frags - $E expects INPOS("SOM")=0)
 .... S INMSG=$E(INBFR,INPOS("SOM"),INPOS("EOM"))
 .... D PUTINREC^INHVTMT3(INMSG)
 ..;
 .. Q:'INRECCNT  ; no complete, raw msg to parse/validate
 ..;
 ..; Process msg @INREC
 .. S INV="INDATA" K @INV
 .. D PARSE^INHUVUT1  ; put INREC into INV
 .. K @INREC S INREC="REC",INRECCNT=0
 .. D EVAL^INHVTMT3(INV)  ; submit msg for validation
 .. K @INV
 .. S INMSGCNT=INMSGCNT+1 ; # msgs read since call to $$RECEIVE
 ;
 ;
 ; Finished reading - return final state of connection
 ;
 ; Remote end disconnected
 I INDONE=3 S INERR=$G(INBFR(0)) K @INREC Q 3
 ;
 ; Remote system timed-out / log error
 I INRECCNT,INNORESP D  Q 2
 . S INERR="Remote system on "_INBPNM_" timed out during transmission of message"
 . D DATAFRAG^INHVTMT3($G(@INREC@(1)),0,$L($G(@INREC@(1)))) ; log msg in progress as data frag
 ;
 ; No message received
 I 'INMSGCNT,INNORESP S INERR="No message received from remote system on transceiver "_INBPNM K @INREC Q 1
 ;
 Q 0
 ;
 ;
