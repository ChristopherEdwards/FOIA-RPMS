INHFTM ;DGH,FRW,JSH,JPD; 11 Oct 1999 20:39 ; GIS Formatter background controller
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;Background process to scan ^INLHFTSK for entries to process
 ;
 ; Input: 
 ;   INBPN - Background Process ien
 ;   INHSRVR - Server number
 ;LOCAL:
 ;   INAVJ    -  executable code to indicate number of available 
 ;               jobs on system, from ^%ZOSF("AVJ")
 ;   INHANG   -  time to hang after starting a new job, 
 ;               from file #4002 field #.05
 ;   INFSHNG  -  Format Server Hang Time for starting new server
 ;   INHSRVMO  -  flag for server/non-server processing mode, 
 ;               from file #4002 field #2.03
 ;   IN       -  transaction to process (ien) in ^INLHFTSK
 ;   JOB(1)   -  executable code to initiate a server
 ;   MODE     -  maximum number of output jobs, 
 ;               from file #4002 field #.1
 ;   DTTM     -  time transaction should be processed at ($H format)
 ;
 ;Intialize local and global variables
 S ^INRHB("RUN",INBPN)=$H,^INLHFTSK("COUNT")=0
 S INHSRVMO=1,MODE=+$P(^INRHSITE(1,0),U,10),INAVJ=^%ZOSF("AVJ")
 S INHANG=$P(^INRHSITE(1,0),U,5) S:'INHANG INHANG=10
 S INFSHNG=+$P(^INRHSITE(1,2),U,4)/4 S:INFSHNG>180 INFSHNG=180
 S JOB(1)=$$REPLACE^UTIL(^INTHOS(1,1),"*","SRVR^INHFTM(INBPN,INHSRVR)")
 D REQUE
 F  Q:'$$RUN  D TMLOOP H 1
 ;exit here
 Q
 ;
TMLOOP ;Main loop to process transactions
 ;Lock and unlock to flush cache
 D INRHB(INBPN,"Process Transaction")
 L +^INRHB("RUN",INBPN):0
 L -^INRHB("RUN",INBPN)
 S ^INRHB("RUN",INBPN)=$H
 ;get next transaction
 S IN=$$NEXTDA(.PRIO,.DTTM),N=DTTM
 ;If no transaction Hang otherwise process it
 I 'IN D INRHB(INBPN,"Idle") H INHANG Q
 E  I $$RUN D NEWSRV(JOB(1))
 Q
 ;
NEWSRV(INJCODE) ;Attempt to start a new server
 ;INPUT:
 ;   INJCODE  -  Code to initiate new server
 ;Variables just hanging around
 ;   INBPN    -  Background process ien (file #4004)
 ;   INAVJ    -  Code to indicate number of available jobs on system
 ;   MODE     -  Maximum number of servers
 ;LOCAL:
 ;   INHSRVR  -  Server number
 ;
 N Y,INHSRVR,INLK
 S INLK=0
 F INHSRVR=1:1:MODE L +^INRHB("RUN","SRVR",INBPN,INHSRVR):0 I $T D  Q
 .S INLK=1
 .X INAVJ I Y>1 D
 ..S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=""
 ..L -^INRHB("RUN","SRVR",INBPN,INHSRVR)
 ..X INJCODE I $T H INHANG
 .L -^INRHB("RUN","SRVR",INBPN,INHSRVR)
 I 'INLK D
 .D INRHB(INBPN,"Idle")
 .F X=1:1:INFSHNG H 2 Q:'$$RUN
 Q
RUN() ;should process continue to run
 ;OUTPUT:
 ;   function value - 1 => continue, 0 => stop
 Q:'$D(^INRHB("RUN",INBPN))!('$G(^INRHSITE(1,"ACT"))) 0
 I $D(^%ZOSF("SIGNOFF")) X ^("SIGNOFF") I $T K ^INRHB("RUN") Q 0
 Q 1
REQUE ;Look for queue entries that were "in process" at prior shut-down
 ;**Need to add if task is older than certain time don't reque
 N TSK,TIME,PRIO,CNT
 S TSK=0,CNT=0 F  S TSK=$O(^INLHFTSK(TSK)) Q:'TSK!(CNT>100)  D
 .S TIME=$P(^INLHFTSK(TSK,0),U,4),PRIO=+$P(^(0),U,6) Q:TIME=""
 .S CNT=CNT+1 Q:$D(^INLHFTSK("AH",PRIO,TIME,TSK))
 .S ^INLHFTSK("AH",PRIO,TIME,TSK)=""
 Q
SRVR(INBPN,INHSRVR) ; Format Controller background process - server
 ;Main entry point
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
 ;   MODE      -  always set to zero (0), used in BACK
 ;
 L +^INRHB("RUN","SRVR",INBPN,INHSRVR):5 E  Q
 X $G(^INTHOS(1,2))
 Q:'$G(INBPN)!'$G(INHSRVR)!'$$RUN
 K INHER S X="ERROR^INHFTM",@^%ZOSF("TRAP")
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 D SETENV^INHUT7
 ;Start GIS Background process audit if flag is set in Site Parms File
 N INPNAME S INPNAME=$P(^INTHPC(INBPN,0),U)
 D AUDCHK^XUSAUD D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME,INHSRVR)
 X:$$PRIO^INHB1 ^%ZOSF("PRIORITY")
 ;Set up control variables
 S INHANG=$P($G(^INRHSITE(1,0)),U,5) S:'INHANG INHANG=10
 S INHMWAIT=$P($G(^INRHSITE(1,2)),U,4) S:'INHMWAIT INHMWAIT=60
 S INSHTDN=INHMWAIT*3 S:INSHTDN>3600 INSHTDN=3600 S:INSHTDN<900 INSHTDN=900
 S MODE=0,INHWAIT=-INHANG,INSHTDN1=0
 F  Q:'$$RUN!'$$WAIT  D LOOP
HALT ;Halt process
 K ^INRHB("RUN","SRVR",INBPN,INHSRVR)
 L -^INRHB("RUN","SRVR",INBPN,INHSRVR)
 K ^DIJUSV(DUZ)
 ;Stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 H
LOOP ;Main loop to process transactions
 D INRHB(INBPN,"SRVR, Process Transaction",INHSRVR)
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 ;Update background process audit
 D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME,INHSRVR)
 L +^INLHFTSK("AH"):3 E  H INHANG Q
 S DA=$$NEXTDA(.PRIO,.DTTM)
 I 'DA D  Q
 .L -^INLHFTSK("AH")
 .D INRHB(INBPN,"Idle",INHSRVR)
 .H INHANG
 K ^INLHFTSK("AH",PRIO,DTTM,DA)
 L -^INLHFTSK("AH")
 S INHWAIT=0
 D BACK(DA,1)
 Q
WAIT() ;max wait time before shutting down
 ; Return 0 to shut down 1 to not shut down
 S INHWAIT=INHWAIT+INHANG,INSHTDN1=INSHTDN1+INSHTDN
 Q INHWAIT'>INHMWAIT!(INSHTDN1'>INSHTDN)
NEXTDA(PRIO,DTTM,NOD) ;Get next transaction off queue
 ;Output: (ref) PRIO - priority
 ;        (ref) DTTM - date,time $H format
 ;        (opt) NOD  - node to $Q
 ;Returns:  DA - function value - next transaction to process
 ;
 N DAY,TIME,INCREF K DA
 ;current date and time, initialize DA="" and NOD=prioriy x-ref
 S DAY=+$H,TIME=$P($H,",",2),DA=""
 S:$G(NOD)="" NOD="^INLHFTSK(""AH"")"
 S NOD=$Q(@NOD)
 I NOD'="" D
 .;get cross ref., priority, Date and Time
 .S INCREF=$QS(NOD,1),PRIO=$QS(NOD,2),DTTM=$QS(NOD,3)
 .;set tran time and tran date
 .S ND=+DTTM,NT=$P(DTTM,",",2)
 .;if PRIO'="",piece 1="AH",transday'>today,(trantime '> now)
 .I PRIO'="",INCREF="AH" D
 ..I (ND=DAY&(NT'>TIME)!(ND<DAY)) S DA=$QS(NOD,4) Q
 ..S NOD="^INLHFTSK(""AH"","_PRIO_",""99999,99999"")"
 ..S DA=$$NEXTDA(.PRIO,.DTTM,NOD)
 Q +DA
 ;
ERROR ;Error module for server
 S X="HALT^INHFTM",@^%ZOSF("TRAP")
 X ^INTHOS(1,3)
 S INHER(1)=$S($D(INHER)#2:INHER,1:$$ERRMSG^INHU1)
 S INHER(2)="in format controller background server for task "_$G(DA)
 ;***DA may not be the transaction being processed - it may have been the previous transaction processed
 S %="" I +$G(DA) S %=$G(^INLHFTSK(DA,0))
 D ENF^INHE($P(%,U,1),$P(%,U,2),$P(%,U,3),"",.INHER)
 G HALT
BACK(INTSK,INHSRVMO) ;Background program entry point
 N INDTTMZ,INHANG,INHMWAIT,INHWAIT,MODE,BP,SV,INORDUZ,INORDIV
 S BP=+$G(INBPN),SV=+$G(INHSRVR)
 N INBPN,INHSRVR S INBPN=BP,INHSRVR=SV
 S X="ERR^INHF",@^%ZOSF("TRAP") X $G(^INTHOS(1,2)) N INDIPA,INIDA,X,INJ
 S U="^" L +^INLHFTSK(INTSK):5 E  Q   ;***SHOULD REQUE TASK
 S X=$P(^INRHSITE(1,0),U,6) X:X ^%ZOSF("PRIORITY")
 I '$D(^INLHFTSK(INTSK,0)) D ERROR^INHF("Task deleted from INLHFTSK - "_INTSK) Q
 S X=^INLHFTSK(INTSK,0),INTT=+X,INIDA=$P(X,U,2),(DUZ,INORDUZ)=$P(X,U,3),INORDIV=$P(X,U,7),INDTTMZ=$P(X,U,4)
 S:$P(X,U,5) DUZ(2)=$P(X,U,5)
 D SETDT^UTDT
 X $G(^INRHSITE(1,1))
 ;Load INDIPA array
 I $D(^INLHFTSK(INTSK,2))>9 M INDIPA=^INLHFTSK(INTSK,2)
 I $D(^INLHFTSK(INTSK,1)) M INIDA=^INLHFTSK(INTSK,1)
 L -^INLHFTSK(INTSK)
 S I="" F  S I=$O(^INRHT("AC",INTT,I)) Q:'I  I $D(^INRHT(I)),$P($G(^(I,0)),U,5) S INJ(+$P(^INRHT(I,0),U,7),I)=""
 I $D(INJ) D
 .S PRIO=.9 F  S PRIO=$O(INJ(PRIO)) Q:'PRIO  D JL
 .S PRIO=0 D JL
 Q
JL ;Loop through jobs at priority PRIO
 S TRT=0 F  S TRT=$O(INJ(PRIO,TRT)) Q:'TRT  D
 .;Preserve original values of INIDA (INDA) and INA (INDIPA)
 .N INA,INDA
 .M INA=INDIPA,INDA=INIDA
 .K INV,UIF
 .S SCR=$P(^INRHT(TRT,0),U,3),DEST=+$P(^INRHT(TRT,0),U,2),INTNAME=$P(^(0),U)
 .;Avoid "no program" error if script is missing
 .I 'SCR S ER=1,ERROR(1)="No script for transaction type "_$P(^INRHT(TRT,0),U)_"  Formatter Task "_$G(INTSK)
 .;Start transaction audit
 .D:$D(XUAUDIT) TTSTRT^XUSAUD(INTNAME,"",$P(^INTHPC(INBPN,0),U),INHSRVR,"SCRIPT")
 .S Z="S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_TRT_",.INDA,.INA,"_DEST_","""",$G(INORDUZ,DUZ),$G(INORDIV))"
 .; execute script if exists and call INTQRY to link UIF with
 .; task number for new DEERS Interface query response. DS
 .I SCR X Z I $G(UIF)>0,$G(INTSK)>0 D
 .. S:'$L($G(INDTTMZ)) INDTTMZ=$$NOW^%ZTFDT
 .. D UPDTUIF^INTQRY(INTSK,INDTTMZ,UIF)
 .;Stop transaction audit
 .D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 .K ^INLHFTSK(INTSK),^INLHFTSK("B",INTT,INTSK)
 .Q:'ER
 .D ENF^INHE(TRT,.INDA,DUZ,.INA,.ERROR)
 Q
INRHB(INBPN,MESS,SRVR,UPDT) ;Update background process file
 ; Input:
 ; INBPN-Background process ien
 ; MESS-Text
 ; SRVR-Server #
 ; LAST- 1 Update 3rd piece to $H, 0 leave 3rd piece
 S UPDT=$G(UPDT)
 I $G(SRVR) S $P(^INRHB("RUN","SRVR",INBPN,SRVR),U,1,2)=$H_U_MESS S:UPDT $P(^(SRVR),U,3)=$H Q
 S $P(^INRHB("RUN",INBPN),U,1,2)=$H_U_MESS S:UPDT $P(^(INBPN),U,3)=$H
 Q
