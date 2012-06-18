ABMDVST4 ; IHS/ASDST/DMJ - PCC Visit Stuff - PART 5 (HOSPITALIZATION) ; 
 ;;2.6;IHS Third Party Billing System;**2,4**;NOV 12, 2009
 ;Original;TMD;03/26/96 12:32 PM
 ;
 ; IHS/SD/SDR v2.5 p5 - 5/17/2004 - Modified to put default for
 ;    admission source/admission type/discharge status if outpatient
 ; IHS/SD/SDR v2.5 p6 - 7/12/04 - IM14030 - Fix so discharge status will
 ;      default correctly
 ; IHS/SD/SDR - v2.5 p8 - task 6 - Added code to get patient weight from V Measurement file
 ; IHS/SD/SDR - v2.5 p9 - IM13294 - Admission/Discharge hour populated for outpatient visits
 ; IHS/SD/SDR - v2.5 p10 - IM19717/IM20374 - Removed "CLEAN" of 27 multiple
 ; IHS/SD/SDR - v2.5 p10 - IM21006 - Added code to increment discharge
 ;   hour by 1 for NC Medicaid for Outpt visits
 ; IHS/SD/SDR - v2.5 p10 - IM21382 - Made Service Category R act like A
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ; IHS/SD/SDR - abm*2.6*4 - HEAT15806 - fix for admit date/time missing; caused by ABMFEAPI change
 ;
 ;ABMP("DDT") is the discharge date from the V HOSPITALIZATION FILE
 ;ABMP("HDATE") is the most recent hospitalizaiton date evaluated by
 ;this rtn for this claim.  These 2 dates need to be the same
 ;after all children of H cat visit are processed or this rtn is not done
 Q:ABMIDONE
 I '$D(ABMCPTTB("HOS")) D
 .F ABM=0:0 S ABM=$O(^ABMDCPT("C","HOSPITALIZATION",ABM)) Q:'ABM  D
 ..S Y=^ABMDCPT(ABM,0)
 ..S ABMCPTTB("HOS",$E($P(Y,U,3),1,3),$E($P(Y,U,1),1,3))=$P(Y,U,4)
 ..S ABMCPTTB("HOS",1,$P(Y,U,4))=""
 .S ABM=0
 .F  S ABM=$O(^ABMDCPT("C","OUTPATIENT",ABM)) Q:'ABM  D
 ..S Y=^ABMDCPT(ABM,0)
 ..I $P(Y,U,3)["ESTABLISHED" D  Q
 ...S ABMCPTTB("OUT","DEF")=$P(Y,U,4)
 ..S ABMCPTTB("OUT","L")=$P(Y,U,4)
 ..S ABMCPTTB("OUT","H")=$P(Y,U,5)
 K AUPNCPT
 S X=$$CPT^AUPNCPT(ABMVDFN)
 ;Make this code act different depending on SERVCAT
 I '$D(ABMP("RELBENE")) D REL^ABMDVSTH,BENE^ABMDVSTH S ABMP("RELBENE")=1
 ;We'll kinda do it the old way for SERVCAT=H & grab subsequent days
 ;from the I visits.  How will we know the discharge visit?
 ;ABMP("DDT") should have the discharge date in it for comparison
 ;There exist special CPT codes for observation.  I need to find out
 ;if they are being handled OK by this code.
 ;In this rtn need the serv cat for child visit not the H visit
 N SERVCAT
 S SERVCAT=$P(ABMCHV0,U,7)
 I "HOS"[SERVCAT,'$D(ABMP("DDT")) D HOSP Q
 ; I need to compare the current date with discharge date.
 I "ID"[SERVCAT,$D(ABMP("DDT")),ABMCHVDT<ABMP("DDT") D MIDDAY^ABMDVSTH Q
 I "ID"[SERVCAT,$D(ABMP("DDT")),ABMCHVDT=ABMP("DDT") D DISCHRG^ABMDVSTH Q
 I "AR"[SERVCAT D OP
 Q
 ;
 ;If either of the following ifs are false the code in 1.6 would goto
 ;the OP section
HOSP ;
 I $D(^AUPNVINP("AD",ABMVDFN))=10 S ABMDA=$O(^AUPNVINP("AD",ABMVDFN,"")) I $D(^AUPNVINP(ABMDA,0)) D  K ABMI Q
 .S ABMI(0)=^AUPNVINP(ABMDA,0)
 .;ABMI("ATYPE") is 3P code
 .;ABMI("DSTAT") discharge status
 .S ABMI("ATYPE")=2,ABMI("DSTAT")=1,ABMI("ASRC")=2
 .I $P(ABMI(0),U,4)]"",$P($G(^DIC(45.7,$P(ABMI(0),U,4),9999999)),U)="07" S ABMI("ATYPE")=4
 .;2 is transfer, 4-7 is death, 1 & 3 are discharge, 
 .I $P(ABMI(0),U,6)]"",$D(^DIC(42.2,$P(ABMI(0),U,6),9999999)) S ABMI("DSTAT")=$S($P(^(9999999),U)=2:2,$P(^(9999999),U)>3&($P(^(9999999),U)<8):20,1:1)
 .I $P(ABMI(0),U,7)]"","23"[$P($G(^DIC(42.1,$P(ABMI(0),U,7),9999999)),U) S ABMI("ASRC")=4
 .I $D(ABMP("NEWBORN")) S ABMI("ATYPE")=4
 .;A for admission source, N for newborn
 .S ABM("ASRC")="A" I ABMI("ATYPE")=4 S ABMI("ASRC")=1,ABM("ASRC")="N"
 .;On 3P Code file.  T is admission type code, 3rd subscript is
 .;.01 field.
 .;Here ATYPE gets converted to the ien for the code
 .;P is for discharge status
 .S ABMI("ATYPE")=$O(^ABMDCODE("AC","T",ABMI("ATYPE"),""))
 .;2nd subscript is A or N
 .S ABMI("ASRC")=$O(^ABMDCODE("AC",ABM("ASRC"),ABMI("ASRC"),""))
 .S ABMI("DSTAT")=$O(^ABMDCODE("AC","P",ABMI("DSTAT"),""))
 .;DDT is date of discharge
 .S (ABMP("DDT"),ABMI("DDT"))=$P($P(ABMI(0),U),".")
 .;DHR discharge hour
 .S ABMI("DHR")=$E($P($P(ABMI(0),U,1),".",2),1,2)
 .S ABMI("DHR")=$S(ABMI("DHR")="":12,ABMI("DHR")>-1&(ABMI("DHR")<24):ABMI("DHR"),1:12)
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 .S DR=".63////"_ABMI("DDT")_";.64////"_ABMI("DHR")_";.59////"_$P(ABMI(0),U,12)_";.51////"_ABMI("ATYPE")_";.52////"_ABMI("ASRC")_";.53////"_ABMI("DSTAT")
 .D ^DIE
 .K DA,DIE,DR
 .;ADT is the date from the visit file - admission date
 .S (ABMI("ADT"),ABMP("ADMITDT"),ABMP("HDATE"))=$P($P(ABMP("V0"),U),".")
 .S ABMI("AHR")=$E($P(+ABMP("V0"),".",2),1,2)
 .S ABMI("AHR")=$S(ABMI("AHR")="":12,ABMI("AHR")>-1&(ABMI("AHR")<24):ABMI("AHR"),1:12)
 .S ABMI("SAMEDAY")=0,X1=ABMI("DDT"),X2=ABMI("ADT") D ^%DTC S ABMI("COVD")=$S(X>0:X,1:1) S:X=0 ABMI("SAMEDAY")=1
 .S Y=$P(ABML(ABMP("PRI"),ABMP("INS")),U,4,5)
 .I $L(Y)>1 D
 ..S X1=$S($P(Y,U,2):$P(Y,U,2),1:ABMI("DDT"))
 ..S X2=$S(+Y:+Y,1:ABMI("ADT"))
 ..D ^%DTC
 ..S ABMI("COVD")=X
 .S:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,0)) ^ABMDCLM(DUZ(2),ABMP("CDFN"),25,0)="^9002274.3025P"
 .S DA(1)=ABMP("CDFN")
 .D CLEAN(25)
 .;Node 25 contains the revenue code subfile
 .;The CLEAN subrtn prevents dupes in subfiles
 .S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",25,"
 .;S DIC(0)="LE",X=120,DIC("DR")=".02////"_ABMI("COVD")_";.03////"_$P($G(^ABMDFEE(ABMP("FEE"),31,X,0)),U,2)  ;abm*2.6*2 3PMS10003A
 .S DIC(0)="LE",X=120,DIC("DR")=".02////"_ABMI("COVD")_";.03////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),31,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 .;Q:(+$G(X)&($P($G(^ABMDFEE(ABMP("FEE"),31,X,0)),U,2)=0)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 .;Q:(+$G(X)&($P($$ONE^ABMFEAPI(ABMP("FEE"),31,X,ABMP("VDT")),U)=0)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 HEAT15806
 .S ABMSRC="02|"_ABMDA_"|CPT"
 .S DIC("DR")=DIC("DR")_";.17////"_ABMSRC
 .;K DD,DO D FILE^DICN  ;abm*2.6*4 HEAT15806
 .I ($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)="Y") K DD,DO D FILE^DICN  ;abm*2.6*4 HEAT15806
 .I (($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y")&(+$G(X)&($P($$ONE^ABMFEAPI(ABMP("FEE"),31,X,ABMP("VDT")),U)'=0))) K DD,DO D FILE^DICN  ;abm*2.6*4 HEAT15806
 .S:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,0)) ^ABMDCLM(DUZ(2),ABMP("CDFN"),27,0)="^9002274.3027P"
 .;Node 27 is the medical procedure subfile
 .;This first one is entering the CPT code for the day of admission
 .S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",27,",DIC(0)="LE"
 .D CLEAN(27)
 .;note:uncommented above line during patch 10 testing
 .S X=$$CPT^ABMDVSTH("INI")
 .;Q:($P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)=0&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 .;Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)=0&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 HEAT15806
 .;S DIC("DR")=".03////1;.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)  ;abm*2.6*2 3PMS10003A
 .S DIC("DR")=".03////1;.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 .;Next line set correspond diagnosis if only 1 POV
 .I $D(ABMP("CORRSDIAG")) S DIC("DR")=DIC("DR")_";.06////1"
 .S DIC("DR")=DIC("DR")_";.07////"_ABMCHVDT
 .S DIC("DR")=DIC("DR")_";.17////"_ABMSRC
 .;K DD,DO D FILE^DICN  ;abm*2.6*4 HEAT15806
 .I ($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)="Y") K DD,DO D FILE^DICN  ;abm*2.6*4 HEAT15806
 .I (($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y")&(+$G(X)&($P($$ONE^ABMFEAPI(ABMP("FEE"),31,X,ABMP("VDT")),U)'=0))) K DD,DO D FILE^DICN  ;abm*2.6*4 HEAT15806
 .S ABMP("COVD",ABMCHVDT)=""
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 .S DR=".61////"_ABMI("ADT")_";.62////"_ABMI("AHR")_";.71////"_ABMI("ADT")_";.72////"_ABMI("DDT")_";.54////90;.55////"_ABMI("ADT")_";.56////"_ABMI("DDT") D ^DIE
 .S ABMI("PCD")=$S('ABMI("SAMEDAY"):ABMI("COVD")+1,1:1)
 .S DR=".57////"_ABMI("PCD")_";.73////"_ABMI("COVD")_";.74////N;.75////N"
 .D ^DIE K DR
 .Q
 Q:SERVCAT="H"   ;Treat as OP if O or S
OP ; Outpatient
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 S ABMI("ATYPE")=2,ABMI("DSTAT")="01",ABMI("ASRC")=1
 S DR=".51///"_ABMI("ATYPE")_";.52///"_ABMI("ASRC")_";.53///"_ABMI("DSTAT")
 D ^DIE
 I $G(ABMP("PRIMVSIT")) D
 .;ADT is the date from the visit file - admission date
 .S (ABMI("ADT"),ABMP("ADMITDT"),ABMP("HDATE"))=$P($P(ABMP("V0"),U),".")
 .S ABMI("AHR")=$E($P(+ABMP("V0"),".",2),1,2)
 .S ABMI("AHDR")=$S(ABMI("AHR")="":12,ABMI("AHR")>-1&(ABMI("AHR")<24):ABMI("AHR"),1:12)
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 .S DR=".61////"_ABMI("ADT")_";.62////"_ABMI("AHR")  ;admit date/hour
 .S DR=DR_";.63////"_ABMI("ADT")  ;discharge date
 .S DR=DR_";.64////"_$S($P($G(^AUTNINS(ABMP("INS"),0)),U)["NORTH CAROLINA MEDICAID":(ABMI("AHR")+1),1:ABMI("AHR"))  ;discharge hour
 .D ^DIE
 D WT  ;get patient weight from PCC
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S Y=^ABMDCLM(DUZ(2),ABMP("CDFN"),7)
 I $P(Y,U,2)<Y D
 .S DR=".72////"_+Y
 .D ^DIE
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,3)<2,ABMP("V0")'=ABMCHV0 D
 .;Don't change it if already >1 and child visit
 .S DR=".73////"_1 D ^DIE
 ; There is an assumption
 ;that if the ABMP("MD") var is true the patient saw a doctor 
 ;and it is a chargeable visit.
 ;Piece 7 of the param file is Auto Set level of svc.
 ; clinic 39 is pharmacy
 K ABMX
 S ABMSRC="BC|DEF|CPT"
 N N
 S N=""
 F  S N=$O(AUPNCPT(N)) Q:N=""  D  Q:$D(ABMX)
 .;If the CPT code is not in the range it is not the code for visit
 .I +AUPNCPT(N)<ABMCPTTB("OUT","L") Q
 .I +AUPNCPT(N)>ABMCPTTB("OUT","H") Q
 .S ABMX=+AUPNCPT(N)
 .S ABMSRC=$P($P(AUPNCPT(N),U,4),".",2)_"|"_$P(AUPNCPT(N),U,5)_"|CPT"
 ;If the CPT code is not in the V file, the provider is an MD, the
 ;clinic is not pharmacy, and the Auto Set Level of Svc parameter is
 ;set then set CPT to the default outpatient level.
 I '$D(ABMX),ABMP("MD"),ABMP("CLN")'=39,$P($G(^ABMDPARM(DUZ(2),1,2)),U,7)'=0 D
 .S ABMX=ABMCPTTB("OUT","DEF")
 I '$D(ABMX) Q                  ;Quit if no CPT code
 S:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,0)) ^(0)="^9002274.3027P"
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",27,",DIC(0)="LE"
 D CLEAN(27)
 S X=ABMX
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;S DIC("DR")=".03////1;.04////"_$P($G(^ABMDFEE(ABMP("FEE"),19,X,0)),U,2)  ;abm*2.6*2 3PMS10003A
 S DIC("DR")=".03////1;.04////"_$P($$ONE^ABMFEAPI(ABMP("FEE"),19,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DIC("DR")=DIC("DR")_";.06////1"
 S DIC("DR")=DIC("DR")_";.07////"_ABMCHVDT
 S DIC("DR")=DIC("DR")_";.17////"_ABMSRC
 K DD,DO D FILE^DICN
 K ABMI,ABMX,DA,DIC,DIE,DR
 Q
 ;
CLEAN(ABMSUB,ABMALL) ;EP - Clean out old values from ABMSUB node
 N ABMJ,ABMFDA,FILE,IENS
 S ABMALL=$G(ABMALL)
 S:'$D(DA) DA(1)=ABMP("CDFN")
 I $G(ABMCHV0)=$G(ABMP("V0")),$D(^ABMDCLM(DUZ(2),DA(1),ABMSUB))>1 D
 .S ABMJ=0
 .F  S ABMJ=$O(^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ)) Q:'ABMJ  D
 ..Q:'$D(^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ,0))
 ..S Y=^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ,0)
 ..I 'ABMALL,($P(Y,U,17)="M") Q
 ..S IENS=ABMJ_","_DA(1)_","
 ..S FILE=9002274.30+(ABMSUB/10000)
 ..S ABMFDA(FILE,IENS,.01)="@"
 ..D FILE^DIE("KE","ABMFDA")
 ..K ABMFDA(FILE)
 ..Q:'ABMALL
 ..S ABMSRC=""
 ..F  S ABMSRC=$O(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC)) Q:ABMSRC=""  D
 ...Q:'$D(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,ABMJ))
 ...K ^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,ABMJ,ABMSUB)
 Q
WT ; get patient weight from V Measurement file
 S ABMVMIEN=0
 S ABMVMFLG=0
 F  S ABMVMIEN=$O(^AUPNVMSR("AD",ABMVDFN,ABMVMIEN)) Q:ABMVMIEN=""  D  Q:ABMVMFLG=1
 .Q:$P($G(^AUPNVMSR(ABMVMIEN,0)),U,2)'=ABMP("PDFN")  ;verify patient
 .Q:($O(^AUTTMSR("B","WT",0)))'=($P($G(^AUPNVMSR(ABMVMIEN,0)),U))
 .S DR=".1211////"_$P($G(^AUPNVMSR(ABMVMIEN,0)),U,4)
 .D ^DIE
 Q
