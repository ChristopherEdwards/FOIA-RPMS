ABMP2512 ; IHS/SD/SDR - 3P BILLING 2.5 Patch 12 PRE/POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
POST ;
 D ADDZISH  ;add entries to Zish Send Parameters file
 D ERRCODES  ;new error codes in 3P Error Codes file
 D UFMSPARM  ;set UFMS parameters to YES for all IHS sites
 ;D UASUFACL  ;load ASUFAC/FED LOC file from temp file
 Q
 ;
ADDZISH ;EP - ADD ZISH ENTIRES TO 'ZISH SEND PARAMETERS' FILE
 ;ADD 'ABM UFMS B' BACKGROUND ENTRY
 ;ADD 'ABM UFMS F' FOREGROUND ENTRY
ADDF ;ADD FOREGROUND
 I $D(^%ZIB(9888888.93,"B","ABM UFMS F")) D  Q
 .D BMES^XPDUTL("Found [ABM UFMS F] as a ZISH SEND PARAMETER entry")
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
ADDB ;ADD BACKGROUND
 I $D(^%ZIB(9888888.93,"B","ABM UFMS B")) D  Q
 .D BMES^XPDUTL("Found [ABM UFMS B] as a ZISH SEND PARAMETER entry")
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
 S USERNAME="ufmstest"
 S PASSWORD="m6pmt3s3"
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
ERRCODES ;EP
 ;225 - Insurer missing TIN error
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=225
 S X="Insurer missing TIN number"
 S DIC("DR")=".02///Add TIN using Add/Edit Insurer option"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(225)
 ;226 - Insurer with Pseudo TIN warning
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=226
 S X="Insurer has pseudo TIN number"
 S DIC("DR")=".02///Add valid TIN using Add/Edit Insurer option"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(226)
 ;227 - ASUFAC missing for parent facility
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=227
 S X="ASUFAC missing for parent facility"
 S DIC("DR")=".02///Contact your site manager to get populated"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(227)
 ;228 - ASUFAC missing for visit location
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=228
 S X="ASUFAC missing for visit location"
 S DIC("DR")=".02///Contact your site manager to get populated"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(228)
 ;230 - Admitting DX might be needed because clinic is ER
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=230
 S X="Clinic is ER and Admitting Dx is missing"
 S DIC("DR")=".02///If needed, populate Admitting Dx"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(230)
 Q
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S(DA(1)=226!(DA(1)=230):"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
UFMSPARM ;EP
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
UASUFACL ;EP - load ASUFAC/FED LOC file from temp file
 S ABMI=0
 F  S ABMI=$O(^ABMUAFLT(ABMI)) Q:+ABMI=0  D
 .S ABMREC=$G(^ABMUAFLT(ABMI,0))
 .S ABMASUF=$P(ABMREC,U)
 .S ABMACCTP=$P(ABMREC,U,2)
 .S ABMFLOC=$P(ABMREC,U,3)
 .S ABMLDFN=$O(^AUTTLOC("C",ABMASUF,0))
 .Q:ABMLDFN=0
 .K DIC,DIE,X,Y,DA
 .S DIC="^ABMUAPFL("
 .S DIC(0)="LM"
 .S X="`"_ABMLDFN
 .S DIC("DR")=".02////"_ABMASUF_";.03////"_ABMACCTP_";.04////"_ABMFLOC_";.05////3070501"
 .D ^DIC
 .I Y<0 W !,"ENTRY "_ABMREC_" COULD NOT BE LOADED"
 Q
