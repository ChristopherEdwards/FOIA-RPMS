INHOTMSM ; DGH,FRW,JSH,JPD ; 6 Mar 96 13:05; Output Controller background processor 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; Input:
 ;   INBPN - ien of output controller
 ;   INHSRVR - Server number
 ; Local:
 ;   DA - IEN of transaction
 ;   DTTM - DATE AND TIME OF TRANSACTION
 ;
 N X
 S ^INRHB("RUN",INBPN)=$H
 S X=$G(^INRHSITE(1,0)),INHANG=$P(X,U,4) S:'INHANG INHANG=10
 S MODE=+$P(X,U,7),INTHROT=+$P(X,U,9)
 S INCUTOFF=$P(X,U,15) S:INCUTOFF="" INCUTOFF=99999
 S INHSRVMO=+$P($G(^INRHSITE(1,2)),U,1),INAVJ=$G(^%ZOSF("AVJ"))
 S INFSHNG=+$P(^INRHSITE(1,2),U,2)/4 S:INFSHNG>90 INFSHNG=90
 S JOB=^INTHOS(1,1)
 S INHJOB(4)=$$REPLACE^UTIL(JOB,"*","SRVR^INHOTM(INBPN,INHSRVNO)")
 ;note - recover transaction process at some future time
 ;loop until server shutdown.
 F  Q:'$$RUN  D LOOP
 K ^INRHB("RUN",INBPN)
END Q  ;Exit here
 ;
LOOP ;Main loop
 D INRHB(INBPN,"Processing Transaction")
 ;Get next transaction from queue
 S DA=$$NEXTDA(.PRIO,.DTTM),N=DTTM
 I 'DA D INRHB(INBPN,"Idle") H INHANG Q
 E  I $$RUN D NEWSRV
 Q
NEWSRV ;Try to start new server
 N INLKFLG S INLKFLG=0
 Q:'$$RUN
 F INHSRVNO=1:1:MODE L +^INRHB("RUN","SRVR",INBPN,INHSRVNO):0 I $T D  Q
 .S INLKFLG=1
 .;start a new job/server process
 .X INAVJ
 .I Y>1 D
 ..S ^INRHB("RUN","SRVR",INBPN,INHSRVNO)=""
 ..L -^INRHB("RUN","SRVR",INBPN,INHSRVNO) X INHJOB(4) I $T H INTHROT
 .L -^INRHB("RUN","SRVR",INBPN,INHSRVNO)
 ;Hang if nothing got locked since all servers in use
 I 'INLKFLG D
 .D INRHB(INBPN,"Idle")
 .F X=1:1:INFSHNG H 2 Q:'$$RUN
 Q
RUN() ;Function to decide if routine should continue to run
 ;Returns 1 = YES    0 = NO
 L +^INRHB("RUN",INBPN):0,-^INRHB("RUN",INBPN)
 Q:'$G(^INRHSITE(1,"ACT")) 0
 Q:'$D(^INRHB("RUN",INBPN)) 0
 I $D(^%ZOSF("SIGNOFF")) X ^("SIGNOFF") I  K ^INRHB("RUN") Q 0
 Q 1
TYPE(DA) ;Return type of transaction
 ; Input: DA - ien of transaction
 S DEST=$P($G(^INTHU(DA,0)),U,2) I 'DEST S TYPE="" Q ""
 S DOM=$G(^INRHD(DEST,0)),TYPE=$S($P(DOM,U,2):1,$P(DOM,U,3)]"":2,$P(DOM,U,4)]"":3,1:0)
 Q TYPE
SRVR(INBPN,INHSRVR) ;Output controller background processor - server
 ;INPUT
 ;   INHSRVR - server number
 ;   INBPN - ien for output controller
 ;
 Q:'$G(INBPN)!'$G(INHSRVR)
 L +^INRHB("RUN","SRVR",INBPN,INHSRVR):5 E  Q
 X $G(^INTHOS(1,2))
 Q:'$$RUN
 K INHER S X="ERROR^INHOTM",@^%ZOSF("TRAP")
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 D SETENV
 S X=$$PRIO^INHB1 X:X ^%ZOSF("PRIORITY")
 ;Start GIS Background process audit if flag is set in Site Parms File
 N INPNAME S INPNAME=$P(^INTHPC(INBPN,0),U)
 D AUDCHK^XUSAUD D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME,INHSRVR)
 ;Set up control variables
 S INHANG=$P($G(^INRHSITE(1,0)),U,4) S:'INHANG INHANG=10
 S INCUTOFF=$P($G(^INRHSITE(1,0)),U,15) S:'INCUTOFF INCUTOFF=99999
 ;set max wait time
 S INHMWAIT=$P($G(^INRHSITE(1,2)),U,2) S:'INHMWAIT INHMWAIT=60
 ;set server shutdown time
 S INSHTDN=INHMWAIT*3
 S:INSHTDN>3600 INSHTDN=3600 S:INSHTDN<900 INSHTDN=900
 S MODE=0,INHWAIT=-INHANG,INSHTDN1=0
 F  S DEV="" Q:'$$RUN!'$$WAIT  D SVLOOP
HALT ;Halt process
 K ^INRHB("RUN","SRVR",INBPN,INHSRVR)
 L -^INRHB("RUN","SRVR",INBPN,INHSRVR)
 K ^DIJUSV(DUZ)
 ;Stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 H
SVLOOP ;Loop through transactions in the server queue
 S ^INRHB("RUN","SRVR",INBPN,INHSRVR)=$H
 ;Get next transaction from queue
 L +^INLHSCH:3 E  H INHANG Q
 ;Update background process audit
 D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME,INHSRVR)
 S DA=$$NEXTDA(.PRIO,.DTTM),H=DTTM I 'DA L -^INLHSCH H INHANG Q
 ;Determine how to process transaction
 S TYPE=$$TYPE(DA),INHWAIT=0
 D KILL
 L -^INLHSCH
 I '$$TRANSOK Q
 E  D
 .;Single Thread Process transaction new variables needed later
 .N U,INHO,MODE,INAVJ,INJOB,INHANG,INTHROT,INCUTOFF,INHMWAIT,INHWAIT,PRIO,INSHTDN1,INSHTDN,DUZ,DTTM,SV,BP
 .S BP=+$G(INBPN),SV=+$G(INHSRVR)
 .N INBPN,INHSRVR S INBPN=BP,INHSRVR=SV
 .;Start up a job for entry with a Transceiver Routine
 .I TYPE=2 D ^INHOT(DA,1,DEV) Q
 .;Start up a job for entry with a Transaction Type
 .I TYPE=1 D ^INHOS(DA) Q
 .;Start up a job for entry with a Mail recipient
 .I TYPE=3 D ^INHOM(DA) Q
 H INHANG
 Q
WAIT() ;max wait time before shutting down
 ; Return 0 to shut down 1 to not shut down
 S INHWAIT=INHWAIT+INHANG,INSHTDN1=INSHTDN1+INSHTDN
 Q INHWAIT'>INHMWAIT!(INSHTDN1'>INSHTDN)
NEXTDA(PRIO,DTTM,NO) ;Get next transaction off queue
 ; Output: PRIO
 ;         DTTM - Date,Time of transaction
 ;     opt NO - Node to $Q 
 ; Returns: DA - next transaction
 N DAY,TIME K DA
 S DAY=+$H,TIME=$P($H,",",2),DA=""
 S:$G(NO)="" NO="^INLHSCH"
 S NO=$Q(@NO)
 I NO'="" D
 .S P=$$QS(NO,1),DTTM=$$QS(NO,2),ND=+DTTM,NT=$P(DTTM,",",2)
 .I '(P'?1.NP) D
 ..I P'>INCUTOFF,(ND=DAY&(NT'>TIME)!(ND<DAY)) S DA=$$QS(NO,3),PRIO=P Q
 ..S NO="^INLHSCH("_P_",""99999,99999"")"
 ..S DA=$$NEXTDA(.PRIO,.DTTM,NO)
 Q +DA
TRANSOK() ;Verify transaction is ok to process
 L +^INTHU(DA):1 E  Q 0
 S %=$$TYPE(DA)
 L -^INTHU(DA)
 I 'DEST K ^INLHSCH(PRIO,N,DA) S MES="Transaction has no destination." D ENO^INHE("",DA,"",MES),ULOG^INHU(DA,"E",MES) K MES Q 0
 I 'TYPE D KILL S MES="Destination has no method of processing." D ENO^INHE("",DA,DEST,MES),ULOG^INHU(DA,"E",MES) K MES Q 0
 Q 1
KILL ;Kill entry from INLHSCH
 K ^INLHSCH(PRIO,DTTM,DA),^INLHSCH("DEST",DEST,PRIO,DA)
 Q
SETENV ;Set up environment
 S U="^",DUZ=.5,DUZ(0)="@",IO=""
 D SETDT^UTDT
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
ERROR ;Error module for server
 S X="HALT^INHOTM",@^%ZOSF("TRAP")
 X ^INTHOS(1,3)
 D ENO^INHE("",.DA,.DEST,$S($D(INHER):INHER,1:$$ERRMSG^INHU1))
 ;*** SHOULD ALSO NOTE TRANSACTION IF DA EXISTS - MAY NOT BE CORRECT - MAY BE LAST DA PROCESSED
 G HALT
QS(GLB,SUB) ; return subscript
 ; input:  GLB = global reference returned from $Query
 ;         SUB = numeric position of subscript to return
 ; output: returns value of subscript denoted by SUB
 ; mimics $QS except instead of error on bad data, just returns NULL
 N I,N,P,PO,S,X,%
 I SUB<1 S GLB=$TR($P(GLB,"("),"[]","||") D  Q $G(X(SUB))
 . I GLB["|" S X(-1)=$P(GLB,"|",2),X(-1)=$E(X(-1),2,$L(X(-1))-1),X(0)=$P(GLB,"|",1)_$P(GLB,"|",3)
 . E  S X(0)=GLB
 S GLB=$P(GLB,"(",2),GLB=$E(GLB,1,$L(GLB)-1)
 S S=1,P=1,PO=0 F  S X(S)=$P(GLB,",",P,P+PO) Q:'$L(X(S))  S %=$L(X(S),"""")#2 S:% S=S+1,P=P+1+PO,PO=0 S:'% PO=PO+1 Q:S>SUB
 S GLB=$G(X(SUB)),N=$E(GLB)
 I 'N,N'=0 S GLB=$E(GLB,2,$L(GLB)-1),%=0 F  S %=$F(GLB,"""""",%-1) Q:'%  S GLB=$E(GLB,1,%-3)_""""_$E(GLB,%,999)
 Q GLB
