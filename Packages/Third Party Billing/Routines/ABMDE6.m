ABMDE6 ; IHS/ASDST/DMJ - Page 6 - DENTAL ;
 ;;2.6;IHS Third Party Billing System;**2,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM17106 - <UNDEFINED>PC1^ABMDE6 regarding
 ;    a cross reference with no entry
 ; IHS/SD/SDR - v2.5 p10 - IM20380/IM20401 - fix when Edit choosen & only one option
 ;   of if they don't select any
 ; IHS/SD/SDR - v2.5 p10 - IM20873 - <UNDEF>E+21^ABMDE6 error (entry not
 ;   selected when Delete is selected)
 ; IHS/SD/SDR - v2.5 p11 - NPI - change for needed fields for ADA-2006 format
 ;   field was there but not being asked
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ;
OPT9 K ABM,ABME
 S ABM("TOTL")=0
 D DISP
 W ! S ABMP("OPT")="ADEVNJBQ" D SEL^ABMDEOPT S ABM("ACTION")=Y
 I "AVDE"'[$E(Y) S:$D(ABMP("DDL"))&($E(ABMP("PAGE"),$L(ABMP("PAGE")))=6) ABMP("QUIT")="" G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("DO")=$S($E(Y)="V":"V1",1:"A")
 K DA D @ABM("DO")
 G OPT9
 ;
DISP ;PAGE DISPLAY
 K ABMZ
 S ABMZ("TITL")="DENTAL SERVICES",ABMZ("PG")="6"
 S ABMZ("ITEM")="Dental (ADA Code)"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D ^ABMDE6X
 S ABMZ("SUB")=33
 D HD G LOOP
HD ;
 W !?4,"VISIT",?56,"ORAL",?61,"OPER"
 W !?4,"DATE",?11,"              DENTAL SERVICE",?56,"CAV",?61,"SITE",?66,"SURF",?73,"CHARGE"
 W !?4,"=====",?11,"============================================",?56,"====",?61,"====",?66,"=====",?73,"======"
 Q
LOOP ;LOOP THROUGH LINE ITEMS
 S (ABMZ("LNUM"),ABMZ(1),ABM)=0
 S ABMZ("NUM")=0
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM)) Q:'ABM  D
 .S ABM("X")=0
 .F  S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM,ABM("X"))) Q:'ABM("X")  D
 ..I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM("X"),0)) K ^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM,ABM("X")) Q
 ..D PC1
 W !?72,"=======",!?70,$J(("$"_$FN(ABM("TOTL"),",",2)),9)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM("X"),0)
 S ABMZ("NUM")=+ABMZ("NUM")+1
 S ABMZ(ABMZ("NUM"))=$P(^AUTTADA(+ABM("X0"),0),U)_U_ABM("X")
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABMZ("NUM"),"]"
 I $P(ABM("X0"),U,7)]"" W ?4,$E($P(ABM("X0"),U,7),4,5)_"/"_$E($P(ABM("X0"),U,7),6,7)
 W ?11,$P(^AUTTADA(+ABM("X0"),0),U)," ",$E($P(^(0),U,2),1,39)
 W ?57,$P($G(ABM("X0")),U,11)  ;oral cavity
 W ?62 W $S($P(ABM("X0"),U,5)="":"",$D(^ADEOPS($P(ABM("X0"),U,5),88)):$P(^(88),U),1:"")
 W ?66,$J($P(ABM("X0"),U,6),4)
 S ABM("ITMTOTL")=$P(ABM("X0"),U,8)*$P(ABM("X0"),U,9)
 S:'+ABM("ITMTOTL") ABM("ITMTOTL")=$P(ABM("X0"),U,8)
 W ?73,$J($FN(ABM("ITMTOTL"),",",2),6)
 S ABM("TOTL")=ABM("TOTL")+ABM("ITMTOTL")
 Q
 ;
XIT K ABM
 Q
 ;
V1 S ABMZ("TITL")="DENTAL VIEW OPTION" D SUM^ABMDE1
 D ^ABMDERR
 Q
A ;ADD LINE ITEM
 K DA S DA(1)=ABMP("CDFN")
 I $E(ABM("ACTION"))="A" D
 .S DIC="^AUTTADA(",DIC(0)="AEMQ"
 .D ^DIC Q:+Y<0
 .S X=$P(Y,U)
 .S DIC("P")=$P(^DD(9002274.3,33,0),U,2)
 .S DIC="^ABMDCLM(DUZ(2),DA(1),33,"
 .;K DD,DO D FILE^DICN Q:+Y<0  S DA=+Y  ;abm*2.6*8 5010
 .K DD,DO D FILE^DICN Q:+Y<0  S (DA,ABMXANS)=+Y  ;abm*2.6*8 5010
E ;EDIT LINE ITEM
 I $E(ABM("ACTION"))="D" D  Q
 .K DIR S DIR(0)="LO^1:"_ABMZ("NUM")_":0"
 .S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Delete"
 .S DIR("A")="Sequence Number to DELETE"
 .D ^DIR K DIR
 .W !
 .S ABMXANS=Y
 .Q:ABMXANS=""
 .F ABM("I")=1:1 S ABM=$P(ABMXANS,",",ABM("I")) Q:ABM=""  D
 ..I $G(ABMX("ANS"))'="" S ABMX("ANS")=ABMX("ANS")_","_$P(ABMZ(ABM),U)
 ..E  S ABMX("ANS")=$P(ABMZ(ABM),U)
 .K DIR S DIR(0)="YO",DIR("A")="Do you wish "_ABMX("ANS")_" DELETED"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I Y=1 D
 ..F ABM("I")=1:1 S ABM=$P(ABMXANS,",",ABM("I")) Q:ABM=""  D
 ...S DA(1)=ABMP("CDFN")
 ...S DA=$P(ABMZ(ABM),U,2)
 ...S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",33,"
 ...D ^DIK
 ;
 I $E(ABM("ACTION"))="E" D
 .;I ABMZ("NUM")=1 S (DA,Y)=$P(ABMZ(1),U,2) Q  ;abm*2.6*8
 .I ABMZ("NUM")=1 S (DA,Y,ABMXANS)=$P(ABMZ(1),U,2) Q  ;abm*2.6*8
 .K DIR S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 .S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Edit",DIR("A")="Sequence Number to EDIT"
 .D ^DIR K DIR
 .G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
 .;W !!!,"[",+Y,"]  ",$P(ABMZ(+Y),U) S DA=$P(ABMZ(+Y),U,2)  ;abm*2.6*8 5010
 .W !!!,"[",+Y,"]  ",$P(ABMZ(+Y),U) S (DA,ABMXANS)=$P(ABMZ(+Y),U,2)  ;abm*2.6*8 5010
E2 ;
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
 S ABMZ("ADACODE")=$P($G(^ABMDCLM(DUZ(2),DA(1),33,DA,0)),U)
 S ABMZ("DCD")=$P(^AUTTADA(ABMZ("ADACODE"),0),U)
 ;S ABMZ("CHRG")=+$P($G(^ABMDFEE(ABMP("FEE"),21,1_ABMZ("DCD"),0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S ABMZ("CHRG")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),21,1_ABMZ("DCD"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",33,"
 I $P(^ABMDEXP(ABMP("EXP"),0),"^",1)["UB" D  Q:$D(Y)
 .S DR="W !;.02" D ^DIE
 S DR="W !;.07//"_ABMP("VISTDT") D ^DIE Q:$D(Y)
 S ABMZ("OPSITE")=1 S:$P(^AUTTADA(ABMZ("ADACODE"),0),"^",9)="n" ABMZ("OPSITE")=0
 I ABMZ("OPSITE") D  Q:$D(Y)
 .S DR="W !;.05;W !;.06;W !;.11"
 .D ^DIE
 D DX^ABMDEMLC S DR=".04///"_Y(0) D ^DIE Q:$D(Y)
 S DR=".09//1" D ^DIE Q:$D(Y)
 S DR=".08//"_ABMZ("CHRG") D ^DIE Q:$D(Y)
 S DR=".17///M" D ^DIE
 D PROV  ;abm*2.6*8 5010
 Q
 ;start new code abm*2.6*8 5010
PROV ;EP
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",0))>0 D
 .W !
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN)) Q:+ABMIEN=0  D
 ..W !?5,$P($G(^VA(200,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U),0)),U)
 ..W ?40,$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="R":"RENDERING",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="D":"ORDERING",1:"")
 .W !
 K DIC,DR,DIE,DA
 S DA(2)=ABMP("CDFN")
 S DA(1)=ABMXANS
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 S DIC(0)="AELMQ"
 S ABMFLNM="9002274.30"_$G(ABMZ("SUB"))
 S DIC("P")=$P($G(^DD(ABMFLNM,.18,0)),U,2)
 Q:DIC("P")=""
 S DIC("DR")=".01;.02//RENDERING"
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA(1),"P","C","R",0))>0 S DIC("DR")=".01;.02//ORDERING"
 D ^DIC
 K DIC,DR,DIE,DA
 I +Y>0,(+$P(Y,U,3)=0) D
 .K DIE,DA,DR
 .S DA(2)=ABMP("CDFN")
 .S DA(1)=ABMXANS
 .S DIE="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 .S DA=+Y
 .S DR=".01//;.02"
 .D ^DIE
 Q
 ;end new code abm*2.6*8
