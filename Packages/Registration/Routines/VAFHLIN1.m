VAFHLIN1 ;ALB/KCL - CREATE HL7 INSURANCE (IN1) SEGMENT ; 12-SEPTEMBER-1997
 ;;5.3;Registration;**122,190**;Aug 13, 1993
 ;
 ;
 ;  This generic function was designed to return the HL7 IN1 (Insurance)
 ;  segment.  This segment contains VA-specific patient insurance
 ;  information. (All active insurance data for a patient including
 ;  those insurance carriers that do not reimburse the VA i.e Medicare)
 ;
EN(DFN,VAFSTR,VAFHLQ,VAFHLFS,VAFARRY) ; --
 ; Entry point to return HL7 IN1 segments.
 ;
 ;  Input:
 ;       DFN - internal entry number of the PATIENT (#2) file.
 ;    VAFSTR - (optional) string of fields requested seperated
 ;             by commas.  If not passed, return all data fields.
 ;    VAFHLQ - (optional) HL7 null variable.
 ;   VAFHLFS - (optional) HL7 field separator.
 ;   VAFARRY - (optional) user-supplied array name which will hold
 ;             HL7 IN1 segments.  Otherwise, ^TMP("VAFIN1",$J) will
 ;             be used.
 ;
 ; Output:
 ;      Array of HL7 IN1 segments
 ;
 N VAFGRP,VAFI,VAFIDX,VAFINS,VAFNODE,VAFPHN,VAFY,VAF36,X
 S VAFARRY=$G(VAFARRY),VAFIDX=0
 ;
 ; if VAFARRY not defined, use ^TMP("VAFIN1",$J)
 S:(VAFARRY="") VAFARRY="^TMP(""VAFIN1"",$J)"
 ;
 ; if VAFHLQ or VAFHLFS not passed, use default HL7 variables
 S VAFHLQ=$S($D(VAFHLQ):VAFHLQ,1:$G(HLQ)),VAFHLFS=$S($D(VAFHLFS):VAFHLFS,1:$G(HLFS))
 ;
 ; if DFN not passed, exit
 I '$G(DFN) S @VAFARRY@(1,0)="IN1"_VAFHLFS_1 G ENQ
 ;
 ; find all insurance data for a patient (IB SUPPORTED CALL)
 D ALL^IBCNS1(DFN,"VAFINS",2)
 ;
 ; if no active insurance on file for patient, build IN1
 I '$G(VAFINS(0)) S VAFINS(1)=0
 ;
ALL ; get all active insurance for patient
 F VAFI=0:0 S VAFI=$O(VAFINS(VAFI)) Q:'VAFI  D
 .;
 .; - zero node of (#2.312) mult. of Patient (#2) file
 .;   and, zero node of the Group Ins. Plan (#355.3) file
 .S VAFNODE=$G(VAFINS(VAFI,0)),VAFGRP=$G(VAFINS(VAFI,355.3))
 .;
 .; - zero node and (.13) node of Insurance Company (#36) file
 .S VAF36=$G(^DIC(36,+VAFNODE,0)),VAFPHN=$G(^(.13))
 .;
 .; - build array of HL7 (IN1) segments
 .D BUILD
 ;
ENQ Q
 ;
 ;
BUILD ; Build array of HL7 (IN1) segments
 S $P(VAFY,VAFHLFS,36)="",VAFIDX=VAFIDX+1
 ;
 ; if VAFSTR not passed, return all data fields
 I $G(VAFSTR)']"" S VAFSTR="4,5,7,8,9,12,13,15,16,17,28,36"
 S VAFSTR=","_VAFSTR_","
 ;
 ; sequential number (required field)
 S $P(VAFY,VAFHLFS,1)=VAFIDX
 ;
 ; build HL7 (IN1) segment fields
 I VAFSTR[",3," S $P(VAFY,VAFHLFS,3)=+VAFNODE ;Insurance company IEN (P-190)
 I VAFSTR[",4," S $P(VAFY,VAFHLFS,4)=$S($P(VAF36,"^")]"":$P(VAF36,"^"),1:VAFHLQ) ; Insurance Carrier Name
 I VAFSTR[",5," S X=$$ADDR(+VAFNODE) S $P(VAFY,VAFHLFS,5)=$S(+X>0:X,1:VAFHLQ)
 I VAFSTR[",7," S X=$$HLPHONE^HLFNC($P(VAFPHN,"^")) S $P(VAFY,VAFHLFS,7)=$S(X]"":X,1:VAFHLQ) ; Insurance Co. Phone Number
 I VAFSTR[",8," S $P(VAFY,VAFHLFS,8)=$S($P(VAFGRP,"^",4)]"":$P(VAFGRP,"^",4),1:VAFHLQ) ; Group Number
 I VAFSTR[",9," S $P(VAFY,VAFHLFS,9)=$S($P(VAFGRP,"^",3)]"":$P(VAFGRP,"^",3),1:VAFHLQ) ; Group Name
 I VAFSTR[",12," S X=$$HLDATE^HLFNC($P(VAFNODE,"^",8)) S $P(VAFY,VAFHLFS,12)=$S(X]"":X,1:VAFHLQ) ; Policy Effective Date
 I VAFSTR[",13," S X=$$HLDATE^HLFNC($P(VAFNODE,"^",4)) S $P(VAFY,VAFHLFS,13)=$S(X]"":X,1:VAFHLQ) ; Policy Expiration Date
 I VAFSTR[",15," S $P(VAFY,VAFHLFS,15)=$S($P(VAFGRP,"^",9)]"":$P(VAFGRP,"^",9),1:VAFHLQ) ; Plan Type (ptr. to Type of Plan (#355.1) file)
 I VAFSTR[",16," S $P(VAFY,VAFHLFS,16)=$S($P(VAFNODE,"^",17)]"":$P(VAFNODE,"^",17),1:VAFHLQ) ; Name of Insured
 I VAFSTR[",17," S $P(VAFY,VAFHLFS,17)=$S($P(VAFNODE,"^",6)]"":$P(VAFNODE,"^",6),1:VAFHLQ) ; Whose Insurance
 I VAFSTR[",28," S $P(VAFY,VAFHLFS,28)=$S($P(VAFGRP,"^",6)]"":$P(VAFGRP,"^",6),1:VAFHLQ) ; Is Pre-Certification Required?
 I VAFSTR[",36," S $P(VAFY,VAFHLFS,36)=$S($P(VAFNODE,"^",2)]"":$P(VAFNODE,"^",2),1:VAFHLQ) ; Subscriber ID
 ;
 ; set all active insurance policies into array
 S @VAFARRY@(VAFIDX,0)="IN1"_VAFHLFS_$G(VAFY)
 Q
 ;
 ;
ADDR(VAFPTR) ; Format insurance company address for HL7 conversion
 ;
 ;  Input:  
 ;    VAFPTR - pointer to Insurance Co. (#36) file 
 ;
 ; Output:
 ;    String in the form of the HL7 address field
 ;
 N VAFAD,VAFADDR,VAFGL,VAFST
 S VAFAD=""
 ;
 ; get (.11) node of Insurance Co. (#36) file
 S VAFADDR=$G(^DIC(36,+VAFPTR,.11))
 ;
 ; 1st & 2nd street address lines
 F VAFST=1,2 S VAFAD=VAFAD_"^"_$P(VAFADDR,"^",VAFST)
 S VAFAD=$P(VAFAD,"^",2,99)
 S VAFGL=$P(VAFADDR,"^",4) ; city
 S VAFGL=VAFGL_"^"_$P(VAFADDR,"^",5) ; state
 S VAFGL=VAFGL_"^"_$P(VAFADDR,"^",6) ; zip
 ;
 ; convert DHCP address to HL7 format using HL7 utility
 Q $$HLADDR^HLFNC(VAFAD,VAFGL)
