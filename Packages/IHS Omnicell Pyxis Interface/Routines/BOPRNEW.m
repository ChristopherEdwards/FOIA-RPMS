BOPRNEW ;IHS/ILC/ALG/CIA/PLS - ILC Listener;06-Feb-2007 21:19;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1,3**;Jul 26, 2005
 Q
DEBUG ;Call here for testing
 D DT^DICRW
 S BOPLSOC=9002,BOPDIV=1
 ;
 ;Entry used as "ZTRTN" in BOPOMTR
GO ; EP
 I $G(BOPDIV)="" S BOPDIV=1
 ;
 ;Quit if Channel Active field set to NO for Receiving Facility
 I '$P($G(^BOP(90355,1,3,BOPDIV,0)),U,2) G QUIT
 ;Quit if STOP field set to INTERFACE STOPPED
 I $P($G(^BOP(90355,1,12)),U,1)+0>0 G QUIT
 ;
 ;Lock / Test / Quit if a job is already running
 L +^BOP(90355,"L",BOPDIV):99 E  Q
 ;
 ;Listen on socket, start routine
 N %A,ZISOS,X,NIO S ZISOS=^%ZOSF("OS")
 ;IHS exemption approved on March 16, 2005
 I $$NEWERR^%ZTER() N $ETRAP S $ETRAP="D ERR^BOPRNEW"
 E  S X="ERR^BOPRNEW",@^%ZOSF("TRAP")
 ;
 ;Open a channel. Parameter 1 is Socket, parameter 2 is the routine.
 ;S IO("C")=1 ; If not commented out, the channel stops after 1 message
 ;
 ;If this side is supposed to be the client, make the connection
 I $P(^BOP(90355,1,3,BOPDIV,0),U,8)="C" S X=^(0) D
 .S BOPLSOC=$P(X,U,5),X=$P(X,U,3)
 .D CALL^%ZISTCP(X,BOPLSOC) Q:POP
 .D READ
 .K BOPLSOC
 ;
QUIT Q
 ;
READ ;LISTEN^%ZISTCP will call here to read the message.
 S DIQUIET=1,BOPBUF="" D DT^DICRW
 ;
LOOP U IO R X:1 H 1
 I $P($G(^BOP(90355,1,12)),U,1)+0>0 G QUIT ; all interfaces stopped
 I '$L(X) H 5 G LOOP:+$G(^BOP(90355,1,4)),QUIT
 S BOPBUF=X
LOOP1 D RECEIVE(2)
 I $P($G(^BOP(90355,1,12)),U,1)+0>0 G QUIT ; all interfaces stopped
 I +$G(^BOP(90355,1,4)) G LOOP1:$L(BOPBUF),LOOP
 G QUIT
 ;
RECEIVE(BOPWAIT) ;
 N I,J
 ;
 K BOPIN S BOPI=0,U="^" U IO
 ;Calculate Operating System to be able to read properly
 I '$D(BOPOS) S BOPOS=^%ZOSF("OS")
 I BOPOS["MSM" G RMSM
 G RR
 ;
 K BOPIN S BOPI=0,U="^" U IO
 ;
RMSM ; go here if MSM
 S BOPOS("MSMVER")=$$VERSION^%ZOSV()
 S:+BOPOS("MSMVER")=0 BOPOS("MSMVER")=8
 ;
 ;Read
 ;If there are multiple records, BOPIN needs to be
 ;changed to a global array.
 ;
RR ;
 F  D R(BOPWAIT,BOPOS) Q:$S(X="":1,X=$C(28):1,1:"")  D
 .I $E(X)=$C(11) S X=$E(X,2,$L(X)) Q:X=""
 .S BOPI=BOPI+1,BOPIN(BOPI)=X
 ;
 ;Quit if no data received
 Q:'$D(BOPIN)
 ;
 ;Quit if the wrong type of record
 S I=":"_$P($P(BOPIN(1),"|",9),U)_":"
 Q:":DFT:EPQ:EOQ:ETO:"'[I
 ;
 D RSET
 I BOPBUF'="" K BOPIN S BOPI=0 G RR
 Q
 ;
RSET ; file new transaction
 ;Create NEW Record
 ;
 ;First calculate now
 S DIC="^BOP(90355.1,"
 S X=$$NOW^XLFDT()
 ;
 ;Then make sure NOW is unique in the file
 L +^BOP(90355.1,0):1
 F I=X:.000001 Q:'$D(^BOP(90355.1,"B",I))
 K DD,DO S X=I,DIC="^BOP(90355.1,",DIC(0)="F" D FILE^DICN
 L -^BOP(90355.1,0)
 ;
 ;Put data into file -- first mark it "NOT COMPLETE"
 S DIE=90355.1,DR=".1///99;.12///"_BOPDIV_";99///1;99.1///1",DA=+Y
 D ^DIE
 ;
 ;Put data into file
 S J=0 F I=0:0 S I=$O(BOPIN(I)) Q:I<1  S J=J+1,^BOP(90355.1,DA,"DATA",J,0)=BOPIN(I)
 S ^BOP(90355.1,DA,"DATA",0)=U_U_J_U_J_U_$P(^BOP(90355.1,DA,0),".")
 ;
 ;Mark transaction received and Acknowledge
 S DIE=90355.1,DR="99.1///0" D ^DIE S BOPSTOP=1
 S ^BOP(90355.1,"AC",0,DA)=""
 ;  send ack back
 K OUT N A,B S A=BOPIN(1),$P(A,"|",9)="ACK"
 S B=$P(A,"|",2) S:B'["&" B=B_"&",$P(A,"|",2)=B
 S B="MSA|AA|"_DA_"|"
 S OUT(1)=$C(11)_A_$C(13),OUT(2)=B_$C(13)_$C(28)_$C(13)
 S A=0 F  S A=$O(OUT(A)) Q:'A  U IO W OUT(A),!
 ; keep copy in file
 S OUT(0)=$H M ^BOP(90355.1,DA,"OUT")=OUT
 K OUT,A,B
 Q
 ;
RACK ; send ack back
ERR ;
 G QUIT
 ;
 ;Job out at this line to start a new receiver at single division site.
JOB N ZTIO,ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTSK
 S ZTIO="",ZTDTH=$H,ZTRTN="JOBGO^BOPRNEW",ZTDESC="BOP LISTENER"
 D ^%ZTLOAD
 I '$G(ZTSK) D
 .W !,"BOPRNEW job startup Failed"
 Q
JOBGO ;Start a new listener
 S X="Automated Dispense "_$J D SETENV^%ZOSV,DT^DICRW
 S I=$O(^BOP(90355,1,3,1,0)) Q:I<1  S X=^(I,0)
 S BOPLSOC=$P(X,U,5),BOPDIV=$P(X,U)
 S X="ERR^ZU",@^%ZOSF("TRAP"),ER=0
 G GO^BOPRNEW
 ;
R(A,Z) ;Read the TCP/IP channel
 ;This module returns X each time it is called
 ;as a "line" of data (the text terminated by a $C(13)
 ;
 N BOPQ,Y
RGO ;
 ;First look in "buffer" for a segment
 S Y=$F(BOPBUF,$C(13)),BOPQ=0
 I 'Y S BOPQ=1
 I Y S X=$E(BOPBUF,1,Y-2),BOPBUF=$E(BOPBUF,Y,9999) Q
 ;
 ;Since there was no discernable line in the buffer, read the channel
 S X="ERR^BOPRNEW",@^%ZOSF("TRAP")
 I $G(Z)["VAX" R X#200:$S($G(A):A,1:160)
 ;Compliant with M standard
 E  R X:$S(A:A,1:60)
 ;
 ;Add what was read to the buffer
 I $L(X) S BOPBUF=BOPBUF_X
 ;
 ;If there was nothing in the buffer and nothing read then quit
 I BOPQ,'$L(X),$L(BOPBUF) S X=BOPBUF,BOPBUF=""
 I BOPBUF="",BOPQ Q
 S BOPQ=0 G RGO:$L(BOPBUF)
 Q
TEST ;This is used for testing
TSTGO ;
 W $C(11)
 W "MSH|^~\&|OMNICELLRX||PHARM||19940|260855||DFT^P03||P|2.2|",$C(13)
 W "PID|||6|6|MAQQIA^ALAN|",$C(13)
 W "PV1||NU4E^A22^Main2|",$C(13)
 W "FT1||||199401260855||V|1217712^ASPIRIN^03||OR123|1||||||||||NID^NNAME|DR123",$C(13)
 W "ZPM|V|OMNICELLRX|NUE100|3|A|12177121|ASPIRIN|U|112|112|1|NID|NNAME|WID|WNAME|222||Main2||NU4E||125|25|19940126085533||",$C(13)
 W $C(28,13),!
 H 9 R X:9
 U 0
 W !!,"Read from Channel (ACK?): "_X
 W !!,"Don't forget to close the channel."
 Q
