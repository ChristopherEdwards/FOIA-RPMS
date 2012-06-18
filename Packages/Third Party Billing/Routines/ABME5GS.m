ABME5GS ; IHS/ASDST/DMJ - 837 GS Segment 
 ;;2.6;IHS Third Party Billing System;**6,8**;NOV 12, 2009
 ;Functional Group Header
 ;
START ;START HERE
 K ABMREC("GS"),ABMR("GS")
 S ABME("RTYPE")="GS"
 S ABMSTCNT=1 ;5010 837P
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:90 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("GS"))'="" S ABMREC("GS")=ABMREC("GS")_"*"
 .S ABMREC("GS")=$G(ABMREC("GS"))_ABMR("GS",I)
 I '$D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D 837^ABMUTL8
 Q
10 ;segment
 S ABMR("GS",10)="GS"
 Q
20 ;GS01 - Functional Identifier Code
 S ABMR("GS",20)="HC"
 Q
30 ;GS02 - Application Sender's Code
 S ABMR("GS",30)=$$SNDR^ABMUTLP(ABMP("INS"),ABMP("VTYP"))
 Q
40 ;GS03 - Application Receiver's Code
 S ABMR("GS",40)=$$RCID^ABMUTLP(ABMP("INS"))
 Q
50 ;GS04 - Date
 S ABMR("GS",50)=$$Y2KD2^ABMDUTL(DT)
 Q
60 ;GS05 - Time
 D NOW^%DTC
 S ABMR("GS",60)=$P(%,".",2)
 S ABMR("GS",60)=$$FMT^ABMERUTL(ABMR("GS",60),"4N")
 Q
70 ;GS06 - Group Control Number
 S ABMR("GS",70)=$$TCN^ABMERUTL(ABMPXMIT)
 Q
80 ;GS07 - Responsible Agency Code
 S ABMR("GS",80)="X"
 Q
90 ;GS08 - Version/Release/Industry Identifier Code
 S ABMR("GS",90)=""
 S:ABMP("EXP")=32 ABMR("GS",90)="005010X222A1"
 S:ABMP("EXP")=31 ABMR("GS",90)="005010X223A2"
 S:ABMP("EXP")=33 ABMR("GS",90)="005010X224A2"
 Q
