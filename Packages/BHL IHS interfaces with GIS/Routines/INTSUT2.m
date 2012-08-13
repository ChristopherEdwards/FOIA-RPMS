INTSUT2 ;JPD; 1 Feb 96 09:26; Utility routine 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
CHECK(INDA,DIE,Y,DWSFLD) ;called from post action of 1st screen of
 ;windowman gallery.
 ;Input:
 ; INDA - ien of 4001.1 entry
 ; DIE - ^DIZ(4001.1,
 ;Output:
 ; Y - where to put cursor
 ; DWSFLD - Array of values for gallery
 ;
 N INIPPO,INBPN,INBPNAP
 ;Type is Unit test
 I $$VAL^DWRA(4001.1,13.02,0,DIE,INDA)="T" S Y="" Q 1
 ;If logon server and no app server have them get app server
 I $$VAL^DWRA(4001.1,18.03,0,DIE,INDA),'$$VAL^DWRA(4001.1,18.04,0,DIE,INDA) D  Q 0
 .D MSG("You picked a Logon Server but no App Server")
 .S Y="18.04"
 ;If App server and no logon server have them get logon server
 I $$VAL^DWRA(4001.1,18.04,0,DIE,INDA),'$$VAL^DWRA(4001.1,18.03,0,DIE,INDA) D  Q 0
 .D MSG("You picked an App Server but no Logon Server")
 .S Y="18.03"
 I $$VAL^DWRA(4001.1,13.02,0,DIE,INDA)="U",$$VAL^DWRA(4001.1,6,0,DIE,INDA)="" D  Q 0
 .D MSG("You must pick a direction. Inbound or Outbound")
 .S Y=6
 Q 1
GETPORT(INBPN) ;get port - called from INTS
 ;Input:
 ; INBPN - ien of background process
 N INIPPO,POP
 S POP=0,INIPPO=6100 F  S INIPPO=INIPPO+$R(15)+10 D  Q:POP
 .L +^INRHB("RUN","SRVR",INBPN,INIPPO):0 S:$T POP=1
 .S ^INRHB("RUN","SRVR",INBPN,INIPPO)=$H
 Q INIPPO
PORTULCK(INIPPO) ;current port value changed- called from gallery
 ;Input:
 ; INIPPO - port number
 N INBPN
 S INBPN=+$O(^INTHPC("B","TEST INTERACTIVE",""))
 L -^INRHB("RUN","SRVR",INBPN,INIPPO)
 Q
LOCKPORT(X) ;Lock port - called from gallery
 ;Input:
 ; X - Port number
 N INBPN
 S INBPN=+$O(^INTHPC("B","TEST INTERACTIVE",""))
 L +^INRHB("RUN","SRVR",INBPN,X):0 I '$T D  Q
 .D MSG("Port is already locked by another user. Pick another one")
 .K X
 S DIPA("18.02")=X
 S ^INRHB("RUN","SRVR",INBPN,X)=$H
 Q
TYPECHK(INDA,X,DWDIPA,DWSFLD) ;User sets TYPE field.
 ;Input:
 ; INDA - ien of Criteria
 ; X - Value inserted by user in TYPE field
 ;Output:
 ; DWDIPA - sets DIPA
 ; DWSFLD - Sets value in fields
 ;
 N INBPN,INIPPO,INBPNAP
 ;called from post action of field 13.02 in windowman gallery
 S DWDIPA(13.02,13.02)=""
 ;If type is changing blank out second screen values
 I $D(DWFCHG) F I=13.03,16.01,16.02,16.03,16.05,16.06,16.07,16.08,16.09,16.1,16.11,16.12,17.01,17.02,23.01,17.03,18.01,18.02 S DWSFLD(I)="@"
 ;
 ;If type is unsolicited clear query values make uneditable
 I $E(X)="U" D
 .;make fields display only
 .S (DWSFLD(17.03,0),DWSFLD(18.01,0),DWSFLD(18.02,0),DWSFLD(18.03,0),DWSFLD(18.04,0),DWSFLD(13.07,0))=2
 .;clear fields
 .S DWSFLD(18.03)="^S X=""@""",DWSFLD(18.04)="^S X=""@""",DWSFLD(13.07)="^S X=""@""",DWSFLD(17.03)="^S X=""@""",DWSFLD(18.01)="^S X=""@""",DWSFLD(18.02)="^S X=""@"""
 .;make fields editable
 .S (DWSFLD(20,0),DWSFLD(6,0))=0
 .S INBPN=+$$VAL^DWRA(4001.1,20,1,DIE,INDA)
 .;Inbound unsolicited set accept ack transaction type
 .I $$VAL^DWRA(4001.1,6,1,DIE,INDA)="I" S DWSFLD(13.01)="HL GIS ACCEPT ACKNOWLEDGEMENT"
 .S (DWSFLD(17.03,0),DWSFLD(18.01,0),DWSFLD(18.02,0))=2
 .;only continue if change was made to reinitialize
 .Q:'$D(DWFCHG)
 .;if inbound then set Accept ack Tran type
 .I $$VAL^DWRA(4001.1,6,0,DIE,INDA)="I" S DWSFLD(13.01)="HL GIS ACCEPT ACKNOWLEDGEMENT"
 .S DWSFLD(13.04)="AL"
 .D DEFRHT^INTSUT1(.DWSFLD,+$G(INBPN))
 ;If query response
 I $E(X)="Q" D
 .;make background process/Start at process display only and clear them
 .S (DWSFLD(20,0),DWSFLD(13.07,0))="2^1"
 .S DWSFLD(20)="^S X=""@""",DWSFLD(13.07)="^S X=""@"""
 .S DWSFLD(6)="O",DWSFLD(6,0)=2
 .S (DWSFLD(18.03,0),DWSFLD(18.04,0))=0
 .;only continue if change was made to reinitialize
 .Q:'$D(DWFCHG)
 .;Accept Transaction Type
 .S DWSFLD(13.01)="HL GIS ACCEPT ACKNOWLEDGEMENT"
 .;Accept ack condition
 .S DWSFLD(13.04)="AL"
 .;Query response background process
 .S INBPN=+$O(^INTHPC("B","TEST INTERACTIVE",""))
 .I $$VAL^DWRA(4001.1,18.01,0,DIE,INDA)="" S DWSFLD(18.01)="127.0.0.1"
 .;set port
 .S INIPPO=$$VAL^DWRA(4001.1,18.02,0,DIE,INDA)
 .S INBPNAP=+$$VAL^DWRA(4001.1,18.04,0,DIE,INDA)
 .I INBPNAP,$$VAL^DWRA(4001.1,17.03,0,DIE,INDA)="" S DWSFLD(17.03)=$P($G(^INTHPC(INBPNAP,7)),U,4)
 .D DEFRHT^INTSUT1(.DWSFLD,+$G(INBPN))
 .;if port not set
 .I INIPPO="" S DWSFLD(18.02)="AUTO GENERATE"
 .E  I INIPPO'="",$E(INIPPO,1,4)'="AUTO" D
 ..;try locking existing defined port
 ..L +^INRHB("RUN","SRVR",INBPN,INIPPO):0 I '$T D MSG("Note - Port currently locked by another user")
 ..L -^INRHB("RUN","SRVR",INBPN,INIPPO)
 ;Unit test
 I $E(X)="T" D
 .S (DWSFLD(18.03,0),DWSFLD(18.04,0))=2
 .;clear fields
 .S (DWSFLD(18.03),DWSFLD(18.04),DWSFLD(6))="^S X=""@"""
 .S DWSFLD(20,0)="2^1",DWSFLD(20)="^S X=""@"""
 .;start at process required and direction uneditable
 .S DWSFLD(13.07,0)=1,DWSFLD(6,0)=2
 Q
CLSVCK(X,DWSFLD) ;client server check
 ;Input:
 ; X - User input - 0 Client, 1 Server
 ;Output:
 ; DWSFLD - Array to set gallery
 ;
 ;answer was server
 I X=1 S DWSFLD(16.01,0)=2,DWSFLD(16.01)="^S X=""@"""
 ;answer was client or not answered
 I 'X S DWSFLD(16.01,0)=0
 Q
MSG(MSG) ;Write message to screen
 ;Input:
 ; MSG - message to display
 W $$SETXY^%ZTF(0,21),MSG,*7
 Q
PRE(INDA,INPRE,INUIF,INARY) ;Pre process
 ;Input:
 ; INDA - ien of 4001.1
 ; INPRE - xecutable pre processing code
 ; INUIF - Current Universal Interface file ien to be sent next
 ;Output: INARY("C") = ien  -  Current UIF ien value to process
 ;        INARY("A",n) =  ien  - Process UIF at position n in ^UTILITY
 ;        INARY("F") = ien - First UIF entry to process
 ;        INARY("L") = ien - Last UIF entry to process  
 ;        INARY("M",n) = Message to display & save in displayman array
 ;        INARY("REF") = 1 Refresh command screen when done
 N DIPA,INBPN,INIP,INCHNL,INIP,INDEST,INXDST,INTT
 K INARY
 D DISPLAY^INTSUT1("Pre Processing")
 X INPRE
 Q
POSTPRE(INDA,INARY,INEXTUIF,INLASTN,INPOP,INUPDAT) ;Post Pre processing
 ; Input: 
 ;  INARY= "^INTHU" , "^INLHFTSK"
 ;  INARY("C") = ien  -  Current UIF ien value to process
 ;  INARY("A",n) =  ien  - Process UIF at position n in ^UTILITY
 ;  INARY("F") = ien - First UIF entry to process
 ;  INARY("L") = ien - Last UIF entry to process  
 ;  INARY("M",n) = Message to display & save in displayman array
 ;  INARY("REF") = 1 Refresh command screen when done
 ; Output: INEXTUIF - Next Universal Interface file entry to process -
 ;                    can be set/reset by the programmer
 ;         INLASTN - Last entry in ^UTILITY global processed - can be
 ;                   set/reset by the programmer - (should be set if
 ;                   it was not set previously)
 ; INEXTUIF and INLASTN need to be set in or out of the PRE and POST
 ; in order to process at least one message.
 ;
 N INP
 I 'INPOP Q 0
 Q:$D(INARY)<10 1
 K INUPDAT
 I $G(INARY("C"))+$G(INARY("F"))+$G(INARY("L"))+$O(INARY("A","")) S INUPDAT=1
 I $G(INARY("REF")) D
 .;D CLR^DIJF
 .D LSTHDR^INTSTRT(INDA)
 .D SCR^INTSUT1(5,17,1)
 S:$G(INARY)="" INARY="^INTHU"
 D DISPLAY^INTSUT1("POSTPRE Processing")
 ;current entry to process
 I +$G(INARY("C")) S INEXTUIF=+INARY("C")
 D MERGE2^INTSUT3(.INARY)
 ;put entry in first spot
 I $D(@(INARY_"(+$G(INARY(""F"")),0)")) D
 .S INP=+$O(^UTILITY("INTHU",DUZ,$J,""))
 .I INP S INP=INP-".00001"
 .S:'INP INP=1
 .S ^UTILITY("INTHU",DUZ,$J,INP,INARY("F"))=INARY("F")
 ;Put entry in last spot 
 I $D(@(INARY_"(+$G(INARY(""L"")),0)")) D
 .S INP=+$O(^UTILITY("INTHU",DUZ,$J,""),-1)
 .S ^UTILITY("INTHU",DUZ,$J,INP,INARY("L"))=INARY("L")
 I '$L($G(INLASTN)),$D(INUPDAT) D
 .S INLASTN=$O(^UTILITY("INTHU",DUZ,$J,""))
 .I '$L($G(INEXTUIF)) S INEXTUIF=$O(^UTILITY("INTHU",DUZ,$J,+INLASTN,""))
 ;put messages in displayman array
 S INP=""
 F  S INP=$O(INARY("M",INP)) Q:'INP  D DISPLAY^INTSUT1(INARY("M",INP),INEXPAND)
 K INARY
 ;Update Multiple
 D UPDTFRUT^INTSUT3(INDA)
 Q 1
POST(INDA,INEXTUIF,INARY) ;Post process
 ;Input:
 ; INDA - ien of 4001.1
 ; INEXTUIF - next UIF ien to transmit
 ; Input: INARY("C") = ien  -  Current UIF ien value to process
 ;        INARY("A",n) =  ien  - Process UIF at position n in ^UTILITY
 ;        INARY("F") = ien - First UIF entry to process
 ;        INARY("L") = ien - Last UIF entry to process  
 ;        INARY("M",n) = "Message to display & save in displayman array
 ;        INARY("REF") = 1 Refresh command screen when done
 N DIPA,DIE,INBPN,INIP,INCHNL,INIP,INDEST,INXDST,INTT
 S INEXTUIF=$G(INEXTUIF)
 D DISPLAY^INTSUT1("Post Processing")
 X INIP("POST")
 Q
