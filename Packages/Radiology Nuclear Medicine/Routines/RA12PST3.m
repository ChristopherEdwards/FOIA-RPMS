RA12PST3 ;HIRMFO/CRT - Post-init number three (patch seventeen) ;5/19/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**17**;Mar 16, 1998
 ;
EN1 ; ***   Adding/Editing entries to the Protocol (101) file   ***
 ;
 I $D(^ORD(101,"B","RA VOICE TCP REPORT")) D
 . N RA101,RAFDA
 . S RA101=$O(^ORD(101,"B","RA VOICE TCP REPORT",0))
 . S RAFDA(101,RA101_",",771)="D ^RAHLTCPB"
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . D MSG^RA12PST2("RA VOICE TCP REPORT",101)
 . D UPDATE^DIE("E","RAFDA")
 . Q
 ;
 I $D(^ORD(101,"B","RA VOICE TCP SERVER RPT")) D
 . N RA101,RAFDA
 . S RA101=$O(^ORD(101,"B","RA VOICE TCP SERVER RPT",0))
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="@"
 . D MSG^RA12PST2("RA VOICE TCP SERVER RPT",101)
 . D UPDATE^DIE("E","RAFDA")
 . Q
 ;
 D MSG^RA12PST2("RA PSCRIBE TCP REPORT",101)
 I '$D(^ORD(101,"B","RA PSCRIBE TCP REPORT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE TCP REPORT"
 . S RAFDA(101,"+1,",1)="Client for PowerScribe TCP rpt"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,"+1,",770.7)="PSCRIBE-RA"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",771)="D ^RAHLTCPB"
 . S RAFDA(101,"+1,",773.1)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.2)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.3)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.4)=$$Y^RA12PST2()
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA PSCRIBE TCP REPORT")) D MSG^RA12PST2("RA PSCRIBE TCP REPORT",101,1)
 I $D(^ORD(101,"B","RA PSCRIBE TCP REPORT")) D
 . S RA101=$O(^ORD(101,"B","RA PSCRIBE TCP REPORT",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D UPDATE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="Subscriber protocol for sending report to VISTA Radiology/Nuclear"
 . S ^ORD(101,RA101,1,2,0)="Medicine.  This protocol is used by the HL7 package to process messages"
 . S ^ORD(101,RA101,1,3,0)="sent to VISTA from a COTS voice recognition unit using TCP/IP for message"
 . S ^ORD(101,RA101,1,4,0)="flow.  This protocol should be entered in the SUBSCRIBERS multiple of the"
 . S ^ORD(101,RA101,1,5,0)="RA PSCRIBE TCP SERVER RPT protocol."
 . S ^ORD(101,RA101,1,0)="^^5^5^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 D MSG^RA12PST2("RA PSCRIBE TCP SERVER RPT",101)
 I '$D(^ORD(101,"B","RA PSCRIBE TCP SERVER RPT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA PSCRIBE TCP SERVER RPT"
 . S RAFDA(101,"+1,",1)="PowerScribe TCP sends report to VISTA"
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.1)="RA-PSCRIBE-TCP"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101.0775,"+2,+1,",.01)="RA PSCRIBE TCP REPORT"
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA PSCRIBE TCP SERVER RPT")) D MSG^RA12PST2("RA PSCRIBE TCP SERVER RPT",101,1)
 I $D(^ORD(101,"B","RA PSCRIBE TCP SERVER RPT")) D
 . S RA101=$O(^ORD(101,"B","RA PSCRIBE TCP SERVER RPT",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="@"
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D UPDATE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="Driver protocol for sending report to VISTA Radiology/Nuclear Medicine."
 . S ^ORD(101,RA101,1,2,0)="This protocol is used by the HL7 package to process radiology/nuclear med"
 . S ^ORD(101,RA101,1,3,0)="reports coming into VISTA from commercial voice recognition units using"
 . S ^ORD(101,RA101,1,4,0)="TCP/IP for message flow."
 . S ^ORD(101,RA101,1,0)="^^4^4^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 D MSG^RA12PST2("RA TALKLINK TCP REPORT",101)
 I '$D(^ORD(101,"B","RA TALKLINK TCP REPORT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK TCP REPORT"
 . S RAFDA(101,"+1,",1)="Client for TalkStation TCP rpt"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,"+1,",770.7)="TALK-RA"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",771)="D ^RAHLTCPB"
 . S RAFDA(101,"+1,",773.1)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.2)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.3)=$$N^RA12PST2()
 . S RAFDA(101,"+1,",773.4)=$$Y^RA12PST2()
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA TALKLINK TCP REPORT")) D MSG^RA12PST2("RA TALKLINK TCP REPORT",101,1)
 I $D(^ORD(101,"B","RA TALKLINK TCP REPORT")) D
 . S RA101=$O(^ORD(101,"B","RA TALKLINK TCP REPORT",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.3)="@"
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D UPDATE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="Subscriber protocol for sending report to VISTA Radiology/Nuclear"
 . S ^ORD(101,RA101,1,2,0)="Medicine.  This protocol is used by the HL7 package to process messages"
 . S ^ORD(101,RA101,1,3,0)="sent to VISTA from a COTS voice recognition unit using TCP/IP for message"
 . S ^ORD(101,RA101,1,4,0)="flow.  This protocol should be entered in the SUBSCRIBERS multiple of the"
 . S ^ORD(101,RA101,1,5,0)="RA TALKLINK TCP SERVER RPT protocol."
 . S ^ORD(101,RA101,1,0)="^^5^5^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 D MSG^RA12PST2("RA TALKLINK TCP SERVER RPT",101)
 I '$D(^ORD(101,"B","RA TALKLINK TCP SERVER RPT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TALKLINK TCP SERVER RPT"
 . S RAFDA(101,"+1,",1)="TalkStation TCP sends report to VISTA"
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",12)=$$PKG^RA12PST2()
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.1)="RA-TALKLINK-TCP"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101.0775,"+2,+1,",.01)="RA TALKLINK TCP REPORT"
 . D UPDATE^DIE("E","RAFDA")
 . I '$D(^ORD(101,"B","RA TALKLINK TCP SERVER RPT")) D MSG^RA12PST2("RA TALKLINK TCP SERVER RPT",101,1)
 I $D(^ORD(101,"B","RA TALKLINK TCP SERVER RPT")) D
 . S RA101=$O(^ORD(101,"B","RA TALKLINK TCP SERVER RPT",0)) K RAFDA
 . S RAFDA(101,RA101_",",770.6)=$$PROID^RA12PST2()
 . S RAFDA(101,RA101_",",770.11)="@"
 . S RAFDA(101,RA101_",",770.95)=2.3
 . D UPDATE^DIE("E","RAFDA")
 . S ^ORD(101,RA101,1,1,0)="Driver protocol for sending report to VISTA Radiology/Nuclear Medicine."
 . S ^ORD(101,RA101,1,2,0)="This protocol is used by the HL7 package to process radiology/nuclear med"
 . S ^ORD(101,RA101,1,3,0)="reports coming into VISTA from commercial voice recognition units using"
 . S ^ORD(101,RA101,1,4,0)="TCP/IP for message flow."
 . S ^ORD(101,RA101,1,0)="^^4^4^"_$$DT^XLFDT()_"^^"
 . Q
 ;
 D EN1^RA12PST4 ; Add/Edit further protocols for HL7 version 2.3.
 ;
 Q
