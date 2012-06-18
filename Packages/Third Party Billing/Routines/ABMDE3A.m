ABMDE3A ; IHS/ASDST/DMJ - Edit Page 3 - QUESTIONS - part 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM14693/IM16105 - Added code for Accident State
 ; IHS/SD/SDR - v2.5 p9 - IM16001 - Made accident related editable
 ; IHS/SD/SDR - v2.5 p10 - IM20022 - Use ROI/AOB multiples
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*6 - 5010 -changed AoB to accept "W"
 ;
1 ;
 W !
 S DIR(0)="Y"
 S DIR("A")="["_ABM("#")_"] Was RELEASE OF INFORMATION obtained"
 S DIR("?")="Is a Signed Statement for Release of Information on File"
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,4)]"" S DIR("B")=$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,4)="Y":"Y",1:"N")
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("Y")=Y
 I Y=0 D N1 Q  ;no ROI obtained
 D Y1
 Q
Y1 ; EP
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".74////Y;.711R~Release Obtained Date.." D ^DIE K DR
 Q
N1 ;
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".74////N;.711////@" D ^DIE K DR
 Q
 ;
2 ;
 W !
 ;S DIR(0)="Y"  ;abm*2.6*6 5010
 S DIR(0)="S^Y:YES;N:NO;W:Patient refuses to assign benefits"  ;abm*2.6*6 5010
 S DIR("A")="["_ABM("#")_"] Was ASSIGNMENT OF BENEFITS Obtained"
 S DIR("?")="Is a Signed Statement for Assignment of Benefits on File"
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,5)]"" S DIR("B")=$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,5)="Y":"Y",1:"N")
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("Y")=Y
 ;start old code abm*2.6*6 5010
 ;I Y=0 D N2 Q
 ;D Y2
 ;end old code start new code 5010
 I Y="N" D N2 Q
 I Y="Y" D Y2 Q
 I Y="W" D W2
 ;end new code 5010
 Q
Y2 ; EP
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".75////Y;.712R~Assignment Obtained Date.." D ^DIE K DR
 Q
N2 ;
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".75////N;.712////@" D ^DIE K DR
 Q
 ;start new code abm*2.6*6 5010
W2 ;
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".75////W;.712////@" D ^DIE K DR
 Q
 ;end new code 5010
 ;
3 W ! S DIR(0)="Y",DIR("A")="["_ABM("#")_"] Was the Visit Related to an Accident",DIR("?")="Was the Purpose of the Visit Associated with an Accident"
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),($P(^(8),U,2)]""!($P(^(8),U,3)]"")) S DIR("B")="Y"
 E  S DIR("B")="N"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I Y=1 G ACTYPE
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)'=""!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)'="") D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)'="" D
 ..S DA(1)=ABMP("CDFN")
 ..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",51,"
 ..S DA=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)
 ..D ^DIK
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 .S DR=".82////@;.83////@;.84////@"
 .D ^DIE K DR
 Q
 ;
ACTYPE S DIR(0)="SO^1:AUTO ACCIDENT;2:AUTO-NO FAULT INSURANCE INVOLVED;3:COURT ACTION POSSIBLE;5:OTHER ACCIDENT",DIR("A")="Type of Accident"
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),$P(^(8),U,3)]"" S DIR("B")=$P(^(8),U,3)
 D ^DIR K DIR
 Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 I Y="" S Y=5
 S ABM("Y")=Y
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".83///"_Y D ^DIE K DR
 ;
ACDT K DIR W ! S DIR(0)="D^:"_ABMP("VDT")_":EX",DIR("A")="Accident Date",DIR("?")="Enter the date the accident occurred that necessitated treatment" I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)]"" S DIR("B")=$$SDT^ABMDUTL($P(^(8),U,2))
 D ^DIR K DIR Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 S ABM("X")=Y
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".82///"_Y D ^DIE K DR
 ;
ACHR W ! S DIR(0)="NO^0:23",DIR("A")="Accident Hour",DIR("?")="Enter the hour the accident occurred that necessitated treatment" I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,4)]"",$P(^(8),U,4)<24,$P(^(8),U,4)>-1 S DIR("B")=$P(^(8),U,4)
 D ^DIR K DIR
 S:X="" Y=99
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".84////"_Y D ^DIE K DR
ACST S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".816" D ^DIE K DR
 ;
ACCODE ;EP - Entry Point for setting UB-82 Accident Code
 I $L(ABM("Y"))=1 S ABM("Y")="0"_ABM("Y")
 S (DINUM,X)=$O(^ABMDCODE("AC","O",ABM("Y"),"")) G ACHR:X=""
 K DD,DO S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",51,",DIC(0)="LE",DIC("DR")=".02////"_ABM("X")
 I '$D(^ABMDCLM(DUZ(2),DA(1),51,0)) S ^ABMDCLM(DUZ(2),DA(1),51,0)="^9002274.3051P^^"
 D FILE^DICN
 Q
 ;
XIT Q
