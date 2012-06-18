DGPFHLS ;ALB/RPM - PRF HL7 SEND DRIVERS ; 5/13/03 3:20pm
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
SNDORU(DGPFIEN,DGPFHIEN,DGFAC) ;Send ORU Message Types (ORU~R01)
 ;This function builds and transmits a single ORU message to all sites
 ;in the associated patient's TREATING FACILITY LIST (#391.91) file.
 ;The optional input parameter DGFAC overrides selection of sites
 ;from the TREATING FACILITY LIST file.
 ;
 ;  Supported DBIA #2990:  This supported DBIA is used to access the
 ;                         Registration API to generate a list of
 ;                         treating facilities for a given patient.
 ;  Input:
 ;    DGPFIEN - (required) IEN of assignment in PRF ASSIGNMENT (#26.13)
 ;                         file to transmit
 ;   DGPFHIEN - (optional) IEN of assignment history in PRF ASSIGNMENT
 ;                         HISTORY (#26.14) file to include in ORU.
 ;                         [default = $$GETLAST^DGPFAAH(DGPFIEN)]
 ;      DGFAC - (optional) array of message destination facilities
 ;                         passed by reference
 ;                         format:  DGFAC(#)=station#
 ;
 ;  Output:
 ;   Function value - 1 on success, 0 on failure
 ;
 N HLEID     ;event protocol ID
 N DGHL      ;VistA HL7 environment array
 N DGHLROOT  ;message array location
 N DGPFA     ;assignment data array
 N DGPFAH    ;assignment history data array
 N DGRSLT    ;function value
 ;
 S DGRSLT=0
 S DGHLROOT=$NA(^TMP("PRFORU",$J))
 K @DGHLROOT
 ;
 I $$ORUON^DGPFPARM(),+$G(DGPFIEN)>0,$D(^DGPF(26.13,DGPFIEN)) D
 . ;
 . ;retrieve assignment record
 . Q:'$$GETASGN^DGPFAA(DGPFIEN,.DGPFA)
 . ;
 . ;retrieve assignment history record
 . S DGPFHIEN=$S($G(DGPFHIEN)>0:DGPFHIEN,1:$$GETLAST^DGPFAAH(DGPFIEN))
 . Q:'$$GETHIST^DGPFAAH(DGPFHIEN,.DGPFAH)
 . ;
 . ;initialize VistA HL7 environment
 . S HLEID=$$INIT^DGPFHLUT("DGPF PRF ORU/R01 EVENT",.DGHL)
 . Q:'HLEID
 . ;
 . ;build ORU segments array
 . Q:'$$BLDORU^DGPFHLU(.DGPFA,.DGPFAH,.DGHL,DGHLROOT)
 . ;
 . ;retrieve treating facilities when no destination is provided
 . I '$D(DGFAC) D TFL^VAFCTFU1(.DGFAC,+$G(DGPFA("DFN")))
 . Q:'$D(DGFAC)
 . ;
 . ;transmit and log messages
 . Q:'$$XMIT^DGPFHLU6(DGPFHIEN,HLEID,.DGFAC,DGHLROOT,.DGHL)
 . ;
 . ;success
 . S DGRSLT=1
 ;
 ;cleanup
 K @DGHLROOT
 Q DGRSLT
 ;
SNDACK(DGACKTYP,DGMIEN,DGHL,DGSEGERR,DGSTOERR) ;Send ACK Message Type (ACK~R01)
 ;This procedure assumes the the VistA HL7 environment is providing the
 ;environment variables and will produce a fatal error if they are
 ;missing.
 ;
 ;  Input:
 ;    DGACKTYP - (required) ACK message type ("AA","AE")
 ;      DGMIEN - (required) IEN of message entry in file #773
 ;        DGHL - (required) HL7 environment array
 ;    DGSEGERR - (optional) Errors found during parsing
 ;    DGSTOERR - (optional) Errors during data storage
 ;
 ;  Output:
 ;    none
 ;
 N DGHLROOT
 N DGHLERR
 ;
 Q:($G(DGACKTYP)']"")
 Q:('+$G(DGMIEN))
 ;
 S DGHLROOT=$NA(^TMP("HLA",$J))
 K @DGHLROOT
 ;
 ;build ACK segments array
 I $$BLDACK^DGPFHLU4(DGACKTYP,DGHLROOT,.DGHL,.DGSEGERR,.DGSTOERR) D
 . ;
 . ;generate the message
 . D GENACK^HLMA1(DGHL("EID"),DGMIEN,DGHL("EIDS"),"GM",1,.DGHLERR)
 ;
 ;cleanup
 K @DGHLROOT
 Q
 ;
SNDQRY(DGDFN,DGMODE) ;Send QRY Message Types (QRY~R02)
 ;
 ;  Input:
 ;    DGDFN - (required) pointer to patient in PATIENT (#2) file
 ;   DGMODE - (optional) type of HL7 connection to use ("1" - direct
 ;            connection, "2" - deferred connection [default])
 ;
 ;  Output:
 ;   Function value - 1 on success, 0 on failure
 ;
 N DGCMOR
 N DGHLROOT
 N DGHLLNK
 N DGHL
 N DGICN
 N DGMSG
 N DGRSLT
 N HLL
 N HLEID
 N HLRSLT
 ;
 ;the following HL* variables are created by DIRECT^HLMA
 N HL,HLCS,HLDOM,HLECH,HLFS,HLINST,HLINSTN
 N HLMTIEN,HLNEXT,HLNODE,HLPARAM,HLPROD,HLQ
 N HLQUIT
 ;
 S DGMODE=+$G(DGMODE)
 S DGRSLT=0
 S DGHLROOT=$NA(^TMP("HLS",$J))
 K @DGHLROOT
 ;
 I $$QRYON^DGPFPARM(),+$G(DGDFN)>0,$D(^DPT(DGDFN,0)) D
 . ;
 . ;ICN must be national and CMOR must not be local site
 . Q:'$$MPIOK^DGPFUT(DGDFN,.DGICN,.DGCMOR)
 . ;
 . ;retrieve CMOR's HL Logical Link and build HLL array
 . S DGHLLNK=$$GETLINK^DGPFHLUT(DGCMOR)
 . Q:(DGHLLNK=0)
 . S HLL("LINKS",1)="DGPF PRF ORF/R04 SUBSC"_U_DGHLLNK
 . ;
 . ;initialize VistA HL7 environment
 . S HLEID=$$INIT^DGPFHLUT("DGPF PRF QRY/R02 EVENT",.DGHL)
 . Q:'HLEID
 . ;
 . ;build QRY segments array
 . Q:'$$BLDQRY^DGPFHLQ(DGDFN,DGICN,DGHLROOT,.DGHL)
 . ;
 . ;display busy message to interactive users when direct-connect
 . I DGMODE=1,$E($G(IOST),1,2)="C-" D
 . . S DGMSG(1)="Attempting to connect to CMOR site to search for Patient"
 . . S DGMSG(2)="Record Flag Assignments.  This request may take some"
 . . S DGMSG(3)="time, please be patient ..."
 . . D EN^DDIOL(.DGMSG)
 . ;
 . ;generate HL7 message
 . I DGMODE=1 D    ;generate direct-connect HL7 message
 . . D DIRECT^HLMA(HLEID,"GM",1,.HLRSLT,"","")
 . . Q:$P(HLRSLT,U,2)]""
 . . I HLMTIEN D RCV^DGPFHLR
 . . ;success
 . . S DGRSLT=1
 . ;
 . E  D              ;generate deferred HL7 message
 . . D GENERATE^HLMA(HLEID,"GM",1,.HLRSLT,"","")
 . . Q:$P(HLRSLT,U,2)]""
 . . ;success
 . . S DGRSLT=1
 ;
 ;cleanup
 K @DGHLROOT
 Q DGRSLT
 ;
SNDORF(DGQRY,DGMIEN,DGHL,DGDFN,DGSEGERR,DGQRYERR) ;Send ORF Message Type (ORF~R04)
 ;This procedure assumes the the VistA HL7 environment is providing the
 ;environment variables and will produce a fatal error if they are
 ;missing.
 ;
 ;  Input:
 ;       DGQRY - (required) Array of QRY parsing results
 ;      DGMIEN - (required) IEN of message entry in file #773
 ;        DGHL - (required) HL7 environment array
 ;       DGDFN - (required) Pointer to patient in PATIENT (#2) file
 ;    DGSEGERR - (optional) Errors found during parsing
 ;    DGQRYERR - (optional) Errors found during query
 ;
 ;  Output:
 ;    none
 ;
 N DGHLROOT
 N DGHLERR
 ;
 Q:('$D(DGQRY))
 Q:('+$G(DGMIEN))
 ;
 S DGHLROOT=$NA(^TMP("HLA",$J))
 K @DGHLROOT
 ;
 ;build ORF segments array
 I $$BLDORF^DGPFHLQ(DGHLROOT,.DGHL,DGDFN,.DGQRY,.DGSEGERR,.DGQRYERR) D
 . ;
 . ;generate the message
 . D GENACK^HLMA1(DGHL("EID"),DGMIEN,DGHL("EIDS"),"GM",1,.DGHLERR)
 ;
 ;cleanup
 K @DGHLROOT
 Q
