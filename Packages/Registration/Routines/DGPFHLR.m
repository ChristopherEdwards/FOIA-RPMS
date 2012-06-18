DGPFHLR ;ALB/RPM - PRF HL7 RECEIVE DRIVERS ; 6/17/03 1:38pm
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
RCV ;Receive all message types and route to message specific receiver
 ;
 ;This procedure is the main driver entry point for receiving all
 ;message types (ORU, ACK, QRY and ORF) for patient record flag
 ;assignment sharing.
 ;
 ;All procedures and functions assume that all VistA HL7 environment
 ;variables are properly initialized and will produce a fatal error if
 ;they are missing.
 ;
 ;The received message is copied to a temporary work global for
 ;processing.  The message type is determined from the MSH segment and
 ;a receive processing procedure specific to the message type is called.
 ;(Ex. ORU~R01 message calls procedure: RCVORU).  The specific receive
 ;processing procedure calls a message specific parse procedure to
 ;validate the message data and return data arrays for storage.  If no
 ;parse errors are reported during validation, then the data arrays are
 ;stored by the receive processing procedure.  Control, along with any
 ;parse validation errors, is then passed to the message specific send
 ;processing procedures to build and transmit the acknowledgment and
 ;query results messages.
 ;
 ;  The message specific procedures are as follows:
 ;
 ;  Message   Receive Procedure   Parse Procedure    Send Procedure
 ;  -------   -----------------   ----------------    --------------
 ;  ORU~R01   RCVORU^DGPFHLR      PARSORU^DGPFHLU    SNDACK^DGPFHLS
 ;  ACK~R01   RCVACK^DGPFHLR      PARSACK^DGPFHLU4   N/A
 ;  QRY~R02   RCVQRY^DGPFHLR      PARSQRY^DGPFHLQ3   SNDORF^DGPFHLS
 ;  ORF~R04   RCVORF^DGPFHLR      PARSORF^DGPFHLQ3   N/A
 ;
 N DGCNT
 N DGMSGTYP
 N DGSEG
 N DGSEGCNT
 N DGWRK
 ;
 S DGWRK=$NA(^TMP("DGPFHL7",$J))
 K @DGWRK
 ;
 ;load work global with segments
 F DGSEGCNT=1:1 X HLNEXT Q:HLQUIT'>0  D
 . S DGCNT=0
 . S @DGWRK@(DGSEGCNT,DGCNT)=HLNODE
 . F  S DGCNT=$O(HLNODE(DGCNT)) Q:'DGCNT  D
 . . S @DGWRK@(DGSEGCNT,DGCNT)=HLNODE(DGCNT)
 ;
 ;get message type from "MSH"
 I $$NXTSEG^DGPFHLUT(DGWRK,0,HL("FS"),.DGSEG),$G(DGSEG("TYPE"))="MSH" D
 . S DGMSGTYP=$P(DGSEG(9),$E(HL("ECH"),1),1)
 . ;HLMTIENS is only required by RCVORU and RCVQRY, thus $GET
 . I DGMSGTYP=HL("MTN") D @("RCV"_DGMSGTYP_"(DGWRK,$G(HLMTIENS),.HL)")
 ;
 ;cleanup
 K @DGWRK
 Q
 ;
RCVORU(DGWRK,DGMIEN,DGHL) ;Receive ORU Message Types (ORU~R01)
 ;
 ;  Input:
 ;    DGWRK - name of work global containing segments
 ;   DGMIEN - IEN of message entry in file #773
 ;     DGHL - HL environment array
 ;
 ;  Output:
 ;    none
 ;
 N DGPFA
 N DGPFAH
 N DGSEGERR
 N DGSTOERR
 N DGACKTYP
 ;
 D PARSORU^DGPFHLU(DGWRK,.DGHL,.DGPFA,.DGPFAH,.DGSEGERR)
 ;
 D  ;drop out of block on failure
 . S DGACKTYP="AE"
 . Q:$D(DGSEGERR)
 . Q:'$$STOHL7^DGPFAA2(.DGPFA,.DGPFAH,.DGSTOERR)
 . S DGACKTYP="AA"
 ;
 D SNDACK^DGPFHLS(DGACKTYP,DGMIEN,.DGHL,.DGSEGERR,.DGSTOERR)
 Q
 ;
RCVACK(DGWRK,DGMIEN,DGHL) ;Receive ACK Message Types (ACK~R01)
 ;
 ;  Input:
 ;    DGWRK - name of work global containing segments
 ;   DGMIEN - IEN of message entry in file #773
 ;     DGHL - HL environment array
 ;
 ;  Output:
 ;    none
 ;
 N DGACK   ;ACK data array
 N DGERR   ;error array
 N DGLIEN  ;HL7 transmission log IEN
 N DGPFL   ;HL7 transmssion log data array
 ;
 D PARSACK^DGPFHLU4(DGWRK,.DGHL,.DGACK,.DGERR)
 I +$G(DGACK("MSGID")) D
 . S DGLIEN=$$FNDLOG^DGPFHLL(DGACK("MSGID"))
 . Q:'DGLIEN
 . I $G(DGACK("ACKCODE"))="AA" D
 . . D STOSTAT^DGPFHLL(DGLIEN,"A")
 . E  D
 . . D PROCERR^DGPFHLU5(DGLIEN,.DGACK,.DGERR)
 . . D STOSTAT^DGPFHLL(DGLIEN,"RJ")
 Q
 ;
RCVQRY(DGWRK,DGMIEN,DGHL) ;Receive QRY Message Types (QRY~R02)
 ;
 ;  Input:
 ;    DGWRK - name of work global containing segments
 ;   DGMIEN - IEN of message entry in file #773
 ;     DGHL - HL environment array
 ;
 ;  Output:
 ;    none
 ;
 N DGDFN
 N DGQRY
 N DGQRYERR
 N DGSEGERR
 ;
 D PARSQRY^DGPFHLQ3(DGWRK,.DGHL,.DGQRY,.DGSEGERR)
 S DGDFN=$$GETDFN^DGPFUT2(DGQRY("ICN"),DGQRY("DOB"),DGQRY("SSN"))
 I DGDFN'>0 S DGQRYERR="NM"
 D SNDORF^DGPFHLS(.DGQRY,DGMIEN,.DGHL,DGDFN,.DGSEGERR,.DGQRYERR)
 Q
 ;
RCVORF(DGWRK,DGMIEN,DGHL) ;Receive ORF Message Types (ORF~R04)
 ;
 ;  Input:
 ;    DGWRK - name of work global containing segments
 ;   DGMIEN - IEN of message entry in file #773
 ;     DGHL - HL environment array
 ;
 ;  Output:
 ;    none
 ;
 N DGACTDT   ;activity date ("ASSIGNDT")
 N DGERR     ;parse error array
 N DGORF     ;ORF data array
 N DGPFA     ;assignment data array
 N DGPFAH    ;assignment history data array
 N DGSET     ;OBR set ID
 N DGSTOERR  ;STOHL7 filer errors
 ;
 D PARSORF^DGPFHLQ3(DGWRK,.DGHL,.DGORF,.DGERR)
 ;
 Q:'$D(DGORF)
 Q:(+$G(DGORF("QID"))'>0)
 Q:'$D(^DPT(DGORF("QID"),0))
 ;
 S DGSET=0
 F  S DGSET=$O(DGORF(DGSET)) Q:'DGSET  D
 . N DGAERR  ;assignment filer errors
 . N DGPFA   ;assignment data array
 . ;
 . Q:($G(DGORF(DGSET,"FLAG"))']"")
 . S DGPFA("DFN")=DGORF("QID")
 . S DGPFA("FLAG")=DGORF(DGSET,"FLAG")
 . ;
 . ;set STATUS to null as a placeholder, actual value is determined by
 . ;$$STATUS^DGPFUT call below
 . S DGPFA("STATUS")=""
 . S DGPFA("OWNER")=$G(DGORF(DGSET,"OWNER"))
 . S DGPFA("ORIGSITE")=$G(DGORF(DGSET,"ORIGSITE"))
 . M DGPFA("NARR")=DGORF(DGSET,"NARR")
 . S DGACTDT=0
 . F  S DGACTDT=$O(DGORF(DGSET,DGACTDT)) Q:'DGACTDT  D
 . . N DGAHERR  ;assignment history filer errors
 . . N DGPFAH   ;assignment history data array
 . . ;
 . . S DGPFAH("ASSIGNDT")=DGACTDT
 . . S DGPFAH("ACTION")=$G(DGORF(DGSET,DGACTDT,"ACTION"))
 . . S DGPFAH("ENTERBY")=.5  ;always be POSTMASTER (DUZ=.5)
 . . S DGPFAH("APPRVBY")=.5  ;always be POSTMASTER (DUZ=.5)
 . . M DGPFAH("COMMENT")=DGORF(DGSET,DGACTDT,"COMMENT")
 . . ;
 . . ;calculate the assignment STATUS from the ACTION
 . . S DGPFA("STATUS")=$$STATUS^DGPFUT(DGPFAH("ACTION"))
 . . I $$STOHL7^DGPFAA2(.DGPFA,.DGPFAH,.DGSTOERR)
 Q
