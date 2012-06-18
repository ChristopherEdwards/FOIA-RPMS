ABME8BHT ; IHS/ASDST/DMJ - 837 BHT Segment    ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Beginning of Hierarchical Transaction
 ;
START ;START HERE
 K ABMREC("BHT"),ABMR("BHT")
 S ABME("RTYPE")="BHT"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:70 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("BHT"))'="" S ABMREC("BHT")=ABMREC("BHT")_"*"
 .S ABMREC("BHT")=$G(ABMREC("BHT"))_ABMR("BHT",I)
 Q
10 ;segment
 S ABMR("BHT",10)="BHT"
 Q
20 ;BHT01 - Hierarchical Structure Code
 S ABMR("BHT",20)="0019"
 Q
30 ;BHT02 - Transaction Set Purpose Code
 S ABMR("BHT",30)="00"
 Q
40 ;BHT03 - Reference Identification
 S ABMR("BHT",40)=$$TCN^ABMERUTL(ABMPXMIT)
 Q
50 ;BHT04 - Date
 S ABMR("BHT",50)=$$Y2KD2^ABMDUTL(DT)
 Q
60 ;BHT05 - Time
 D NOW^%DTC
 S ABMR("BHT",60)=$P(%,".",2)
 S ABMR("BHT",60)=$$FMT^ABMERUTL(ABMR("BHT",60),"4N")
 Q
70 ;BHT06 - Transaction Type Code
 S ABMR("BHT",70)="CH"
 Q
