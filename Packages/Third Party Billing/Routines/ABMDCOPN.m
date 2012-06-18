ABMDCOPN ; IHS/ASDST/DMJ - RE-OPEN COMPLETED CLAIM ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option
 ;
START ;START
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 S DIC="^ABMDCLM(DUZ(2),",DIE=DIC,DIC(0)="AEMQ"
 F  D  Q:$G(ABM("QUIT"))
 .W !
 .D ^DIC I Y<0 S ABM("QUIT")=1 Q
 .S ABM("C#")=+Y
 .S ABM("CSTATUS")=$P(^ABMDCLM(DUZ(2),ABM("C#"),0),"^",4)
 .S ABM("SNAR")=$F("FERUCX",ABM("CSTATUS"))
 .S ABM("SNAR")=$P("^Flagged as Billable^Edit Mode^Claim Rejected^Uneditable (Billed)^Complete^Closed","^",ABM("SNAR"))
 .W !,"Current Claim Status is: ",ABM("SNAR")
 .I ABM("CSTATUS")="U" W *7," ??" Q
 .I ABM("CSTATUS")="X"!(ABM("CSTATUS")="C") D OPEN  ;CLOSED OR COMPLETE
 .I ABM("CSTATUS")'="X"&(ABM("CSTATUS")'="C") D CLOSE  ;CLOSED OR COMPLETE
 K DIC,ABM Q
OPEN ;OPEN CLOSED CLAIM
 S DIR(0)="Y",DIR("A")="Re-Open Claim",DIR("B")="NO" D ^DIR K DIR
 Q:Y'=1
 S DA=ABM("C#"),DR=".04///E" D ^DIE
 N DA,DIC,DIE,X,Y,DIR
 S DA(1)=ABM("C#")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 S DIC("P")=$P(^DD(9002274.3,69,0),U,2)
 S DIC(0)="L"
 S X="NOW"
 S DIC("DR")=".02////"_DUZ_";.03////O"
 D ^DIC
 W !!,"Claim # ",ABM("C#")," now in Edit Mode.",!
 Q
CLOSE ;CLOSE OPEN CLAIM
 S DIR(0)="Y",DIR("A")="Change Status to Closed",DIR("B")="NO" D ^DIR K DIR
 Q:Y'=1
 S DA=ABM("C#"),DR=".04///X" D ^DIE
 N DA,DIC,DIE,X,Y,DIR
 S DA(1)=ABM("C#")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 S DIC("P")=$P(^DD(9002274.3,69,0),U,2)
 S DIC(0)="L"
 S X="NOW"
 S DIC("DR")=".02////"_DUZ_";.03////C"
 D ^DIC
 S ABMANS=Y
 K DIC,DIE,X,Y,DIR,DA,DR
 S DA(1)=ABM("C#")
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 S DA=+ABMANS
 S DR=".04R"
 S DIE("NO^")=""
 D ^DIE
 W !!,"Claim # ",ABM("C#")," Now in Status Closed.",!
 Q
