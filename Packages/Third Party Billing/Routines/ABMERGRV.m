ABMERGRV ; IHS/ASDST/DMJ - GET ANCILLARY SVCS REVENUE CODE INFO ;   
 ;;2.6;IHS Third Party Billing;**1,8**;NOV 12, 2009
 ;Original;DMJ;01/26/96 4:02 PM
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for new ambulance multiple 47
 ; IHS/SD/SDR - v2.5 p9 - IM18857
 ;    Added code to print FL45
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;  Split out lines bundled by rev code
 ; IHS/SD/SDR - v2.5 p10 - IM20396
 ;   Made change to fix covered days amount when there aren't
 ;   any covered days
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT5691 - Correction for covered days
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6395 - allow dental codes to print on UB
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7884 -
 ;
 ; *********************************************************************
 ;
START ;START HERE
 K ABM,ABMRV
 D ORV
 D P1
 D FLP
 Q
 ;
ORV ; EP
 ; OTHER REVENUE CODE
 ; ABMRV(IEN to REVENUE CODE,0) = IEN to REVENUE CODE ^ ^ ^ ^ 1 ^
 ;           Revenue charge ^ ^ Revenue charge
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),"^",7) D
 .S ABMRV(+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),9),U,7),0,1)=$P(^(9),U,7)_"^^^^1^"_$P(^(9),U,8)_"^^"_$P(^(9),U,8)
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
 I '$D(ABMP("FLAT")) D
 .N I
 .F I=21,23,25,27,33,35,37,39,43,45,47 D
 ..; dont get pharmacy if RX bill status is unbillable
 ..I $P($G(^AUTNINS(ABMP("INS"),2)),"^",3)="U",I=23 Q
 ..;this will make only viewable pages in CE show on bill, not everything
 ..;I ABMP("VTYP")=998,((I'=21)&(I'=25)&(I'=27)&(I'=39)&(I'=45)&(I'=47)) Q  ;dental  ;abm*2.6*1 HEAT6395
 ..I ABMP("VTYP")=997,(I'=23) Q  ;pharmacy
 ..I ABMP("VTYP")=996,(I'=37) Q  ;lab
 ..I ABMP("VTYP")=995,(I'=35) Q  ;rad
 ..I $G(ABMP("CLIN"))="A3",((I'=43)&(I'=47)) Q  ;ambulance
 ..D @(I_"^ABMERGR2")  ; get ancillary services revenue code info
 ;
 I $P($G(^DIC(40.7,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,10),0)),U,2)="A3" D
 .S ABMODMOD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,14)_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,16)
 .S I=0
 .F  S I=$O(ABMRV(I)) Q:'I  D
 ..S J=""
 ..S J=$O(ABMRV(I,J)) Q:J=""  D
 ...S K=0
 ...F  S K=$O(ABMRV(I,J,K)) Q:K=""  D
 ....I $P(ABMRV(I,J,K),U,3)="QL" S ABMQLFLG=1
 .S I=0
 .F  S I=$O(ABMRV(I)) Q:'I  D
 ..S J=""
 ..F  S J=$O(ABMRV(I,J)) Q:J=""  D
 ...S K=0
 ...F  S K=$O(ABMRV(I,J,K)) Q:K=""  D
 ....I $G(ABMQLFLG)=1,($P(ABMRV(I,J,K),U,3)'="QL") S $P(ABMRV(I,J,K),U,3)=""
 ....I $G(ABMQLFLG)'=1 S $P(ABMRV(I,J,K),U,3)=$S($P(ABMRV(I,J,K),U,3)="":ABMODMOD,1:$P(ABMRV(I,J,K),U,3)_":"_ABMODMOD)
 K ABMQLFLG
 ;
 ; if flat rate ....
 I $D(ABMP("FLAT")) D
 .N I
 .F I=1:1:3 S ABM(I)=$P(ABMP("FLAT"),"^",I)
 .I (ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID")) S ABM(3)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5)),U,7)  ;abm*2.6*1 HEAT7884
 .S ABMRV(+ABM(2),0,1)=+ABM(2)_"^^^^"_ABM(3)_"^"_($S(+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)'=0:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U),1:ABM(1)*ABM(3)))_"^^"_ABM(1)
 .;I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)'=0 S $P(ABMRV(+ABM(2),0,1),U,6)=(+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,8))
 .S $P(ABMRV(+ABM(2),0,1),U,10)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 .S $P(ABMRV(+ABM(2),0,1),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U,9)  ;abm*2.6*8 5010
 .S ABMP("CDAYS")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,3)  ;abm*2.6*1 HEAT5691
 .I +$G(ABMP("CDAYS"))>0 D
 ..S $P(ABMRV(+ABM(2),0,1),U,5)=$G(ABMP("CDAYS"))
 ..S $P(ABMRV(+ABM(2),0,1),U,6)=$G(ABMP("CDAYS"))*ABM(1)
 .S ABMCPT=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,16) I ABMCPT D
 ..S ABMCPT=$P($$CPT^ABMCVAPI(ABMCPT,ABMP("VDT")),U,2)  ;CSV-c
 ..S ABMP("CPT")=ABMCPT
 ..S $P(ABMRV(+ABM(2),0,1),U,2)=ABMCPT
 ..Q:$G(ABMP("EXP"))'=11
 ..S $P(ABMRV(+ABM(2),"TOT"),U,2)=ABMCPT
 .S ABM(4)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6)
 .I ABM(4),ABMP("VTYP")=111 S $P(ABMRV(+ABM(2),0,1),U,7)=(ABM(4)*ABM(1))
 .I ABM(4),(+$G(ABMP("CDAYS"))=0) S $P(ABMRV(+ABM(2),0,1),U,5)=0
 .I ABMP("VTYP")=831 D
 ..K ABMRV(+ABM(2),0),ABM("831SET")
 ..N I
 ..F I=21,27,35 D @(I_"^ABMERGR2")
 ..S I=0
 ..F  S I=$O(ABMRV(I)) Q:'I  D
 ...N J
 ...S J=0
 ...F  S J=$O(ABMRV(I,J)) Q:'J  D
 ....S K=0
 ....F  S K=$O(ABMRV(I,J,K)) Q:'K  D
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
 S ABMRV(9999)="001^^^^"_ABM("TOT",5)_"^"_ABM("TOT",6)_"^"_ABM("TOT",7)
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
 .S L=0
 .F  S L=$O(ABMRV(I,J,L)) Q:L=""  D
 ..S $P(ABMRV(I),U,1)=I
 ..F K=2,3,4 S $P(ABMRV(I),U,K)=""
 ..F K=5,6,7 S $P(ABMRV(I),U,K)=$P(ABMRV(I),U,K)+$P(ABMRV(I,J,L),U,K)
 Q
