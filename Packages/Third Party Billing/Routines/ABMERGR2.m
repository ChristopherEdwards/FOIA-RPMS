ABMERGR2 ; IHS/ASDST/DMJ - GET ANCILLARY SVCS REVENUE CODE INFO ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;
 ; IHS/SD/LSL - 08/30/02 - V2.5 Patch 1 - HIPAA
 ;            Added prescription number as 14th piece of ABMRV array
 ;            for Pharmacy
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 -  NOIS HQW-0302-100190
 ;     Modified to display 2nd and 3rd modifiers and units
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;    Correction to calculate cumulative charges correctly for dental
 ; IHS/SD/SDR - v2.5 p8 - task 6 - Added code for new ambulance multiple 47
 ; IHS/SD/SDR - v2.5 p9 - IM19492 - Corrected HCPCS issue (was +'ing HCPCS, making it 0)
 ; IHS/SD/SDR - v2.5 p9 - split for routine size ABMERGR3
 ; IHS/SD/SDR - v2.5 p10 - IM20018 - Added code to get CPT code on Revenue code page
 ; IHS/SD/SDR - v2.5 p10 - IM20395 - Split out lines bundled by Rev Code
 ;   NOTE: old code removed due to routine size
 ; IHS/SD/SDR - v2.5 p11 - IM24135 - Fixed Rx number not printing (wasn't looking at both fields)
 ; IHS/SD/SDR - v2.5 p12 - IM25207 - Changed default to RX number
 ; IHS/SD/SDR - v2.5 p12 - IM25947 - Don't include dental charges if not doing ADA billing
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added date written
 ; IHS/SD/SDR - abm*2.6*6 - HEAT28973 - if 55 modifier present use '1' for units to calculate charges
 ;
 ; ********************************************************************
 ; All line tags adhere to the following description unless specified
 ; otherwise in the appropriate line tag:
 ;
 ; ABMRV(IEN to REVENUE CODE, CPT CODE)= IEN to REVENUE CODE ^ CPT
 ;     Code ^ Modifier ^ 2nd modifier ^ cumulative units ^ cumulative
 ;     charges ^ ^ Unit Charge ^ NDC/ADA ^ from date/time ^ 
 ;     ^ 3rd Modifier ^ 4th Modifier ^ Prescription ^ Attending Provider
 ;     ^ Operating Provider ^ Referring Provider ^ Other Provider
 ;*********************************************************************
 ;
21 ;EP - Med/Surg
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA)) Q:'DA  D
 .F J=1:2:13,12,14 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,0),"^",J)
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S:ABM(13)="" ABM(13)=1  ; Set default
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0) ; CPT code  ;CSV-c
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U)=ABM(3)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT code
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,3)=ABM(9)  ;Modifier
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,4)=ABM(11)  ;2nd Modifier
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,5)=ABM(13)  ;units
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,6)=(ABM(7)*ABM(13))  ;unit charges
 .I (ABM(9)="55")!(ABM(11)="55")!(ABM(12)="55") S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,6)=(ABM(7))  ;IHS/SD/AML 2/15/2011 HEAT28973
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,10)=ABM(5)  ;From date/time
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,16)=ABM(14)  ;Operating Provider
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,8)=ABM(7)  ;Unit charge
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,12)=ABM(12)  ;3rd Modifier
 .S $P(ABMRV(+ABM(3),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
 ;
23 ;EP - Pharmacy
 ;
 ; ABMRV(IEN to REVENUE CODE, Medication IEN)= IEN to REVENUE CODE ^ 
 ;           ^ ^ ^ cumulative units ^ cumulative charges ^ ^ ^
 ;           NDC code_" "_generic name ^ date/time ^ ^ ^ ^ Prescription
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA)) Q:'DA  D
 .;F J=1:1:6,14,22 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,0),"^",J)  ;abm*2.6*6 5010
 .F J=1:1:6,14,22,25 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,0),"^",J)  ;abm*2.6*6 5010
 .S ABM(10)=ABM(14)
 .S ABM(14)=ABM(6)
 .K ABM(6)
 .S:'+ABM(3) ABM(3)=1                       ; default units = 1
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,14)=$S($G(ABM(6))'="":ABM(6),+$G(ABM(22))'=0:$P($G(^PSRX(ABM(22),0)),U),1:"")  ;Prescription (RX)
 .S ABM(6)=ABM(3)*ABM(4)+ABM(5)  ;units * units cost + dispense fee
 .S ABM(6)=$J(ABM(6),1,2)
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(6)  ;charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,9)=$P($G(^PSDRUG(ABM(1),2)),U,4)_" "_$P($G(^PSDRUG(ABM(1),0)),U)  ;NDC generic name
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(10)  ;Date/Time
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,32)=ABM(25)  ;date written  ;abm*2.6*6 5010
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
 ;
25 ;EP - Revenue Code
 ;
 ; ABMVR(IEN,0) = IEN to REVENUE CODE ^ ^ ^ ^ Cumulative units ^
 ;                Charges ^ ^ Unit charge ^ ^ start date/time
 ;
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA)) Q:'DA  D
 .F J=1:1:7 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA,0),"^",J)
 .S:'+ABM(2) ABM(2)=1                  ; Default units = 1
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(1),0,ABMLCNT),U)=ABM(1)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(1),0,ABMLCNT),U,2)=$S(+$G(ABM(7))'=0:$P($G(^ICPT(ABM(7),0)),U),1:ABM(7))
 .S $P(ABMRV(+ABM(1),0,ABMLCNT),U,5)=ABM(2)  ;units
 .S $P(ABMRV(+ABM(1),0,ABMLCNT),U,6)=(ABM(2)*ABM(3))+ABM(6)  ;Charges
 .S $P(ABMRV(+ABM(1),0,ABMLCNT),U,8)=ABM(3)  ;Unit charge
 .S $P(ABMRV(+ABM(1),0,ABMLCNT),U,10)=ABM(4)  ;Start date/time
 .S $P(ABMRV(+ABM(1),0,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,10),'$D(ABMRV(450,0,ABMLCNT)) D
 .S ABMRV(450,0,ABMLCNT)=450
 .S $P(ABMRV(450,0,ABMLCNT),U,5)=1
 .S $P(ABMRV(450,0,ABMLCNT),U,6)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),8),U,10)  ;emergency room surcharge
 .S $P(ABMRV(450,0,ABMLCNT),U,8)=$P(ABMRV(450,0,ABMLCNT),U,6)
 .S $P(ABMRV(450,0,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
 ;
27 ;EP - Medical Procedures
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA)) Q:'DA  D
 .F J=1:1:10 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0) ; CPT code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(8)  ;2nd modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=ABM(3)  ;cumulative units
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;cumulative charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,15)=ABM(10)  ;Attending Provider
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,8)=ABM(4)  ;Unit Charge
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(7)  ;Date/Time
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(9)  ;3rd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
 ;
33 ;EP - Dental
 ;
 ; ABMRV(IEN, Dental Code) = IEN to REVENUE CODE ^ Dental code ^ ^
 ;            ^ Cumulative units ^ Cumulative charges ^ ^ ^
 ;            ADA Description ^ Date of Service
 ;
 S DA=0
 I $G(ABMP("LDFN"))'="",($G(ABMP("INS"))'=""),($G(ABMP("VTYP"))'="") Q:$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,2)'="A"
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA)) Q:'DA  D
 .F J=1,2,7,8,9 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,0),"^",J)
 .S:'+ABM(9) ABM(9)=1
 .S ABM("DCODE")=$P(^AUTTADA(ABM(1),0),U) ; dental code
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),+ABM("DCODE"),ABMLCNT),U)=ABM(2)  ; Revenue code IEN
 .S $P(ABMRV(+ABM(2),+ABM("DCODE"),ABMLCNT),U,2)=ABM("DCODE")  ; Dental code
 .S $P(ABMRV(+ABM(2),+ABM("DCODE"),ABMLCNT),U,5)=ABM(9)  ;units
 .S $P(ABMRV(+ABM(2),+ABM("DCODE"),ABMLCNT),U,6)=(ABM(8)*ABM(9))  ;charges
 .S $P(ABMRV(+ABM(2),+ABM("DCODE"),ABMLCNT),U,9)=$P(^AUTTADA(ABM(1),0),U,2)  ; ADA Description
 .S $P(ABMRV(+ABM(2),+ABM("DCODE"),ABMLCNT),U,10)=ABM(7)  ; Date of service
 .S $P(ABMRV(+ABM(2),+ABM("DCODE"),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
 ;
35 ;EP - Radiology
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA)) Q:'DA  D
 .F J=1:1:10 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(6)  ;2nd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,8)=ABM(4)  ;Unit Charge
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(9)  ;Date/Time
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(7)  ;3rd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,15)=ABM(10)  ;Attending Provider
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),35,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 Q
 ;
37 ;EP - Laboratory
 D 37^ABMERGR3
 Q
 ;
39 ;EP - Anesthesia
 D 39^ABMERGR3
 Q
 ;
43 ;EP - Miscellaneous Services
 D 43^ABMERGR3
 Q
45 ;EP - Supplies
 D 45^ABMERGR3
 Q
47 ;EP - Ambulance Services
 D 47^ABMERGR3
 Q
