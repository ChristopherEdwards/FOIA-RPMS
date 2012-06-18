ABME5PWK ; IHS/ASDST/DMJ - 837 PWK Segment 
 ;;2.6;IHS Third Party Billing;**6,8**;NOV 12, 2009
 ;Transaction Set Header
 ;  
START ;START HERE
 K ABMREC("PWK"),ABMR("PWK")
 S ABME("RTYPE")="PWK"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:100 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("PWK"))'="" S ABMREC("PWK")=ABMREC("PWK")_"*"
 .S ABMREC("PWK")=$G(ABMREC("PWK"))_ABMR("PWK",I)
 Q
10 ;segment
 S ABMR("PWK",10)="PWK"
 Q
20 ;PWK01 - Report Type Code
 S ABMR("PWK",20)=$P($G(^ABMDCODE($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,ABM71IEN,0)),U),0)),U)  ;abm*2.6*1 HEAT6439 ;5010 837p  ;abm*2.6*8
 ;S ABMR("PWK",20)="EB" ;5010 837P  ;abm*2.6*8
 Q
30 ;PWK02 - Report Transmission Code
 S ABMR("PWK",30)="" ;5010 837P  ;abm*2.6*8
 S ABMR("PWK",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,ABM71IEN,0)),U,2)  ;abm*2.6*1 HEAT6439 ;5010 837p  ;abm*2.6*8
 ;S ABMR("PWK",30)="FT" ;5010 837P  ;abm*2.6*8
 Q
40 ;PWK03 - Report Copies Needed-not used
 S ABMR("PWK",40)=""
 Q
50 ;PWK04 - Entity Identifier Code-not used
 S ABMR("PWK",50)=""
 Q
60 ;PWK05 - Identification Code Qualifier
 S ABMR("PWK",60)=""
 S ABMR("PWK",60)="AC"  ;abm*2.6*1 HEAT6439  ;abm*2.6*2 ;5010 837p  ;abm*2.6*8
 S ABMR("PWK",30)="FT" ;5010 837P  ;abm*2.6*8
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,ABM71IEN,0)),U,3)'="" S ABMR("PWK",60)="AC"  ;abm*2.6*2 ;5010 837p  ;abm*2.6*8
 ;S ABMR("PWK",30)="FT" ;5010 837P
 Q
70 ;PWK06 - Identification Code
 S ABMR("PWK",70)=""
 S ABMR("PWK",70)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,ABM71IEN,0)),U,3)  ;abm*2.6*1 HEAT6439 ;5010 837P  ;abm*2.6*8
 Q
80 ;PWK07 - Description
 S ABMR("PWK",80)=""
 Q
90 ;PWK08 - Actions Indicated-not used
 S ABMR("PWK",90)=""
 Q
100 ;PWK09 - Request Category Code-not used
 S ABMR("PWK",100)=""
 Q
