AGEL4 ; IHS/ASDS/EFG - Add/Edit Eligibility PART 4 ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
COV ;EP - PROMPT FOR COVERAGE TYPE
 S DIE="^AUPN3PPH("
 S DR=".05[11] Select COVERAGE TYPE: ",DA=AGELP("PH")
 D ^DIE
 K DIC
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,5)=""!$D(Y)
 S AGEL("COV")=$P(^AUPN3PPH(AGELP("PH"),0),U,5)
 Q
H14 ;
 S AGEL("OLDN")=$P(^AUTNEMPL(0),U,4)
 S DIE="^AUPN3PPH("
 S DR=".16[14] Select EMPLOYER: "
 S DA=AGELP("PH")
 D ^DIE
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,16)=""!$D(Y)  S AGEL("DFN")=$P(^(0),U,16)
 Q:$P(^AUTNEMPL(0),U,4)=AGEL("OLDN")
EMPL S DIE="^AUTNEMPL(",DA=AGEL("DFN")
 W !!,"<---------EDIT EMPLOYER DEMOGRAPHICS--------->"
 S DR=".02 Street...: ;.03 City.....: ;.04 State....: "
 S DR=DR_";.05 Zip......: ;.06 Phone....: "
 D ^DIE
 Q
P14 S AGEL("OLDN")=$P(^AUTNEMPL(0),U,4)
 S DIE="^AUPN3PPH("
 S DR=".16[14] Select EMPLOYER: ",DA=AGELP("PH")
 D ^DIE
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,16)=""!$D(Y)  S AGEL("DFN")=$P(^(0),U,16)
 Q:$P(^AUTNEMPL(0),U,4)=AGEL("OLDN")
 G EMPL
GRP ;EP - PROMPT FOR GROUP FLDS
 S AGEL("OLDN")=$P(^AUTNEGRP(0),U,4)
 S DIE="^AUPN3PPH(",DR=".06[10] Select GROUP NAME: ",DA=AGELP("PH") D ^DIE
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,6)=""!$D(Y)  S AGEL("EGRP")=$P(^AUPN3PPH(AGELP("PH"),0),U,6)
 Q:$P(^AUTNEGRP(0),U,4)=AGEL("OLDN")
 W ! S DIE="^AUTNEGRP(",DA=AGEL("EGRP")
 W !!?5 W "NOTE: Some Insurers assign different Group Numbers based upon the",!?11,"particular type of visit (dental, outpatient, etc.) that",!?11,"occurred."
 W ! K DIR S DIR("B")="N",DIR(0)="Y",DIR("A")="Do the Group Numbers vary depending on Visit Type (Y/N)"
 S DIR("B")=$S($D(^AUTNEGRP(AGEL("EGRP"),11)):"Y",1:"N") D ^DIR
 Q:$D(DTOUT)!(Y="^")  W !
 I Y=0 S DIE="^AUTNEGRP(",DA=AGEL("EGRP"),DR=".02R~[5a] Group Number.....: " D ^DIE K ^AUTNEGRP(AGEL("EGRP"),11) Q
 S DA=AGEL("EGRP"),DIE="^AUTNEGRP(",DR="11" D ^DIE
 Q
CARDCOPY ;EP
 Q:$G(AGELP("MODE"))="A"
 S:$P($G(AGINSREC),U,11)'="" DA=$P($P(AGINSREC,U,11),",",3)
 S DA(1)=$G(DFN)
 S DIE="^AUPNPRVT("_DA(1)_",11,"
 S DR=".15[12] Card Copy on file: "
 D ^DIE
 ;I $G(DA(1)),$G(DA) I '$P($G(^AUPNPRVT(DA(1),11,DA,0)),U) K TESTVAR S X=TESTVAR
 I $G(DA(1)),$G(DA) I '$P($G(^AUPNPRVT(DA(1),11,DA,0)),U) K ^AUPNPRVT(DA(1),11,DA,0)
 I X="Y" D
 .S DR=".16 Date CC obtained..: "
 .D ^DIE
 K DIE
 Q
PRECERT ;
 I $G(AUPNPAT)="" S AUPNPAT=AGELP("PDFN")
 S DIC="^AUPNPCRT("
 S DIC(0)="AELQMZ"
 S DIC("S")="I $P($G(^AUPNPCRT(Y,0)),U,2)=$G(AUPNPAT)"
 S DIC("A")="[8] Pre-Certification #.:"
 S DIC("DR")=".02////^S X=AUPNPAT"
 D ^DIC
 K DIC("S")
 Q:Y<0
 S DIE=DIC
 S DA=+Y,AGPCIEN=Y
 S DR=".03 Pre-cert Date.: ;.04"
 D ^DIE
 K DIC,DIE
 Q
PCCONTAC ;
 Q:$G(AGPCIEN)=""
 S DIE="^AUPNPCRT("
 S DR=".04[9] Pre-cert Contact: "
 S DA=+AGPCIEN
 D ^DIE
 K DIE
 Q
PCP ;EP
 Q:$G(AGELP("MODE"))="A"
 ;THERE IS NO PRVT ENTRY IN THE INSURER FILE WHEN THIS IS ENTERED
 S:$P($G(AGINSREC),U,11)'="" DA=$P($P(AGINSREC,U,11),",",3)
 S DA(1)=$G(DFN)
 S DIE="^AUPNPRVT("_DA(1)_",11,"
 S DR=".14[7] Primary Care Provider: "
 D ^DIE
 ;I $G(DA(1)),$G(DA) I '$P($G(^AUPNPRVT(DA(1),11,DA,0)),U) K TESTVAR S X=TESTVAR
 I $G(DA(1)),$G(DA) I '$P($G(^AUPNPRVT(DA(1),11,DA,0)),U) K ^AUPNPRVT(DA(1),11,DA,0)
 K DIE
 Q
ESTAT ;EP - PH EMPLOYMENT STATUS
 S DIE="^AUPN3PPH("
 S DA=AGELP("PH")
 S DR=.15
 D ^DIE
 K DIE
 Q
EMP ;EP - PH EMPLOYER
 S DIE="^AUPN3PPH("
 S DA=AGELP("PH")
 S DR=.16
 D ^DIE
 K DIE
 Q
PHSEX ;EP - PH GENDER
 S DIE="^AUPN3PPH("
 S DA=AGELP("PH")
 S DR=.08
 D ^DIE
 K DIE
 Q
PHDOB ;EP - PH DOB
 S DIE="^AUPN3PPH("
 S DA=AGELP("PH")
 S DR=.19
 D ^DIE
 K DIE
 Q
