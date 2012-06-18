ABME8N4 ; IHS/ASDST/DMJ - 837 N4 Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;City/State/Zip
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM12246/IM17548
 ;    Added code for Service Facility (9002274.35)
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    use point of pickup city/st/zip if ambulance
 ;
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;   Added code for ordering provider address
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
 F I=10:10:70 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("N4"))'="" S ABMREC("N4")=ABMREC("N4")_"*"
 .S ABMREC("N4")=$G(ABMREC("N4"))_ABMR("N4",I)
 Q
10 ;segment
 S ABMR("N4",10)="N4"
 Q
20 ;N401 - City Name
 I X=2 D
 .S ABMR("N4",20)=$P($G(^DPT(Y,.11)),"^",4)
 I X=4 D
 .S ABMR("N4",20)=$P($G(^DIC(4,Y,1)),"^",3)
 I X=9000003.1 D
 .S ABMR("N4",20)=$P($G(^AUPN3PPH(Y,0)),"^",11)
 I X=9999999.06 D
 .S ABMR("N4",20)=$P($G(^AUTTLOC(Y,0)),"^",13)
 I X=9999999.18 D
 .S ABMR("N4",20)=$P($G(^AUTNINS(Y,1)),"^",3)
 I X=9002274.35 D
 .S ABMR("N4",20)=$P($G(^AUTTVNDR($P($G(^ABMRLABS(Y,0)),U),13)),U,2)
 I X=9002274.4 D
 .S ABMR("N4",20)=$P($G(^ABMDBILL(DUZ(2),Y,12)),U,4)
 I X=200 D
 .S ABMR("N4",20)=$P($G(^VA(200,Y,.11)),U,4)
 Q
30 ;N402 - State or Province
 I X=2 D
 .S ABMR("N4",30)=$P($G(^DPT(Y,.11)),"^",5)
 I X=4 D
 .S ABMR("N4",30)=$P($G(^DIC(4,Y,0)),"^",2)
 I X=9000003.1 D
 .S ABMR("N4",30)=$P($G(^AUPN3PPH(Y,0)),"^",12)
 I X=9999999.06 D
 .S ABMR("N4",30)=$P($G(^AUTTLOC(Y,0)),"^",14)
 I X=9999999.18 D
 .S ABMR("N4",30)=$P($G(^AUTNINS(Y,1)),"^",4)
 I X=9002274.4 D
 .S ABMR("N4",30)=$P($G(^ABMDBILL(DUZ(2),Y,12)),U,5)
 I X=9002274.35 D
 .S ABMR("N4",30)=$P($G(^AUTTVNDR($P($G(^ABMRLABS(Y,0)),U),13)),U,3)
 I X=200 D
 .S ABMR("N4",30)=$P($G(^VA(200,Y,.11)),U,5)
 S ABMR("N4",30)=$P($G(^DIC(5,+ABMR("N4",30),0)),"^",2)
 Q
40 ;N403 - Postal Code
 I X=2 D
 .S ABMR("N4",40)=$P($G(^DPT(Y,.11)),"^",6)
 I X=4 D
 .S ABMR("N4",40)=$P($G(^DIC(4,Y,1)),"^",4)
 I X=9000003.1 D
 .S ABMR("N4",40)=$P($G(^AUPN3PPH(Y,0)),"^",13)
 I X=9999999.06 D
 .S ABMR("N4",40)=$P($G(^AUTTLOC(Y,0)),"^",15)
 I X=9999999.18 D
 .S ABMR("N4",40)=$P($G(^AUTNINS(Y,1)),"^",5)
 I X=9002274.35 D
 .S ABMR("N4",40)=$P($G(^AUTTVNDR($P($G(^ABMRLABS(Y,0)),U),13)),U,4)
 I X=9002274.4 D
 .S ABMR("N4",40)=$P($G(^ABMDBILL(DUZ(2),Y,12)),U,6)
 I X=200 D
 .S ABMR("N4",40)=$P($G(^VA(200,Y,.11)),U,6)
 S ABMR("N4",40)=$TR(ABMR("N4",40)," -")
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
