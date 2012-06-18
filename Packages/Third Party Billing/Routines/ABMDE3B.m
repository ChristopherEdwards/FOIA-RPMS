ABMDE3B ; IHS/ASDST/DMJ - Edit Page 3 - QUESTIONS - part 3 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20076
 ;    Added EPSDT referral
 ;
5 W ! S DIR(0)="Y",DIR("A")="["_ABM("#")_"] Was Visit an Emergency",DIR("?")="If Emergency Room Utilized as a result of Condition of Medical Severity"
 I $P(ABMP("C0"),U,6)]"",$D(^DIC(40.7,$P(ABMP("C0"),U,6),0)),$P(^(0),U)["EMERGENCY" S DIR("B")="Y"
 E  I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),$P(^(8),U,5)="Y" S DIR("B")="Y"
 I '$D(DIR("B")) S DIR("B")="N"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I Y=1 G ASET
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),$P(^(8),U,5)="Y" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".85///@;.855///@" D ^DIE K DR
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),$P(^(5),U,1)=$O(^ABMDCODE("AC","T",1,"")) S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".51///@" D ^DIE K DR
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),$P(^(5),U,2)=$O(^ABMDCODE("AC","A",7,"")) S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".52///@" D ^DIE K DR
 Q
ASET ;EP - Entry Point for setting Emergency Room charge
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".85///Y"
 D ^DIE K DR
 ;
ASRC I $P(ABMP("C0"),U,7)'=111 Q
 I $P($G(^ABMDCODE(ABMP("CDFN"),5)),U,2)'="" G ATYP
 S X=$O(^ABMDCODE("AC","A",7,"")) G ATYP:X=""
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".52////"_X D ^DIE K DR
 ;
ATYP S X=$O(^ABMDCODE("AC","T",1,"")) Q:X=""
 I $P($G(^ABMDCODE(ABMP("CDFN"),5)),U,1)'="" Q
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".51////"_X D ^DIE K DR
 Q
 ;
6 ; Special Program
 W ! S DIR(0)="Y",DIR("A")="["_ABM("#")_"] Was visit related to a SPECIAL PROGRAM",DIR("?")="If services provided to patient were related to a Special Program"
 I $O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,0))]"" S DIR("B")="Y"
 E  S DIR("B")="N"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I Y=1 G SPPROG
 I $O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,0))]"" S DA(1)=ABMP("CDFN"),ABM("X")=$O(^ABMDCLM(DUZ(2),DA(1),59,0)) I ABM("X")]"" S DA=ABM("X"),DIK="^ABMDCLM(DUZ(2),"_DA(1)_",59," D ^DIK
 Q
 ;
SPPROG K DIC
 K X,Y
 S ABM("DICS")="9002274.3059" X:$D(^DD(ABM("DICS"),.01,12.1)) ^DD(ABM("DICS"),.01,12.1)
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),59))=10 S ABM("X")=$O(^(59,0)) I ABM("X")]"",$D(^(ABM("X"),0)) S ABM("X")=^(0) I $D(^ABMDCODE(ABM("X"),0)) S DIC("B")=$P(^(0),U,1)
 W ! S DIC="^ABMDCODE(",DIC(0)="QEAM" S DIC("A")="Select SPECIAL PROGRAM: " D ^DIC K DIC
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(X="")
 I +Y<1 G 6
SP ;EP - Entry Point for setting UB-82 Special Prog code
 S ABM("Y")=+Y
 S DA(1)=ABMP("CDFN")
 I +$O(^ABMDCLM(DUZ(2),DA(1),59,0))=0 S DIC("P")=$P(^DD(9002274.3,59,0),U,2)
 I +$O(^ABMDCLM(DUZ(2),DA(1),59,0))'=0 D
 .S ABM("X")=$O(^ABMDCLM(DUZ(2),DA(1),59,0))
 .I ABM("X")]"" D
 ..K DIR,X,Y
 ..S DIR(0)="Y"
 ..S DIR("A")="Info in EPSDT fields.  Ok to delete?"
 ..S DIR("B")="Y"
 ..D ^DIR K DIR
 ..S ABMANS=+Y
 ..Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT))
 ..I ABMANS>0 S DA=ABM("X"),DIK="^ABMDCLM(DUZ(2),"_DA(1)_",59," D ^DIK
 I +$O(^ABMDCLM(DUZ(2),DA(1),59,0))'=0,(+$G(ABMANS)<1) Q
 S (DINUM,X)=ABM("Y")
 K DD,DO S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",59,",DIC(0)="LE"
 D FILE^DICN K DIC
 ;EPSDT referral?
 S (DA,ABMPSCD)=+Y
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",59,"
 S DR=".02"
 D ^DIE
 ;If referral, up to 3 reasons
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABMPSCD,0)),U,2)="Y" D  ;referral reason
 .F ABMX=1:1:3 D  Q:(+Y<0)!($D(DTOUT))!($D(DUOUT))
 ..K DIC,DIE,DA,DR,X,Y
 ..S DA(2)=ABMP("CDFN")
 ..S DA(1)=ABMPSCD
 ..S DIC="^ABMDCLM(DUZ(2),"_DA(2)_",59,"_DA(1)_",1,"
 ..S DIC(0)="AEMLQ"
 ..S DIC("P")=$P(^DD(9002274.3059,".03",0),U,2)
 ..S DIC("A")="Select referral reason(s):"
 ..D ^DIC
 ..I $P(Y,U,3)'=1 S ABMX=ABMX-1
 Q
 ;
7 ; Outside Lab Charges
 W ! S DIR(0)="NO^0:999.99:2",DIR("A")="["_ABM("#")_"] Outside Lab Charges",DIR("?")="Enter the Amount of Lab Charges that occurred Outside IHS"
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),$P(^(8),U,1)]"" S DIR("B")=$P(^(8),U)
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I X'="" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".81////"_Y D ^DIE K DR
 Q
 ;
8 W ! S DIR(0)="YO",DIR("A")="["_ABM("#")_"] Was BLOOD Furnished (Y/N)",DIR("?")="If whole blood or units of packed red cells furnished to patient"
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),$P(^(7),U,6)>0 S DIR("B")="Y"
 E  S DIR("B")="N"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I Y=0 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".76///@;.77///@;.78///@;.79///@" D ^DIE K DR Q
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".76T;.77T;.78T;.79T" D ^DIE K DR
 Q
 ;
XIT Q
