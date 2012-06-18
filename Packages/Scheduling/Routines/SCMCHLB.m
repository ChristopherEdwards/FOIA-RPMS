SCMCHLB ;BP/DJB - PCMM HL7 Bld Segment Array ; 3/2/00 2:12pm
 ;;5.3;Scheduling;**177,204,210,224**;AUG 13, 1993
 ;
BUILD(VARPTR,HL,XMITARRY) ;Build an array of HL7 segments based on EVENT
 ;POINTER field in PCMM HL7 EVENT file (#404.48).
 ;
 ;Input:
 ;     VARPTR   - EVENT POINTER field in PCMM HL7 EVENT file.
 ;     HL       - Array of HL7 variables (pass by reference).
 ;                Output of call to INIT^HLFNC2().
 ;     XMITARRY - Array to store HL7 segments (full global ref).
 ;                Default=^TMP("HLS",$J)
 ;Output:
 ;     XMITARRY(n,segment) array of segments.
 ;        Examples:
 ;           ^TMP("PCMM","HL7",$J,2290,"PID")...= PID segment
 ;           ^TMP("PCMM","HL7",$J,2290,"ZPC",ID)= ZPC segments
 ;     -1^Error = Unable to build message / bad input
 ;
 ;Note: The calling program must initialize (i.e. KILL) XMITARRY.
 ;
 ;Declare variables
 NEW RESULT,SCIEN,SCGLB
 NEW HLECH,HLEID,HLFS,HLQ
 ;
 ;Convert VARPTR (ien;global) to SCIEN & SCGLB
 S RESULT=$$CHECK^SCMCHLB1($G(VARPTR))
 ;
 I 'RESULT Q "-1^Did not pass valid variable pointer"
 ;
 ;Initialize HL7 variables
 S HLECH=HL("ECH")
 S HLFS=HL("FS")
 S HLQ=HL("Q")
 ;
 I RESULT=2 D  G QUIT ;........................Process a deletion
 . I SCGLB="SCPT(404.43," D PTP^SCMCHLB2 Q  ;..Delete - File 404.43
 . I SCGLB="SCTM(404.52," D POS^SCMCHLB2 Q  ;..Delete - File 404.52
 . I SCGLB="SCTM(404.53," D PRE^SCMCHLB2 Q  ;..Delete - File 404.53
 I SCGLB="SCPT(404.43," D PTP(SCIEN) G QUIT ;..File 404.43
 I SCGLB="SCTM(404.52," D POS G QUIT ;.........File 404.52
 I SCGLB="SCTM(404.53," D PRE G QUIT ;.........File 404.53
QUIT Q 1
 ;
 ;==================================================================
 ;
PTP(PTPI) ;Patient Team Position Assignment (#404.43).
 ;Input: PTPI - Patient Team Position Assignment IEN
 ;
 ;To keep VISTA and NPCD in sync, for this PT TM POS ASSIGN send
 ;down a delete for all previous entries, and then send down data
 ;for current valid entries.
 ;
 ;NEW DFN,ERROR,ND,ZDATE,ZPTP
 ;djb/bp Added SCSEQ per Patch 210, replace above line with below line
 NEW DFN,ERROR,ND,SCSEQ,ZDATE,ZPTP
 ;
 ;Get data
 S ND=$G(^SCPT(404.43,PTPI,0))
 S DFN=$$DFN^SCMCHLB1(ND) Q:'DFN  ;..Patient
 ;
 ;Get only valid entries for this PT TM POS ASSIGN. This call returns
 ;provider array for a patient team position assignment.
 ;Example: ZPTP(8944,"AP","8944-909-0-AP")=data
 ;         ZPTP(8944,"PCP","8944-911-157-PCP")=data
 KILL ZPTP
 D SETDATE ;Set date array
 S RESULT=$$PRPTTPC^SCAPMC(PTPI,"ZDATE","ZPTP","ERROR","",1)
 ;
 ;If no valid history don't build any segments
 Q:'$D(ZPTP)
 ;
 ;Build EVN & PID segments
 D SEGMENTS^SCMCHLB1(DFN,PTPI)
 ;
 ;Generate deletes for all ID's starting with this PT TM POS ASSIGN.
 D PTPD^SCMCHLB2(PTPI)
 ;
 ;Build data type ZPC segments.
 D ZPC^SCMCHLB1(.ZPTP)
 ;alb/rpm;Patch 224 Decrement max msg counter
 I $D(SCLIMIT) S SCLIMIT=SCLIMIT-1
 Q
 ;
POS ;Position Assign History (#404.52)
 ;
 ;To keep VISTA and NPCD in sync, for every primary care entry in Pt
 ;Tm Pos Assign for this TEAM POSITION, send down all valid entries.
 ;
 NEW TMPOS,TP
 ;
 ;Team Position pointer
 S TMPOS=$P($G(^SCTM(404.52,SCIEN,0)),U,1)
 Q:'TMPOS
 ;
 ;Get History entries for each PT TM POS ASSIGN
 D POS1(TMPOS)
 ;
 ;What if this TEAM POSITION is also a preceptor? Find every TEAM
 ;POSITION being precepted by this TEAM POSITION and for each, find
 ;every PT TM POS ASSIGN and send down all valid History entries.
 ;
 S TP=0
 F  S TP=$O(^SCTM(404.53,"AD",TMPOS,TP)) Q:'TP  D POS1(TP)
 Q
 ;
POS1(TMPOS) ;Find every primary care PT TM POS ASSIGN for this TEAM POSITION
 ;and get all valid History entries.
 ;Input:
 ;   TMPOS - TEAM POSITION pointer
 ;
 Q:'$G(TMPOS)
 NEW IFN,ND,TM
 ;
 S TM=0
 F  S TM=$O(^SCPT(404.43,"APTPA",TMPOS,TM)) Q:'TM  D  ;
 . S IFN=0
 . F  S IFN=$O(^SCPT(404.43,"APTPA",TMPOS,TM,IFN)) Q:'IFN  D  ;
 .. S ND=$G(^SCPT(404.43,IFN,0))
 .. Q:($P(ND,U,5)'=1)  ;..Must be Primary Care
 .. D PTP(IFN) ;..........Bld segments for this PT TM POS ASSIGN
 Q
 ;
PRE ;Preceptor Assign History (#404.53)
 ;
 ;Get TEAM POSITION pointer of preceptee. Find every primary care
 ;PT TM POS ASSIGN for this TEAM POSITION and send down all valid
 ;History entries.
 ;
 NEW TMPOS
 ;
 ;Preceptee TEAM POSITION pointer
 S TMPOS=$P($G(^SCTM(404.53,SCIEN,0)),U,1)
 Q:'TMPOS
 D POS1(TMPOS) ;Get History entries for each PT TM POS ASSIGN
 ;
 ;Preceptor TEAM POSITION pointer
 S TMPOS=$P($G(^SCTM(404.53,SCIEN,0)),U,6)
 Q:'TMPOS
 D POS1(TMPOS) ;Get History entries for each PT TM POS ASSIGN
 Q
 ;
SETDATE ;Set all encompassing date array
 S ZDATE("BEGIN")=2800101
 S ZDATE("END")=9991231
 S ZDATE("INCL")=0
 Q
