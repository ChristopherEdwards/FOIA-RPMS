ABMP2514 ; IHS/SD/SDR - 3P BILLING 2.5 Patch 14 PRE/POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
POST ;
 D TPCODES  ;add entries to 3P Codes file
 D EN^ABMF400  ;find Medicare 400/900 entries in local mod file
 D UFMSPARM
 ;D ERRCODES^ABMP2512  ;new error codes in 3P Error Codes file
 ;D ECODES  ;new codes for patch 13
 ;D QUES  ;add question 20 (block 19) to 1500 (08/05)
 ;D POADFLT  ;set default for POA field in 3P Parameters
 Q
 ;
TPCODES ;
 ; IM28458
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="63"
 S DIC("DR")=".02///P"
 S DIC("DR")=DIC("DR")_";.03///Discharged/Transferred to Long Term Care"
 K DD,DO
 D FILE^DICN
 Q
UFMSPARM ;EP
 S X=$$INSTALLD^ABMENVCK("ABM*2.5*12")
 Q:X'=1
 ;
 S DUZHOLD=$G(DUZ(2))
 S DUZ(2)=1
 F  S DUZ(2)=$O(^ABMDPARM(DUZ(2))) Q:+DUZ(2)=0  D
 .Q:$D(^ABMDPARM(DUZ(2),1))'=10
 .S ABMADIEN=$O(^AUTTLOC(DUZ(2),11,9999999),-1)
 .Q:+ABMADIEN=0
 .K DIE,DIC,X,DR,DA
 .S DIE="^ABMDPARM(DUZ(2),"
 .S DA=1
 .I $P($G(^AUTTLOC(DUZ(2),11,ABMADIEN,0)),U,3)="1" S DR="414////1;415////1;416////5"  ;if affiliation IHS
 .I $P($G(^AUTTLOC(DUZ(2),11,ABMADIEN,0)),U,3)'="1" S DR="414////0;415////0;416////5"  ;if affiliation NOT IHS
 .D ^DIE
 S DUZ(2)=DUZHOLD
 K DUZHOLD,ABMADIEN
 Q
QUES ;EP
 K DIC,DIE,DA,DR,X,Y
 S DIE="^ABMDEXP("
 S DA=27
 S DR=".08////1,2,3,4B,5,7,9,10,12B,13,15,20,22,34,35,19,25"
 D ^DIE
 Q
POADFLT ;EP
 S DUZHOLD=$G(DUZ(2))
 S DUZ(2)=1
 F  S DUZ(2)=$O(^ABMDPARM(DUZ(2))) Q:+DUZ(2)=0  D
 .Q:$D(^ABMDPARM(DUZ(2),1))'=10
 .K DIE,DIC,X,DR,DA
 .S DIE="^ABMDPARM(DUZ(2),"
 .S DA=1
 .S DR="213////Y"  ;POA default to yes
 .D ^DIE
 S DUZ(2)=DUZHOLD
 K DUZHOLD,ABMADIEN
 Q
ECODES ;EP
 ;231 - Present on Admission (POA) indicator missing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=231
 S X="PRESENT ON ADMISSION (POA) INDICATOR MISSING"
 S DIC("DR")=".02///Populate POA for inpatient DXs on page 5A"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(231)
 Q
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:+DUZ(2)=0  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S(DA(1)=225!(DA(1)=226)!(DA(1)=230):"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
TASK ;EP
 S ZTRTN="FROMDT^ABMPUEXT"
 S ZTDESC="3P UFMS RE-EXPORT"
 ;S ZTSAVE("ABM*")=""
 S ZTIO=""
 S ZTPRI=5
 S ZTDTH=DT_"."_22  ;install day at 10:00pm
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued to run Re-Export at 10:00pm",!
 Q
