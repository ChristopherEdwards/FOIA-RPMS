INHVCRV1 ;KAC,bar ; 17 Aug 95 10:35; Create Application Server (ApS)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
NEWSVR(INBPN,INV,INOA) ; Create Application Server (ApS).
 ;
 ; Input:
 ;   INBPN    - (req) BACKGROUND PROCESS CONTROL IEN for ApS
 ;   INV      - (req) array of inbound msg values to pass to server
 ;   INOA     - (req) array of outbound msg values to pass to server
 ;
 ; Variables:
 ;   INAVJ     - executable code to indicate # of available jobs on
 ;               system, from ^%ZOSF("AVJ")
 ;   INJCODE   - executable code to initiate an Aps server
 ;   INLSTSVR  - last ApS server number used
 ;   INMAXAPS  - maximum # of Application Server (ApS) jobs
 ;               default is 9999, our definition of infinity
 ;   INSRVR    - ApS server #
 ;
 ; Output:
 ;   0 - successfully created an application server
 ;   1 - application server NOT created
 ;
 N L,T,S,Y,INAVJ,INJCODE,INLSTSVR,INMAXAPS,INSRVR
 ;
 S INMAXAPS=$G(^INTHPC(INBPN,7)) ; get node with ApS startup info
 Q:'+INMAXAPS 1  ; valid ApS server?
 ; Get last ApS server # used & max # of ApS processes
 S INLSTSVR=+$P(INMAXAPS,U,3),INMAXAPS=+$P(INMAXAPS,U,2) S:'INMAXAPS INMAXAPS=9999
 ;
 ; Executable code that specifies # of available jobs on system
 S INAVJ=^%ZOSF("AVJ")
 ;
 ; Check for available ApS process slot.  Locked "RUN" node indicates
 ; that this slot is in use.  Wrap to slot 1 when hit maximum slot #.
 ; L = flag indicating when to stop iterating thru the list of slots
 ;     (each slot will be ck'd no more than 2 times)
 ; S = ApS server (slot) #
 S (INSRVR,L)=0,S=INLSTSVR
 F  S S=S+1 S:S>INMAXAPS S=1,L=L+1 Q:L>1  L +^INRHB("RUN","SRVR",INBPN,S):0 I  S INSRVR=S Q
 ;
 ; Update last ApS server # used
 L +^INTHPC(INBPN):0 S $P(^INTHPC(INBPN,7),U,3)=INSRVR L -^INTHPC(INBPN)
 ;
 ; Check for available DSM process slot
 S T=0 I INSRVR X INAVJ I Y>1 D  S Y=$$INRHB^INHUVUT1(INBPN,"",T) ; clr status, T=1 logs success
 . ; T is startup flag
 . S T=1,^INRHB("RUN",INBPN)=$H_"^Starting server "_INSRVR,^INRHB("RUN","SRVR",INBPN,INSRVR)=$H_"^Attempting to start server"
 . ; get program to build job code
 . N INPROG S INPROG=$G(^INTHPC(INBPN,"ROU"))
 . ; verify program and execute, $T should be set from JOB command
 . I $L(INPROG) D @INPROG I 1 X INJCODE S T=$T Q
 . S T=0
 L -^INRHB("RUN","SRVR",INBPN,S)
 Q '(T&INSRVR)
 ;
PWSSRVR ; build executable code to start PWS server
 ;
 ;   INV      - array of inbound msg values to pass to server
 ;                    ZIL2  =  IP address of remote system
 ;                    ZIL3  =  port of remote system
 ;   INOA     - array of outbound msg values to pass to server
 ;                    ZIL4  =  remote user (DUZ)
 ;                    ZIL10 =  key/ticket value for verification
 ;
 S INJCODE=$$REPLACE^UTIL(^INTHOS(1,1),"*","EN^INHVCRA("_INBPN_","_INSRVR_","""_@INV@("ZIL2")_""","_@INV@("ZIL3")_","""_INOA("ZIL10")_""","_INOA("ZIL4")_")")
 Q
