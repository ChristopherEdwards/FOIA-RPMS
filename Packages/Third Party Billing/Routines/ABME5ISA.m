ABME5ISA ; IHS/ASDST/DMJ - 837 ISA Segment 
 ;;2.6;IHS Third Party Billing System;**6,8**;NOV 12, 2009
 ;Interchange Control Header
 ;
START ;START HERE
 K ABMREC("ISA"),ABMR("ISA")
 S ABME("RTYPE")="ISA"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:170 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("ISA"))'="" S ABMREC("ISA")=ABMREC("ISA")_"*"
 .S ABMREC("ISA")=$G(ABMREC("ISA"))_ABMR("ISA",I)
 I '$D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D 837^ABMUTL8
 Q
10 ;segment
 S ABMR("ISA",10)="ISA"
 Q
20 ;ISA01 - Authorization Information Qualifier 
 S ABMR("ISA",20)="00"
 Q
30 ;ISA02 - Authorization Information
 S ABMR("ISA",30)=""
 S ABMR("ISA",30)=$$FMT^ABMERUTL(ABMR("ISA",30),10)
 Q
40 ;ISA03 - Security Information Qualifier
 S ABMR("ISA",40)="00"
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),"^",3)'="" D
 .S ABMR("ISA",40)="01"
 Q
50 ;ISA04 - Security Information
 S ABMR("ISA",50)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),"^",3)
 S ABMR("ISA",50)=$$FMT^ABMERUTL(ABMR("ISA",50),10)
 Q
60 ;ISA05 - Interchange ID Qualifier
 S ABMR("ISA",60)="ZZ"
 Q
70 ;ISA06 - Interchange Sender ID
 S ABMR("ISA",70)=$$SNDR^ABMUTLP(ABMP("INS"),ABMP("VTYP"))
 S ABMR("ISA",70)=$$FMT^ABMERUTL(ABMR("ISA",70),15)
 Q
80 ;ISA07 - Interchange ID Qualifier
 S ABMR("ISA",80)="ZZ"
 S:$$RCID^ABMUTLP(ABMP("INS"))="C00900" ABMR("ISA",80)=27
 S:$$RCID^ABMUTLP(ABMP("INS"))="04402" ABMR("ISA",80)=27
 S:$G(ABMPITYP)="P" ABMR("ISA",80)=33
 ;start new code abm*2.6*8
 I $D(^ABMRECVR("C",ABMP("INS"))) D
 .S ABMCHIEN=$O(^ABMRECVR("C",ABMP("INS"),0))
 .S:ABMCHIEN ABMR("ISA",80)=$P($G(^ABMRECVR(ABMCHIEN,0)),U,5)
 ;end new code
 Q
90 ;ISA08 - Interchange Receiver ID
 S ABMR("ISA",90)=$$RCID^ABMUTLP(ABMP("INS"))
 S ABMR("ISA",90)=$$FMT^ABMERUTL(ABMR("ISA",90),15)
 Q
100 ;ISA09 - Interchange Date
 S ABMR("ISA",100)=$E($$Y2KD2^ABMDUTL(DT),3,8)
 Q
110 ;ISA10 - Interchange Time
 D NOW^%DTC
 S ABMR("ISA",110)=$P(%,".",2)
 S ABMR("ISA",110)=$$FMT^ABMERUTL(ABMR("ISA",110),"4N")
 Q
120 ;ISA11 - Interchange Repetition Separator
 S ABMR("ISA",120)="^"
 Q
130 ;ISA12 - Interchange Control Version Number
 S ABMR("ISA",130)="00501"
 Q
140 ;ISA13 - Interchange Control Number
 S ABMR("ISA",140)=$$TCN^ABMERUTL(ABMPXMIT)
 S ABMR("ISA",140)=$$FMT^ABMERUTL(ABMR("ISA",140),"9NR")
 Q
150 ;ISA14 - Acknowledgement Requested
 S ABMR("ISA",150)="1"
 Q
160 ;ISA15 - Usage Indicator
 S ABMR("ISA",160)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),"^",4)
 S:ABMR("ISA",160)="" ABMR("ISA",160)="P"
 Q
170 ;ISA16 - Component Element Separator
 S ABMR("ISA",170)=":"
 Q
