ABME5CLM ; IHS/ASDST/DMJ - 837 CLM Segment 
 ;;2.6;IHS Third Party Billing System;**6,8**;NOV 12, 2009
 ;Health Claim
 ;
START ;EP - START HERE
 K ABMREC("CLM"),ABMR("CLM")
 S ABME("RTYPE")="CLM"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:210 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CLM"))'="" S ABMREC("CLM")=ABMREC("CLM")_"*"
 .S ABMREC("CLM")=$G(ABMREC("CLM"))_ABMR("CLM",I)
 Q
10 ;segment
 S ABMR("CLM",10)="CLM"
 Q
20 ;CLM01 - Claim Submitter's Identifier
 S ABMR("CLM",20)=ABMP("PCN")
 Q
30 ;CLM02 - Monetary Amount
 S ABMR("CLM",30)=$P(ABMB2,U)  ;bill amount
 I ABMPSQ'=1,(+$P(ABMB2,U,7)'=0) S ABMR("CLM",30)=$P(ABMB2,U,7)
 S ABMR("CLM",30)=$J(ABMR("CLM",30),0,2)
 Q
40 ;CLM03 - Claim Filing Indicator Code-not used
 S ABMR("CLM",40)=""
 Q
50 ;CLM04 - Non-Institutional Claim Type Code-not used
 S ABMR("CLM",50)=""
 Q
60 ;CLM05 - Health Care Service Location Information
 I ABMP("EXP")=31 D  ;837I
 .S ABMR("CLM",60)=$E(ABMP("BTYP"),1,2)
 .S $P(ABMR("CLM",60),":",2)="A"
 .S $P(ABMR("CLM",60),":",3)=$E(ABMP("BTYP"),3)
 I ABMP("EXP")'=31 D
 .S ABMR("CLM",60)=$$POS^ABMERUTL()
 .S $P(ABMR("CLM",60),":",2)="B"
 .S $P(ABMR("CLM",60),":",3)=1
 Q
70 ;CLM06 - Provider Signature on File
 ;S ABMR("CLM",70)="Y"  ;abm*2.6*8 5010
 S ABMR("CLM",70)=""  ;abm*2.6*8 5010
 S:ABMP("EXP")'=31 ABMR("CLM",70)="Y"  ;abm*2.6*8 5010
 Q
80 ;CLM07 - Provider Accept Assignment Code
 S ABMR("CLM",80)="A"
 Q
90 ;CLM08 - Assignment of Benefits Indicator
 S ABMR("CLM",90)=$P(ABMB7,"^",5)
 Q
100 ;CLM09 - Release of Information Code
 S ABMR("CLM",100)=$P(ABMB7,"^",4)
 I ABMR("CLM",100)'="Y" S ABMR("CLM",100)="I"
 Q
110 ;CLM10 - Patient Signature Source-not used
 S ABMR("CLM",110)=""
 Q
120 ;CLM11 - Related Causes Information
 I ABMP("EXP")=31 S ABMR("CLM",120)="" Q
 N X
 S X=$P(ABMB8,"^",3)
 I X="" S ABMR("CLM",120)="" Q
 S ABMR("CLM",120)=$S(X=1:"AA",X=4:"EM",1:"OA")
 I ABMR("CLM",120)="AA" D
 .S X=$P(^AUTTLOC(ABMP("LDFN"),0),"^",14)
 .S X=$P(^DIC(5,+X,0),"^",2)
 .S ABMR("CLM",120)="AA:::"_X
 Q
130 ;CLM12 - Special Programs Code
 I ABMP("EXP")=31 S ABMR("CLM",130)="" Q
 S ABMR("CLM",130)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,0))
 Q:ABMR("CLM",130)=""
 S ABMR("CLM",130)=$P($G(^ABMDCODE(ABMR("CLM",130),0)),U)
 Q
140 ;CLM13 - Yes/No-not used
 S ABMR("CLM",140)=""
 Q
150 ;CLM14 - Level of Service Code-not used
 S ABMR("CLM",150)=""
 Q
160 ;CLM15 - Yes/No-not used
 S ABMR("CLM",160)=""
 Q
170 ;CLM16 - Provider Agreement Code-not used
 S ABMR("CLM",170)=""
 Q
180 ;CLM17 - Claim Status Code-not used
 S ABMR("CLM",180)=""
 Q
190 ;CLM18 - Explanation of Benefits Indicator
 S ABMR("CLM",190)=""  ;abm*2.6*8 5010
 ;start old code abm*2.6*8 5010
 ;I ABMP("EXP")=21 D
 ;.S ABMR("CLM",190)="Y"
 ;I ABMP("EXP")'=21 D
 ;.S ABMR("CLM",190)=""
 ;end old code abm*2.6*8 5010
 Q
200 ;CLM19 - Claim Submission Reason Code-not used
 S ABMR("CLM",200)=""
 Q
210 ;CLM20 - Delay Reason Code
 S ABMR("CLM",210)=""
 S ABMDRC=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),"^",16)
 I ABMDRC'="" S ABMR("CLM",210)=$P($G(^ABMDCODE(ABMDRC,0)),"^")
 Q
