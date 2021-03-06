ABME5L16 ; IHS/ASDST/DMJ - Header 
 ;;2.6;IHS Third Party Billing System;**6,9,10,11**;NOV 12, 2009;Build 133
 ;Header Segments
 ;
START ;START HERE
 S ABMLOOP=2320
 D PAYED^ABMUTLP
 N ABMI
 S ABMI=0
 F  S ABMI=$O(ABMP("INS",ABMI)) Q:'ABMI  D
 .S ABMLINE=ABMP("INS",ABMI)
 .I $P(ABMLINE,U)=ABMP("INS")!($P(ABMLINE,"^",11)=ABMP("INS")),$P(ABMLINE,"^",3)="I" Q
 .D EP^ABME5SBR(ABMI)
 .D WR^ABMUTL8("SBR")
 .F ABML="OA","PR","CO" D
 ..Q:'$D(ABMP(+ABMLINE,ABML))  ;quit if no data for insurer in ABMP adj array
 ..D EP^ABME5CAS
 ..D WR^ABMUTL8("CAS")
 .;start old code abm*2.6*9 NOHEAT
 .;printing AMT twice
 .;I $G(ABMP("PAYED",+ABMLINE)) D
 .;.D EP^ABME5AMT("D")
 .;.D WR^ABMUTL8("AMT")
 .;end old code
 .I ($G(ABMP("PAYED",+ABMLINE))!($P($G(^ABMNINS(ABMP("LDFN"),+ABMLINE,0)),U,11)="Y")) D
 ..D EP^ABME5AMT("D")
 ..D WR^ABMUTL8("AMT")
 .;start new code abm*2.6*10 COB billing
 .;I ABMPSQ'=1,$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMP("INS"),".211","I"),1,"I")="R" D
 ..S ABMAMT=0
 ..D EP^ABME5AMT("B6")
 ..D WR^ABMUTL8("AMT")
 ..;end new code abm*2.6*10 COB billing
 .D ^ABME5OI
 .D WR^ABMUTL8("OI")
 .;
 .S ABMLOOP="2330A"
 .I $G(ABMSBR(ABMI)) D
 ..S ABMSFILE=$P(ABMSBR(ABMI),"-",1)
 ..S ABMSIEN=$P(ABMSBR(ABMI),"-",2)
 .D EP^ABME5NM1("IL")
 .D WR^ABMUTL8("NM1")
 .D EP^ABME5N3(ABMSFILE,ABMSIEN)
 .D WR^ABMUTL8("N3")
 .D EP^ABME5N4(ABMSFILE,ABMSIEN)
 .D WR^ABMUTL8("N4")
 .;
 .S ABMLOOP="2330B"
 .D EP^ABME5NM1("PR",+ABMLINE)
 .D WR^ABMUTL8("NM1")
 .D EP^ABME5N3(9999999.18,+ABMLINE)
 .D WR^ABMUTL8("N3")
 .D EP^ABME5N4(9999999.18,+ABMLINE)
 .D WR^ABMUTL8("N4")
 .I $G(ABMP("PAYED",+ABMLINE))'="" D
 ..;S ABMPDT=$S($P($G(ABMP("PAYED",+ABMLINE)),U,2)'="":$P(ABMP("PAYED",+ABMLINE),U,2),$G(ABMP("PDT",+ABMLINE))'="":ABMP("PDT",+ABMLINE),1:"")  ;abm*2.6*10 COB billing
 ..S ABMPDT=$S($P($G(ABMP("PAYED",+ABMLINE)),U,2)'="":$P(ABMP("PAYED",+ABMLINE),U,2),$G(ABMP("PDT",+ABMLINE))'="":ABMP("PDT",+ABMLINE),1:DT)  ;abm*2.6*10 COB billing
 ..D EP^ABME5DTP(573,"D8",ABMPDT)
 ..D WR^ABMUTL8("DTP")
 ..K ABMPDT
 .;D OTHR  ;abm*2.6*9 HEAT58542
 Q
OTHR ;other payer info
 ;loops 2330C through 2330G
 N J
 F J=1:1:4 D
 .S ABMPTYP=$E("FRPS",J)
 .Q:($G(ABMP("CLIN"))="A3")&(J="R")
 .S ABMPROV=$O(ABMP("PRV",ABMPTYP,0))
 .I ABMPROV D
 ..S ABMPNBR=$$NPI^ABMEEPRV(ABMPROV,ABMP("LDFN"),+ABMLINE)
 ..Q:ABMPNBR=""
 ..D EP^ABME5NM2($P("DN^82^QB^DQ","^",J))
 ..D WR^ABMUTL8("NM1")
 ..S ABMITYP=$P(ABMLINE,"^",2)
 ..S ABMP("RTYPE")=$S(ABMITYP="R":"1G",ABMITYP="D":"1D",$P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U)'="":$P($G(^ABMREFID($P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U),0)),U),1:"0B")
 ..;I ABMP("EXP")=32,ABMP("RTYPE")="1G" S ABMP("RTYPE")="1C"
 ..;D EP^ABME5RF2(ABMP("RTYPE"))
 ..;I ABMNPIU="B"!(ABMNPIU="N") D
 ..;.D EP^ABME5REF("EI",9999999.06,DUZ(2))
 ..;D WR^ABMUTL8("REF")
 Q
