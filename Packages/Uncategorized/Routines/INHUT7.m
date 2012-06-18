INHUT7 ; KAC ; 8 Jan 98 17:16; HL7 Utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
GETDEST(INACKTT,INA,INACKDST,INACKUIF) ; $$function - Used to support routing
 ; of Application Acknowledgement messages to the originating system
 ; when multiple instantiations of a remote system type exist.  Only
 ; one of the input parameters (INA,INACKDST,INACKUIF) must be
 ; specified by the caller to route an Application Ack.  If a valid
 ; destination cannot be identified, a fatal script error is logged
 ; and the O/P Ctlr will log an error in ^INTHER.
 ;
 ; Called by:  SCRIPT GENERATOR MESSAGE file, Outgoing Initial MUMPS
 ;             Code field, S INDEST=$$GETDEST^INHUT(INTT,.INA,INDEST)
 ;
 ; Input:
 ;   INACKTT  - (req) INTERFACE TRANSACTION TYPE IEN for Application
 ;                    Ack.  Used for error handling.
 ;   INA      - (req) array containing information for routing
 ;                    Application Ack to originator's dest as
 ;                    specified by GIS Receiver
 ;   INACKDST - (opt) INTERFACE DESTINATION IEN for outbound
 ;                    Application Ack as specified by user
 ;   INACKUIF - (opt) UNIVERSAL INTERFACE IEN for outbound Application
 ;                    Ack.  Contains destination specified for this
 ;                    Ack at time of Ack creation.  Future implementation.
 ;
 ; Variables:
 ;   X        - scratch
 ;   INERRMSG - error message to be returned in INHERR by Ack script
 ;
 ; Output:
 ;   - INTERFACE DESTINATION IEN for outbound Application Ack
 ;   - "" if fails to find valid dest
 ;
 N INERRMSG,X
 ;
 ; GIS-Receiver-specified dest
 I $G(INA("INDEST")),$D(^INRHD(INA("INDEST"),0)) Q INA("INDEST")
 ;
 ; User-specified dest
 I $G(INACKDST),$D(^INRHD(INACKDST,0)) Q INACKDST
 ;
 ; Ack msg exists - use dest specified at time of msg creation
 I $G(INACKUIF) S X=$P($G(^INTHU(INACKUIF,0)),U,2) I X,$D(^INRHD(X,0)) Q X
 ;
 ; Error - no valid destinations identified
 S INERRMSG="Application Ack creation failed - no valid destinations identified for Ack transaction type "_$S($G(INACKTT):$P($G(^INRHT(INACKTT,0)),U),1:"")
 D ERROR^INHS(INERRMSG,2) ; fatal Ack script error - set INHERR
 Q ""
 ;
SUBESC(INREC,INDEL,INB) ;Substitute escape delimeters to and from HL7
 ;                        spec
 ;Input:
 ; INREC - Portion of HL7 MSG to check
 ; INDEL(opt) = FSRET values - each position is critical
 ;              ie S INDEL="^\|~&"
 ;                       or
 ;              array of delimiters
 ;              S INDEL("F")="^"
 ;              S INDEL("S")="\"
 ;              S INDEL("R")="|"
 ;              S INDEL("E")="~"
 ;              S INDEL("T")="&"
 ; INB - I inbound, O outbound
 ;Returns - Record with replace values
 ;Outbound
 Q:$G(INB)="O" $$CNVDLM(.INREC,.INDEL)
 ;Inbound
 Q:$G(INB)="I" $$DLMCNV(.INREC,.INDEL)
 Q INREC
CNVDLM(INREC,INDEL) ;;Convert delimeters to HL7 specifications if in record
 ; Input: INREC - Portion of HL7 MSG to check
 ;        INDEL(opt) = FSRET values - each position is critical
 ;                  ie S INDEL="^\|~&"
 ;                          or
 ;                  array of delimiters
 ;                    S INDEL("F")="^"
 ;                    S INDEL("S")="\"
 ;                    S INDEL("R")="|"
 ;                    S INDEL("E")="~"
 ;                    S INDEL("T")="&"
 ; Returns - Record with replace values
 ;
 N INF,I,J,K,E,R,S,F,T,INREC1,IND
 S (INREC1,E,R,S,F,T)="",IND="FSRET"
 I $L($G(INDEL)) F I=1:1:5 S @$E(IND,I)=$E(INDEL,I)
 E  I $D(INDEL)>1 S I="" F  S I=$O(INDEL(I)) Q:I=""  S @I=INDEL(I)
 S:E="" E=$$ESC^INHUT() S:R="" R=$$REP^INHUT() S:S="" S=$$COMP^INHUT()
 S:F="" F=$$FIELD^INHUT() S:T="" T=$$SUBCOMP^INHUT()
 ;
 ;Set array of HL7 delimters to replacement value
 S J(R)=E_"R"_E,J(S)=E_"S"_E,J(E)=E_"E"_E,J(F)=E_"F"_E,J(T)=E_"T"_E
 ;
 ;loop through record looking for HL7 delimters
 F K=1:1:$L(INREC) D
 .;if special character doesn't exist keep else replace
 .I '$D(J($E(INREC,K))) S INREC1=INREC1_$E(INREC,K)
 .E  S INREC1=INREC1_J($E(INREC,K))
 Q INREC1
DLMCNV(INREC,INDEL) ;;HL7 specifications to correct delimitor if in record
 ; Input: INREC - Portion of HL7 MSG to check
 ;        INDEL(opt) = FSRET values - each position is critical
 ;                  ie S INDEL="^\|~&"
 ;                          or
 ;                  array of delimiters
 ;                    S INDEL("F")="^"
 ;                    S INDEL("S")="\"
 ;                    S INDEL("R")="|"
 ;                    S INDEL("E")="~"
 ;                    S INDEL("T")="&"
 ; Returns - Record with replace values
 ;
 N INF,I,J,K,E,R,S,F,T,INREC1,IND
 S (INREC1,E,R,S,F,T)="",IND="FSRET"
 I $L($G(INDEL)) F I=1:1:5 S @$E(IND,I)=$E(INDEL,I)
 E  I $D(INDEL)>1 S I="" F  S I=$O(INDEL(I)) Q:I=""  S @I=INDEL(I)
 S:E="" E=$$ESC^INHUT() S:R="" R=$$REP^INHUT() S:S="" S=$$COMP^INHUT()
 S:F="" F=$$FIELD^INHUT() S:T="" T=$$SUBCOMP^INHUT()
 ;
 ;Set array of HL7 delimters to replacement value
 S J("R")=R,J("S")=S,J("E")=E,J("F")=F,J("T")=T
 ;
 ;loop through record looking for HL7 delimters
 F  S K=$F(INREC,E) Q:'K!($E(INREC,K+1)="")  I $E(INREC,K+1)=E D
 .S INREC1=INREC1_$E(INREC,1,K-2)
 .I $D(J($E(INREC,K))) S INREC1=INREC1_J($E(INREC,K))
 .E  S INREC1=INREC1_$E(INREC,K-1,K+1)
 .S INREC=$E(INREC,K+2,$L(INREC))
 S INREC1=INREC1_INREC
 Q INREC1
APPACK(INUIF,INAKMES,INASTAT,INERMSG) ;User API to ACKLOG^INHU
 ;
 ; Inputs:
 ;   INUIF   = UIF ien of ack message in Universal Interface file
 ;   INAKMES = Acked message ID - Typically: @INV@("MSA2")
 ;   INASTAT = Ack message status - Typically: @INV@("MSA1"), converted
 ;             to 0=NAK or 1=ACK.  ex: S INASTAT=("AA"=INASTAT)
 ;   INERMSG = Message to store if NAK. Typically: @INV@("MSA6")
 ;
 ; Usage:
 ;     D APPACK^INHUT(UIF,@INV@("MSA2"),@INV@("MSA1"),@INV@("MSA6"))
 ;
 S INAKMES=$G(INAKMES),INASTAT=$G(INASTAT),INERMSG=$G(INERMSG)
 N INFERR,INFMSG
 S (INFERR,INFMSG)=""
 ;
 I INAKMES="" S INFMSG="No message identified to acknowledge",INFERR=2
 I 'INFERR D  ;save the worst error
 .I '$D(^INTHU("C",INAKMES)) S INFMSG="Acknowledge for unknown message ID - "_INAKMES,INFERR=2 Q
 .I INASTAT S INASTAT=1 Q
 .I $E(INASTAT,2)="A" S INASTAT=1 Q
 .I INASTAT="" S INERMSG=$S($L(INERMSG):$E(INERMSG,1,475)_"      ",1:"")_"No ACK status"
 .S INASTAT=0
 I INFERR D ERROR^INHS(INFMSG,INFERR) Q
 D ACKLOG^INHU(INUIF,INAKMES,INASTAT,INERMSG)
 Q
 ;
SETENV ;Set environment for GIS with DUZ postmaster array
 S U="^",DUZ=.5,DUZ(0)="@",IO="",DTIME=1
 ;If Postmaster has no default division, find one and set it.
 ;IHS logic
 I '$$SC^INHUTIL1 D SETDT^UTDT K Z Q
 ;CHCS logic
 I '$P(^DIC(3,DUZ,0),U,16) D SETDIV
 D SETDT^UTDT
 D DUZAG^XUS1   ; set up agency codes, no user prompts
 D ^XUDIV   ; set up division. No user prompts since default div is set
 K Z
 Q
 ;
SETDIV ;Called from SETENV if needed to stuff the postmaster default division.
 N INDEF,INDIV
 S (INDEF,INDIV)=0 F  S INDIV=$O(^DG(40.8,INDIV)) Q:'INDIV!INDEF  D
 .;Set as default if a) an inpatient facility and b) not inactive
 .I $G(^DG(40.8,INDIV,8100)),'$G(^DG(40.8,INDIV,28)) S INDEF=INDIV
 ;If no divisions meet criteria, look for first non active division
 I 'INDEF S INDEV=0 F  S INDIV=$O(^DG(40.8,INDIV)) Q:'INDIV!INDEF  D
 .I '$G(^DG(40.8,INDIV,28)) S INDEF=INDIV
 ;If still no INDEFault, set default to first entry in 40.8
 S:'INDEF INDEF=$O(^DG(40.8,0))
 S DIE="^DIC(3,",DA=.5,DR="28.2///`"_INDEF D ^DIE
 Q
 ;
