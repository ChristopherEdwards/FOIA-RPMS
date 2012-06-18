ABMDVST ; IHS/ASDST/DMJ - PCC Visit Stuff ;     
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/19/96 4:45 PM
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM12246/IM17548
 ;    Added code to put defaults on claim for CLIAs
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 8
 ;    Added tag for insurer replace and splitting routine
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM19717/IM20374
 ;   Added to check for when to merge visits into one claim
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20610
 ;    Fix Medicare Part B check so only one claim will generate
 ;
 ; IHS/SD/SDR - v2.5 p10 - task order item 1
 ;    Calls for ChargeMaster added to national code.  Calls were
 ;    supplied by Lori Butcher
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21500
 ;    Added code to check new V Med field POINT OF SALE BILLING STATUS
 ;    and only generate claim if at least one med wasn't billed by POS
 ;    or was billed and rejected
 ;
 ; *********************************************************************
VAR ;
 N ABMSRC,DA,DIE,DIK
 K ABMP("DUP"),ABMP("NEWBORN")
 I '$D(ABMP("VTYP")) D
 .S ABMP("VTYP")=$$VTYP^ABMDVCK1(ABMVDFN,SERVCAT,ABMP("INS"),ABMP("CLN"))
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,7)="N" D  Q
 .S DIE="^AUPNVSIT("
 .S DA=ABMVDFN
 .S DR=".04////22"
 .D ^DIE
 ;Find new Claim ien if ien null
 ;Not sure what will happen here if the claim is a split claim.
 ;Clearly only one claim will be updated.
 I '$G(ABMP("CDFN")) S ABMP("CDFN")=$O(^ABMDCLM(DUZ(2),"AV",ABMVDFN,""))
 I ABMP("CDFN")<1 S ABM=0 F  S ABM=$O(^ABMDCLM(DUZ(2),"B",ABMP("PDFN"),ABM)) Q:'ABM  D  Q:ABMP("CDFN")
 .I '$D(^ABMDCLM(DUZ(2),ABM,0)) K ^ABMDCLM(DUZ(2),"B",ABMP("PDFN"),ABM) Q
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,2)'=ABMP("VDT")  ;encounter(visit) date
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,3)'=ABMP("LDFN")  ;visit location
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,7)'=ABMP("VTYP")  ;visit type
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,6)'=ABMP("CLN")  ;clinic
 .D GETPPRV  ;get primary provider
 .D GETPPOV  ;find primary DX
 .I ABMVPRV'=0,(ABMCPRV=ABMVPRV),(ABMVICD'=0),(ABMCICD=ABMVICD) S ABMP("CDFN")=ABM
 I ABMARPS,ABMP("CDFN")<1 D  Q:$G(ABMP("NOKILLABILL"))=2
 .S ABMP("CDFN")=$O(^ABMDCLM(ABMP("LDFN"),"AV",ABMVDFN,""))
 .I ABMP("CDFN"),'$D(^ABMDCLM(ABMP("LDFN"),ABMP("CDFN"),0)) D
 ..K ^ABMDCLM(ABMP("LDFN"),"AV",ABMVDFN,ABMP("CDFN"))
 ..S ABMP("CDFN")=0
 .Q:ABMP("CDFN")<1
 .S ABMP("NOKILLABILL")=2
 G NEW:ABMP("CDFN")<1
 Q:$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0))=""
 ;25= Existing claim modified
 N R
 S R=$P(^AUPNVSIT(ABMVDFN,0),U,4)
 I R'=24!((R=24)&('$D(ABMNFLG))),R'=25 D
 .S DIE="^AUPNVSIT("
 .S DA=ABMVDFN
 .S DR=".04////25"
 .D ^DIE
 L +^ABMDCLM(DUZ(2),ABMP("CDFN")):10 E  S ABMP("LOCKFAIL")=1 Q
 S DR=""
 S Y=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 I $P(Y,U,10)'=DT D
 .S DR=".1////"_DT
 I $P(Y,U,2)'=ABMP("VDT") D
 .S DR=".02////"_ABMP("VDT")_$S(DR]"":";"_DR,1:"")
 S DR=$S(DR]"":DR_";",1:"")_".06////"_ABMP("CLN")
 I $P(Y,U,7)'=ABMP("VTYP"),$D(ABMP("PRIMVSIT")) D
 .S DR=$S(DR]"":DR_";",1:"")_".07////"_ABMP("VTYP")
 ;The following works because the only way that 97 will be the value is
 ;if the primary insurer is billed elswhere (e.g. Data Center)
 I ABMP("PRI")=97 S DR=$S(DR]"":DR_";",1:"")_".04////U;.08////"_ABMP("INS")
 ;The next line checks the active insurer field.  If it is null & the
 ;insurer in ABMP("INS") is the primary insurer set and the mode of 
 ;export
 I $P(Y,U,8)="",DR'[".08",'$O(ABML(ABMP("PRI")),-1),$O(ABML(ABMP("PRI"),""))=ABMP("INS") D
 .N ABMMODE
 .S ABMMODE=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,4)
 .S DR=$S(DR]"":DR_";",1:"")_".08////"_ABMP("INS")_$S(ABMMODE:";.14///"_ABMMODE,1:"")
 I DR]"" D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .D ^DIE
 D VSIT
 D FRATE
 D OTHER
 ;if routine BCMZINHO exists and there are tran codes in the table run BCMZINHO
 I $T(^BCMZINHO)]"",$O(^BCMTCA(0)) D:$D(^AUPNVSIT("AD",ABMVDFN)) ^BCMZINHO  ;IHS/CMI/LAB-chargemaster call
 I $O(^ABMDBILL(DUZ(2),"AV",ABMVDFN,0)),$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="U" D  Q:ABM("OUT")
 .S ABM("OUT")=1
 .Q:$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMP("INS")))
 .S DA=$O(^ABMDBILL(DUZ(2),"AV",ABMVDFN,0))
 .S ABM=$P($G(^ABMDBILL(DUZ(2),DA,0)),U,8)   ; Active Insurer
 .Q:'ABM
 .I $P($G(^AUTNINS(ABM,2)),U)="I" D          ;Type of ins = Indian Pat
 ..S ABM("OUT")=0
 ..S DIE="^ABMDBILL(DUZ(2),"
 ..S DR=".04////X"                           ;Mark bill as cancelled
 ..D ^ABMDDIE
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".04////F;.08////"_ABMP("INS")
 ..D ^ABMDDIE
 I $D(^ABMDBILL(DUZ(2),"AS",ABMP("CDFN"))) Q
 Q
 ;
 ; *********************************************************************
NEW ;CREATE NEW CLAIM
 I $D(^ABMDBILL(DUZ(2),"AV",ABMVDFN)) D  Q
 .S DIE="^AUPNVSIT("
 .S DA=ABMVDFN
 .S DR=".04////20"
 .D ^DIE
 ;BILLED POS insurer?
 I $P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P" D
 .S ABMVMIEN=0
 .F  S ABMVMIEN=$O(^AUPNVMED("AD",ABMVDFN,ABMVMIEN)) Q:+ABMVMIEN=0  D  Q:$G(ABMPSFLG)=1
 ..I $P($G(^AUPNVMED(ABMVMIEN,11)),U,6)'=1 S ABMPSFLG=1
 I $D(^AUPNVMED("AD",ABMVDFN)),$P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P",($G(ABMPSFLG)'=1) D  Q
 .K ABMPSFLG
 .D PCFL^ABMDVCK(62)  ;billed POS
 S DINUM=$$NXNM^ABMDUTL
 I DINUM="" S ABMP("NOKILLABILL")=1 Q
 K DIC
 S DIC="^ABMDCLM(DUZ(2),"
 S DIC(0)="L"
 S X=ABMP("PDFN")
 K DD,DO
 D FILE^DICN
 I Y<1 S ABMP("NOKILLABILL")=1 Q
 S ABMP("CDFN")=+Y
 L +^ABMDCLM(DUZ(2),+Y):1 E  S ABMP("LOCKFAIL")=1 Q
 S DA=+Y
 S DIE=DIC
 S DR=".02////"_$P($P(ABMP("V0"),U),".")_";.03////"_ABMP("LDFN")
 S DR=DR_";.04////"_"F"_";.06////"_ABMP("CLN")_";.07////"_ABMP("VTYP")
 ;No active insurer if one insurer billed elsewhere
 I '$D(ABML(97)) S DR=DR_";.08////"_ABMP("INS")
 S DR=DR_";.1////"_DT_";.17////"_DT
 D ^DIE
 S DIE="^AUPNVSIT("
 S DA=ABMVDFN
 S DR=".04////24"
 D ^DIE
 D VSIT
 S ABMNFLG=1
 D FRATE
 D OTHER
 ;if routine BCMZINHO exists and there are tran codes in the table run BCMZINHO
 I $T(^BCMZINHO)]"",$O(^BCMTCA(0)) D:$D(^AUPNVSIT("AD",ABMVDFN)) ^BCMZINHO  ;IHS/CMI/LAB-chargemaster call
 K X,Y
 D MAIN^ABMASPLT(ABMP("CDFN"))
 I $P($G(^AUTNINS(+ABMP("INS"),2)),U)="R" D
 .S ABMBONLY=$S($P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U)'="":$P(^ABMDPARM(ABMP("LDFN"),1,5),U),1:2)
 .I (ABMBONLY'=2) Q
 .D MAIN^ABMDSPLB(ABMP("CDFN"))
 Q
 ;
 ; *********************************************************************
VSIT ;
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",11,"
 S DIC(0)="LE"
 I $D(@(DIC_ABMVDFN_")")),'$D(ABMP("PRIMVSIT")) Q
 ;This section needs to be done for non-new claims
 ;Direct set into the claim file
 S DIC("P")=$P(^DD(9002274.3,11,0),U,2)
 K DD,DO,DR,DIC("DR")
 I $D(ABMP("PRIMVSIT")) S DIC("DR")=".02////P"
 S (X,DINUM)=ABMVDFN
 I '$D(@(DIC_ABMVDFN_")")) D
 .D FILE^DICN
 E  D
 .S DIE=DIC
 .S DR=DIC("DR")
 .S DA=DINUM
 .D ^DIE
 .K DIE,DR,DINUM
 K DIC
 Q
 ;
 ; *********************************************************************
FRATE ;
 ;I need code to prevent 2nd visit on claim from undoing eligibility
 N V,INSADD,INSSKIP
 S V=0
 F  S V=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,V)) Q:'V  D  Q:$D(INSADD)
 .I V'=ABMVDFN,$D(^TMP($J,"PROC",V)) D
 ..S IEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMP("INS"),""))
 ..I 'IEN S INSADD="" Q
 ..I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,IEN,0),U,3)?1(1"P",1"I"),ABMP("PRI")>96 S INSSKIP=""
 I '$D(INSSKIP),$D(ABMP("OPONADMIT")) D
 .Q:$P(ABML(ABMP("PRI"),ABMP("INS")),U,3)'?1(1"M",1"R")
 .Q:ABMP("PRI")<97
 .;If the patient has B but not A don't skip.
 .I $G(ABML(ABMP("PRI"),ABMP("INS"),"COV",+$O(ABML(ABMP("PRI"),ABMP("INS"),"COV",""))))="B" Q
 . I $P(ABML(ABMP("PRI"),ABMP("INS")),U,6)=44 S INSSKIP=""
 I '$D(INSSKIP) D ADDCHK^ABMDE2E
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 S ABMX("INS")=ABMP("INS")
 D:'$D(ABMP("BTYP")) BTYP^ABMDEVAR
 D FRATE^ABMDE2X1
 D EXP^ABMDE2X5
 I ABMP("EXP")=22!(ABMP("EXP")=23)!(ABMP("EXP")=3)!(ABMP("EXP")=14)!(ABMP("EXP")=25) D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".922////"_$P($G(^ABMDPARM(ABMP("LDFN"),1,4)),U,11)
 .S DR=DR_";.923///"_$P($G(^ABMDPARM(ABMP("LDFN"),1,4)),U,12)
 .D ^DIE
 K ABMV,ABMX
 Q
 ;
OTHER ;RUN OTHER STUFFING ROUTINES
 ;ABMDVST1 - Purpose of visit
 ;ABMDVST2 - Provider
 ;ABMDVST3 - ICD Procedure
 ;ABMDVST4 - Hospitalization
 ;ABMDVST5 - Pharmacy
 ;ABMDVST6 - Dental
 ;ABMDVST7 - Not used
 ;ABMDVST8 - Not used    
 ;ABMDVST9 - IV Pharmacy
 ;ABMDVS10 - Not used 
 ;ABMDVS11 - Lab
 ;ABMDVS12 - Not used        
 ;ABMDVS13 - CPT CODES
 S ABMACTVI=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)
 I ABMACTVI="" S ABMACTVI=ABMP("INS")
 K ABM("DONE")
 F ABM("COUNTER")=1:1 D  Q:$G(ABM("DONE"))
 .S ABM("ROUTINE")=$S(ABM("COUNTER")<10:"ABMDVST"_ABM("COUNTER"),1:"ABMDVS"_ABM("COUNTER"))
 .Q:(ABM("COUNTER")<5!(ABM("COUNTER")>6))&(ABMACTVI'=ABMP("INS"))&(ABM("COUNTER")<14)
 .S X=ABM("ROUTINE")
 .X ^%ZOSF("TEST") E  S:ABM("COUNTER")>13 ABM("DONE")=1 Q
 .I  D @("^"_ABM("ROUTINE"))
 I ABMACTVI=ABMP("INS") S ABMIDONE=1
 I $T(^BCMDVS01)]"",$O(^BCMTCA(0)) D ^BCMDVS01  ;IHS/CMI/LAB-chargemaster call
 Q
GETPPRV ;
 ;get attending/operating provider from claim
 S ABMCPRV=+$O(^ABMDCLM(DUZ(2),ABM,41,"C","A",0))
 S:ABMCPRV=0 ABMCPRV=+$O(^ABMDCLM(DUZ(2),ABM,41,"C","O",0))
 I ABMCPRV'=0 S ABMCPRV=$P($G(^ABMDCLM(DUZ(2),ABM,41,ABMCPRV,0)),U)
 ;get provider from visit
 S ABMV=0
 F  S ABMV=$O(^AUPNVPRV("AD",ABMVDFN,ABMV)) Q:+ABMV=0  D  Q:+$G(ABMVPRV)'=0
 .Q:$P($G(^AUPNVPRV(ABMV,0)),U,4)'="P"
 .S ABMVPRV=$P($G(^AUPNVPRV(ABMV,0)),U)
 I $G(ABMVPRV)="" S ABMVPRV=0
 Q
GETPPOV ;
 ;get Primary/first entry from claim
 S ABMCICD=+$O(^ABMDCLM(DUZ(2),ABM,17,0))
 ;get Primary or first entry from claim
 S ABMV=0
 K ABMVFST
 S ABMVFST=""
 F  S ABMV=$O(^AUPNVPOV("AD",ABMVDFN,ABMV)) Q:+ABMV=0  D  Q:+$G(ABMVICD)'=0
 .I $G(ABMVFST)="" S ABMVFST=$P($G(^AUPNVPOV(ABMV,0)),U)
 .Q:$P($G(^AUPNVPOV(ABMV,0)),U,12)'="P"
 .S ABMVICD=$P($G(^AUPNVPOV(ABMV,0)),U)
 I +$G(ABMVICD)=0 S ABMVICD=ABMVFST
 Q
