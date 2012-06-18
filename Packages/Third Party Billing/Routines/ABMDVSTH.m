ABMDVSTH ; IHS/ASDST/DMJ - PCC Visit Stuff - PART 5 (HOSPITALIZATION) CONTD ;  
 ;;2.6;IHS Third Party Billing System;**2,4**;NOV 12, 2009
 ; IHS/SD/SDR - v2.5 p10 - IM20022 - Use AOB/ROI multiples
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ; IHS/SD/SDR - abm*2.6*4 - HEAT15806 - admit date/time not showing due to ABMFEAPI quit; moved up or made conditional
 ;
 ;This is a continuation of ABMDVST4
 Q   ;Not to be called from the top
CPT(SUB,LVL) ;EP - rtn CPT code
 K X,ABMSRC
 N N,L
 S:'$D(LVL) LVL="LOW"
 S (L,N)=""
 F  S N=$O(AUPNCPT(N)) Q:N=""  D  Q:$D(X)
 .F  S L=$O(ABMCPTTB("HOS",SUB,L)) Q:L=""  D  Q:$D(X)
 ..Q:(+AUPNCPT(N))'=ABMCPTTB("HOS",SUB,L)
 ..S X=+AUPNCPT(N)
 ..S ABMSRC=$P($P(AUPNCPT(N),U,4),".",2)_"|"_$P(AUPNCPT(N),U,5)_"|CPT"
 I '$D(X) D
 .S X=ABMCPTTB("HOS",SUB,LVL)
 .S ABMSRC="02|"_$S($D(ABMDA):ABMDA,1:"DEF")_"|CPT"
 Q X
 ;
 ; the following code to be executed when SERVCAT=I or D
MIDDAY ;EP - The following is for the middle days of care
 N ABMCOVD,ABMEDIT,QUIT
 S X1=ABMCHVDT
 S X2=ABMP("HDATE")
 D ^%DTC
 S ABMCOVD=X
 I ABMCOVD<1 D  Q:$G(QUIT)
 .I $D(ABMP("COVD",ABMCHVDT)) S QUIT=1 Q
 .S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,"C",ABMCHVDT,""))
 .I DA S ABMEDIT=1
 E  I ABMCOVD>1 D MAKEDY
 S ABMP("COVD",ABMCHVDT)=""
 I ABMCHVDT>ABMP("HDATE") S ABMP("HDATE")=ABMCHVDT
 Q:ABMCOVD>1
 S ABMD=ABMCHVDT
MIDDAY2 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",27,",DIC(0)="LE"
 S X=$$CPT("SUB")
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 HEAT15806
 I (($P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)=0)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y")) Q  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 HEAT15806
 ;S DIC("DR")=".03////1;.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)  ;abm*2.6*2 3PMS10003A
 S DIC("DR")=".03////1;.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DIC("DR")=DIC("DR")_";.06////1"
 S DIC("DR")=DIC("DR")_";.07////"_ABMD
 S DIC("DR")=DIC("DR")_";.17////"_ABMSRC
 I $G(ABMEDIT) D  Q
 .S DIE=DIC
 .S DR=DIC("DR")
 .K DIC(0)
 .D ^DIE
 .K ABMI
 K DD,DO D FILE^DICN
 K ABMI
 Q
 ;
MAKEDY ;Put in each day separately
 F ABM=1:1:ABMCOVD D
 .S X1=ABMP("HDATE")
 .S X2=ABM
 .D C^%DTC
 .S ABMD=X
 .Q:$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,"C",ABMD,""))
 .D MIDDAY2
 Q
 ;
DISCHRG ;EP - The following is for discharge care
 N DISNOTCV,COVD
 S Y=$P(ABML(ABMP("PRI"),ABMP("INS")),U,4,5)
 S X1=$S($P(Y,U,2):$P(Y,U,2),1:ABMP("DDT"))
 I X1<ABMP("DDT") S DISNOTCV=1
 S X2=$S(+Y>ABMP("HDATE"):+Y,1:ABMP("HDATE"))
 D ^%DTC
 ;If discharge date not covered just do middle days if they exist
 I $D(DISNOTCV) D  Q
 .I X>0 D
 ..S ABMCOVD=X
 ..I ABMCOVD>1 D MAKEDY Q
 ..S ABMD=ABMCHVDT
 ..D MIDDAY2
 E  I X>1 D
 .S ABMCOVD=X-1
 .I ABMCOVD>1 D MAKEDY Q
 .S X1=ABMCHVDT
 .S X2=-1
 .D C^%DTC
 .S ABMD=X
 .D MIDDAY2
 S ABMP("HDATE")=ABMCHVDT
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",27,",DIC(0)="LE"
 S X=$$CPT("DIS","LT ")
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 HEAT15806
 I (($P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)=0)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y")) Q  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 HEAT15806
 ;S DIC("DR")=".03////1;.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)  ;abm*2.6*2 3PMS10003A
 S DIC("DR")=".03////1;.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DIC("DR")=DIC("DR")_";.06////1"
 S DIC("DR")=DIC("DR")_";.07////"_ABMCHVDT
 S DIC("DR")=DIC("DR")_";.17///"_ABMSRC
 K DD,DO D FILE^DICN
 K ABMI
 Q
 ;
REL ;EP - RELEASE OF INFORMATION
 K DIE S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S DR=".74////N"
 I ($D(^AUPNPAT(ABMP("PDFN"),36,0)))>10,($O(^AUPNPAT(ABMP("PDFN"),36,"B",9999999),-1)<ABMP("VDT")) S DR=".74////Y;.711////"_$O(^AUPNPAT(ABMP("PDFN"),36,"B",9999999),-1)
 D ^DIE K DR
 Q
 ;
BENE ;EP - ASSIGNMENT OF BENEFITS
 S DR=".75////N"
 I ($D(^AUPNPAT(ABMP("PDFN"),71,0)))>10,($O(^AUPNPAT(ABMP("PDFN"),71,"B",9999999),-1)<ABMP("VDT")) S DR=".75////Y;.712////"_$O(^AUPNPAT(ABMP("PDFN"),71,"B",9999999),-1)
 D ^DIE K DR
 Q
