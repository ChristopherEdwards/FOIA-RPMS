ABMEHGRV ; IHS/ASDST/DMJ - GET ANCILLARY SVCS REVENUE CODE INFO ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6,7**;NOV 12, 2009
 ;Original;DMJ;01/26/96 4:02 PM
 ; IHS/ASDS/DMJ - 09/06/00 - V2.4 Patch 3 (no NOIS)
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6 - Added code for new ambulance multiple 47
 ; IHS/SD/SDR - v2.5 p10 - IM20395 - Split out lines bundled by rev codes
 ; IHS/SD/SDR - v2.5 p11 - ambulance and pt stmt
 ;   Made change to getting ambulance line items.  Found it wasn't
 ;   working right when they were doing new pt stmt in patch 11.
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*6 - line item control number
 ;
START ;START HERE
 K ABM,ABMRV
 D P1
 ;D FLP
 Q
 ;
P1 ;EP - SET UP ABMRV ARRAY
 ; 21 - Med/Surg
 ; 23 - Pharmacy
 ; 25 - Room and Board
 ; 27 - Medical Procedures
 ; 33 - Dental
 ; 35 - Radiology
 ; 37 - Laboratory
 ; 39 - Anesthesia
 ; 43 - Miscellaneous Services
 ; 45 - Supplies
 ; 47 - Ambulance
 ; 
 ; if not flat rate .....
 D FRATE^ABMDF11
 I '$D(ABMP("FLAT")) D
 .N I
 .F I=21,23,25,27,33,35,37,39,43,45,47 D
 ..; dont get pharmacy if RX bill status is unbillable
 ..I $P($G(^AUTNINS(ABMP("INS"),2)),"^",3)="U",I=23 Q
 ..;this will make only viewable pages in CE show on bill, not everything
 ..I ABMP("VTYP")=998,((I'=33)&(I'=43)) Q  ;dental
 ..I ABMP("VTYP")=997,(I'=23) Q  ;pharmacy
 ..I ABMP("VTYP")=996,(I'=37) Q  ;lab
 ..I ABMP("VTYP")=995,(I'=35) Q  ;rad
 ..I ABMP("CLIN")="A3",((I'=43)&(I'=47)) Q  ;ambulance
 ..I ABMP("CLIN")'="A3",(I=47) Q
 ..K ABM
 ..D @(I_"^ABMEHGR2")  ; get ancillary services revenue code info
 ;
 I $P($G(^DIC(40.7,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,10),0)),U,2)="A3" D
 .S ABMODMOD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,14)_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,16)
 .S I=0
 .F  S I=$O(ABMRV(I)) Q:'I  D
 ..S J=""
 ..S J=$O(ABMRV(I,J)) Q:J=""  D
 ...S K=0
 ...F  S K=$O(ABMRV(I,J,K)) Q:K=""  D
 ....I $P(ABMRV(I,J,K),U,3)="Q" S ABMQLFLG=1
 .S I=0
 .F  S I=$O(ABMRV(I)) Q:'I  D
 ..S J=""
 ..F  S J=$O(ABMRV(I,J)) Q:J=""  D
 ...S K=0
 ...F  S K=$O(ABMRV(I,J,K)) Q:K=""  D
 ....I $G(ABMQLFLG)=1,($P(ABMRV(I,J,K),U,3)'="QL") S $P(ABMRV(I,J,K),U,3)=""
 ....I $G(ABMQLFLG)'=1 S $P(ABMRV(I,J,K),U,3)=$S($P($G(ABMRV(I,J,K)),U,3)="":ABMODMOD,1:$P(ABMRV(I,J,K),U,3)_":"_ABMODMOD)
 K ABMQLFLG
 ;
 ; if flat rate ....
 I $D(ABMP("FLAT")) D
 .N I
 .F I=1:1:3 S ABM(I)=$P(ABMP("FLAT"),"^",I)
 .S ABMRV(1,1,1)=+ABM(2)_"^^^^"_ABM(3)_"^"_(ABM(1)*ABM(3))_"^^"_ABM(1)
 .;S $P(ABMRV(1,1,1),U,12)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U,9)  ;abm*2.6*6 line item control number  ;abm*2.6*7 HEAT38591
 .S $P(ABMRV(1,1,1),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U,9)  ;abm*2.6*7 HEAT38591
 .S ABMCPT=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",16) I ABMCPT D
 ..S ABMCPT=$P($$CPT^ABMCVAPI(ABMCPT,ABMP("VDT")),U,2)  ;CSV-c
 ..S $P(ABMRV(1,1,1),U,2)=ABMCPT
 ..S $P(ABMRV(1,1,1),U,11)=1
 ..K ABMCDX
 ..Q:$G(ABMP("EXP"))'=11
 ..S $P(ABMRV(+ABM(2),"TOT"),U,2)=ABMCPT
 .S ABM(4)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6)
 .I ABM(4),ABMP("VTYP")=111 S $P(ABMRV(1,1,1),U,7)=(ABM(4)*ABM(1))
 .I ABMP("VTYP")=831 D
 ..K ABMRV(+ABM(2),0),ABM("831SET")
 ..N I
 ..F I=21,27,35 D @(I_"^ABMEHGR2")
 ..S I=0
 ..F  S I=$O(ABMRV(I)) Q:'I  D
 ...N J
 ...S J=0
 ...F  S J=$O(ABMRV(I,J)) Q:'J  D
 ....S K=0
 ....F  S K=$O(ABMRV(I,J,K)) Q:K=""  D
 .....S $P(ABMRV(I,J,K),U,6)=0
 .....S:'$G(ABM("831SET")) $P(ABMRV(I,J,K),U,6)=$P(ABMP("FLAT"),U),ABM("831SET")=1
 K ABMCPT
 Q
 ;
FLP ;FORMAT LOOP
 F J=5,6,7 S ABM("TOT",J)=0
 S I=0
 F  S I=$O(ABMRV(I)) Q:'I  D
 .D TOT
 .F J=1:1:9 D FMT
 .S ABMRV(I)=$TR(ABMRV(I),"^")
 S ABMRV(9999)="0001^^^^"_ABM("TOT",5)_"^"_ABM("TOT",6)_"^"_ABM("TOT",7)
 S ABMRV(9999,0)=ABMRV(9999)
 S I=9999
 F J=1:1:9 D FMT
 S ABMRV(9999)=$TR(ABMRV(9999),"^")
 K ABM
 Q
 ;
FMT ;Format
 S ABM(J)=$P(ABMRV(I),"^",J)
 I J>4&(J<8) S ABM("TOT",J)=ABM("TOT",J)+ABM(J)
 S ABM("FSTR")=$P("4NR^5^2^2^7NR^10NRJ2^10NRJ2^4^12","^",J)
 S ABM(J)=$$FMT^ABMERUTL(ABM(J),ABM("FSTR"))
 S $P(ABMRV(I),"^",J)=ABM(J)
 Q
 ;
TOT ;TOTAL TO REVENUE CODE
 S J=-1
 F  S J=$O(ABMRV(I,J)) Q:J=""  D
 .S $P(ABMRV(I),U)=I
 .F K=2,3,4 S $P(ABMRV(I),"^",K)=""
 .F K=5,6,7 S $P(ABMRV(I),"^",K)=$P(ABMRV(I),"^",K)+$P(ABMRV(I,J),"^",K)
 Q
