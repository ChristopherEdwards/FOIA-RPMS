BYIMIMM5 ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE;**3,4,5,6,7**;JUN 01, 2015;Build 242
 ;
BRIDGE ;EP;TO MONITOR HL7 BRIDGE
 I $G(^%ZOSF("OS"))'["OpenM-NT" D  Q
 .W !!,"Bridge monitor functions not available for Windows systems."
 .D PAUSE^BYIMIMM6
 F  D B1 Q:$G(BYIMQUIT)
 Q
B1 ;BRIDGE MONITOR
 D ^XBCLS
 K DIR
 S DIR(0)="SO^1:Show STATUS of HL7 Bridge Service;2:CANCEL HL7 Bridge Process;3:START HL7 Bridge Service"
 S DIR("A")="Choose a function"
 D ^DIR
 K DIR
 I X=""!$D(DIRUT)!$D(DIROUT) D END Q
 S HL7FUNC=X
 I HL7FUNC=1 D STAT Q
 I HL7FUNC=2 D CANC Q
 I HL7FUNC=3 D START Q
 Q
STAT ;EP;TO DETERMINE BRIDGE STATUS
 I $G(^%ZOSF("OS"))["NT" D  Q
 .W "(Bridge monitor functions not available for Windows systems.)"
 D ^XBCLS
 S HL7CMD="ps -ef |grep java"
 D HOSTCMD
 D PAUSE^BYIMIMM6
 Q
CANC ;
 D ^XBCLS
 S HL7CMD="ps -ef |grep java"
 D HOSTCMD
 K DIR
 S DIR(0)="FO^1:9",DIR("A")="Enter Process ID to CANCEL "
 D ^DIR
 Q:X=""!$D(DIRUT)!($D(DIROUT))
 S HL7JOBN=X
 W !!,"Killing PROCESS ID ",HL7JOBN
 S HL7CMD="kill -9 "_HL7JOBN
 D HOSTCMD
 Q
START ;
 D ^XBCLS
 S HL7CMD="cd "_$P($P($G(^BYIMPARA(DUZ(2),0)),U,2),"requests")
 D HOSTCMD
 Q:$L(X)'>3
 S HL7NAME=X
 S HL7CMD="./hl7bridge.sh"
 D HOSTCMD
 W !!,"Enabling HL7 Services",!!
 S HL7CMD="ps -ef |grep java"
 D HOSTCMD
 Q
HOSTCMD ;
 S X="S X=$$TERMINAL^%"_"HOSTCMD(HL7CMD)"
 X X
 Q
END ;
 K X,HL7FUNC,HL7CMD,HL7JOBN,HL7NAME,DIR
 S BYIMQUIT=1
 Q
RXA(BYIMDA) ;EP;TO SET THE IIS CODE FOR RXA-11.4
 Q:$G(BYIMDA)=""
 S BYIMDA=+^AUTTSITE(1,0)
 I $P(^BYIMPARA(0),U,4)>1,'$D(^BYIMPARA(BYIMDA,0)) D
 .W !!,"BYIM Parameter Sites:"
 .S BYIMDA=0
 .F  S BYIMDA=$O(^BYIMPARA(BYIMDA)) Q:'BYIMDA  D
 ..W !?10,$P($G(^DIC(4,BYIMDA,0)),U)
 .S DIC="^BYIMPARA("
 .S DIC(0)="AEMQZ"
 .S DIC("A")="Which BYIM Parameter Site: "
 .D ^DIC
 .I 'Y S BYIMDA="" Q
 .S BYIMDA=+Y
 Q:'BYIMDA
 I '$D(^BYIMPARA(BYIMDA,1)) F  S BYIMDA=$O(^BYIMPARA(BYIMDA)) Q:'BYIMDA  Q:$D(^BYIMPARA(BYIMDA,"LAST EXPORT"))
 Q:'BYIMDA
 N BYIMRXA,DISP,BYIMQUIT
 I $O(^BYIMPARA(BYIMDA,5,0)) D RXA1 Q
 W !!,"Some state Immunization Information Systems (IIS) require facilities to send"
 W !,"a code to identify the facility at which the immunization was administered or"
 W !,"identify the vaccine inventory location instead of the facility name."
 W !!,"If you need to add state IIS assigned code(s) please enter 'Y' below."
 W !,"You will be prompted to select the name of your facility and then"
 W !,"enter the state assigned code."
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Add State IIS Assigned Facility Codes"
 S DIR("B")="NO"
 W !!
 D ^DIR
 K DIR
 Q:'Y
RXA1 N BYIMX
 S BYIMQUIT=0
 F  D RXAACT Q:BYIMQUIT
 Q
 ;-----
RXAACT ;ADDITIONAL SITE ACTION
 I '$O(^BYIMPARA(BYIMDA,5,0)) D RXAADD
 I '$O(^BYIMPARA(BYIMDA,5,0)) S BYIMQUIT=1 Q
 D RXADISP
 K DIR
 S DIR(0)="SO^1:Edit Codes;2:Add codes;3:Delete codes"
 W !!
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT=1 Q
 I Y=1 D RXAEDIT Q
 I Y=2 D RXAADD Q
 I Y=3 D RXADEL
 Q
 ;-----
RXAADD ;SELECT FACILITIES FOR STATE RXA CODE
 N BYIMX,BYIMY
 S DIC="^DIC(4,"
 S DIC(0)="AEMQZ"
 ;S DIC("S")="I $D(^AUTTSITE(""B"",Y))!$D(^AUTTSITE(1,19251,""B"",Y))"
 S DIC("A")="Select Facility for the IIS assigned Code: "
 W !
 D ^DIC
 I Y<1 S BYIMQUIT=1 Q
 S BYIMX=+Y
 S BYIMY=$P(^DIC(4,+Y,0),U)
 K DIR
 S DIR(0)="FO^1:50"
 S DIR("A")="Enter State IIS Code assigned for **"_BYIMY_"**"
 W !
 D ^DIR
 K DIR
 I X="" S BYIMQUIT=1 Q
 S BYIMY=X
 S X=BYIMX
 S DA(1)=DUZ(2)
 S DIC="^BYIMPARA("_DUZ(2)_",5,"
 S DIC(0)="L"
 S DIC("DR")=".02////"_BYIMY
 S DINUM=X
 D FILE^DICN
 I Y<1 S BYIMQUIT=1 Q
 Q
 ;------
RXADISP ;DISPLAY EXISTING IIS RXA CODES
 N DISP,J,X,Y,Z
 S J=0
 S X=0
 F  S X=$O(^BYIMPARA(DUZ(2),5,X)) Q:'X  S Y=$G(^(X,0)) D:Y
 .S Z=$P($G(^DIC(4,X,0)),U)
 .Q:Z=""
 .S Z=Z_" (IEN "_X_")"
 .S J=J+1
 .S X(Z)=Y
 S J=0
 S X=""
 F  S X=$O(X(X)) Q:X=""  D
 .S J=J+1
 .S $E(DISP(J),11)=J
 .S $E(DISP(J),16)=X
 .S $E(DISP(J),60)=$P(X(X),U,2)
 .S BYIMRXA(J)=+X(X)
 S BYIMJ=J
 W @IOF
 W !?5,"State IIS Assigned Administered-at or Vaccine Inventory Location Code"
 W !!?10,"NO."
 W ?15,"Facility"
 W ?59,"IIS Code"
 W !?10,"---",?15,"------------------------------",?59,"--------------------"
 S J=0
 F  S J=$O(DISP(J)) Q:'J  D
 .W !,DISP(J)
 Q
 ;------
RXAEDIT ;EDIT SITE
 D RXASEL
 Q:'$G(DA)
RXAE1 S DA(1)=BYIMDA
 S DR=".02T"
 S DIE="^BYIMPARA("_BYIMDA_",5,"
 W !!,"Edit  IIS Facility Code for: ",$P($G(^DIC(4,DA,0)),U)
 D ^DIE
 K DA,DR,DIE
 Q
 ;-----
RXADEL ;DELETE SITE
 D RXASEL
 Q:'$G(DA)
 S X=+^BYIMPARA(BYIMDA,5,DA,0)
 S X=$P($G(^DIC(4,X,0)),U)
 W !?10,X
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Delete export/import site: "_X
 S DIR("B")="NO"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
 S DA(1)=BYIMDA
 S DIK="^BYIMPARA("_BYIMDA_",5,"
 D ^DIK
 K DA,DIK
 Q
 ;-----
RXASEL ;SELECT ADDITION SITE
 I BYIMJ=1 S Y=1 D RXASEL1 Q
 K DIR
 S DIR(0)="NO^1:"_BYIMJ
 S DIR("A")="Select Facility number"
 W !!
 D ^DIR
 K DIR
RXASEL1 Q:'Y
 Q:'$G(BYIMRXA(Y))
 S DA=BYIMRXA(Y)
 Q
 ;-----
