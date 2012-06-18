HLCSTCP ;SFIRMFO/TNV-ALB/JFP,PKE - (TCP/IP) MLLP ;09/13/2006
 ;;1.6;HEALTH LEVEL SEVEN;**19,43,49,57,58,64,84,109,133**;Oct 13, 1995;Build 13
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ; 
 ; This is an implementation of the HL7 Minimal Lower Layer Protocol
 ;
 ;taskman entry/startup option, HLDP defined in menu entry,
 Q:'$D(HLDP)
 N HLCSOUT,HLDBACK,HLDBSIZE,HLDREAD,HLDRETR,HLRETRA,HLDWAIT,HLOS,HLTCPADD,HLTCPCS,HLTCPLNK,HLTCPORT,HLTCPRET,HLCSFAIL
 ;HLCSOUT= 1-error
 I '$$INIT D EXITS("Init Error") Q
 ; Start the client
 I $G(HLTCPCS)="C" D  Q
 . ; identify process for ^%SY
 . D SETNM^%ZOSV($E("HLClnt:"_HLDP,1,15))
 . D ST1
 . F  D ^HLCSTCP2 Q:$$STOP!$G(HLCSOUT)
 . I $G(HLCSOUT)=1 D MON("Error") H 1 Q
 . I $G(HLCSOUT)=2 D EXITS("Inactive") Q
 . D EXITS("Shutdown")
 ;
 ; identify process for ^%SY
 D SETNM^%ZOSV($E("HLSrv:"_HLDP,1,15))
 ;HLCSFAIL=1 port failed to open
 S HLCSFAIL=1
 ;single threaded listener
 I $G(HLTCPCS)="S" D  Q
 . D ST1,MON("Listen"),LISTEN^%ZISTCP(HLTCPORT,"SERVER^HLCSTCP("""_HLDP_""")")
 . ;couldn't open listener port
 . I HLCSFAIL D EXITS("Openfail") Q
 ;
 ;multi-threaded listener (OpenM)
 I $G(HLTCPCS)="M",^%ZOSF("OS")["OpenM" D  Q
 . D ST1,MON("Listen"),LISTEN^%ZISTCPS(HLTCPORT,"SERVERS^HLCSTCP("""_HLDP_""")")
 Q
 ;
SERVER(HLDP) ; single server using Taskman
 S HLCSFAIL=0
 I '$$INIT D EXITS("Init error") Q
 D ^HLCSTCP1
 I $$STOP D CLOSE^%ZISTCP,EXITS("Shutdown") S IO("C")="" Q
 Q:$G(HLCSOUT)=1
 D MON("Idle")
 Q
 ;
SERVERS(HLDP) ; Multi-threaded server using Taskman
 I '$$INIT D EXITS("Init error") Q
 G LISTEN
 ;
 ;multiple process servers, called from an external utility
MSM ;MSM entry point, called from User-Defined Services
 ;HLDP=ien in the HL LOWER LEVEL PROTOCOL PARAMETER file for the
 ;HL7 Multi-Threaded SERVER
 S (IO,IO(0))=$P
 G LISTEN
 ;
CACHEVMS(%) ;Cache'/VMS tcpip/ucx entry point, called from HLSEVEN.COM file,
 ;listener,  % = HLDP
 I $G(%)="" D ^%ZTER Q
 S IO="SYS$NET",HLDP=%
 S IO(0)="_NLA0:" O IO(0) ;Setup null device
 ; **Cache'/VMS specific code**
 O IO::5 E  D MON("Openfail") Q
 X "U IO:(::""-M"")" ;Packet mode like DSM
 D LISTEN C IO Q
 ;
EN ;vms ucx entry point, called from HLSEVEN.COM file,
 ;listener,  % = device^HLDP
 I $G(%)="" D ^%ZTER Q
 S IO="SYS$NET",U="^",HLDP=$P(%,U,2)
 S IO(0)="_NLA0:" O IO(0) ;Setup null device
 ; **VMS specific code, need to share device**
 O IO:(TCPDEV):60 E  D MON("Openfail") Q
LISTEN ;
 N HLLSTN,HLCSOUT,HLDBACK,HLDBSIZE,HLDREAD,HLDRETR,HLRETRA,HLDWAIT,HLOS,HLTCPADD,HLTCPCS,HLTCPLNK,HLTCPORT,HLTCPRET,HLCSFAIL
 I '$$INIT D ^%ZTER Q
 ; identify process for ^%SY
 D SETNM^%ZOSV($E("HLSrv:"_HLDP,1,15))
 ;HLLSTN used to identify a listener to tag MON
 S HLLSTN=1
 ;increment job count, run server
 D UPDT(1),^HLCSTCP1,EXITM
 Q
 ;
DCOPEN(HLDP) ;open direct connect - called from HLMA2
 Q:'$$INIT 0
 Q:HLTCPADD=""!(HLTCPORT="") 0
 Q:'$$OPEN^HLCSTCP2 0
 Q 1
 ;
INIT() ; Initialize Variables
 ; HLDP should be set to the IEN or name of Logical Link, file 870
 S HLOS=$P($G(^%ZOSF("OS")),"^")
 N DA,DIQUIET,DR,TMP,X,Y
 S DIQUIET=1
 D DT^DICRW
 I 'HLDP S HLDP=$O(^HLCS(870,"B",HLDP,0)) I 'HLDP Q 0
 S DA=HLDP
 S DR="200.02;200.021;200.022;200.03;200.04;200.05;200.09;400.01;400.02;400.03;400.04;400.05"
 D GETS^DIQ(870,DA,DR,"IN","TMP","TMP")
 ;
 I $D(TMP("DIERR")) QUIT 0
 ; -- re-transmit attempts
 S HLDRETR=+$G(TMP(870,DA_",",200.02,"I"))
 S HLDRETR("CLOSE")=+$G(TMP(870,DA_",",200.022,"I"))
 ; -- exceed re-transmit action
 S HLRETRA=$G(TMP(870,DA_",",200.021,"I"))
 ; -- block size
 S HLDBSIZE=+$G(TMP(870,DA_",",200.03,"I"))
 ; -- read timeout
 S HLDREAD=+$G(TMP(870,DA_",",200.04,"I"))
 ; -- ack timeout
 S HLDBACK=+$G(TMP(870,DA_",",200.05,"I"))
 ; -- uni-directional wait
 S HLDWAIT=$G(TMP(870,DA_",",200.09,"I"))
 ; -- tcp address
 S HLTCPADD=$G(TMP(870,DA_",",400.01,"I"))
 ; -- tcp port
 S HLTCPORT=$G(TMP(870,DA_",",400.02,"I"))
 ; -- tcp/ip service type
 S HLTCPCS=$G(TMP(870,DA_",",400.03,"I"))
 ; -- link persistence
 S HLTCPLNK=$G(TMP(870,DA_",",400.04,"I"))
 ; -- retention
 S HLTCPRET=$G(TMP(870,DA_",",400.05,"I"))
 ;
 ; -- set defaults in case something's not set
 S:HLDREAD=0 HLDREAD=10
 S:HLDBACK=0 HLDBACK=60
 S:HLDBSIZE=0 HLDBSIZE=245
 S:HLDRETR=0 HLDRETR=5
 S:HLTCPRET="" X=$P($$PARAM^HLCS2,U,12),HLTCPRET=$S(X:X,1:15)
 ;
 Q 1
 ;
ST1 ;record startup in 870 for single server
 ;4=status 9=Time Started, 10=Time Stopped, 11=Task Number 
 ;14=Shutdown LLP, 3=LLP Online, 18=Gross Errors
 N HLJ,X
 F  L +^HLCS(870,HLDP,0):2 Q:$T
 S X="HLJ(870,"""_HLDP_","")"
 S @X@(4)="Init",(@X@(10),@X@(18))="@",@X@(14)=0
 I HLTCPCS["C" S @X@(3)=$S(HLTCPLNK["Y":"PC",1:"NC")
 E  S @X@(3)=$S(HLTCPCS["S":"SS",HLTCPCS["M":"MS",1:"")
 I @X@(3)'="NC" S @X@(9)=$$NOW^XLFDT
 S:$G(ZTSK) @X@(11)=ZTSK
 D FILE^HLDIE("","HLJ","","ST1","HLCSTCP") ;HL*1.6*109
 L -^HLCS(870,HLDP,0)
 Q
 ;
MON(Y) ;Display current state & check for shutdown
 ;don't display for multiple server
 Q:$G(HLLSTN)
 F  L +^HLCS(870,HLDP,0):2 Q:$T
 S $P(^HLCS(870,HLDP,0),U,5)=Y
 L -^HLCS(870,HLDP,0)
 Q:'$D(HLTRACE)
 N X U IO(0)
 W !,"IN State: ",Y
 I '$$STOP D
 . R !,"Type Q to Quit: ",X#1:1
 . I $L(X),"Qq"[X S $P(^HLCS(870,HLDP,0),U,15)=1
 U IO
 Q
UPDT(Y) ;update job count for multiple servers,X=1 increment
 N HLJ,X
 F  L +^HLCS(870,HLDP,0):2 Q:$T
 S X=+$P(^HLCS(870,HLDP,0),U,5),$P(^(0),U,5)=$S(Y:X+1,1:X-1)_" server"
 ;if incrementing, set the Device Type field to Multi-Server
 I X S HLJ(870,HLDP_",",3)="MS" D FILE^HLDIE("","HLJ","","UPDT","HLCSTCP") ;HL*1.6*109
 L -^HLCS(870,HLDP,0)
 Q
STOP() ;stop flag set
 N X
 F  L +^HLCS(870,HLDP,0):2 Q:$T
 S X=+$P(^HLCS(870,HLDP,0),U,15)
 L -^HLCS(870,HLDP,0)
 Q X
 ;
LLCNT(DP,Y,Z) ;update Logical Link counters
 ;DP=ien of Logical Link in file 870
 ;Y: 1=msg rec, 2=msg proc, 3=msg to send, 4=msg sent
 ;Z: ""=add to counter, 1=subtract from counter
 Q:'$D(^HLCS(870,+$G(DP),0))!('$G(Y))
 N P,X
 S P=$S(Y<3:"IN",1:"OUT")_" QUEUE "_$S(Y#2:"BACK",1:"FRONT")_" POINTER"
 F  L +^HLCS(870,DP,P):2 Q:$T
 S X=+$G(^HLCS(870,DP,P)),^(P)=X+$S($G(Z):-1,1:1)
 L -^HLCS(870,DP,P)
 Q
SDFLD ; set Shutdown? field to yes
 Q:'$G(HLDP)
 N HLJ,X
 F  L +^HLCS(870,HLDP,0):2 Q:$T
 ;14=Shutdown LLP?
 S HLJ(870,HLDP_",",14)=1
 D FILE^HLDIE("","HLJ","","SDFLD","HLCSTCP") ;HL*1.6*109
 L -^HLCS(870,HLDP,0)
 Q
 ;
EXITS(Y) ; Single service shutdown and cleans up
 N HLJ,X
 F  L +^HLCS(870,HLDP,0):2 Q:$T
 ;4=status,10=Time Stopped,9=Time Started,11=Task Number
 S X="HLJ(870,"""_HLDP_","")"
 S @X@(4)=Y,@X@(11)="@"
 S:$G(HLCSOUT)'=2 @X@(10)=$$NOW^XLFDT,@X@(9)="@"
 D FILE^HLDIE("","HLJ","","EXITS","HLCSTCP") ; HL*1.6*109
 L -^HLCS(870,HLDP,0)
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
EXITM ;Multiple service shutdown and clean up
 D UPDT(0)
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
