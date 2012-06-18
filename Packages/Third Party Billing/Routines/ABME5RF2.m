ABME5RF2 ; IHS/ASDST/DMJ - 837 REF Segment [ 02/04/2003  11:07 AM ]
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;other payer provider info
 ;  
EP(X,Y) ;EP
 K ABMREC("REF"),ABMR("REF")
 S ABMEIC=X
 S ABME("RTYPE")="REF"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:50 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("REF"))'="" S ABMREC("REF")=ABMREC("REF")_"*"
 .S ABMREC("REF")=$G(ABMREC("REF"))_ABMR("REF",I)
 Q
10 ;segment
 S ABMR("REF",10)="REF"
 Q
20 ;REF01 - Reference Identification Qualifier
 S ABMR("REF",20)=ABMEIC
 Q
30 ;REF02 - Reference Identification
 S ABMR("REF",30)=$G(ABMPNBR)
 Q
40 ;REF03 - Description-not used
 S ABMR("REF",40)=""
 Q
50 ;REF04 - Reference Identifier-not used
 S ABMR("REF",50)=""
 Q
