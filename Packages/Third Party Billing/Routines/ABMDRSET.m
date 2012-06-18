ABMDRSET ; IHS/DSD/DMJ - Reset Exported to Unexported ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 K ABM S U="^",ABM("XMIT")=0
 W !!,"If run, this Program will remove a selected Export Batch and reset all ",!,"Bills that are linked to it so that they may be re-exported."
 W !!,"NOTE: Only batches that were exported by you and have not been transmitted to",!?6,"the Area Tracking System may be selected."
SEL W !! K DIC S DIC="^ABMDTXST(",DIC("A")="Select EXPORT Batch: ",DIC(0)="QEAM",DIC("S")="I '$P(^(0),U,6),$P(^(0),U,5)=DUZ" D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G SEL
 K DIR S ABM("Y")=+Y,DIR(0)="Y",DIR("A")="Do you wish to Cancel Export Batch Number "_+Y_" (Y/N)" D ^DIR K DIR G XIT:Y'=1 S Y=ABM("Y")
 S ABM("BAT")=+Y
 ;
 S ABM="" F  S ABM=$O(^ABMDBILL("AX",ABM("BAT"),ABM)) Q:'ABM  D
 .I '$D(^ABMDBILL(ABM,0)) K ^ABMDBILL("AX",ABM("BAT"),ABM)
 .S DIE="^ABMDBILL(",DA=ABM,DR=".04////A;.16///@;.17///@" D ^ABMDDIE
 .S ABM("BILL")=$P(^ABMDBILL(ABM,0),U) I $D(^ABPVFAC("B",ABM("BILL"))) S DIK="^ABPVFAC(",DA=$O(^(ABM("BILL"),"")) D ^DIK
 S DIK="^ABMDTXST(",DA=ABM("BAT") D ^DIK
XIT K ABM
 Q
