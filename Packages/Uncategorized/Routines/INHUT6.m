INHUT6 ; CHEM,KAC ; 6 May 97 17:03; HL7 Utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
SUPPRESS(INPROC,INTT,INDEST,INBPC,INA,INDA,INUIF,INMSH) ; $$function - Identify
 ; application screening logic based on precedence at a particular
 ; GIS process screening point and execute (if exists).
 ;
 ; Input:
 ; INPROC   - (req) function of calling process
 ;                  "XMT" = Transmitter
 ;                  "RCV" = Receiver
 ; INTT     - (opt) INTERFACE TRANSACTION TYPE IEN
 ; INDEST   - (opt) INTERFACE DESTINATION IEN (lowest level)
 ;                  Lowest level destination has Route IDs.
 ; INBPC    - (opt) BACKGROUND PROCESS CONTROL IEN
 ; INA      - (opt) "INA" or "^INTHU(IEN,7)" (UNIVERSAL INTERFACE file).
 ;                  Location of [selected subnodes of] the INA array.
 ;                  Selected subnodes of INA array are merged into 
 ;                  the outbound message by the Format Controller 
 ;                  after outbound script execution.  Used by 
 ;                  application teams' screening logic (@INA@("node")).
 ; INDA     - (opt) "INDA" or "^INTHU(IEN,6)" (UNIVERSAL INTERFACE file).
 ;                  Location of INDA array.  INDA array is merged into 
 ;                  the outbound message by the Format Controller 
 ;                  prior to outbound script execution.  Used by 
 ;                  application teams' screening logic (@INDA@("node")).
 ; INUIF    - (opt) UNIVERSAL INTERFACE IEN of message to be screened
 ; INMSH    - (opt) HL7 Message Header (MSH) string (not parsed)
 ;                  Set for inbound messages at Receiver screening
 ;                  point only.
 ;
 ; Variables:
 ; X        - scratch
 ; INPRI    - array - top level = precedence of screen to execute
 ;                  - descendents = information relevant to screen
 ;                                  precedence and execution
 ;            Format: INPRI(X)=File#^IEN^Field # of screening logic"
 ;            Example:  INPRI=2  ; execute screen w/ precedence=2
 ;                      INPRI(1)=Precedence 1 screening info
 ;                      INPRI(2)=Precedence 2 screening info
 ;                      INPRI(3)=Precedence 3 screening info
 ; INSRCTL  - array - screening logic control information
 ;   "INSRPROC" - identifies GIS process currently executing
 ;                  "XMT" = Transmitter
 ;                  "RCV" = Receiver
 ;   "INTT"     - INTERFACE TRANSACTION IEN
 ;   "INDEST"   - INTERFACE DESTINATION IEN (lowest level)
 ;                Lowest level destination has Route IDs.
 ;   "INBPC"    - BACKGROUND PROCESS CONTROL IEN
 ;   "MSH"      - HL7 Message Header (MSH) string (not parsed)
 ;                from inbound msg
 ; INSRDATA - array - screening logic return values
 ;            false = send msg
 ;            true  = suppress msg
 ;   "Route ID" - identifies destination to which to route msg.
 ;                Multiple entries are allowed.
 ; INSRMC   - selective routing M code to be executed as a screen at
 ;            this screening point
 ; INSUPRES - flag - function return value
 ;                   0 = send msg
 ;                   1 = suppress msg
 ;
 ; Output:
 ; 0 = deliver msg to destination
 ; 1 = suppress msg (no delivery to destination)
 ;
 N INPRI,INSRCTL,INSRDATA,INSRMC,INSUPRES,X
 ;
 ; Initialization
 S INPROC=$G(INPROC),INTT=$G(INTT),INDEST=$G(INDEST),INBPC=$G(INBPC),INUIF=$G(INUIF),INMSH=$G(INMSH)
 ;
 ; Customizations for current screening point - File#^IEN^Screen Node
 I INPROC="XMT" D  ; Transmitter screens
 .; Precedence 1 = Transaction Type
 . S:INTT INPRI(1)="4000^"_INTT_"^9"
 .; Precedence 2 = Background Process
 . S:INBPC INPRI(2)="4004^"_INBPC_"^12"
 .; Precedence 3 = Primary Destination
 . D:INDEST
 .. S X=$P($G(^INRHD(INDEST,7)),U,2) ; Primary Dest has SRMC
 .. S INPRI(3)="4005^"_$S(X:X,1:INDEST)_"^16"
 ;
 I INPROC="RCV" D  ; Receiver screens
 .; Precedence 1 = Transaction Type
 . S:INTT INPRI(1)="4000^"_INTT_"^8"
 .; Precedence 2 = Background Process
 . S:INBPC INPRI(2)="4004^"_INBPC_"^11"
 .; Precedence 3 =Inbound Destination (off of BPC)
 . D:INDEST
 .. S X=$P($G(^INRHD(INDEST,7)),U,2) ; Primary Dest has SRMC
 .. S INPRI(3)="4005^"_$S(X:X,1:INDEST)_"^15"
 . S INSRCTL("MSH")=INMSH
 ;
 ; send if calling process NOT identified or no valid file/table passed in
 Q:'$D(INPRI) 0
 ;
 ; Get screen w/ highest precedence
 S INPRI=0 ; remember precedence of screen to be executed
 F  S INPRI=$O(INPRI(INPRI)) Q:'INPRI  D  Q:$L(INSRMC)
 . S X="S INSRMC=$G("_^DIC(+INPRI(INPRI),0,"GL")_$P(INPRI(INPRI),U,2)_","_$P(INPRI(INPRI),U,3)_"))"
 . X X  ; set INSRMC = screening logic to be executed (if exists) or ""
 ;
 Q:'$L($G(INSRMC)) 0  ; send if no screening logic in file/table
 ;
 ; Initialization prior to calling screen
 S INSRCTL("INSRPROC")=INPROC ; function of calling process
 S:INTT INSRCTL("INTT")=INTT
 S:INDEST INSRCTL("INDEST")=INDEST
 S:INBPC INSRCTL("INBPC")=INBPC
 X INSRMC  ; execute screening logic
 ;
 ; Examine screening results (in INSRDATA)
 ; Check:
 ; 1) suppress
 ; 2) broadcast, no list
 ; 3) broadcast, list exists - ck if Route ID for this destination 
 ;    matches INSRDATA("RouteID") returned by screen
 S INSUPRES=$S($G(INSRDATA):1,$D(INSRDATA)<10:0,1:$S($G(INDEST):$$FINDRID^INHUT5(.INSRDATA,INDEST),1:0))
 ; Log suppressions
 I INSUPRES S X=INPRI(INPRI) D LOG^INHUT6(+X,$P(X,U,2),$P(X,U,3),INUIF,$S($G(INUIF):1,1:0))
 Q INSUPRES
 ;
LOG(INFN,INIEN,INSRMC,INUIF,INLOG) ; Log error message.
 ; Add entry in the UIF ACTIVITY LOG MULTIPLE.
 ; Used for identifying which screening code suppressed this entry.
 ; If INUIF is absent, or SR debug is on,
 ;  log message will be in the IFE file only.
 ; INPUTS:
 ;   INFN     File number (Should be 4000, 4004, or 4005)
 ;   INIEN    IEN w/in file that was suppressed
 ;   INSRMC   SRMC Field number
 ;   INUIF    (opt) IEN of the Universal Interface File (Optional)
 ;   INLOG    (opt) Boolean: 0 Don't update status, 1: Update status
 ;   INENVSDB (opt) Boolean: 0 no SR debug, 1: Site SR debug is turned on
 ;   INSRCTL("INSRPROC") (opt) Environment variable letting me know
 ;            which gis function is calling me
 ;   INSRCTL("INDEST")   (opt) For XMT, its part of ENT^INHE call. (Dest)
 ;   INSRCTL("INBPC")    (opt) For RCV, this is part of ENR^INHE call
 ;   INSRCTL("INTT")     (opt) For REP, this is part of ENO^INHE call
 ;
 ; OUTPUTS:
 ;   INENVSDB Boolean: 0 no debug, 1: Site debug is turned on
 ;
 N X,Y,%,MSG
 S:'$D(INENVSDB) INENVSDB=$P($G(^INRHSITE(1,0)),"^",16)
 S INFN=+$G(INFN),INIEN=+$G(INIEN),INSRMC=+$G(INSRMC),INUIF=+$G(INUIF),INLOG=+$G(INLOG)
 ;
 S MSG=INFN_"^"_INIEN_"^"_INSRMC_"^"_INUIF_"^"_$G(INSRCTL("INDEST"))
 D:INENVSDB  ; Use pointers only, unless in DEBUG mode.
 .S MSG="INVALID FILE NUMBER IN LOG ROUTINE"
 .S %=$G(^DIC(INFN,0,"GL")) D:$L(%)  ;
 ..K MSG S MSG(1)="Suppressed at "_$O(^DD(INFN,0,"NM",""))_" file, "
 ..I $G(INSRCTL("INDEST")) S X="^INRHD("_(INSRCTL("INDEST"))_",0)" S:$D(@X)#2 MSG(5)=" for dest "_$P(@X,"^")
 ..S X=%_(INIEN)_",0)" S MSG(2)=$P($G(@X),"^")_" record, "
 ..S MSG(3)=$P($G(^DD(INFN,INSRMC,0)),"^")_" field, "
 ..S X=%_(INIEN)_","_(INSRMC)_")"
 ..S MSG(4)=" with code "_$G(@X)
 ;
 I 'INUIF!INENVSDB D
 .;File in IEF via INHE
 .I $G(INSRCTL("INSRPROC"))="XMT" D ENT^INHE(INUIF,$G(INSRCTL("INDEST")),.MSG) Q
 .I $G(INSRCTL("INSRPROC"))="REP" D ENO^INHE($G(INSRCTL("INTT")),INUIF,$G(INSRCTL("INDEST")),.MSG) Q
 .D ENR^INHE(+$G(INSRCTL("INBPC")),.MSG)
 ;
 Q:'INUIF
 ;
 ;File in UIF (ACTIVITY LOG MULTIPLE) via ULOG^INHU
 I 'INENVSDB K MSG D ULOG^INHU(INUIF,"X",.MSG,"",1) ;Update multiple.
 D:INENVSDB ULOG^INHU(INUIF,"X",.MSG,"",1) ;Update multiple w/ MSG
 D:INLOG ULOG^INHU(INUIF,"C") ; Update status.
 Q
 ;
