INHVCRL1 ;KAC ; 8 Jul 95 15:58; Logon Server (LoS) Background Controller (continued)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
RESET(INBPN,INCHNL,INERR,INA,INIP,INUIF,INPARMS) ;
 ; Logon attempt by remote system has failed.  Log the error, transmit 
 ; negative acknowledgement to remote system (if requested), close LoS 
 ; port.
 ;
 ; Input:
 ;   INA      - (opt) array containing either:
 ;                    1) INA = UNIVERSAL INTERFACE IEN for outbound Ack
 ;                             (already processed by outbound script)
 ;                    2) INA array subscripts, some or all of which have
 ;                       been defined, comprising a msg ready to be 
 ;                       processed by outbound script
 ;                    3) INA = Ack code - AA = application accept
 ;                                        AE = application error
 ;                                        AR = application reject
 ;                    4) If INA is passed, but does NOT meet conditions
 ;                       in 1-3, default Ack code = AR
 ;                    If INA is NOT passed, do NOT send Ack.
 ;   INBPN    - (req) BACKGROUND PROCESS CONTROL IEN for LoS
 ;   INCHNL   - (req) TCP channel assigned to this server when connection
 ;                    is opened
 ;   INDA     - array containing information to be sent to an outbound
 ;              destination.  Not currently used.
 ;                INDA = IEN in base file used by outbound script
 ;                Subscripts may hold subfile IENs in the format:
 ;                  INDA(subfile #,DA)=""
 ;              If NOT needed, set to -1 prior to running outbound script.
 ;   INERR    - (opt) array containing error msg used to log an error
 ;   INIP     - (opt) array containing initialization parameters from
 ;                    BACKGROUND PROCESS CONTROL file. Required to send Ack.
 ;   INPARMS  - (opt) inbound msg parameter array
 ;                    Format: INPARMS(INDSTP,"param")=value
 ;   INUIF    - (opt) UNIVERSAL INTERFACE IEN for inbound msg
 ;                    Required to "build" Ack.
 ;
 ; Variables:
 ;   INERRACK - error information returned by function
 ;   X        - scratch
 ;
 ; Output:
 ;   None.
 ;
 N INERRACK,X
 D:$D(INERR) LOG^INHVCRA1(.INERR,"E")
 ;
 ; Send Ack if requested
 I $D(INA) D
 . N INERR
 .; Skip Ack creation if Ack was already built in UIF or in INA array
 . I $S('$G(INA):1,'$D(^INTHU(INA)):1,1:0),$D(INA)<10 D
 ..; Create Ack in INA array
 .. S X=$G(INA) K INA
 ..; Ck if user passed valid error Ack code
 .. S INA("INSTAT")=$S(X="AE":X,1:"AR")
 .. S INA("INACKTXT")="Invalid CHCS Logon Attempt"
 .; Transmit negative Ack
 . D LOG^INHVCRA1("Transmitting negative acknowledgement")
 . S INERRACK=$$SNDAACK^INHVCRL2(INBPN,INCHNL,.INIP,.INA,.INDA,$G(INUIF),.INPARMS,1,.INERR)
 . I INERRACK D LOG^INHVCRA1(.INERR,"E") Q  ; error sending Ack
 . D LOG^INHVCRA1("Successful transmission")
 ;
 D LOG^INHVCRA1("Closing connection")
 D CLOSE^INHVCRL(INBPN,INCHNL)
 Q
 ;
