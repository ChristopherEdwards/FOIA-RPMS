BADEHL2 ;IHS/MSC/MGH/PLS/VAC - Dentrix HL7 interface  ;16-Jul-2009 10:54;PLS
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;; Modified - IHS/MSC/AMF - 11/23/10 - More descriptive alert messages
 Q
 ; Build Outbound Master File Updates for the provider file
NEWMSG(IEN,MFNTYP) ;EP
 N HLPM,HLST,ARY,HLQ,TODAY,NODE,NODE1,NODE11,NODE13,WHO,ERR
 N LN,HL1,APPARMS,HLPM,HLFS,HLECH,NPI
 S LN=0
 S HLPM("MESSAGE TYPE")="MFN"
 S HLPM("EVENT")="M02"
 S HLPM("VERSION")=2.4
 I '$$NEWMSG^HLOAPI(.HLPM,.HLST,.ERR) D  Q
 .D NOTIF(IEN,"Unable to build HL7 message. "_$G(ERR)) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 ;Create segments
 ;
 D MFI
 I '$D(ERR) D MFE(IEN)
 I '$D(ERR) D STF(IEN)
 I '$D(ERR) D PRA(IEN)
 Q:$D(ERR)>0
 ; Define sending and receiving parameters
 I '$D(ERR) D
 .S APPARMS("SENDING APPLICATION")="RPMS-DEN"
 .S APPARMS("ACCEPT ACK TYPE")="AL"  ;Commit ACK type
 .S APPARMS("APP ACK RESPONSE")="AACK^BADEHL1"  ;Callback when 'application ACK' is received
 .S APPARMS("ACCEPT ACK RESPONSE")="CACK^BADEHL1"  ;Callback when 'commit ACK' is received
 .S APPARMS("APP ACK TYPE")="AL"  ;Application ACK type
 .S APPARMS("QUEUE")="DENT MFE"   ;Incoming QUEUE
 .S WHO("RECEIVING APPLICATION")="DENTRIX"
 .S WHO("FACILITY LINK NAME")="DENTRIX"
 .I '$$SENDONE^HLOAPI1(.HLST,.APPARMS,.WHO,.ERR) D
 ..D NOTIF(IEN,"Unable to send HL7 message. "_$G(ERR)) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ;
ERR ;
 Q
 ;
MFI ;Create the MFI segment
 N NOW,FLD
 S NOW=$$NOW^XLFDT()
 S NOW=$$HLDATE^HLFNC(NOW,"TS")
 D SET(.ARY,"MFI",0)
 D SET(.ARY,"PRA",1)
 D SET(.ARY,"RPMS",2)
 D SET(.ARY,"UPD",3)
 D SET(.ARY,NOW,4)
 D SET(.ARY,NOW,5)
 D SET(.ARY,"NE",6)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF(IEN,"Can't create MFI. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ; Create MFE segment
MFE(IEN) ;EP
 Q:'$G(IEN)
 N PID,SGM,X,LP,VAL,HLQ
 S HLQ=HL1("Q")
 D SET(.ARY,"MFE",0)
 D SET(.ARY,MFNTYP,1)
 D SET(.ARY,1,2)
 D SET(.ARY,$$HLDATE^HLFNC($$DT^XLFDT()),3)
 D SET(.ARY,IEN,4)
 D SET(.ARY,"CE",5)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF(IEN,"Can't create MFE. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
 ; Create segment
STF(IEN) ;Create the STF segment
 Q:'$G(IEN)
 N ADDR,PHONE,DGNAME,FLD,K,CNT,SHIP,REL,FLD,VAL,LP,X
 N AC,PN,EX
 S HLQ=HL1("Q")
 S NODE=$G(^VA(200,IEN,0)),NODE13=$G(^VA(200,IEN,.13))
 S NODE1=$G(^VA(200,IEN,1))
 S NODE11=$G(^VA(200,IEN,.11))
 Q:NODE=""
 D SET(.ARY,"STF",0)
 S NPI=""
 S NPI=$$NPI^XUSNPI("Individual_ID",IEN)
 I NPI<1 S ERR="No NPI.  Can't create STF." D NOTIF(IEN,ERR) Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 D SET(.ARY,+IEN,1)  ;Primary Key
 D SET(.ARY,+NPI,2)   ;NPI
 S DGNAME("FILE")=200,DGNAME("IENS")=IEN
 S DGNAME("FIELD")=.01
 ;Name of provider
 S FLD=$$HLNAME^XLFNAME(.DGNAME,"","^")
 I FLD="" S ERR="No provider name.  Can't create STF." D NOTIF(IEN,ERR) Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ; More descriptive alert message
 F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 .D SET(.ARY,VAL,3,LP)
 D SET(.ARY,"N",4)  ; Staff type
 ;D SET(.ARY,$P(NODE1,U,2),5)  ;Gender
 ;D SET(.ARY,$$HLDATE^HLFNC($P(NODE1,U,3)),6)  ;DOB
 D SET(.ARY,$S(MFNTYP="MDC":"I",1:"A"),7)  ;Active/Inactive flag
 S PHONE=$$HLPHONE^HLFNC($P(NODE13,U,2))
 I $L(PHONE) D
 .D SET(.ARY,PHONE,10,1)    ;Work phone
 .D SET(.ARY,"WPH",10,2)
 .I $L($P(PHONE,")")) D
 ..S AC=+$P($P(PHONE,")"),"(",2)
 ..D:AC SET(.ARY,AC,10,3)
 .I $P(PHONE,")",2) D
 ..S PN=$E($P($P(PHONE,")",2),"X"),1,8)  ;extract the phone number
 ..D:PN SET(.ARY,PN,10,4)
 .S EX=$P(PHONE,"X",2)
 .D:$L(EX) SET(.ARY,EX,10,5)
 S ADDR=$$ADDR^VAFHLFNC($P(NODE11,U,1,6))
 F LP=1:1:$L(ADDR,$E(HLECH)) S VAL=$P(ADDR,$E(HLECH),LP) D
 .D SET(.ARY,VAL,11,LP)   ;Address
 ;D SET(.ARY,TODAY,12)  ;Activation Date
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF(IEN,"Can't create STF. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
PRA(IEN) ;Create the PRA segment
 Q:'$G(IEN)
 N I,SSN,MEDICAID,DATA,RP,X,LP,FLD,VAL,VAL1,DEA,VA
 D SET(.ARY,"PRA",0)
 D SET(.ARY,IEN,1)
 D SET(.ARY,"Dental General Practice",5)
 S SSN=$P(NODE1,U,9)
 S MEDICAID=$P($G(^VA(200,IEN,9999999)),U,7)
 S DEA=$P($G(^VA(200,IEN,"PS")),U,2)
 S VA=$P($G(^VA(200,IEN,"PS")),U,3)
 ;Only include items which have values
 S FLD=1
 ;S FLD=""
 I $L(NPI) D
 .D SET(.ARY,+NPI,6,1,1,FLD)
 .D SET(.ARY,"NPI",6,2,1,FLD)
 .S FLD=FLD+1
 I $L(SSN) D
 .D SET(.ARY,SSN,6,1,1,FLD)
 .D SET(.ARY,"SSN",6,2,1,FLD)
 .S FLD=FLD+1
 I $L(DEA) D
 .D SET(.ARY,DEA,6,1,1,FLD)
 .D SET(.ARY,"DEA",6,2,1,FLD)
 .S FLD=FLD+1
 I $L(VA) D
 .D SET(.ARY,VA,6,1,1,FLD)
 .D SET(.ARY,"VA",6,2,1,FLD)
 .S FLD=FLD+1
 I $L(MEDICAID) D
 .D SET(.ARY,MEDICAID,6,1,1,FLD)
 .D SET(.ARY,"MEDICAIDID",6,2,1,FLD)
 .S FLD=FLD+1
 ;S:NPI'="" FLD=NPI_"^NPI"
 ;S:SSN'="" FLD=FLD_$S($L(FLD):"~",1:"")_SSN_"^SSN"
 ;S:DEA'="" FLD=FLD_$S($L(FLD):"~",1:"")_DEA_"^DEA"
 ;S:VA'="" FLD=FLD_$S($L(FLD):"~",1:"")_VA_"^VA"
 ;S:MEDICAID'="" FLD=FLD_$S($L(FLD):"~",1:"")_MEDICAID_"^MEDICAID"
 ;F RP=1:1:$L(FLD,$E(HLECH,2,2)) S VAL1=$P(FLD,$E(HLECH,2,2),RP) D
 ;.F LP=1:1:$L(VAL1,$E(HLECH)) S VAL=$P(VAL1,$E(HLECH),LP) D
 ;..D SET(.ARY,VAL,6,LP,,RP)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF(IEN,"Can't create PRA. "_ERR) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
NOTIF(IEN,MSG) ;EP ------- IHS/MSC/AMF 11/23/10 More descriptive alert
 N PVDIEN,RET,X,SAVE,STR,LEN
 N XQA,XQAID,XQDATA,XQAMSG
 S LEN=$L("Provider:  ["_IEN_"]. "_$G(MSG))
 S STR=""
 I $L(IEN) S STR=$P($G(^VA(200,IEN,0)),U,1) I ($L(STR)+LEN)>70 S STR=$E(STR,1,(67-LEN))_"..."
 S XQAMSG="Provider: "_STR_" ["_IEN_"]. "_$G(MSG)
 ; -------- end IHS/MSC/AMF 11/23/10 
 S XQAID="ADEN,"_IEN_","_50
 S XQDATA="IEN="_IEN
 S XQA("G.RPMS DENTAL")=""
 D SETUP^XQALERT
 ;Save the IEN in a parameter for correction
 S X=$$GET^XPAR("ALL","BADE EDR TOTAL PROVIDER ERRORS",1,"E")
 S X=X+1
 S SAVE=IEN_" "_MSG
 D EN^XPAR("SYS","BADE EDR TOTAL PROVIDER ERRORS",1,X)
 D EN^XPAR("SYS","BADE EDR PROVIDER ERRORS",X,SAVE)
 Q
FINDTYP(IEN) ;Find out if a new or update message should be sent
 ;If MFNTYP exists, no need to do the lookup
 N TD,ENTER,ACTIVE,RES
 Q:$D(MFNTYP) MFNTYP
 S TD=$$DT^XLFDT()
 S ENTER=$P($G(^VA(200,IEN,1)),U,7)  ; Date Entered
 I TD>ENTER S RES="MUP1"
 I ENTER=TD D
 .I $P($G(^VA(200,IEN,1.1)),U,1)'="" S RES="MUP1"
 .I $P($G(^VA(200,IEN,1.1)),U,1)="" S RES="MAD"
 I $P($G(^VA(200,IEN,0)),U,11)!($P($G(^VA(200,IEN,"PS")),U,4)) S RES="MDC"
 Q RES
