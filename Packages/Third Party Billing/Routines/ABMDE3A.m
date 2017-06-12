ABMDE3A ; IHS/ASDST/DMJ - Edit Page 3 - QUESTIONS - part 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**6,13,14,15**;NOV 12, 2009;Build 251
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM14693/IM16105 - Added code for Accident State
 ; IHS/SD/SDR - v2.5 p9 - IM16001 - Made accident related editable
 ; IHS/SD/SDR - v2.5 p10 - IM20022 - Use ROI/AOB multiples
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*6 - 5010 -changed AoB to accept "W"
 ;IHS/SD/SDR - 2.6*13 - exp mode 35; made changes to link Injury Date, Date First Symptom, and 9A Occurrence codes
 ;IHS/SD/SDR - 2.6*14 - HEAT165301 - Removed link that was added in patch 13 to page 9A.
 ;IHS/SD/SDR - 2.6*15 - HEAT165301 - Completely removed link to page 9A.  Now it won't even create the 9A entry.
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
 ;abm*2.6*14 HEAT165301 put back below original code to remove link from page 9A
 ;start old code abm*2.6*13 exp mode 35
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)'=""!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)'="") D
 .;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)'="" D
 .;.S DA(1)=ABMP("CDFN")
 .;.S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",51,"
 .;.S DA=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)
 .;.D ^DIK
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 .S DR=".82////@;.83////@;.84////@"
 .D ^DIE K DR
 ;end old start new exp mode 35
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)'=""!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)'="") D
 ;.S ABMTEST=+$O(^ABMDCODE("AC","O","01",0))
 ;.S ABMI=0
 ;.F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABMI)) Q:'ABMI  D
 ;..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABMI,0)),U)'=ABMTEST Q
 ;..D ^XBFMK
 ;..S DA(1)=ABMP("CDFN")
 ;..S DA=ABMI
 ;..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",51,"
 ;..D ^DIK
 ;.;
 ;.S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 ;.S DR=".82////@;.83////@;.84////@"
 ;.S DR=DR_";.86////@;.816////@"
 ;.D ^DIE K DR
 ;end new exp mode 35
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
ACDT K DIR W ! S DIR(0)="D^:"_ABMP("VDT")_":EX",DIR("A")="Accident Date",DIR("?")="Enter the date the accident occurred that necessitated treatment"
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)]"" S DIR("B")=$$SDT^ABMDUTL($P(^(8),U,2))
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)=""&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,6)'="") S DIR("B")=$$SDT^ABMDUTL($P(^(8),U,6))  ;abm*2.6*12 exp mode 35
 D ^DIR K DIR Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ;S ABM("X")=Y  ;abm*2.6*13 accident date
 S (ABM("X"),ABMP("ACDT"))=Y  ;abm*2.6*13 accident date
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".82///"_Y D ^DIE K DR
 ;
ACHR W ! S DIR(0)="NO^0:23",DIR("A")="Accident Hour",DIR("?")="Enter the hour the accident occurred that necessitated treatment" I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,4)]"",$P(^(8),U,4)<24,$P(^(8),U,4)>-1 S DIR("B")=$P(^(8),U,4)
 D ^DIR K DIR
 S:X="" Y=99
 S:X="@" Y="@"  ;delete hour/ will drop error ;abm*2.6*13 HEAT72979
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".84////"_Y D ^DIE K DR
ACST S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".816" D ^DIE K DR
 ;
ACCODE ;EP - Entry Point for setting UB-82 Accident Code
 ;start old code abm*2.6*13 exp mode 35
 ;I $L(ABM("Y"))=1 S ABM("Y")="0"_ABM("Y")
 ;S (DINUM,X)=$O(^ABMDCODE("AC","O",ABM("Y"),"")) G ACHR:X=""
 ;K DD,DO
 ;S DA(1)=ABMP("CDFN")
 ;S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",51,"
 ;S DIC(0)="LE"
 ;S DIC("DR")=".02////"_ABM("X")
 ;I '$D(^ABMDCLM(DUZ(2),DA(1),51,0)) S ^ABMDCLM(DUZ(2),DA(1),51,0)="^9002274.3051P^^"
 ;D FILE^DICN
 ;end old start new exp mode 35
 ;
 ;start old abm*2.6*15 HEAT165301
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)="" Q
 ;K ABMTEST,ABMI
 ;D ^XBFMK
 ;S DA(1)=ABMP("CDFN")
 ;S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",51,"
 ;S DIC("P")=$P(^DD(9002274.3,51,0),U,2)
 ;S X="`"_+$O(^ABMDCODE("AC","O","01",0))
 ;G ACHR:X=""
 ;S DIC(0)="ML"
 ;K DD,DO
 ;D ^DIC
 ;S DIE=DIC
 ;S DA=+Y
 ;S DR=".02////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)
 ;D ^DIE
 ;end old HEAT165301
 ;end new exp mode 35
 Q
 ;
XIT Q
