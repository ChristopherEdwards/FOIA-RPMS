ABME5N4 ; IHS/ASDST/DMJ - 837 N4 Segment 
 ;;2.6;IHS Third Party Billing System;**6,8**;NOV 12, 2009
 ;City/State/Zip
 ;
EP(X,Y) ;EP - START HERE
 ;x=file
 ;y=internal entry number
 K ABMREC("N4"),ABMR("N4")
 S:X=3 X=9000003.1
 S ABME("RTYPE")="N4"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:80 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("N4"))'="" S ABMREC("N4")=ABMREC("N4")_"*"
 .S ABMREC("N4")=$G(ABMREC("N4"))_ABMR("N4",I)
 Q
10 ;segment
 S ABMR("N4",10)="N4"
 Q
20 ;N401 - City Name
 I X=2 S ABMR("N4",20)=$P($G(^DPT(Y,.11)),"^",4)
 I X=4 S ABMR("N4",20)=$P($G(^DIC(4,Y,1)),"^",3)
 I X=9000003.1 S ABMR("N4",20)=$P($G(^AUPN3PPH(Y,0)),"^",11)
 I X=9999999.06 S ABMR("N4",20)=$P($G(^AUTTLOC(Y,0)),"^",13)
 I X=9999999.18 S ABMR("N4",20)=$P($G(^AUTNINS(Y,1)),"^",3)
 I X=9002274.35 S ABMR("N4",20)=$P($G(^AUTTVNDR($P($G(^ABMRLABS(Y,0)),U),13)),U,2)
 I X=200 S ABMR("N4",20)=$P($G(^VA(200,Y,.11)),U,4)
 I X="AMB",(Y="PU") S ABMR("N4",20)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,4)
 I X="AMB",(Y="DO") D
 .S ABMR("F")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";",2)
 .S ABMR("IEN")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";")
 .;start old code abm*2.6*8 HEAT45242
 .;I ABMR("F")["AUTNINS" S ABMR("N3",20)=$P($G(^AUTNINS(ABMR("IEN"),0)),U,3)
 .;I ABMR("F")["AUPNPAT" S ABMR("N3",20)=$P($G(^DPT(ABMR("IEN"),.11)),U,4)
 .;I ABMR("F")["AUTTLOC" S ABMR("N3",20)=$P($G(^DIC(4,ABMR("IEN"),1)),U,3)
 .;end old code start new code HEAT45242
 .;I ABMR("F")["AUTNINS" S ABMR("N4",20)=$P($G(^AUTNINS(ABMR("IEN"),0)),U,3)
 .I ABMR("F")["AUPNPAT" S ABMR("N4",20)=$P($G(^DPT(ABMR("IEN"),.11)),U,4)
 .I ABMR("F")["AUTTLOC" S ABMR("N4",20)=$P($G(^DIC(4,ABMR("IEN"),1)),U,3)
 .I ABMR("F")["AUTTVNDR" S ABMR("N4",20)=$P($G(^AUTTVNDR(ABMR("IEN"),13)),U,2)
 .;end new code HEAT45242
 Q
30 ;N402 - State or Province
 I X=2 S ABMR("N4",30)=$P($G(^DPT(Y,.11)),"^",5)
 I X=4 S ABMR("N4",30)=$P($G(^DIC(4,Y,0)),"^",2)
 I X=9000003.1 S ABMR("N4",30)=$P($G(^AUPN3PPH(Y,0)),"^",12)
 I X=9999999.06 S ABMR("N4",30)=$P($G(^AUTTLOC(Y,0)),"^",14)
 I X=9999999.18 S ABMR("N4",30)=$P($G(^AUTNINS(Y,1)),"^",4)
 I X=9002274.35 S ABMR("N4",30)=$P($G(^AUTTVNDR($P($G(^ABMRLABS(Y,0)),U),13)),U,3)
 I X=200 S ABMR("N4",30)=$P($G(^VA(200,Y,.11)),U,5)
 I X="AMB",(Y="PU") S ABMR("N4",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,5)
 I X="AMB",(Y="DO") D
 .S ABMR("F")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";",2)
 .S ABMR("IEN")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";")
 .;start old code abm*2.6*8 HEAT45242
 .;I ABMR("F")["AUTNINS" S ABMR("N3",20)=$P($G(^AUTNINS(ABMR("IEN"),0)),U,4)
 .;I ABMR("F")["AUPNPAT" S ABMR("N3",20)=$P($G(^DPT(ABMR("IEN"),.11)),U,5)
 .;I ABMR("F")["AUTTLOC" S ABMR("N3",20)=$P($G(^DIC(4,ABMR("IEN"),0)),U,2)
 .;end old code start new code HEAT45242
 .;I ABMR("F")["AUTNINS" S ABMR("N4",30)=$P($G(^AUTNINS(ABMR("IEN"),0)),U,4)
 .I ABMR("F")["AUPNPAT" S ABMR("N4",30)=$P($G(^DPT(ABMR("IEN"),.11)),U,5)
 .I ABMR("F")["AUTTLOC" S ABMR("N4",30)=$P($G(^DIC(4,ABMR("IEN"),0)),U,2)
 .I ABMR("F")["AUTTVNDR" S ABMR("N4",30)=$P($G(^AUTTVNDR(ABMR("IEN"),13)),U,3)
 .;end new codes HEAT45242
 S ABMR("N4",30)=$P($G(^DIC(5,+ABMR("N4",30),0)),"^",2)
 Q
40 ;N403 - Postal Code
 I X=2 S ABMR("N4",40)=$P($G(^DPT(Y,.11)),"^",6)
 I X=4 S ABMR("N4",40)=$P($G(^DIC(4,Y,1)),"^",4)
 I X=9000003.1 S ABMR("N4",40)=$P($G(^AUPN3PPH(Y,0)),"^",13)
 I X=9999999.06 S ABMR("N4",40)=$P($G(^AUTTLOC(Y,0)),"^",15)
 I X=9999999.18 S ABMR("N4",40)=$P($G(^AUTNINS(Y,1)),"^",5)
 I X=9002274.35 S ABMR("N4",40)=$P($G(^AUTTVNDR($P($G(^ABMRLABS(Y,0)),U),13)),U,4)
 I X=200 S ABMR("N4",40)=$P($G(^VA(200,Y,.11)),U,6)
 I X="AMB",(Y="PU") S ABMR("N4",40)=$P($G(^ABMDBILL(DUZ(2),Y,12)),U,6)
 I X="AMB",(Y="DO") D
 .S ABMR("F")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";",2)
 .S ABMR("IEN")=$P($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7),";")
 .;start old code abm*2.6*8 HEAT 45242
 .;I ABMR("F")["AUTNINS" S ABMR("N3",20)=$P($G(^AUTNINS(ABMR("IEN"),0)),U,5)
 .;I ABMR("F")["AUPNPAT" S ABMR("N3",20)=$P($G(^DPT(ABMR("IEN"),.11)),U,6)
 .;I ABMR("F")["AUTTLOC" S ABMR("N3",20)=$P($G(^DIC(4,ABMR("IEN"),1)),U,4)
 .;end old code start new code HEAT45242
 .I ABMR("F")["AUTNINS" S ABMR("N4",40)=$P($G(^AUTNINS(ABMR("IEN"),0)),U,5)
 .I ABMR("F")["AUPNPAT" S ABMR("N4",40)=$P($G(^DPT(ABMR("IEN"),.11)),U,6)
 .I ABMR("F")["AUTTLOC" S ABMR("N4",40)=$P($G(^DIC(4,ABMR("IEN"),1)),U,4)
 .;end new code HEAT45242
 S:(+ABMR("N4",40)'=0) ABMR("N4",40)=$$FMT^ABMERUTL($TR(ABMR("N4",40)," -"),"9N")
 Q
50 ;N404 - Country Code
 S ABMR("N4",50)=""
 Q
60 ;N405 - Location Qualifier
 S ABMR("N4",60)=""
 Q
70 ;N406 - Location Identifier
 S ABMR("N4",70)=""
 Q
80 ;N407 - Country Subdivision Code
 S ABMR("N4",80)=""
 Q
