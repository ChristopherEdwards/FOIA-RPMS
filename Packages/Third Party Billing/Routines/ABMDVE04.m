ABMDVE04 ; IHS/ASDST/DMJ - Recreate cancelled claim from PCC ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Allows user to look up visit by patient and reset .04 field
 ;in visit file and creates ABILL X-ref so claim will be
 ;recreated by claim generator
START ;EP
 S DIC="^AUPNPAT("
 S DIC(0)="AEMQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",Y))"
 D ^DIC
 I Y<0 G Q
 S DFN=+Y
 S DIC="^AUPNVSIT("
 S DIC(0)="AEQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",DFN,Y))&'$P(^AUPNVSIT(Y,0),U,11)"
 D ^DIC
 I Y<0 G Q
 S ABMV=+Y
 S Y=^AUPNVSIT(ABMV,0)
 N ABMDTC,ABMDTM
 S ABMDTC=$P(Y,U,2)
 S ABMDTM=$P(Y,U,13)
 I $P(Y,U,4)=1 D
 .S DIE=DIC
 .S DR=".04///@"
 .S DA=ABMV
 .D ^DIE
 I '$D(^AUPNVSIT("ABILL",ABMDTC,ABMV)),'$D(^AUPNVSIT("ABILL",+ABMDTM,ABMV)) D
 .S ^AUPNVSIT("ABILL",ABMDTC,ABMV)=""     ;Set ABILL X-ref
 W !!,"Claim will be created for this visit next time claim generator runs."
 G START
 ;
Q K DIC,DIE,ABMV,DR
 Q
