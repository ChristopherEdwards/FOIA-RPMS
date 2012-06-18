BARDYSV2 ; IHS/SD/MAS,TPF - OMB - DAYS TO COLLECTION REPORT FOR SQL ; 02/09/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**12,13**;JULY 2,2009
 ;
 ; 
 ; IHS/SD/TMM  07/02/09  
 ; Routine ^BARDYSV2 created as a continuation of ^BARDYSVZ due to 
 ; large routine size for SAC checker.  
 ; 
 Q
 ;
SENDFILE(XBGL,XBFN) ; EP - CREATE FLAT FILE FOR UFMS USING XBGSAVE
 S:$G(XBFN)="" XBFN="OMB.TST"
 S:$G(XBGL)="" XBGL="BAROMB("  ;TEMP FILE KILLED AFTER FTP SEND. CAN'T USE ^XTMP($J
 S XBQSHO=""
 S XBF=$J                       ; Beginning 1st level numeric subscript
 S XBE=$J                       ; Ending 1st level numeric subscript
 S XBFLT=1                      ; indicates flat file
 S XBMED="F"                    ; Flag indicates file as media
 S XBCON=1                      ; Q if non-cononic
 S XBS1="BAR OMB F"             ; ZISH SEND PARAMETERS entry
 I $D(ZTQUEUED) S XBS1="BAR OMB B"
 S XBQ="N"
 S XBUF=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),16)),U)  ;A/R SITE PARAMETER FILE, OMB DIRECTORY
 I XBUF="" D  Q
 .W !!,"Before OMB files can be created a non-public directory must be created"
 .W !,"on the Host File System. This directory must be entered in to A/R Site Parameter"
 .W !,"field OMB DIRECTORY using the 'SPE    Site Parameter Edit' option"
 .D ASKFORRT^BARUFUT
 S XBFLG=0
 ;
 ;S XBS1=""  ;IF SET TO "" IT WON'T FTP ACROSS
 ;
 I XBUF="" D  Q
 . S XBFLG=-1
 . S XBFLG(1)="Missing OMB REPORT storage directory. Please check A/R OMB Parameters"
 I IO=IO(0) W !!
 ;
 D ^XBGSAVE
 Q
 ;
WRITE ;TEMP WRITE WHILE TESTING
 N BARVLOC,BARVDA,BARBIL,VISITREC,BILLREC,TRANDT,TRANREC
 S BARVLOC=0
 F  S BARVLOC=$O(^BAROMB($J,BARVLOC)) Q:'BARVLOC  D
 .S BARVDA=0
 .F  S BARVDA=$O(^BAROMB($J,BARVLOC,BARVDA)) Q:'BARVDA  D
 ..S VISITREC=^BAROMB($J,BARVLOC,BARVDA,"A VISITREC")
 ..;W !,BARVLOC,U,BARVDA,U,"A",U,VISITREC
 ..W !,BARVLOC,U,BARVDA,U,VISITREC
 ..S BARBIL=0
 ..F  S BARBIL=$O(^BAROMB($J,BARVLOC,BARVDA,"BILLREC",BARBIL)) Q:BARBIL=""  D
 ...S BILLREC=^BAROMB($J,BARVLOC,BARVDA,"BILLREC",BARBIL)
 ...;W !,BARVLOC,U,BARVDA,U,"B",U,BILLREC
 ...W !,BARVLOC,U,BARVDA,U,BILLREC
 ...S TRANDT=0
 ...F  S BARBIL=$O(^BAROMB($J,BARVLOC,BARVDA,"TRANS REC",TRANDT)) Q:TRANDT=""  D
 ....S TRANREC=^BAROMB($J,BARVLOC,BARVDA,"TRANS REC",TRANDT)
 ....W !,BARVLOC,U,BARVDA,U,TRANREC
 Q
