INHVCRL2 ;KAC ; 29 Feb 96 11:38; Logon Server (LoS) Background Controller (continued)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
INPARMS(INDSTP,INPARMS,INERR,INUIF) ; $$function - Build persistent msg parameter 
 ; array for an inbound msg.  If array already exists for this inbound msg's
 ; destination, exit.
 ;
 ; Input:
 ;   INDSTP   - (pbr) INTERFACE DESTINATION IEN for inbound msg from 
 ;                    UNIVERSAL INTERFACE file
 ;   INERR    - (pbr) array containing error msg used to log an error
 ;   INPARMS  - (pbr) inbound msg parameter array
 ;                    Format: INPARMS(INDSTP,"param")=value
 ;   INUIF    - (opt) UNIVERSAL INTERFACE IEN for inbound msg
 ;                    Required if INDSTP needs to be set.
 ;
 ; Variables:
 ;   INGETACK - flag - null = Ack is NOT used by this inbound transaction type
 ;                     >0   = Ack IS used by this inbound transaction type
 ;   X        - scratch
 ;
 ; Output:
 ;   0 - success  - INPARMS(INDSTP,"param") = value
 ;   1 - failure  - NO data is stored in inbound msg parameter array
 ;                - INERR = error msg
 ;
 ; Get destination for this inbound msg (if NOT passed in or if null)
 I '$G(INDSTP) D  Q:$L($G(INERR)) 1
 . I '$G(INUIF) S INERR="Missing UNIVERSAL INTERFACE entry for inbound message" Q
 . S INDSTP=$P($G(^INTHU(INUIF,0)),U,2)
 . I 'INDSTP S INERR="Missing destination for inbound message - UNIVERSAL INTERFACE entry, '"_INUIF_"'"
 ;
 ; Quit if array for this inbound destination has been built
 Q:$D(INPARMS(INDSTP)) 0
 ;
 N DSIN0,DSIN01,DSOUT,DSOUT0,DSOUT01,INGETACK,SCIN,SCOUT,TTIN,TTIN0,TTIN01,TTOUT,TTOUT0,TTOUT01,X
 ;
 ; Get 0-node & name for inbound destination
 S DSIN0=$G(^INRHD(INDSTP,0)),DSIN01=$P(DSIN0,U)
 I '$L(DSIN01) S INERR="Missing inbound destination name for INTERFACE DESTINATION entry, '"_INDSTP_"'" Q 1
 ;
 ; Get inbound transaction type for this destination
 S TTIN=$P(DSIN0,U,2)
 I 'TTIN S INERR="Missing inbound transaction type for INTERFACE DESTINATION, '"_DSIN01_"'" Q 1
 ;
 ; Get 0-node & name for inbound transaction type
 S TTIN0=$G(^INRHT(TTIN,0)),TTIN01=$P(TTIN0,U)
 I '$L(TTIN01) S INERR="Missing inbound transaction type name for INTERFACE TRANSACTION TYPE entry, '"_TTIN_"'" Q 1
 ;
 ; Verify whether inbound transaction type is active
 I '$P(TTIN0,U,5) S INERR="Inactive INTERFACE TRANSACTION TYPE, '"_TTIN01_"'" Q 1
 ;
 ; Get inbound script for this transaction type
 S SCIN=$P(TTIN0,U,3)
 I 'SCIN S INERR="Missing inbound script for INTERFACE TRANSACTION TYPE, '"_TTIN01_"'" Q 1
 ;
 ; Ack information may NOT be required for every transaction type.
 S INGETACK=$P(TTIN0,U,9) ; get Ack transaction type
 I INGETACK D  Q:$L($G(INERR)) 1
 . S TTOUT=INGETACK
 .; Get 0-node & name for Ack transaction type
 . S TTOUT0=$G(^INRHT(TTOUT,0)),TTOUT01=$P(TTOUT0,U)
 . I '$L(TTOUT01) S INERR="Missing Ack transaction type name for INTERFACE TRANSACTION TYPE entry, '"_TTOUT_"'" Q
 .;
 .; Get outbound script for Ack transaction type
 . S SCOUT=$P(TTOUT0,U,3)
 . I 'SCOUT S INERR="Missing outbound script for INTERFACE TRANSACTION TYPE, '"_TTOUT01_"'" Q
 .;
 .; Get outbound destination for Ack transaction type
 . S DSOUT=$P(TTOUT0,U,2)
 . I 'DSOUT S INERR="Missing outbound destination for INTERFACE TRANSACTION TYPE, '"_TTOUT01_"'" Q
 .;
 .; Get 0-node & name for outbound (Ack) destination
 . S DSOUT0=$G(^INRHD(DSOUT,0)),DSOUT01=$P(DSOUT0,U)
 . I '$L(DSOUT01) S INERR="Missing outbound destination name for INTERFACE DESTINATION entry, '"_DSOUT_"'" Q
 ;
 ; Build inbound msg parameter array
 F X="DSIN01","DSOUT","DSOUT01","SCIN","SCOUT","TTIN","TTIN01","TTOUT","TTOUT01" S:$D(@X) INPARMS(INDSTP,X)=@X
 Q 0
 ;
SNDAACK(INBPN,INCHNL,INIP,INA,INDA,INUIF,INPARMS,INQUE,INERR) ; 
 ; $$function - Send application Acknowledgement to remote system.
 ;
 ; Input:
 ;   INA      - (opt) array containing either:
 ;                    1) INA = UNIVERSAL INTERFACE IEN for outbound Ack
 ;                             (already processed by outbound script)
 ;                    2) INA array subscripts, some or all of which have
 ;                       been defined, comprising a msg ready to be 
 ;                       processed by outbound script
 ;                    If NOT passed, ACK^INHOS creates an application
 ;                    error Ack ("AE").
 ;   INBPN    - (req) BACKGROUND PROCESS CONTROL IEN for calling process
 ;   INCHNL   - (req) TCP channel assigned to this server when connection
 ;                    is opened
 ;   INDA     - (opt) array containing information to be sent to an
 ;                    outbound destination
 ;                      INDA = IEN in base file used by outbound script
 ;                      Subscripts may hold subfile IENs in the format:
 ;                        INDA(subfile #,DA)=""
 ;                    If NOT passed, ACK^INHOS sets to -1.
 ;   INERR    - (pbr) array containing error msg used to log an error
 ;   INIP     - (req) array containing initialization parameters from
 ;                    BACKGROUND PROCESS CONTROL file
 ;   INPARMS  - (opt) inbound msg parameter array
 ;                    Format: INPARMS(INDSTP,"param")=value
 ;   INQUE    - (opt) flag - 1 = do NOT que Ack to o/p ctlr
 ;                           0 = que Ack to o/p ctlr (default)
 ;   INUIF    - (opt) UNIVERSAL INTERFACE IEN for inbound msg
 ;                    Required if need to "build" Ack from INA array.
 ;
 ; Variables:
 ;   INACKTYP - flag - 1 = positive Ack - AA = application accept
 ;                     0 = negative Ack (default)
 ;                         AE or AR = application error reject
 ;   INACKUIF - UNIVERSAL INTERFACE IEN for outbound Ack
 ;   INDSTP   - INTERFACE DESTINATION IEN for original inbound msg from 
 ;              UNIVERSAL INTERFACE file
 ;   INERRACK - error information returned by function
 ; 
 ; Output:
 ;   0 = Ack successfully sent
 ;   1 = Ack NOT successfully sent
 ;
 N INACKTYP,INACKUIF,INDSTP,INERRACK
 ;
 I $G(INCHNL)'>0 S INERR="Failed to send Ack - invalid channel #" Q 1
 S INACKUIF=$G(INA) ; if Ack is already built in UIF, INACKUIF = IEN
 ;
 ; Create Ack if NOT already built in UIF
 I $S('INACKUIF:1,'$D(^INTHU(INACKUIF)):1,1:0) D  Q:$D(INERR) 1
 . I $S('$G(INUIF):1,'$D(^INTHU(INUIF)):1,1:0) S INERR="Missing entry in UNIVERSAL INTERFACE file for Ack creation" Q
 .; Get inbound INTERFACE TRANSACTION TYPE IEN
 . I $$INPARMS^INHVCRL2(.INDSTP,.INPARMS,.INERR,INUIF) Q
 .; Get type of Ack
 . S INACKTYP=$S($E($G(INA("INSTAT")),2)="A":1,1:0)
 . D ACK^INHOS(INPARMS(INDSTP,"TTIN"),INACKTYP,INUIF,.INERR,.INA,.INDA,$G(INQUE),.INACKUIF)
 ;
 ; Transmit Ack to remote system
 ;Start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD(INACKUIF,"",$P(^INTHPC(INBPN,0),U),$G(INHSRVR),"TRANSMIT")
 S INERRACK=$$SEND^INHUVUT(INACKUIF,INCHNL,.INIP)
 ;Stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 Q INERRACK
 ;
