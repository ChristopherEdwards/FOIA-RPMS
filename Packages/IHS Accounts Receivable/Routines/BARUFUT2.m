BARUFUT2 ; IHS/SD/TPF - UTILITIES FOR UFMS ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3**;OCT 26, 2005
 Q
 ;
SENDFILE(XBGL,XBFN) ; EP - CREATE FLAT FILE FOR UFMS USING XBGSAVE
 S:$G(XBFN)="" XBFN="UFMS.TST"
 S:$G(XBGL)="" XBGL="BARUFEX("
 S XBQSHO=""
 S XBF=$J                       ; Beginning 1st level numeric subscript
 S XBE=$J                       ; Ending 1st level numeric subscript
 S XBFLT=1                      ; indicates flat file
 S XBMED="F"                    ; Flag indicates file as media
 S XBCON=1                      ; Q if non-cononic
 S XBS1="BAR UFMS F"             ; ZISH SEND PARAMETERS entry
 I $D(ZTQUEUED) S XBS1="BAR UFMS B"
 S XBQ="N"
 S XBUF=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),15)),U)  ;A/R SITE PARAMETER FILE, UFMS DIRECTORY
 I XBUF="" D  Q
 .W !!,"Before UFMS files can be created a non-public directory must be created"
 .W !,"on the Host File System. This directory must be entered in to A/R Site Parameter"
 .W !,"field UFMS DIRECTORY using the 'SPE    Site Parameter Edit' option"
 .D ASKFORRT^BARUFUT
 S XBFLG=0
 ;
 ;S XBS1=""  ;SO IT WON'T FTP ACROSS
 ;
 I XBUF="" D  Q
 . S XBFLG=-1
 . S XBFLG(1)="Missing UFMS storage directory. Please check A/R UFMS Parameters"
 I IO=IO(0) W !!
 ;
 I $$GET1^DIQ(90052.06,DUZ(2)_",",1502,"I") D  Q
 .W !!,"CREATING/SENDING UFMS FILES HAS BEEN TURNED OFF FOR THIS SITE"
 .D ASKFORRT^BARUFUT
 D ^XBGSAVE
 Q
