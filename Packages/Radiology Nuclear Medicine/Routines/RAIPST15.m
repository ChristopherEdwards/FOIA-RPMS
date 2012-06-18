RAIPST15 ;HIRMFO/BNT - Post-init number three (patch twelve) ;5/19/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**12**;Mar 16, 1998
 ;
EN1 ; *** Adding Event Drivers (HL7 version 2.3) to the Protocol file ***
 I '$D(^ORD(101,"B","RA RPT 2.3")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA RPT 2.3"
 . S RAFDA(101,"+1,",1)="Rad/nuc Med report released/verified"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",770.1)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",772)="Q"
 . S RAFDA(101,"+1,",99)=$$TSTMP^RAIPST12()
 . S RAFDA(101,"+1,",770.4)="R01"
 . D MSG^RAIPST12("RA RPT 2.3",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA RPT 2.3")) D  Q
 . . S RA101=$O(^ORD(101,"B","RA RPT 2.3",0))
 . . K RAFDA S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 . . S ^ORD(101,RA101,1,1,0)="This protocol is triggered whenever a Radiology/Nuclear Medicine report"
 . . S ^ORD(101,RA101,1,2,0)="enters into a status of verified or Released/Not Verified.  It executes"
 . . S ^ORD(101,RA101,1,3,0)="code that creates an HL7 version 2.3 ORU message consisting of PID, OBR"
 . . S ^ORD(101,RA101,1,4,0)="and OBX segments.  The message contains relevant information about the"
 . . S ^ORD(101,RA101,1,5,0)="report, including procedure, procedure modifiers, diagnostic code,"
 . . S ^ORD(101,RA101,1,6,0)="interpreting physician, impression text and report text."
 . . S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^^^"
 . . Q
 . D MSG^RAIPST12("RA RPT 2.3",101,1)
 . Q
 I '$D(^ORD(101,"B","RA CANCEL 2.3")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA CANCEL 2.3"
 . S RAFDA(101,"+1,",1)="Rad/Nuc Med exam cancellation"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",770.1)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.3)="ORM"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",772)="Q"
 . S RAFDA(101,"+1,",99)=$$TSTMP^RAIPST12()
 . S RAFDA(101,"+1,",770.4)="O01"
 . D MSG^RAIPST12("RA CANCEL 2.3",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA CANCEL 2.3")) D  Q
 . . S RA101=$O(^ORD(101,"B","RA CANCEL 2.3",0))
 . . K RAFDA S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 . . S ^ORD(101,RA101,1,1,0)="This protocol is triggered whenever a Radiology/Nuclear Medicine exam is"
 . . S ^ORD(101,RA101,1,2,0)="cancelled.  It executes code that creates an HL7 version 2.3 ORM message"
 . . S ^ORD(101,RA101,1,3,0)="consisting of PID, ORC, and OBX segments.  The message contains all"
 . . S ^ORD(101,RA101,1,4,0)="relevant information about the exam, including procedure, time of"
 . . S ^ORD(101,RA101,1,5,0)="cancellation, procedure modifiers, patient allergies and clinical history."
 . . S ^ORD(101,RA101,1,0)="^^5^5^"_$$DT^XLFDT()_"^^"
 . . Q
 . D MSG^RAIPST12("RA CANCEL 2.3",101,1)
 . Q
 I '$D(^ORD(101,"B","RA REG 2.3")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA REG 2.3"
 . S RAFDA(101,"+1,",1)="Rad/Nuc Med exam registered for HL7 v2.3 message"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",770.1)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.3)="ORM"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",772)="Q"
 . S RAFDA(101,"+1,",99)=$$TSTMP^RAIPST12()
 . S RAFDA(101,"+1,",770.4)="O01"
 . D MSG^RAIPST12("RA REG 2.3",101)
 . D UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA REG 2.3")) D  Q
 . . S RA101=$O(^ORD(101,"B","RA REG 2.3",0))
 . . K RAFDA S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 . . S ^ORD(101,RA101,1,1,0)="This protocol is triggered whenever a Radiology/Nuclear Medicine exam is"
 . . S ^ORD(101,RA101,1,2,0)="registered.  It executes code that creates an HL7 ORM version 2.3 message"
 . . S ^ORD(101,RA101,1,3,0)="consisting of PID, ORC, OBR, and OBX segments.  The message containes all"
 . . S ^ORD(101,RA101,1,4,0)="relevant information about the exam, including procedure, time of"
 . . S ^ORD(101,RA101,1,5,0)="registration, procedure modifiers, patient allergies, and clinical"
 . . S ^ORD(101,RA101,1,6,0)="history."
 . . S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^"
 . . Q
 . D MSG^RAIPST12("RA REG 2.3",101,1)
 . Q
 I '$D(^ORD(101,"B","RA EXAMINED 2.3")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA EXAMINED 2.3"
 . S RAFDA(101,"+1,",1)="Rad/Nuc Med examined case"
 . S RAFDA(101,"+1,",12)=$$PKG^RAIPST12()
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",770.1)="RA-VOICE-SERVER"
 . S RAFDA(101,"+1,",770.3)="ORM"
 . S RAFDA(101,"+1,",770.6)=$$PROID^RAIPST12()
 . S RAFDA(101,"+1,",772)="Q"
 . S RAFDA(101,"+1,",99)=$$TSTMP^RAIPST12()
 . S RAFDA(101,"+1,",770.4)="O01"
 . D MSG^RAIPST12("RA EXAMINED 2.3",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA EXAMINED 2.3")) D  Q
 . . S RA101=$O(^ORD(101,"B","RA EXAMINED 2.3",0))
 . . K RAFDA S RAFDA(101,RA101_",",770.95)=2.3 D FILE^DIE("E","RAFDA")
 . . S ^ORD(101,RA101,1,1,0)="This protocol is triggered whenever a Radiology/Nuclear Medicine exam has"
 . . S ^ORD(101,RA101,1,2,0)="reached a status where GENERATE EXAMINED HL7 MSG is Y at that (or at a"
 . . S ^ORD(101,RA101,1,3,0)="lower) status.  An HL7 version 2.3 ORM message will be generated that"
 . . S ^ORD(101,RA101,1,4,0)="contains all relevant information about the exam, including procedure,"
 . . S ^ORD(101,RA101,1,5,0)="time of registration, procedure modifiers, patient allergies, and clinical"
 . . S ^ORD(101,RA101,1,6,0)="history."
 . . S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^"
 . . Q
 . D MSG^RAIPST12("RA EXAMINED 2.3",101,1)
 . Q
 Q
