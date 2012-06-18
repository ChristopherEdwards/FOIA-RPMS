INHB ; cmi/flag/maw - JSH,KAC 18 Apr 97 11:03 Background Process Control ; [ 05/14/2002 1:31 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;
STARTUP ;Full interface startup
 D START
 Q
 ;
STOPALL ;Stop all processes
 N INDA,X
 I '$D(IOF) S (%ZIS,IOP)="" D ^%ZIS
 W @IOF,!
 S X=$$YN^UTSRD("Do you really want to shut down all Interface processes? ;1","") Q:'X
 ; Signal all background processes to quit
 F X=1:1:100 K ^INRHB("RUN")
 ; If process opened as server & is active, shut down "hung" active servers
 S INDA=0
 F  S INDA=$O(^INTHPC("ACT",1,INDA)) Q:'INDA  I +$P(^INTHPC(INDA,0),U,8),$$VER(INDA) S X=$$SRVRHNG(INDA)
 W !!,"All processes have been signalled to quit."
 Q
 ;
START ;Start all background processes
 N AVJ,DA,I,VER,CT S AVJ=^%ZOSF("AVJ"),U="^"
 S (CT,DA)=0
 F  S DA=$O(^INTHPC("ACT",1,DA)) Q:'DA  D
 .S DA(0)=$P(^INTHPC(DA,0),U) X AVJ W:Y<1&'$D(ZTSK) !,DA(0)_"NOT Started - not enough available jobs." I Y>0  S VER=1 D  I VER S X=$$A(DA) W:'$D(ZTSK) !,DA(0)_$S(X:"",1:" NOT")_" Started." S:X CT=CT+1
 ..Q:$D(ZTSK)  I $$VER(DA) W !,*7 S X=$$YN^UTSRD("NOTE: "_DA(0)_" appears to be running - continue? ;0","") S:'X VER=0
 Q:$D(ZTSK)
 W !,CT_" processes were started."
 Q
 ;
A(DA) ;Startup a process
 ;DA = entry # in file 4004
 ;Returns 1 if started, 0 otherwise
 ;
 N INERR
 S INERR=$$OKTR(DA) I 'INERR W:'$D(ZTSK) !,?10,*7,INERR Q 0
 N JOB S JOB=$$REPLACE^UTIL(^INTHOS(1,1),"*","^INHB1("_DA_")")
 K ^INRHB("RUN",DA) X JOB F I=1:1:15 L +^INRHB("RUN",DA):0,-^INRHB("RUN",DA) Q:$D(^INRHB("RUN",DA))  H 2 W:'$D(ZTSK) "."
 H 1 Q ''$D(^INRHB("RUN",DA))
 ;
OKTR(X) ;See if OK to run process #X
 ;Returns 1 if OK, 0 otherwise
 Q:'$G(^INRHSITE(1,"ACT")) "Interface system not active - NO ACTION TAKEN."
 Q:'$P($G(^INTHPC(X,0)),"^",2) "Process not active - NO ACTION TAKEN."
 Q:+$G(^INTHPC(X,7)) "Process cannot be started manually - NO ACTION TAKEN."
 Q 1
 ;
START1 ;Restart individual processes
 N DIC,INDA,X,Y
 S DIC="^INTHPC(",DIC(0)="QAE",DIC("S")="I $P(^(0),U,2)",DIC("A")="Select PROCESS to Start: " D ^DIC Q:Y<0
 S INDA=+Y I $$VER(INDA) W !,*7 S X=$$YN^UTSRD("This process appears to be running already - continue? ;0","") G:'X START1
 X ^%ZOSF("AVJ") I Y<1 W !,*7,"No available partitions." Q
 W !?5 S X=$$A(INDA)
 W:X " Started" W:'X !,*7," PROCESS DID NOT START!"
 G START1
 ;
VER(DA) ;Verify entry DA is running
 ;Return 1 if running, 0 if not running, -1 if running but signaled to quit
 G:$G(^INTHOS(1,4))]"" VER1
 L +^INRHB("RUN",DA):1 I  L -^INRHB("RUN",DA) Q 0
 Q:'$D(^INRHB("RUN",DA)) -1
 Q 1
 ;
VER1 ;Come here when OS file has code to do the checking
 N X S X=$P(^INTHPC(DA,0),"^",4) Q:'X 0
 X "N DA "_^INTHOS(1,4) Q:'X 0
 Q:'$D(^INRHB("RUN",DA)) -1
 Q 1
 ;
VERIFY ;Verify if all active processes are running
 D EN^INHOV Q
 ;
 ;Deactivated 2/23/95 by jmb
 N I,OK,S,H S U="^"
 S I=0,OK=1 F  S I=$O(^INTHPC("ACT",1,I)) Q:'I  S S=$$VER(I) W !?5,$P(^INTHPC(I,0),"^")," ",$S('S:"appears to be *NOT* running!",S=-1:"has been signaled to quit.",1:"appears to be running.") S H=$$LAST(I) W:H]"" !?10,"Last run update: "_H
 W !,$$CR^INHU1
 Q
 ;
LAST(I) ;Returns last run update date/time for process #I
 N H S H=$G(^INRHB("RUN",I)) Q:H="" "" Q $$DATEFMT^UTDT(H,"DD MMM YY@HH:II:SS")
 ;
STOP ;Stop a process
 N DIC,INDA,INRUN,INSRVR,X,Y
 S DIC="^INTHPC(",DIC(0)="QAE",DIC("S")="I $P(^(0),U,2)",DIC("A")="Select PROCESS to Stop: " D ^DIC Q:Y<0
 S INDA=+Y
 S INRUN=$$VER(INDA)
 S INSRVR=+$P(^INTHPC(INDA,0),U,8) ; opened as client=0 or server=1
 I 'INRUN!((INRUN=-1)&('INSRVR)) W !,*7 S X=$$YN^UTSRD("This process does not appear to be running - continue? ;0","") Q:'X
 F X=1:1:100 K ^INRHB("RUN",INDA)
 S:$$VER(INDA)&INSRVR X=$$SRVRHNG(INDA) ; shut down "hung" active server
 U 0 W !,"Process has been signaled to terminate."
 Q
 ;
SRVRHNG(INBPN) ; $$function - If a receiver opens a TCP/IP socket, but no 
 ; transmitter makes a connection, the receiver will hang on the 
 ; OPEN^%INET command.  As a result, signalling such a receiver 
 ; background process to shutdown will fail since %INET retains 
 ; control until a connection is received.  The purpose of this 
 ; routine is to supply the awaited connection, at which time the 
 ; background process will receive control, detect the flag to 
 ; shutdown and quit.
 ;
 ; Input:
 ;   INBPN    - BACKGROUND PROCESS CONTROL IEN for process to shut down
 ;
 ; Variables:
 ;   INCHNL   - TCP channel assigned to this server when connection is opened
 ;   INMEM    - memory variable used by %INET
 ;   INPADIE  - IEN of "well-known" IP port multiple for this server
 ;   INPORT   - "well-known" IP port(s) for this server background process
 ; 
 ; Output:
 ;   0 = successful attempt to connect to potentially "hung" server
 ;   1 = attempt to connect to potentially "hung" server was NOT successful
 ;
 N INCHNL,INMEM,INPADIE,INPORT
 ;
 Q:'+$P(^INTHPC(INBPN,0),U,8) 1  ; quit if process opened as client
 Q:'$D(^INTHPC(INBPN,5)) 1  ; quit if no port data for this server
 K ^INRHB("RUN",INBPN) ; signal process to shutdown
 ;
 ; Find/connect to any port(s) associated with this background process
 ; on which a "hung" server may be listening
 S INPADIE=0
 F  S INPADIE=$O(^INTHPC(INBPN,5,INPADIE)) Q:'INPADIE  D
 . S INPORT=$P(^INTHPC(INBPN,5,INPADIE,0),U) Q:'INPORT
 .; Attempt to open as a client to this server on this port
 . D OPEN^%INET(.INCHNL,.INMEM,"0.0.0.0",INPORT,1)
 . ;D OPEN^%INET(.INCHNL,.INMEM,"0.0.0.0",INPORT,1,$G(INBPN))  ;maw cache
 . D:INCHNL CLOSE^%INET(INCHNL)
 . ;D:INCHNL CLOSE^%INET(INCHNL,$G(INBPN))  ;maw cache
 Q 0
 ;
