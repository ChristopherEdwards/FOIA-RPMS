INHFTM1(INBPN,INHSRVR) ; DGH,FRW ; 3 Feb 93 14:54; Format Controller background process - server [ 06/22/2001  2:28 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;;July 1, 2001
 ;COPYRIGHT 1991-2000 SAIC
EN ;Main entry point
 ;INPUT:
 ;   INHSRVR   -  server number
 ;   INBPN     -  ien for output controller
 ;LOCAL:
 ;   DA        -  transaction to process (ien) in ^INLHFTSK
 ;   INHANG    -  time to hang after processing a task, 
 ;                from file #4002 field #.05
 ;   INHER     -  error message
 ;   INHMWAIT  -  maximum time a server should wait for 
 ;                something to process before shutting down, 
 ;                from file #4002 field #2.04
 ;   INHWAIT   -  time since a trascation was processed
 ;   MODE      -  always set to zero (0), used in BACK^INHF
 ;
 L +^INRHB("RUN","SRVR",INBPN,INHSRVR):5 E  Q
 X $G(^INTHOS(1,2))
 Q:'$G(INBPN)!'$G(INHSRVR)!'$$RUN^INHFTM
 K INHER S X="ERROR^INHFTM1",@^%ZOSF("TRAP")
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 ;*** REPLACE WITH STANDARD CALL
 S U="^",DUZ=.5,DUZ(0)="@",IO=""
 S X=$$PRIO^INHB1 X:X ^%ZOSF("PRIORITY")
 ;Set up control variables
 S INHANG=$P($G(^INRHSITE(1,0)),U,5) S:'INHANG INHANG=10
 S INHMWAIT=$P($G(^INRHSITE(1,2)),U,4) S:'INHMWAIT INHMWAIT=60
 S MODE=0,INHWAIT=-INHANG
 ;
LOOP ;Main loop to process transactions
 S INHWAIT=INHWAIT+INHANG
 I '$$RUN^INHFTM!(INHWAIT>INHMWAIT) G HALT
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 L +^INLHFTSK("AH"):3 E  H INHANG G LOOP
 S DA=$$NEXTDA I 'DA L -^INLHFTSK("AH") H INHANG G LOOP
 K ^INLHFTSK("AH",PRIO,H,DA)
 L -^INLHFTSK("AH")
 S INHWAIT=0
 D JOB H INHANG G LOOP
 Q
 ;
JOB ;Run formatter
 ;Any variables that are needed by the server program (^INHFTM1) should be NEWed prior to calling ^INHF
 N INHANG,INHMWAIT,INHWAIT,MODE,INBPN,INHSRVR
 D BACK^INHFTM(DA)
 Q
 ;
NEXTDA() ;Get next transaction off queue
 ;OUTPUT:
 ;   function value - next transaction to process
 ;
 S DAY=+$H,TIME=$P($H,",",2),DA=""
 S P="" F  S P=$O(^INLHFTSK("AH",P)) Q:DA!(P="")  D
 .S H=$O(^INLHFTSK("AH",P,"")) Q:H=""
 .S ND=+H,NT=$P(H,",",2) Q:ND>DAY!(NT>TIME&(ND=DAY))
 .S DA=$O(^INLHFTSK("AH",P,H,"")),PRIO=P
 Q +DA
 ;
ERROR ;Error module for server
 S X="HALT^INHFTM1",@^%ZOSF("TRAP")
 X ^INTHOS(1,3)
 S INHER(1)=$S($D(INHER)#2:INHER,1:$$ERRMSG^INHU1)
 S INHER(2)="in format controller background server for task "_$G(DA)
 ;***DA may not be the transaction being processed - it may have been the previous transaction processed
 S %="" I +$G(DA) S %=$G(^INLHFTSK(DA,0))
 D ENF^INHE($P(%,U,1),$P(%,U,2),$P(%,U,3),"",.INHER)
 ;
HALT ;Halt process
 K ^INRHB("RUN","SRVR",INBPN,INHSRVR)
 L -^INRHB("RUN","SRVR",INBPN,INHSRVR)
 H
 ;
