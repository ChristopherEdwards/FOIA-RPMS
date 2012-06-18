HLTF ;AISC/SAW,JRP-Create/Process Message Text File Entries ;01/23/06  12:56
 ;;1.6;HEALTH LEVEL SEVEN;**1,19,43,55,109,120**;Oct 13, 1995;Build 12
FILE ;Create Entries in files 772 and 773 for Version 1.5 Interface Only
 D CREATE(,.HLDA,.HLDT,.HLDT1)
 Q
CREATE(HLMID,MTIEN,HLDT,HLDT1) ;Create entries in Message Text (#772)
 ;
 ;Input  : HLMID = Variable in which value of message ID will be
 ;                 returned (pass by reference)
 ;         MTIEN = Variable in which IEN of Message Text file entry
 ;                 will be returned (pass by reference)
 ;         HLDT = Variable in which current date/time in FM internal
 ;                format will be returned (pass by reference)
 ;         HLDT1 = Variable in which current date/time in HL7 format
 ;                 will be returned (pass by reference)
 ;
 ;Output : See above
 ;
 ;Notes  : If HLDT has a value [upon entry], the created entries will
 ;         be given that value for their date/time (value of .01)
 ;       : Current date/time used if HLDT is not passed or invalid
 ;
 ;Make entry in Message Administration file
 N Y
 S HLDT=$G(HLDT)
 D MT(.HLDT)
 S Y=$$CHNGMID(MTIEN,.HLMID),HLDT1=$$HLDATE^HLFNC(HLDT)
 Q
TCP(HLMID,MTIEN,HLDT) ;create new message in 772 & 773 entries
 ;used for incoming messages and outgoing responses
 ;Input  : HLMID = Variable in which value of message ID will be
 ;                 returned (pass by reference)
 ;         MTIEN = Variable in which IEN of file 773 entry
 ;                 will be returned (pass by reference)
 ;         HLDT = Variable in which current date/time in FM internal
 ;                format will be returned (pass by reference)
 ;
 S HLDT=$G(HLDT),HLMID=$G(HLMID)
 D MT(.HLDT)
 S MTIEN=$$MA(MTIEN,.HLMID)
 Q
 ;
MT(HLX) ;Create entry in Message Text file (#772)
 ;
 ;Input  : HLX = Date/time entry in file should be given (value of .01)
 ;               Defaults to current date/time
 ;
 ;Output : HLDT = Date/time of created entry (value of .01)
 ;       : HLDT1 = HLDT in HL7 format
 ;
 ;Notes  : HLX must be in FileMan format (default value used if not)
 ;       : HLDT will be in FileMan format
 ;       : MTIEN is ien in file 772
 ;
 ;Check for input
 S HLX=$G(HLX)
 ;Declare variables
 N DIC,DD,DO,HLCNT,HLJ,X,Y
 F HLCNT=0:1 D  Q:Y>0  H HLCNT
 . I (HLX'?7N.1".".6N) S HLX=$$NOW^XLFDT
 . S DIC="^HL(772,",DIC(0)="L",(HLDT,X)=HLX
 . S Y=$$STUB772(X) ; This call substituted for D FILE^DICN by HL*1.6*109
 . ;Entry not created - try again
 . I Y<0 S HLX="" Q
 . S MTIEN=+Y
 ;***If we didn't get a record in 772, need to do something
 I Y<0 Q
 S HLDT1=$$HLDATE^HLFNC(HLDT)
 Q
 ;add to Message Admin file #773
MA(X,HLMID) ;X=ien in file 772, HLMID=msg. id (passed by ref.)
 ;return ien in file 773
 Q:'$G(^HL(772,X,0)) 0
 N DA,DD,DO,DIC,DIE,DR,HLDA,HLCNT,HLJ,Y
 S DIC="^HLMA(",DIC(0)="L"
 F HLCNT=0:1 D  Q:Y>0  H HLCNT
 . S Y=$$STUB773(X) ; This call substituted for D FILE^DICN by HL*1.6*109
 ;***If we didn't get a record in 773, need to do something
 I Y<0 Q 0
 S HLDA=+Y,HLMID=$$MAID(HLDA,$G(HLMID))
 Q HLDA
 ;
MAID(Y,HLMID) ;Determine message ID (if needed) & store message ID
 ;Y=ien in 773, HLMID=id,  Output message id
 N HLJ
 ;need to have id contain institution number to make unique
 S:$G(HLMID)="" HLMID=+$P($$PARAM^HLCS2,U,6)_Y
 S HLJ(773,Y_",",2)=HLMID
 D FILE^HLDIE("","HLJ","","MAID","HLTF") ;HL*1.6*109
 Q HLMID
 ;
CHNGMID(PTRMT,NEWID) ;Change message ID for entry in Message Text file
 ;Input  : PTRMT - Pointer to entry in Message Text file (#772)
 ;         NEWID - New message ID
 ;Output : 0 = Success
 ;         -1^ErrorText = Error/Bad input
 ;
 ;Check input
 S PTRMT=+$G(PTRMT)
 S NEWID=$G(NEWID)
 Q:('$D(^HL(772,PTRMT,0))) "-1^Did not pass valid pointer to Message Text file (#772)"
 N HLJ
 I $G(NEWID)="" S NEWID=+$P($$PARAM^HLCS2,U,6)_PTRMT
 S HLJ(772,PTRMT_",",6)=NEWID
 D FILE^HLDIE("","HLJ","","CHNGMID","HLTF") ; HL*1.6*109
 Q 0
 ;
OUT(HLDA,HLMID,HLMTN) ;File Data in Message Text File for Outgoing Message
 ;Version 1.5 Interface Only
 Q:'$D(HLFS)
 ;
 I HLMTN="ACK"!(HLMTN="MCF")!(HLMTN="ORR") Q:'$D(HLMSA)  D ACK(HLMSA,"I") Q
 ;
 ;-- if message contained MSA find inbound message
 I $D(HLMSA),$D(HLNDAP),$P(HLMSA,HLFS,3)]"" D
 . N HLDAI
 . S HLDAI=0
 . F  S HLDAI=$O(^HL(772,"AH",+$P($G(HLNDAP0),U,12),$P(HLMSA,HLFS,3),HLDAI)) Q:'HLDAI!($P($G(^HL(772,+HLDAI,0)),U,4)="I")
 . I 'HLDAI K HLDAI
 ;
 D STUFF^HLTF0("O")
 ;
 N HLAC S HLAC=$S($D(HLERR):4,'$P(HLNDAP0,"^",10):1,1:2) D STATUS^HLTF0(HLDA,HLAC,$G(HLMSG))
 D:$D(HLCHAR) STATS^HLTF0(HLDA,HLCHAR,$G(HLEVN))
 ;
 ;-- update status if MSA and found inbound message
 I $D(HLMSA),$D(HLDAI) D
 .N HLERR,HLMSG I $P(HLMSA,HLFS,4)]"" S HLERR=$P(HLMSA,HLFS,4)
 .S HLAC=$P(HLMSA,HLFS,2)
 .I HLAC'="AA" S HLMSG=$S(HLAC="AR":"Application Reject",HLAC="AE":"Application Error",1:"")_" - "_HLERR
 .S HLAC=$S(HLAC'="AA":4,1:3) D STATUS^HLTF0(HLDAI,HLAC,$G(HLMSG))
 Q
 ;
IN(HLMTN,HLMID,HLTIME) ;File Data in Message Text File for Incoming Message
 ;Version 1.5 Interface Only
 Q:'$D(HLFS)
 I HLMTN="ACK"!(HLMTN="MCF")!(HLMTN="ORR") Q:'$D(HLMSA)  D ACK(HLMSA,"O",$G(HLDA)) Q
 ;
 N HLDAI S HLDA=0
 I $D(HLNDAP),HLMID]"" D
 .F  S HLDA=+$O(^HL(772,"AH",+$P($G(HLNDAP0),U,12),HLMID,HLDA)) Q:'HLDA!($P($G(^HL(772,+HLDA,0)),U,4)="I")
 .I HLDA D
 ..S HLDT=+$P($G(^HL(772,HLDA,0)),"^"),HLDT1=$$HLDATE^HLFNC(HLDT)
 ..K ^HL(772,HLDA,"IN")
 .I $D(HLMSA),$P(HLMSA,HLFS,3)]"" D
 ..S HLDAI=0
 ..F  S HLDAI=$O(^HL(772,"AH",+$P($G(HLNDAP0),U,12),$P(HLMSA,HLFS,3),HLDAI)) Q:'HLDAI!($P($G(^HL(772,+HLDAI,0)),U,4)="O")
 ..I 'HLDAI K HLDAI
 ;
 I 'HLDA D CREATE(.HLMID,.HLDA,.HLDT,.HLDT1) K HLZ
 ;
 D STUFF^HLTF0("I")
 N HLAC S HLAC=$S($D(HLERR):4,1:1) D STATUS^HLTF0(HLDA,HLAC,$G(HLMSG))
 ;
 D MERGE15^HLTF1("G",HLDA,"HLR",HLTIME)
 ;
 I '$D(HLERR),$D(HLMSA),$D(HLDAI) D
 .N HLAC,HLERR,HLMSG I $P(HLMSA,HLFS,4)]"" S HLERR=$P(HLMSA,HLFS,4)
 .S HLAC=$P(HLMSA,HLFS,2) I HLAC'="AA" S HLMSG=$S(HLAC="AR":"Application Reject",1:"Application Error")_" - "_HLERR
 .S HLAC=$S(HLAC'="AA":4,1:3) D STATUS^HLTF0(HLDAI,HLAC,$G(HLMSG))
 Q
 ;
ACK(HLMSA,HLIO,HLDA) ;Process 'ACK' Message Type - Version 1.5 Interface Only
 ; To determine the correct message to link the ACK, HLIO is used.
 ; For an ack from DHCP (original message from remote system) then
 ; HLIO should be "I" so that the correct inbound message is ack-ed. For
 ; an inbound ack (original message outbound from DHCP) HLIO should be
 ; "O". This distinction must be made due to the possible duplicate
 ; message ids from a bi-direction interface.
 ;
 ; Input : MSA - MSA from ACK message.
 ;         HLIO - Either "I" or "O" : See note above.
 ;Output : None
 ;
 N HLAC,HLMIDI
 ;-- set up required vars
 S HLAC=$P(HLMSA,HLFS,2),HLMIDI=$P(HLMSA,HLFS,3)
 ;-- quit
 Q:HLMIDI']""!(HLAC']"")!('$D(HLNDAP))
 ;-- find message to ack
 I '$G(HLDA) S HLDA=0 D
 . F  S HLDA=+$O(^HL(772,"AH",+$P($G(HLNDAP0),U,12),HLMIDI,HLDA)) Q:'HLDA!($P($G(^HL(772,+HLDA,0)),U,4)=HLIO)
 ;-- quit if no message
 Q:'$D(^HL(772,+HLDA,0))
 ;-- check for error
 I $P(HLMSA,HLFS,4)]"" N HLERR S HLERR=$P(HLMSA,HLFS,4)
 I $D(HLERR),'$D(HLMSG) N HLMSG S HLMSG="Error During Receipt of Acknowledgement Message"_$S(HLAC="AR":" - Application Reject",HLAC="AE":" - Application Error",1:"")_" - "_HLERR
 ;-- update status
 S HLAC=$S(HLMTN="MCF":2,HLAC'="AA":4,1:3)
 D STATUS^HLTF0(HLDA,HLAC,$G(HLMSG))
 Q
 ;
STUB772(FLD01,OS) ;
 ;This function creates a new stub record in file 772. The Stub record may consist of only the 0 node with a value of "^". If a value is passed in for the .01 field it will be included in the 0 node and its "B" x-ref set.
 ;Inputs:
 ;  OS (optional), the value of ^%ZOSF("OS")
 ;  FLD01 (optional), the value for the .01 field
 ;Output - the function returns the ien of the newly created record
 ;
 N IEN
 I '$L($G(OS)) N OS S OS=$G(^%ZOSF("OS"))
 ;
 ; patch HL*1.6*120, protect Else command
 ; I OS'["DSM",OS'["OpenM" D
 I OS'["DSM",OS'["OpenM" D  I 1
 .F  L +^HLCS(869.3,1,772):10 S IEN=+$G(^HLCS(869.3,1,772))+1,^HLCS(869.3,1,772)=IEN S:$D(^HL(772,IEN)) IEN=0,^HLCS(869.3,1,772)=($O(^HL(772,":"),-1)\1) L -^HLCS(869.3,1,772) Q:IEN
 E  D
 .F  S IEN=$I(^HLCS(869.3,1,772),1) S:$D(^HL(772,IEN)) IEN=0,^HLCS(869.3,1,772)=($O(^HL(772,":"),-1)\1) Q:IEN
 S ^HL(772,IEN,0)=$G(FLD01)_"^"
 I $L($G(FLD01)) S ^HL(772,"B",FLD01,IEN)=""
 Q IEN
 ;
STUB773(FLD01,OS) ;
 ;This function creates a new stub record in file 772. The Stub record may consist of only the 0 node with a value of "^". If a value is passed in for the .01 field it will be included in the 0 node and its "B" x-ref set.
 ;Inputs:
 ;  OS (optional), the value of ^%ZOSF("OS")
 ;  FLD01 (optional), the value for the .01 field
 ;Output - the function returns the ien of the newly created record
 ;
 N IEN
 I '$L($G(OS)) N OS S OS=$G(^%ZOSF("OS"))
 ;
 ; patch HL*1.6*120, protect Else command
 ; I OS'["DSM",OS'["OpenM" D
 I OS'["DSM",OS'["OpenM" D  I 1
 .F  L +^HLCS(869.3,1,773):10 S IEN=+$G(^HLCS(869.3,1,773))+1,^HLCS(869.3,1,773)=IEN S:$D(^HLMA(IEN)) IEN=0,^HLCS(869.3,1,773)=($O(^HLMA(":"),-1)\1) L -^HLCS(869.3,1,773) Q:IEN
 E  D
 .F  S IEN=$I(^HLCS(869.3,1,773),1) S:$D(^HLMA(IEN)) IEN=0,^HLCS(869.3,1,773)=($O(^HLMA(":"),-1)\1) Q:IEN
 S ^HLMA(IEN,0)=$G(FLD01)_"^"
 I $L($G(FLD01)) S ^HLMA("B",FLD01,IEN)=""
 Q IEN
