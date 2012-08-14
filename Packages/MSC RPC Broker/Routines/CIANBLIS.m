CIANBLIS ;MSC/IND/DKM - MSC RPC Broker ;23-Mar-2011 18:36;PLS
 ;;1.1;CIA NETWORK COMPONENTS;**001007,001008**;Sep 18, 2007
 ;;Copyright 2000-2011, Medsphere Systems Corporation
 ;=================================================================
 ; Start listener process (primary and secondary)
 ;   CIAPORT = Listener port
 ;   CIAIP = IP address of client
 ;   CIAMODE = Connection type:
 ;     0: primary listener - dispatches connections
 ;     1: secondary listener - services individual clients
 ;     2: secondary listener - concurrent mode
 ;
EN(CIAPORT,CIAIP,CIAMODE) ;PEP - See above
 N CIAVER,CIAOS,CIATDEV,CIAQUIT,CIALN,CIAXUT,CIAUCI,CIARETRY,XWBOS,X,Y,$ET,$ES
 D UCI^%ZOSV
 S U="^",CIAUCI=$P(Y,","),CIAMODE=+$G(CIAMODE),CIAIP=$G(CIAIP),(CIAQUIT,CIARETRY)=0
 D MONSTART^CIANBEVT                                                   ; Start background event monitor if not already running
 S:'$G(CIAPORT) CIAPORT=9000                                           ; Default service port
 Q:'$$STATE(1)                                                         ; Quit if listener already running
 S Y=$G(^%ZOSF("OS")),(CIAOS,X)=0
 F XWBOS="DSM","MSM","OpenM" S X=X+1 I Y[XWBOS S CIAOS=X Q
 D:'CIAOS RAISE(15,Y)
 D CLEANUP,STSAVE(0),NULLOPEN,STSAVE(1)
 D:CIAMODE=1 LOGRSRC^%ZOSV("$BROKER HANDLER$",2,1)                     ; Start RUM for Broker Handler
 D CHPRN("CIA"_$S($L(CIAIP):$P(CIAIP,".",3,4)_":"_CIAPORT,1:CIAPORT))  ; Change process name
 D LISTEN
 D:CIAMODE=1 LOGRSRC^%ZOSV("$BROKER HANDLER$",2,2)                     ; Stop RUM for handler
 D:CIAQUIT>0!'CIAMODE STATE(0),STREST(1),^%ZISC,STREST(0),CLEANUP,LOGOUT^XUSRB:$G(DUZ)
 I 'CIAMODE,'CIAQUIT J EN^CIANBLIS(CIAPORT)                            ; Restart primary listener after fatal error
 Q
 ; Entry point for interactive debugging
DEBUG N CIAPORT,CIAIP
 W !!,"Debug Mode Support",!!
 S CIAIP=$$PMPT("Addr","Enter callback IP address.","127.0.0.1")
 Q:U[CIAIP
 S CIAPORT=$$PMPT("Port","Enter callback port.")
 Q:U[CIAPORT
 I $L($T(^%Serenji)),$$ASK^CIAU("Use Serenji Debugger","Y") D  Q
 .N SRJIP,SRJPORT
 .S SRJIP=$$PMPT("Serenji Listener Addr","Enter Serenji listener address",CIAIP)
 .Q:U[SRJIP
 .S SRJPORT=$$PMPT("Serenji Listener Port","Enter Serenji listener port",4321)
 .Q:U[SRJPORT
 .D DEBUG^%Serenji("EN^CIANBLIS(CIAPORT,CIAIP,1)",SRJIP,SRJPORT)
 W !
 D EN(CIAPORT,CIAIP,1)
 Q
PMPT(PMPT,HELP,DFLT) ;
 N RET
PMPTX W PMPT,": ",$S($D(DFLT):DFLT_"// ",1:"")
 R RET:$G(DTIME,30)
 E  S RET=U
 I $D(DFLT),'$L(RET) S RET=DFLT W DFLT
 W !
 I RET["?" W !,HELP,!! G PMPTX
 Q RET
 ; Entry point for MSERVER process (MSM only)
MSERVER D EN(%("PORT"),%("ADDRESS"),2)
 Q
 ; Entry point for UCX process (DSM only)
USERVER D EN($P(%,":",2),$P(%,":"),2)
 Q
 ; Start primary listener
START(CIAPORT) ;EP
 D SSLIS(,CIAPORT,,1),CLEANUP^CIANBUTL
 Q
 ; Stop primary or secondary listener
STOP(CIAPORT,CIAIP) ;EP
 D SSLIS(.CIAIP,CIAPORT,,0)
 Q
 ; Start all primary listeners
STARTALL ;PEP - see above
 D SSALL(1)
 Q
 ; Stop all primary listeners
STOPALL ;PEP - see above
 D SSALL(0)
 Q
 ; Start/stop all registered listeners
SSALL(SS,SL) ;
 N IEN,X
 S SL=$G(SL,$D(ZTQUEUED)),U="^"
 F IEN=0:0 S IEN=$O(^CIANB(19941.22,IEN)) Q:'IEN  S X=^(IEN,0) D
 .I SS,$P(X,U,3) Q
 .W:'SL !,$P(X,U),": "
 .D SSLIS(,$P(X,U,2),$P(X,U,4),SS,SL)
 Q
 ; Start/stop primary listener
SSLIS(CIAIP,CIAPORT,CIAUCI,SS,SL) ;
 N CIALN,X,P1,P2,$ET
 S SL=$G(SL,$D(ZTQUEUED))
 S:'SL $ET="D SSERR^CIANBLIS"
 S P1=$S(SS:"start",1:"stop"),P2=P1_$S(SS:"ed",1:"ped")
 I $$STATE=SS W:'SL "Listener ",$S(SS:"already",1:"not")," running on port ",CIAPORT,!! Q
 I 'SS S @$$LOCKNODE=1
 E  I $L($G(CIAUCI)) D
 .J EN^CIANBLIS(CIAPORT)[CIAUCI]
 E  J EN^CIANBLIS(CIAPORT)
 Q:SL
 W "Waiting for listener to ",P1,"..."
 F X=1:1:5 D
 .H 2
 .W "."
 .S:$$STATE=SS X=99
 I X<99 W "Listener failed to ",P1,!
 E  W "Listener ",P2," on port ",CIAPORT,!
 Q
SSERR W:'$G(SL) "Listener failed to ",P1,": ",$$EC^%ZOSV,!
 S $ET="D UNWIND^%ZTER"
 Q
 ; Main loop
LISTEN N $ET,$ES
 S $ET="D ETRAP1^CIANBLIS",CIARETRY=0,CIAQUIT='$$TCPOPEN
 F  Q:$$QUIT  D
 .N $ET,$ES
 .S:$$DOACTION($S(CIAMODE=2&(CIAOS'=3):"C",CIAMODE:"DPQRSU",1:"C")) CIARETRY=0
 D TCPCLOSE
 Q
 ; Read action and params
 ;  VAC = List of valid action codes
 ; Returns true if valid inputs
DOACTION(VAC) ;
 N NM,SB,RT,VL,PR,CIA,ACT,SEQ,ARG,CIAERR,CIADATA,X
 S CIAERR(0)=0
 D TCPUSE
 S X=$$TCPREAD(8,10)
 Q:$E(X,1,5)'="{CIA}" 0
 S ARG=0,CIA("EOD")=$A(X,6),SEQ=$E(X,7),ACT=$E(X,8)
 F  S NM=$$TCPREADL Q:'$L(NM)  S PR=NM=+NM,RT=$S(PR:"P"_NM,1:"CIA("""_NM_"""") N:PR&'$D(ARG(NM)) @RT D
 .S:PR ARG=$S(NM>ARG:NM,1:ARG),ARG(NM)=""
 .S SB=$$TCPREADL,VL=$$TCPREADL
 .I $L(SB) S RT=RT_$S(PR:"(",1:",")_SB_")"
 .E  S:'PR RT=RT_")"
 .S @RT=VL
 W SEQ
 I '$$ERRCHK^CIANBACT(VAC'[ACT,9,ACT) D
 .N $ET,$ES
 .S $ET="D ETRAP2^CIANBLIS"
 .D @("ACT"_ACT_"^CIANBACT")
 I CIAERR(0) D
 .D SNDERR
 E  I $D(CIADATA) D
 .D REPLY(.CIADATA)
 E  D SNDEOD
 D:'CIAMODE TCPREL
 Q 1
 ; Cleanup environment
CLEANUP K ^TMP("CIANBRPC",$J),^TMP("CIANBLIS",$J),^XUTL("XQ",$J),@$$LOCKNODE
 Q
 ; Returns true if listener should quit
QUIT() S:'CIAQUIT CIAQUIT=+$G(@$$LOCKNODE)
 Q CIARETRY>5!CIAQUIT
 ; Save application state
STSAVE(ST) ;
 D SAVE^XUS1
 K ^TMP("CIANBLIS",$J,ST)
 M ^TMP("CIANBLIS",$J,ST)=^XUTL("XQ",$J)
 Q
 ; Restore application state
STREST(ST) ;
 K ^XUTL("XQ",$J)
 M ^XUTL("XQ",$J)=^TMP("CIANBLIS",$J,ST)
 K IO
 D RESETVAR^%ZIS
 I ST,$D(IO)#2 D
 .N $ET
 .S $ET="S $EC="""" D NULLOPEN^CIANBLIS"
 .U IO
 Q
 ; Establish null device as default IO device
NULLOPEN N %ZIS,IOP,POP
 S %ZIS="0H",IOP="NULL"
 D ^%ZIS,RAISE(16):POP
 U IO
 Q
 ; Open TCP listener port
 ; Returns true if successful
TCPOPEN() ;
 N POP
 S POP=0
 I CIAMODE=2 D
 .S CIATDEV=$S(CIAOS=1:"SYS$NET",CIAOS=2:56,1:$P)
 .I CIAOS=1 O CIATDEV:TCPDEV:5 S POP='$T
 I CIAMODE=1 D
 .D CALL^%ZISTCP(CIAIP,CIAPORT)
 .Q:POP
 .S CIATDEV=IO,IO(0)=IO
 .D:$T(SHARELIC^%ZOSV)'="" SHARELIC^%ZOSV(1)
 I 'CIAMODE D
 .I CIAOS=1 D
 ..S CIATDEV=CIAPORT
 ..O CIATDEV:TCPCHAN:5
 ..S POP='$T
 .I CIAOS=2 S CIATDEV=56
 .I CIAOS=3 D
 ..S CIATDEV="|TCP|"_CIAPORT
 ..O CIATDEV:(:CIAPORT:"DS"):5
 ..S POP='$T
 Q 'POP
 ; Use TCP listener port
TCPUSE I CIAOS=1 U CIATDEV Q
 I CIAOS=2 D  Q
 .I CIAMODE U CIATDEV S:$ZC CIAQUIT=1 Q
 .O CIATDEV
 .U CIATDEV::"TCP"
 .W /SOCKET("",CIAPORT)
 I CIAOS=3 U CIATDEV
 Q
 ; Close TCP listener port
TCPCLOSE C:$D(CIATDEV) CIATDEV
 Q
 ; Release TCP port
TCPREL I CIAOS=1 U CIATDEV:DISCONNECT Q
 I CIAOS=2 C CIATDEV Q
 I CIAOS=3 W *-3,*-2
 Q
 ; Read from listener port
TCPREAD(CNT,TMO) ;
 N X,Y
 S Y="",TMO=$G(TMO,60)
 F  Q:CNT'>0  D
 .R X#CNT:TMO
 .I '$L(X) S Y="",CNT=0 S:CIAMODE=2 CIARETRY=CIARETRY+.5
 .E  S Y=Y_X,CNT=CNT-$L(X)
 Q Y
 ; Read byte from listener port
TCPREADB() ;
 Q $A($$TCPREAD(1))
 ; Read length-prefixed data from input stream
TCPREADL() ;
 N X,L,I,N
 S X=$$TCPREADB
 Q:X=CIA("EOD") ""
 S N=X#16,X=$$TCPREAD(X\16),L=0
 F I=1:1:$L(X) S L=L*256+$A(X,I)
 Q $$TCPREAD(L*16+N)
 ; Raise an exception
RAISE(MSG,P1,P2) ;
 D GETDLG^CIANBUTL(MSG,.MSG,.P1,.P2)
 S $EC=MSG(1)
 Q
 ; Communication error
ETRAP1 N ECSAV
 S $ET="D UNWIND^CIANBLIS Q:$Q 0 Q",ECSAV=$EC,CIARETRY=CIARETRY+1
 D:CIARETRY=1&(ECSAV'["READ") ^%ZTER
 S $EC=ECSAV
 Q
 ; Unwind stack
UNWIND Q:$ES>1
 S $EC=""
 Q
 ; Trapped error, send error info to client
ETRAP2 N ECSAV
 S $ET="D UNWIND^CIANBLIS Q:$Q 0 Q",ECSAV=$$EC^%ZOSV,CIARETRY=CIARETRY+1
 D:CIARETRY=1 ^%ZTER,ERRCHK^CIANBACT(1,1,ECSAV)
 S $EC=ECSAV
 Q
 ; Send a reply
REPLY(DATA,ACK) ;
 D TCPUSE
 W $C(+$G(ACK)),$G(DATA)
 D SNDEOD
 Q
 ; Send error information
SNDERR ;
 N X
 D TCPUSE
 W $C(1)
 D OUT^CIANBACT("CIAERR",1),SNDEOD
 S CIAERR(0)=0
 Q
 ; Send end of data byte if not already sent
SNDEOD I $D(CIA("EOD")) D
 .D TCPUSE
 .W $C(CIA("EOD")),!
 .K CIA("EOD")
 Q
 ; Lock/Unlock listener
 ; CIAACT:  1 = lock, 0 = unlock, missing = return status
 ; Returns true if locked, false if not.
STATE(CIAACT) ;
 N RES,Y
 S Y=$$LOCKNODE
 I '$D(CIAACT) D
 .L +@Y:0
 .S RES='$T
 .L:'RES -@Y
 E  I CIAACT D
 .L +@Y:1
 .S RES=$T
 E  D
 .L -@Y
 .S RES=0
 Q:$Q RES
 Q
 ; Get global reference for lock node
LOCKNODE(LN) ;
 S:'$D(LN) LN=$NA(^[$G(CIAUCI)]XTMP("CIANBLIS",$G(CIAIP)_":"_CIAPORT_$S($G(CIAMODE)=2:":"_$J,1:"")))
 Q:$Q LN
 Q
 ; Change process name to X
CHPRN(X) D SETNM^%ZOSV($E(X,1,15))
 Q
