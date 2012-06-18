ABMDVST6 ; IHS/ASDST/DMJ - PCC VISIT STUFF - DENTAL ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;Original;TMD;03/26/96 10:50 AM
 ;
 ;IHS/DSD/JLG - 05/21/98 -  NOIS NCA-0598-180077
 ;            Modified to set corresponding diagnosis if only one POV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ;
 Q:$D(ABMP("DENTDONE"))
 Q:'$D(^AUPNVDEN("AD",ABMVDFN))
 Q:$P($G(^AUTNINS(ABMP("INS"),2)),U,5)="U"
DEN D CLEAN^ABMDVST4(33)
 S ABMP("DENTDONE")=1
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",33,",DIC(0)="LE"
 S ABM("HIT")=0
 S ABM=""
 F  S ABM=$O(^AUPNVDEN("AD",ABMVDFN,ABM)) Q:'ABM  D
 .K DD,DO,DIC("DR") D DENCHK
 I ABM("HIT"),$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,7)'=998 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".07////998" D ^DIE K DR
 K DIC,ABMR,DIE,DR
 Q
 ;
DENCHK Q:'$D(^AUPNVDEN(ABM,0))  S ABMR("OPSITE")=$P(^(0),U,5),ABMR("SURF")=$P(^(0),U,6),X=$P(^(0),U),ABMR("UNIT")=$P($G(^(0)),U,4)
 S ABMR("CODE")=$P($G(^AUTTADA(+X,0)),U)
TEST I ABMR("CODE")]"" D  Q:'X
 .S ABMR("DA1")=$S($D(^ABMDREC(ABMP("INS"),1,"B",ABMR("CODE"))):ABMP("INS"),1:99999)
 .Q:'$D(^ABMDREC(ABMR("DA1"),1,"B",ABMR("CODE")))
 .S ABMR("IEN")=$O(^ABMDREC(ABMR("DA1"),1,"B",ABMR("CODE"),0))
 .S ABMR("CODE")=$P(^ABMDREC(ABMR("DA1"),1,ABMR("IEN"),0),"^",2)
 .Q:ABMR("CODE")=""
 .S X=$O(^AUTTADA("B",ABMR("CODE"),0))
 ;S ABM("CHRG")=$P($G(^ABMDFEE(ABMP("FEE"),21,1_ABMR("CODE"),0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S ABM("CHRG")=$P($$ONE^ABMFEAPI(ABMP("FEE"),21,1_ABMR("CODE"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 ;Q:'ABM("CHRG")
 I ($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"),('ABM("CHRG")) Q
 S ABMSRC="05|"_ABM_"|DEN"
 S ABM("HIT")=1
 S DIC("P")=$P(^DD(9002274.3,33,0),U,2)
 S DIC("DR")=".02////510;.05////"_ABMR("OPSITE")_";.06////"_ABMR("SURF")_";.07////"_ABMCHVDT_";.08////"_ABM("CHRG")_";.09////"_ABMR("UNIT")
 ;Next line set correspond diagnosis if only 1 POV  
 I $D(ABMP("CORRSDIAG")) S DIC("DR")=DIC("DR")_";.04////1"
 S DIC("DR")=DIC("DR")_";.17////"_ABMSRC
 K DD,DO
 K DD,DO D FILE^DICN
 Q
