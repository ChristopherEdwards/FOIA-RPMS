BLRUIIN1 ;cmi/anch/maw - Process Incoming UI Msgs, continued 12/3/1997 ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1027**;NOV 01, 1997
 ;
 ;cmi/maw for UNILAB DIAGNOSTICS INBOUND HL7 MESSAGE
 ;;5.2;LAB MESSAGING;**17,23,27**;Sep 27, 1994
 ;This routine is a continuation of LA7UIIN and is only
 ;called from there.  It is called with each message found
 ;in the incoming queue.
 QUIT
 ;
NXTMSG S (LA7CNT,LA7QUIT)=0
 S (LA7AN,LA7INST,LA7OBR,LA7UID)=""
 S DT=$$DT^XLFDT
 I '$O(^LAHM(62.49,LA76249,150,0)) D  Q  ; Message built but no text.
 . D CREATE^LA7LOG(6)
MSH S LA7MSH=$G(^($O(^LAHM(62.49,LA76249,150,0)),0))
 I $E(LA7MSH,1,3)'="MSH" D  QUIT  ;bad first line of message
 . D CREATE^LA7LOG(7)
 S LA7FS=$E(LA7MSH,4)
 S LA7CS=$E(LA7MSH,5)
 I LA7FS=""!(LA7CS="") D  QUIT  ;no field or component seperator
 . D CREATE^LA7LOG(8)
 S LA762495=0
OBR F  S LA762495=$O(^LAHM(62.49,LA76249,150,LA762495)) Q:'LA762495!($E($G(^(+LA762495,0)),1,3)="OBR")  ;find the OBR segment
 S DT=$$DT^XLFDT
 I 'LA762495,$L($G(LA7OBR)) Q  ; No more OBR's, found at least 1.
 S LA7OBR=$G(^LAHM(62.49,LA76249,150,+LA762495,0))
 I $E(LA7OBR,1,3)'="OBR" D  QUIT  ;should only be working on OBR
 . D CREATE^LA7LOG(9)
 ;S LA7INST=$P($P(LA7OBR,LA7FS,19),LA7CS,1) ; extracting 1st piece
 S LA7INST=$$GET1^DIQ(9009029,DUZ(2),3001)
 I LA7INST="" D  QUIT
 . D CREATE^LA7LOG(10)
 S LA7624=+$O(^LAB(62.4,"B",LA7INST,0))
 I 'LA7624 D  QUIT  ;instrument name not found in xref
 . D CREATE^LA7LOG(11)
 S LA7INST=$G(^LAB(62.4,LA7624,0))
 I LA7INST="" D  QUIT  ;instrument entry not found in file
 . D CREATE^LA7LOG(11)
 S LA7ENTRY=$P(LA7INST,"^",6) ;LOG,LLIST,IDENT or SEQN
 S:LA7ENTRY="" LA7ENTRY="LOG"
 ;
 S LA7TRAY=+$P($P(LA7OBR,LA7FS,20),LA7CS,1) ;Tray
 S LA7CUP=+$P($P(LA7OBR,LA7FS,20),LA7CS,2) ; Cup
 ;S LA7AA=+$P($P(LA7OBR,LA7FS,20),LA7CS,3) ;  Accession Area
 S LA7AA=+$O(^LRO(68,"B","SO",0))         ;  Accession Area
 S LA7AD=$$HDATE^INHUT(+$P(LA7OBR,LA7FS,8)) ;  Accession Date
 S LA7AN=+$P($P(LA7OBR,LA7FS,20),LA7CS,5) ;  Accession Entry
 S LA7ACC=$P(LA7OBR,LA7FS,3) ;  Accession
 ;S LA7ACC=$E(LA7ACC,1,2)_$E(LA7ACC,3,99)
 S LA7UID=LA7ACC  ;unique id
 ;S LA7UID=""  ;LA7ACC ;  Unique ID
 S LA7IDE=$P($P(LA7OBR,LA7FS,20),LA7CS,8) ;  Sequence Number
 S LA7LWL=$P(LA7INST,"^",4) ;  Load/Work List
 ;I LA7LWL="" S LA7LWL="SENDOUTS"  ;maw ref lab
 S LA7OBR3=$P(LA7OBR,LA7FS,3) ; Sample ID or Bar code
 S LA7OBR(15)=$P(LA7OBR,LA7FS,16) ; Specimen source
 I LA7UID="",LA7OBR3?10UN S LA7UID=LA7OBR3 ; UID might come as Sample ID
 ; Try to figure out LRAA LRAD LRAN by using the unique ID (LRUID)
 ; accession may have rolled over, use UID to get current accession info.
 I LA7UID]"" D
 . N X
 . S X=$Q(^LRO(68,"C",LA7UID))
 . I $QS(X,3)'=LA7UID S LA7UID="" Q  ; UID not on file.
 . S LA7AA=+$QS(X,4),LA7AD=+$QS(X,5),LA7AN=+$QS(X,6)
 ;if still not known, compute from default date and accession area
 I '(LA7AA*LA7AD*LA7AN) D
 . N X
 . S DT=$$DT^XLFDT
 . ;S LA7AA=+$P(LA7INST,"^",11)
 . S X=$P($G(^LRO(68,LA7AA,0)),U,3)
 . S LA7AD=$S(X="D":DT,X="M":$E(DT,1,5)_"00",X="Y":$E(DT,1,3)_"0000",X="Q":$E(DT,1,3)_"0000"+(($E(DT,4,5)-1)\3*300+100),1:DT) ; Calculate accession date based on accession transform.
 . S LA7AN=+LA7OBR3
 I LA7ENTRY="LOG",'$D(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,0)) D  ;log but cont
 . D CREATE^LA7LOG(13)
 I LA7ENTRY="LLIST" S:'LA7CUP LA7CUP=LA7IDE ;cup=sequence number
 D LAGEN ;create entry in ^LAH global
 I $G(LA7ISQN)="" D  QUIT  ;couldn't create entry in ^LAH
 . D CREATE^LA7LOG(14)
 S (LA761,LA762,LA70070)="" ; specimen(topography), collection sample, HL7 specimen source
 I $O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,0)) D
 . N X
 . S X=$O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,0))
 . S X(0)=$G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,X,0)) ; specimen^collection sample
 . S LA761=$P(X(0),"^") ; specimen
 . S LA762=$P(X(0),"^",2) ; collection sample
 . I LA761 S LA70070=$$GET1^DIQ(61,LA761_",","LEDI HL7:HL7 ABBR") ;HL7 code from Topography
 I $L(LA70070),$L($P(LA7OBR(15),LA7CS)) D
 . I LA70070=$P(LA7OBR(15),LA7CS) Q  ; Message matches accession
 . D CREATE^LA7LOG(22) ; Log error when specimen source does not match accession segments.
 . S LA7QUIT=1
 I LA7QUIT S LA7QUIT=0 G OBR ; Something wrong, process next OBR
 S LA7AA(0)=$G(^LRO(68,+LA7AA,0)) ; Zeroth node of acession area.
 I $P(LA7AA(0),"^",2)="" G OBR ; No subscript defined for this area.
 I "CH"'[$P(LA7AA(0),"^",2) G OBR ; Processing of this subscript not supported.
 ;I $P(LA7AA(0),"^",2)="MI" D MI^LA7UIIN3 ; Process "MI" subscript results.
 I $P(LA7AA(0),"^",2)="CH" D NTE^BLRUIIN2 ; Process "CH" subscript results - NTE and OBX segments.
 I 'LA762495 Q  ; No more segments to process, reached end of global array.
 S LA762495=LA762495-1 ; Reset subscript variable.
 G OBR ; Go back to find/process additional OBR segments.
 ;
LAGEN ;subroutine to set up vars for call to ^LAGEN,  build entry in LAH
 ;requires LA7INST,LA7TRAY,LA7CUP,LA7AA,LA7AD,LA7AN,LA7LWL
 ;returns LA7ISQN=subscript to store results in ^LAH global
 K TRAY,CUP,LWL,WL,LROVER,METH,LOG,IDENT,ISQN
 K LADT,LAGEN,LA7ISQN
 S LA7ISQN=""
 S TRAY=+$G(LA7TRAY) S:'TRAY TRAY=1
 S CUP=+$G(LA7CUP) S:'CUP CUP=1
 S LWL=LA7LWL  ;maw ref lab
 I '$D(^LRO(68.2,+LWL,0)) D  QUIT
 . D CREATE^LA7LOG(19)
 ; Set accession area to area of specimen, allow multiple areas on same instrument.
 S WL=LA7AA
 I '$D(^LRO(68,+WL,0)) D  QUIT
 . D CREATE^LA7LOG(20)
 S LROVER=$P(LA7INST,"^",12)
 S METH=$P(LA7INST,"^",10)
 S LOG=LA7AN
 S IDENT=$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,0)),"^",6) ;identity field
 S IDE=+LA7IDE
 S LADT=LA7AD
 D @(LA7ENTRY_"^LAGEN") ;this disregards the CROSS LINK field in 62.4
 S LA7ISQN=$G(ISQN)
 Q  ;quit LAGEN subroutine
