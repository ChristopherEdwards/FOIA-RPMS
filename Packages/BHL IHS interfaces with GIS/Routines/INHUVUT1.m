INHUVUT1 ; cmi/flag/maw - DGH,FRW 05 Oct 1999 15:29 Generic TCP/IP socket utilities ; [ 05/14/2002 1:26 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;Called from tag lines in INHUVUT
 ;
 Q
INIT(INBPN,INIP) ; Intialize parameters
 ;INPUT:
 ; INBPN=background process
 ; INIP=variable to contain parameters. Pass By Reference.
 ;OUTPUT:
 ; INIP will be returned as an array of parameters
 ; INIP("OTRY")=number of times to try and open socket
 ; INIP("OHNG")=pause between attempts to open socket (seconds
 ; INIP("DTRY")=number of times to try to open socket following
 ;              consecutive remote end disconnects (firewalls can
 ;              give false open)
 ; INIP("DHNG")=pause between attempts to open socket following
 ;              remote end disconnect (firewalls can give false open)
 ; INIP("RTO")=receive timeout
 ; INIP("STO")=send timeout
 ; INIP("RTRY")=number of times to retry read from other system)
 ; INIP("RHNG")=hang between read attempts
 ; INIP("EOL")=end of line character(s)
 ; INIP("INIT")=initialization string to send
 ; INIP("ACK")=acknowledge to initialization string
 ; INIP("THNG")=Transmitter hang time if nothing on queue
 ; INIP("STRY")=number of times to retry send
 ; INIP("SHNG")=hang time between send retries
 ; INIP("SMAX")=maximum # of msgs that multi-threaded transceiver can
 ;              have in-flight at any point in time
 ; INIP("TMAX")=remote system timeout
 ;              # of seconds to wait for remote system to communicate
 ;              before connection is closed
 ;              Input: DUZ   - (opt) USER IEN
 ; INIP("NOSOM")=No S.O.M. required (for apcots.  This will go away)
 ; INIP("CRYPT")=encryption flag (default=0)
 ; INIP("DESKEY")=DES Key for encryption (default=null)
 ; INIP("SOM")=start of message (default=null)
 ; INIP("EOM")=end of message (default=null)
 ;
 N STR,STR7,STR10
 S STR=$G(^INTHPC(INBPN,1)),STR7=$G(^INTHPC(INBPN,7))
 S STR10=$G(^INTHPC(INBPN,10))
 S INIP("OTRY")=$S($L($P(STR,U)):$P(STR,U),1:10)
 S INIP("OHNG")=$S($L($P(STR,U,2)):$P(STR,U,2),1:15)
 S INIP("DTRY")=$S($L($P(STR,U,15)):$P(STR,U,15),1:10)
 S INIP("DHNG")=$S($L($P(STR,U,18)):$P(STR,U,18),1:0)
 S INIP("RTO")=$S($L($P(STR,U,3)):$P(STR,U,3),1:15)
 S INIP("STO")=$S($L($P(STR,U,4)):$P(STR,U,4),1:60)
 S INIP("RTRY")=$S($L($P(STR,U,5)):$P(STR,U,5),1:5)
 S INIP("RHNG")=$S($L($P(STR,U,6)):$P(STR,U,6),1:1)
 S INIP("EOL")=$$ASCII($S($P(STR,U,7):$P(STR,U,7),1:13))
 ;cmi/maw 10/5/2001 for x12
 I $P($G(^INTHL7M(INBPNM,0)),U,12)="X12" S INIP("EOL")=""
 S INIP("INIT")=$S($P(STR,U,8):$$ASCII($P(STR,U,8)),1:"")
 S INIP("ACK")=$$ASCII($S($P(STR,U,9):$P(STR,U,9),1:""))
 S INIP("THNG")=$S($L($P(STR,U,10)):$P(STR,U,10),1:10)
 S INIP("STRY")=$S($L($P(STR,U,11)):$P(STR,U,11),1:10)
 S INIP("SHNG")=$S($L($P(STR,U,12)):$P(STR,U,12),1:1)
 S INIP("NOSOM")=$P(STR,U,13)
 S INIP("SMAX")=$S($L($P(STR,U,14)):$P(STR,U,14),1:15)
 S INIP("CRYPT")=$S($P(STR10,U,1):$P(STR10,U,1),1:0)
 S INIP("DESKEY")=$S($L($P(STR10,U,2)):$P(STR10,U,2),1:"")
 S INIP("SOM")=$$ASCII($S($P(STR,U,16):$P(STR,U,16),1:11))
 S INIP("EOM")=$$ASCII($S($P(STR,U,17):$P(STR,U,17),1:28))
 I $G(DUZ)>1 S INIP("TMAX")=$$DTIME^INHULOG(DUZ)
 S:$P(STR7,U,5)>+$G(INIP("TMAX")) INIP("TMAX")=$P(STR7,U,5)
 Q
 ;
ASCII(X) ;Converts a string into an ASCII string
 ;INPUT:
 ; X is string in format "13,14,15"
 ;OUTPUT
 ; format $C(13)_$C(14)_$C(15)
 Q:'X ""
 I X'["," Q $C(+X)
 N ASC,I
 S ASC="" F I=1:1:$L(X,",") S ASC=ASC_$C($P(X,",",I))
 Q ASC
 ;
INRHB(INBPN,MESS,LAST) ;Updates background process file
 ;format is ^INRHB("RUN",INBPN)=$H^MESSage^$H time of last success
 ;INPUT:
 ; INBPN=Background process file number
 ; MESS=message text
 ; LAST = 1 to set $H time in third piece, 2 to kill third piece
 ;        0 or null to leave at previous value
 ;RETURNS
 ; 1 if background job should continue to run
 ; 0 if it should be shut down
 ;
 L +^INRHB("RUN",INBPN):0
 I '$D(^INRHB("RUN",INBPN)) L -^INRHB("RUN",INBPN) Q 0
 S $P(^INRHB("RUN",INBPN),U,1,2)=$H_U_$G(MESS)
 I $G(LAST) S $P(^INRHB("RUN",INBPN),U,3)=$S(LAST=1:$H,1:"")
 L -^INRHB("RUN",INBPN)
 Q 1
 ;
PARSE ;Parse INREC array (raw message) into ING array (HL7 segments).
 ;PARSE tag moved to INHUVUT1 because routine size is too large
 ;Array format =
 ; INV(1) if line terminated by $c(13), or is first line of many in seg
 ; INV(1,1), INV(1,2)... for overflow nodes until terminated
 N DSC,LIN,REM,EOS,X,X1,SEGS
 S (LN,DSC)=0,LIN=1,REM=""
 ;$O through all lines of "raw" array
 F  S LN=$O(@INREC@(LN)) Q:'LN  D
 .Q:@INREC@(LN)=""
 .S INLIN=@INREC@(LN)
 .;break each raw line into 240 chacter pieces
 .F  S X1=$E(INLIN,1,240),INLIN=$E(INLIN,241,999) Q:'$L(X1)  D
 ..F  S X=$$SEG(.X1,.EOS) D  Q:'$L(X1)
 ...I $L(X) D R2 Q
 ...;If EOS was first character in line, X will have no length,
 ...;but the next parsed value of X will be start of new segmnt
 ...S LIN=LIN+1,DSC=0
 Q
 ;
SEG(X1,EOS) ;Parse line X1 into HL7 segments.
 ;INPUT:
 ;--X1 (PBR) = string which may contain embedded EOS characters
 ;--EOS (PBR)= flag to indicate if EOS characters are present
 ;OUTPUT:
 ;--X1 (PBR) = remainder of string (if any) following EOS character
 ;--value returned is string preceeding EOS character
 ;
 I X1'[INIP("EOL") S X=X1,EOS=0,X1="" Q X
 S X=$P(X1,INIP("EOL")),X1=$P(X1,INIP("EOL"),2,99),EOS=1 Q X
 ;
R2 ;Set received lines into variable or global with format
 N LEN
 ;INV(LIN)=segment string
 ;INV(LIN,DSC)=overflow of string if segment exceeds 240 characters
 ;INPUT:
 ;--X = string to be stored
 ;--LIN = line number into which X is to be stored.
 ;--DSC = descendent into which X is to be stored
 ;  If X is not the start of a segment (DSC=0), attempt to concatenate
 ;  X to the last INV(LIN) or INV(LIN,DSC) to length of 240, place
 ;  remainder of X in the next DSC.
 ;OUTPUT:
 ;--new values of LIN and DSC
 ;
 ;First, check memory, roll out to global if needed.
 I $S<INSMIN D
 .Q:INV["^"
 .K ^UTILITY("INV",$J)
 .M ^UTILITY("INV",$J)=@INV K @INV S INV="^UTILITY(""INV"","_$J_")"
 ;IF DSC>0, store into descendent level.
 I DSC D
 .;if it doesn't already exist, create it.
 .I '$D(@INV@(LIN,DSC)) S @INV@(LIN,DSC)=X Q
 .;otherwise concatenate it to previous value
 .I $L((@INV@(LIN,DSC))_X)<240 S @INV@(LIN,DSC)=@INV@(LIN,DSC)_X Q
 .S LEN=240-$L(@INV@(LIN))
 .S @INV@(LIN,DSC)=@INV@(LIN,DSC)_$E(X,1,LEN)
 .S DSC=DSC+1,@INV@(LIN,DSC)=$E(X,LEN+1,999)
 ;IF DSC is 0, store into top level.
 I 'DSC D
 .;if it doesn't already exist, create it.
 .I '$D(@INV@(LIN)) S @INV@(LIN)=X Q
 .;otherwise concatenate it to previous value
 .I $L((@INV@(LIN))_X)<240 S @INV@(LIN)=@INV@(LIN)_X Q
 .S LEN=240-$L(@INV@(LIN))
 .S @INV@(LIN)=@INV@(LIN)_$E(X,1,LEN),DSC=1,@INV@(LIN,DSC)=$E(X,LEN+1,999)
 ;If end of segment flag, increment LINe count and set DSC back to 0
 I EOS S LIN=LIN+1,DSC=0
 Q
 ;
RCVSTR(INV,INCHNL,INIP,INERR,INMEM) ;Read socket
 ;This reads a single string from a socket. It is the companion
 ;routine to SENDSTR^INHUVUT, and is used for initializaton
 ;and response to initialization. These two tags differ from
 ;the SEND and RECEIVE tags in that there is no start-of-message.
 ;The should, however, be an end-of-message. The initialization
 ;string should be contained in a single socket read, but this
 ;function allows for multipe reads up to the EOM.
 ;
 ;INPUT
 ; INV=Location to store message, pass by reference
 ; INCHNL=socket
 ; INIP=array of parameters, PBR
 ; INERR=error array, PBR
 ;OUTPUT
 ;0=ok, 1=no response at all, 2=failure in middle of receive
 ;3=remote system disconnected
 ;   Note: the check for remote system disconnect is based on a string
 ;   match from utility routine %INET. If that utility is changed, this
 ;   must also be changed.
 ;
 N NULLREAD,NORESP,RTO,AP,APDONE,API,APREC,X,REM,INSMIN,REC,INERRREC
 S RTO=INIP("RTO"),INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 ; load socket input into INREC (or into ^UTILITY("INREC")
 S (APDONE,APREC,AP)="",(NULLREAD,NORESP)=0,INREC="REC"
 K @INREC
 S (APDONE,APREC,AP)="",(NULLREAD,NORESP)=0,INREC="REC"
 F  D  Q:APDONE!NORESP
 .D RECV^%INET(.APREC,.INCHNL,RTO,1)
 .;D RECV^%INET(.APREC,.INCHNL,RTO,1,$G(INBPN))  ;maw cache
 .;check for remote disconnect
 .I $G(APREC(0))["Remote end disconnect" S APDONE=3 Q
 .I APREC=""!(APREC[INIP("EOM")) S APDONE=1
 .;Remove message framing characters from packet
 .S APREC=$TR(APREC,INIP("SOM")_INIP("EOM"))
 .;Check for no response from remote system after NNN tries
 .I '$L(APREC) D  Q
 ..D WAIT^INHUVUT2(INBPN,INIP("RHNG"),"Reading socket",.NORESP) Q:NORESP
 ..S NULLREAD=NULLREAD+1 S:NULLREAD>INIP("RTRY") NORESP=1
 .I $S<INSMIN D
 ..Q:INREC["^"
 ..K ^UTILITY("INREC",$J)
 ..M ^UTILITY("INREC",$J)=@INREC K @INREC S INREC="^UTILITY(""INREC"","_$J_")"
 .S AP=AP+1,@INREC@(AP)=APREC
 ;If remote end disconnected
 I APDONE=3 S INERR=$G(APREC(0)) Q APDONE
 ;If No message was received
 I 'AP S INERR="No message received from remote system on receiver "_$P(^INTHPC(INBPN,0),U) Q 1
 ;If remote system timed-out log error
 I NORESP S INERR="Remote system on "_$P(^INTHPC(INBPN,0),U)_" timed out during transmission of message "_$P($G(@INREC@(1)),$G(INDELIM),10) Q 2
 D PARSE^INHUVUT1
 K @INREC
 Q 0
 ;
