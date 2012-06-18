ABME5LIN ; IHS/SD/SDR - 837 LIN Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
EP ;EP - START HERE
 K ABMREC("LIN"),ABMR("LIN")
 S ABME("RTYPE")="LIN"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:320 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("LIN"))'="" S ABMREC("LIN")=ABMREC("LIN")_"*"
 .S ABMREC("LIN")=$G(ABMREC("LIN"))_ABMR("LIN",I)
 Q
10 ;segment
 S ABMR("LIN",10)="LIN"
 Q
20 ;LIN01 - Assigned Identification - NOT USED
 S ABMR("LIN",20)=""
 Q
30 ;LIN02 - Product/Service ID Qualifier
 S ABMR("LIN",30)="N4"
 Q
40 ;LIN03 - Product/Service ID
 S ABMR("LIN",40)=$P(ABMRV(ABMI,ABMJ,ABMK),U,15)
 Q
50 ;LIN04 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",50)=""
 Q
60 ;LIN05 - Product/Service ID - NOT USED
 S ABMR("LIN",60)=""
 Q
70 ;LIN06 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",70)=""
 Q
80 ;LIN07 - Product/Service ID - NOT USED
 S ABMR("LIN",80)=""
 Q
90 ;LIN08 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",90)=""
 Q
100 ;LIN09 - Product/Service ID - NOT USED
 S ABMR("LIN",100)=""
 Q
110 ;LIN10 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",110)=""
 Q
120 ;LIN11 - Product/Service ID - NOT USED
 S ABMR("LIN",120)=""
 Q
130 ;LIN12 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",130)=""
 Q
140 ;LIN13 - Product/Service ID - NOT USED
 S ABMR("LIN",140)=""
 Q
150 ;LIN14 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",150)=""
 Q
160 ;LIN15 - Product/Service ID - NOT USED
 S ABMR("LIN",160)=""
 Q
170 ;LIN16 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",170)=""
 Q
180 ;LIN17 - Product/Service ID - NOT USED
 S ABMR("LIN",180)=""
 Q
190 ;LIN18 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",190)=""
 Q
200 ;LIN19 - Product/Service ID - NOT USED
 S ABMR("LIN",200)=""
 Q
210 ;LIN20 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",210)=""
 Q
220 ;LIN21 - Product/Service ID - NOT USED
 S ABMR("LIN",220)=""
 Q
230 ;LIN22 - Product/Service ID Qualifier - NOT USED
 S ABMR("LIN",230)=""
 Q
240 ;LIN23 - Product/Service ID - NOT USED
 S ABMR("LIN",240)=""
 Q
250 ;LIN24 - Product/Service ID Qualifier - NOT USED
 S ABMR("LIN",250)=""
 Q
260 ;LIN25 - Product/Service ID - NOT USED
 S ABMR("LIN",260)=""
 Q
270 ;LIN26 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",270)=""
 Q
280 ;LIN27 - Product/Service ID - NOT USED
 S ABMR("LIN",280)=""
 Q
290 ;LIN28 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",290)=""
 Q
300 ;LIN29 - Product/Service ID - NOT USED
 S ABMR("LIN",300)=""
 Q
310 ;LIN30 - Product Service ID Qualifier - NOT USED
 S ABMR("LIN",310)=""
 Q
320 ;LIN31 - Product/Service ID - NOT USED
 S ABMR("LIN",320)=""
 Q
