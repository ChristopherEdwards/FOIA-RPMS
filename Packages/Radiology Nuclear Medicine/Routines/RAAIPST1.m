RAAIPST1 ;HIRMFO/GJC - Post-init number one (patch four) ;1/7/98  08:27
VERSION ;;5.0;Radiology/Nuclear Medicine;**4**;Mar 16, 1998
 ;
EN1 ; Add entries to the HL LL Protocol Param (869.2) file, HL Logical
 ; Link (870) file, HL7 Application Param (771) and the Protocol (101)
 ; file.
 ; ***    Add entries to HL LL Protocol Param (869.2) file     ***
 I '$D(^HLCS(869.2,"B","RA-MED LLP")) D
 . N RAFDA S RAFDA(869.2,"+1,",.01)="RA-MED LLP"
 . S RAFDA(869.2,"+1,",.02)=$$TCP()
 . S RAFDA(869.2,"+1,",400.03)=$$CLIENT()
 . S RAFDA(869.2,"+1,",400.04)=$$Y()
 . D MSG^RAAIPST2("RA-MED LLP",869.2),UPDATE^DIE("E","RAFDA")
 . D:'$D(^HLCS(869.2,"B","RA-MED LLP")) MSG^RAAIPST2("RA-MED LLP",869.2,1)
 . Q
 I '$D(^HLCS(869.2,"B","MED-RA LLP")) D
 . N RAFDA S RAFDA(869.2,"+1,",.01)="MED-RA LLP"
 . S RAFDA(869.2,"+1,",.02)=$$TCP()
 . S RAFDA(869.2,"+1,",400.03)=$$SLISTN()
 . S RAFDA(869.2,"+1,",400.04)=$$Y()
 . D MSG^RAAIPST2("MED-RA LLP",869.2),UPDATE^DIE("E","RAFDA")
 . D:'$D(^HLCS(869.2,"B","MED-RA LLP")) MSG^RAAIPST2("MED-RA LLP",869.2,1)
 . Q
 ; *** End adding entries to HL LL Protocol Param (869.2) file ***
 D BMES^XPDUTL(" ") ; greater readability
 ; ***    Add entries to HL Logical Link (870) file     ***
 I '$D(^HLCS(870,"B","RA-MED")) D
 . N RAFDA S RAFDA(870,"+1,",.01)="RA-MED"
 . S RAFDA(870,"+1,",2)="TCP"  ;IHS/ITSC/CLS 04/25/2003
 . D MSG^RAAIPST2("RA-MED",870),UPDATE^DIE("E","RAFDA")
 . D:'$D(^HLCS(870,"B","RA-MED")) MSG^RAAIPST2("RA-MED",870,1)
 . Q
 I '$D(^HLCS(870,"B","MED-RA")) D
 . N RAFDA S RAFDA(870,"+1,",.01)="MED-RA"
 . S RAFDA(870,"+1,",2)="TCP"  ;IHS/ITSC/CLS 04/25/2003
 . D MSG^RAAIPST2("MED-RA",870),UPDATE^DIE("E","RAFDA")
 . D:'$D(^HLCS(870,"B","MED-RA")) MSG^RAAIPST2("MED-RA",870,1)
 . Q
 ; *** End adding entries to HL Logical Link (870) file ***
 D BMES^XPDUTL(" ") ; greater readability
 ; ***    Add entries to HL7 Application Param (771) file     ***
 I '$D(^HL(771,"B","RA-SERVER-IMG")) D
 . N RAFDA S RAFDA(771,"+1,",.01)="RA-SERVER-IMG"
 . S RAFDA(771,"+1,",2)=$$ACTIVE()
 . S RAFDA(771,"+1,",7)=$$US()
 . D MSG^RAAIPST2("RA-SERVER-IMG",771),UPDATE^DIE("E","RAFDA")
 . D:'$D(^HL(771,"B","RA-SERVER-IMG")) MSG^RAAIPST2("RA-SERVER-IMG",771,1)
 . Q
 I '$D(^HL(771,"B","RA-CLIENT-TCP")) D
 . N RAFDA S RAFDA(771,"+1,",.01)="RA-CLIENT-TCP"
 . S RAFDA(771,"+1,",2)=$$ACTIVE()
 . S RAFDA(771,"+1,",7)=$$US()
 . D MSG^RAAIPST2("RA-CLIENT-TCP",771),UPDATE^DIE("E","RAFDA")
 . D:'$D(^HL(771,"B","RA-CLIENT-TCP")) MSG^RAAIPST2("RA-CLIENT-TCP",771,1)
 . Q
 ; *** End adding entries to HL7 Application Param (771) file ***
 D BMES^XPDUTL(" ") ; greater readability
 ; ***   Adding entries to the Protocol (101) file   ***
 I '$D(^ORD(101,"B","RA TCP ORM")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TCP ORM"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)="RADIOLOGY/NUCLEAR MEDICINE"
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-CLIENT-TCP"
 . S RAFDA(101,"+1,",770.3)="ACK"
 . S RAFDA(101,"+1,",770.4)="O01"
 . S RAFDA(101,"+1,",770.6)=""  ;IHS/ITSC/CLS 04/25/2003
 . S RAFDA(101,"+1,",770.7)="RA-MED"
 . S RAFDA(101,"+1,",770.11)="ORM"
 . S RAFDA(101,"+1,",771)="Q"
 . S RAFDA(101,"+1,",773.1)=$$N(),RAFDA(101,"+1,",773.2)=$$N()
 . S RAFDA(101,"+1,",773.3)=$$N(),RAFDA(101,"+1,",773.4)=$$Y()
 . D MSG^RAAIPST2("RA TCP ORM",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA TCP ORM")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA TCP ORM",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.1 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA REG, RA EXAMINED, and RA"
 .. S ^ORD(101,RA101,1,2,0)="CANCEL event protocols.  It is used by the VISTA HL7 package to send"
 .. S ^ORD(101,RA101,1,3,0)="ORM messages to TCP/IP recipients.  This protocol should be entered in the"
 .. S ^ORD(101,RA101,1,4,0)="ITEM multiple field of those event point protocols if this type of"
 .. S ^ORD(101,RA101,1,5,0)="messaging scenerio is used at a facility.  This is part of the file set-up"
 .. S ^ORD(101,RA101,1,6,0)="to enable HL7 message flow when exams are registered, cancelled, and when"
 .. S ^ORD(101,RA101,1,7,0)="they reach the status flagged as 'examined' by the site."
 .. S ^ORD(101,RA101,1,0)="^^7^7^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAAIPST2("RA TCP ORM",101,1)
 . Q
 I '$D(^ORD(101,"B","RA TCP ORU")) D
 . N RA101,RAFDA
 . S RAFDA(101,"+1,",.01)="RA TCP ORU"
 . S RAFDA(101,"+1,",1)="TCP Client"
 . S RAFDA(101,"+1,",4)="subscriber"
 . S RAFDA(101,"+1,",12)="RADIOLOGY/NUCLEAR MEDICINE"
 . S RAFDA(101,"+1,",15)="Q"
 . S RAFDA(101,"+1,",20)="Q"
 . S RAFDA(101,"+1,",99)=$$FMTH^XLFDT($$NOW^XLFDT())
 . S RAFDA(101,"+1,",770.2)="RA-CLIENT-TCP"
 . S RAFDA(101,"+1,",770.3)="ACK"
 . S RAFDA(101,"+1,",770.4)="R01"
 . S RAFDA(101,"+1,",770.6)=""  ;IHS/ITSC/CLS 04/25/2003
 . S RAFDA(101,"+1,",770.7)="RA-MED"
 . S RAFDA(101,"+1,",770.11)="ORU"
 . S RAFDA(101,"+1,",771)="Q"
 . S RAFDA(101,"+1,",773.1)=$$N(),RAFDA(101,"+1,",773.2)=$$N()
 . S RAFDA(101,"+1,",773.3)=$$N(),RAFDA(101,"+1,",773.4)=$$Y()
 . D MSG^RAAIPST2("RA TCP ORU",101),UPDATE^DIE("E","RAFDA")
 . I $D(^ORD(101,"B","RA TCP ORU")) D  Q
 .. S RA101=$O(^ORD(101,"B","RA TCP ORU",0)) K RAFDA
 .. S RAFDA(101,RA101_",",770.95)=2.1 D FILE^DIE("E","RAFDA")
 .. S ^ORD(101,RA101,1,1,0)="This protocol is used in conjunction with the RA RPT event point protocol."
 .. S ^ORD(101,RA101,1,2,0)="The HL7 package uses this protocol to send rad/nuc med report (ORU)"
 .. S ^ORD(101,RA101,1,3,0)="messages to TCP/IP recipients.  This protocol should be entered in the"
 .. S ^ORD(101,RA101,1,4,0)="ITEM multiple field of the RA RPT protocol if this messaging scenerio is"
 .. S ^ORD(101,RA101,1,5,0)="used in a facility.  This is part of the file set-up to enable message"
 .. S ^ORD(101,RA101,1,6,0)="flow when a rad/nuc med report is verified."
 .. S ^ORD(101,RA101,1,0)="^^6^6^"_$$DT^XLFDT()_"^^"
 .. Q
 . D MSG^RAAIPST2("RA TCP ORU",101,1)
 . Q
 D EN1^RAAIPST2 ; continue to add protocols and items under existing
 ; protocols.
 ; *** End adding entries to the Protocol (101) file ***
 Q
ACTIVE() ; return 'ACTIVE', for ACTIVE/INACTIVE (2) field in file
 ; 771
 Q "ACTIVE"
CLIENT() ; return 'CLIENT (SENDER)', for CLIENT/SERVER (400.03) field
 ; in file 869.2
 Q "CLIENT (SENDER)"
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
N() ; return 'NO', for various fields in file 101
 Q "NO"
SLISTN() ; return 'SINGLE LISTENER', for CLIENT/SERVER (400.03) field
 ; in file 869.2
 Q "SINGLE LISTENER"
TCP() ; return 'TCP' for LLP TYPE (.02) field in file 869.2
 Q "TCP"
US() ; return 'US', for COUNTRY CODE (7) field in file 771
 Q "US"
Y() ; return 'YES', for PERMANENT (400.04) field in file 869.2
 Q "YES"
