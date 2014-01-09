BYIMIMM5 ;IHS/CIM/THL - IMMUNIZATION DATA INTERCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE INTERFACE;**3**;JAN 15, 2013;Build 79
 ;
BRIDGE ;EP;TO MONITOR HL7 BRIDGE
 I $G(^%ZOSF("OS"))'["OpenM-NT" D  Q
 .W !!,"Bridge monitor functions not available for Windows systems."
 .D PAUSE^BYIMIMM
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
 D PAUSE^BYIMIMM
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
 S X=$$TERMINAL^%HOSTCMD(HL7CMD)
 Q
END ;
 K X,HL7FUNC,HL7CMD,HL7JOBN,HL7NAME,DIR
 S BYIMQUIT=1
 Q
