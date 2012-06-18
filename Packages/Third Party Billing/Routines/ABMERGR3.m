ABMERGR3 ; IHS/ASDST/DMJ - GET ANCILLARY SVCS REVENUE CODE INFO ; 
 ;;2.6;IHS Third Party Billing;**1,3,6,8**;NOV 12, 2009
 ;Original;DMJ;03/20/96 9:07 AM
 ;
 ; IHS/SD/SDR - v2.5 p9 - split routine for size
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by Rev code
 ; IHS/SD/SDR - v2.5 p10 - IM21539
 ;   Made anes amt just use base charge
 ; IHS/SD/SDR - v2.5 p12 - IM24093
 ;   Put description in array if J-code
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6566 - Populate anes based on MCR/non-MCR
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12742 - Correction to MCR/non-MCR; removed all HEAT6566 changes
 ; IHS/SD/SDR - abm2.6*6 - 5010 - added 5010 prompts to 43 multiple
 ;
37 ;EP - Laboratory
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA)) Q:'DA  D
 .F J=1:1:8 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(6)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(7)  ;2nd modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,8)=ABM(4)  ;Unit Charge
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(5)  ;Date/Time
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(8)  ;3rd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
39 ;EP - Anesthesia
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA)) Q:'DA  D
 .F J=1:1:6,11,14,19 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,0),"^",J)
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(6)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(14)  ;2nd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=1  ;units
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*1 HEAT6566
 .;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*1 HEAT6566  abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))="R")!($G(ABMP("ITYPE"))="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))="R")!($G(ABMP("ITYPE"))="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(3)+ABM(4)  ;charges  ;abm*2.6*1 HEAT6566abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(3)+ABM(4)  ;charges  ;abm*2.6*3 HEAT12742
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(5)  ;Date/time of service
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(19)  ;3rd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,18)=ABM(11)  ;Other Provider
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
 ;
43 ;EP - Miscellaneous Services
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA)) Q:'DA  D
 .F J=1:1:9 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(8)  ;2nd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,8)=ABM(4)  ;Unit Charge
 .I $E($P($$CPT^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,0)),U),ABMP("VDT")),U,2),1)="J" D  ;CSV-c
 ..S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,9)=$P($$CPT^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,0)),U),ABMP("VDT")),U,3)  ;description for J-codes only ;CSV-c
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(7)  ;date/time
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(9)  ;3rd Modifier
 .;start new code abm*2.6*6 5010
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,1)) $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,33)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,1)  ;QTY/LENGTH MEDICAL NECESSITY
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,2)) $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,34)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,2)  ;MONETARY AMT/DME RENTAL PRICE
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,3)) $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,35)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,3)  ;MONETARY AMT/DME PURCH. PRICE
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,4)) $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,36)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,4)  ;FRQ CODE/RENTAL UNIT PRICE IND
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,5)) $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,37)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,5)  ;immun. batch
 .;end new code 5010
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
45 ;EP - Supplies
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),45,DA)) Q:'DA  D
 .F J=1:1:7 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),45,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .I ABM(5)="" S ABM(5)=270
 .S ABM(7)=$P($$CPT^ABMCVAPI(+ABM(7),ABMP("VDT")),U,2)  ;CSV-c
 .S:ABM(7)="" ABM(7)=0
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S ABMRV(ABM(5),ABM(7),ABMLCNT)=ABM(5)  ;Revenue code
 .S $P(ABMRV(ABM(5),ABM(7),ABMLCNT),U,2)=ABM(7)  ;CPT Code
 .S $P(ABMRV(ABM(5),ABM(7),ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(ABM(5),ABM(7),ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(ABM(5),ABM(7),ABMLCNT),U,10)=ABM(2)
 .S $P(ABMRV(ABM(5),ABM(7),ABMLCNT),U,8)=ABM(4)
 .S $P(ABMRV(ABM(5),ABM(7),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),45,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
47 ;EP - Ambulance Services
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA)) Q:'DA  D
 .F J=1:1:9 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(8)  ;2nd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,8)=ABM(4)  ;Unit Charge
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(7)  ;date/time
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(9)  ;3rd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
