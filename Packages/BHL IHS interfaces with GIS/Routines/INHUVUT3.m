INHUVUT3 ; KAC ; 06 Aug 1999 14:41; Generic TCP/IP socket utilities (continued)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
 ;
NEXT(INDEST,INPRI,INHOR,INPEND) ;Return next transaction in the destination que.
 ; Used for single and multiple transceiver execution off of a single
 ; destination que.
 ;
 ; Called by: INHVTAPT,INHVTMT,INHVMTR
 ;
 ;Input:
 ; INDEST   - (req) INTERFACE DESTINATION IEN
 ; INPRI    - (pbr) Priority (0-10 to single decimal place e.g. 1.5)
 ; INHOR    - (pbr) Time to process ($H format)
 ; INPEND   - (opt) # of msgs in "pending response" que. Req'd for 
 ;                  multi-threaded transceivers (INMLTHRD=1))
 ; INMLTHRD - (opt) flag - 1 = multi-threaded transceiver (INHVTMT)
 ;                         0 = (default) single-threaded transceiver
 ; INBPN    - (req) BACKGROUND PROCESS CONTROL IEN
 ;
 ;Output:
 ; UIF IEN or null if no entry on destination queue
 ;
 N INUIF,INOK,INDT,INTM,INMSG
 S (INPRI,INHOR,INUIF)="",INOK=0,INDT=$H,INTM=$P(INDT,",",2),INDT=$P(INDT,",")
 F  S INPRI=$O(^INLHDEST(INDEST,INPRI)) Q:(+INPRI'=INPRI)  D  Q:INOK
 . S INHOR=""
 . F  S INHOR=$O(^INLHDEST(INDEST,INPRI,INHOR)) Q:(INHOR="")  D  Q:INOK
 .. I (INHOR<INDT)!((+INHOR=INDT)&($P(INHOR,",",2)'>INTM)) D
 ... S INUIF=""
 ... F  S INUIF=$O(^INLHDEST(INDEST,INPRI,INHOR,INUIF)) Q:'INUIF  D  Q:INOK
 .... L +^INLHDEST(INDEST,INPRI,INHOR,INUIF):0 I  D
 ..... I '$D(^INTHU(INUIF)) D  Q
 ......; If entry no longer exists in INTHU, log error & get next UIF
 ...... S INMSG="Missing entry "_INUIF_" in INTHU"
 ...... K ^INLHDEST(INDEST,INPRI,INHOR,INUIF)
 ...... D ENT^INHE(INUIF,INDEST,INMSG,INBPN)
 ...... D:$G(INDEBUG) LOG^INHVCRA1(INMSG,4)
 ...... L -^INLHDEST(INDEST,INPRI,INHOR,INUIF)
 ..... I '$G(INMLTHRD) S INOK=1 Q  ; NOT multi-threaded xceivers
 ..... S:$$PUTPEND^INHVTMT4(INDEST,INUIF,.INSEQNUM,.INPEND) INOK=1
 ..... L -^INLHDEST(INDEST,INPRI,INHOR,INUIF)
 ;
 Q:(INPRI="")!(INHOR="")!(INUIF="")!('INOK) ""
 Q INUIF
 ;
 ;
