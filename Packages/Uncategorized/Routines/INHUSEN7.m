INHUSEN7 ;KN,DGH; 11 Nov 1999 16:52 ; X12 verification logic
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 5; 21-MAY-1997
 ;COPYRIGHT 1994 SAIC
 ;
VERIF(INGBL,INTYP,INTA,ORIGID,INLINK,INSTAT,INERR) ;12/6/98
 ; Description:
 ; The function VERIF is used to verify and evaluate X12 headers 
 ; such as ISA, GS or TA1 and X12 Trailers such as GE, IEA.
 ; It returns values such as message type, control numbers, etc.
 ;
 ; Parameters:
 ; Input:
 ; INGBL = May be a local or global array of X12 message lines
 ;         If numeric, assumed to be IEN for ^INTHU
 ;         If non-numeric, assumed to be variable array
 ; INTYP = (PRB) Variable to contain X12 Functional Identifier (msg type)
 ; INTA = (PBR) Variable array contains fields of interest
 ; ORIGID = (PBR) Message ID of incoming message
 ; INLINK = (PBR) ID of original message such as a query.
 ;          This will be stored in CHCS as a sequence number because
 ;          alpha characters are not allowed by X12.
 ; INSTAT = (PBR) Variable to contain status of original message.
 ;    (INLINK & INSTAT are only populated for FA and TA1 message types)
 ;   kim is including following in INTA, not sure if this is needed
 ;  INTA   = array of value for interchange ack (PBR)
 ;  INTA("ORGICNUM") = Original Interchange Control Number
 ;  INTA("ORGDATE")  = Original Date
 ;  INTA("ORGTIME")  = Original Time
 ;  INTA("ACKCODE")  = Interchange Ack Code
 ;  INTA("NOTECODE") = Interchange Note Code
 ;  INORGID = Original message ID (PBR)
 ; the Transaction Set Control Number (ST02) is the original ID.
 ;
 ; Returns:
 ;    0 = Success
 ;    1 = Non-Fatal Error
 ;    2 = Fatal Error
 ;
 N LCT,INDOCNT,INISA,INGST,INGE,INIEA,INER,INGS2,LINE,MSG,INACK
 N INFROM,INSTCNT,INTEREST,LINE,SEGID
 ;Initialize
 S INVL=0 K INACK
 ;Get Interchnage Control Header ISA
 I +INGBL D GETLINE^INHOU(INGBL,.LCT,.LINE)
 I 'INGBL S LINE=$G(@INGBL@(1))
 I $E(LINE,1,3)'="ISA" W !,"Message from receiver "_$P(^INTHPC(INBPN,0),U)_" does not have the ISA segment in the correct location",MSG(2)=$E(LINE,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) Q 2
 S INDELIM=$E(LINE,4),INSUBDEL=$E(LINE,105)
 ;Set ORIGID of the ISA. If incoming is TA1, this must be used.
 ;If not a TA1, ORIGID will be overwritten with id in the ST segment.
 S ORIGID=$P(LINE,INDELIM,13)
 ; Default value is good transmission
 ;Get next line, INGST=GS or TA1  
 I +INGBL D GETLINE^INHOU(INGBL,.LCT,.LINE)
 I 'INGBL S LINE=$G(@INGBL@(2))
 ;Second segment must be either GS or TA1
 S SEGID=$P(LINE,INDELIM)
 I ",TA1,GS,"'[(","_SEGID_",") S MSG(1)="Second segment is not GS nor TA1",MSG(2)=$E(LINE,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) Q 2
 ;--TA1 not planned for DEERS use, but needed for generic X12 processing.
 I SEGID="TA1" D  Q INVL
 .S INTYP="TA1"
 .S INLINK=$P(LINE,INDELIM,2),INSTAT=$P(LINE,INDELIM,4)
 .I ",A,E,R,"'[(","_INSTAT_",") D ERRADD^INHUSEN3(.INERR,"Missing or invalid acknowledge code "_LINE) S INVL=2 Q
 .I INSTAT'="A" D ERRADD^INHUSEN3(.INERR,LINE)
 ;
 ;--Else next segment is a GS.
 S (INTYP,INTA("GS01"))=$P(LINE,INDELIM,2)
 S INTA("GS06")=$P(LINE,INDELIM,7)
 I '$L(INTYP) S MSG(1)="Message from receiver "_$P(^INTHPC(INBPN,0),U)_" does not have a type.",MSG(2)=$E(LINE,1,250),INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG)
 Q:INVL INVL
 ;$Order through remainder lines to obtain needed control data.
 S INTEREST=",ISA,GS,ST,SE,GE,ISE,TA1,AK1,AK2,AK3,AK4,AK5,AK9,BHT,BGN,BGF,",INDOCNT=0
 I +INGBL D  Q:'INVL
 .D GETLINE^INHOU(INGBL,.LCT,.LINE)
 .S SEGID=$P(LINE,INDELIM)
 .;count segments beteween ST and SE if "do count" flag is set.
 .I INDOCNT S INSTCNT=$G(INSTCNT)+1
 .D:INTEREST[SEGID INCNTL
 I 'INGBL S LCT=2 F  S LCT=$O(@INGBL@(LCT)) Q:'LCT  D
 .S LINE=$G(@INGBL@(LCT))
 .S SEGID=$P(LINE,INDELIM)
 .;Count segments between ST and SE. Note: Overflow nodes will be
 .;in @INGBL@(LCT,I), so LINE is an accurate counte of segments.
 .I INDOCNT S INSTCNT=$G(INSTCNT)+1
 .D:INTEREST[SEGID INCNTL
 ;
 ;---Miscellaneous error checking section--
 I $G(INTA("ST02"))'=$G(INTA("SE02")) S MSG(1)="ST02 "_$G(INTA("ST02"))_" does not match SE02 "_$G(INTA("SE02"))_" transaction set control numbers",INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG) Q INVL
 ;---Set other needed variables. INLINK value differs by message type--
 S ORIGID=$G(INTA("ST02"))
 S:INTYP="HB" INLINK=$G(INTA("BHT03")) ;271
 S:INTYP="AG" INLINK=$G(INTA("BGN02")) ;824
 S:INTYP="BE" INLINK=$G(INTA("BGN02")) ;834
 S:INTYP="HI" INLINK=$G(INTA("BHT03")) ;278
 Q INVL
 ;
INCNTL ;Get control segment field values for segments of interest
 ;This assumes that needed variables are within the first 240
 ;characters of LINE (e.g. there are no overflow nodes). If INGBL
 ;is a local array (most likely), any overflow of a segment would
 ;not reach this call because the calling logic is doing a $O of
 ;the first subscript and overflow beyond 240 chars are in subsequent.
 ;Input
 ; LINE=first line of segment if global; first 240 characters if local
 ; SEGID
 ;Return
 ; fields needed to process
 Q:SEGID=""
 I SEGID="ISA" S MSG(1)="Second ISA found in message",MSG(2)=LINE,INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG) Q
 I SEGID="GS" S MSG(1)="Multiple GS loops not supported",MSG(2)=LINE,INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG) Q
 I SEGID="IEA" S INTA("IEA1")=$P(LINE,INDELIM,2),INTA("IEA2")=$P(LINE,INDELIM,2) Q
 I SEGID="TA1" S ORIGID=$P(LINE,INDELIM,2),INTA("ACKCODE")=$P(LINE,INDELIM,3),INTA("NOTECODE")=$P(LINE,INDELIM,4) Q
 I SEGID="ST" D  Q
 .;Turn "do count" on and initialize ST-SE segment counter to 1.
 .S (INSTCNT,INDOCNT)=1
 .I $D(INTA("ST01")) S MSG(1)="Multiple ST loops not supported",INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG)
 .S INTA("ST01")=$P(LINE,INDELIM,2),INTA("ST02")=$P(LINE,INDELIM,3) Q
 I SEGID="SE" D  Q
 .S INTA("SE01")=$P(LINE,INDELIM,2),INTA("SE02")=$P(LINE,INDELIM,3)
 .;Turn "do count" flag off and compare count in SE01 with INSTCNT
 .S INDOCNT=0
 .I INTA("SE01")'=INSTCNT S MSG(1)="Segment count "_INSTCNT_" does not match specified count "_INTA("SE01"),INVL=1 D ERRADD^INHUSEN3(.INERR,.MSG)
 I SEGID="GE" S INTA("GE01")=$P(LINE,INDELIM,2),INTA("GE02")=$P(LINE,INDELIM,3) Q
 I SEGID="BHT" S INTA("BHT03")=$P(LINE,INDELIM,4)
 I SEGID="BGN" S INTA("BGN01")=$P(LINE,INDELIM,2),INTA("BGN02")=$P(LINE,INDELIM,3) Q
 I SEGID="BGF" S INTA("BGF01")=$P(LINE,INDELIM,2),INTA("BGF02")=$P(LINE,INDELIM,3) Q
 ;Following should only exist if INTYP=FA (Functional Acknowledge).
 Q:INTYP'="FA"
 ;Logic will add each AKn segment to temp array. Only roll it into
 ;error log if status is in error. But we don't know that till the end.
 ;Don't set INSTAT flag until the last segment--AK9
 I SEGID="AK2" S INLINK=$P(LINE,INDELIM,3)
 I ",AK1,AK2,AK3,AK4,AK5,"[(","_SEGID_",") D ERRADD^INHUSEN3(.INACK,LINE) Q
 ;AK9-1 has value of X12's INSTAT, the equivalent of HL7's MSASTAT.
 I SEGID="AK9" D
 .S INSTAT=$P(LINE,INDELIM,2)
 .I ",A,E,R,"'[(","_INSTAT_",") D ERRADD^INHUSEN3(.INERR,"Missing or invalid acknowledge code "_LINE) S INVL=2 Q
 .I INSTAT'="A" D ERRADD^INHUSEN3(.INACK,LINE),ERRADD^INHUSEN3(.INERR,.INACK)
 Q
 ;
 ;
