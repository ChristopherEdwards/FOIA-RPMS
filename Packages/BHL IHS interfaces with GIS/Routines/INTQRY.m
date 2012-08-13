INTQRY ;DS/SAIC; 21 May 99 15:57; Utilities for GIS query/response
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
UPDTUIF(INTSK,INTSKDT,INUIF) ; Insert the INHF TASK NUMBER and
 ; TASK DATE/TIME into the Univ Interface file.
 ; "AT" xref ^INTHU("AT",INTSK,UIF)="" is created by FileMan
 ;
 ; Input:
 ;       INTSK (req)   = GIS Format Background Controller Task Number
 ;       INTSKDT (req) = date/time task submitted to Format Controller
 ;                       in FileMan format CYYMMDD.HHMMSS
 ;       INUIF (req)   = IEN for the message in Univ. Interface file
 ;
 N DA,DIE,DR
 S INTSK=$G(INTSK),INTSKDT=$G(INTSKDT),INUIF=$G(INUIF)
 Q:'INTSK
 Q:'INTSKDT
 Q:'INUIF
 S DR="4.01////"_INTSK_";"_"4.02////"_INTSKDT,DIE="^INTHU(",DA=INUIF
 D ^DIE
 Q
 ;
SRCH(INTSK,INUIFARY,INSTATUS) ; Search for query responses
 ;
 ; Input:
 ;       INTSK (req) = IEN for a given task number
 ;       INUIFARY    = Passed by ref, this function builds the list of
 ;                     all query responses with their status or if
 ;                     complete, ACK_UIF MESSAGE ID.
 ;                     'E' for ERROR
 ;                     ACK_UIF MESSAGE ID, of the response entry
 ;                           in the Univ Interface File.
 ;       INSTATUS = Passed by ref, if exists, we return
 ;                  the activity status codes with their date/time in
 ;                  the following format:
 ;                  INSTATUS(MSGID,STATUS)=FileMan DATE/TIME
 ; Output:
 ;       zero, if no pending responses
 ;       INACK^INNOACK where INACK is the number of responses received
 ;                           INNOACK is the number of pending responses
 ;
 ;
 N INACK,INACKUIF,INDATA,INDEST,INMSGDIR,INNOACK,INSTAT,INUIFIEN
 ;
 S INTSK=$G(INTSK) Q:'INTSK 0
 K INUIFARY
 ; If no pending query response, return zero
 I '$D(^INTHU("AT",INTSK)) Q 0
 S (INUIFIEN,INNOACK,INACK)=0
 F  S INUIFIEN=$O(^INTHU("AT",INTSK,INUIFIEN)) Q:'INUIFIEN  D
 .;
 .; build an array for all query responses, data level will have the
 .; status if still waiting for a response, otherwise it will contain
 .; the ACK_UIF MESSAGE ID that points back to the reply entry in the
 .; Universal Interface File.
 .;
 . S INDATA=$G(^INTHU(INUIFIEN,0)),INACKUIF=$P(INDATA,U,18),INSTAT=$P(INDATA,U,3)
 . I INSTAT'="C"!('INACKUIF) D  Q
 .. S INNOACK=INNOACK+1,INUIFARY(INUIFIEN)=INSTAT
 .. D STATUS(INUIFIEN,.INSTATUS)
 . S INDEST=+$P(INDATA,U,2)
 . I $P($G(^INRHD(INDEST,0)),U)="HL REPLICATOR" D  Q
 ..; Special processing for replicated messages
 .. N INACT,INACT0,INUIFPTR,INACKUIF
 ..; Loop thru the activity log multiple and get the replicant UIF
 .. S INACT=0 F  S INACT=$O(^INTHU(INUIFIEN,1,INACT)) Q:'INACT  D
 ... S INACT0=$G(^INTHU(INUIFIEN,1,INACT,0)) Q:'$L(INACT0)
 ... Q:$P(INACT0,U,2)'="R"
 ... S INUIFPTR=$P(INACT0,U,3) Q:'INUIFPTR
 ... Q:'$G(^INTHU(INUIFPTR,0))
 ... S INACKUIF=$P(^INTHU(INUIFPTR,0),U,18)
 ... S INUIFARY(INUIFPTR)=$$GETMSGID(INACKUIF),INACK=INACK+1
 ... D STATUS(INUIFIEN,.INSTATUS)
 . S INMSGID=$$GETMSGID(INACKUIF),INUIFARY(INUIFIEN)=INMSGID,INACK=INACK+1
 . D STATUS(INUIFIEN,.INSTATUS)
 Q INACK_"^"_INNOACK
 ;
STATUS(INUIFIEN,INSTATUS) ; return detail activity info in INSTATUS array
 ; in the following format:
 ;
 ; INSTATUS(MESSAGEID,"C") = FileMan Date/Time (Completed)
 ; INSTATUS(MESSAGEID,"S") = FileMan Date/Time (Sent)
 ; INSTATUS(MESSAGEID,"T") = FileMan Date/Time (Format Controller Task)
 ; INSTATUS(MESSAGEID,"SEQUENCE") = Sequence Number
 ;
 N INACT,INACT0,INMSGID,INSEQ,INSTAT
 ;
 K INSTATUS
 S INUIFIEN=$G(INUIFIEN),INMSGID=$$GETMSGID(INUIFIEN) Q:'$L(INMSGID)
 S INSEQ=$P($G(^INTHU(INUIFIEN,0)),U,17)
 I $L(INSEQ) S INSTATUS(INMSGID,"SEQUENCE")=INSEQ
 S INSTATUS(INMSGID,"T")=$P($G(^INTHU(INUIFIEN,4)),U,2)
 ; Loop thru the activity log multiple and get the activity info
 S INACT=0 F  S INACT=$O(^INTHU(INUIFIEN,1,INACT)) Q:'INACT  D
 . S INACT0=$G(^INTHU(INUIFIEN,1,INACT,0)) Q:'$L(INACT0)
 . S INSTAT=$P(INACT0,U,2) Q:'$L(INSTAT)
 . I "AECS"[INSTAT,'$D(INSTATUS(INMSGID,INSTAT)) S INSTATUS(INMSGID,INSTAT)=$P(INACT0,U)
 ;
 Q
 ;
GETMSGID(INUIF) ; Return the message id for a given UIF
 ;
 S INUIF=$G(INUIF) Q:'INUIF ""
 Q $P($G(^INTHU(INUIF,0)),U,5)
 ;
TASKNUM(INSEQ) ; return the task number for a given incoming sequence number
 ;
 ; Input:
 ;       INSEQ (req) = Sequence number of an incoming message
 ; Output:
 ;       Task Number of the original sending message
 ;       NULL, if not successful
 ;
 N INUIF,INUIFR
 S INSEQ=$G(INSEQ)
 Q:'$L(INSEQ) ""
 ; get the UIF entry number for the responding message
 S INUIFR=$O(^INTHU("D",INSEQ,"")) Q:'INUIFR ""
 ; get the UIF entry number of the parent message
 S INUIF=$P($G(^INTHU(INUIFR,0)),U,7) Q:'INUIF ""
 ; return the task number of the sending message
 Q $P($G(^INTHU(INUIF,4)),U)
 ;
