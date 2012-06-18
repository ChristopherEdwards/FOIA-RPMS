HLOCNRT ;DAOU/ALA-Generate HL7 Optimized Message ; 17 Jun 2005  12:57 PM
 ;;1.6;HEALTH LEVEL SEVEN;**126**;Oct 13, 1995
 ;
 ;**Program Description**
 ;  This program takes a current HL7 1.6 message and converts
 ;  it to use the new HL Optimized code if it follows the standard
 ;  1.6 methodology of protocols.
 ;
 ;  **If the VistA HL7 Protocol does not exist, calls to HL Optimized
 ;  will have to be coded separately and this program cannot be used**
 Q
 ;
EN(HLOPRTCL,ARYTYP,HLP) ;Entry Point
 ;  Input Parameters
 ;   HLOPRTCL = Protocol IEN or Protocol Name
 ;   ARYTYP = The array where HL7 message resides
 ;   HLP = Additional HL7 message parameters
 ;
 ;  Output
 ;    ZTSTOP = Stop processing flag (used by HDR)
 ;    HLORESL = Error parameter
 ;
 NEW HLORESL,HLMSTATE,APPARMS,WHOTO,WHO,ERROR,HLOMESG
 S ZTSTOP=0,HLORESL=1
 ;
 ;  Get IEN of protocol if name is passed
 I HLOPRTCL'?.N S HLOPRTCL=+$O(^ORD(101,"B",HLOPRTCL,0))
 I '$D(^ORD(101,HLOPRTCL)) S HLORESL="^99^HL7 1.6 Protocol not found",ZTSTOP=1 Q HLORESL
 ;
 ;  If the VistA HL7 Protocol exists, call the Conversion Utility
 ;  to set up the APPARMS, WHO or WHOTO arrays from protocol
 ;  logical link
 D APAR^HLOCVU(HLOPRTCL,.APPARMS,.WHO,.WHOTO)
 ;
 ; If special HLP parameters are defined, convert them
 I $D(HLP) D
 . I $G(HLP("SECURITY"))'="" S APPARMS("SECURITY")=HLP("SECURITY")
 . I $G(HLP("CONTPTR"))'="" S APPARMS("CONTINUATION POINTER")=HLP("CONTPTR")
 . I $G(HLP("QUEUE"))'="" S APPARMS("QUEUE")=HLP("QUEUE")
 ;
 ;  Create HL Optimized message
 I '$$NEWMSG^HLOAPI(.APPARMS,.HLMSTATE,.ERROR) S HLORESL="^99^"_ERROR,ZTSTOP=1 Q HLORESL
 I $E(ARYTYP,1)="G" S HLOMESG="^TMP(""HLS"",$J)"
 I $E(ARYTYP,1)="L" S HLOMESG="HLA(""HLS"")"
 ;
 ;  Move the existing message from array into HL Optimized
 D MOVEMSG^HLOAPI(.HLMSTATE,HLOMESG)
 ; 
 ;  Send message via HL Optimized
 I $D(WHOTO) D  Q HLORESL
 . I '$$SENDMANY^HLOAPI1(.HLMSTATE,.APPARMS,.WHOTO) S HLORESL="^99^Unable to send message",ZTSTOP=1 Q
 . S HLORESL=1
 ;
 I '$$SENDONE^HLOAPI1(.HLMSTATE,.APPARMS,.WHO,.ERROR) S HLORESL="^99^"_ERROR,ZTSTOP=1 Q HLORESL
 Q HLORESL
