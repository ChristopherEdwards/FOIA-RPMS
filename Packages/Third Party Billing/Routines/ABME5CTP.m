ABME5CTP ; IHS/SD/SDR - 837 CTP Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
EP ;EP - START HERE
 K ABMREC("CTP"),ABMR("CTP")
 S ABME("RTYPE")="CTP"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:120 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CTP"))'="" S ABMREC("CTP")=ABMREC("CTP")_"*"
 .S ABMREC("CTP")=$G(ABMREC("CTP"))_ABMR("CTP",I)
 Q
10 ;segment
 S ABMR("CTP",10)="CTP"
 Q
20 ;CTP01 - Class of Trade Code - NOT USED
 S ABMR("CTP",20)=""
 Q
30 ;CTP02 - Price Identifier Code - NOT USED
 S ABMR("CTP",30)=""
 Q
40 ;CTP03 - Unit Price - NOT USED
 S ABMR("CTP",40)=""
 Q
50 ;CTP04 - Quantity
 S ABMR("CTP",50)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5)
 Q
60 ;CTP05 - Composite Unit of Measure
 ;CTP05-1 - Unit Or Basis for Measurement Code
 ;CTP05-2 - Exponent - not used
 ;CTP05-3 - Multiplier - not used
 S ABMR("CTP",60)="UN"
 Q
70 ;CTP06 - Price Multiplier Qualifier - NOT USED
 S ABMR("CTP",70)=""
 Q
80 ;CTP07 - Multiplier - NOT USED
 S ABMR("CTP",80)=""
 Q
90 ;CTP08 - Monetary Amount - NOT USED
 S ABMR("CTP",90)=""
 Q
100 ;CTP09 - Basis of Unit Price Code - NOT USED
 S ABMR("CTP",100)=""
 Q
110 ;CTP10 - Condition Value - NOT USED
 S ABMR("CTP",110)=""
 Q
120 ;CTP11 - Multiple Price Quantity - NOT USED
 S ABMR("CTP",120)=""
 Q
