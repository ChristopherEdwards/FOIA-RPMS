BMXMEVN ; IHS/OIT/HMW - BMXNet MONITOR ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 Q
 ;
REGET ;EP
 ;Error trap from REGEVNT, RAISEVNT, and UNREG
 ;
 I '$D(BMXI) N BMXI S BMXI=999
 S BMXI=BMXI+1
 D REGERR(BMXI,99)
 Q
 ;
REGERR(BMXI,BMXERID) ;Error processing
 S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)=BMXERID_$C(30)
 S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)=$C(31)
 Q
 ;
REGEVNT(BMXY,BMXEVENT) ;EP
 ;RPC Called by BMX REGISTER EVENT to inform RPMS server
 ;of client's interest in BMXEVENT
 ;Returns RECORDSET with field ERRORID.
 ;If everything ok then ERRORID = 0;
 ;
 N BMXI
 S BMXI=0
 S X="REGET^BMXMEVN",@^%ZOSF("TRAP")
 S BMXY=$NA(^TMP("BMX",$J)) K @BMXY
 S ^TMP("BMX",$J,0)="I00020ERRORID"_$C(30)
 S ^TMP("BMX EVENT",$J,BMXEVENT)=$G(DUZ)
 ;
 S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)="0"_$C(30)_$C(31)
 Q
 ;
RAISEVNT(BMXY,BMXEVENT,BMXPARAM,BMXBACK,BMXKEY) ;EP
 ;RPC Called to raise event BMXEVENT with parameter BMXPARAM
 ;If BMXBACK = 'TRUE' then event will be raised back to originator
 ;Calls EVENT
 ;Returns a RECORDSET wit the field ERRORID.
 ;If everything ok then ERRORID = 0;
 ;
 N BMXI,BMXORIG
 S BMXI=0
 S BMXORIG=$S($G(BMXBACK)="TRUE":"",1:$J)
 S BMXY=$NA(^TMP("BMX",$J)) K @BMXY
 S ^TMP("BMX",$J,0)="I00020ERRORID"_$C(30)
 S X="REGET^BMXMEVN",@^%ZOSF("TRAP")
 ;
 D EVENT(BMXEVENT,BMXPARAM,BMXORIG,$G(BMXKEY))
 ;
 S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)="0"_$C(30)_$C(31)
 Q
 ;
EVENT(BMXEVENT,BMXPARAM,BMXORIG,BMXKEY) ;PEP - Raise event to interested clients
 ;Clients are listed in ^TMP("BMX EVENT",BMXEVENT,BMXSESS)=DUZ
 ;BMXORIG represents the event originator's session
 ;The event will not be raised back to the originator if BMXORIG is the session of the originator
 ;BMXKEY is a ~-delimited list of security keys.  Only holders of one of these keys
 ;will receive event notification.  If BMXKEY is "" then all registered sessions
 ;will be notified.
 ;
 L +^TMP("BMX EVENT RAISED"):30
 N BMXSESS,BMXINC
 S BMXSESS=0 F  S BMXSESS=$O(^TMP("BMX EVENT",BMXSESS)) Q:'+BMXSESS  D
 . I BMXSESS=$G(BMXORIG) Q
 . I '$D(^TMP("BMX EVENT",BMXSESS,BMXEVENT)) Q
 . ;S BMXDUZ=^TMP("BMX EVENT",BMXEVENT,BMXSESS)
 . S BMXDUZ=^TMP("BMX EVENT",BMXSESS,BMXEVENT)
 . ;TODO: Test if DUZ holds at least one of the keys in BMXKEY
 . S BMXINC=$O(^TMP("BMX EVENT RAISED",BMXSESS,BMXEVENT,99999999),-1)
 . S:BMXINC="" BMXINC=0
 . ;S ^TMP("BMXTRACK",$P($H,",",2))="Job "_$J_" Set "_$NA(^TMP("BMX EVENT RAISED",BMXSESS,BMXEVENT,BMXINC+1))_"="_$G(BMXPARAM)
 . S ^TMP("BMX EVENT RAISED",BMXSESS,BMXEVENT,BMXINC+1)=$G(BMXPARAM) ;IHS/OIT/HMW SAC Exemption Applied For
 . Q
 L -^TMP("BMX EVENT RAISED")
 Q
 ;
POLLD(BMXY) ;EP
 ;Debug Entry Point
 ;D DEBUG^%Serenji("POLLD^BMXMEVN(.BMXY)")
 Q
 ;
POLL(BMXY) ;EP
 ;Check event queue for events of interest to current session
 ;Return DataSet of events and parameters
 ;Called by BMX EVENT POLL
 ;
 N BMXI,BMXEVENT
 S BMXI=0
 S X="POLLET^BMXMEVN",@^%ZOSF("TRAP")
 S BMXY=$NA(^TMP("BMX",$J)) K @BMXY
 S ^TMP("BMX",$J,0)="T00030EVENT"_U_"T00030PARAM"_$C(30)
 L +^TMP("BMX EVENT RAISED"):1 G:'$T POLLEND
 ;
 G:'$D(^TMP("BMX EVENT RAISED",$J)) POLLEND
 S BMXEVENT=0 F  S BMXEVENT=$O(^TMP("BMX EVENT RAISED",$J,BMXEVENT)) Q:BMXEVENT']""  D
 . N BMXINC
 . S BMXINC=0
 . F  S BMXINC=$O(^TMP("BMX EVENT RAISED",$J,BMXEVENT,BMXINC)) Q:'+BMXINC  D
 . . ;Set output array node
 . . S BMXPARAM=$G(^TMP("BMX EVENT RAISED",$J,BMXEVENT,BMXINC))
 . . S BMXI=BMXI+1
 . . S ^TMP("BMX",$J,BMXI)=BMXEVENT_U_BMXPARAM_$C(30)
 . . Q
 . Q
 ;S ^TMP("BMXTRACK",$P($H,",",2))="Job "_$J_" Killed "_$NA(^TMP("BMX EVENT RAISED",$J))
 K ^TMP("BMX EVENT RAISED",$J)
 ;
POLLEND S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)=$C(31)
 L -^TMP("BMX EVENT RAISED")
 Q
 ;
TTESTD(BMXY,BMXTIME) ;Debug entry point
 ;
 ;D DEBUG^%Serenji("TTEST^BMXMEVN(.BMXY,BMXTIME)")
 Q
 ;
TTEST(BMXY,BMXTIME) ;EP Timer Test
 ;
 S X="REGET^BMXMEVN",@^%ZOSF("TRAP")
 S BMXY=$NA(^BMXTMP("BMX",$J)) K @BMXY
 S ^BMXTMP("BMX",$J,0)="I00020HANGTIME"_$C(30)
 I +BMXTIME H BMXTIME
 ;
 S BMXI=1
 S BMXI=BMXI+1
 S ^BMXTMP("BMX",$J,BMXI)=BMXTIME_$C(30)_$C(31)
 ;
 Q
 ;
UNREGALL ;EP
 ;Unregister all events for current session
 ;Called on exit of each session
 ;
 N BMXEVENT
 S BMXEVENT=""
 K ^TMP("BMX EVENT",$J)
 Q
 ;
UNREG(BMXY,BMXEVENT) ;EP
 ;RPC Called by client to Unregister client's interest in BMXEVENT
 ;Returns RECORDSET with field ERRORID.
 ;If everything ok then ERRORID = 0;
 ;
 N BMXI
 S BMXI=0
 S X="REGET^BMXMEVN",@^%ZOSF("TRAP")
 S BMXY=$NA(^TMP("BMX",$J)) K @BMXY
 S ^TMP("BMX",$J,0)="I00020ERRORID"_$C(30)
 K ^TMP("BMX EVENT",$J,BMXEVENT)
 ;
 S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)="0"_$C(30)_$C(31)
 Q
 ;
POLLET ;EP
 ;Error trap from REGEVNT, RAISEVNT, ASYNCQUE and UNREG
 ;
 I '$D(BMXI) N BMXI S BMXI=999
 S BMXI=BMXI+1
 D POLLERR(BMXI,99)
 Q
 ;
POLLERR(BMXI,BMXERID) ;Error processing
 S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)=BMXERID_U_$C(30)
 S BMXI=BMXI+1
 S ^TMP("BMX",$J,BMXI)=$C(31)
 Q
 ;
ASYNCQUD(BMXY,BMXRPC,BMXEVN) ;EP
 ;D DEBUG^%Serenji("ASYNCQUD^BMXMEVN(.BMXY,BMXRPC,BMXEVN)")
 Q
 ; 
ASYNCQUE(BMXY,BMXRPC,BMXEVN) ;EP
 ;RPC Queues taskman to job wrapper ASYNCZTM
 N BMXRPCX
 S BMXRPCX=$P(BMXRPC,$C(30))
 ;RETURNS EVENT NAME, ZTSK in PARAM
 S X="POLLET^BMXMEVN",@^%ZOSF("TRAP")
 S BMXY=$NA(^TMP("BMX ASYNC QUEUE",$J)) K @BMXY
 S ^TMP("BMX ASYNC QUEUE",$J,0)="I00030ERRORID"_U_"I00030PARAM"_$C(30)
 ;
 K BMXSEC
 S BMXSEC=""
 D CHKPRMIT^BMXMSEC(BMXRPCX) ;checks if RPC allowed to run
 N OLDCTXT
 I $L($G(BMXSEC)) D
 . S OLDCTXT=""
 . F  S OLDCTXT=$O(XWBSTATE("ALLCTX",OLDCTXT)) Q:'$L($G(OLDCTXT))  D  I '$L($G(BMXSEC)) Q
 . . D ADDCTXT^BMXMSEC(DUZ,OLDCTXT)
 . . D CHKPRMIT^BMXMSEC(BMXRPCX)
 . . Q
 . Q
 I $L($G(BMXSEC)) D  Q
 . S ^TMP("BMX ASYNC QUEUE",$J,1)=2_U_$G(BMXSEC)_$C(30) ;IHS/OIT/HMW SAC Exemption Applied For
 . S ^TMP("BMX ASYNC QUEUE",$J,2)=$C(31) ;IHS/OIT/HMW SAC Exemption Applied For
 . Q
 ;K ZTSK
CHKOLDOK N ZTSK,ZTRTN,ZTSAVE,ZTDESC,ZTIO,ZTDTH
 S ZTRTN="ASYNCZTM^BMXMEVN"
 S BMXRPC=$TR(BMXRPC,"~",$C(30))
 S ZTSAVE("BMXRPC")=""
 S ZTSAVE("BMXEVN")=""
 S ZTDESC="BMX ASYNC JOB"
 S ZTIO="",ZTDTH=DT
 D ^%ZTLOAD
 ;D @ZTRTN ;Debugging call
 ;
 S ^TMP("BMX ASYNC QUEUE",$J,1)=1_U_$G(ZTSK)_$C(30)
 S ^TMP("BMX ASYNC QUEUE",$J,2)=$C(31)
 ;
 Q
 ;
ASYNCZTM ;EP
 ;Called by Taskman with BMXRPC and BMXEVN defined to
 ; 1) invoke the BMXRPC (RPC NAME^PARAM1^...^PARAMN)
 ; 2) when done, raises event BMXEVN with ZTSK^$J in BMXPARAM
 ;
 N BMXRTN,BMXTAG,BMXRPCD,BMXCALL,BMXJ,BMXY,BMXNOD,BMXY
 N BMXT S BMXT=$C(30)
 I $E(BMXRPC,1,6)="SELECT" S BMXRPC="BMX SQL"_$C(30)_BMXRPC
 S BMXRPCD=$O(^XWB(8994,"B",$P(BMXRPC,BMXT),0))
 S BMXNOD=^XWB(8994,BMXRPCD,0)
 S BMXRTN=$P(BMXNOD,U,3)
 S BMXTAG=$P(BMXNOD,U,2)
 S BMXCALL="D "_BMXTAG_"^"_BMXRTN_"(.BMXY,"
 F BMXJ=2:1:$L(BMXRPC,BMXT) D
 . S BMXCALL=BMXCALL_$C(34)_$P(BMXRPC,BMXT,BMXJ)_$C(34)
 . S:BMXJ<$L(BMXRPC,BMXT) BMXCALL=BMXCALL_","
 . Q
 S BMXCALL=BMXCALL_")"
 X BMXCALL
 D EVENT(BMXEVN,$G(ZTSK)_"~"_$P($G(BMXY),U,2),$J,"")
 Q
 ;
 ;
 ;Windows event handler:
 ;Catches event with ZTSK^DataLocation parameter
 ;Matches ZTSK to process that called event
 ;Calls ASYNCGET rpc with DATALOCATION parameter
 ;
ASYNCGET(BMXY,BMXDATA) ;EP
 ;RPC Retrieves data queued by ASYNCZTM
 ;by setting BMXY to BMXDATA
 ;
 S BMXY="^"_BMXDATA
 Q
 ;
ASYNCET ;EP
 ;Error trap from ASYNCQUE
 ;
 I '$D(BMXI) N BMXI S BMXI=999
 S BMXI=BMXI+1
 D ASYNCERR(BMXI,0)
 Q
 ;
ASYNCERR(BMXI,BMXERID) ;Error processing
 S BMXI=BMXI+1
 S ^TMP("BMX ASYNC QUEUE",$J,BMXI)=BMXERID_U_$C(30)
 S BMXI=BMXI+1
 S ^TMP("BMX ASYNC QUEUE",$J,BMXI)=$C(31)
 Q
