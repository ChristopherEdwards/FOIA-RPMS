ABME5TOO ; IHS/ASDST/DMJ - 837 TOO Segment 
 ;;2.6;IHS Third Party Billing System;**6,19**;NOV 12, 2009;Build 300
 ;Tooth Identification
 ;IHS/SD/SDR - 2.6*19 - HEAT180453 - Updated TOO02 for some of the codes being sent, mostly the ones with 'X' or 'Q'
 ;  as the final character.
 ;
 ;EP - START HERE
 K ABMREC("TOO"),ABMR("TOO")
 S ABME("RTYPE")="TOO"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("TOO"))'="" S ABMREC("TOO")=ABMREC("TOO")_"*"
 .S ABMREC("TOO")=$G(ABMREC("TOO"))_ABMR("TOO",I)
 Q
10 ;segment
 S ABMR("TOO",10)="TOO"
 Q
20 ;TOO01 - Code List Qualifier Code
 S ABMR("TOO",20)="JP"
 Q
30 ;TOO02 - Tooth Number
 N I
 S I=$P(ABMRV(ABMI,ABMJ,ABMK),U,23)
 S ABMR("TOO",30)=$G(^ADEOPS(+I,88))
 ;start new abm*2.6*19 IHS/SD/SDR HEAT180453
 I ABMR("TOO",30)="MND" S ABMR("TOO",30)="02"
 I ABMR("TOO",30)="MAX" S ABMR("TOO",30)="01"
 I ABMR("TOO",30)="OT" S ABMR("TOO",30)="09"
 I ABMR("TOO",30)="LLQ" S ABMR("TOO",30)="30"
 I ABMR("TOO",30)="LRQ" S ABMR("TOO",30)="40"
 I ABMR("TOO",30)="ULQ" S ABMR("TOO",30)="20"
 I ABMR("TOO",30)="URQ" S ABMR("TOO",30)="10"
 I ABMR("TOO",30)="LAX" S ABMR("TOO",30)="07"
 I ABMR("TOO",30)="LLX" S ABMR("TOO",30)="06"
 I ABMR("TOO",30)="LRX" S ABMR("TOO",30)="08"
 I ABMR("TOO",30)="UAX" S ABMR("TOO",30)="04"
 I ABMR("TOO",30)="ULX" S ABMR("TOO",30)="05"
 I ABMR("TOO",30)="URX" S ABMR("TOO",30)="03"
 ;end new abm*2.6*19 IHS/SD/SDR HEAT180453
 Q
40 ;TOO03 - Tooth Surface
 N I,J
 S I=$P(ABMRV(ABMI,ABMJ,ABMK),U,24)
 I I="" S ABMR("TOO",40)="" Q
 F J=1:1:$L(I) D
 .S $P(ABMR("TOO",40),":",J)=$E(I,J)
 Q
