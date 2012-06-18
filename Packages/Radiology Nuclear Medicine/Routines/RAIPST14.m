RAIPST14 ;HIRMFO/BNT - Post-init number two (patch twelve) ;5/19/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**12**;Mar 16, 1998
 ;
EN1 ; ***   Adding/Editing entries to the Protocol (101) file   ***
 I $D(^ORD(101,"B","RA VOICE TCP REPORT")) D
 . N RA101,RAFDA
 . S RA101=$O(^ORD(101,"B","RA VOICE TCP REPORT",0))
 . S RAFDA(101,RA101_",",771)="D ^RAHLTCPB"
 . D MES^XPDUTL("Changing GENERATE/PROCESS ROUTINE (field 771) for RA VOICE TCP REPORT protocol")
 . D FILE^DIE("E","RAFDA")
 . Q
 ;
 I '$D(^ORD(101,"B","RA PSCRIBE TCP REPORT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE TCP REPORT"
 . S RAFDA(101,"+1,",1)="Client for PowerScribe TCP rpt"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",770.7)="PSCRIBE-RA"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",771)="D ^RAHLTCPB"
 . S RAFDA(101,"+1,",773.1)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.2)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.3)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.4)=$$Y^RAIPST12()
 . D MSG^RAIPST12("RA PSCRIBE TCP REPORT",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA PSCRIBE TCP REPORT")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA PSCRIBE TCP REPORT",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="Subscriber protocol for sending report to VISTA Radiology/Nuclear"
 .. S ^ORD(101,RA101,1,2,0)="Medicine.  This protocol is used by the HL7 package to process messages"
 .. S ^ORD(101,RA101,1,3,0)="sent to VISTA from a COTS voice recognition unit using TCP/IP for message"
 .. S ^ORD(101,RA101,1,4,0)="flow.  This protocol should be entered in the ITEM multiple of the RA"
 .. S ^ORD(101,RA101,1,5,0)="PSCRIBE TCP SERVER RPT protocol."
 .. S ^ORD(101,RA101,1,0)="^^5^5^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA PSCRIBE TCP REPORT",101,1)
 . Q
 I '$D(^ORD(101,"B","RA PSCRIBE TCP SERVER RPT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE TCP SERVER RPT"
 . S RAFDA(101,"+1,",1)="PowerScribe TCP sends report to VISTA"
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.1)="RA-PSCRIBE-TCP"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",772)="Q"
 . S RAFDA(101.01,"+2,+1,",.01)="RA PSCRIBE TCP REPORT"
 . D MSG^RAIPST12("RA PSCRIBE TCP SERVER RPT",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA PSCRIBE TCP SERVER RPT")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA PSCRIBE TCP SERVER RPT",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="Driver protocol for sending report to VISTA Radiology/Nuclear Medicine."
 .. S ^ORD(101,RA101,1,2,0)="This protocol is used by the HL7 package to process radiology/nuclear med"
 .. S ^ORD(101,RA101,1,3,0)="reports coming into VISTA from commercial voice recognition units using"
 .. S ^ORD(101,RA101,1,4,0)="TCP/IP for message flow."
 .. S ^ORD(101,RA101,1,0)="^^4^4^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA PSCRIBE TCP SERVER RPT",101,1)
 . Q
 I '$D(^ORD(101,"B","RA TALKLINK TCP REPORT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK TCP REPORT"
 . S RAFDA(101,"+1,",1)="Client for TalkStation TCP rpt"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",770.7)="TALK-RA"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",771)="D ^RAHLTCPB"
 . S RAFDA(101,"+1,",773.1)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.2)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.3)=$$N^RAIPST12()
 . S RAFDA(101,"+1,",773.4)=$$Y^RAIPST12()
 . D MSG^RAIPST12("RA TALKLINK TCP REPORT",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA TALKLINK TCP REPORT")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA TALKLINK TCP REPORT",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="Subscriber protocol for sending report to VISTA Radiology/Nuclear"
 .. S ^ORD(101,RA101,1,2,0)="Medicine.  This protocol is used by the HL7 package to process messages"
 .. S ^ORD(101,RA101,1,3,0)="sent to VISTA from a COTS voice recognition unit using TCP/IP for message"
 .. S ^ORD(101,RA101,1,4,0)="flow.  This protocol should be entered in the ITEM multiple of the RA"
 .. S ^ORD(101,RA101,1,5,0)="TALKLINK TCP SERVER RPT protocol."
 .. S ^ORD(101,RA101,1,0)="^^5^5^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA TALKLINK TCP REPORT",101,1)
 . Q
 I '$D(^ORD(101,"B","RA TALKLINK TCP SERVER RPT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK TCP SERVER RPT"
 . S RAFDA(101,"+1,",1)="TalkStation TCP sends report to VISTA"
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.1)="RA-TALKLINK-TCP"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",772)="Q"
 . S RAFDA(101.01,"+2,+1,",.01)="RA TALKLINK TCP REPORT"
 . D MSG^RAIPST12("RA TALKLINK TCP SERVER RPT",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA TALKLINK TCP SERVER RPT")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA TALKLINK TCP SERVER RPT",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="Driver protocol for sending report to VISTA Radiology/Nuclear Medicine."
 .. S ^ORD(101,RA101,1,2,0)="This protocol is used by the HL7 package to process radiology/nuclear med"
 .. S ^ORD(101,RA101,1,3,0)="reports coming into VISTA from commercial voice recognition units using"
 .. S ^ORD(101,RA101,1,4,0)="TCP/IP for message flow."
 .. S ^ORD(101,RA101,1,0)="^^4^4^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAIPST12("RA TALKLINK TCP SERVER RPT",101,1)
 . Q
 D EN1^RAIPST15 ; Add new event driver protocols for HL7 version 2.3.
 ;
 Q
