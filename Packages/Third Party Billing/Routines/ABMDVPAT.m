ABMDVPAT ; IHS/ASDST/DMJ - CLAIM FOR ONE PAT ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;;Y2K/OK - IHS/ADC/JLG 12-03-97
 S DIC="^AUPNPAT("
 S DIC(0)="AEMQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",Y))"
 D ^DIC
 I Y<1 D  Q
 .W !,"No patient selected."
 W !
 D QUEUE
 W !
 S DIR(0)="Y",DIR("A")="Another patient",DIR("B")="NO"
 D ^DIR
 I Y G ABMDVPAT
 K DIC,DIR,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
 ;
QUEUE ;EP - requires patient DFN in Y
 S ZTSAVE("ABMDFN")=+Y
 S ZTRTN="^ABMDVCK",ZTIO=""
 S ZTDESC="Generate Third Party Billing Claim for one patient."
 S ZTDTH=$H
 D ^%ZTLOAD
 I $D(ZTSK)[0 W !,"Claim generator not run." Q
 E  W !,"Claim generator queued for selected patient."
 K DIR
 S DIR(0)="E"
 D ^DIR
 Q
