ABME5PER ; IHS/ASDST/DMJ - 837 PER Segment [ 09/15/2003  3:40 PM ]
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Administrative Communications Contact
 ;  
START ;START HERE
 K ABMREC("PER"),ABMR("PER")
 S ABME("RTYPE")="PER"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:100 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("PER"))'="" S ABMREC("PER")=ABMREC("PER")_"*"
 .S ABMREC("PER")=$G(ABMREC("PER"))_ABMR("PER",I)
 Q
10 ;segment
 S ABMR("PER",10)="PER"
 Q
20 ;PER01 - Contact Function Code
 S ABMR("PER",20)="IC"
 Q
30 ;PER02 - Name
 S ABMR("PER",30)="BUSINESS OFFICE"
 Q
40 ;PER03 - Communication Number Qualifier
 S ABMR("PER",40)="TE"
 Q
50 ;PER04 - Communication Number
 S ABMR("PER",50)=$P($G(^AUTTLOC(DUZ(2),0)),"^",11)
 S ABMR("PER",50)=$TR(ABMR("PER",50),".-() ")
 Q
60 ;PER05 - Communication Number Qualifier
 S ABMR("PER",60)=""
 Q
70 ;PER06 - Communication Number
 S ABMR("PER",70)=""
 Q
80 ;PER07 - Communication Number Qualifier
 S ABMR("PER",80)=""
 Q
90 ;PER08 - Communication Number
 S ABMR("PER",90)=""
 Q
100 ;PER09 - Contact Inquiry Reference
 S ABMR("PER",100)=""
 Q
