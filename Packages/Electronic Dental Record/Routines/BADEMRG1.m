BADEMRG1 ;IHS/MSC/MGH/PLS - Dentrix HL7 interface  ;28-Jun-2010 16:59;MGH
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 Q
 ; Build Outbound A40
NEWMSG(FROM,TO,EVNTTYPE) ;EP
 N HLPM,HLST,ARY,HLQ,APPARMS,HLPM,HLMSGIEN,HLECH,HLFS,ERR,WHO
 N LN,HL1,HRCN,FLD,LP,X,LN
 S LN=0
 S HLPM("MESSAGE TYPE")="ADT"
 S HLPM("EVENT")=EVNTTYPE
 S HLPM("VERSION")=2.4
 I '$$NEWMSG^HLOAPI(.HLPM,.HLST,.ERR) D NOTIF^BADEHL1(DFN,"Unable to build HL7 message. "_$G(ERR)) Q
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 ;Create segments
 ;
 D EVN^BADEHL1(EVNTTYPE)
 I '$D(ERR) D PID^BADEHL1(TO)
 I '$D(ERR) D MRG(FROM)
 I '$D(ERR) D
 .; Define sending and receiving parameters
 .S APPARMS("SENDING APPLICATION")="RPMS-DEN"
 .S APPARMS("ACCEPT ACK TYPE")="AL"  ;Commit ACK type
 .S APPARMS("APP ACK RESPONSE")="AACK^BADEHL1"  ;Callback when 'application ACK' is received
 .S APPARMS("ACCEPT ACK RESPONSE")="CACK^BADEHL1"  ;Callback when 'commit ACK' is received
 .S APPARMS("APP ACK TYPE")="AL"  ;Application ACK type
 .S APPARMS("QUEUE")="DENT ADT"   ;Incoming QUEUE
 .;S APPARMS("RECEIVING APPLICATION")="DENTRIX"
 .;S APPARMS("FACILITY LINK NAME")="DENTRIX"
 .;S APPARMS("FAILURE RESPONSE")="FAILURE^DENTHL1"  ;Callback for transmission failures (i.e. - No 'commit ACK' received or message not sendable.
 .S WHO("RECEIVING APPLICATION")="DENTRIX"
 .S WHO("FACILITY LINK NAME")="DENTRIX"
 .S WHO("STATION NUMBER")=11555  ;Used for testing on external RPMS system
 .I '$$SENDONE^HLOAPI1(.HLST,.APPARMS,.WHO,.ERR) D NOTIF^BADEHL1(DFN,"Unable to send HL7 message. "_$G(ERR))
 Q
 ;
AACK ; EP - Application ACK callback - called when AA, AE or AR is received.
 N DATA,AACK,XQAID,XQDATA,XQA,XQAMSG,MSGID
 Q:'$G(HLMSGIEN)
 S MSGID=$P($G(^HLB(+HLMSGIEN,0)),U)
 S AACK=$G(^HLB(HLMSGIEN,4))
 I $P(AACK,U,3)'["|AA|" D
 .S XQAMSG="EDR message "_MSGID_" did not receive a correct application ack."
 .S XQAID="ADEN,"_MSGID_","_50
 .S XQDATA=$P(AACK,U,3)
 .S XQA("G.RPMS DENTAL")=""
 .D SETUP^XQALERT
 Q
 ;
CACK ; EP - Commit ACK callback - called when CA, CE or CR is received.
 N CACK,XQAID,XQAMSG,XQA,XQDATA,MSGID
 S MSGID=$P($G(^HLB(+HLMSGIEN,0)),U)
 S CACK=$G(^HLB(HLMSGIEN,4))
 I $P(CACK,U,3)'["|CA|" D
 .S XQAMSG="EDR message "_MSGID_" did not receive a correct commit acknowledgement."
 .S XQAID="ADEN,"_MSGID_","_50
 .S XQDATA=$P(CACK,U,3)
 .S XQA("G.RPMS DENTAL")=""
 .D SETUP^XQALERT
 Q
 ;
 ; Send Notification to group
 ; Input: DFN = Patient
 ;        MSG = Main message
NOTIF(TO,FROM,MSG) ;EP
 N PNAM,PVDIEN,RET,X,SAVE,FNAME
 N XQA,XQAID,XQADATA,XQAMSG
 S PNAM=$P($G(^DPT(TO,0)),U,1)
 S FNAME=$P($G(^DPT(FROM,0)),U,1)
 I $L(PNAM)>15 S PNAM=$E(PNAM,1,15)
 I $L(FNAME)>15 S FNAME=$E(FNAME,1,15)
 S XQAMSG=PNAM_" "
 S XQAMSG=XQAMSG_$G(MSG)
 S XQAID="ADEN,"_TO_","_50
 S XQDATA="FROM="_FNAME_" TO="_PNAM
 S XQA("G.RPMS DENTAL")=""
 D SETUP^XQALERT
 ;Save the DFN in a parameter for correction
 S X=$$GET^XPAR("ALL","BADE EDR MRG PTS ERRORS",1,"E")
 S X=X+1
 S SAVE="From: "_FROM_" to: "_TO_" "_MSG
 D EN^XPAR("SYS","BADE EDR MRG PTS ERRORS",X,SAVE)
 Q
 ;
ERR ;
 Q
MRG(FROM) ;EP
 N MRG,NAME,VAL
 D SET(.ARY,"MRG",0)
 D SET(.ARY,FROM,1)
 S NAME=$P(^DPT(FROM,0),U,1)
 S FLD=$$HLNAME^XLFNAME(NAME)
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,7,LP)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF^BADEHL1(DFN,"Can't create MRG. "_ERR)
 Q
 ; Create MSA segment
MSA ;EP
 N MSA
 D SET(.ARY,"MSA",0)
 D SET(.ARY,"AA",1)
 D SET(.ARY,"TODO-MSGID",2)
 D SET(.ARY,"Transaction Successful",3)
 D SET(.ARY,"todo-010",4)
 S MSA=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; Create MSH segment
 ;EP
 N MSH
 D SET(.ARY,"MSH",0)
 S MSH=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
