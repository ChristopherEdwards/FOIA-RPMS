BEHOLPCI ;MSC/IND/PLS - Lab POC Component KIDS Support ;23-Mar-2009 22:44;DKM
 ;;1.1;BEH COMPONENTS;**048001**;June 18, 2008
 ;=========================================================
 ;EP - Environment Check
ENV ;
 Q
 I '$$PATCH^XPDUTL("LR*5.2*1025") D
 .W !!,"The supporting Lab v5.2 patch 1025 has not been installed."
 .W !,"The component will be disabled! Use vcManager to enable.",!
 .N DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR
 Q
PREINIT ;EP - Preinitialization
 Q
POSTINIT ;EP - Postinitialization
 N IEN
 D REGNMSP^CIAURPC("BLRPOC","CIAV VUECENTRIC")
 S IEN=$$FIND1^DIC(19930.2,,,"INDIANHEALTHSERVICE.BEH.POCLAB.BEHLABPOC")
 I IEN,$$PATCH^XPDUTL("LR*5.2*1025") D
 .S FDA(19930.2,IEN_",",13)="@"
 .D FILE^DIE("K","FDA")
 Q
