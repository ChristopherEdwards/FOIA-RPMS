ABMP2513 ; IHS/SD/SDR - 3P BILLING 2.5 Patch 13 PRE/POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
POST ;
 D ADDZISH  ;add entries to Zish Send Parameters file
 D ERRCODES^ABMP2512  ;new error codes in 3P Error Codes file
 D ECODES  ;new codes for patch 13
 D UFMSPARM^ABMP2512  ;set UFMS parameters to YES for all IHS sites
 D QUES  ;add question 20 (block 19) to 1500 (08/05)
 D POADFLT  ;set default for POA field in 3P Parameters
 ;D TASK  ;task re-export to run  12/4/07 don't task, just run
 ;D FROMDT^ABMPUEXT  ;re-export--will be done prior to A/R install manually
 Q
 ;
ADDZISH ;EP - ADD ZISH ENTIRES TO 'ZISH SEND PARAMETERS' FILE
 ;ADD 'ABM UFMS B' BACKGROUND ENTRY
 ;ADD 'ABM UFMS F' FOREGROUND ENTRY
 D ADDF
 D ADDB
 Q
ADDF ;ADD FOREGROUND
 I $D(^%ZIB(9888888.93,"B","ABM UFMS F")) D  Q
 .D BMES^XPDUTL("Found [ABM UFMS F] as a ZISH SEND PARAMETER entry")
 .K DIC,DIE,DA,DR,DIR
 .S DIC="^%ZIB(9888888.93,"
 .S DIC(0)="L"
 .S X="ABM UFMS F"
 .D ^DIC
 .S DIE="^%ZIB(9888888.93,"
 .S DA=+Y
 .S USERNAME="ufmsuser"
 .S PASSWORD="vjrsshn9"
 .S DR=".03///^S X=USERNAME"
 .S DR=DR_";.04////^S X=PASSWORD"
 .D ^DIE
 D BMES^XPDUTL("Adding [ABM UFMS F] as a ZISH SEND PARAMETER entry")
 K DIC,DIE,DA,DR,DIR
 S DIC="^%ZIB(9888888.93,"
 S DIC(0)="L"
 S X="ABM UFMS F"
 D ^DIC
 I +Y<0 W !,"UNABLE TO ADD ZISH PARAMETER ENTRY. TRY MANUALLY!!" Q
 K DIC,DIE,DA,DR,DIR,DD,DO,DINUM
 S DIE="^%ZIB(9888888.93,"
 S DA=+Y
 S USERNAME="ufmsuser"
 S PASSWORD="vjrsshn9"
 S SENDCMD="sendto"
 S TYPE="F"
 S TARGETIP="quovadx-ie.ihs.gov"
 S ARGS="-i -u -a"
 S DR=".02///^S X=TARGETIP"
 S DR=DR_";.03///^S X=USERNAME"
 S DR=DR_";.04////^S X=PASSWORD"
 S DR=DR_";.06///^S X=ARGS"
 S DR=DR_";.07///^S X=TYPE"
 S DR=DR_";.08///^S X=SENDCMD"
 D ^DIE
 K DIC,DIE,DA,DR,DIR
 Q
ADDB ;ADD BACKGROUND
 I $D(^%ZIB(9888888.93,"B","ABM UFMS B")) D  Q
 .D BMES^XPDUTL("Found [ABM UFMS B] as a ZISH SEND PARAMETER entry")
 .K DIC,DIE,DA,DR,DIR
 .S DIC="^%ZIB(9888888.93,"
 .S DIC(0)="L"
 .S X="ABM UFMS B"
 .D ^DIC
 .S DIE="^%ZIB(9888888.93,"
 .S DA=+Y
 .S USERNAME="ufmsuser"
 .S PASSWORD="vjrsshn9"
 .S DR=".03///^S X=USERNAME"
 .S DR=DR_";.04////^S X=PASSWORD"
 .D ^DIE
 D BMES^XPDUTL("Adding [ABM UFMS B] as a ZISH SEND PARAMETER entry")
 K DIC,DIE,DA,DR,DIR
 S DIC="^%ZIB(9888888.93,"
 S DIC(0)="L"
 S X="ABM UFMS B"
 D ^DIC
 I +Y<0 D BMES^XPDUTL("UNABLE TO ADD ZISH PARAMETER ENTRY. TRY MANUALLY!!")
 K DIC,DIE,DA,DR,DIR,DD,DO,DINUM
 S DIE="^%ZIB(9888888.93,"
 S DA=+Y
 S USERNAME="ufmsuser"
 S PASSWORD="vjrsshn9"
 S SENDCMD="sendto"
 S TYPE="B"
 S TARGETIP="quovadx-ie.ihs.gov"
 S ARGS="-i -u -a"
 S DR=".02///^S X=TARGETIP"
 S DR=DR_";.03///^S X=USERNAME"
 S DR=DR_";.04////^S X=PASSWORD"
 S DR=DR_";.06///^S X=ARGS"
 S DR=DR_";.07///^S X=TYPE"
 S DR=DR_";.08///^S X=SENDCMD"
 D ^DIE
 K DIC,DIE,DA,DR,DIR
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
