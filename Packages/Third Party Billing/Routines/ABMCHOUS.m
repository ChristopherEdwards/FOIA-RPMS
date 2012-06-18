ABMCHOUS ; IHS/SD/SDR - Setup Clearing House ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;
START ;start
 W !!
 D ^XBFMK
 S DIC="^ABMRECVR("
 S DIC(0)="AEMQL"
 S DIC("A")="Enter the clearinghouse name: "
 D ^DIC
 Q:Y<0
 Q:$D(DTOUT)!$D(DUOUT)
 S ABMCH=+Y
 D ^XBFMK
 S DIE="^ABMRECVR("
 S DA=ABMCH
 ;S DR=".01//;W !!,""Setting up Header Data... "",!;.02//;.03//"  ;abm*2.6*8 HEAT45044
 S DR=".01//;W !!,""Setting up Header Data... "",!;.02//;.03//;.04//;.05"  ;abm*2.6*8 HEAT45044
 D ^DIE
 I '$D(^ABMRECVR(ABMCH)) K ^ABMRECVR(ABMCH,1),ABMCH
 Q:'$G(ABMCH)
 D ^XBFMK
 W !!
INSURER ;
 F  D  Q:Y<0
 .D ^XBFMK
 .S DIR(0)="PO^9999999.18:EMQ"
 .S DIR("A")="Select Insurer"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .I $D(^ABMRECVR("C",+Y)) D  Q
 ..S ABMCHIEN=$O(^ABMRECVR("C",+Y,0))
 ..I ABMCHIEN'=ABMCH D  ;Insurer is set up w/different CH than the one we are editing
 ...W !!,"** Insurer "_$P($G(^AUTNINS(+Y,0)),U)_" is already setup"
 ...W !?3,"with Clearinghouse ",$P($G(^ABMRECVR(ABMCHIEN,0)),U)," and cannot be setup with a second Clearinghouse."
 ...W !!
 ..;I ABMCHIEN=ABMCH D  Q  ;Insurer is set up w/CH we are editing  ;abm*2.6*8
 ..I ABMCHIEN=ABMCH D  ;Insurer is set up w/CH we are editing  ;abm*2.6*8
 ...W !!,"** Insurer "_$P($G(^AUTNINS(+Y,0)),U)_" is already setup"
 ...W !?3,"with this Clearinghouse"
 ...W !!
 ...K DIC,DIE,DIR
 ...S DA(1)=ABMCH
 ...S DA=+Y
 ...S DIE="^ABMRECVR("_DA(1)_",1,"
 ...;S DR=".01//;.02//"  ;abm*2.6*8 HEAT28891
 ...S DR=".01//;.02//;.03//"  ;abm*2.6*8 HEAT28891
 ...D ^DIE
 ...S Y=0
 .S ABM("INS")=+Y
 .D ^XBFMK
 .S DA(1)=ABMCH
 .S DIC="^ABMRECVR("_DA(1)_",1,"
 .S DIC("P")=$P(^DD(9002274.095,1,0),U,2)
 .S DIC(0)="E"
 .S (X,DINUM)=ABM("INS")
 .K DD,DO
 .D FILE^DICN
 .Q:Y<0
 .S DIE="^ABMRECVR("_DA(1)_",1,"
 .S DA=+Y
 .;S DR=".01//;.02//"  ;abm*2.6*8 HEAT28891
 .S DR=".01//;.02//;.03//"  ;abm*2.6*8 HEAT28891
 .D ^DIE
 .S Y=1
 Q
