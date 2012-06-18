ABME8L12 ; IHS/ASDST/DMJ - Header 
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;Header Segments
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM12246/IM17548 - Added code to do CLIA number REF segment
 ; IHS/SD/EFG - V2.5 P8 - IM16385 - Allow dental charges on 837P
 ; IHS/SD/SDR - v2.5 p8 - task 6 - Don't put rendering if ambulance
 ; IHS/SD/SDR - v2.5 p9 - task 1 - Added address for ordering provider
 ; IHS/SD/SDR - v2.5 p10 - IM20395 - Split out lines bundled by rev code
 ; IHS/SD/SDR - v2.5 p10 - IM20454 - Added flag for what loop
 ; IHS/SD/SDR - v2.5 p10 - IM19843 - Added code for SERVICE TO DATE/TIME
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p11 - IM21946 - Changes for CLIA number
 ; IHS/SD/SDR - v2.5 p11 - IM23175 - G0107 needs CLIA number; treat as lab
 ; IHS/SD/SDR - v2.5 p12 - IM25247 - Add missing REF segment for TIN if NPI ONLY
 ; IHS/SD/SDR - abm*2.6*6 - HEAT29380 - G0103 needs CLIA number; treat as lab
 ;
EP ;START HERE
 S ABMLXCNT=0
 K ABM
 D ^ABMEHGRV
 S ABMI=0
 F  S ABMI=$O(ABMRV(ABMI)) Q:'+ABMI  D
 .S ABMJ=-1
 .F  S ABMJ=$O(ABMRV(ABMI,ABMJ)) Q:'+ABMJ  D
 ..S ABMK=0
 ..F  S ABMK=$O(ABMRV(ABMI,ABMJ,ABMK)) Q:'+ABMK  D
 ...D LOOP
 K ABMI,ABMJ,ABMK
 Q
 ;
LOOP ;
 S ABMLXCNT=ABMLXCNT+1
 D EP^ABME8LX
 D WR^ABMUTL8("LX")
 D EP^ABME8SV1
 D WR^ABMUTL8("SV1")
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 .I $P(ABMRV(ABMI,ABMJ,ABMK),U,27)'="",($P(ABMRV(ABMI,ABMJ,ABMK),U,10)'=$P(ABMRV(ABMI,ABMJ,ABMK),U,27)) D EP^ABME8DTP(472,"RD8",$P(ABMRV(ABMI,ABMJ,ABMK),U,10),$P(ABMRV(ABMI,ABMJ,ABMK),U,27))
 .E  D EP^ABME8DTP(472,"D8",$P(ABMRV(ABMI,ABMJ,ABMK),U,10))
 I '$P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 .D EP^ABME8DTP(472,"D8",$P(ABMB7,U))
 D WR^ABMUTL8("DTP")
 I ABMI=37 D  ;lab multiple
 .Q:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,ABMJ,0)),U,21)=""  ;no lab result
 .D ^ABME8MEA
 .D WR^ABMUTL8("MEA")
 ;I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>79999)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<90000))!($P(ABMRV(ABMI,ABMJ,ABMK),U,2)="G0107") D  ;abm*2.6*6 HEAT29380
 ;start new code abm*2.6*8 HEAT31238
 ;mammography cert number
 I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>77050)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<77060)) D
 .Q:ABMP("CLIN")=72  ;don't write if clinic is mammography; cert# already written for claim
 .Q:$P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U,4)=""  ;no cert#
 .D EP^ABME8REF("EW")
 .D WR^ABMUTL8("REF")
 ;end new code HEAT31238
 I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>79999)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<90000))!($E($P(ABMRV(ABMI,ABMJ,ABMK),U,2))="G") D  ;abm*2.6*6 HEAT29380
 .S ABMCLIA="SV"
 .I $G(ABMOUTLB)'=1 D
 ..D EP^ABME8REF("X4","1SV","1SV")
 ..D WR^ABMUTL8("REF")
 .I $G(ABMOUTLB)=1 D  ;if reference lab
 ..D EP^ABME8REF("F4",1,1)
 ..D WR^ABMUTL8("REF")
 ;
 ; Loop 2420A - Rendering Physician
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,13) D
 .Q:$G(ABMP("VTYP"))=831&($G(ABMP("ITYPE"))="R")  ;don't write provider info for ASC
 .Q:$G(ABMP("CLIN"))="A3"
 .S ABMLOOP="2420A"
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,13)
 .Q:ABM("PRV")=$O(ABMP("PRV","D",0))
 .D EP^ABME8NM1(82,ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .D EP^ABME8PRV("PE",ABM("PRV"))
 .D WR^ABMUTL8("PRV")
 .Q:$P($G(^AUTNINS(ABMP("INS"),0)),U)["OKLAHOMA MEDICAID"
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..Q:((ABMRCID="99999")!(ABMRCID="AHCCCS866004791"))  ;AZ Medicaid
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 ;
 ; Loop 2420B - Purchased Service Physician Name
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,19) D
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,19)
 .Q:ABM("PRV")=$O(ABMP("PRV","P",0))
 .D EP^ABME8NM1("QB",ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 ;
 ; Loop 2420C - Service Facility Location
 I $G(ABMOUTLB)=1 D  ;reference lab
 .S ABMOTLBN=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0),"^",14)
 .I $G(ABMOTLBN)'="" D
 ..D EP^ABME8NM1(77,ABMOTLBN)
 ..D WR^ABMUTL8("NM1")
 ..D EP^ABME8N3(9002274.35,ABMOTLBN)
 ..D WR^ABMUTL8("N3")
 ..D EP^ABME8N4(9002274.35,ABMOTLBN)
 ..D WR^ABMUTL8("N4")
 ;
 ; Loop 2420D - Supervising Physician Name
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,20) D
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,20)
 .Q:ABM("PRV")=$O(ABMP("PRV","S",0))
 .D EP^ABME8NM1("DQ",ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 ;
 ; Loop 2420E - Ordering Physician Name
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,21) D
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,21)
 .;NOTE:below line was added for patch 10 but removed during testing because site was
 .;reporting payer was requiring it
 .S ABMLOOP="2420E"
 .D EP^ABME8NM1("DK",ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .D EP^ABME8N3(200,ABM("PRV"))
 .D WR^ABMUTL8("N3")
 .D EP^ABME8N4(200,ABM("PRV"))
 .D WR^ABMUTL8("N4")
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 .K ABMLOOP
 ;
 ; Loop 2420F Referring Provider Name
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,18) D
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,18)
 .Q:ABM("PRV")=$O(ABMP("PVR","F",0))
 .D EP^ABME8NM1("DN",ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .D EP^ABME8PRV("RF")
 .D WR^ABMUTL8("PRV",ABM("PRV"))
 Q
