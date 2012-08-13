INTSUSN1 ;JD; 28 Jun 96 19:22; processing functions and utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
VERIF(INGBL,INMSH,INTYP,INEVN,INERR) ;Determine HL7 message type and event
 ;INPUT
 ;--INGBL = global being checked, can be ^INTHU
 ;--------If numeric, assumed to be IEN for ^INTHU
 ;--------If non-numeric, assumed to be global reference
 ;--INMSH = variable for MSH segment (Pass by reference)
 ;--INTYP = Message type in format (PBR)
 ;--INEVN = Trigger event (PBR)
 ;--INERR = error message array (PBR)
 ;RETURN
 ;0=success 1=failure  2=fatal error
 N LCT,EVN,TYPE
 I +INGBL S LCT=0 D GETLINE^INHOU(INGBL,.LCT,.INMSH)
 I 'INGBL S INMSH=$G(@INGBL@(1))
 I $E(INMSH,1,3)'="MSH" S MSG(1)="Message from receiver Test Utility does not have the MSH segment in the correct location",MSG(2)=$E(INMSH,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) Q 2
 S INDELIM=$E(INMSH,4),INSUBDEL=$E(INMSH,5)
 D
 . ;First get message type from MSH-9. Trigger Event may be
 . ;second component of type.
 . S TYPE=$P(INMSH,INDELIM,9) S INEVN=$P(TYPE,INSUBDEL,2),INTYP=$P(TYPE,INSUBDEL) Q:$L(INEVN)
 . ;If no EVENT, check for EVN segment in next 5 lines
 . I INGBL F I=1:1:5 D  Q:$L(INEVN)
 .. D GETLINE^INHOU(INGBL,.LCT,.EVN)
 .. S:$P(EVN,INDELIM)="EVN" INEVN=$P(EVN,INDELIM,2)
 . I 'INGBL F I=2:1:5 D  Q:$L(INEVN)
 .. S EVN=$G(@INGBL@(I))
 .. S:$P(EVN,INDELIM)="EVN" INEVN=$P(EVN,INDELIM,2)
 Q 0
 ;
