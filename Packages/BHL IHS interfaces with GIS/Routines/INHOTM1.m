INHOTM1(INBPN,INHSRVR) ;DGH,FRW ; 4 Mar 94 09:00; Output controller background processor - server [ 06/22/2001  2:31 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;;July 1, 2001
 ;COPYRIGHT 1991-2000 SAIC
EN ;Main entry point
 ;INPUT
 ;   INHSRVR - server number
 ;   INBPN - ien for output controller
 ;
 Q:'$G(INBPN)!'$G(INHSRVR)
 L +^INRHB("RUN","SRVR",INBPN,INHSRVR):5 E  Q
 X $G(^INTHOS(1,2))
 Q:'$$RUN^INHOTM
 K INHER S X="ERROR^INHOTM1",@^%ZOSF("TRAP")
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 ;***REPLACE WITH STANDARD CALL
 S U="^",DUZ=.5,DUZ(0)="@",IO=""
 S X=$$PRIO^INHB1 X:X ^%ZOSF("PRIORITY")
 ;Set up control variables
 S INHANG=$P($G(^INRHSITE(1,0)),U,4) S:'INHANG INHANG=10
 S INCUTOFF=$P($G(^INRHSITE(1,0)),U,15) S:'INCUTOFF INCUTOFF=99999
 S INHMWAIT=$P($G(^INRHSITE(1,2)),U,2) S:'INHMWAIT INHMWAIT=60
 ;
 S MODE=0,INHWAIT=-INHANG
 ;
LOOP ;Loop through transactions in the server queue
 Q:'$$GETDEV
 S INHWAIT=INHWAIT+INHANG
 I '$$RUN^INHOTM!(INHWAIT>INHMWAIT) G HALT
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 ;Get next transaction from queue
 L +^INLHSCH:3 E  H INHANG G LOOP
 S DA=$$NEXTDA I 'DA L -^INLHSCH H INHANG G LOOP
 ;Determine how to process transaction
 S TYPE=$$TYPE^INHOTM(DA)_"^INHOTM",INHWAIT=0
 K ^INLHSCH(PRIO,H,DA),^INLHSCH("DEST",DEST,PRIO,DA)
 L -^INLHSCH
 ;Verify transaction is ok
 I 'TYPE D  G LOOP
 .  I 'DEST S MES="Transaction has no destination." D ENO^INHE("",DA,"",MES),ULOG^INHU(DA,"E",MES) K MES
 .  I 'TYPE S MES="Destination has no method of processing." D ENO^INHE("",DA,DEST,MES),ULOG^INHU(DA,"E",MES) K MES
 .  H INHANG
 ;Process transaction
 D @TYPE H INHANG G LOOP
 Q
 ;
NEXTDA() ;Get next transaction off queue
 S DAY=+$H,TIME=$P($H,",",2),DA=""
 S P="" F  S P=$O(^INLHSCH(P)) Q:(P'?1.NP)!(P>INCUTOFF)!DA  D
 .S H=$O(^INLHSCH(P,"")) Q:H=""
 .S ND=+H,NT=$P(H,",",2) Q:ND>DAY!(NT>TIME&(ND=DAY))
 .S DA=$O(^INLHSCH(P,H,0)),PRIO=P Q:'DA
 Q +DA
 ;
GETDEV() ;Perform device handling
 ;OUTPUT:
 ;  function value - boolean flag
 ;                     1 => ok , 0 => problems encountered
 ;  DEV  -  $I of device (or NULL), device is open for use
 ;
 ;***NEEDS TO BE COMPLETED
 S DEV=""
 Q 1
 ;
ERROR ;Error module for server
 S X="HALT^INHOTM1",@^%ZOSF("TRAP")
 X ^INTHOS(1,3)
 D ENR^INHE(INBPN,$S($D(INHER):INHER,1:$$ERRMSG^INHU1))   ;***CALL IS WRONG ENO^INHE
 ;*** SHOULD ALSO NOTE TRANSACTION IF DA EXISTS - MAY NOT BE CORRECT - MAY BE LAST DA PROCESSED
 ;
HALT ;Halt process
 K ^INRHB("RUN","SRVR",INBPN,INHSRVR)
 L -^INRHB("RUN","SRVR",INBPN,INHSRVR)
 H
 ;
