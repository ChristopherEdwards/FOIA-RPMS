APSPRXN ;IHS/MSC/MGH - Unmapp ;04-Sep-2013 12:45;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1017**;Sep 23, 2004;Build 40
EN ;EP
 N APSPNUM,APSPQ,APSPARY,APSPNAME,QFLG,APSPCNT
 S APSPQ=""
 ;All or selection of  drugs
 W @IOF
 W !,"Drugs without RxNorm codes",!!
 D DEV
 Q
DEV ;EP
 N XBRP,XBNS
 S XBRP="OUT^APSPRXN"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 N IEN,NODE,INACT,DRUG,INACTDT,NDC,VA,VANDC,VAIEN,RXNORM
 U IO
 D HDR
 S IEN=0 F  S IEN=$O(^PSDRUG(IEN)) Q:IEN=""!('+IEN)  D
 .S (VANDC,VA)=""
 .S INACTDT=$$GET1^DIQ(50,IEN,100,"I")
 .Q:+INACTDT
 .S RXNORM=$$GET1^DIQ(50,IEN,9999999.27)
 .Q:+RXNORM
 .S DRUG=$$GET1^DIQ(50,IEN,.01,"E")
 .S NDC=$$GET1^DIQ(50,IEN,31)
 .S NDC=$TR(NDC,"-","")
 .S VAIEN=$$GET1^DIQ(50,IEN,22,"I")
 .I VAIEN'="" D
 ..S VA=$$GET1^DIQ(50.68,VAIEN,.01)
 ..S VANDC=$$GET1^DIQ(50.68,VAIEN,13)
 .I $L(VANDC)=12 S VANDC=$E(VANDC,2,12)
 .S APSPARY(DRUG)=IEN_U_NDC_U_VA_U_VANDC
 S APSPQ=0
 S DRUG="" F  S DRUG=$O(APSPARY(DRUG)) Q:DRUG=""!(+APSPQ)  D
 .S NODE=$G(APSPARY(DRUG))
 .S IEN=$P(NODE,U,1),NDC=$P(NODE,U,2),VA=$P(NODE,U,3),VANDC=$P(NODE,U,4)
 .W !,IEN,?8,$E(DRUG,1,50),?58,NDC
 .W !,?10,$E(VA,1,44),?58,VANDC,!
 .I $Y+4>IOSL,IOST["C-" D PAUS Q:APSPQ  D HDR
 .Q:APSPQ=1
 K APSPARY
 Q
PAUS ;
 N DTOUT,DUOUT,DIR
 S DIR("?")="Enter '^' to Halt or Press Return to continue"
 S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to Halt"
 D ^DIR
 I $D(DUOUT) S APSPQ=1
 Q
HDR ;
 I IOST["C-" W @IOF
 W !,"Active Drugs missing RxNorm codes"
 W !,"IEN",?8,"Drug Name",?58,"NDC"
 W !,?10,"VA Product",?58,"VA NDC",!
 Q
REMAP ;EP Option to reset a local NDC and map to RxNorm or just set an RxNorm
 N APSPNUM,RXNORM
 W @IOF
 W !,"Update NDC and RxNorm",!!
ASK ;
 N D,DIC,Y,DA,DR,DIE,IEN,NDC,NDCAP,ZDATA,NAME,IN,OUT,%,DLAYGO
 W ! S DIC="^PSDRUG(",DIC(0)="QEALMNTV",D="BCAP",DLAYGO=50,DIC("T")="" D IX^DIC K DIC,D I Y<0 Q
 S IEN=$P(Y,U,1)
 S NAME=$P(Y,U,2)
 S APSPNUM=$$DIR^APSPUTIL("S^NDC:Match on NDC;NAME:Name Lookup",,,.APSPQ)
 Q:APSPNUM=""!(APSPNUM="^")
 S RXNORM=""
 I APSPNUM="NDC" D
 .S DIE="^PSDRUG(",DR=31,DA=IEN D ^DIE
 .S NDC=$$GET1^DIQ(50,IEN,31)
 .S NDC=$$STRIP^XLFSTR(NDC,"-")
 .S:$L(NDC)=12 NDC=$E(NDC,2,12)
 .W !,"Querying Apelon site..."
 .S IN=NDC_"^N" S ZDATA=$$DI2RX^BSTSAPI(IN)
 .S RXNORM=$P(ZDATA,U,1)
 .I RXNORM'="" D STORE(RXNORM) W !,RXNORM_" code stored"
 .E  W !,"Unable to map this NDC code"
 I APSPNUM="NAME" D
 .N CNT,CT,RXCODE,DESC,DATA
 .K ARR,^TMP($J)
 .S CT=0
 .W !,"Querying Apelon site..."
 .S IN=$P(NAME," ",1)_"^F^1552^^^^P"
 .S OUT="^TMP(""APSPRX"",$J)"
 .S ZDATA=$$SEARCH^BSTSAPI(.OUT,.IN)
 .I ZDATA>0 D
 ..S CNT="" F  S CNT=$O(@OUT@(CNT)) Q:CNT=""  D
 ...;S DATA=$G(@OUT@(CNT,"CON"))_U_$G(@OUT@(CNT,"PRE","TRM"))
 ...S DATA=$G(@OUT@(CNT,"PRE","TRM"))
 ...S DESC=$G(@OUT@(CNT,"PRE","TRM"))
 ...S ^TMP($J,CNT,0)=DATA
 ...S ^TMP($J,"B",DATA)=CNT
 ...S CT=CT+1
 ..S ^TMP($J,0)=U_U_CT_U_CT
 ..W !!,"Enter ? to see the list of RxNorm Name Matches"
 ..W !,"Enter ^ to quit the selection",!
 ..S DIC="^TMP($J," S DIC(0)="AEQ",DIC("A")="Select RxNORM Item: "
 ..D ^DIC
 ..S RXNORM=Y
 ..S RXCODE=$G(^TMP("APSPRX",$J,$P(RXNORM,U,1),"PRE","DSC"))
 ..I RXCODE'=-1&(RXCODE'="") D STORE(RXCODE) W !,RXCODE_" code stored"
 W !!,"Do you want to continue?" S %=2 D YN^DICN
 I %=1 G ASK
 Q
STORE(RXNORM) ;store code
 NEW DA,DIE,DR,X,Y
 S DA=IEN
 S DIE="^PSDRUG("
 S DR="9999999.27///^S X=RXNORM"
 D ^DIE
 Q
