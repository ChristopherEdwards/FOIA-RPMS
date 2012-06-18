ABME5CL1 ; IHS/ASDST/DMJ - 837 CL1 Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("CL1"),ABMR("CL1")
 S ABME("RTYPE")="CL1"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:50 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CL1"))'="" S ABMREC("CL1")=ABMREC("CL1")_"*"
 .S ABMREC("CL1")=$G(ABMREC("CL1"))_ABMR("CL1",I)
 Q
10 ;segment
 S ABMR("CL1",10)="CL1"
 Q
20 ;CL101 - Admission Type Code
 N X
 S X=$P(ABMB5,U)
 S X=$P($G(^ABMDCODE(+X,0)),U)
 S:+X X=+X
 S:X=0 X=""
 S ABMR("CL1",20)=X
 Q
30 ;CL102 - Admission Source Code
 N X
 S X=$P(ABMB5,"^",2)
 S X=$P($G(^ABMDCODE(+X,0)),U)
 S:+X X=+X
 S:X=0 X=""
 S ABMR("CL1",30)=X
 Q
40 ;CL103 - Patient Status Code
 N X
 S X=$P(ABMB5,"^",3)
 S X=$P($G(^ABMDCODE(+X,0)),U)
 S ABMR("CL1",40)=X
 S ABMR("CL1",40)=$$FMT^ABMERUTL(ABMR("CL1",40),"2NR")
 Q
50 ;CL104 - Nursing Home Residential Status Code-not used
 S ABMR("CL1",50)=""
 Q
