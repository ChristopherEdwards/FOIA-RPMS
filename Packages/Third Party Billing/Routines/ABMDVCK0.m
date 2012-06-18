ABMDVCK0 ; IHS/ASDST/DMJ - PCC Visit Edits ;      
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/19/96 4:49 PM
 ;Split off from ABMDVCK
 ;
 ; IHS/PIMC/JLG - 9/24/02 - V2.5 P2 - PAB-1001-90120
 ;      Jim supplied code to fix 72-hour rule for Medicaid
 ;
 ; IHS/SD/SDR - 12/7/2004 - V2.5 P7 - An issue has arisen with the new
 ;      version of Pharmacy (7).  They send the clinic code of Pharmacy
 ;      and TPB thinks it's unbillable if inpatient.  Changing the clinic
 ;      to general if inpatient and clinic is pharmacy.
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25368
 ;   Changes so duplicate claims won't generate and claims
 ;   will generate under correct DUZ(2).
 ;
 ; *********************************************************************
 ;
VCHX(ABMVDFN) ;EP -  CHECK EACH VISIT
 N ABMCHV0,ABMCHVDT,ABMV
 Q:'$D(^AUPNVSIT(ABMVDFN,0))
 S ABMCHV0=^AUPNVSIT(ABMVDFN,0)
 S ABMCHVDT=$P(ABMCHV0,U)\1
 S ABMP("LDFN")=$P(ABMCHV0,"^",6)
 ; The following are checks to see if a claim can be generated
 ; Reasons are put into field .04 of the visit file
 ;Codes 1, 2, 20, 22, 24, & 25 are not referred to in this section
 ;
 ;8= Location not specified for this visit
 I ABMP("LDFN")="" D  Q
 .D PCFL^ABMDVCK2(8)
 .S ABMP("FLAG1")=1
 .S ^TMP($J,"PROC",ABMVDFN)=""
 ;
 ;10= Visit location not found in 3P site parameters file
 S ABMARPS=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",9)
 I $O(^ABMDCLM(ABMP("LDFN"),"AV",ABMVDFN,"")) S ABMARPS=""
 I 'ABMARPS,'$D(^ABMDPARM(ABMP("LDFN"),0)) D  Q
 .D PCFL^ABMDVCK2(10)
 .S ABMP("FLAG1")=1
 .S ^TMP($J,"PROC",ABMVDFN)=""
 I ABMARPS,'$D(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)) D  Q
 .Q:$D(^BAR(90052.05,ABMP("LDFN"),ABMP("LDFN")))
 .Q:$D(^BAR(90052.05,ABMP("LDFN"),DUZ(2)))
 .D PCFL^ABMDVCK2(10)
 .S ABMP("FLAG1")=1
 .S ^TMP($J,"PROC",ABMVDFN)=""
 I ABMP("LDFN")'=DUZ(2),'ABMARPS Q
 I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)),"^",3)'=DUZ(2) Q
 I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)),"^",6)>ABMP("VDT") D  Q
 .D PCFL^ABMDVCK2(32)
 .S ABMP("FLAG1")=1
 .S ^TMP($J,"PROC",ABMVDFN)=""
 I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)),"^",7),$P(^(0),"^",7)<ABMP("VDT") D  Q
 .D PCFL^ABMDVCK2(33)
 .S ABMP("FLAG1")=1
 .S ^TMP($J,"PROC",ABMVDFN)=""
 S ^TMP($J,"PROC",ABMVDFN)=""
 S ABMP("FLAG1")=1
 ;
 ;1= Claim manually purged
 I $P(ABMP("V0"),U,4)=1 D  Q
 .Q:ABMP("V0")=ABMCHV0
 .D PCFL^ABMDVCK2($P(ABMP("V0"),U,4))
 .; give a status if a child visit
 ;
 ;23= Unknown status
 I $P(ABMCHV0,U,4)="" D PCFL^ABMDVCK2(23)
 ;
 ;3= PCC visit deleted
 I $P(ABMCHV0,U,11) D PCFL^ABMDVCK2(3) Q
 ;
 ;4= Contract type of visit
 I $P(ABMCHV0,"^",3)="C" D PCFL^ABMDVCK2(4) Q
 ;
 ;5= VA type of visit
 I $P(ABMCHV0,"^",3)="V" D PCFL^ABMDVCK2(5) Q
 ;
 ;6= Visit date prior to backbilling limit
 ;Use parent visit for this check
 I +$P($G(^ABMDPARM(DUZ(2),1,0)),U,16) D  I +ABMP("V0")<X D PCFL^ABMDVCK2(6) Q
 .S X1=DT
 .S X2=0-($P(^ABMDPARM(DUZ(2),1,0),U,16)*30.417)
 .D C^%DTC
 S ABMP("PDFN")=$P(ABMP("V0"),U,5)
 S ABMP("CLN")=$P(ABMCHV0,U,8)              ; Clinic
 I "IDH"[SERVCAT,(ABMP("CLN")=39) S ABMP("CLN")=1
 ;
 ;7= Patient not specified for this visit
 I ABMP("PDFN")="" D PCFL^ABMDVCK2(7) Q
 ;
 ;9= Entry found this patient date of service in file # 9002273.02
 I $D(^ABPVFAC("PC",ABMP("PDFN"),$P($P(ABMP("V0"),U),"."))) D PCFL^ABMDVCK2(9) Q
 ;
 ;11 is unbillable clinic
 I ABMP("CLN")]"",$D(^ABMDPARM(DUZ(2),1,15,ABMP("CLN"))) D PCFL^ABMDVCK2(11) Q
 ;
 ;21= PCC service category not amb, hosp, in hosp, observ, or day surg
 I "ADHOISRT"'[$P(ABMCHV0,U,7) D PCFL^ABMDVCK2(21) Q
 I ABMP("CLN")="" S ABMP("CLN")=1
 ;
 ;12= Previous claim exists for this patient, visit date, and clinic
 ;13= Patient not found in file #2
 I '$D(^DPT(ABMP("PDFN"),0)) D PCFL^ABMDVCK2(13) Q
 ;
 ;14= Location not found in file #9999999.06
 I '$D(^AUTTLOC(DUZ(2),0)) D PCFL^ABMDVCK2(14) Q
 ;
 ;15= Clinic not found in file 40.07
 I '$D(^DIC(40.7,ABMP("CLN"),0)) D PCFL^ABMDVCK2(15) Q
 ;
 ;16= No V files pointing to this visit
 ;These are the local mods that are not likely to end up on the national release
         S ABMIPGMN=0
         I '$P(ABMCHV0,U,9) D  Q:'ABMIPGMN
         .D PCFL^ABMDVCK2(16)
         .I $P($G(^ABMDPARM(DUZ(2),1,0)),U,18)'=2 Q
         .I "HID"'[SERVCAT Q
         .S IENS=ABMP("PDFN")_","
         .S X=$$GET1^DIQ(2,IENS,.105,"I")
         .K IENS
         .Q:'X     ;If no current admission don't assume inpat status
         .S X1=DT
         .S X2=ABMCHVDT
         .D ^%DTC
         .I X<30 S ABMP("NOKILLABILL")=1 Q
         .S ABMIPGMN=1
         ;because there is no POV, need a flag!
 I '$P(ABMCHV0,U,9) D PCFL^ABMDVCK2(16) Q
 ;
 ;17= No data found in file #9000010.07 (V POV) for this visit
 N OK,ABMORLAG
 S ABMORLAG=$P($G(^ABMDPARM(DUZ(2),1,4)),U,8)
 S:'ABMORLAG ABMORLAG=45   ;Orphan lag time in days
 I ("ID"'[SERVCAT)!(("ID"[SERVCAT)&ABMPARNT=""),'$D(^AUPNVPOV("AD",ABMVDFN)) D  Q:'OK
 .S X1=ABMP("VDT")
 .S X2=ABMORLAG
 .D C^%DTC
 .I X>DT D  Q
 ..S ABMP("NOKILLABILL")=1
 ..D PCFL^ABMDVCK2(17)
 ..S OK=0
 .S OK=$$MISSPOV^ABMDVCK2(ABMVDFN)
 .I ABMIPGMN S OK=1   ;Code to create claim after 30D IP stay
 .I 'OK D PCFL^ABMDVCK2(17)
 ;If orphan & less than lag time days old, no claim & not kill ABILL
 Q:$G(ABMP("NOKILLABILL"))
 ;Look elswhere if no provider 
 ;
 ;18= No data found in file #9000010.06 (V PROVIDER) for this visit
 I '$D(^AUPNVPRV("AD",ABMVDFN)) D  Q:'OK&'ABMIPGMN
 .S X1=ABMP("VDT")
 .S X2=ABMORLAG
 .D C^%DTC
 .I X>DT S ABMP("NOKILLABILL")=1
 .S OK=$$ORPHAN^ABMDVCK2(ABMVDFN)
 .Q:OK
 .D PCFL^ABMDVCK2(18)
 Q:$G(ABMP("NOKILLABILL"))
 I ABMP("V0")=ABMCHV0 D ELG^ABMDLCK(ABMVDFN,.ABML,ABMP("PDFN"),ABMP("VDT"))
 ;
 ; 41 ; Visit date occurs after date of death
 I +$G(ABMNOELG)=41 D PCFL^ABMDVCK2(41) Q
 ;
 ;19= No eligibility found for this patient
 I $D(ABML)'=10 D PCFL^ABMDVCK2(19) Q
 ;
 ; 34-58 = No eligibility found for this patient (specific)
 I $O(ABML(""))=99 D  Q
 .S ABMINS2=0
 .F  S ABMINS2=$O(ABML(99,ABMINS2)) Q:'+ABMINS2  D
 ..S ABMNO=$P(ABML(99,ABMINS2),U,6)
 .I +$G(ABMNO) D PCFL^ABMDVCK2(ABMNO)
 .I '+$G(ABMNO) D PCFL^ABMDVCK2(19)
 .K ABMNO
 ;
 ; 29 ; Visit prior to billing start date
 I $O(ABML(""))=97 D PCFL^ABMDVCK2(29) Q
 N ABMPRIM,I,P
 N ABMPRIEN
 ;Check for pre-existing claim for visit.
 S Y=$O(^ABMDCLM(DUZ(2),"AV",ABMVDFN,""))
 I Y D
 .;Use its active insurer if it exists.
 .I $O(^ABMDCLM(DUZ(2),Y,13,0)) S I=$P(^ABMDCLM(DUZ(2),Y,0),U,8)
 .E  Q
 .Q:'I
 .S P=0
 .F  S P=$O(ABML(P)) Q:'P  D  Q:$D(ABMPRIM)
 ..I $D(ABML(P,I)) D
 ...S ABMPRIM=$P(ABML(P,I),U,3)
 ...S ABMPRIEN=I
 I '$D(ABMPRIM) D
 .S P=$O(ABML(""))
 .S I=$O(ABML(P,""))
 .S ABMPRIM=$P(ABML(P,I),U,3)   ;Get primary insurance
 .S ABMPRIEN=I
 I ABMPRIM="" S ABMPRIM="UNK"
 N NOCLAIM
 I $D(ABMP("PRIMVSIT")),ABMP("PRIMVSIT")'=ABMVDFN K ABMP("PRIMVSIT")
 I "H"=SERVCAT K ABMP("OPONADMIT")
 ;Only make check if medicare, medicaid, or RR
 I "AS"[SERVCAT,"DMR"[ABMPRIM D   ;Determine if there is an admit in 72 hrs
 .I "MR"[ABMPRIM,$P($G(^ABMNINS(DUZ(2),ABMPRIEN,0)),U,8)=0 Q
 .I "D"=ABMPRIM,$P($G(^ABMNINS(DUZ(2),ABMPRIEN,0)),U,8)'=1 Q
 .S ABM72=$$IN72HVIS(ABMVDFN)
 .I ABM72=2 D
 ..S ABMP("NOKILLABILL")=1
 ..D PCFL^ABMDVCK2(31)
 ..S NOCLAIM=1
 G QNOKILAB
RULE72H ; Done if admission within 72 hours found.
 S ABMP("OPONADMIT")=""
 K ABMP("PRIMVSIT")
 K ABMP("NOKILLABILL")
 ;Check if claim already has billing pointer
 I $P(ABMCHV0,U,28)]"" S NOCLAIM=1 Q
 ;Check if claim already exists. If so add this A visit to claim
 S Y=$O(^ABMDCLM(DUZ(2),"AV",ABMV,""))
 I Y S ABMP("CDFN")=Y Q
 S DIE="^AUPNVSIT("
 S DA=ABMVDFN
 S DR=".28////"_ABMV
 D ^DIE
 ;To make this work, need to put value in parent field.
 S NOCLAIM=1
 Q
QNOKILAB Q:$D(ABMP("NOKILLABILL"))
 Q:$D(NOCLAIM)=1&($D(ABMP("CDFN"))=0)
 N ABMIDONE
 S ABMIDONE=0
 ;ABMIDONE is used to end this loop once rtn ABMDVST is actually run
 K ABMP("DENTDONE"),ABMP("RXDONE"),ABMP("MEDSCHKD")
 S ABMP("PRI")=""
 F  S ABMP("PRI")=$O(ABML(ABMP("PRI"))) Q:('ABMP("PRI")!(ABMP("PRI")>96))  D INS^ABMDVCK2 Q:$D(ABMP("NOKILLABILL"))!$D(ABMP("LOCKFAIL"))
 Q
 ;
IN72H(ABMCLMNO) ;EP
 ;Extrinsic to tell if claim is inside 72 hour rule.
 I ABMCLMNO'=+ABMCLMNO Q "INVALID"
 S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMCLMNO,11,"AC","P",""))
 I 'ABMVIEN S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMCLMNO,11,""))
 I 'ABMVIEN Q "UNKNOWN"
 Q $$IN72HVIS(ABMVIEN)
 ;
IN72HVIS(ABMVIEN) ;Extrinsic to tell if visit is inside 72 hour rule
 Q:$G(^AUPNVSIT(ABMVIEN,0))=""
 N ABMRDM3,W
 I '$D(ABMP("VDT")) D
 .S ABMP("VDT")=+^AUPNVSIT(ABMVIEN,0)
 .S ABMP("VDT")=ABMP("VDT")\1
 I '$D(ABMP("PDFN")) S ABMP("PDFN")=$P(^AUPNVSIT(ABMVIEN,0),U,5)
 S ABM72=0
 I $P(^AUPNVSIT(ABMVIEN,0),U,7)="H" D  Q ABM72
 .S X1=ABMP("VDT")
 .S X2=-3
 .D C^%DTC
 .S ABMRDM3=9999999-X+.25
 .S W=9999999-ABMP("VDT")-.1
 .F  S W=$O(^AUPNVSIT("AA",ABMP("PDFN"),W)) Q:'W!(W>ABMRDM3)  D
 ..S ABMV=""
 ..F  S ABMV=$O(^AUPNVSIT("AA",ABMP("PDFN"),W,ABMV)) Q:'ABMV  D
 ...Q:ABMV=ABMVIEN
 ...S ABM72=1
 .Q
 S X1=ABMP("VDT")
 S X2=3
 D C^%DTC
 I X>DT Q 2   ;Visit date within 3 days of today.
 ;ABMRDM3 is an inverse date-3.  W is start point
 S X1=ABMP("VDT")
 S X2=3
 D C^%DTC
 S ABMRDM3=9999999-ABMP("VDT")+.25
 S W=9999999-X
 F  S W=$O(^AUPNVSIT("AAH",ABMP("PDFN"),W)) Q:'W!(W>(ABMRDM3))  D
 .;AAH X-REF is only hospitalizations -- patient, inverse date, visit
 .S ABMV=""
 .F  S ABMV=$O(^AUPNVSIT("AAH",ABMP("PDFN"),W,ABMV)) Q:'ABMV  D
 ..S ABM72=1
 Q ABM72
