HLZTCP ;MILW/JMC - HL7 TCP/IP Hybrid Lower Level Protocol Receiver/Sender ;5/18/99  15:42 [ 04/02/2003   8:37 AM ]
 ;;1.6;HEALTH LEVEL SEVEN;**1004**;APR 1, 2003
 ;;1.5;HEALTH LEVEL SEVEN;;JUL 09, 1993
 ;
INIT ;Initialize Variables
 ;REDIRECTED BY FROM HLLP IF IOT IS A CHANNEL DEVICE 08/19/02
 ;I.E. TERMINAL TYPE = CHAN
 N HLZIO,HLZOS,HLZSTATE
 ;S HLZOS=^%ZPSF("OS")
 ;BEGIN IHS MODE **1004** IHS/ITSC/TPF
 S HLZOS=$$VERSION^%ZOSV(1)   ;e.g. Cache for Windows NT (Intel)
 ;                                  MSM for RedHat Linux
 ;END IHS MOD **1004**
 ;
 ;I $D(ZTQUEUED) S ZTREQ="@"
 ;
 I $$NEWERR^%ZTER N $ETRAP S $ETRAP=""
 S X="ERR^HLZTCP",@^%ZOSF("TRAP")
 ;
 I '$D(HLION) D  Q:POP
 . D HOME^%ZIS
 . I POP Q
 . S HLION=$S(ION']"":"UNKNOWN",1:ION)
 ;
 S HLZIO(0)=IO
 ;
 ; Figure out type of connection: 1=Server, 2=Client.
 I HLZOS["DSM" S HLZTCP=$S(IOPAR["ADDRESS":2,1:1)
 I HLZOS["Cache" D
 . N IP
 . S IP=$P(IOPAR,"""",2) ; Extract IP address
 . S HLZTCP=$S(IP?1.3N1P1.3N1P1.3N1P1.3N:2,1:1)
 ;
 ;BEGIN IHS MODE **1004** CHECK FOR MSM SYSTEM  IHS/ITSC/TPF 08/19/02
 I HLZOS["MSM" D
 .S IOP=HLION
 .S %ZIS="N"  ;TROUBLE GETTING 'NO OPEN' TO WORK.
 .D ^%ZIS
 .D ^%ZISC    ;DEVICE 56 STILL OPENED SO HAD TO CLOSE
 .;USE 'USE PARAMETERS' IN DEVICE FILE TO PARSE IP AND PORT
 .S IP=$TR($P($P(IOUPAR,"(",2),","),"""")
 .S PORT=$P($P(IOUPAR,")"),",",2)
 .D CALL^%ZISTCP(IP,PORT,30)
 ;END IHS MOD **1004**
 ;
 S IOP="NULL DEVICE" D ^%ZIS
 I POP G EXIT
 S HLZIO=IO K IOP
 ;
 S HLTIME=$$NOW^XLFDT
 ;
 ;U HLZIO(0)
 ; If TCP client, send a "space" to initiate connection.
 ;I HLZTCP=2 W " ",!
 ;BEGIN IHS MOD **1004** REPLACES THREE LINES ABOVE
 ;IHS/ITSC/TPF 08/19/02 I FOUND THE FOLLOWING THREE LINES
 ;NOT NEEDED FOR MSM CONNECTION
 I HLZOS'["MSM" D
 .U HLZIO(0)
 .; If TCP client, send a "space" to initiate connection.
 .I HLZTCP=2 W " ",!
 ;END IHS MOD **1004**
 ;
 K %,%H,%I,X
 S DTIME=$P($G(HLNDAP0),"^",9),HLTRIES=$P($G(HLNDAP0),"^",5)
 S:DTIME'>0 DTIME=60 S:HLTRIES'>0 HLTRIES=3
 S HLLPC=^%ZOSF("LPC")
 ;
 ;
LOOP ; Infinite loop to check for HL7 messages to send/receive
 F  D  I $$S^%ZTLOAD S ZTSTOP=1 Q
 . S HLLOG=$S($D(^HL(770,"ALOG",HLION)):1,1:0)
 . D CHKREC,CHKSEND
EXIT Q
 ;
ERR ; Trap error
 ; Reset current device to "NULL DEVICE".
 U:$G(HLZIO)'="" HLZIO
 ; Reschedule task.
 I $$EC^%ZOSV["WRITE"!($$EC^%ZOSV["READ") D
 . N ZTDTH,ZTSK
 . S ZTSK=ZTQUEUED,ZTDTH="60S",ZTREQ=""
 . D REQ^%ZTLOAD ; Requeue task in 60 seconds.
 K HLL(1),^TMP("HLR",$J),^TMP("HLS",$J)
 Q
 ;
CHKREC ; Check if there are HL7 messages to receive
 ; Set flag to receive state.
 S HLZSTATE="recv"
 D REC
 ; Received "NAK" message don't know what it goes to.
 I $G(HLZNAK) K HLERR Q 
 I '$D(HLDTOUT),'HLERR D SENDNAK G CHKREC
 I '$D(HLDTOUT) U HLZIO K HLERR D ^HLCHK
 U HLZIO
 Q
 ;
CHKSEND ; Check if there are HL7 messages to send
 ; Set flag to send state.
 S HLZSTATE="send"
 Q:'$D(HLNDAP)
 I '$D(HLNDAP0) S HLNDAP0=$G(^HL(770,HLNDAP,0))
 S HLDA=+$O(^HL(772,"AC","O",+$P(HLNDAP0,U,12),0)) G:'HLDA EX
 S HLDA0=$G(^HL(772,HLDA,0)) G:HLDA0']"" EX
 S HLXMZ=+$P(HLDA0,"^",5)
 I 'HLXMZ D  G EX
 . D STATUS^HLTF0(HLDA,4,"","No pointer to Message file(#3.9)")
 I '$D(^XMB(3.9,HLXMZ)) D  G EX
 . D STATUS^HLTF0(HLDA,4,"","No message found at #"_HLXMZ_" in Message file(#3.9)")
 I '$O(^XMB(3.9,HLXMZ,2,0)) D  G EX
 . D STATUS^HLTF0(HLDA,4,"","No message contents at #"_HLXMZ_" in Message file(#3.9)")
 S (HLI,HLTRIED)=0,HLSDT=+HLDA0
 F HLJ=1:1 S HLI=$O(^XMB(3.9,HLXMZ,2,HLI)) Q:HLI'>0  S ^TMP("HLS",$J,HLSDT,HLJ)=$G(^XMB(3.9,HLXMZ,2,HLI,0))
CS1 ;
 S HLTRIED=HLTRIED+1
 K ^TMP("HLR",$J),HLSDATA
 D SEND
 ; Set flag to awaiting acknowledgement state.
 S HLZSTATE="awaiting ack"
 D REC
 I HLTRIED'=HLTRIES G CS1:$D(HLDTOUT) G CS1:HLZNAK
 G EX:$D(HLDTOUT)
 I HLZNAK D  G EX
 . S HLAC=4,HLMSG="Lower Level Protocol Error - "_$S($E(HLL(1))="X":"Checksum",1:"Character Count")_" Did Not Match"
 . D STATUS^HLTF0(HLDA,HLAC,HLMSG)
 I $S('$D(HLL(1)):1,"BHS,MSH"'[$E(HLL(1),1,3):1,1:0) D  G EX
 . S HLAC=4,HLMSG="Application Level error - Header Segment Missing"
 . D STATUS^HLTF0(HLDA,HLAC,HLMSG)
 K HLXMZ
 U HLZIO
 D CHK^HLCHK,IN^HLTF(HLMTN,HLMID,HLTIME)
 ;
EX K HLAC,HLDA,HLDA0,HLERR,HLMSG,HLI,HLJ,HLSDATA,HLSDT,HLTRIED
 K ^TMP("HLS",$J),^TMP("HLR",$J)
 Q
 ;
CSUM ;Calculate Checksum
 S HLC1=HLC1+$L(X),X=X_HLC2 X HLLPC S HLC2=$C(Y)
 Q
 ;
REC ;Receive a Message
 S %=$$NOW^XLFDT
 I HLTIME<% S HLTIME=%
 E  S HLTIME=$$FMADD^XLFDT(HLTIME,0,0,0,1)
 I HLLOG F  Q:'$D(^TMP("HL",HLION,HLTIME))  S HLTIME=$$FMADD^XLFDT(HLTIME,0,0,0,1)
 K HLL,^TMP("HLR",$J)
 S (HLC2,X0)="",(HLC1,HLI,HLK,HLZEB,HLZNAK)=0
 U HLZIO(0)
 F  R X1#1:DTIME Q:X1=$C(11)  I '$T S HLDTOUT=1 Q
 ; Did not find "Start of block" character.
 I X1'=$C(11) Q
 S X0=X1,HLZLEN=1
REC1 ;
 U HLZIO(0) K HLDTOUT
 R X1#1:DTIME I '$T S HLDTOUT=1
 ; Timed out and buffer empty.
 I $G(HLDTOUT),'$L(X1) Q
 ;
 S X0=X0_X1,HLZLEN=HLZLEN+1
 ; Set "NAK" block type flag.
 I X1="N",HLZLEN=2 S HLZNAK=1
 ; Set "End Block" flag.
 I X1=$C(28) S HLZEB=1
 I X1'=$C(13) G REC1
 I HLZEB,HLZNAK D RECNAK Q
 ;
 ; Process "End Block" if not a "NAK" record.
 I HLZEB S HLC=+$E(X0,6,8),HLB=+$E(X0,1,5),X0=""
 I $L(X0) D
 . I HLLOG D  ;Record Incoming Transmission in Log
 . . S HLII=X0 S:$P(X0,$E(X0,5))="MSH" $P(X0,$E(X0,5),8)=""
 . . S HLI=HLI+1,^TMP("HL",HLION,HLTIME,"REC",HLI)=$TR(X0,$C(11,13)),X0=HLII
 . I HLK,HLK'>2 S HLL(HLK)=$TR(X0,$C(11,13))
 . I HLK S ^TMP("HLR",$J,HLTIME,HLK)=$TR(X0,$C(11,13))
 . S HLK=HLK+1,X=X0 D CSUM
 . S X0=""
 I 'HLZEB G REC1
 S X=HLC2 X HLLPC S HLCSUM=Y,HLERR=$S(HLCSUM'=HLC:"X",HLC1'=HLB:"C",1:1)
 I HLLOG S ^TMP("HL",HLION,HLTIME,"REC","CKS")="Our checksum="_HLCSUM_"/Their checksum="_HLC_"^Our character count="_HLC1_"/Their character count="_HLB
 Q
 ;
RECNAK ; Process Received "NAK" message.
 S HLTIME=$$FMADD^XLFDT(HLTIME,0,0,0,1)
 S HLC=+$E(X0,7,9),HLB=+$E(X0,2,6),X=$E(X0,1) D CSUM
 S X=HLC2 X HLLPC S HLCSUM=Y,HLERR=$S(HLCSUM'=HLC:"X",HLC1'=HLB:"C",1:1)
 S HLL(1)=$TR(X0,$C(11,13,28)),^TMP("HLR",$J,HLTIME,1)=HLL(1)
 I HLLOG D
 . S ^TMP("HL",HLION,HLTIME,"REC",1)=HLL(1)
 . S ^TMP("HL",HLION,HLTIME,"REC","CKS")="Our checksum="_HLCSUM_"/Their checksum="_HLC_"^Our character count="_HLC1_"/Their character count="_HLB
 Q
 ;
SEND ;Send a Message
 N X,Y
 S %=$$NOW^XLFDT
 I HLTIME<% S HLTIME=%
 E  S HLTIME=$$FMADD^XLFDT(HLTIME,0,0,0,1)
 I HLLOG F  Q:'$D(^TMP("HL",HLION,HLTIME))  S HLTIME=$$FMADD^XLFDT(HLTIME,0,0,0,1)
 S (HLI,HLC1)=0,HLC2=""
 D WRITE($C(11)_"D21"_$C(13))
 I '$D(HLSDT) F  S HLI=$O(HLSDATA(HLI)) Q:HLI=""  D WRITE(HLSDATA(HLI)_$C(13))
 I $D(HLSDT) F  S HLI=$O(^TMP("HLS",$J,HLSDT,HLI)) Q:HLI=""  S HLSDATA=^(HLI) D WRITE(HLSDATA_$C(13))
 D FLUSH
 Q
 ;
SENDNAK ; Send a "NAK" message.
 S (HLC1,HLI)=0,HLC2="",HLTIME=$$FMADD^XLFDT(HLTIME,0,0,0,1)
 D WRITE($C(11)_"N21"_$C(13)_HLERR)
 D FLUSH
 K HLSDATA,HLERR
 Q
 ;
WRITE(X) ; Write data in buffer.
 U HLZIO(0)
 W X,!
 I HLLOG S ^TMP("HL",HLION,HLTIME,"SEND",HLI)=$TR(X,$C(11,13))
 D CSUM
 Q
 ;
FLUSH ; Write checksum and flush buffer.
 S X=HLC2 X HLLPC S X=$E("0000",1,(5-$L(HLC1)))_HLC1_$E("00",1,(3-$L(Y)))_Y_$C(28)_$C(13)
 U HLZIO(0)
 ; Do final write for this block and flush buffer.
 W X,!
 I HLLOG S ^TMP("HL",HLION,HLTIME,"SEND","CKS")=$TR(X,$C(11,13,28))
 Q
