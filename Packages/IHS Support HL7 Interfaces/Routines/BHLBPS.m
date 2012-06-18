BHLBPS ; IHS/TUCSON/DCP - HL7 RDS Message Processor ; 
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 ;
 ;------------------------------------------------------------
 ; This routine processes HL7 RDS messages and files the data
 ; into RPMS/PCC.  It does not produce any output variables.
 ;
 ; This routine requires the input variables listed below.
 ; These variables are supplied by the HL7 package, based
 ; on the incoming message that it was processing when it
 ; branched to this routine via the protocol file.
 ;
 ;  HLNEXT     = M code to be executed to $O through
 ;               the nodes of global that contains the
 ;               message being processed.
 ;
 ;  HLNODE     = A node from the message text global.  This
 ;               variable is set to the next line of the
 ;               incoming message when HLNEXT is executed.
 ;
 ;  HLQUIT     = A variable that indicates when there are no
 ;               more nodes (message lines) to process.
 ;
 ;  HLMTIENS   = The IEN in the MESSAGE TEXT FILE (#772)
 ;               for the subscriber application.
 ;
 ;  HL("APAT") = The application acknowledgement condition
 ;               from the message header segment of the
 ;               incoming message.
 ;
 ;  HL("EID")  = The IEN in the PROTOCOL FILE (#101) of
 ;               the event driver protocol that generated
 ;               the incoming message.
 ;
 ;  HL("EIDS") = The IEN in the PROTOCOL FILE (#101) of
 ;               the subscriber protocol that is receiving
 ;               the incoming message.
 ;
 ;  HL("FS")   = HL7 field separator character for the
 ;               incoming message.
 ;
 ;  HL("ECH")  = HL7 encoding characters for the incoming
 ;               message.
 ;
 ;  HL("MID")  = The HL7 message control ID for the incoming
 ;               message.
 ;
 ;
START ;  ENTRY POINT from HL7 client protocol
 ;
 D INIT
 F  X HLNEXT Q:HLQUIT'>0  S BHLSEG=$P(HLNODE,BHLFS,1) I BHLSEG'="",$T(@BHLSEG)'="" S BHLDATA=$P(HLNODE,BHLFS,2,$L(HLNODE,BHLFS)) D @BHLSEG
 D FILING,ACKMSG
 I $D(HLERR),BHLERR'="" S BHLERR=BHLERR_".  "_HLERR
 I BHLERR'="" S HLERR=BHLERR D BULLETIN
 D DISPLAY
END D EOJ
 Q
 ;-------------------------------------------------------------
MSH ;
 N BHLFAC
 ; adjust pieces so piece numbers match HL7 field numbers
 S BHLDATA=BHLFS_BHLDATA
 ; save MSH data for use in ACK message
 S BHLMSH=BHLDATA
 ; HL7 receiving facility number
 S BHLFAC=$P(BHLDATA,BHLFS,6)
 S $P(BHLBPS("PAT DEMO"),BHLFS,6)=BHLFAC
 S $P(BHLBPS("VISIT"),BHLFS,3)=BHLFAC
 Q
 ;
PID ;
 S BHLBPS("PID")=""
 ; name
 S $P(BHLBPS("PAT DEMO"),BHLFS,1)=$$FMNAME^HLFNC($P(BHLDATA,BHLFS,5),HLECH)
 ; dob
 S $P(BHLBPS("PAT DEMO"),BHLFS,2)=$$FMDATE^HLFNC($P(BHLDATA,BHLFS,7))
 ; sex
 S $P(BHLBPS("PAT DEMO"),BHLFS,3)=$P(BHLDATA,BHLFS,8)
 ; ssn
 S $P(BHLBPS("PAT DEMO"),BHLFS,4)=$P(BHLDATA,BHLFS,19)
 ; chart number (HRN)
 S $P(BHLBPS("PAT DEMO"),BHLFS,5)=$P($P(BHLDATA,BHLFS,3),BHLCS,1)
 Q
 ;
ORC ;
 S BHLBPS("ORC")=""
 ; provider DEA #
 S $P(BHLBPS("MED"),BHLFS,11)=$P($P(BHLDATA,BHLFS,12),BHLCS,1)
 ; provider name - last, first, middle, suffix - 30 char max
 S $P(BHLBPS("MED"),BHLFS,12)=$$FMNAME^HLFNC($E($P($P(BHLDATA,BHLFS,12),BHLCS,2,5),1,30),HLECH)
 Q
 ;
RXD ;
 S BHLBPS("RXD")=""
 ; rx number
 S $P(BHLBPS("MED"),BHLFS,1)=$P(BHLDATA,BHLFS,7)
 ; quantity
 S $P(BHLBPS("MED"),BHLFS,2)=$P(BHLDATA,BHLFS,4)
 ; dispense date
 S $P(BHLBPS("MED"),BHLFS,4)=$$FMDATE^HLFNC($P(BHLDATA,BHLFS,3))
 ; xkey
 S $P(BHLBPS("MED"),BHLFS,5)=$P(BHLDATA,BHLFS,7)_"_"_$P(BHLDATA,BHLFS,1)
 ; ndc
 S $P(BHLBPS("MED"),BHLFS,7)=$P($P(BHLDATA,BHLFS,2),BHLCS,4)
 ; drug
 S $P(BHLBPS("MED"),BHLFS,8)=$P($P(BHLDATA,BHLFS,2),BHLCS,5)
 ; units
 S $P(BHLBPS("MED"),BHLFS,9)=$P(BHLDATA,BHLFS,5)
 ; sig
 S $P(BHLBPS("MED"),BHLFS,10)=$P(BHLDATA,BHLFS,9)
 Q
 ;
Z02 ;
 S BHLBPS("Z02")=""
 ; days
 S $P(BHLBPS("MED"),BHLFS,3)=$P(BHLDATA,BHLFS,2)
 ; action
 S $P(BHLBPS("MED"),BHLFS,6)=$P(BHLDATA,BHLFS,3)
 ; rph code
 S $P(BHLBPS("MED"),BHLFS,13)=$P($P(BHLDATA,BHLFS,1),BHLCS,1)
 ; rph name - last, first, middle - 30 char max
 S $P(BHLBPS("MED"),BHLFS,14)=$$FMNAME^HLFNC($E($P($P(BHLDATA,BHLFS,1),BHLCS,2,4),1,30),HLECH)
 Q
 ;
Z03 ;
 S BHLBPS("Z03")=""
 ; visit date
 S $P(BHLBPS("VISIT"),BHLFS,1)=$$FMDATE^HLFNC($P(BHLDATA,BHLFS,1))
 ; service catagory
 S $P(BHLBPS("VISIT"),BHLFS,2)=$P(BHLDATA,BHLFS,2)
 Q
 ;
FILING ;
 N SEG
 F SEG="PID","ORC","RXD","Z02","Z03" I '$D(BHLBPS(SEG)) S BHLERR=BHLERR_","_SEG
 I BHLERR'="" S BHLERR="MISSING MESSAGE SEGMENT(S): "_$E(BHLERR,2,$L(BHLERR)) Q
 D ^BHLBPS1
 Q
 ;
ACKMSG ;
 ; transmit acknowledgement message back to sending application if required
 N HLRESLTA
 I $G(HL("APAT"))="",$G(HL("ACAT"))'="" Q
 I HL("APAT")="NE" Q
 I HL("APAT")="SU",BHLERR'="" Q
 I HL("APAT")="ER",BHLERR="" Q
 S HLA("HLA",1)="MSA"_BHLFS_$S(BHLERR="":"AA",1:"AE")_BHLFS_HL("MID")
 I BHLERR'="" S HLA("HLA",2)="ERR"_BHLFS_BHLERR
 Q:$G(BHLDBUG)  ; don't send ACK in programmer debug mode
 D GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"LM",1,.HLRESLTA)
 I $P(HLRESLTA,U,2)'="" S BHLERR=BHLERR_" ** APP ACK GEN ERROR "_$TR(HLRESLTA,U,":")_" **"
 Q
 ;
BULLETIN ; Send Error Bulletin
 ;
 Q:$G(BHLDBUG)
 N %X,%Y,X,XMB,XMDT,XMDUZ,Y1
 S XMB="BHLBPS RX-PCC MESSAGE ERROR"
 S XMB(1)=BHLERR
 S XMB(2)=$G(BHLEDATA)
 S XMB(3)=HLMTIEN
 S XMDUZ=.5
 D ^XMB
 Q
 ;
EOJ ;
 K BHLDATA,BHLFS,BHLCS,BHLBPS,BHLMSH,BHLERR,BHLSEG,BHLEDATA
 K D0,DA,DD,DFN,DIC,DIK,DO,DR,F,I,X,Y,%,HLA
 Q
 ;
INIT ;
 D ^XBKVAR ; make sure kernel variables are defined
 D EOJ
 K HLERR
 S BHLERR=""
 S BHLBPS("MED")=""
 S BHLBPS("VISIT")=""
 S BHLBPS("PAT DEMO")=""
 S BHLFS=HL("FS")          ; HL7 field separator
 S HLECH=HL("ECH")         ; HL7 encoding characters
 S BHLCS=$E(HLECH,1)       ; HL7 component separator
 Q
 ;
DEBUG ; ENTRY POINT for programmer testing
 ;
 ; This entry point will not send any bulletins or HL7 messages.
 ; The ACK message, HL7 errors, and bulletin errors will be written
 ; to the screen instead.  If the error involves data stored in
 ; the APCDALVR array, that array will be written out to
 ; ^TMP("BHLBPS",$J,"APCDALVR",I), where I is the ACPDALVR index.
 ;
 N BHLMSH9,BHLSAN,X,X2,HL,HLMTIEN,HLNODE,HLQUIT,HLNEXT,HLECH
 N %1,%DT,DISYS,IO,DIR,X,Y
 ;
 S DIR(0)="NO",DIR("T")=300,DIR("A")="Enter IEN for message to be processed" D ^DIR
 S HLMTIEN=Y Q:"^"[HLMTIEN
 ;
 S HLNODE=$G(^HL(772,HLMTIEN,"IN",1,0))
 I $E(HLNODE,1,3)'="MSH" W !,"MSH is missing" Q
 ;
 ; extract data from MSH
 ;
 S HL("FS")=$E(HLNODE,4)
 S HL("ECH")=$P(HLNODE,HL("FS"),2)
 S HL("SAN")=$P(HLNODE,HL("FS"),3)
 S HL("RAN")=$P(HLNODE,HL("FS"),5)
 S BHLMSH9=$P(HLNODE,HL("FS"),9)
 S HL("MTN")=$P(BHLMSH9,$E(HL("ECH"),1),1)
 S HL("ETN")=$P(BHLMSH9,$E(HL("ECH"),1),2)
 S HL("MID")=$P(HLNODE,HL("FS"),10)
 S HL("ACAT")=$P(HLNODE,HL("FS"),15)
 S HL("APAT")=$P(HLNODE,HL("FS"),16)
 ;
 ; check MSH for missing data
 ;
 I HL("SAN")="" W !,"sending application is missing from MSH" Q
 I HL("RAN")="" W !,"receiving application is missing from MSH" Q
 I HL("MTN")="" W !,"message type is missing from MSH" Q
 I HL("ETN")="" W !,"event type is missing from MSH" Q
 ;
 ;Validate message type
 ;
 S HL("MTP")=0
 S:(HL("MTN")'="") HL("MTP")=+$O(^HL(771.2,"B",HL("MTN"),0))
 I ('HL("MTP")) W !,"Invalid Message Type" Q
 ;
 ;Validate event type
 ;
 S HL("ETP")=0
 S:(HL("ETN")'="") HL("ETP")=+$O(^HL(779.001,"B",HL("ETN"),0))
 I ('HL("ETP")) W !,"Invalid Event Type" Q
 ;
 ;Validate sending application
 ;
 S HL("SAP")=+$O(^HL(771,"B",HL("SAN"),0))
 I 'HL("SAP") S BHLSAN=$$UPPER^HLFNC(HL("RAN")),HL("SAP")=+$O(^HL(771,"B",BHLSAN,0))
 I 'HL("SAP") W !,"Invalid Sending Application" Q
 ;
 ;Validate receiving application
 ;
 S HL("RAP")=+$O(^HL(771,"B",HL("RAN"),0))
 I 'HL("RAP") S X=$$UPPER^HLFNC(HL("RAN")),HL("RAP")=+$O(^HL(771,"B",X,0))
 I 'HL("RAP") W !,"Invalid Receiving Application"
 S X2=$G(^HL(771,HL("RAP"),0))
 I (X2="") W !,"Invalid Receiving Application" Q
 I ($P(X2,"^",2)'="a") W !,"Receiving Application is Inactive" Q
 ;
 ;Find Server Protocol - based on message and event type
 ;
 S HL("EID")=+$O(^ORD(101,"AHL1",HL("SAP"),HL("MTP"),HL("ETP"),0))
 I 'HL("EID") W !,"Invalid Event" Q
 ;
 ;Find Client Protocol - in ITEM multiple of Server Protocol
 ;
 S HL("EIDS")=0
 F  S HL("EIDS")=+$O(^ORD(101,HL("EID"),10,"B",HL("EIDS"))) Q:('HL("EIDS"))  S X=$G(^ORD(101,HL("EIDS"),770))  Q:(($P(X,"^",2)=HL("RAP"))&($P(X,"^",3)=HL("MTP"))&($P(X,"^",4)=HL("ETP")))
 I 'HL("EIDS") W !,"Invalid Receiving Application for this Event" Q
 ;
 W !,"Processing..."
 S HLNODE=""
 S HLQUIT=0
 S HLNEXT="S HLQUIT=$O(^HL(772,HLMTIEN,""IN"",HLQUIT)) S:HLQUIT HLNODE=$G(^(HLQUIT,0))"
 K BHLMSH9,BHLSAN,X,X2
 K ^TMP("BHLBPS",$J)
 S BHLDBUG=1
 D START
 W !,"Done"
 K BHLDBUG
 Q
 ;
DISPLAY ; Display result messages (programmer debug mode only)
 ;
 Q:'$G(BHLDBUG)
 W !,"Error Message:",!,?3,$S($G(HLERR)="":"none",1:HLERR)
 W !,"Error Data:",!,?3,$S($G(BHLEDATA)="":"none",1:BHLEDATA)
 W !,"ACK message:"
 I '$D(HLA) W !,?3,"none" Q
 N I S I=0 F  S I=$O(HLA("HLA",I)) Q:I=""  W !,?3,HLA("HLA",I)
 Q
