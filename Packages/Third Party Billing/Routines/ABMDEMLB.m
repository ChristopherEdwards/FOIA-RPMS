ABMDEMLB ; IHS/ASDST/DMJ - DSD/JLG - Edit Utility - MULTIPLES - PART 3 ; 
 ;;2.6;IHS Third Party Billing;**1,2**;NOV 12, 2009
 ;
 ;IHS/DSD/MRS - 5/6/1999 - NOIS DXX-0599-140006 Patch 1
 ;      Changed indirect (ABMZ("DICI")) to direct call to fee table 
 ;      for outside labs
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for A0425/A0888 to remove mileage from page 3A
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM13945
 ;    Ability to delete range of codes
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20384
 ;   Fix for <UNDEF>CONT+5^ABMDEMLB
 ;
 ; IHS/SD/SDR - abm*2.6*1 - HEAT2653 - E-codes not deleting
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Modified to call ABMFEAPI
 ;
D1 ; EP - Delete Multiple
 I +$E(Y,2,3)>0&(+$E(Y,2,3)<(ABMZ("NUM")+1)) S Y=+$E(Y,2,3) G D2
 I ABMZ("NUM")=1 S Y=1 G D2
 I ABMZ("NUM")<1 D  G XIT
 .W !,"There is no ",ABMZ("ITEM")," to delete."
 .H 3
 K DIR S DIR(0)="LO^1:"_ABMZ("NUM")_":0"
 S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Delete",DIR("A")="Sequence Number to DELETE"
 D ^DIR K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(Y'>0)
D2 ;
 W !
 S ABMXANS=Y
 F ABM("I")=1:1 S ABM=$P(ABMXANS,",",ABM("I")) Q:ABM=""  D
 .I $G(ABMX("ANS"))'="" S ABMX("ANS")=ABMX("ANS")_","_$P(ABMZ(ABM),U)
 .E  S ABMX("ANS")=$P(ABMZ(ABM),U)
 K DIR S DIR(0)="YO",DIR("A")="Do you wish "_ABMX("ANS")_" DELETED"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
D3 ;
 I Y=1 D
 .F ABM("I")=1:1 S ABM=$P(ABMXANS,",",ABM("I")) Q:ABM=""  D
 ..I (ABMZ("SUB")=43)!(ABMZ("SUB")=47),"A0425^A0888"[$P(ABMZ(ABM),U) D
 ...I $P(ABMZ(ABM),U)="A0425",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABM),U,2),0)),U,3) D
 ....S DIE="^ABMDCLM(DUZ(2),"
 ....S DA=ABMP("CDFN")
 ....S DR=".128////@"
 ....D ^DIE
 ...I $P(ABMZ(ABM),U)="A0888",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABM),U,2),0)),U,3) D
 ....S DIE="^ABMDCLM(DUZ(2),"
 ....S DA=ABMP("CDFN")
 ....S DR=".129////@"
 ....D ^DIE
 ..;start new code abm*2.6*1 HEAT2653
 ..;this deletes the individual fields that are associated with any E-codes in the Diag mult.
 ..I $P(ABMZ(ABM),U)["E" D
 ...F ABM("I2")=12,19,20 D
 ....Q:(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,ABM("I2"))=0)
 ....I ($P($G(^ICD9($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,ABM("I2")),0)),U)=$P(ABMZ(ABM),U)) D
 .....S DIE="^ABMDCLM(DUZ(2),"
 .....S DA=ABMP("CDFN")
 .....S DR=$S(ABM("I2")=12:".857",ABM("I2")=19:".858",ABM("I2"):".859",1:"")_"////@"
 .....D ^DIE
 ..;end new code HEAT2653
 ..;
 ..S DA(1)=ABMP("CDFN")
 ..S DA=$P(ABMZ(ABM),U,2)
 ..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 ..D ^DIK
XIT K ABMX
 Q
 ;
CONT ;EP for setting Contract Provider procedures to zero
 W !!,"Either the Attending or Operating Provider's affiliation is Contract, depending",!,"upon local policy, procedures done by a Contract Provider may be unbillable."
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want a Zero Charge for this Procedure (Y/N)" S:$D(ABMX("EDIT")) DIR("B")=$S($P(ABMZ(ABMX("Y")),U,8)=0:"Y",1:"N") D ^DIR K DIR
 I Y=1 S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")_"////0" Q
 Q:'$D(ABMX("EDIT"))
 I $P(ABMZ(ABMX("Y")),U,8)=0,$P($G(@(ABMZ("DIC")_$P(ABMZ(ABMX("Y")),U,3)_",0)")),U,2)>0 S ABMZ("DR")=ABMZ("DR")_";.07////"_$S($P(ABMZ(ABMX("Y")),U,10):$P(^(11,$P(ABMZ(ABMX("Y")),U,10),0),U,3),1:$P(^(0),U,2))_";09///@"
 Q
 ;
LAB ;EP for Outside Labs
 W !!,"============================ OUTSIDE LAB CHARGES =============================="
 W !,"Outside Laboratory activity has occurred for this visit as indicated on Page 3.",!,"If a lab test is indicated as being performed by an outside entity than, the"
 W !,"CPT Code for these tests will be appended with a modifier of 90 (outside lab),",!,"and the billing fee will become editable."
 W ! K DIR S DIR(0)="Y",DIR("A")="Was this Test performed by an Outside Lab (Y/N)" D ^DIR K DIR
 ;I Y=1 S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")_"//"_$S('$D(ABMX("EDIT")):+$P($G(^ABMDFEE(ABMP("FEE"),ABMZ("CAT"),ABMX("Y"),0)),U,2),1:"")_";"_+ABMZ("MOD")_"////"_90 Q  ;abm*2.6*2 3PMS10003A
 I Y=1 S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")_"//"_$S('$D(ABMX("EDIT")):+$P($$ONE^ABMFEAPI(ABMP("FEE"),ABMZ("CAT"),ABMX("Y"),ABMP("VDT")),U),1:"")_";"_+ABMZ("MOD")_"////"_90 Q  ;abm*2.6*2 3PMS10003A
 Q:'$D(ABMX("EDIT"))
 ;I $P($G(^ABMDFEE(ABMP("FEE"),+ABMX("Y"),0)),U,2)>0 S ABMZ("DR")=ABMZ("DR")_";.04////"_$P(^(0),U,2)_";.06///@"  ;abm*2.6*2 3PMS10003A
 I $P($$ONE^ABMFEAPI(ABMP("FEE"),ABMZ("CAT"),+ABMX("Y"),ABMP("VDT")),U)>0 S ABMZ("DR")=ABMZ("DR")_";.04////"_$P(^(0),U,2)_";.06///@"  ;abm*2.6*2 3PMS10003A
 Q
 ;
RX ;EP for entering Prescription Number
 K ABMX("P")
 K DIC W !
 S DIC="^PSRX(",DIC(0)="QAZEM",DIC("B")=ABMZ("RX"),DIC("S")="I $D(^PS(55,ABMP(""PDFN"")))"
 D ^DIC K DIC
 Q
 ;
RXW ;EP - for displaying PRESCRIPTION FILE identifiers
 W ?17,$P(^PSDRUG($P(ABMP(0),U,6),0),U),?50,$$HDT^ABMDUTL($P(ABMP(0),U,13))
 S DIW=1
 Q
