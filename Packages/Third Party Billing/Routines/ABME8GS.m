ABME8GS ; IHS/ASDST/DMJ - 837 GS Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Functional Group Header
 ;
START ;START HERE
 K ABMREC("GS"),ABMR("GS")
 S ABME("RTYPE")="GS"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:90 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("GS"))'="" S ABMREC("GS")=ABMREC("GS")_"*"
 .S ABMREC("GS")=$G(ABMREC("GS"))_ABMR("GS",I)
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
 S:ABMP("EXP")=21 ABMR("GS",90)="004010X096A1"
 S:ABMP("EXP")=22 ABMR("GS",90)="004010X098A1"
 S:ABMP("EXP")=23 ABMR("GS",90)="004010X097A1"
 Q
