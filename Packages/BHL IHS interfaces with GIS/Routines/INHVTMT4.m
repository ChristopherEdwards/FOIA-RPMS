INHVTMT4 ; KAC ; 06 Aug 1999 16:51; Multi-threaded TCP/IP socket utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
PENDSYNC(INPEND) ; Function - Sync INPEND variable with the reality of 
 ; what is on pending reponse queue.  Provides ability to continue 
 ; where left off in the case of a FORCEX.  Called at start of 
 ; transceiver.
 ;
 ; Called by: INHVTMT
 ;
 ; Returns:
 ;   1 - pending que contained entries on startup
 ;   0 - pending que was empty on startup
 ;
 N X
 S X=0
 F INPEND=0:1 S X=$O(^INLHDEST(INDSTR,"PEND",INBPN,X)) Q:(X="")
 Q $S(INPEND:1,1:0)
 ;
PUTPEND(INDEST,INUIF,INSEQNUM,INPEND) ; Function - Put UIF on "pending 
 ; response" queue.  Used for multi-threaded transceivers. Assumes 
 ; caller locked the node being moved from ^INLHDEST to "pending 
 ; response" queue.
 ;
 ; Called by: NEXT^INHUVUT3
 ;
 ; Input:
 ;  INDEST   - (req) Destination IEN (INDSTR)
 ;  INUIF    - (req) Universal Interface IEN
 ;
 ; Output:  Flag - 1=success, 0=failure
 ;  INSEQNUM - (pbr) Sequence # for this UIF, "" if not found
 ;  INPEND   - (pbr) # of msgs in "pending response" que
 ;
 N INERRMSG
 S INSEQNUM=$P(^INTHU(INUIF,0),U,17)
 I INSEQNUM="" D  Q 0
 . S INERRMSG="Putpend: Missing sequence number in INTHU for entry "_INUIF_": Cannot que msg"
 . D ENT^INHE(INUIF,INDEST,INERRMSG,INBPN)
 . D:$G(INDEBUG) LOG^INHVCRA1(INERRMSG,4)
 . K ^INLHDEST(INDEST,INPRI,INHOR,INUIF) ; avoid re-processing
 D:$G(INDEBUG) LOG^INHVCRA1("Putting UIF="_INUIF_" on pend que",9)
 S ^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM,INUIF)=""
 K ^INLHDEST(INDEST,INPRI,INHOR,INUIF)
 S INPEND=INPEND+1
 Q 1
 ;
GETPEND(INDEST,INSEQNUM,INUIF,INPEND) ; Function - Get UIF from "pending 
 ; response" queue and restore entry on destination queue.  Used 
 ; for multi-threaded transceivers.  If no entry existed on que
 ; entry is still restored to dest que and INPEND will not be updated.
 ;
 ; Called by: INHVTMT, EVAL^INHVTMT3, REROUTE^INHVTMT4
 ;
 ; Input:
 ;  INDEST   - (req) Destination IEN (INDSTR)
 ;  INSEQNUM - (req) Sequence # for this UIF
 ;
 ; Output:  Flag - 1=success, 0=failure
 ;  INUIF    - (pbr) UIF for this sequence #, "" if not found
 ;  INPEND   - (pbr) # of msgs in "pending response" que
 ;
 N INERR,INPRI,INHOR
 Q:'$D(^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM))  ; no que entry
 S INUIF=$O(^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM,""))
 I INUIF="" D  Q 0
 . S INERR="Getpend: Missing UIF IEN in pending queue entry with sequence #: "_INSEQNUM_": Cannot reroute msg"
 . D ENT^INHE(INUIF,INDEST,INERR,INBPN)
 . D:$G(INDEBUG) LOG^INHVCRA1(INERR,4)
 . K ^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM)
 S INPRI=$P(^INTHU(INUIF,0),U,16) ; priority
 S INHOR=$P(^INTHU(INUIF,0),U,19) ; time to process
 I (INPRI="")!(INHOR="") D  Q 0
 . S INERR="Getpend: Missing priority/time in UIF entry "_INUIF_": Cannot reroute msg"
 . D ENT^INHE(INUIF,INDEST,INERR,INBPN)
 . D:$G(INDEBUG) LOG^INHVCRA1(INERR,4)
 . D PQKILL(INDEST,INSEQNUM,INUIF,.INPEND) ; avoid hanging entry
 S ^INLHDEST(INDEST,INPRI,INHOR,INUIF)=""
 ; update INPEND only if que entry exists
 D:$G(INDEBUG) LOG^INHVCRA1("Restoring UIF="_INUIF_" to dest que",9)
 D PQKILL(INDEST,INSEQNUM,INUIF,.INPEND)
 Q 1
 ;
REROUTE(INDEST,INPEND) ; Move ALL entries on "pending response" queue to 
 ; destination queue, effectively rerouting UIF entries to 
 ; another transceiver.
 ;
 ; Called by: INHVTMT, SHUTDWN^INHVTMT5, ERR^INHVTMT5
 ;
 N INSEQNUM,INUIF,X
 D:$G(INDEBUG) LOG^INHVCRA1("Rerouting entire pending que to dest que",9)
 S INSEQNUM=""
 F  S INSEQNUM=$O(^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM))  Q:(INSEQNUM="")  D
 . S X=$$GETPEND(INDEST,INSEQNUM,.INUIF,.INPEND)
 Q
 ;
RESEND(INDEST,INUIF,INSEQNUM) ; Resend INUIF.  If no 'pending que' entry
 ; for INUIF, create a queue entry and update INPEND.
 ;
 ; Called by: INHVTMT, EVAL^INHVTMT3
 ;
 N INATTMPT
 S INATTMPT=$P($G(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM,INUIF)),U,2)+1
 ; Start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD(INUIF,"",INBPNM,"","RESEND")
 D:$G(INDEBUG) LOG^INHVCRA1("Resending outgoing UIF="_INUIF_" on "_INBPNM_". Attempt "_INATTMPT_".",7)
 S INRUNMT=$$INRHB^INHUVUT1(INBPN,"Resending "_INUIF_",Attempt "_INATTMPT) Q:'INRUNMT
 F  S INERRMT=$$SEND^INHVTMT1(INUIF,INCHNL,.INIP) Q:'INERRMT!'$D(^INRHB("RUN",INBPN))
 ; Post-send activities
 D ULOG^INHU(INUIF,"S") ; log activity in UIF - sent
 S:INATTMPT=1 INPEND=INPEND+1 ; pending que entry did not exist upon call
 S ^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM,INUIF)=$H_U_INATTMPT
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)  ;stop transaction audit
 Q
 ;
PQKILL(INDEST,INSEQNUM,INUIF,INPEND) ; Kill entry on "pending response" queue
 ; Used when multiple transceivers are sending msgs to the same 
 ; destination.
 ;
 ; Called by: INHVTMT, EVAL^INHVTMT3
 ;
 Q:'$D(^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM))  ; no que entry
 ; Update INPEND only if que entry exists
 S INPEND=INPEND-1
 K ^INLHDEST(INDEST,"PEND",INBPN,INSEQNUM,INUIF)
 Q
 ;
 ;
