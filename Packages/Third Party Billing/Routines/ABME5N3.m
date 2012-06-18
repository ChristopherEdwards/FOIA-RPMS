ABME5N3 ; IHS/ASDST/DMJ - 837 N3 Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Address Information
 ;
EP(X,Y) ;EP - START HERE
 ;x=file number
 ;y=ien
 K ABMREC("N3"),ABMR("N3")
 S:X=3 X=9000003.1
 S ABME("RTYPE")="N3"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:30 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("N3"))'="" S ABMREC("N3")=ABMREC("N3")_"*"
 .S ABMREC("N3")=$G(ABMREC("N3"))_ABMR("N3",I)
 Q
10 ;segment
 S ABMR("N3",10)="N3"
 Q
20 ;N301 - Address 1
 S ABMR("N3",20)=""
 I X=2 S ABMR("N3",20)=$$TRIM^ABMUTLP($P($G(^DPT(Y,.11)),U),"R"," ")
 I X=4 S ABMR("N3",20)=$P($G(^DIC(4,Y,1)),U)
 I X=9000003.1 S ABMR("N3",20)=$$TRIM^ABMUTLP($P($G(^AUPN3PPH(Y,0)),U,9),"R"," ")
 I X=9999999.06 S ABMR("N3",20)=$P($G(^AUTTLOC(Y,0)),"^",12)
 I X=9999999.18 S ABMR("N3",20)=$P($G(^AUTNINS(Y,1)),"^",2)
 I X=9002274.35 S ABMR("N3",20)=$P($G(^AUTTVNDR($P($G(^ABMRLABS(Y,0)),U),13)),U)
 I X=200 S ABMR("N3",20)=$P($G(^VA(200,Y,.11)),U)
 I X="AMB",(Y="PU") S ABMR("N3",20)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,3)
 I X="AMB",(Y="DO") D
 .S ABMR("F")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";",2)
 .S ABMR("IEN")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";")
 .I ABMR("F")["AUTNINS" S ABMR("N3",20)=$P($G(^AUTNINS(ABMR("IEN"),0)),U,2)
 .I ABMR("F")["AUPNPAT" S ABMR("N3",20)=$P($G(^DPT(ABMR("IEN"),.11)),U)
 .I ABMR("F")["AUTTLOC" S ABMR("N3",20)=$P($G(^DIC(4,ABMR("IEN"),1)),U)
 Q
30 ;N302 - Address 2
 S ABMR("N3",30)=""
 I X=2 D
 .S ABMR("N3",30)=$P($G(^DPT(Y,.11)),"^",2)
 I X=4 D
 .S ABMR("N3",30)=$P($G(^DIC(4,Y,1)),"^",2)
 Q
