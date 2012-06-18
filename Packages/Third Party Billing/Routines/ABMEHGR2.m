ABMEHGR2 ; IHS/ASDST/DMJ - GET ANCILLARY SVCS REVENUE CODE INFO ;     
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;Original;DMJ;03/20/96 9:07 AM
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190
 ;     Modified to display 2nd and 3rd modifiers and units
 ; IHS/SD/SDR - v2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/EFG - V2.5 P8 - IM16385 - Calculate line total when more than 1 unit for 837D and 837P
 ; IHS/SD/SDR - v2.5 p8 - task 6 - Added code for new ambulance multiple 47
 ; IHS/SD/SDR - v2.5 p9 - task 1 - Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p9 - split routine for size
 ; IHS/SD/SDR - v2.5 p10 - IM20395 - Split lines bundled by Rev code
 ; IHS/SD/SDR - v2.5 p10 - IM19843
 ;   Added code for SERVICE TO DATE/TIME
 ;   NOTE: Removed old code due to routine size
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR -abm*2.6*6 - 5010 - added date written to array for 23
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added line item control number
 ; IHS/SD/SDR - abm*2.6*6 - HEAT28973 - if 55 modifier present use '1' as the units to calculate charges
 ;
 ; *********************************************************************
 ;
 ; ABMRV(SECTION,#) piece 1=revenue code, 2=CPT code, 3=modifier 
 ;      4=2nd modifier, 5=units, 6=total charges, 8=unit charge 
 ;      9=description, 10=date/time,
 ;     11=corresponding dx, 12=3rd modifier, 13=rendering provider
 ;     14=days of supply, 15=ndc#, 16=dea#, 17=new/refill code
 ;     18=referring provider, 19=purchased service provider
 ;     20=supervising provider, 21=ordering provider, 22=4th modifier
 ;     23=dental tooth, 24=dental tooth surface, 25=POS, 26=TOS
 ;     27=service to date/time
 ;
21 ;EP - Med/Surg
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA)) Q:'DA  D
 .F J=1:1:13,19 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,0),U,J)
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0) ; CPT code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(21,DA,ABMLCNT),U)=ABM(3)  ;Revenue code IEN
 .S $P(ABMRV(21,DA,ABMLCNT),U,2)=ABM(1)  ;CPT code
 .S $P(ABMRV(21,DA,ABMLCNT),U,3)=ABM(9)  ;Modifier
 .S $P(ABMRV(21,DA,ABMLCNT),U,4)=ABM(11)  ;2nd Modifier
 .S $P(ABMRV(21,DA,ABMLCNT),U,5)=ABM(13) ; counter
 .S $P(ABMRV(21,DA,ABMLCNT),U,6)=(ABM(7)*ABM(13))  ;unit charges
 .I (ABM(9)="55")!(ABM(11)="55")!(ABM(12)="55") S $P(ABMRV(21,DA,ABMLCNT),U,6)=(ABM(7))  ;IHS/SD/AML 2/15/2011 HEAT28973
 .S $P(ABMRV(21,DA,ABMLCNT),U,10)=ABM(5)  ;date/time
 .S $P(ABMRV(21,DA,ABMLCNT),U,11)=ABM(4)  ;corresponding dx
 .S $P(ABMRV(21,DA,ABMLCNT),U,12)=ABM(12)
 .S ABM(14)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,"P","C","R",0))  ;rendering provider
 .I +ABM(14)'=0 S $P(ABMRV(21,DA,ABMLCNT),U,13)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,"P",ABM(14),0)),U)
 .S $P(ABMRV(21,DA,ABMLCNT),U,25)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,0)),U,15)
 .S $P(ABMRV(21,DA,ABMLCNT),U,26)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,0)),U,16)
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,"P","C","D",0))  ;ordering provider
 .I +ABM(21)'=0 S $P(ABMRV(21,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,"P",ABM(21),0)),U)
 .S $P(ABMRV(21,DA,ABMLCNT),U,27)=$S($G(ABM(19))'="":ABM(19),1:ABM(5))  ;service to date/time
 .S $P(ABMRV(21,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),21,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
 ;
23 ;EP - Pharmacy
 ;
 ; ABMRV(IEN to REVENUE CODE, Medication IEN)= IEN to REVENUE CODE ^ 
 ;           ^ ^ ^ units ^ charges ^ ^ ^ NDC generic name
 ;           date/time
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA)) Q:'DA  D
 .;F J=1:1:6,13,14,19,22,28 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,0),U,J)  ;abm*2.6*6 5010
 .;F J=1:1:6,13,14,19,22,24,25,28 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,0),U,J)  ;abm*2.6*6 5010  ;abm*2.6*8 HEAT35661
 .F J=1:1:6,13,14,19,22,24,25,28,29 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,0),U,J)  ;abm*2.6*6 5010  ;abm*2.6*8 HEAT35661
 .S:'+ABM(3) ABM(3)=1                       ; default units = 1
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(23,DA,ABMLCNT),U)=ABM(2)  ;revenue code IEN
 .S $P(ABMRV(23,DA,ABMLCNT),U,2)=$S(ABM(29):$P($$CPT^ABMCVAPI(ABM(29),ABMP("VDT")),U,2),1:0)  ;CPT  abm*2.6*8 HEAT35661
 .S $P(ABMRV(23,DA,ABMLCNT),U,5)=ABM(3)  ;units
 .S ABM(7)=ABM(3)*ABM(4)+ABM(5)  ;units * units cost + dispense fee
 .S ABM(7)=$J(ABM(7),1,2)
 .S $P(ABMRV(23,DA,ABMLCNT),U,6)=ABM(7)   ;charges
 .S $P(ABMRV(23,DA,ABMLCNT),U,9)=$P($G(^PSDRUG(ABM(1),2)),U,4)_" "_$P($G(^(0)),U)  ;NDC generic name
 .S $P(ABMRV(23,DA,ABMLCNT),U,13)=$S(ABM(6)'="":ABM(6),1:ABM(22))  ;prescription
 .K ABMDA,ABM(52)
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,"P","C","D",0))  ;ordering provider
 .I +$G(ABM(21))'=0 S $P(ABMRV(23,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,"P",ABM(21),0)),U)
 .D:ABM(6)
 ..N DA S DA=$O(^PSRX("B",ABM(6),0))
 ..Q:'DA
 ..S ABMDA=DA
 ..S DIQ="ABM(",DIQ(0)="IE",DIC="^PSRX("
 ..S DR="4;8;27"
 ..D EN^DIQ1
 .;start new code abm*2.6*8 HEAT35661
 .S $P(ABMRV(23,DA,ABMLCNT),U,11)=ABM(13)  ;corresponding dx
 .S $P(ABMRV(23,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 .;end new code HEAT35661
 .Q:'$G(ABMDA)
 .S $P(ABMRV(23,DA,ABMLCNT),U,14)=ABM(52,ABMDA,8,"E")  ;days of supply
 .;S $P(ABMRV(23,DA,ABMLCNT),U,15)=ABM(52,ABMDA,27,"E")  ;ndc #  ;abm*2.6*6
 .S $P(ABMRV(23,DA,ABMLCNT),U,15)=ABM(24)  ;ndc #  ;abm*2.6*6
 .S ABMDEA=$P($G(^VA(200,+$G(ABM(52,ABMDA,4,"I")),"PS")),U,2)  ;dea #
 .S $P(ABMRV(23,DA,ABMLCNT),U,16)=ABMDEA
 .S $P(ABMRV(23,DA,ABMLCNT),U,10)=ABM(14)
 .S $P(ABMRV(23,DA,ABMLCNT),U,17)=ABM(19)
 .S $P(ABMRV(23,DA,ABMLCNT),U,11)=ABM(13)  ;corresponding dx
 .S $P(ABMRV(23,DA,ABMLCNT),U,27)=$S($G(ABM(28))'="":ABM(28),1:ABM(5))  ;service date to
 .S $P(ABMRV(23,DA,ABMLCNT),U,32)=ABM(25)  ;date written  ;abm*2.6*6 5010
 .S $P(ABMRV(23,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
 ;
25 ;EP - Revenue Code
 ;
 ; ABMVR(IEN,0) = IEN to REVENUE CODE ^ ^ ^ ^ Cumulative units ^
 ;                Charges ^ ^ Unit charge
 ;
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA)) Q:'DA  D
 .F J=1:1:3,6,7 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA,0),"^",J)
 .S:'+ABM(2) ABM(2)=1                  ; Default units = 1
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(25,DA,ABMLCNT),U)=ABM(1)  ;Revenue code IEN
 .S $P(ABMRV(25,DA,ABMLCNT),U,2)=ABM(7)
 .S $P(ABMRV(25,DA,ABMLCNT),U,5)=ABM(2)  ;units
 .S $P(ABMRV(25,DA,ABMLCNT),U,6)=(ABM(2)*ABM(3))+ABM(6)  ;charges
 .S $P(ABMRV(25,DA,ABMLCNT),U,8)=ABM(3)  ;Unit charge
 .S $P(ABMRV(25,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA,2)),U)  ;abm*2.6*8 5010 line item control number
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,10),'$D(ABMRV(25,450,ABMLCNT)) D
 .S ABMRV(25,450,ABMLCNT)=450
 .S $P(ABMRV(25,450,ABMLCNT),U,5)=1
 .S $P(ABMRV(25,450,ABMLCNT),U,6)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),8),U,10)  ;emergency room surcharge
 .S $P(ABMRV(25,450,ABMLCNT),U,8)=$P(ABMRV(25,450,ABMLCNT),U,6)
 .S $P(ABMRV(25,450,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),25,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
 ;
27 ;EP - Medical Procedures
 ;
 ; ABMRV(IEN to REVENUE CODE, CPT CODE)= IEN to REVENUE CODE ^ 
 ;           CPT Code ^ Modifier ^ cumulative units ^ units 
 ;           ^ cumulative charges 
 ;
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA)) Q:'DA  D
 .F J=1:1:10,12 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,0),U,J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(27,DA,ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(27,DA,ABMLCNT),U,2)=ABM(1)  ;CPT code
 .S $P(ABMRV(27,DA,ABMLCNT),U,3)=ABM(5)  ;Modifier
 .S $P(ABMRV(27,DA,ABMLCNT),U,10)=ABM(7)  ;charge date
 .S $P(ABMRV(27,DA,ABMLCNT),U,4)=ABM(8)  ;2nd modifier
 .S $P(ABMRV(27,DA,ABMLCNT),U,5)=ABM(3)  ;units
 .S $P(ABMRV(27,DA,ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges
 .S $P(ABMRV(27,DA,ABMLCNT),U,11)=ABM(6)  ;corresponding dx
 .S $P(ABMRV(27,DA,ABMLCNT),U,12)=ABM(9)  ;3rd Modifier
 .S ABM(13)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,"P","C","R",0))
 .I +ABM(13)'=0 S $P(ABMRV(27,DA,ABMLCNT),U,13)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,"P",ABM(13),0)),U)  ;rendering provider
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,"P","C","D",0))
 .I +ABM(21)'=0 S $P(ABMRV(27,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,"P",ABM(21),0)),U)  ;ordering provider
 .S $P(ABMRV(27,DA,ABMLCNT),U,25)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,0)),U,15)
 .S $P(ABMRV(27,DA,ABMLCNT),U,26)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,0)),U,16)
 .S $P(ABMRV(27,DA,ABMLCNT),U,27)=$S($G(ABM(12))'="":ABM(12),1:ABM(7))  ;service to date/time
 .I ABM(1)=99231!(ABM(1)=99232)!(ABM(1)=99233) D
 ..Q:+ABM(3)'>1
 ..I '+ABM(7) S ABM(7)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 ..S $P(ABMRV(27,DA,ABMLCNT),U,15)=$$FMADD^XLFDT(ABM(7),(ABM(3)-1))
 .S $P(ABMRV(27,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),27,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 S ABMDCPT=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),ABMP("VTYP"),0)),U,16)
 Q:ABMDCPT=""
 S ABMDCPT=$P($$CPT^ABMCVAPI(ABMDCPT,ABMP("VDT")),U,2)  ;CSV-c
 Q:ABMDCPT=""
 S DA=DA+1
 S $P(ABMRV(27,DA,ABMLCNT),U,2)=ABMDCPT
 S $P(ABMRV(27,DA,ABMLCNT),U,5)=1
 S $P(ABMRV(27,DA,ABMLCNT),U,6)=$$FLAT^ABMDUTL(ABMP("INS"),ABMP("VTYP"),ABMP("VDT"))
 Q
 ;
33 ;EP - Dental
 ;
 ; ABMRV(IEN, Dental Code) = IEN to REVENUE CODE ^ Dental code ^ ^
 ;            ^ Cumulative units ^ Cumulative charges ^ ^ ^
 ;            ADA Description ^ Date of Service
 ;
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA)) Q:'DA  D
 .F J=1:1:9 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,0),"^",J)
 .S:'+ABM(9) ABM(9)=1
 .S ABM("DCODE")=$P(^AUTTADA(ABM(1),0),U) ; dental code
 .S ABMDENP=$P($G(^ABMDREC(ABMP("INS"),0)),U,2)
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,11)
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(DUZ(2),1,3)),U,11)
 .S:ABMDENP]"" ABM("DCODE")=ABMDENP_ABM("DCODE")
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(33,DA,ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(33,DA,ABMLCNT),U,2)=ABM("DCODE")  ;Dental code
 .S $P(ABMRV(33,DA,ABMLCNT),U,5)=ABM(9)  ;units
 .S $P(ABMRV(33,DA,ABMLCNT),U,6)=(ABM(8)*ABM(9))  ;charges
 .S $P(ABMRV(33,DA,ABMLCNT),U,9)=$P(^AUTTADA(ABM(1),0),U,2)  ;ADA Description
 .S $P(ABMRV(33,DA,ABMLCNT),U,10)=ABM(7)  ;Date of service
 .S $P(ABMRV(33,DA,ABMLCNT),U,11)=ABM(4)  ;corresponding dx
 .S $P(ABMRV(33,DA,ABMLCNT),U,23)=ABM(5)  ;tooth
 .S $P(ABMRV(33,DA,ABMLCNT),U,24)=ABM(6)  ;surface
 .;start new code abm*2.6*8 5010 service line providers
 .S ABM(13)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,"P","C","R",0))
 .I +ABM(13)'=0 S $P(ABMRV(33,DA,ABMLCNT),U,13)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,"P",ABM(13),0)),U)  ;rendering provider
 .S ABM(21)=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,"P","C","S",0))
 .I +ABM(21)'=0 S $P(ABMRV(33,DA,ABMLCNT),U,21)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,"P",ABM(21),0)),U)  ;supervising provider
 .;end new code abm*2.6*8
 .S $P(ABMRV(33,DA,ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,DA,2)),U)  ;abm*2.6*6 5010 line item control number
 Q
 ;
35 ;EP - Radiology
 D 35^ABMEHGR3
 Q
 ;
37 ;EP - Laboratory
 D 37^ABMEHGR3
 Q
 ;
39 ;EP - Anesthesia
 D 39^ABMEHGR3
 Q
 ;
43 ;EP - Miscellaneous Services
 D 43^ABMEHGR3
 Q
45 ;EP - Supplies
 D 45^ABMEHGR3
 Q
47 ;EP - Ambulance Services
 D 47^ABMEHGR3
 Q
