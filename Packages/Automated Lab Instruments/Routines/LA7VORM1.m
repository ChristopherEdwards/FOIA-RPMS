LA7VORM1 ;VA/DALOI/DLR - LAB ORM (Order) message builder ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**27,51,46,61,64,1027**;NOV 01, 1997;Build 9
 ;
BUILD(LA7628) ;
 ; Call with LA7628 = ien of entry in file #62.8 Shipping Manifest
 ;
 N LA7101,LA762801,LA7629,LA7NVAF,LA7PIDSN,LA7X,ECNT,GBL,SHP,SHPC,SITE,ORUID,NTST
 ;
 I $G(LA7628)<1!('$D(^LAHM(62.8,+$G(LA7628),0))) D  Q
 . ; Need to add error logging for manifest not found.
 . D EXIT
 ;
 S GBL="^TMP(""HLS"","_$J_")",ECNT=1
 S LA7628(0)=$G(^LAHM(62.8,LA7628,0))
 S LA7629=$P(LA7628(0),U,2)
 S LA7629(0)=$G(^LAHM(62.9,LA7629,0))
 S LA76248=+$P(LA7629(0),"^",7)
 S LA76248(0)=$G(^LAHM(62.48,LA76248,0))
 I '$P(LA76248(0),"^",3) D EXIT Q  ; not active
 ;
 S LA7V("INST")=$P(LA7629(0),U,11)
 Q:LA7V("INST")=$P(LA7629(0),U,6)  ;Same system shipment
 ;
 S LA7NVAF=$$NVAF^LA7VHLU2(+LA7V("INST")),SITE=""
 I LA7NVAF=0 S SITE=$$GET1^DIQ(4,+$P(LA7629(0),U,11)_",",99)
 I LA7NVAF=1 S SITE=$$ID^XUAF4("DMIS",+$P(LA7629(0),U,11))
 S LA7V("NON")=$P(LA7629(0),U,12)
 I LA7V("NON")'="" S SITE=LA7V("NON")
 ;
 S LA7X=$$NVAF^LA7VHLU2(+$P(LA7629(0),U,2))
 I LA7X=0 S LA7V("CLNT")=$$GET1^DIQ(4,+$P(LA7629(0),U,2)_",",99)
 I LA7X=1 S LA7V("CLNT")=$$ID^XUAF4("DMIS",+$P(LA7629(0),U,2))
 S $P(LA7V("CLNT"),U,2)=$$GET1^DIQ(4,+$P(LA7629(0),U,2)_",",.01)
 ;
 S LA7X=$$NVAF^LA7VHLU2(+$P(LA7629(0),U,3))
 I LA7X=0 S LA7V("HOST")=$$GET1^DIQ(4,+$P(LA7629(0),U,3)_",",99)
 I LA7X=1 S LA7V("HOST")=$$ID^XUAF4("DMIS",+$P(LA7629(0),U,3))
 S $P(LA7V("HOST"),U,2)=$$GET1^DIQ(4,+$P(LA7629(0),U,3)_",",.01)
 ;
 ; Assuming the receiving institution is the primary site (site with the computer system)
 ;
 ; Set flag = 0 (multiple PID's/message - build one message)
 ;            1 (one PID/message - build multiple messages)
 ;            2 (one ORC/message - build multiple messages)
 S LA7SMSG=+$P(LA76248(0),"^",8)
 ;
 ; Sort tests by patient,UID,test - only need to build one PID, PV1 per patient
 ; ^TMP("LA7628",$J, LRDFN, accession UID, ien of shipping manifest specimen entry)
 K ^TMP("LA7628",$J)
 S LA762801=0
 F  S LA762801=$O(^LAHM(62.8,LA7628,10,LA762801)) Q:'LA762801  D
 . S X(0)=$G(^LAHM(62.8,LA7628,10,LA762801,0))
 . I $P(X(0),"^",8)=0 Q  ; Removed from manifest
 . I $G(LA7SMSG)'=3 D  ;cmi/maw for LEDI IHS order
 .. I $P(X(0),"^"),$L($P(X(0),"^",5)) S ^TMP("LA7628",$J,+$P(X(0),"^"),$P(X(0),"^",5),LA762801)=""
 . I $G(LA7SMSG)=3 D  ;cmi/maw for LEDI IHS order
 .. I $P(X(0),"^"),$L($P(X(0),"^",5)) S ^TMP("LA7628",$J,$$GETORDA($P(X(0),"^",5)),$P(X(0),"^",5),LA762801)=""
 .. ;I $P(X(0),"^"),$L($P(X(0),"^",5)) S ^TMP("LA7628",$J,+$P(X(0),"^"),$$GETORDA($P(X(0),"^",5))_"~"_$P(X(0),"^",5),LA762801)=""
 K LA762801
 ;
 ; Nothing to send
 I '$D(^TMP("LA7628",$J)) D EXIT Q
 ;
 ;
 I LA7SMSG=0 D  Q:$G(HL)
 . D STARTMSG
 . I $G(HL) D EXIT
 ;
 ;S (LRDFN,LRI,LA7PIDSN,LA7ORD)=0  ;ihs/cmi/maw 11/17/2010
 S (LRDFN,LRI,LA7PIDSN,LA7ORD,LA7OBRSN)=0  ;ihs/cmi/maw 11/17/2010
 F  S LA7ORD=$O(^TMP("LA7628",$J,LA7ORD)) Q:'LA7ORD  D  Q:$G(HL)
 . N LA7PID,LA7PV1,LA7ORDI,LA7ORDD,LA7ORI
 . I LA7SMSG=1 D STARTMSG Q:$G(HL)
 . S LA7ORDI=$Q(^LRO(69,"C",LA7ORD))
 . I $QS(LA7ORDI,3)'=LA7ORD Q
 . S LA7ORDD=$QS(LA7ORDI,4)
 . S LA7ORI=$QS(LA7ORDI,5)
 . S LRDFN=+$G(^LRO(69,LA7ORDD,1,LA7ORI,0))
 . ;S LA7ORD=$$GETORD(LRDFN)  ;cmi/maw get order number
 . I LA7SMSG<2 D PID,PV1,IN1(LA7ORD),GT1(LA7ORD)  ;cmi/maw for billing info
 . I LA7SMSG=3 D STARTMSG Q:$G(HL)  D PID,PV1,IN1(LA7ORD),GT1(LA7ORD)  ;,INS  ;cmi/maw 5/26/2010 insurance added LEDI order
 . S LA7UID=""
 . S (LA7GUAR,LA7DGQ)=0  ;cmi/maw 5/26/2010 insurance
 . F  S LA7UID=$O(^TMP("LA7628",$J,LA7ORD,LA7UID)) Q:LA7UID=""  D
 . . N LA76802,LA7ORC,X
 . . S X=$Q(^LRO(68,"C",LA7UID))
 . . I $QS(X,3)'=LA7UID Q
 . . S LRAA=$QS(X,4),LRAD=$QS(X,5),LRAN=$QS(X,6)
 . . F I=0,.1,.3,3 S LA76802(I)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,I))  ;cmi/maw 3/10/2010 get .1 node as well
 . . ;F I=0,.3,3 S LA76802(I)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,I))  cmi/maw 3/10/2010 orig line
 . . S I=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,5,0))
 . . S LA76802(5)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,5,I,0))
 . . I LA7SMSG=2 D STARTMSG Q:$G(HL)  D PID,PV1,IN1(LA7ORD),GT1(LA7ORD)  ;,INS  ;cmi/maw 5/26/2010 insurance added
 . . S (LA7OBRSN,LA762801)=0  ;ihs/cmi/maw 11/16/2010 orig line changed back 04/04/2011 to this
 . . ;S LA762801=0  ;ihs/cmi/maw 11/17/2010 mod changed back 04/04/2011
 . . F  S LA762801=$O(^TMP("LA7628",$J,LA7ORD,LA7UID,LA762801)) Q:'LA762801  D
 . . . N LA7OBR,I
 . . . F I=0,.1,1,2,5 S LA762801(I)=$G(^LAHM(62.8,LA7628,10,LA762801,I))
 . . . I $$CHKTST^LA7SMU(LA7628,LA762801)'=0 Q  ;deleted accession
 . . . D ORC,OBR^LA7VORM3,DG1(LA7ORD),OBX(LA7ORD,LA7UID)  ;cmi/maw 06/23/2010 added DG1 segment for LEDI
 . . I LA7SMSG=2 D BLG,SENDMSG
 . I LA7SMSG=3 D BLG,SENDMSG  ;cmi/maw 7/1/2010 for ledi insurance
 . S (LA7DGQ,LA7GUAR)=0  ;cmi/maw 5/26/2010 added for insurance
 . I LA7SMSG<2 D BLG
 . I LA7SMSG=1 D SENDMSG
 ;
 I LA7SMSG=0 D SENDMSG
 ;
 ;ihs/cmi/maw 9/27/10 below is original ledi code
 ;S (LRDFN,LRI,LA7PIDSN)=0
 ;F  S LRDFN=$O(^TMP("LA7628",$J,LRDFN)) Q:'LRDFN  D  Q:$G(HL)
 ;. N LA7PID,LA7PV1
 ;. I LA7SMSG=1 D STARTMSG Q:$G(HL)
 ;. S LA7ORD=$$GETORD(LRDFN)  ;cmi/maw get order number
 ;. I LA7SMSG<2 D PID,PV1,IN1(LA7ORD),GT1(LA7ORD)  ;cmi/maw for billing info
 ;. I LA7SMSG=3 D STARTMSG Q:$G(HL)  D PID,PV1,IN1(LA7ORD),GT1(LA7ORD)  ;,INS  ;cmi/maw 5/26/2010 insurance added LEDI order
 ;. S LA7UID=""
 ;. S (LA7GUAR,LA7DGQ)=0  ;cmi/maw 5/26/2010 insurance
 ;. F  S LA7UID=$O(^TMP("LA7628",$J,LRDFN,LA7UID)) Q:LA7UID=""  D
 ;. . N LA76802,LA7ORC,X
 ;. . S X=$Q(^LRO(68,"C",$P(LA7UID,"~",2)))
 ;. . I $QS(X,3)'=$P(LA7UID,"~",2) Q
 ;. . S LRAA=$QS(X,4),LRAD=$QS(X,5),LRAN=$QS(X,6)
 ;. . F I=0,.1,.3,3 S LA76802(I)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,I))  ;cmi/maw 3/10/2010 get .1 node as well
 ;. . ;F I=0,.3,3 S LA76802(I)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,I))  cmi/maw 3/10/2010 orig line
 ;. . S I=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,5,0))
 ;. . S LA76802(5)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,5,I,0))
 ;. . I LA7SMSG=2 D STARTMSG Q:$G(HL)  D PID,PV1,IN1(LA7ORD),GT1(LA7ORD)  ;,INS  ;cmi/maw 5/26/2010 insurance added
 ;. . S (LA7OBRSN,LA762801)=0
 ;. . F  S LA762801=$O(^TMP("LA7628",$J,LRDFN,LA7UID,LA762801)) Q:'LA762801  D
 ;. . . N LA7OBR,I
 ;. . . F I=0,.1,1,2,5 S LA762801(I)=$G(^LAHM(62.8,LA7628,10,LA762801,I))
 ;. . . I $$CHKTST^LA7SMU(LA7628,LA762801)'=0 Q  ;deleted accession
 ;. . . D ORC,OBR^LA7VORM3,DG1(LA7ORD),OBX^LA7VORM3  ;cmi/maw 06/23/2010 added DG1 segment for LEDI
 ;. . I LA7SMSG=2 D BLG,SENDMSG
 ;. . I LA7SMSG=3 D BLG,SENDMSG  ;cmi/maw 7/1/2010 for ledi insurance
 ;. . S (LA7DGQ,LA7GUAR)=0  ;cmi/maw 5/26/2010 added for insurance
 ;. I LA7SMSG<2 D BLG
 ;. I LA7SMSG=1 D SENDMSG
 ;
 ;I LA7SMSG=0 D SENDMSG
 ;ihs/cmi/maw end of orig ledi code
 ;
EXIT ;
 K @GBL,^TMP("LA7628",$J)
 K DIC,DFN,EID,HL,HLCOMP,HLFS,HLQ,HLSUB,INT
 K LA760,LA7628,LA762801,LA7629
 K LA7ECH,LA7FS,LA7MID,LA7V,LA7HDR,LA7OBRSN,LA7OBXSN,LA7VIEN,LAEVNT
 K LRAA,LRACC,LRAD,LRAN,LRDFN,LRI
 K LTST,NLT,NLTIEN,PCNT,RUID,SNIEN,TIEN,X,Y,LA
 D KVAR^LRX
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
 ;
STARTMSG ; Create/initialize HL message
 ;
 K @GBL
 S (LA76249,LA7PIDSN)=0
 D STARTMSG^LA7VHLU("LA7V Order to "_SITE,.LA76249)
 Q
 ;
 ;
SENDMSG ; File HL7 message with HL and LAB packages.
 ;
 N LA7DATA,LA7ID
 S LA7ID="LA7V HOST "_SITE_"-O-"_$P($G(LA7628(0)),"^")
 ; If no message to send then quit
 I '$D(^TMP("HLS",$J)) D  Q
 . N FDA,LA7ER
 . I $G(LA76248) S FDA(1,62.49,LA76249_",",.5)=LA76248
 . S FDA(1,62.49,LA76249_",",1)="O"
 . S FDA(1,62.49,LA76249_",",2)="E"
 . S FDA(1,62.49,LA76249_",",5)=LA7ID
 . D FILE^DIE("","FDA(1)","LA7ER(1)")
 . D CLEAN^DILF
 . L -^LAHM(62.49,LA76249)
 ;
 D GEN^LA7VHLU
 S LA7DATA="SM06"_"^"_$$NOW^XLFDT
 D SEUP^LA7SMU($P(LA7628(0),"^"),"1",LA7DATA)
 D UPDT6249
 ; Unlock entry
 L -^LAHM(62.49,LA76249)
 Q
 ;
 ;
UPDT6249 ; update entry in 62.49
 ;
 N FDA,LA7ER
 ;
 I $G(LA76248) S FDA(1,62.49,LA76249_",",.5)=LA76248
 S FDA(1,62.49,LA76249_",",1)="O"
 I $P(^LAHM(62.49,LA76249,0),"^",3)'="E" D
 . I $G(HL("APAT"))="AL" S FDA(1,62.49,LA76249_",",2)="A"
 . E  S FDA(1,62.49,LA76249_",",2)="X"
 . I $G(LA7ERR) S FDA(1,62.49,LA76249_",",2)="E"
 S FDA(1,62.49,LA76249_",",5)=LA7ID
 I $G(HL("SAN"))'="" S FDA(1,62.49,LA76249_",",102)=HL("SAN")
 I $G(HL("SAF"))'="" S FDA(1,62.49,LA76249_",",103)=HL("SAF")
 I $G(HL("MTN"))'="" S FDA(1,62.49,LA76249_",",108)=HL("MTN")
 I $G(HL("PID"))'="" S FDA(1,62.49,LA76249_",",110)=HL("PID")
 I $G(HL("VER"))'="" S FDA(1,62.49,LA76249_",",111)=HL("VER")
 I $P($G(LA7MID),"^")'="" S FDA(1,62.49,LA76249_",",109)=$P(LA7MID,"^")
 I $P($G(LA7MID),"^",2) D
 . S FDA(1,62.49,LA76249_",",160)=$P(LA7MID,"^",2)
 . S FDA(1,62.49,LA76249_",",161)=$P(LA7MID,"^",3)
 D FILE^DIE("","FDA(1)","LA7ER(1)")
 D CLEAN^DILF
 Q
 ;
 ;
PID ; Patient identification
 S LRDPF=$P(^LR(LRDFN,0),"^",2),DFN=$P(^(0),"^",3)
 D DEM^LRX
 D PID^LA7VPID(LRDFN,"",.LA7PID,.LA7PIDSN,.HL,"")
 ; DoD/CHCS facilities only use 1st repetition of PID-3.
 I LA7NVAF=1 D
 . S X=$P(LA7PID(0),LA7FS,4),X=$P(X,$E(LA7ECH,2))
 . S $P(LA7PID(0),LA7FS,4)=X
 D FILESEG^LA7VHLU(GBL,.LA7PID)
 D FILE6249^LA7VHLU(LA76249,.LA7PID)
 Q
 ;
 ;
PV1 ; Location information
 ; DoD/CHCS facilities do not use PV1 segment
 I LA7NVAF=1 Q
 ;
 D PV1^LA7VPID(LRDFN,.LA7PV1,LA7FS,LA7ECH)
 D FILESEG^LA7VHLU(GBL,.LA7PV1)
 D FILE6249^LA7VHLU(LA76249,.LA7PV1)
 Q
 ;
 ;
ORC ;Order Control
 ;
 N ORC,LA7DATA,LA7DUR,LA7DURU,LA76205,LA762801,LA7X
 ;
 S ORC(0)="ORC"
 S ORC(1)=$$ORC1^LA7VORC("NW")
 ;
 ; Place order number - accession UID
 ;S ORC(2)=$$ORC2^LA7VORC($P(LA76802(.3),"^"),LA7FS,LA7ECH)
 S ORC(2)=$$ORC2^LA7VORC($P(LA76802(.1),"^"),LA7FS,LA7ECH)
 ;
 ; Placer group number - shipping manifest invoice #
 S ORC(4)=$$ORC4^LA7VORC($P(LA7628(0),"^"),LA7FS,LA7ECH)
 ;
 ; Quantity/Timing
 S (LA76205,LA7DUR,LA7DURU)=""
 S LA762801=0
 ;F  S LA762801=$O(^TMP("LA7628",$J,LRDFN,LA7UID,LA762801)) Q:'LA762801  D  ;ihs/cmi/maw ledi orig
 F  S LA762801=$O(^TMP("LA7628",$J,LA7ORD,LA7UID,LA762801)) Q:'LA762801  D  ;ihs/cmi/maw 09/27/2010 ledi new
 . N I,LA760
 . ; Test duration
 . F I=0,2 S LA762801(I)=$G(^LAHM(62.8,LA7628,10,LA762801,I))
 . I $P(LA762801(2),"^",4) D
 . . S LA7DUR=$P(LA762801(2),"^",6) ; collection duration
 . . S LA7DURU=$P(LA762801(2),"^",7) ; duration units
 . ; Test urgency - find highest urgency on accession
 . S LA760=+$P(LA762801(0),"^",2)
 . S X=+$$GET1^DIQ(68.04,LA760_","_LRAN_","_LRAD_","_LRAA_",",1,"I")
 . I 'LA76205 S LA76205=X
 . I LA76205,X<LA76205 S LA76205=X
 S ORC(7)=$$ORC7^LA7VORC(LA7DUR,LA7DURU,LA76205,LA7FS,LA7ECH)
 ;
 ; Order Date/Time - if no order date/time then try draw time
 I $P(LA76802(0),"^",4) S ORC(9)=$$ORC9^LA7VORC($P(LA76802(0),"^",4))
 I '$P(LA76802(0),"^",4),$P(LA76802(3),"^") S ORC(9)=$$ORC9^LA7VORC($P(LA76802(3),"^"))
 ;
 ; Ordering provider
 S LA7X=$$FNDOLOC^LA7VHLU2(LA7UID)
 S ORC(12)=$$ORC12^LA7VORC($P(LA76802(0),"^",8),$P(LA7X,"^",3),LA7FS,LA7ECH)
 ;
 ; Entering organization - VA facility
 S ORC(17)=$$ORC17^LA7VORC($P($G(LA7629(0)),U,2),LA7FS,LA7ECH)
 ;
 D BUILDSEG^LA7VHLU(.ORC,.LA7DATA,LA7FS)
 D FILESEG^LA7VHLU(GBL,.LA7DATA)
 D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 Q
 ;
GETORD(DF) ;-- get the order number
 N LA7QUID
 S LA7QUID=$O(^TMP("LA7628",$J,DF,0))
 I $G(LA7QUID)="" Q ""
 Q $P(LA7QUID,"~")
 ;
GETORDA(UID) ;-- get the order number
 N X
 S X=$Q(^LRO(68,"C",UID))
 I $QS(X,3)'=UID Q ""
 S LRAA=$QS(X,4),LRAD=$QS(X,5),LRAN=$QS(X,6)
 F I=0,.1,.3,3 S LA76802(I)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,I))  ;cmi/maw 3/10/2010 get .1 node as well
 Q $G(LA76802(.1))
 ;
DG1(ORD) ;-- handle the diagnosis
 Q:$P($$ACCT^LA7VQINS(ORD),U,4)'="T"
 D DG1^LA7VQINS(ORD)
 Q
 ;
GT1(ORD) ;-- handle the guarantor
 Q:$P($$ACCT^LA7VQINS(ORD),U,4)="C"  ;ihs/cmi/maw 11/18/2010 changed to send if T or P
 D GAR^LA7VQINS(DFN,,,1)
 Q
 ;
IN1(ORD) ;-- handle insurance
 ;Q:$P($$ACCT^LA7VQINS(ORD),U,4)'="T"
 K IN1  ;maybe this is hanging around?
 S CNT=0  ;ihs/cmi/maw resets the IN1 segment counter 1/12/2011
 D INS^LA7VQINS(1,ORD)
 Q
 ;
OBX(ORD,UID) ;-- build the obx ask at order questions
 D OBX^LA7VQINS(ORD,UID)  ;ihs/cmi/maw 11/15/2010 - lets put the local ask at order questions in OBX
 Q
BLG ; Billing segment
 ;
 Q  ;cmi/maw 4/14/2010 no BLG segment, will replace with DG1, IN1, and GT1
 N LA7BLG
 ;
 I $P(LA7629(0),U,13)="" Q
 S LA7BLG(0)=$$BLG^LA7VHLU($P(LA7629(0),"^",13),"CO",LA7FS,LA7ECH)
 D FILESEG^LA7VHLU(GBL,.LA7BLG)
 D FILE6249^LA7VHLU(LA76249,.LA7BLG)
 Q
