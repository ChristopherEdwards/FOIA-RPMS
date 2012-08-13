INHPSA2 ; FRW ; 18 Aug 1999 09:49:54; Standard post processing for applications
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
POST(INTER,INEXE) ;post-processing logic - called by MESS^INHPSA
 ;
 ;If program logic defined execute and quit
 I $L($G(INEXE)) X INEXE Q
 ;Quit if application is not supported
 Q:'$$APPL(INTER)
 ;Display message
 D MSG(INTER)
 ;Execute post-processing module
 D @INTER
 Q
 ;
 ;
MSG(INTER) ;Display post processing message
 ;
 N I,X
 ;Loop through data (comment lines) for the application
 F I=0:1 S X=$P($T(@INTER+(I+1)),";;",2,999) Q:'$L(X)  D:'I T^INHMG1 W:'I ! D T^INHMG1 W X
 D:I T^INHMG1 W:I !
 ;
 Q
 ;
BPC(INTER,INDAT,INPAR,INBPCPAR) ; Post-processing for all Background Process Control file entries for one interface (INTER)
 ; Input:
 ;   INTER      - (req) interface application to post-process
 ;   INDAT      - (pbr) data array of control file records for application
 ;   INPAR      - (pbr) array of parameters
 ;   INBPCPAR   - (pbr) array of BPC parameters
 ;
 ; Output:
 ;   INERR   - flag - 0 = no errors
 ;                    1 = errors encountered
 ;
 N DA,DIC,X,Y,DIE,DR,INFLDNUM,INNAME,INREC
 S INREC=0
 ; Loop thru BPC entries associated w/ this INTERface
 F  S INREC=$O(INDAT(INTER,4004,INREC)) Q:'INREC  D
 . S (INNAME,X)=$P($G(INDAT(INTER,4004,INREC)),U,1),DIC=4004,DIC(0)="",Y=$$DIC^INHSYS05(DIC,X,"",DIC(0)),DA=+Y
 . I INNAME'=$P(Y,U,2) D T^INHMG1 W "ERROR: Wanted background process ",INNAME," but found ",$P(Y,U,2)," (",+Y,")." S INERR=1 Q
 . I DA<0 D T^INHMG1 W "ERROR:  Background Process: ",INNAME," not found." S INERR=1 Q
 . Q:'$D(INBPCPAR)
 .; create DR string, looping thru fields in INBPCPAR
 . S (DR,INFLDNUM)=""
 . F  S INFLDNUM=$O(INBPCPAR(INFLDNUM)) Q:'INFLDNUM  D
 .. S:$L(DR) DR=DR_";"  ; NOT 1st time
 .. S DR=DR_INFLDNUM_"///^ S X="_INBPCPAR(INFLDNUM)
 . S DIE=4004 D ^DIE
 . S INFLDNUM=""
 . F  S INFLDNUM=$O(INBPCPAR(INFLDNUM)) Q:'INFLDNUM  D:$D(INBPCPAR(INFLDNUM,"VER"))
 .. X INBPCPAR(INFLDNUM,"VER")
 Q
 ;
APPL(INTER) ;Determine if interface application is supported
 ;
 Q $L($T(@$G(INTER)))
 ;
AP ;Anatomic Pathology
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  ANATOMIC PATHOLOGY RECEIVER and
 ;;  ANATOMIC PATHOLOGY TRANSMITTER background processes.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
 ;
BB ;DBSS
 ;;Remember to enter the CLIENT IP ADDRESS and IP PORT for the
 ;;  DBSS RECEIVER
 ;;  DBSS TRANSMITTER  background processes.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 ;;Also, enter destination identifiers in the ROUTE ID multiple of
 ;;  HL DBSS  interface destination.
 ;;This can be done through the GIS menu. GIS->FTM->DE
 Q
BCC ;BCC
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  BCC TRANSMITTER 1A,
 ;;  BCC TRANSMITTER 1B,
 ;;  BCC QR RECEIVER and
 ;;  BCC QR TRANSMITTER background processes.
 ;;Remember to enter the:
 ;; 1) SERVER IP PORT for the BCC LOGON SERVER background process
 ;; 2) CLIENT IP ADDRESS for the BCC APP SERVER background process
 ;;    (one entry for each PWS remote system).
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
CIW ;CIW
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  CIW RECEIVER and
 ;;  CIW TRANSMITTER background processes.
 ;;Remember to enter the:
 ;; 1) SERVER IP PORT for the CIW LOGON SERVER background process
 ;; 2) CLIENT IP ADDRESS for the CIW APP SERVER background process
 ;;    (one entry for each PWS remote system).
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
CLIN ;Clinicomp
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  CLINICOMP TRANSMITTER background process.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
CRSPL ;Regional Scheduling - Local
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  CRSP RECEIVER 1A and CRSP RECEIVER 1B
 ;;  CRSP TRANSMITTER 1A  CRSP RECEIVER 1B background processes
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 ;;Also, enter destination identifiers in the ROUTE ID multiple and
 ;;the DEFAULT RECEIVING FACILITY field of
 ;;  HL CRSP 1A and HL CRSP 1B  interface destination.
 ;;This can be done through the GIS menu. GIS->FTM->DE
 N INBPCPAR
 S INBPCPAR(.08)=0  ; open as CLIENT
 S INBPCPAR(.08,"VER")="I $P($G(^INTHPC(DA,0)),U,8)'=INBPCPAR(.08) D T^INHMG1 W ""ERROR:  Background Process: ""_INNAME_"" not opened as a 'CLIENT'"" S INERR=1 Q"
 D BPC(INTER,.INDAT,.INPAR,.INBPCPAR)
 Q
CRSPR ;Regional Scheduling - Regional
 ;;Remember to enter the SERVER PORT for the
 ;;following background processes:
 ;;  CRSP TRANSMITTERS 1A and 1B
 ;;  CRSP TRANSMITTERS 2A and 2B
 ;;  CRSP TRANSMITTERS 3A and 3B
 ;;  CRSP RECEIVERS 1A and 1B
 ;;  CRSP RECEIVERS 2A and 2B
 ;;  CRSP RECEIVERS 3A and 3B
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 ;;Also, enter destination identifiers in the ROUTE ID multiple, the
 ;;DEFAULT RECEIVING FACILITY and the PRIMARY DESTINATION fields of
 ;;  HL CRSP 1A
 ;;  HL CRSP 1B
 ;;  HL CRSP 2A
 ;;  HL CRSP 2B
 ;;  HL CRSP 3A
 ;;  HL CRSP 3B  interface destinations.
 ;;This can be done through the GIS menu. GIS->FTM->DE
 N INBPCPAR
 S INBPCPAR(.08)=1  ; open as SERVER
 S INBPCPAR(.08,"VER")="I $P($G(^INTHPC(DA,0)),U,8)'=INBPCPAR(.08) D T^INHMG1 W ""ERROR:  Background Process: ""_INNAME_"" not opened as a 'SERVER'"" S INERR=1 Q"
 D BPC(INTER,.INDAT,.INPAR,.INBPCPAR)
 Q
 ;
DINPACS ;DINPACS
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;; DINPACS TRANSMITTER (and DINPACS TRANSMITTER 2 if needed)
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
HIV ;VIROMED/HIV ABTS RECEIVER
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  HL LA VIROMED/HIV ABTS RECEIVER background process.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
ITS ;Immunization Tracking System EuroCHCS/DEERS
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  HCI ITS TRANSMITTER background process.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
LSI ;LSI
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  LSI INTERFACE RECEIVER and
 ;;  LSI INTERFACE TRANSMITTER  background processes.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
MDIS ;MDIS
 ;
 Q
MHC ;MHCMIS
 ;;Remember to populate the MHCMIS Site Parameters file.
 ;;This can be done through the Site Manager's Menu.  INT->MHC->EDI
 ;;Remember to schedule the XXDMM AUTOTRANSMIT option to send the
 ;;message files to MHCMIS.
 ;
 Q
NMIS ;NMIS
 ;;Remember to enter the CLIENT IP ADDRESS and IP PORT for the
 ;;  NMIS TRANSMITTER background process.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 ;;Also, enter destination identifiers in the ROUTE ID multiple of
 ;;  HL NMIS - OUT  interface destination.
 ;;This can be done through the GIS menu. GIS->FTM->DE
 Q
PDTS ;PDTS
 ;;Remember to enter the CLIENT IP ADDRESS and IP PORT for the 
 ;;  PDTS TRANSCEIVER 1A
 ;;  PDTS TRANSCEIVER 2A background processes.
 ;;Also, enter the DES KEY encryption parameter for each background
 ;;  process.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
PMN ;PACMEDNET
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  PMN RECEIVER and
 ;;  PMN TRANSMITTER background processes.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
PWS ;PWS
 ;;Remember to enter the:
 ;; 1) SERVER IP PORT for the CHCS LOGON SERVER background process
 ;; 2) CLIENT IP ADDRESS for the PWS APP SERVER background process
 ;;    (one entry for each PWS remote system).
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
TSC ;TSC
 ;;Remember to enter the CLIENT ADDRESS and IP PORT for the
 ;;  TSC RECEIVER and
 ;;  TSC TRANSMITTER background processes.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
TSCL ;TSC Loader
 ;;Remember to DEACTIVATE the TSC Loader interface when
 ;;  loading is complete.
 Q
TRAC ;Traces
 ;;Remember to enter the CLIENT IP ADDRESS and IP PORT for the
 ;;  TRACES TRANSMITTER background process.
 ;;This can be done through the GIS menu.  GIS->FTM->BPE
 Q
TEST ;
PROTO ;
 Q
 ;
