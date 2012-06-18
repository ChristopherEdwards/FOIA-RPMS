HLOQUE ;ALB/CJM- HL7 QUEUE MANAGEMENT - 10/4/94 1pm
 ;;1.6;HEALTH LEVEL SEVEN;**126**;Oct 13, 1995
 ;
INQUE(FROM,QNAME,IEN778,ACTION,PURGE) ;
 ;Will place the message=IEN778 on the IN queue, incoming
 ;Input:
 ;  FROM - sending facility from message header.
 ;         For actions other than incoming messages, its the specified link.
 ;  QNAME - queue named by the application
 ;  IEN778 = ien of the message in file 778
 ;  ACTION - <tag^routine> that should be executed for the application
 ;  PURGE (optional) - PURGE=1 indicates that the purge dt/tm needs to be set by the infiler
 ;     If PURGE("ACKTOIEN") is set, it indicates that the purge dt/tm of
 ;     the original message to this application ack also needs to be set.
 ;Output: none
 ;
 I $G(FROM)="" S FROM="UNKNOWN"
 I '$L($G(QNAME)) S QNAME="DEFAULT"
 S ^HLB("QUEUE","IN",FROM,QNAME,IEN778)=ACTION_"^"_$G(PURGE)_"^"_$G(PURGE("ACKTOIEN"))
 I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","IN",FROM,QNAME)))
 Q
 ;
OUTQUE(LINKNAME,PORT,QNAME,IEN778) ;
 ;Will place the message=IEN778 on the out-going queue
 ;Input:
 ;  LINKNAME = name of (.01) the logical link
 ;  PORT (optional) the port to connect to
 ;  QNAME - queue named by the application
 ;  IEN778 = ien of the message in file 778
 ;Output: none
 ;
 N SUB
 S SUB=LINKNAME
 I PORT S SUB=SUB_":"_PORT
 I '$L($G(QNAME)) S QNAME="DEFAULT"
 S ^HLB("QUEUE","OUT",SUB,QNAME,IEN778)=""
 I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","OUT",SUB,QNAME)))
 Q
 ;
DEQUE(FROMORTO,QNAME,DIR,IEN778) ;
 ;This routine will remove the message=IEN778 from its queue
 ;Input:
 ;  DIR = "IN" or "OUT", denoting the direction that the message is going in
 ;  FROMORTO = for outgoing: the .01 field of the logical link
 ;         for incoming: sending facility
 ;  IEN778 = ien of the message in file 778
 ;Output: none
 ;
 Q:(FROMORTO="")
 I ($G(QNAME)="") S QNAME="DEFAULT"
 D
 .I $E(DIR)="I" S DIR="IN" Q
 .I $E(DIR)="O" S DIR="OUT" Q
 I DIR'="IN",DIR'="OUT" Q
 Q:'$G(IEN778)
 I $D(^HLB("QUEUE",DIR,FROMORTO,QNAME,IEN778)) K ^HLB("QUEUE",DIR,FROMORTO,QNAME,IEN778) I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT",DIR,FROMORTO,QNAME)),-1)
 Q
 ;
STOPQUE(DIR,QUEUE) ;
 ;This API is used to set a stop flag on a named queue.
 ;DIR=<"IN" or "OUT">
 ;QUEUE - the name of the queue to be stopped
 ;
 Q:$G(DIR)=""
 Q:$G(QUEUE)=""
 S ^HLTMP("STOPPED QUEUES",DIR,QUEUE)=1
 Q
STARTQUE(DIR,QUEUE) ;
 ;This API is used to REMOVE the stop flag on a named queue.
 ;DIR=<"IN" or "OUT">
 ;QUEUE - the name of the queue to be stopped
 ;
 Q:$G(DIR)=""
 Q:$G(QUEUE)=""
 K ^HLTMP("STOPPED QUEUES",DIR,QUEUE)
 Q
STOPPED(DIR,QUEUE) ;
 ;This API is used to DETERMINE if the stop flag on a named queue is set.
 ;Input:
 ;  DIR=<"IN" or "OUT">
 ;  QUEUE - the name of the queue to be checked
 ;Output:
 ;  Function returns 1 if the queue is stopped, 0 otherwise
 Q:$G(DIR)="" 0
 Q:$G(QUEUE)="" 0
 I $G(^HLTMP("STOPPED QUEUES",DIR,QUEUE)) Q 1
 Q 0
