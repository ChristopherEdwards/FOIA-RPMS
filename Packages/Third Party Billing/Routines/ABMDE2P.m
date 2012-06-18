ABMDE2P ; IHS/ASDST/DMJ - Edit Page 2 - PICK PAYER ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 8
 ;    Added code for replacement insurer
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM13815 - change bill type when different insurer is picked
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - allow a 10th insurer to be selected; if 10th was selected it was putting 1st
 ; *********************************************************************
 ;
P1 ; Pick Insurer
 W !
 I $E(Y,2)>0&($E(Y,2)<(ABMZ("NUM")+1)) S Y=$E(Y,2) G P2
 I ABMZ("NUM")=1 S Y=1 G P2
 K DIR
 S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to BILL"
 S DIR("A")="Sequence Number of "_ABMZ("ITEM")_" to BILL"
 D ^DIR
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(Y'>0)
 ;
P2 ;
 Q:'$D(ABMZ(Y))
 ;S ABM("ANS")=$E(Y)  ;abm*2.6*6 NOHEAT
 S ABM("ANS")=+$G(Y)  ;abm*2.6*6 NOHEAT
 I $P(ABMZ(ABM("ANS")),U,4)="U" D  Q
 . W !!,*7,$P(ABMZ(ABM("ANS")),U)," is Designated as UNBILLABLE!",!
 . D PAZ
 I '$D(ABMZ("UNBILL",ABM("ANS"))) G PA
 W !!,$P(ABMZ(ABM("ANS")),U)," has Already been Billed!"
 W !
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Do you wish to bill "_$P(ABMZ(ABM("ANS")),U,1)_" Again"
 D ^DIR
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(Y'=1)
 ;
PA ;
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)]"" D
 .W !!,$P(^AUTNINS($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8),0),U)
 .W " is Currently the Billing Source!"
 W !
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Do you wish to bill "_$P(ABMZ(ABM("ANS")),U,1)
 D ^DIR
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(Y'=1)
 ;
P3 ;
 N ABMVIST,ABMMODE
 S ABMP("INS")=$P(ABMZ(ABM("ANS")),U,2)
 S DA=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"
 S ABMVIST=$P(^ABMDCLM(DUZ(2),DA,0),U,7)
 S ABMMODE=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMVIST,0)),U,4)
 S DR=".08////"_ABMP("INS")_$S(ABMMODE:";.14///"_ABMMODE,1:"")
 S ABMP("BTYP")=$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,11)'="":$P($G(^ABMDCODE($P(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0),U,11),0)),U),1:ABMP("VTYP"))
 S DR=DR_";.12////"_ABMP("BTYP")
 D ^DIE
 K DR
 K ^ABMDCLM(DUZ(2),DA,13,"C")
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 S ABMX("INS")=$P(ABMZ(ABM("ANS")),"^",3)
 D COV^ABMDE2X5
 K ABMX
 S Y="",ABM("T")=""
 I ABMZ("UNBILL") D
 .F ABM("I")=1:1 S ABM("T")=$O(ABMZ("UNBILL",ABM("T"))) Q:'ABM("T")  D
 ..I ABM("T")'=ABM("ANS") D
 ...S Y=$S(Y]"":Y_","_ABM("T"),1:ABM("T"))
 S Y=$S(Y]"":Y_","_ABM("ANS"),1:ABM("ANS"))
 F ABM("I")=1:1 S ABM("T")=$O(ABMZ(ABM("T"))) Q:'ABM("T")  D
 .I ABM("T")'=ABM("ANS") D
 ..I '$D(ABMZ("UNBILL",ABM("T"))) D
 ...S Y=Y_","_ABM("T")
 S DA(1)=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 I ABM("I")'=1 D
 .K ABMX
 .F ABMX=1:1 S ABMX("Y")=$P(Y,",",ABMX) Q:ABMX("Y")=""  Q:+ABMX("Y")'>0!(ABMX("Y")'<(ABMZ("NUM")+1))  D
 ..S:'$D(ABMX(ABMX("Y"))) ABMX(ABMX("Y"))=ABMX
 I ABM("I")'=1 D
 .F ABMX=1:1:ABMZ("NUM") D
 ..S DA=$P(ABMZ(ABMX),U,3)
 ..S DR=".02////"_$S($D(ABMX(ABMX)):ABMX(ABMX),1:ABMX)
 ..D ^DIE
 S DA(1)=ABMP("CDFN")
 S DA=$P(ABMZ(ABM("ANS")),U,3)
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 S DR=".03///I"
 D ^DIE
 K DR
 S DA(1)=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 S DR=".03///P"
 S DA=0
 F  S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,DA)) Q:'DA  D
 .I "CU"'[$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,DA,0),U,3) D
 .. I DA'=$P(ABMZ(ABM("ANS")),U,3) D ^DIE
 D TPICHECK^ABMDE1
 Q
 ;
PAZ ;
 K DIR
 S DIR(0)="E"
 D ^DIR
 K DIRUT,DUOUT
 Q
