RAIPST16 ;HIRMFO/BNT - Post-init number one (patch twelve) ;5/19/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**12**;Mar 16, 1998
 ;
EN1 ; Add entries to the Protocol (101) file.
 ; ***   Adding entries to the Protocol (101) file   ***
 I '$D(^ORD(101,"B","RA PSCRIBE ORM")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE ORM"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-PSCRIBE-TCP"
 . S RAFDA(101,"+1,",770.3)="ACK"
 . S RAFDA(101,"+1,",770.4)="O01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",770.7)="RA-PSCRIBE"
 . S RAFDA(101,"+1,",770.11)="ORM"
 . S RAFDA(101,"+1,",771)="Q"
 . S RAFDA(101,"+1,",773.1)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.2)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.3)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.4)=$$Y^RAIPST12()
 . D MSG^RAIPST12("RA PSCRIBE ORM",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA PSCRIBE ORM")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA PSCRIBE ORM",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA REG 2.3, RA EXAMINED 2.3,"
 .. S ^ORD(101,RA101,1,2,0)="and RA CANCEL 2.3 event protocols.  It is used by the VISTA HL7 package to"
 .. S ^ORD(101,RA101,1,3,0)="send ORM messages to TCP/IP recipients.  This protocol should be entered"
 .. S ^ORD(101,RA101,1,4,0)="in the ITEM multiple field of those event point protocols if this type of"
 .. S ^ORD(101,RA101,1,5,0)="messaging scenerio is used at a facility.  This is part of the file set-up"
 .. S ^ORD(101,RA101,1,6,0)="to enable HL7 message flow when exams are registered, cancelled, and when"
 .. S ^ORD(101,RA101,1,7,0)="they reach the status flagged as 'examined' by the site."
 .. S ^ORD(101,RA101,1,0)="^^7^7^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA PSCRIBE ORM",101,1)
 . Q
 I '$D(^ORD(101,"B","RA PSCRIBE ORU")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE ORU"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-PSCRIBE-TCP"
 . S RAFDA(101,"+1,",770.3)="ACK"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",770.7)="RA-PSCRIBE"
 . S RAFDA(101,"+1,",770.11)="ORU"
 . S RAFDA(101,"+1,",771)="Q"
 . S RAFDA(101,"+1,",773.1)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.2)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.3)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.4)=$$Y^RAIPST12()
 . D MSG^RAIPST12("RA PSCRIBE ORU",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA PSCRIBE ORU")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA PSCRIBE ORU",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA RPT event point protocol."
 .. S ^ORD(101,RA101,1,2,0)="The HL7 package uses this protocol to send rad/nuc med report (ORU)"
 .. S ^ORD(101,RA101,1,3,0)="messages to TCP/IP recipients.  This protocol should be entered in the"
 .. S ^ORD(101,RA101,1,4,0)="ITEM multiple field of the RA RPT protocol if this messaging scenerio is"
 .. S ^ORD(101,RA101,1,5,0)="used in a facility.  This is part of the file set-up to enable message"
 .. S ^ORD(101,RA101,1,6,0)="flow when a rad/nuc med report is verified."
 .. S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA PSCRIBE ORU",101,1)
 . Q
 I '$D(^ORD(101,"B","RA TALKLINK ORM")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK ORM"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-TALKLINK-TCP"
 . S RAFDA(101,"+1,",770.3)="ACK"
 . S RAFDA(101,"+1,",770.4)="O01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",770.7)="RA-TALK"
 . S RAFDA(101,"+1,",770.11)="ORM"
 . S RAFDA(101,"+1,",771)="Q"
 . S RAFDA(101,"+1,",773.1)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.2)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.3)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.4)=$$Y^RAIPST12()
 . D MSG^RAIPST12("RA TALKLINK ORM",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA TALKLINK ORM")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA TALKLINK ORM",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA REG 2.3, RA EXAMINED 2.3,"
 .. S ^ORD(101,RA101,1,2,0)="and RA CANCEL 2.3 event protocols.  It is used by the VISTA HL7 package to"
 .. S ^ORD(101,RA101,1,3,0)="send ORM messages to TCP/IP recipients.  This protocol should be entered"
 .. S ^ORD(101,RA101,1,4,0)="in the ITEM multiple field of those event point protocols if this type of"
 .. S ^ORD(101,RA101,1,5,0)="messaging scenerio is used at a facility.  This is part of the file set-up"
 .. S ^ORD(101,RA101,1,6,0)="to enable HL7 message flow when exams are registered, cancelled, and when"
 .. S ^ORD(101,RA101,1,7,0)="they reach the status flagged as 'examined' by the site."
 .. S ^ORD(101,RA101,1,0)="^^7^7^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA TALKLINK ORM",101,1)
 . Q
 I '$D(^ORD(101,"B","RA TALKLINK ORU")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK ORU"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-TALKLINK-TCP"
 . S RAFDA(101,"+1,",770.3)="ACK"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",770.7)="RA-TALK"
 . S RAFDA(101,"+1,",770.11)="ORU"
 . S RAFDA(101,"+1,",771)="Q"
 . S RAFDA(101,"+1,",773.1)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.2)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.3)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.4)=$$Y^RAIPST12()
 . D MSG^RAIPST12("RA TALKLINK ORU",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA TALKLINK ORU")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA TALKLINK ORU",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA RPT 2.3 event point"
 .. S ^ORD(101,RA101,1,2,0)="protocol.  The HL7 package uses this protocol to send rad/nuc med report"
 .. S ^ORD(101,RA101,1,3,0)="(ORU) messages to TCP/IP recipients.  This protocol should be entered in"
 .. S ^ORD(101,RA101,1,4,0)="the ITEM multiple field of the RA RPT protocol if this messaging scenerio"
 .. S ^ORD(101,RA101,1,5,0)="is used in a facility.  This is part of the file set-up to enable message"
 .. S ^ORD(101,RA101,1,6,0)="flow when a rad/nuc med report is verified."
 .. S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA TALKLINK ORU",101,1)
 . Q
 D EN1^RAIPST14 ; continue to add protocols and items under existing
 ; protocols.
 ; *** End adding entries to the Protocol (101) file ***
 Q
