SCMSVPID ;ALB/ESD HL7 PID Segment Validation ; 23 Oct 98  3:36 PM
 ;;5.3;Scheduling;**44,66,162,254**;Aug 13, 1993
 ;
 ;
EN(PIDSEG,HLQ,HLFS,HLECH,VALERR,ENCDT,EVNTHL7) ;
 ; Entry point to return the HL7 PID (Patient ID) validation segment
 ;
 ;  Input:  PIDSEG  - Array containing PID segment (pass by ref)
 ;                    PIDSEG = First 245 characters
 ;                    PIDSEG(1..n) = Continuation nodes
 ;             HLQ  - HL7 null variable
 ;            HLFS  - HL7 field separator
 ;           HLECH  - HL7 encoding characters
 ;          VALERR  - The array name to put the errors in
 ;           ENCDT  - The date/time of the encounter.
 ;         EVNTHL7  - Event type ("A08" for add/edit, "A23" for delete)
 ;
 ; Output:  1 if PID passed validity check
 ;          Error message if PID failed validity check in form of:
 ;          -1^"xxx failed validity check" (xxx=element in PID segment)
 ;
 ;Declare variables
 N MSG,SEQ,DFN,STATE,SD,PARSEG,SEG
 S PARSEG=$NA(^TMP("SCMSVPID",$J,"PARSEG"))
 K @PARSEG
 S MSG="-1^Element in PID segment failed validity check"
 ;-Set encoding chars to standard HL7 encoding chars if not passed in
 S HLECH=$G(HLECH)
 S:HLECH="" HLECH="~|\&"
 ;-Create array of elements to validate
 F SEQ=3,5,7,8,10,11,12,16,17,19,22 S SD(SEQ)=""  ;Elements for 'add' or 'edit' transactions
 I $G(EVNTHL7)="A23" K SD F I=3,19 S SD(SEQ)=""  ;Elements for 'delete' transactions
 ;
 S SEG="PID"
 D VALIDATE^SCMSVUT0(SEG,$G(PIDSEG),"0006",VALERR,.CNT)
 I $D(@VALERR@(SEG)) G ENQ
 ;-Parse out fields
 D SEGPRSE^SCMSVUT5(.PIDSEG,PARSEG,HLFS)
 ;-Remember DFN
 S DFN=$G(@PARSEG@(3))
 ;-Validate segment name
 S CNT=1
 D VALIDATE^SCMSVUT0(SEG,$G(@PARSEG@(0)),$P($T(0),";",3),VALERR,.CNT)
 ;-Validate fields
 S SEQ=0
 F  S SEQ=+$O(SD(SEQ)) Q:'SEQ  D
 .S DATA=$$CONVERT^SCMSVUT0($G(@PARSEG@(SEQ)),HLFS,HLQ)
 .I SEQ=11 D ADDRCHK($G(@PARSEG@(11)),SEG,VALERR,.CNT,.STATE) Q
 .I (SEQ=10)!(SEQ=22) D  Q
 ..N PARSEQ,REP,COMP
 ..S PARSEQ=$NA(^TMP("SCMSVPID",$J,"PARSEQ"))
 ..K @PARSEQ
 ..D SEQPRSE^SCMSVUT5($G(@PARSEG@(SEQ)),PARSEQ,HLECH)
 ..S REP=0
 ..F  S REP=+$O(@PARSEQ@(REP)) Q:'REP  D
 ...S DATA=$$CONVERT^SCMSVUT0($G(@PARSEQ@(REP,1)),HLFS,HLQ)
 ...D VALIDATE^SCMSVUT0(SEG,$P(DATA,$E(HLECH,1),1),$P($T(@(SEQ)),";",3),VALERR,.CNT)
 ..K @PARSEQ
 .S:SEQ=3 DATA=$P(DATA,$E(HLECH,1,1),1)
 .S:SEQ=5 DATA=$$FMNAME^HLFNC(DATA)
 .S:SEQ=7 DATA=$$FMDATE^HLFNC(DATA)
 .D VALIDATE^SCMSVUT0(SEG,DATA,$P($T(@(SEQ)),";",3),VALERR,.CNT)
 ;
ENQ K @PARSEG
 Q $S($D(@VALERR@(SEG,1)):MSG,1:1)
 ;
 ;
ADDRCHK(PIDADDR,SEG,VALERR,CNT,STATE) ;- Validity chk for street addr 1, city, state, zip
 ;
 N LP
 F LP=111,112,113,114,115 DO
 .D VALIDATE^SCMSVUT0(SEG,$P(PIDADDR,$E(HLECH,1),$E(LP,3,3)),$P($T(@(LP)),";",3),VALERR,.CNT)
 .I LP=114 S STATE=$P(PIDADDR,$E(HLECH,1),4) I STATE]"" S STATE=+$O(^DIC(5,"C",STATE,""))
 .Q
 Q
 ;
 ;
 ;
ERR ;;Invalid or missing patient ID data for encounter (HL7 PID data segment)
 ;
 ;
 ;- PID data elements validated
 ;
0 ;;0035;HL7 SEGMENT NAME
3 ;;2030;PATIENT ID (INTERNAL)
5 ;;2000;NAME
7 ;;2050;DATE OF BIRTH
8 ;;2100;SEX
10 ;;2150;RACE
111 ;;2200;STREET ADDRESS 1
112 ;;2210;STREET ADDRESS 2
113 ;;2220;CITY
114 ;;2230;STATE
115 ;;2240;ZIP CODE
12 ;;2250;COUNTY CODE
16 ;;2300;MARITAL STATUS
17 ;;2330;RELIGION
19 ;;2360;SSN
22 ;;2380;ETHNICITY
