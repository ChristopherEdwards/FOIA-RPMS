ABMDE8X2 ; IHS/SD/SDR - Page 8 - ERROR CHECKS ; 
 ;;2.6;IHS Third Party Billing System;**13**;NOV 12, 2009;Build 213
 ;
D2 ;EP - this next section compares entries in V Med vs 23 multiple; will
 ;display warning if entry in V Med that's not in 23 multiple
 ;build array of V Med entries by drug with count of occurances
 ;  ABMMEDS(V MED IEN)=  P1=# OF V MED ENTRIES
 ;                       P2=# OF 23 MULTIPLE ENTRIES
 ;                       P3=DATE DISCONTINUED
 ;                       P4=RETURN TO STOCK DATE
 S ABMVIEN=0
 K ABMMEDS
 F  S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVIEN)) Q:+ABMVIEN=0  D
 .S ABMVDFN=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVIEN,0)),U)
 .S ABM=0
 .F  S ABM=$O(^AUPNVMED("AD",ABMVDFN,ABM)) Q:'ABM  D
 ..I $P($G(^AUPNVMED(ABM,0)),U)'="" D
 ...S ABMMEDS($P(^AUPNVMED(ABM,0),U))=+$G(ABMMEDS($P(^AUPNVMED(ABM,0),U)))+1
 ...S $P(ABMMEDS($P(^AUPNVMED(ABM,0),U)),U,3)=$P($G(^AUPNVMED(ABM,0)),U,8)  ;date disc.
 ...S $P(ABMMEDS($P(^AUPNVMED(ABM,0),U)),U,4)=$P($G(^PSDRUG($P($G(^AUPNVMED(ABM,0)),U),2)),U,15)  ;RTS
 ;build array of 23-multiple entries by drug with count of occurances
 S ABMVIEN=0
 F  S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMVIEN)) Q:+ABMVIEN=0  D
 .S ABMVDATA=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMVIEN,0)),U)
 .S $P(ABMMEDS(ABMVDATA),U,2)=$P(+$G(ABMMEDS(ABMVDATA)),U,2)+1
 ;now compare p1 and p2; p1 must be < or = p2
 S ABMVIEN=0,ABMVFLG=0
 K ABME(213)
 F  S ABMVIEN=$O(ABMMEDS(ABMVIEN)) Q:+ABMVIEN=0  D
 .K ABMVMED,ABM23M
 .S ABMVMED=$P(ABMMEDS(ABMVIEN),U)
 .S ABM23M=$P(ABMMEDS(ABMVIEN),U,2)
 .Q:ABMVMED=ABM23M
 .Q:ABM23M>ABMVMED
 .S ABMVFLG=1
 I $G(ABMVFLG)=1 S ABME(213)=""
 K ABMVFLG,ABMVIEN,ABMVMED,ABM23M
 Q
