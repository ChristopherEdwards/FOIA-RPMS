INTSTR1 ;DGH; 5 Aug 97 10:35;Continuation of required field function
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q  ;no top entry
 ; Entry points are all called from INTSTR.
 ; MSG:
 ;  Given an entry in the SCRIPT GENERATOR MESSAGE file, this
 ;  builds an array of segments and required fields.
 ; UIF:
 ;  Given an entry in the Universal Interface File, build an array
 ;  of segment ids.
 ; VALID: Validates fields.
 ;
UIF(UIF,INARRAY,INDELIM,INSUBDEL) ;build array of UIF segment ids
 ;INPUT
 ;  UIF = Entry in the UIF
 ;  INARRAY = PBR array to return array. Final format will be
 ;     INARRAY(1)=MSH
 ;     INARRAY(2)=PID  and so on.
 ;       Note: this may be a sparse array if the UIF segments
 ;       overflow into multiple INHTU(uif,3, nodes
 ;  INDELIM = PBR value to find the HL7 delimiter from the message
 ;RETURN VALUE
 ; 0 = array build successfully
 ; 1 = fatal error
 ;
 N LCT,LINE,INMSG
 ;First entry in 3 node of UIF should be MSH, set HL7 delimiter
 S LCT=0 D GETLINE^INHOU(UIF,.LCT,.LINE)
 I '$D(LINE) D IO^INTSTR("No segments found in message") Q 1
 S INDELIM=$E(LINE,4)
 I $P(LINE,INDELIM)'="MSH" D IO^INTSTR("First segment is not MSH") Q 1
 ;Set variable with ALL the delimiter set
 S INSUBDEL=$P(LINE,INDELIM,2)
 ;Build array of segment ids
 S INARRAY(LCT)="MSH"
 F  D GETLINE^INHOU(UIF,.LCT,.LINE) Q:'$D(LINE)  D
 .S INARRAY(LCT)=$P(LINE,INDELIM)
 Q 0
 ;
MSG(MESS,INSEG) ;Enter here with known message ien
 ;INPUT
 ;   MESS=ien of message
 ;OUTPUT
 ;   INSEG array with following format (PBR)
 ;   INSEG(<sequence>,0) = <seg id>^Repeatable?^Required? (0=no, 1=yes)
 ;   INSEG(<sequence>,<nested sequence>,0) = <seg id>^Repeat?^Required?
 ;   INSEG(<seg id>)=Req field 1^Req field 2^....
 ; Example:
 ;   INSEG(1,0)=MSH^0^1
 ;   INSEG(2,0)=PID^0^1
 ;   INSEG(3,0)=OBC^1^1
 ;   INSEG(3,1,0)=OBR^1^0
 ;   INSEG("MSH")=1^1^^^1^^1
 ;   INSEG("PID")=^^^1^^1^
 ;INTERNALS
 ;
 ;Key variables
 ;   MULTIEN= ien of segment multiple
 ;   SEGIEN=  ien of segment in segment file
 N INS,MULTIEN,SEG,SEGIEN,INMSG,LVL,I,ORD
 ;Get message name
 S INMSG=$P(^INTHL7M(MESS,0),U)
 ;
 ;------------Build array of segments-----------------------------
 ;  This builds an array in variable INSEG, which is then inserted
 ;if any are defined, in sequence order (the "AS" x-ref)
 Q:'$D(^INTHL7M(MESS,1))
 ;   Process segments in sequence order BUT if a segment is a parent
 ;   to other segments, place those in order (see end of SEG tag).
 S ORD=1,LVL(1)=0
 S INS="" F  S INS=$O(^INTHL7M(MESS,1,"AS",INS)) Q:'INS  D
 .;Accomodate possibility of duplicate sequence numbers
 .S MULTIEN=""
 .F  S MULTIEN=$O(^INTHL7M(MESS,1,"AS",INS,MULTIEN)) Q:'MULTIEN  D
 ..S SEG(1)=^INTHL7M(MESS,1,MULTIEN,0),SEGIEN=+SEG(1)
 ..;at this point int the loop only LVL(1) should remain. Kill
 ..;other levels in case they weren't killed inside SEG tag.
 ..S I=1 F  S I=$O(LVL(I)) Q:'I  K LVL(I)
 ..;11 piece=parent. If this segment has a parent, don't process now.
 ..D:'$P(SEG(1),U,11) SEG(MESS,MULTIEN,.LVL)
 ;Add segments that have no sequence number
 S INS=0 F  S INS=$O(^INTHL7M(MESS,1,INS)) Q:'INS  D
 .Q:+$P(^INTHL7M(MESS,1,INS,0),U,2)
 .D SEG(MESS,INS,.LVL)
 Q
 ;
SEG(MESS,MULTIEN,LVL) ;  Load array with data from the segment multiple.
 ;INPUT
 ;  MESS = Pointer to Script Generator Message File
 ;  MULTIEN= Pointer to the segment multiple in MESS
 ;  LVL = Level array (PBR)
 N CH,CH2,PARENT,SEGIEN,DIFF,FSEQ,MULT,SEGNAM,STR,FLD,I,LEN,ORD,REQ,SEG,FLDP,J
 S SEGIEN=+^INTHL7M(MESS,1,MULTIEN,0)
 ;MULT(0) is zero node of the entry in the segment multiple
 S MULT(0)=^INTHL7M(MESS,1,MULTIEN,0)
 ;SEG(0) is zero node of the entry in the segment file
 S SEG(0)=^INTHL7S(SEGIEN,0)
 ;set string of required fields
 S (STR,FSEQ)="",REQ=0
 F  S FSEQ=$O(^INTHL7S(SEGIEN,1,"AS",FSEQ)) Q:'FSEQ  D
 .S FLD=$O(^INTHL7S(SEGIEN,1,"AS",FSEQ,"")) Q:'FLD
 .;3rd piece defines "required" within the segment
 .S REQ=$P(^INTHL7S(SEGIEN,1,FLD,0),U,3)
 .;If not required, see if field has any required subfields.
 .I 'REQ D
 ..S FLDP=+^INTHL7S(SEGIEN,1,FLD,0)
 ..Q:'$D(^INTHL7F(FLDP,10))
 ..S J=0 F  S J=$O(^INTHL7F(FLDP,10,J)) Q:'J!REQ  D
 ...;Set required flag to 2if any subfields are required.
 ...S:$P($G(^INTHL7F(FLDP,10,J,0)),U,3) REQ=2
 .S $P(STR,U,FSEQ)=+REQ
 ;Ignore segments with no fields, they may be "navigational".
 ;Only set level array if it is "real"
 D
 .;increment counter at highest level defined
 .S I=$O(LVL(""),-1),LVL(I)=LVL(I)+1
 .;set order variable to include all level counters
 .S ORD="",I="" F  S I=$O(LVL(I)) Q:'I  D
 ..S ORD=ORD_LVL(I)_","
 .S ORD="INSEG("_ORD_"0)"
 .;Only set level array if it is "real"
 .I '$L(STR) D  Q
 ..S @ORD="NAVIGATE"_U_$P(MULT(0),U,3)_U_$P(MULT(0),U,9)
 ..I $D(DEBUG) S $P(@ORD,U,4)=$P(SEG(0),U)_U_$P(MULT(0),U,2)
 .S @ORD=$P(SEG(0),U,2)_U_$P(MULT(0),U,3)_U_$P(MULT(0),U,9)
 .;For debug, tack on segment name and sequence number
 .I $D(DEBUG) S $P(@ORD,U,4)=$P(SEG(0),U)_U_$P(MULT(0),U,2)
 .;Set array with seg id^repeatable?^required?
 .S SEGNAM=$P(SEG(0),U,2)
 .I '$D(INSEG(SEGNAM)) S INSEG(SEGNAM)=STR Q
 .;If required field definition has already been set, check it
 .S LEN=$L(STR,U) S:$L(INSEG(SEGNAM),U)>LEN LEN=$L(INSEG(SEGNAM),U)
 .S DIFF=0 F I=1:1:LEN Q:DIFF  S:+$P(STR,U,I)'=+$P(INSEG(SEGNAM),U,I) DIFF=1
 .Q:'DIFF
 .;If there are differences, reset INSEG(SEGNAM) to maximum required.
 .;But only display warning message once per segment
 .D:'$D(INSEG(SEGNAM,1))
 ..S INMSG="Multiple "_SEGNAM_" segments are included in this message definition" D IO^INTSTR(INMSG)
 ..D IO^INTSTR("Validation will be performed using maximum set of required fields",0)
 ..S INSEG(SEGNAM,1)=$G(INSEG(SEGNAM,1))+1
 .F I=1:1:LEN S $P(INSEG(SEGNAM),U,I)=$P(STR,U,I)+$P(INSEG(SEGNAM),U,I)
 ;parent
 S PARENT=$S('$P(MULT(0),U,11):"",1:$P(^INTHL7S($P(MULT(0),U,11),0),U,2))
 ;   See if this segment is a parent to others, Quit if not
 Q:'$D(^INTHL7M(MESS,1,"ASP",SEGIEN))
 ;   If it is a parent, call SEG recursively. Also create another LVL.
 ;   Example, with LVL(1)=3, the current segment might be OBC, so
 ;   INSEG(3,0)=OBC. With OBC as a parent, LVL(2)=0 is created here,
 ;   incremented in the recursive call, and a "child" OBR is created
 ;   at INSEG(3,1,0)=OBR. A "child" OBX becomes INSEG(3,1,1,0)=OBX.
 ;   A second "child" to the OBR, (say NTE), becomes INSEG(3,1,2,0)=NTE.
 ;S I=$O(LVL(""),-1) S:LVL(I)>0 LVL(I+1)=0
 S I=$O(LVL(""),-1),LVL(I+1)=0
 S CH=0 F  S CH=$O(^INTHL7M(MESS,1,"ASP",SEGIEN,CH)) Q:'CH  D
 .S CH2=$O(^INTHL7M(MESS,1,"ASP",SEGIEN,CH,0))
 .D SEG(MESS,CH2,.LVL)
 ;After the recursion quits in previous line, kill current LVL
 S I=$O(LVL(""),-1) K LVL(I)
 Q
 ;
VALID(LCT,DEFMES,MSID,UIFMES,UCNT,INUIF,INERR) ;Validate required fields
 ;Validation consists of checking for the existance of data in field.
 ;No check is performed for type of data.
 ;INPUT:
 ; LCT = (PBR) Line count. It is incremented within VALID
 ; DEFMES= (PBR) Defined message array
 ; MSID= Segment ID for segment being evaluated
 ;    DEFMES(MSID) = string of required fields in sequence order.
 ;    Example: 1^0^1^2 means <SEG ID>-1 is required, -2 is not
 ;    A value of 2 indicates field is not required, but subfield(s) are.
 ;    The VALID function does not currently check individual subfields
 ;    but the capability could be added.
 ; UIFMES = (PBR) Actual message array
 ; UCNT = Pointer in array
 ; INUIF = Entry of actual message in UIF
 ;OUTPUT
 ;  A <validated> flag will be added to the UIFMES array
 ;  UIFMES(segment number)=<seg id>^<validated>
 ;  1=all required fields are present
 ;  2=at least one required field is missing
 ;  Nothing indicates the segment was not validated, probably
 ;  because bad message structure made segment impossible to get to.
 ; INERR = (PBR) Is set to 1 if any error condition is encountered
 ; UIFMES(UCNT) = Is updated with flag in second piece
 ;
 N ERR,LINE,I,J,MSH,SEGID,VALSTR,VAR
 S ERR=0
 D GETLINE^INHOU(INUIF,.LCT,.LINE)
 Q:'$D(LINE)
 I $D(DEBUG)>1 D IO^INTSTR(LINE)
 ;Set string of required fields for the current segment
 S VALSTR=$G(DEFMES(MSID)) I '$L(VALSTR) S INMSG="Segment "_MSID_" is not defined for this message" D IO^INTSTR(INMSG) Q
 ;Set flag if this is the MSH segment
 S SEGID=$P(LINE,INDELIM),MSH=$S(SEGID="MSH":1,1:0)
 F I=1:1:$L(VALSTR,U) D
 .;If the piece position does not have value, it is not required.
 .Q:'$P(VALSTR,U,I)
 .;If checking MSH, $P position=HL7 position. Otherwise add one
 .S J=$S(MSH:I,1:I+1)
 .S VAR=$$PIECE^INHU(.LINE,INDELIM,J)
 .;For all fields except MSH-2, translate out delimiter set (INSUBDEL).
 .;If a field has required subfields, this does not check that the
 .;proper subfield has value, only that the field containing it does.
 .I MSH,(J=2),$L(VAR) Q
 .S VAR=$TR(VAR,INSUBDEL,"")
 .;If required field is not present, display it and set error flag
 .I '$L(VAR) S INMSG="Missing required field "_SEGID_"("_I_")",ERR=1 D IO^INTSTR(INMSG)
 .;;for debugging only
 .I $D(DEBUG),$L(VAR) S INMSG="Required field "_SEGID_"("_I_") = "_VAR D IO^INTSTR(INMSG)
 ;Set <valid> piece in array
 S $P(UIFMES(UCNT),U,2)=$S(ERR:2,1:1) S:ERR INERR=1
 Q
 ;
 ;
 ;
