HLOAPP ;ALB/CJM-HL7 -Application Registry ;02/04/2004
 ;;1.6;HEALTH LEVEL SEVEN;**126**;Oct 13, 1995
 ;
GETIEN(NAME) ;given the application name, it finds the ien.  Returns 0 on failure
 Q:'$L($G(NAME)) 0
 N IEN,SUB
 S SUB=$E(NAME,1,60)
 S IEN=0
 F  S IEN=$O(^HLD(779.2,"B",SUB,IEN)) Q:'IEN  Q:$P($G(^HLD(779.2,IEN,0)),"^")=NAME
 Q +IEN
 ;
ACTION(HEADER,ACTION,QUEUE) ;Given the parsed header of a message it returns both the action that should be performed in response to the message and the incoming queue that it should be placed on.
 ;
 ;Input:
 ;  HEADER() subscripts are used: "RECEIVING APPLICATION","SEGMENT TYPE", "MESSAGE TYPE", "EVENT"
 ;Output:
 ;  Function returns 1 on success, 0 on failure
 ;  ACTION (pass by reference) <tag>^<rtn>
 ;  QUEUE (pass by reference) returns the named queue if there is one, else "DEFAULT"
 ;
 N IEN
 S (ACTION,QUEUE)=""
 S IEN=$$GETIEN(HEADER("RECEIVING APPLICATION"))
 Q:'$G(IEN) 0
 I $G(HEADER("SEGMENT TYPE"))="BHS" D
 .S NODE=$G(^HLD(779.2,IEN,0))
 .I $P(NODE,"^",5)]"" D
 ..S ACTION=$P(NODE,"^",4,5)
 .E  I $P(NODE,"^",7)]"" S ACTION=$P(NODE,"^",6,7)
 .I $P(NODE,"^",8)]"" D
 ..S QUEUE=$P(NODE,"^",8)
 .E  I $P(NODE,"^",3)]"" S QUEUE=$P(NODE,"^",3)
 E  I HEADER("SEGMENT TYPE")="MSH" D
 .I HEADER("MESSAGE TYPE")'="",HEADER("EVENT")'="" D
 ..N SUBIEN,NODE
 ..S SUBIEN=$O(^HLD(779.2,IEN,1,"C",HEADER("MESSAGE TYPE"),HEADER("EVENT"),0))
 ..I SUBIEN D
 ...S NODE=$G(^HLD(779.2,IEN,1,SUBIEN,0))
 ...I $P(NODE,"^",5)]"" S ACTION=$P(NODE,"^",4,5)
 ...I $P(NODE,"^",3)]"" S QUEUE=$P(NODE,"^",3)
 ..I ACTION="" S NODE=$G(^HLD(779.2,IEN,0)) I $P(NODE,"^",7)]"" S ACTION=$P(NODE,"^",6,7)
 ..I QUEUE="" S NODE=$G(^HLD(779.2,IEN,0)) I $P(NODE,"^",3)]"" S QUEUE=$P(NODE,"^",3)
 I QUEUE="" S QUEUE="DEFAULT"
 I ACTION="" Q 0
 Q 1
 ;
RTRNLNK(APPNAME) ;
 ;given the name of a receiving application, this returns the return
 ;link for application acks if one is provided.  Otherwise, return
 ;acks are routed based on the information provide in the message hdr
 ;
 Q:(APPNAME="") ""
 N IEN
 S IEN=$$GETIEN(APPNAME)
 Q:IEN $P($G(^HLD(779.2,IEN,0)),"^",2)
 Q ""
 ;
RTRNPORT(APPNAME) ;
 ;Given the name of the sending application, IF the application has its
 ;own listener, its port # is returned.  Application acks should be
 ;returned using that port
 Q:(APPNAME="") ""
 N IEN,LINK
 S IEN=$$GETIEN(APPNAME)
 Q:'IEN ""
 S LINK=$P($G(^HLD(779.2,IEN,0)),"^",9)
 Q:'LINK ""
 Q $$PORT^HLOTLNK(LINK)
