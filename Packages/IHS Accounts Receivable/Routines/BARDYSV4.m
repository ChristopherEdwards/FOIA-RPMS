BARDYSV4 ; IHS/SD/MAS,TPF - OMB - DAYS TO COLLECTION ; 02/09/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**12,13,14,16**;OCT 22,2008
 ;
 ; 
 ; IHS/SD/TMM  07/02/2009  M1  Routine ^BARDYSV2 created as a continuation of ^BARDYSVZ 
 ;                             due to large routine size for SAC checker. 
 ; IHS/SD/TMM  10/20/2009  M2  OMB Phase II modifications. (Create/copy from ^BARDYSV2)
 ; IHS/SD/TMM  01/10/2010  M3  Record XBFLG value returned from ^XBGSAVE
 ; IHS/SD/TMM  01/29/2010  M4  Tag TRANS moved from ^BARDYSV3 to ^BARDYSV5 due to 
 ;                             routine size of ^BARDYSV3 and SAC checker requirement
 ; IHS/SD/TMM  01/29/2010  M5  Run install report twice using diff date ranges
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
 ..W !,BARVLOC,U,BARVDA,U,VISITREC
 ..S BARBIL=0
 ..F  S BARBIL=$O(^BAROMB($J,BARVLOC,BARVDA,"BILLREC",BARBIL)) Q:BARBIL=""  D
 ...S BILLREC=^BAROMB($J,BARVLOC,BARVDA,"BILLREC",BARBIL)
 ...W !,BARVLOC,U,BARVDA,U,BILLREC
 ...S TRANDT=0
 ...F  S BARBIL=$O(^BAROMB($J,BARVLOC,BARVDA,"TRANS REC",TRANDT)) Q:TRANDT=""  D
 ....S TRANREC=^BAROMB($J,BARVLOC,BARVDA,"TRANS REC",TRANDT)
 ....W !,BARVLOC,U,BARVDA,U,TRANREC
 Q
 ;
ASKFNAME(BARFILE,BEGDATE,ENDDATE) ;EP - ASK FOR FILENAME (COPIED FROM BARUFUT1)
 S BARFILE=$$GETFILNM(BEGDATE,ENDDATE)
 W !!,"File will be created using the following name: ",BARFILE
 Q 1
 ;
GETFILNM(BEGDATE,ENDDATE) ;EP - CREATE FILE NAME  (COPIED FROM BARUFUT1)
 N FNROOT,FNEXT,FN,YR,DATE,TIME,DATETIME,BARPK,BARPT,BARP2,BARP3,DATERANG
 S FNROOT="IHS_AR_OMB_"_DUZ_"_"_$$GETSUFAC()
 S FNXREF=DUZ_"_"_$$GETSUFAC()
 S BARV=$$VERSION^XPDUTL("BAR")
 S BARP2=$$FILLSTR^BARUFUT1($P(BARV,".",2),2,"R","0")
 S BARPK=$O(^DIC(9.4,"C","BAR",0))
 S BARPK="IHS ACCOUNTS RECEIVABLE"
 S BARPT=$$LAST^XPDUTL(BARPK,BARV)
 S BARP3=$$FILLSTR^BARUFUT1(+BARPT,2,"R","0")
 S FNXT=$P(BARV,".",1)_"."_BARP2_"."_BARP3
 S FNEXT="_"_FNXT_".DAT"
 S FN=FNROOT
GETFILAG ;CHECK FOR FILE NAME ALREADY USED  (COPIED FROM BARUFUT1)
 D NOW^%DTC
 S YR=1700+$E(%,1,3)
 S DATE=YR_$E(%,4,7)
 S Y=% X ^DD("DD")
 S TIME=$TR($P(Y,"@",2),":")
 S:$L(TIME)=4 TIME=TIME_"00"
 S DATETIME=DATE_"_"_TIME
 S DATERANG="-"_BEGDATE_"-"_ENDDATE_"-"
 S FN=FNROOT_"_"_DATETIME_DATERANG
 S FN=FN_FNEXT
 Q FN
 ;
GETSUFAC() ;EP;GIVEN DUZ(2)  (COPIED FROM BARUFUT1)
 ;   get parent from parent/satellite file
 N BARSAT,BARPAR,DA,ASUFAC
 S BARSAT=DUZ(2)
 S BARPAR=0                               ; Parent
 ; check site active at DOS to ensure bill added to correct site
 S DA=0
 F  S DA=$O(^BAR(90052.06,DA)) Q:DA'>0  D  Q:BARPAR
 . Q:'$D(^BAR(90052.06,DA,DA))  ; Pos Parent UNDEF Site Parameter
 . Q:'$D(^BAR(90052.05,DA,BARSAT))  ; Satellite UNDEF Parent/Satellit
 . Q:+$P($G(^BAR(90052.05,DA,BARSAT,0)),U,5)  ; Par/Sat not usable
 . ; Q if sat NOT active at DT
 . I DT<$P($G(^BAR(90052.05,DA,BARSAT,0)),U,6) Q
 . ; Q if sat became NOT active before DT
 . I $P($G(^BAR(90052.05,DA,BARSAT,0)),U,7),(DT>$P($G(^BAR(90052.05,DA,BARSAT,0)),U,7)) Q
 . S BARPAR=$S(BARSAT:$P($G(^BAR(90052.05,DA,BARSAT,0)),U,3),1:"")
 S ASUFAC=$$CURASUFC(BARPAR,DT)
 Q ASUFAC
 ;
CURASUFC(LOCIEN,BARDOS) ;EP - GET CURRENT ASUFAC BASED ON 'DOS BEGIN' (#102) IN A/R BILL FILE (COPIED FROM BARUFUT1)
 Q:LOCIEN="" "UNPOPL"
 Q:BARDOS="" "UNPOPD"
 N ASUFAC,BARDT,BARDTFLG
 S ASUFAC=""
 S BARDT=0
 S BARDTFLG=0
 S ASUFAC=$$GET1^DIQ(9999999.06,DUZ(2)_",",.12)  ;First take it from 'asufac index" field
 ;if not, check class multiple
 I 'ASUFAC D
 .F  S BARDT=$O(^AUTTLOC(LOCIEN,11,BARDT)) Q:BARDT=""!(BARDTFLG=1)  D
 ..I BARDOS>$P($G(^AUTTLOC(LOCIEN,11,BARDT,0)),U) D
 ...S ASUFAC=$P($G(^AUTTLOC(LOCIEN,11,BARDT,0)),U,6)
 ...S BARDTFLG=1
 ;S:ASUFAC="" ASUFAC=$$GET1^DIQ(9999999.06,DUZ(2)_",",.12)
 Q ASUFAC
 ;
INSTALL ;EP - Run two times using different date range when BAR*1.8*16 installed ;M5*ADD*TMM
 S BEGDATE=3081001                ;M5*ADD*TMM
 S ENDDATE=3090930                ;M5*ADD*TMM
 D INST                           ;M5*ADD*TMM
 S BEGDATE=3091001                ;M5*ADD*TMM
 S ENDDATE=3100131                ;M5*ADD*TMM
 D INST                           ;M5*ADD*TMM
 Q
 ;
INST ;EP - Run once when patch installed BAR*1.8*14         ;M5*ADD*TMM
 ;INSTALL ;EP - Run once when patch installed BAR*1.8*14    ;M5*DEL*TMM
 I '$$IHS^BARDYSV3(DUZ(2)) Q        ;***Should this be installed at non-IHS facilities?
 D INIT^BARDYSV3
 ;S BEGDATE=3081001               ;M5*DEL*TMM
 ;S ENDDATE=3090930               ;M5*DEL*TMM
 D NOW^%DTC
 S ^BARTMP("BARDYSV3",0,"INSTALL STARTED",DUZ(2),%)=BEGDATE_U_ENDDATE
 D VISITS^BARDYSV5(BEGDATE,ENDDATE)
 D BILLS^BARDYSV3(BEGDATE,ENDDATE)                            ;M2
 ;D TRANS^BARDYSV3(BEGDATE,ENDDATE)                           ;M2  ;M4*DEL*TMM
 D TRANS^BARDYSV5(BEGDATE,ENDDATE)                            ;M2  ;M4*ADD*TMM
 S ^BARTMP("BARDYSV3",0,"INSTALL COMPLETED",DUZ(2),%)="OMB PHASE II - Data Extracted, Ready to send"
 S RC=$$ASKFNAME(.BARFILE,BEGDATE,ENDDATE)
 D SENDFILE("BAROMB(",BARFILE)               ;M1 BAR*1.8*13 TMM 
 D NOW^%DTC
 ;I $G(XBFLG)'=0 S ^BARTMP("BARDYSV3",0,"INTERACT COMPLETED",DUZ(2),%,1)="Global copy of ^BAROMB Failed"_"^"_$G(XBFLG(1))   ;M2 ;M3*DEL*TMM
 ;I $G(XBFLG)=-1 S ^BARTMP("BARDYSV3",0,"INTERACT COMPLETED",DUZ(2),%,2)=$G(XBFLG(1))                                    ;M2 ;M3*DEL*TMM
 ;I $G(XBFLG)=0 S ^BARTMP("BARDYSV3",0,"INTERACT COMPLETE",DUZ(2),%,3)="Global copy ^BAROMB successful"                     ;M2 ;M3*DEL*TMM
 I $G(XBFLG)'=0 S ^BARTMP("BARDYSV3",0,"INSTALL COMPLETED",DUZ(2),%,1)="Global copy of ^BAROMB Failed"_"^"_XBFLG_"^"_$G(XBFLG(1))   ;M2  ;M3*ADD*TMM
 I $G(XBFLG)=-1 S ^BARTMP("BARDYSV3",0,"INSTALL COMPLETED",DUZ(2),%,2)=$G(XBFLG)_"^"_$G(XBFLG(1))                                   ;M2  ;M3*ADD*TMM
 I $G(XBFLG)=0 S ^BARTMP("BARDYSV3",0,"INSTALL COMPLETE",DUZ(2),%,3)="Global copy ^BAROMB successful"                               ;M2  ;M3*ADD*TMM
 Q
