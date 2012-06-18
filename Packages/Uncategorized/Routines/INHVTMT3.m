INHVTMT3 ; KAC ; 04 Nov 1999 15:32 ; Multi-threaded TCP/IP socket utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
GETFRAME(INBFR,INFRMCHR,INFRMPOS) ; Create array of framing char positions
 ; in INBFR.  E.g. INFRMPOS(5)=SOM, INFRMPOS(29)=SOM, INFRMPOS(134)=SOM
 ;
 ; Called by: RECEIVE^INHVTMT2
 ;
 ; Input:
 ; INBFR    - (req) Buffer read by %INET (up to 512 bytes long)
 ; INFRMCHR - (req) Framing char(s) to search for
 ;
 ; Output:
 ; INFRMPOS - (pbr) Array of framing chars in INBFR by position
 ;
 N INFOUND
 S INFOUND=0
 F  D  Q:'INFOUND
 . S INFOUND=$F(INBFR,INFRMCHR,INFOUND)
 . Q:'INFOUND
 . S INFRMPOS(INFOUND-$L(INFRMCHR))=INFRMCHR
 Q
 ;
PUTINREC(INMSG) ; Put msg (may only be a piece of msg) into INREC array
 ; Remove msg framing chars from msg portion and decrypt.
 ;
 ; Called by: RECEIVE^INHVTMT2
 ;
 N X,INCLRHDR,INLAST,INMSGHDR,INTYPE
 S INLAST=$S(INMSG[INEOM:1,1:0)
 S:INMSG[INSOM INMSG=$E(INMSG,$F(INMSG,INSOM),$L(INMSG)) ; remove SOM
 S:INLAST INMSG=$TR(INMSG,INEOM) ; remove EOM
 ; PDTS requires that ER & SE msg type be sent to CHCS unencrypted
 ; Check TYPE in msg hdr
 I INSTD="PDTS",'$G(INCLRMSG),(INMSG[INSOD) D
 . S X="" F  S X=$O(@INREC@(X)) Q:'X  S INMSGHDR=$G(INMSGHDR)_@INREC@(X)
 . S INMSGHDR=$G(INMSGHDR)_$P(INMSG,INSOD)
 . S INCLRMSG="^ER^SE^"[(U_$E(INMSGHDR,3,4)_U)
 I INSTD="PDTS",'$G(INCLRMSG) S INCLRHDR=$S((INMSG[INSOD):1,(INRSTATE="SOD"):1,1:0)
 I $D(INSOD),(INMSG[INSOD) S INMSG=$TR(INMSG,INSOD,INEOL) ; grp separator
 ;
 ; Decrypt all except 1st hdr (E.g. SOM-ENP Hdr Data-EOL) and EOM char
 I $L(INMSG),'$G(INCLRMSG) D
 . I $G(INCLRHDR) D  ; do NOT decrypt any part of 1st hdr
 .. S INMSGHDR=$P(INMSG,INEOL)_$S(INMSG[INEOL:INEOL,1:"")
 ..; decrypt after 1st hdr
 .. S INMSG=$P(INMSG,INEOL,2,99999)
 . I $L(INMSG) D
 ..; if partial IV at start of encrypted msg, save til have full IV
 .. I INFIRST,(($L(INIVBLD)+$L(INMSG))<INIVLEN) S INIVBLD=INIVBLD_INMSG,INMSG="" Q
 .. I $L(INIVBLD) D  S INIVBLD=""
 ... I ($L(INIVBLD)+$L(INMSG))'>512 S INMSG=INIVBLD_INMSG Q
 ... S INIVBLD=INIVBLD_$E(INMSG,1,INIVLEN)
 ... S INMSG=$E(INMSG,INIVLEN+1,99999)
 ... D DECRYPT^INCRYPT(.INIVBLD,.X,$L(INIVBLD),INFIRST,0)
 ... S INIVBLD=X,INFIRST=0
 ... D STORE(INIVBLD)
 ..;
 .. D DECRYPT^INCRYPT(.INMSG,.X,$L(INMSG),INFIRST,INLAST)
 .. S INMSG=X,INFIRST=$S(INLAST:1,1:0)
 .;
 . S:$G(INCLRHDR) INMSG=INMSGHDR_INMSG
 ;
 S:INLAST INCLRMSG='$G(INIP("CRYPT"))
 D STORE(INMSG)
 Q
 ;
STORE(INMSG) ; Store decrypted msg in INREC
 Q:'$L(INMSG)
 S:$D(INFS) INMSG=$TR(INMSG,INFS,INDELIM) ; transform field separator
 ; Ck $Storage for rollover to global
 I $S<INSMIN D
 .Q:INREC["^"
 .K ^UTILITY("INREC",$J)
 .M ^UTILITY("INREC",$J)=@INREC K @INREC S INREC="^UTILITY(""INREC"","_$J_")"
 ;
 S INRECCNT=INRECCNT+1,@INREC@(INRECCNT)=INMSG
 Q
 ;
EVAL(ING) ; Evaluate incoming response.  Msg is marked complete
 ; when o/p ctlr runs inbound script.
 ;
 ; Called by: RECEIVE^INHVTMT2
 ;
 ; Input:
 ;   ING   - (req) Array in which decrypted, parsed msg is stored.
 ;
 N INERR,INERRHU,INMSG,INMSGDSP,INMSGLG,INMSGST,INSEQNUM,INUIF,INXUIF,X
 S (INMSGDSP,INMSGLG,INMSGST)=""
 S INMSG="Evaluating response"
 D:$G(INDEBUG) LOG^INHVCRA1(INMSG,8)
 S RUN=$$INRHB^INHUVUT1(INBPN,INMSG)
 ; Start transaction audit for receipt of response
 D:$D(XUAUDIT) TTSTRT^XUSAUD("","",INBPNM,"","RECEIVE")
 ;
 S INERRHU=$$IN^INHUSEN(ING,.INDEST,INDSTR,.INSEQNUM,.INSEND,.INERR,.INXDST,"","",.INMSASTA,1,INSTD)
 ;
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)  ;stop transaction audit
 ;
 ;INERRHU=
 ; 0 - no evaluation errors - kill msg, get next
 ; 1 - transient error - resend msg, log error
 ; 2 - fatal error - reroute msg, log error
 ; 3 - outgoing error - kill msg, log error
 ; 4 - incoming error - allow no-response timeout to cause resend, log error
 ; 5 - internal error - kill msg, get next
 ; 6 - heartbeat/dummy accept - get next
 ; 7 - heartbeat/dummy reject - continue heartbeat
 ;
 D:$G(INDEBUG)
 . I INERRHU D LOG^INHVCRA1("Code "_INERRHU_" evaluating response.",6) Q
 . D LOG^INHVCRA1("Response accepted",9)
 ;
 ; Get originating UIF.  If no INSEQNUM, INERRHU must = 4,6,7
 I $G(INSEQNUM) D  Q:'INUIF  ; exit EVAL if seq #, but no orig UIF
 . S INUIF=$O(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM,""))
 . I 'INUIF D  ; no pending que entry to manage
 .. S INXUIF=$O(^INTHU("ASEQ",INDSTR,INSEQNUM,"")) ; get UIF for debugging
 .. I INERRHU,$D(INERR) D ENR^INHE(INBPN,.INERR)
 .. S INMSG="No pending que entry for response with sequence number "_INSEQNUM_$S(INXUIF:" and UIF="_INXUIF,1:"")_": No further processing performed by "_INBPNM
 .. D ENR^INHE(INBPN,INMSG)
 .. D:$G(INDEBUG) LOG^INHVCRA1(INMSG,8)
 ;
 ; Post-eval processing
 S INMSGST="Msg "_$S(("^0^6^")[(U_INERRHU_U):"accepted",1:"rejected")
 S INMSGLG=INMSGST_" ("_INERRHU_")"_$S($G(INUIF):" for originating UIF= "_INUIF,1:"")
 ;
 ; 0 - no evaluation errors - kill msg, get next
 I INERRHU=0 D
 . D PQKILL^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 . D ULOG^INHU(INUIF,"C") ; mark complete
 ;
 ; 1 - transient error - resend msg, log error
 I INERRHU=1 D
 . I INIP("STRY")'>$P(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM,INUIF),U,2) D  Q
 ..; send tries exceeded, reroute msg to another xceiver
 .. S X=$$GETPEND^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 .. S INMSGDSP=": Rerouting"
 .. I INSTATE'="HB" D
 ... D ERRADD^INHUSEN3(.INERR,"Transceiver entering heartbeat state.")
 ... S INSTATE="HB" ; start heartbeat msgs following this read series
 .;
 .; else, send retries NOT exceeded
 . D RESEND^INHVTMT4(INDSTR,INUIF,INSEQNUM)
 . S INMSGDSP=": Resending"
 ;
 ; 2 - fatal error - reroute msg, log error
 I INERRHU=2 D
 . S X=$$GETPEND^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 . S INMSGDSP=": Rerouting"
 . I INSTATE'="HB" D
 .. D ERRADD^INHUSEN3(.INERR,"Transceiver entering heartbeat state.")
 .. S INSTATE="HB" ; start heartbeat msgs following this read series
 ;
 ; 3 - outgoing (original o/b msg) error - kill msg, log error
 I INERRHU=3 D
 . D PQKILL^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 . S INMSGDSP=": Outbound msg error"
 . D ULOG^INHU(INUIF,"E",.INERR) ; mark err
 ;
 ; 4 - incoming error - allow no-response timeout to cause resend, log error
 ; No sequence # or orig UIF unavailable
 I INERRHU=4 D
 . S INMSGDSP=": Inbound msg error"
 ;
 ; 5 - internal error - kill msg, get next
 I INERRHU=5 D
 . D PQKILL^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 . S INMSGDSP=": Internal error"
 . D ULOG^INHU(INUIF,"E",.INERR) ; mark err
 ;
 ; 6 - heartbeat/dummy transaction accepted - start sending claims
 ; Sequence # = DUMMYTRX and no UIF unavailable
 I INERRHU=6 D
 . S INHBSENT=0,INMSGDSP=": Dummy trx successful"
 .; if 1st time thru and pend que had entries on xceiver startup,
 .;   ck for timeout before sending new entries
 . I INSYNC S INSTATE="TIMEOUT" Q
 . I INSTATE="HB" D
 .. D ERRADD^INHUSEN3(.INERR,"Transceiver exiting heartbeat state.")
 .. S INSTATE="SEND" ; start sending claims
 ;
 ; 7 - heartbeat/dummy transaction rejected - continue in HB state
 ; Sequence # = DUMMYTRX and no UIF unavailable
 I INERRHU=7 D
 . S INMSGST="",INMSGDSP=": Dummy trx failed,Attempt "_INHBSENT_" with no response"
 . S INSTATE="HB",INHBSENT=0  ; reset cnt if dummy response
 ;
 I INERRHU,$D(INERR) D ENR^INHE(INBPN,.INERR)  ; log err
 S INRUNMT=$$INRHB^INHUVUT1(INBPN,INMSGST_INMSGDSP,$S(INERRHU:0,1:1))
 D:$G(INDEBUG) LOG^INHVCRA1(INMSGLG_INMSGDSP,8)
 Q
 ;
DATAFRAG(INBFR,INSTART,INEND) ; Data Fragmentation (possibly across bfrs).
 ; Log error & reset vars.
 ;
 ; Called by: RECEIVE^INHVTMT2
 ;
 ; Input:
 ;  INBFR   - (req) Bfr containing frag
 ;  INSTART - (req) Char from which to start logging frag
 ;  INEND   - (req) Char at which to stop logging frag
 ;
 N INERRMSG,INERRREC
 S INERRREC=$$CLEAN^INHUVUT($E(INBFR,INSTART,INEND))
 ; if crosses bfrs, logs chars in this INBFR only
 S INERRMSG="Data Fragmentation error. Ignored: "_$E(INERRREC,1,450)
 D ENR^INHE(INBPN,INERRMSG)
 D:$G(INDEBUG) LOG^INHVCRA1(INERRMSG,3)
 F I="SOM","SOD","EOM" S INPOS(I)=0
 K @INREC S INREC="REC",INRECCNT=0
 S INRSTATE="SOM"  ; looking for SOM
 S INFIRST=1 ; 1st time thru decryptor per msg
 S INCLRMSG='$G(INIP("CRYPT")) ; 1 = do not decrypt rcv'd msg
 S INIVBLD=""
 Q
 ;
 ;
