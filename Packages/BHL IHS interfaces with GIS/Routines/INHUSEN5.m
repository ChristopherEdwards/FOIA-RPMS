INHUSEN5 ; DGH ; 27 Jul 1999 11:06:07; MEDE/NCPDP processing functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 5; 21-MAY-1997
 ;COPYRIGHT 1994 SAIC
 ;
 ;This contains the MEDE implementation of NCPDP validation software.
 ;
 Q
INNC(ING,INSEQ,INXDST,INERR) ;Primary entry point for MEDE/NCPDP messages.
 ;Called from IN^INHUSEN
 ;INPUT:
 ; ING (req) = message array
 ; INSEQ (PBR) = variable in which to return MEDE sequence number
 ; INXDST = EXecutable code to identify the destination of messages.
 ; INERR (PBR) = variable to return error array if message is in error
 ; INDSTR = state variable, destination ien of transceiver
 ;RETURNS
 ; 0 = no errors--transceier will QKILL and set message to "complete"
 ; 1 = PDTS error--transceiver should resend message
 ; 2 = communication error--transceiver should reroute message
 ; 3 = error in outgoing MEDE ENP header--QKILL and log error
 ; 4 = ENP error (incoming)--log error but take no other action.
 ; 5 = Error in incoming such as no sequence # x-ref
 ; 6 = Dummy message is ok
 ; 7 = Dummy message is not ok
 N INMEDE,INVL,PARUIF,INMSG,MESS
 ;Verify MEDE ENP header--get sequence number & type. Quit if error
 S INVL=$$VERIF(ING,.INMEDE,.INTYP,.INSEQ,.INERR) Q:INVL INVL
 ;
 ;--Determine the GIS destination from MEDE transaction type
 D  Q:INVL INVL
 .;Tranceiver must pass Dest. Deter. routine, INXDST, execute it.
 .X INXDST
 .;Dest Det. code must return INDSTP
 .I '$G(INDSTP) S INVL=3,MSG="Message "_INSEQ_" has no destination" M MSG=@ING D ERRADD^INHUSEN3(.INERR,.MSG) Q
 .;pointer needed for most functions, NAME needed for NEW^INHD.
 .S:'$D(INDST) INDST=$P(^INRHD(INDSTP,0),U)
 ;
 ;Identify parent (original outgoing message) for this response.
 S PARUIF=$O(^INTHU("ASEQ",INDSTR,INSEQ,""))
 I 'PARUIF S MSG="Message "_INSEQ_" has no ASEQ cross reference",INVL=5 D ERRADD^INHUSEN3(.INERR,.MSG)
 ;
 ;Set variables needed for STORE and store the message
 S (ORIGID,MESSID)=INSEQ,INMSH=INMEDE
 D STORE^INHUSEN4
 I INMSG>0,PARUIF D
 .;Update parent pointer in incoming message.
 .S:$D(^INTHU(INMSG)) $P(^INTHU(INMSG,0),U,7)=PARUIF
 .;Update "application ack" pointer in parent message
 .S $P(^INTHU(PARUIF,0),U,6)=INMSG
 .S MESS(1)="Response received"
 .D ULOG^INHU(PARUIF,"A",.MESS)
 Q $S(INVL:INVL,1:0)
 ;
VERIF(INGBL,INMEDE,INTYP,INSEQ,INERR) ;Check for error status and extract MEDE data
 ;INPUT
 ;--INGBL = global being checked, can be ^INTHU
 ;--------If numeric, assumed to be IEN for ^INTHU
 ;--------If non-numeric, assumed to be global reference
 ;--INMEDE = variable for MEDE segment (Pass by reference)
 ;--INTYP = Message type in format (PBR)
 ;--INSEQ = sequence number (PBR)
 ;--INERR = error message array (PBR)
 ;RETURN
 ;-error codes 0-4 as desribed in INNC tag
 N LCT,MSG,ERR,INDMISID,INSITE,INSE,INNCP,INNC3
 ;--First segment is MEDE header.
 I +INGBL S LCT=0 D GETLINE^INHOU(INGBL,.LCT,.INMEDE)
 I 'INGBL S INMEDE=$G(@INGBL@(1))
 ;--Get type = "CR", "HB" or "ER" and sequence number
 S INTYP=$E(INMEDE,3,4),INSEQ=$E(INMEDE,5,12),INSITE=$E(INMEDE,17,20)
 ;If either of these are missing, this is a fatal ENP error
 I ",CR,DR,HR,ER,SE,"'[(","_INTYP_",") S MSG="Message from receiver "_$P(^INTHPC(INBPN,0),U)_" does not have a valid type" M MSG=@INGBL D ERRADD^INHUSEN3(.INERR,.MSG) Q 4
 ;If sequence number = DUMMYTRX, this is a response to a dummy/heartbeat
 I INSEQ="DUMMYTRX" D  Q INVL
 .;INTYP="DR" means the dummy was good. Otherwise build error array
 .I INTYP="DR" S INVL=6 Q
 .S MSG="Error in 'dummy' message from receiver "_$P(^INTHPC(INBPN,0),U)
 .M MSG=@INGBL D ERRADD^INHUSEN3(.INERR,.MSG) S INVL=7
 ;INSEQ must be numeric except for DUMMYTRX.
 I INSEQ'?.N S MSG="Sequence number contains non-numberic characters" M MSG=@INGBL D ERRADD^INHUSEN3(.INERR,.MSG) Q 4
 S INSEQ=+INSEQ
 I 'INSEQ S MSG="Message does not have a valid sequence number" M MSG=@INGBL D ERRADD^INHUSEN3(.INERR,.MSG) Q 4
 ;INTYP="ER" is reserved for ENP header problem. Log and quit.
 I INTYP="ER" D  Q 3
 .S MSG="ENP header error in message with sequence number "_INSEQ M MSG=@INGBL
 .D ERRADD^INHUSEN3(.INERR,.MSG)
 ;--Check destination=DMIS ID from MEDICAL TREATMENT FACILITY file
 ;Following code is CHCS specific. Will require equivalent IHS function
 ;S OUT=1 I $$SC^INHUTIL1 D  Q:OUT 4
 ;.S INDMISID=$$DMISID^DAHPNU
 ;.I INDMISID'=INSITE S MSG="Message destination of "_INSITE_" does not match "_INDMISID M MSG=@INGBL D ERRADD^INHUSEN3(.INERR,.MSG) S OUT=1
 ;If INTYP="CR", message contains a valid response, no need to continue
 Q:INTYP="CR" 0
 ;If INTYP="SE", a switch/communication error has occured.
 I INTYP="SE" D  Q INVL
 . ;Switch error will start immediately in second segment.
 . I INGBL D GETLINE^INHOU(INGBL,.LCT,.INNCP)
 . I 'INGBL S INNCP=$G(@INGBL@(2))
 . ;Trim leading and trailing blanks
 . S INSE=$$LBTB^UTIL(INNCP)
 . I '$L(INSE) S MSG="Error field of message "_$G(INSEQ)_" is blank" M MSG=@INGBL D ERRADD^INHUSEN3(.INERR,.MSG) S INVL=2 Q
 . ;convert to upper case and match known error messages
 . S INSE=$$CASECONV^UTIL(INSE,"U"),INVL=0
 . F I=1:1 S ERR=$T(ERRORS+I) Q:ERR'[";;"!INVL  I INSE[$P(ERR,";;",2) S INVL=$P(ERR,";;",3) M MSG=@INGBL D ERRADD^INHUSEN3(.INERR,.MSG)
 . ;If no match on error message, default to INVL=4
 . Q:INVL
 . S INVL=4,MSG="Message contains no known error code" M MSG=@INGBL
 . D ERRADD^INHUSEN3(.INERR,.MSG)
 ;-If heartbeat, it is unexpected. Log it.
 D ERRADD^INHUSEN3(.INERR,"Heart beat received "_INMEDE) S INVL=4
 Q INVL
 ;
ERRORS ;Tags containing all known MEDE error messages
 ;;TSHARED UNAVAILABLE;;2;;
 ;;SWITCH UNAVAILABLE;;2;;MEDE may use this instead of TSHARED
 ;;TSHARED NOT RESPONDING;;1;;
 ;;PDTS NOT RESPONDING;;1;;
 ;;PDTS UNAVAILABLE;;2;;May indicate need to switch processor?
 ;;WRONG VERSION;;3;;
 ;;INVALID ENP TYPE;;3;;
 ;;NON ALPHANUMERIC;;3;;
 ;;INCORRECT VALUE IN SOURCE;;3;;
 ;;DATA LENGTH;;3;;
 ;;MISSING ENP;;3;;
 ;
