RA12PST4 ;HIRMFO/CRT - Post-init number four (patch seventeen) ;5/19/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**17**;Mar 16, 1998
 ;
EN1 ; Add/Edit PowerScribe/TalkStation entries to the Protocol (101) file.
 ;
 D MSG^RA12PST2("RA TCP ORM",101)
 I $D(^ORD(101,"B","RA TCP ORM")) D
 . S RA101=$O(^ORD(101,"B","RA TCP ORM",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="ACK"
 . D FILE^DIE("E","RAFDA")
 ;
 D MSG^RA12PST2("RA TCP ORU",101)
 I $D(^ORD(101,"B","RA TCP ORU")) D
 . S RA101=$O(^ORD(101,"B","RA TCP ORU",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="ACK"
 . D FILE^DIE("E","RAFDA")
 ;
 ; *** Adding/Editing PowerScribe entries to Protocol (101) file ***
 ;
 D MSG^RA12PST2("RA PSCRIBE ORM",101)
 I '$D(^ORD(101,"B","RA PSCRIBE ORM")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE ORM"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-PSCRIBE-TCP"
 . S RAFDA(101,"+1,",770.4)="O01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,"+1,",770.7)="RA-PSCRIBE"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",773.1)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.2)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.3)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.4)=$$Y^RA12PST2()
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA PSCRIBE ORM")) D MSG^RA12PST2("RA PSCRIBE ORM",101,1)
 I $D(^ORD(101,"B","RA PSCRIBE ORM")) D
 . S RA101=$O(^ORD(101,"B","RA PSCRIBE ORM",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="ACK"
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D FILE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA REG 2.3, RA EXAMINED 2.3,"
 . S ^ORD(101,RA101,1,2,0)="and RA CANCEL 2.3 event protocols.  It is used by the VISTA HL7 package to"
 . S ^ORD(101,RA101,1,3,0)="send ORM messages to TCP/IP recipients.  This protocol should be entered"
 . S ^ORD(101,RA101,1,4,0)="in the SUBSCRIBERS multiple field of those event point protocols if this"
 . S ^ORD(101,RA101,1,5,0)="type of messaging scenerio is used at a facility.  This is part of the"
 . S ^ORD(101,RA101,1,6,0)="file set-up to enable HL7 message flow when exams are registered,"
 . S ^ORD(101,RA101,1,7,0)="cancelled and when they reach the status flagged as 'examined' by the site."
 . S ^ORD(101,RA101,1,0)="^^7^7^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 D MSG^RA12PST2("RA PSCRIBE ORU",101)
 I '$D(^ORD(101,"B","RA PSCRIBE ORU")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE ORU"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-PSCRIBE-TCP"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,"+1,",770.7)="RA-PSCRIBE"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",773.1)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.2)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.3)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.4)=$$Y^RA12PST2()
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA PSCRIBE ORU")) D MSG^RA12PST2("RA PSCRIBE ORU",101,1)
 I $D(^ORD(101,"B","RA PSCRIBE ORU")) D
 . S RA101=$O(^ORD(101,"B","RA PSCRIBE ORU",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="ACK"
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D FILE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA RPT 2.3 event protocol."
 . S ^ORD(101,RA101,1,2,0)="The HL7 package uses this protocol to send rad/nuc med report (ORU)"
 . S ^ORD(101,RA101,1,3,0)="messages to TCP/IP recipients.  This protocol should be entered in the"
 . S ^ORD(101,RA101,1,4,0)="SUBSCRIBERS multiple field of the RA RPT 2.3 protocol if this messaging"
 . S ^ORD(101,RA101,1,5,0)="scenario is used in a facility.  This is part of the file set-up to"
 . S ^ORD(101,RA101,1,6,0)="enable message flow when a rad/nuc med report is verified."
 . S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 ; *** End Adding/Editing PowerScribe entries in Protocol File ***
 ;
 ; *** Adding/Editing TalkStation entries in Protocol (101) File ***
 ;
 D MSG^RA12PST2("RA TALKLINK ORM",101)
 I '$D(^ORD(101,"B","RA TALKLINK ORM")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK ORM"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-TALKLINK-TCP"
 . S RAFDA(101,"+1,",770.4)="O01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,"+1,",770.7)="RA-TALK"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",773.1)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.2)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.3)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.4)=$$Y^RA12PST2()
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA TALKLINK ORM")) D MSG^RA12PST2("RA TALKLINK ORM",101,1)
 I $D(^ORD(101,"B","RA TALKLINK ORM")) D
 . S RA101=$O(^ORD(101,"B","RA TALKLINK ORM",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="ACK"
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D FILE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA REG 2.3, RA EXAMINED 2.3,"
 . S ^ORD(101,RA101,1,2,0)="and RA CANCEL 2.3 event protocols.  It is used by the VISTA HL7 package to"
 . S ^ORD(101,RA101,1,3,0)="send ORM messages to TCP/IP recipients.  This protocol should be entered"
 . S ^ORD(101,RA101,1,4,0)="in the SUBSCRIBERS multiple field of those event point protocols if this"
 . S ^ORD(101,RA101,1,5,0)="type of messaging scenerio is used at a facility.  This is part of the"
 . S ^ORD(101,RA101,1,6,0)="file set-up to enable HL7 message flow when exams are registered, cancelled,"
 . S ^ORD(101,RA101,1,7,0)="and when they reach the status flagged as 'examined' by the site."
 . S ^ORD(101,RA101,1,0)="^^7^7^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 D MSG^RA12PST2("RA TALKLINK ORU",101)
 I '$D(^ORD(101,"B","RA TALKLINK ORU")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK ORU"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-TALKLINK-TCP"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,"+1,",770.7)="RA-TALK"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",773.1)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.2)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.3)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.4)=$$Y^RA12PST2()
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA TALKLINK ORU")) D MSG^RA12PST2("RA TALKLINK ORU",101,1)
 I $D(^ORD(101,"B","RA TALKLINK ORU")) D
 . S RA101=$O(^ORD(101,"B","RA TALKLINK ORU",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="ACK"
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D FILE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA RPT 2.3 event point"
 . S ^ORD(101,RA101,1,2,0)="protocol.  The HL7 package uses this protocol to send rad/nuc med report"
 . S ^ORD(101,RA101,1,3,0)="(ORU) messages to TCP/IP recipients.  This protocol should be entered in"
 . S ^ORD(101,RA101,1,4,0)="the SUBSCRIBERS multiple field of the RA RPT 2.3 protocol if this"
 . S ^ORD(101,RA101,1,5,0)="messaging scenario is used in a facility.  This is part of the file set-up"
 . S ^ORD(101,RA101,1,6,0)="to enable message flow when a rad/nuc med report is verified."
 . S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 ; *** End Adding/Editing TalkStation entries in Protocol file ***
 ;
 D EN1^RA12PST5 ; Edit existing HL7 Version 2.3 Event Driver Protocols
 ;
 Q
