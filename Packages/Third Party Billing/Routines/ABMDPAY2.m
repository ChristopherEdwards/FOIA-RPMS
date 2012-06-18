ABMDPAY2 ; IHS/ASDST/DMJ - Payment of Bill - Part 2 ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
CHK ;EP for Additional Payment Checks
 S ABMP("CDFN")=+ABMP("BILL")
 I ABMP("SPAY") S DIE="^ABMDBILL(DUZ(2),",DR=".16////A",DA=ABMP("BDFN") D ^DIE Q
 I ABM("OB")'=0 D  G PAZ
 .W !!?16,"(Unobligated Balance: ",$FN(ABM("OB"),",",2),")"
 .W !!?10,"The Bill can not be closed nor secondary billing occur until"
 .W !?10,"the unobligated balace is eliminated."
 .D OBIL
 D:ABM("OB")=0 CBIL
 I $P(ABMP("SIS"),U,2)>0 W !!?5,"A Sister Bill (",$P(ABMP("SIS"),U),") exists with an unobligated balance, it",!?5,"must be resolved before proceeding to bill a secondary entity." G PAZ
 I +ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U) G PAZ
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)) W !!,"Claim Number: ",+ABMP("BILL"),?22,"- has previously been CANCELLED, thus further",!?24,"billing is not possible." G PAZ
 N I S I=0 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)'="I"
 .S DA(1)=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,",DA=I,DR=".03////C" D ^DIE K DR
 I '$P(ABM("TOT"),U,2),'$P(ABM("TOT"),U,3) W !!?10,"The bill has been paid in full with no deductible or",!?10,"write-off, thus no further billing is possible." D CCLM G PAZ
 W !!,"Checking for Secondary Billing...",!,"---------------------------------"
UNBILL W !!,"Unbilled Sources: "
 S (ABM("HIT"),ABM("CNT"))=0
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="N" D CCLM G PAZ
 S ABMVDFN=$G(ABMP("VDFN")),ABMPDFN=ABMP("PDFN"),ABMVDT=ABMP("VDT")
 D ELG^ABMDLCK(ABMVDFN,.ABML,ABMPDFN,ABMVDT)
 N I S I=0 F  S I=$O(ABML(I)) Q:'I  D
 .N J S J=0 F  S J=$O(ABML(I,J)) Q:'J  D
 ..Q:$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",J))
 ..S ABM("PRI")=I,ABM("INS")=J
 ..D ADD^ABMDE2E
 S ABM="" F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM)) Q:'ABM  D
 .S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,""))
 .I "PIFL"[$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("X"),0),U,3) S ABM("INSCO")=$P(^(0),U) D
 ..Q:$P($G(^AUTNINS(ABM("INSCO"),2)),U)="I"  Q:$P($G(^(1)),U,7)=4
 ..W:ABM("CNT") ! S ABM("CNT")=ABM("CNT")+1
 ..W ?18,"[",ABM("CNT"),"]  ",$P(^AUTNINS(ABM("INSCO"),0),U) S ABM(ABM("CNT"))=ABM("X")
 I ABM("CNT")=0 D  G PAZ
 .D CCLM
 .W "NONE",!!,"Since there are no unbilled sources no further billing is possible."
 S ABM("HIT")=ABM(1)
 ;
 S ABM("AMT")=$P(ABM("TOT"),U,2) I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,4) S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".24////0" D ^DIE
 I '$P(ABM("TOT"),U,3) G CONT
 W ! S DIR(0)="Y",DIR("A")="Apply write off to next bill (Y/N)",DIR("B")="N" D ^DIR K DIR Q:$D(DIRUT)  S ABM("Y")=Y D  I ABM("Y")'=1 D CCLM G PAZ
 .Q:ABM("Y")'=1
 .S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".24////"_Y D ^DIE
 .S ABM("AMT")=ABM("AMT")+$P(ABM("TOT"),U,3)
 ;
CONT I 'ABM("AMT"),'$D(ABMP("SIS")) W !!,"Since there is no uncollected balance no futher billing is possible." D CCLM G PAZ
 I "UC"'[$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4) W !!?5,"Claim: ",+ABMP("BILL")," is in EDIT MODE thus can only be entered through",!?5,"the EDIT CLAIM DATA Option." G PAZ
 I '$P(ABM("TOT"),U),'$P(ABM("TOT"),U,2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,4) G OCLM
 S DA(1)=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,",DA=ABM("HIT"),DR=".03////I" D ^DIE
 ;
OCLM S DA=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),",DR=".04////E;.14////@;.08////"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("HIT"),0),U)
 D ^DIE
 W !!,"Claim Number: ",+ABMP("BILL")," is now Open for Editing!",!
 K DIR S DIR(0)="Y",DIR("A")="Enter CLAIM EDITOR for APPROVAL of Secondary Entity (Y/N)",DIR("B")="Y" D ^DIR K DIR Q:$D(DIRUT)!'$G(Y)
 S DA=+ABMP("BILL")
 N ABMP S ABMP("PAYM")=1,ABMP("CDFN")=DA
 D EXT^ABMDE
 S ABMP("PAYM")=1
 Q
 ;
CCLM Q:$P(ABMP("SIS"),U,2)>0  S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),",DR=".04////C" D ^DIE
 Q
 ;
KCLM S DA=+ABMP("BILL") Q:'$D(^ABMDCLM(DUZ(2),DA))  D ^ABMDEDIK
 W !!,"Claim Number: ",DA," has been deleted!"
 Q
 ;
CBIL ;EP for Closing Bill
 S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".04////C;.17///@" D ^DIE K DR
 Q
 ;
OBIL S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".04////P" D ^DIE K DR
 Q
PAZ ;END OF PAGE
 K DIR W ! S DIR(0)="E" D ^DIR K DIR
 Q
