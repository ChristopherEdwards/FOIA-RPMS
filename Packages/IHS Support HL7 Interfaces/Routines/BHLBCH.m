BHLBCH ; IHS/TUCSON/DCP - HL7 ORU Message Processor ; 
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 ;
 ;------------------------------------------------------------
 ; This routine processes HL7 ORU messages and files the data
 ; into RPMS/PCC.  It does not produce any output variables.
 ;
 ; This routine requires the input variables listed below.
 ; These variables are supplied by the HL7 package, based
 ; on the incoming message that it was processing when it
 ; branched to this routine via the protocol file.
 ;
 ;  HLMTIEN    = The IEN in the MESSAGE TEXT FILE (#772)
 ;               for the message being processed.
 ;
 ;  HL("FS")   = HL7 field separator character for the
 ;               incoming message.
 ;
 ;  HL("ECH")  = HL7 encoding characters for the incoming
 ;               message.
 ;
 ;
START ; ENTRY POINT from HL7 protocol
 ;
 D INIT
 F  X HLNEXT Q:'HLQUIT  S BHLSEG=$P(HLNODE,BHLFS,1) I BHLSEG'="",$T(@BHLSEG)'="" S BHLDATA=$P(HLNODE,BHLFS,2,$L(HLNODE,BHLFS)) D @BHLSEG
 D FILING
 Q
 ;-------------------------------------------------------------
MSH ;
 S BHLBCH("MSH")=""
 S BHLDATA=BHLFS_BHLDATA   ; make piece numbers match HL7 field numbers
 S $P(BHLBCH("DEMO"),U,8)=$P(BHLDATA,BHLFS,6)     ; receiving facility
 S $P(BHLBCH("TRANS"),U,3)=$P(BHLDATA,BHLFS,3)    ; sending application
 Q
 ;
PID ;
 S BHLBCH("PID")=""
 I $P(BHLDATA,BHLFS,7)?1."0" S $P(BHLDATA,BHLFS,7)=""
 ;
 S $P(BHLBCH("DEMO"),U,1)=$$FMNAME^HLFNC($P(BHLDATA,BHLFS,5),HLECH) ; name
 S $P(BHLBCH("DEMO"),U,7)=$P($P(BHLDATA,BHLFS,3),BHLCS)           ; chart number (HRN)
 S $P(BHLBCH("DEMO"),U,2)=$$FMDATE^HLFNC($P(BHLDATA,BHLFS,7))     ; dob
 S $P(BHLBCH("DEMO"),U,3)=$P(BHLDATA,BHLFS,8)                     ; sex
 S $P(BHLBCH("DEMO"),U,4)=$P(BHLDATA,BHLFS,19)                    ; ssn
 S $P(BHLBCH("DEMO"),U,5)=$P(BHLDATA,BHLFS,22)                    ; tribe [ethnic group]
 S $P(BHLBCH("DEMO"),U,9)=$TR($P($P(BHLDATA,BHLFS,11),BHLCS,1,7),BHLCS," ") ; translate address delimiters from component separator to space
 Q
 ;
OBR ;
 S BHLBCH("OBR")=""
 S BHLBCH("OBR CNT")=BHLBCH("OBR CNT")+1
 I $P(BHLDATA,BHLFS,4)["99CHRSVC" D
 . S $P(BHLBCH("POV",BHLBCH("OBR CNT")),U,2)=$P($P(BHLDATA,BHLFS,4),BHLCS,4) ;SVCCODE
 . S $P(BHLBCH("POV",BHLBCH("OBR CNT")),U,3)=$P(BHLDATA,BHLFS,20)      ;SVCMIN
 . S $P(BHLBCH("POV",BHLBCH("OBR CNT")),U,5)=$P(BHLDATA,BHLFS,21)      ;SUBSTANC
 . Q:$D(BHLBCH("REC"))
 . S $P(BHLBCH("REC"),U,1)=$$FMDATE^HLFNC($P(BHLDATA,BHLFS,7))         ; SVCDATE [observation date / service date]
 . S $P(BHLBCH("REC"),U,3)=$$STRIP^XLFSTR($P(BHLDATA,BHLFS,31)," ")    ; PROVIDER (note: this should be in Field 32)
 . Q
 Q
 ;
OBX ;
 S BHLBCH("OBX")=""
 I $P(BHLDATA,BHLFS,3)["99CHRSVC" D
 . S $P(BHLBCH("POV",BHLBCH("OBR CNT")),U,4)=$P(BHLDATA,BHLFS,5)       ; NARRATV
 . Q
 ;
 I $P(BHLDATA,BHLFS,3)["99CHRHAC" D
 . S $P(BHLBCH("POV",BHLBCH("OBR CNT")),U,1)=$P($P(BHLDATA,BHLFS,3),BHLCS,4) ;HAC
 . Q
 ;
 I $P(BHLDATA,BHLFS,3)["99CHRTM" D
 . S BHLBCH("OBX CNT")=BHLBCH("OBX CNT")+1
 . N TYPE,VALUE
 . S TYPE=$P($P(BHLDATA,BHLFS,3),BHLCS,4)
 . S VALUE=$P(BHLDATA,BHLFS,5)
 . S:VALUE["99CHRFPM" VALUE=$P(VALUE,BHLCS,4)
 . I TYPE="LMP" S VALUE=$$FMDATE^HLFNC(VALUE) N Y S Y=VALUE X ^DD("DD") S VALUE=Y
 . S BHLBCH("MSR",BHLBCH("OBX CNT"))=TYPE_U_VALUE
 . Q
 ;
 Q
 ;
Z01 ;
 S BHLBCH("Z01")=""
 S $P(BHLBCH("DEMO"),U,6)=$P($P(BHLDATA,BHLFS,1),BHLCS,4)     ;COMRES
 S $P(BHLBCH("REC"),U,2)=$P($P(BHLDATA,BHLFS,2),BHLCS,4)      ;PROGRAM
 S $P(BHLBCH("REC"),U,4)=$P($P(BHLDATA,BHLFS,3),BHLCS,4)      ;ACTLOC
 S $P(BHLBCH("REC"),U,12)=$P(BHLDATA,BHLFS,4)                 ;LOCENC
 S $P(BHLBCH("REC"),U,6)=$P($P(BHLDATA,BHLFS,5),BHLCS,4)      ;REFBY
 S $P(BHLBCH("REC"),U,5)=$P($P(BHLDATA,BHLFS,6),BHLCS,4)      ;REFTO
 S $P(BHLBCH("REC"),U,7)=$P(BHLDATA,BHLFS,7)                  ;EVAL
 S $P(BHLBCH("REC"),U,8)=$P(BHLDATA,BHLFS,8)                  ;TRAVEL
 S $P(BHLBCH("REC"),U,9)=$P(BHLDATA,BHLFS,9)                  ;NUMBER
 S $P(BHLBCH("TRANS"),U,2)=$P($P(BHLDATA,BHLFS,10),BHLCS,1)   ;RECORD
 S $P(BHLBCH("TRANS"),U,1)=$P($P(BHLDATA,BHLFS,10),BHLCS,2)   ;RECTYPE
 S $P(BHLBCH("REC"),U,10)=$P(BHLDATA,BHLFS,11)                ;INSURER
 Q
 ;
FILING ;
 ; N SEG F SEG="PID","OBR","OBX","Z01" I '$D(BHLBCH(SEG)) S BHLERR=$S(BHLERR="":"",1:",")_SEG
 ; I BHLERR'="" S BHLQUIT=1,HLERR="MISSING MESSAGE SEGMENT(S): "_BHLERR D EOJ^BHLBCH1 Q
 D START^BHLBCH1
 Q
INIT ;
 K BHLBCH,BHLFS,BHLCS
 S BHLERR="",(BHLQUIT,BHLR)=0
 S HLECH=HL("ECH")
 S BHLFS=HL("FS"),BHLCS=$E(HLECH,1) ; field and component separators extracted fm message
 S HLQUIT=0
 S BHLBCH("OBR CNT")=0,BHLBCH("OBX CNT")=0
 S HLNEXT="S HLQUIT=$O(^HL(772,HLMTIEN,""IN"",HLQUIT)) S:HLQUIT HLNODE=$G(^(HLQUIT,0))"
 Q
DEBUG ; EP - PROGRAMMER DEBUGGING
 D:'$G(DUZ(0)) ^XBKVAR
 S U="^"
 S HL("ECH")="~|\&"
 S HL("FS")="^"
 G START
 Q
