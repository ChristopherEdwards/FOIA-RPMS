APSPPCC1 ;IHS/CIA/PLS - PCC Hook for Pharmacy Package - Continued ;01-Mar-2011 05:14;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1003,1005,1007,1009,1010**;Sep 23, 2004
 ; Modified - IHS/MSC/PLS - 02/05/08 - POV API modified
 ;                          08/25/10 - SET+1
 ;                          02/10/11 - EN and new EN1 EP
 ; Prompt and store POV value in APSP POV CACHE parameter
EN(DFN,RXIEN,SUS) ;EP
 N POV,RFIEN
 S RFIEN=$O(^PSRX(RXIEN,1,$C(1)),-1)
 Q:$L($$GET^XPAR("SYS","APSP POV CACHE",+RXIEN_","_+RFIEN))  ; already have a POV stored
 I $G(SUS) D
 .Q:'$$GET1^DIQ(9009033,+$G(PSOSITE),402,"I")
 .W !!,"Processing POV entry for suspense...",!
 .D EN1
 E  I $$GET1^DIQ(9009033,+$G(PSOSITE),315,"I") D
 .Q:'RFIEN  ; Must have a refill
 .Q:'$$CONFIRM("Is this a Pharmacy Only Visit (Paperless refill)?",1)
 .W !!,"Processing paperless refill...",!
 .D EN1
 Q
EN1 ;EP - Prompt user
 W !,"Rx# "_$P($G(^PSRX(RXIEN,0)),U,1),"  Drug:",$P($G(^PSDRUG(+$P($G(^PSRX(RXIEN,0)),U,6),0)),U),!
 S POV=$$POV(RXIEN,RFIEN)
 D SET(RXIEN,RFIEN,POV)
 Q
 ; Prompt and store POV value in cache
 ; Input:  RXIEN - Prescription IEN
 ;         RFIEN - Refill IEN under Prescription IEN
POV(RXIEN,RFIEN) ;
 N RXVMED,POV,VIS,CLININD,SIGN
 S POV=""
 ; Check for Indication Code - IHS/MSC/PLS - 02/05/08 - Added lookup of Sign/Indication Code if available.
 S SIGN=$P($G(^PSRX(RXIEN,999999921)),U)
 S CLININD=$P($G(^PSRX(RXIEN,999999921)),U,2)
 I $L(CLININD) D  Q:$L(POV) POV
 .W !,"Do you wish to use the Sign/Symptom associated with the prescription?",!
 .S X=CLININD,DIC=80,DIC(0)="EMQ" D ^DIC
 .I $G(Y)>0 D
 ..S POV=$P(Y,U,2)_U_$$PRVNARR^APSPPCC($S($L(SIGN):SIGN,1:$$GET1^DIQ(80,+Y,3)))
 ;
 S RXVMED=$$GETVMED(RXIEN)
 I 'RXVMED D
 .S POV=$$ACTPROB(RXIEN)
 .S:'$L(POV) POV=$$PROVNAR
 E  D
 .S VIS=+$$GET1^DIQ(9000010.14,RXVMED,.03,"I")
 .I '$D(^AUPNVSIT(VIS,0)) D
 ..S POV=$$ACTPROB(RXIEN)
 ..S:'$L(POV) POV=$$PROVNAR
 .E  I '$D(^AUPNVPOV("AD",VIS)) D
 ..S POV=$$ACTPROB(RXIEN)
 ..S:'$L(POV) POV=$$PROVNAR
 .E  D
 ..S POV=$$POVS(VIS)
 ..S:'$L(POV) POV=$$ACTPROB(RXIEN)
 ..S:'$L(POV) POV=$$PROVNAR
 Q POV
 ;
 ; Prompt for Active Problem List
 ; List is restrict to Problems with Active ICD9 Codes
ACTPROB(RXIEN) ;
 N POV,CNT,PRB,PIEN,DFN,DIR,DUOUT,DIRUT,DTOUT,ICDIEN
 S POV=""
 S DFN=+$$GET1^DIQ(52,RXIEN,2,"I")
 I $D(^AUPNPROB("AC",DFN)) D
 .W !,"Problem list:"
 .S (PIEN,CNT)=0 F  S PIEN=$O(^AUPNPROB("AC",DFN,PIEN)) Q:'PIEN  D
 ..Q:$$GET1^DIQ(80,+$$GET1^DIQ(9000011,PIEN,.01,"I"),100,"I")  ;Quit if Inactive
 ..S CNT=CNT+1 W !?5,CNT,")",?8,$$GET1^DIQ(9000011,PIEN,.01),?15,$$GET1^DIQ(9000011,PIEN,.05) S PRB(CNT)=PIEN
 .I CNT>0 D
 ..S DIR(0)="N^1:"_CNT_":0",DIR("A")="Please select the appropriate Problem List diagnosis for the drug prescribed."
 ..D ^DIR
 ..I '$D(DIRUT) D
 ...S PIEN=PRB(+Y)
 ...S POV=$$ICD(+$P(^AUPNPROB(PIEN,0),U))_U_+$P(^AUPNPROB(PIEN,0),U,5)
 Q POV
 ; Prompt for provider narrative
PROVNAR() ;
 N POV,DIR,DUOUT,DIRUT,DTOUT
 S POV=""
 W !,"Please enter a narrative describing the diagnosis."
 S DIR("A")="Diagnosis Narrative",DIR(0)="9000010.07,.04" D ^DIR
 I '$D(DIRUT) D
 .S POV=".9999"_U_+Y
 E  S POV="999.9"_U_$$PRVNARR^APSPPCC("MEDICATION REFILL")
 Q POV
 ; Prompt for existing purpose of visit
POVS(VIEN) ;
 N POV,POVS,DIR,DUOUT,DIRUT,DTOUT,CNT,PIEN
 S (CNT,PIEN)=0,POV=""
 W !,"Purpose of Visit List:"
 F  S PIEN=$O(^AUPNVPOV("AD",VIEN,PIEN)) Q:'PIEN  D
 .Q:$$POVSEL(PIEN)  ; Screen POVs
 .S CNT=CNT+1 W !?5,CNT,")",?8,$$GET1^DIQ(9000010.07,PIEN,.01),?15,$$GET1^DIQ(9000010.07,PIEN,.04) S POVS(CNT)=PIEN
 I CNT>0 D
 .S DIR(0)="N^1:"_CNT_":0",DIR("A")="Please select the appropriate diagnosis for the drug prescribed."
 .S DIR("B")=1
 .S DIR("?")="Select a number or enter ^ for more choices."
 .D ^DIR
 .I '$D(DIRUT) D
 ..S PIEN=POVS(+Y)
 ..S POV=$$ICD(+$P(^AUPNVPOV(PIEN,0),U))_U_+$P(^AUPNVPOV(PIEN,0),U,4)
 Q POV
 ; Return ICD Code for given IEN
ICD(IEN) ;
 Q $S($$GET1^DIQ(80,+IEN,100,"I"):".9999",1:$$GET1^DIQ(80,+IEN,.01))
 ; Return code selection status
 ; Output: 0 - Code is selectable
 ;         1 - Code is NOT selectable
POVSEL(PIEN) ;EP
 N RES
 S RES=+$$GET1^DIQ(80,+$$GET1^DIQ(9000010.07,PIEN,.01,"I"),100,"I")  ; Check for Inactive flag
 S RES=RES!($$GET1^DIQ(9000010.07,PIEN,.01)="V68.1")   ; Exclude from selection
 Q RES
 ; Set data into XTMP global node
SET(RXIEN,RFIEN,POV) ;
 ;IHS/MSC/PLS - 08/25/2010 - Changed to cache POV in parameter
 D ADD^XPAR("SYS","APSP POV CACHE",+RXIEN_","_+RFIEN,$TR(POV,U,"~"))
 ;L +^XTMP("APSPPCC.VPOV"):2
 ;S ^XTMP("APSPPCC.VPOV",0)=$$FMADD^XLFDT(DT,7)_U_$$DT^XLFDT
 ;S ^XTMP("APSPPCC.VPOV",RXIEN,RFIEN)=POV
 ;L -^XTMP("APSPPCC.VPOV")
 Q
 ; Confirm
CONFIRM(PROMPT,DEFAULT) ; EP
 N DIR
 S DIR("A")=$G(PROMPT)
 S DIR(0)="Y",DIR("B")=$S(+$G(DEFAULT):"Yes",1:"No")
 D ^DIR
 Q Y>0
 ;Return VMED pointer
GETVMED(RXIEN) ;EP
 N RES
 ;First try to return the VMED for the first refill.
 S RES=+$$GET1^DIQ(52.1,"1,"_RXIEN_",",9999999.11,"I")
 Q:RES RES
 ;Otherwise return VMED for the prescription
 Q +$$GET1^DIQ(52,RXIEN,9999999.11,"I")
