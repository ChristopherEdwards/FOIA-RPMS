RAAIPST2 ;HIRMFO/GJC - Post-init number two (patch four) ;4/29/98  15:18
VERSION ;;5.0;Radiology/Nuclear Medicine;**4**;Mar 16, 1998
 ;
EN1 ; ***   Adding entries to the Protocol (101) file   ***
 I '$D(^ORD(101,"B","RA VOICE TCP REPORT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA VOICE TCP REPORT"
 . S RAFDA(101,"+1,",1)="Client for Voice TCP rpt"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)="RADIOLOGY/NUCLEAR MEDICINE"
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-SERVER-IMG"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=""  ;IHS/ITSC/CLS 04/25/2003
 . S RAFDA(101,"+1,",770.7)="MED-RA"
 . S RAFDA(101,"+1,",770.11)="ACK"
 . S RAFDA(101,"+1,",771)="D ^RAHLBMS"
 . S RAFDA(101,"+1,",773.1)=$$N^RAAIPST1()
 . S RAFDA(101,"+1,",773.2)=$$N^RAAIPST1()
 . S RAFDA(101,"+1,",773.3)=$$N^RAAIPST1()
 . S RAFDA(101,"+1,",773.4)=$$Y^RAAIPST1()
 . D MSG("RA VOICE TCP REPORT",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA VOICE TCP REPORT")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA VOICE TCP REPORT",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.1 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="Subscriber protocol for sending report to VISTA Radiology/Nuclear"
 .. S ^ORD(101,RA101,1,2,0)="Medicine.  This protocol is used by the HL7 package to process messages"
 .. S ^ORD(101,RA101,1,3,0)="sent to VISTA from a COTS voice recognition unit using TCP/IP for message"
 .. S ^ORD(101,RA101,1,4,0)="flow.  This protocol should be entered in the ITEM multiple of the RA"
 .. S ^ORD(101,RA101,1,5,0)="VOICE TCP SERVER RPT protocol."
 .. S ^ORD(101,RA101,1,0)="^^5^5^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG("RA VOICE TCP REPORT",101,1)
 . Q
 I '$D(^ORD(101,"B","RA VOICE TCP SERVER RPT")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA VOICE TCP SERVER RPT"
 . S RAFDA(101,"+1,",1)="Voice TCP sends report to VISTA"
 . S RAFDA(101,"+1,",4)="event driver"
 . S RAFDA(101,"+1,",12)="RADIOLOGY/NUCLEAR MEDICINE"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.1)="RA-CLIENT-TCP"
 . S RAFDA(101,"+1,",770.3)="ORU"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=""  ;IHS/ITSC/CLS 04/25/2003
 . S RAFDA(101,"+1,",772)="Q"
 . S RAFDA(101.01,"+2,+1,",.01)="RA VOICE TCP REPORT"
 . D MSG("RA VOICE TCP SERVER RPT",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA VOICE TCP SERVER RPT")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA VOICE TCP SERVER RPT",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.1 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="Driver protocol for sending report to VISTA Radiology/Nuclear Medicine."
 .. S ^ORD(101,RA101,1,2,0)="This protocol is used by the HL7 package to process radiology/nuclear med"
 .. S ^ORD(101,RA101,1,3,0)="reports coming into VISTA from commercial voice recognition units using"
 .. S ^ORD(101,RA101,1,4,0)="TCP/IP for message flow."
 .. S ^ORD(101,RA101,1,0)="^^4^4^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG("RA VOICE TCP SERVER RPT",101,1)
 . Q
 ; *** End adding entries to the Protocol (101) file ***
 Q
MSG(ENTRY,FILE,ERR) ; display a status message pertaining to the addition
 ; of entries to files: 869.2, 870, 771 & 101.  Display a status message
 ; when items are added to the Protocol (101) file.
 ; Variable list:
 ; ENTRY-> value of the .01 field for a particular file (60 chars max)
 ; FILE -> file # where the data will be added
 ; ERR  -> err message? 1 if yes, else null
 N RACNT,RATXT,STRING,WORDS S RACNT=1,RATXT(RACNT)=" "
 S:$G(ERR) STRING="* ERROR * "
 S STRING=$G(STRING)_"Adding '"_$E(ENTRY,1,40)_"' to the "
 S STRING=$G(STRING)_$E($P($G(^DIC(FILE,0)),"^"),1,40)_" file."
 S:$G(ERR)&($D(DIERR)) STRING=$G(STRING)_" "_$E($G(^TMP("DIERR",$J,1,"TEXT",1)),1,115) ; display the 1st error text encountered! (there may be more errors. Because of possible string length error display only the first error.)
 S:$G(ERR) STRING=$G(STRING)_" IRM should investigate."
 F  D  Q:STRING=""
 . S WORDS=$L($E(STRING,1,71)," ")
 . S RACNT=RACNT+1,RATXT(RACNT)=$P(STRING," ",1,WORDS)
 . S STRING=$P(STRING," ",WORDS+1,999)
 . Q
 D MES^XPDUTL(.RATXT)
 Q
