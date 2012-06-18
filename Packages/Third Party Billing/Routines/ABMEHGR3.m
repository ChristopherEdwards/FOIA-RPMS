ABMEHGR3 ; IHS/ASDST/DMJ - GET ANCILLARY SVCS REVENUE CODE INFO ;     
 ;;2.6;IHS Third Party Billing;**1,3,6**;NOV 12, 2009
 ;Original;DMJ;03/20/96 9:07 AM
 ;
 ; IHS/SD/SDR - v2.5 p9 -split routine from ABMEHGR2
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split lines bundled by rev code
 ; IHS/SD/SDR - v2.5 p10 - IM21539
 ;   Changed anes amt to just use base charge
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6566 - populate anes based on MCR vs non-MCR
 ; IHS/SD/SDR - abm*2.6*1 - HEAT8498 - Use start/stop time, not service dates for anes
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12742 - Correction to MCR/non-MCR; removed 6566 changes
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added prompts for SV5 segment
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added test date to 37 multiple
 ;
35 ;EP - Radiology
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA)) Q:'DA  D
 .F J=1:1:10,12 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(35,DA,ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(35,DA,ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(35,DA,ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(35,DA,ABMLCNT),U,4)=ABM(6)  ;2nd Modifier
 .S $P(ABMRV(35,DA,ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(35,DA,ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(35,DA,ABMLCNT),U,11)=ABM(8)  ;corresponding dx
 .S $P(ABMRV(35,DA,ABMLCNT),U,12)=ABM(7)  ;3rd Modifier
 .S $P(ABMRV(35,DA,ABMLCNT),U,10)=ABM(9)  ;service date
 .S ABM(13)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,"P","C","R",0))  ;rendering provider
 .I +$G(ABM(13))'=0 S $P(ABMRV(35,DA,ABMLCNT),U,13)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,"P",ABM(13),0)),U)
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,"P","C","D",0))  ;ordering provider
 .I +$G(ABM(21))'=0 S $P(ABMRV(35,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,"P",ABM(21),0)),U)
 .S $P(ABMRV(35,DA,ABMLCNT),U,25)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,0)),U,15)
 .S $P(ABMRV(35,DA,ABMLCNT),U,26)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,0)),U,16)
 .S $P(ABMRV(35,DA,ABMLCNT),U,27)=$S($G(ABM(12))'="":ABM(12),1:ABM(9))
 .S $P(ABMRV(35,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
37 ;EP - Laboratory
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA)) Q:'DA  D
 .F J=1:1:9,12 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0),U,J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(37,DA,ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(37,DA,ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(37,DA,ABMLCNT),U,3)=ABM(6)  ;Modifier
 .S $P(ABMRV(37,DA,ABMLCNT),U,4)=ABM(7)  ;2nd modifier
 .S $P(ABMRV(37,DA,ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(37,DA,ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(37,DA,ABMLCNT),U,11)=ABM(9)  ;corresponding dx
 .S $P(ABMRV(37,DA,ABMLCNT),U,12)=ABM(8)  ;3rd Modifier
 .S ABM(13)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,"P","C","R",0))  ;rendering provider
 .I +$G(ABM(13))'=0 S $P(ABMRV(37,DA,ABMLCNT),U,14)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,"P",ABM(13),0)),U)
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,"P","C","D",0))  ;ordering provider
 .I +$G(ABM(21))'=0 S $P(ABMRV(37,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,"P",ABM(21),0)),U)
 .S $P(ABMRV(37,DA,ABMLCNT),U,25)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0)),U,15)  ;HCFA POS
 .S $P(ABMRV(37,DA,ABMLCNT),U,26)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0)),U,16)  ;HCFA TOS
 .S $P(ABMRV(37,DA,ABMLCNT),U,27)=$S($G(ABM(12))'="":ABM(12),1:ABM(5))  ;service to date/time
 .S $P(ABMRV(37,DA,ABMLCNT),U,34)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0)),U,21)  ;Test date  ;abm*2.6*6 5010
 .S $P(ABMRV(37,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
39 ;EP - Anesthesia
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA)) Q:'DA  D
 .F J=1:1:10 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,0),"^",J)
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(39,DA,ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(39,DA,ABMLCNT),U,2)=ABM(1)  ;CPT code
 .S $P(ABMRV(39,DA,ABMLCNT),U,3)=ABM(6)  ;Modifier
 .S $P(ABMRV(39,DA,ABMLCNT),U,5)=1  ;units
 .S $P(ABMRV(39,DA,ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*1 HEAT6566
 .;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S $P(ABMRV(39,DA,ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*1 HEAT6566  abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))="R")!($G(ABMP("ITYPE"))="R") S $P(ABMRV(39,DA,ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))="R")!($G(ABMP("ITYPE"))="R") S $P(ABMRV(39,DA,ABMLCNT),U,6)=ABM(3)+ABM(4)  ;charges  ;abm*2.6*1 HEAT6566 abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S $P(ABMRV(39,DA,ABMLCNT),U,6)=ABM(3)+ABM(4)  ;charges  ;abm*2.6*3 HEAT12742
 .;S $P(ABMRV(39,DA,ABMLCNT),U,10)=ABM(5)  ;Date/time of service  ;abm*2.6*1 HEAT8498
 .S $P(ABMRV(39,DA,ABMLCNT),U,10)=ABM(7)  ;date/time from service date  ;abm*2.6*1 HEAT8498
 .S $P(ABMRV(39,DA,ABMLCNT),U,11)=ABM(10)  ;Corresponding DX
 .S ABM(13)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,"P","C","R",0))  ;rendering provider
 .I +$G(ABM(13))'=0 S $P(ABMRV(39,DA,ABMLCNT),U,13)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,"P",ABM(13),0)),U)
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,"P","C","D",0))  ;ordering provider
 .I +$G(ABM(21))'=0 S $P(ABMRV(39,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,"P",ABM(21),0)),U)
 .S $P(ABMRV(39,DA,ABMLCNT),U,25)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,0)),U,15)
 .S $P(ABMRV(39,DA,ABMLCNT),U,26)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,0)),U,16)
 .S $P(ABMRV(39,DA,ABMLCNT),U,27)=ABM(8)  ;date/time to service date  ;abm*2.6*1 HEAT8498
 .S ABMMTS=$$FMDIFF^XLFDT(ABM(8),ABM(7),2)
 .S ABMMTS=ABMMTS\60
 .S $P(ABMRV(39,DA,ABMLCNT),U,16)=ABMMTS
 .S $P(ABMRV(39,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 .K ABMMTS
 Q
 ;
43 ;EP - Miscellaneous Services
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA)) Q:'DA  D
 .F J=1:1:9,12 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,0),U,J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(43,DA,ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(43,DA,ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(43,DA,ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(43,DA,ABMLCNT),U,4)=ABM(8)  ;2nd Modifier
 .S $P(ABMRV(43,DA,ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(43,DA,ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(43,DA,ABMLCNT),U,10)=ABM(7)  ;Service from date/time
 .S $P(ABMRV(43,DA,ABMLCNT),U,11)=ABM(6)  ;corresponding dx
 .S $P(ABMRV(43,DA,ABMLCNT),U,12)=ABM(9)  ;3rd Modifier
 .S ABM(13)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,"P","C","R",0))  ;rendering provider
 .I +$G(ABM(13))'=0 S $P(ABMRV(43,DA,ABMLCNT),U,13)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,"P",ABM(13),0)),U)
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,"P","C","D",0))  ;ordering provider
 .I +$G(ABM(21))'=0 S $P(ABMRV(43,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,"P",ABM(21),0)),U)
 .S $P(ABMRV(43,DA,ABMLCNT),U,25)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,0)),U,15)
 .S $P(ABMRV(43,DA,ABMLCNT),U,26)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,0)),U,16)
 .S $P(ABMRV(43,DA,ABMLCNT),U,27)=$S($G(ABM(12))'="":ABM(12),1:ABM(7))  ;service to date/time
 .;start new code abm*2.6*6 5010
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,1)) $P(ABMRV(43,DA,ABMLCNT),U,33)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,1)
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,2)) $P(ABMRV(43,DA,ABMLCNT),U,34)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,2)
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,3)) $P(ABMRV(43,DA,ABMLCNT),U,35)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,3)
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,4)) $P(ABMRV(43,DA,ABMLCNT),U,36)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,4)
 .S:+($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,5)) $P(ABMRV(43,DA,ABMLCNT),U,37)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,1)),U,5)  ;immun. batch#6
 .;end new code 5010
 .S $P(ABMRV(43,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,DA,2)),U)  ;abm*2.6*6 5010 line item control number
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
 .S ABMRV(45,DA,ABMLCNT)=ABM(5)  ;Revenue code
 .S $P(ABMRV(45,DA,ABMLCNT),U,2)=ABM(7)  ;CPT Code
 .S $P(ABMRV(45,DA,ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(45,DA,ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(45,DA,ABMLCNT),U,10)=ABM(2)
 .S $P(ABMRV(45,DA,ABMLCNT),U,8)=ABM(4)
 .S $P(ABMRV(45,DA,ABMLCNT),U,11)=ABM(6)  ;corresponding dx
 .S $P(ABMRV(45,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),45,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
47 ;EP - Ambulance Services
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA)) Q:'DA  D
 .F J=1:1:9,12 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA,0),U,J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(47,DA,ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(47,DA,ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(47,DA,ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(47,DA,ABMLCNT),U,4)=ABM(8)  ;2nd Modifier
 .S $P(ABMRV(47,DA,ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(47,DA,ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(47,DA,ABMLCNT),U,11)=ABM(6)  ;corresponding dx
 .S $P(ABMRV(47,DA,ABMLCNT),U,12)=ABM(9)  ;3rd Modifier
 .S $P(ABMRV(47,DA,ABMLCNT),U,25)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA,0)),U,15)
 .S $P(ABMRV(47,DA,ABMLCNT),U,26)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA,0)),U,16)
 .S $P(ABMRV(47,DA,ABMLCNT),U,27)=$S($G(ABM(12))'="":ABM(12),1:ABM(7))  ;service to date/time
 .S $P(ABMRV(47,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),47,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
