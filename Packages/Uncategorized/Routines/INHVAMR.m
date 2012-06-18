INHVAMR ;JSH; 27 May 94 09:34; VA gateway/MDIS Receiver
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
RECEIVE ;Receiver
 ;INPUT:
 ;  INBPN - background process ien
 ;
 S SYSTEM="VA"  ;magic
LOOP ;Restart at top of queue
 Q:'$D(^INRHB("RUN",INBPN))  S IN=0,^INRHB("RUN",INBPN)=$H
LP1 ;Look for a message using the APS cross reference
 L -^INVAMI(IN) Q:'$D(^INRHB("RUN",INBPN))  S ^INRHB("RUN",INBPN)=$H
 S IN=$O(^INVAMI("APS",0,IN)) G:'IN WAIT
 ;Lock the entry
 L +^INVAMI(IN):0 E  G LP1
 G:'$D(^INVAMI(IN,0)) LP1 G:$P(^INVAMI(IN,0),U,4) LP1
 S ING="INDATA" K INDATA
 S (%,%1)=0 F  Q:%=""  S %=$O(^INVAMI(IN,1,%)) Q:'%  S %1=%1+1,INDATA(%1)=^(%,0) D:INDATA(%1)'[$C(13)  I INDATA(%1)[$C(13) S INDATA(%1)=$TR(INDATA(%1),$C(13))
 . S %2=0 F  S %=$O(^INVAMI(IN,1,%)) Q:'%  S %2=%2+1,INDATA(%1,%2)=^(%,0) I INDATA(%1,%2)[$C(13) S INDATA(%1,%2)=$TR(INDATA(%1,%2),$C(13)) Q
 I '$D(INDATA(2)) D ENR^INHE(INBPN,"Message format error in MDIS message #"_IN) G MP
 I $E(INDATA(2),1,3)="MSA" S DEST="INCOMING ACK",ACK=0 G STORE
 ;Not currently accepting anything except ack messages
 D ENR^INHE(INBPN,"Invalid MDIS message type received entry #"_IN) G MP
 ;
 S X=$P(INDATA(2),U,1,2) I $E(X,1,3)'="EVN" D ENR^INHE(INBPN,"MDIS message entry #"_IN_" does not have the EVN segment in the correct location.") G MP
NOCON S XX=^INVAMI(IN,0)
 ;,A=$P(XX,U,4),A=A+1,$P(^(0),U,4)=A
 ;I A>5 D ENR^INHE(INBPN,"Too many attempts for entry #"_IN) G MP
 S DEST=$P($T(@$P(X,U,2)),";",3),ACK=1
 I DEST="" D ENR^INHE(INBPN,"No known destination for event type "_$P(X,U,2)_" in MDIS message entry #"_IN) G MP
 ;
STORE ;store in UIF
 S MESSID=$P(INDATA(1),U,10) I MESSID="" D ENR^INHE(INBPN,"MDIS message entry #"_IN_" does not have a message ID") G MP
 S MESSID="MDIS-"_MESSID
 ;Call the input driver
 S X=$$NEW^INHD(MESSID,DEST,"MDIS","INDATA",ACK,"I")
 ;If the input driver returns a -1 then the transaction was rejected
 I X<0 D ENR^INHE(INBPN,"MDIS message entry #"_IN_" was rejected by GIS") G MP
 ;
DEL ;Delete entry
 S DIK="^INVAMI(",DA=IN D ^DIK
 ;unlock and return to loop
 L -^INVAMI(IN) G LP1
 ;
MP ;Mark as processed
 S DIE="^INVAMI(",DA=IN,DR=".04///1" D ^DIE
 ;unlock and return to loop
 L -^INVAMI(IN) G LP1
 ;
WAIT ;Wait for new messages to appear in the queue
 H 15 G LOOP
 ;
 ;
DEST ;The following tags are used to determine destination
 ;
