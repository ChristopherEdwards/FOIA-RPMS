INHVCRA1 ;KAC,JKB ; 7 Mar 96 14:11; Application Server (ApS) Cont'd
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q  ;no top entry
 ;
OPEN(INCHNL,INMEM,INADDR,INPORT,INIP) ; open a TCP socket
 ; Input : INCHNL (req) = will return channel of created socket or error
 ;                        msg if open fails, PBR
 ;         INMEM  ( ? ) = ?? - may be unnecessary, PBR
 ;         INADDR (opt) = IP address of remote server to connect to as a
 ;                        client, or null to open as a server; if null,
 ;                        and PBR, will return address of client that
 ;                        connects
 ;         INPORT (req) = IP port to open (client or server)
 ;         INIP   (req) = array of backround proc params, PBR
 ;         also requires INBPN
 ; Output: void
 N INI,INSTOP
 F INI=1:1:INIP("OTRY") D OPEN^%INET(.INCHNL,.INMEM,.INADDR,INPORT,1) Q:INCHNL  D WAIT^INHUVUT(INBPN,INIP("OHNG"),"",.INSTOP) Q:INSTOP
 I 'INCHNL,INSTOP S INCHNL="process signalled to quit"
 Q
 ;
RECEIVE(INV,INCHNL,INIP,INERR,INMEM) ; read socket
 ; Input : INV    (req) = location to store message, PBR
 ;         INCHNL (req) = socket
 ;         INIP   (req) = array of backround proc params, PBR
 ;         INERR  (opt) = error array, PBR
 ;         INMEM  ( ? ) = ?? - may be unnecessary, PBR
 ;         also requires INBPN,U
 ; Output: 0=ok, 1=no response, 2=failure during receive, 3=fatal err
 ; init vars
 N AP,APREC,INDONE,INORESP,INREC,INSMIN,INTTOT,INULRD,REC
 S (APREC,AP,INDONE,INORESP,INTTOT,INULRD)="",INREC="REC"
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 ; socket read loop
 F  D  Q:INDONE!INORESP
 .D RECV^%INET(.APREC,.INCHNL,INIP("RTO"),1)
 .; handle receive errors
 .I $D(APREC(0)) D  Q
 ..; all but timeouts are fatal
 ..I APREC(0)'["TIMEOUT" S INDONE=1 Q
 ..; handle timeouts
 ..K APREC(0)
 ..S INULRD=INULRD+1 ; increment # of retries
 ..;I INULRD>INIP("RTRY") S INORESP=1 Q  ; retries NOT currently active
 ..D WAIT^INHUVUT(INBPN,INIP("RHNG"),"",.INORESP) Q:INORESP
 ..S INTTOT=INTTOT+INIP("RTO")+INIP("RHNG")
 ..I INTTOT'<INIP("TMAX") S INORESP=1 Q
 .; process end of msg
 .I APREC[$C(28) D
 ..; if end of msg not clean, purge buffer (513 byte msg prob)
 ..I $P(APREC,$C(28),2)'=$C(13) N X S X="" D RECV^%INET(.X,.INCHNL,1,1)
 ..; remove end of msg sequence; set flag
 ..S APREC=$P(APREC,$C(28)),INDONE=1
 .; remove start of msg sequence
 .I APREC[$C(11) S APREC=$P(APREC,$C(11),2)
 .; quit if nothing left
 .Q:'$L(APREC)
 .; switch to global storage if short on memory
 .I $S<INSMIN,INREC'["^" K ^UTILITY("INREC",$J) M ^($J)=@INREC S INREC="^UTILITY(""INREC"","_$J_")"
 .S AP=AP+1,@INREC@(AP)=APREC,INULRD=0
 ; if fatal error
 I $D(APREC(0)) S INERR="fatal error: "_APREC(0) Q 3
 ; if no msg received
 I 'AP S INERR="no message received from remote system" Q 1
 ; if remote system timed-out
 I INORESP S INERR="remote system timed-out during transmission" Q 2
 ; msg receipt completed - parse it
 D PARSE^INHUVUT1 K @INREC
 Q 0
 ;
LOGLOCI ; LOG LOCATION input transform (4004,9.02)
 I X=$E("GLOBAL",1,$L(X)) S X="GLOBAL" Q
 I $L(X)>50 K X Q
 I X[".DAT",$L($$OPENSEQ^%ZTFS1(X,"W")) C X Q
 D TXTPTR^INHU1(3.5,.X,.Y) S:$D(X) X=$P(Y,U)
 Q
 ;
LOGLOCO ; LOG LOCATION output transform (4004,9.02)
 I Y?1.N,$D(^%ZIS(1,Y,0)) S Y=$P(^(0),U)
 Q
 ;
LOG(MSG,TYP,ACK) ; log BACKGROUND PROCESS activity and errors
 ; Input : MSG (req) = status/error/debug message; status msg must be a
 ;                     string, error/debug msg can be a string (PBV) or
 ;                     an array of strings (PBR)
 ;         TYP (opt) = msg type: S=status(def), E=error, or integer
 ;                     corresponding to level of a debug msg
 ;         ACK (opt) = boolean flag; set true only when logging a
 ;                     positive ack (sets piece 3 of run node = $H)
 ;         INBPN,U (req)
 ;         INDEBUG,INDEBUGD,INHSRVR (opt)
 ; Output: void
 ;         INDEBUG,INDEBUGD if not set coming in
 ;         if debug on, will write to debug log (file, device or global)
 ; Local : ENUM = INTERFACE ERROR ptr
 ;         T    = timestamp
 ;         SRVR = server number or 0 if not a multiple background proc
 I '$D(INDEBUG) D DEBUG()
 N SRVR S SRVR=+$G(INHSRVR),TYP=$G(TYP)
 ; if debugging, write to log
 I INDEBUG,INDEBUG'<TYP D
 .I $D(MSG)=1,$L(MSG) S MSG(1)=MSG
 .N J,T S J="",T=$$NOW^%ZTFDT
 .I INDEBUGD="GLOBAL" D  Q
 ..N I S I=$O(^UTILITY("INDEBUG",INBPN,SRVR,$J,""),-1)
 ..F I=I+1:1 S J=$O(MSG(J)) Q:J=""  S ^(I)=T_U_MSG(J) ;NAKED on ^UTILITY
 .U INDEBUGD F  S J=$O(MSG(J)) Q:J=""  W !,INBPN_U_SRVR_U_T_U_MSG(J)
 Q:TYP
 ; on error, log in error file and abbrev msg text to point to it
 I TYP="E" N ENUM D LOAD^INHE("","","","R","","","",.MSG,INBPN,.ENUM) S MSG="Error "_$G(ENUM)
 ; update "run" node (format: Status$H^StatusText^LastPositiveAck$H)
 I SRVR S $P(^INRHB("RUN","SRVR",INBPN,SRVR),U,1,2)=$H_U_MSG S:$G(ACK) $P(^(SRVR),U,3)=$H Q
 S $P(^INRHB("RUN",INBPN),U,1,2)=$H_U_MSG S:$G(ACK) $P(^(INBPN),U,3)=$H
 Q
 ;
DEBUG(L) ; set debug params for a BACKGROUND PROCESS
 ; Input : L (opt) = debug level; "" = look it up (def), 0 = turn it
 ;                   off, positive integer = set it
 ;         also expects INBPN
 ; Output: void
 ;         INDEBUG  = Debug Level
 ;         INDEBUGD = Log Location
 ; if debug level input is null, look it up
 S INDEBUG=$S($L($G(L)):L,1:$P($G(^INTHPC(INBPN,9)),U))
 ; if debug off, close log loc if not a global, then kill var and quit
 I 'INDEBUG D  Q
 .I $L($G(INDEBUGD)) D:INDEBUGD'="GLOBAL" ^%ZISC K INDEBUGD
 ; debug is on - get log loc
 S INDEBUGD=$P(^INTHPC(INBPN,9),U,2)
 ; quit if no need to open (is a global or $P)
 I "GLOBAL"[INDEBUGD S:INDEBUGD="" INDEBUGD=$P Q
 ; if a device ptr, resolve it
 I INDEBUGD,$D(^%ZIS(1,INDEBUGD,0)) S INDEBUGD=$P(^(0),U)
 ; open the device - if can't, use $P
 S IOP=INDEBUGD D ^%ZIS I POP S IOP="" D ^%ZIS
 S INDEBUGD=IO
 Q
