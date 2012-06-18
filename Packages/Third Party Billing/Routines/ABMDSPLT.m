ABMDSPLT ; IHS/ASDST/DMJ - SPLIT CLAIM IN TWO ;     
 ;;2.6;IHS Third Party Billing;**1,3**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   Added check to see if user is logged in before splitting
 ;   claims allowed
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4480 - Added ARE YOU SURE prior to split
 ; IHS/SD/SDR - abm*2.6*3 - HEAT11948 - fix for <UNDEF>START+3^AUPNPAT
 ;
 ; *********************************************************************
 ;
START ;START
 W !
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 D ^ABMDEDIC
 Q:'$G(ABMP("CDFN"))
 S DIC="^ABMDCLM(DUZ(2),",DIC(0)="L"
 S X=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U)
 ;start new code abm*2.6*1 HEAT4480
 W !!
 S DIR(0)="Y",DIR("A")="You are about to split a claim.  Are you sure?"
 S DIR("B")="NO"
 D ^DIR K DIR
 G:Y=0 START
 S X=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U)  ;abm*2.6*3 HEAT11948
 ;end new code HEAT4480
 S DINUM=$$NXNM^ABMDUTL
 I DINUM="" D  Q
 .W !!,"ERROR: Claim not created - check global ^ABMDCLM(0)"
 .S DIR(0)="E" D ^DIR K DIR
 K DD,DO D FILE^DICN Q:+Y<0  S ABMC2=+Y
 M ^ABMDCLM(DUZ(2),ABMC2)=^ABMDCLM(DUZ(2),ABMP("CDFN"))
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMC2
 S DR=".1////"_DT_";.04///E"
 S DR=DR_";.17////"_DT
 D ^DIE
MLI ;MOVE LINE ITEMS
 S ABMSTRG=""
 S DIR(0)="SO^8A:MEDICAL;8B:SURGICAL;8C:REVENUE CODE;8D:RX;8E:LAB;8F:RADIOLOGY;8G:ANESTHESIA;8H:HCPCS;8I:INPATIENT DENTAL;8J:CHARGE MASTER;8Z:ALL"
 S DIR("A")="Move Which Section(s)? "
 F  D  Q:'Y
 .D ^DIR
 .Q:'Y
 .S:ABMSTRG'[Y ABMSTRG=ABMSTRG_Y_"^"
 .W !!,"Selected: ",$TR(ABMSTRG,"^"," ")
 K DIR
 W !
 I ABMSTRG'["8Z" D
 .S DIR(0)="Y",DIR("A")="Delete sections from original claim after move"
 .S DIR("B")="NO"
 .D ^DIR K DIR
 .S:Y=1 ABMDLT=1
 D DEL
 S DIK="^ABMDCLM(DUZ(2),"
 F DA=ABMC2,ABMP("CDFN") D
 .K ^ABMDCLM(DUZ(2),DA,"ASRC")
 .D IX1^DIK
 W !!,"Claim # ",ABMC2," created.",!
 K ABMSTRG,ABMDLT,ABMC2,ABMPG,ABMSEC
 S DIR(0)="E" D ^DIR K DIR
 Q
DEL ;DELETE SECTIONS
 K ^ABMDCLM(DUZ(2),ABMC2,13)
 F I=1:1:10 D
 .S ABMPG=$P("8A^8B^8C^8D^8E^8F^8G^8H^8I^8J","^",I)
 .S ABMSEC=$P("27^21^25^23^37^35^39^43^33^45","^",I)
 .I $G(ABMDLT),ABMSTRG[ABMPG K ^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMSEC)
 .Q:ABMSTRG["8Z"
 .I '(ABMSTRG[ABMPG) K ^ABMDCLM(DUZ(2),ABMC2,ABMSEC)
 Q
