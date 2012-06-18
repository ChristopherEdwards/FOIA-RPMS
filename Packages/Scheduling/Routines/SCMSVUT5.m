SCMSVUT5 ;BPFO/JRP - IEMM UTILTIES (CONT);7/29/2002
 ;;5.3;Scheduling;**254**;Aug 13, 1993
SEGPRSE(SEGMENT,OUTARR,FS)      ;Parse HL7 segment by field separator
 ;Input  : SEGMENT - Array containing HL7 segment to parse (pass by ref)
 ;                   SEGMENT = First 245 characters of segment
 ;                   SEGMENT(1..n) = Continuation nodes
 ;                        OR
 ;                   SEGMENT(x) = First 245 characters of segment
 ;                   SEGMENT(x,1..n) = Continuation nodes
 ;         OUTARR - Array to put parsed segment into (full global ref)
 ;         FS - HL7 field separator (defaults to ^) (1 character)
 ;Output : None
 ;         OUTARR(0) = Segment name
 ;         OUTARR(seq#) = Data
 ;Notes  : OUTARR is initialized (KILLed) on entry
 ;       : Assumes no sequence is longer than 245 characters
 ;
 ;Declare variables
 N SEQ,NODE,STOP,DATA,INFO,I,L
 K @OUTARR
 S FS=$G(FS,"^") S FS=$E(FS,1) S:FS="" FS="^"
 S SEQ=0
 S NODE=$NA(SEGMENT)
 S INFO=$G(@NODE)
 S I=1
 S L=$L(INFO,FS)
 S STOP=0
 F  S DATA=$P(INFO,FS,I) D  Q:STOP
 .I I=L D  Q
 ..S @OUTARR@(SEQ)=$G(@OUTARR@(SEQ))_DATA
 ..S NODE=$Q(@NODE)
 ..I NODE="" S STOP=1 Q
 ..S INFO=$G(@NODE)
 ..S L=$L(INFO,FS)
 ..S I=1
 .S @OUTARR@(SEQ)=$G(@OUTARR@(SEQ))_DATA
 .S SEQ=SEQ+1
 .S I=I+1
 Q
 ;
SEQPRSE(SEQDATA,OUTARR,ENCODE)  ;Parse HL7 sequence by component
 ;Input  : SEQDATA - Sequence (field) to parse
 ;         OUTARR - Array to put parsed sequence into (full global ref)
 ;         ENCODE - HL7 encoding characters (defaults to ~|\&) (4 chars)
 ;Output : None
 ;         OUTARR(rep#,comp#)
 ;Notes  : OUTARR is initialized (KILLed) on entry
 ;
 ;Declare variables
 N RS,CS,INFO,DATA,REP,COMP
 K @OUTARR
 S ENCODE=$G(ENCODE,"~|\&")
 S ENCODE=$E(ENCODE,1,4) S:$L(ENCODE)'=4 ENCODE="~|\&"
 S CS=$E(ENCODE,1)
 S RS=$E(ENCODE,2)
 F REP=1:1:$L(SEQDATA,RS) S INFO=$P(SEQDATA,RS,REP) D
 .F COMP=1:1:$L(INFO,CS) S @OUTARR@(REP,COMP)=$P(INFO,CS,COMP)
 Q
