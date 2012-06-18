ABMP2510 ; IHS/SD/SDR - 3P BILLING 2.5 Patch 10 PRE/POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;
 Q
PREINST ;
 S DIK="^ABMQUES("
 S DA=31
 D ^DIK
 S DIK="^ABMPSTAT("
 F DA=1,3,9,10,13 D ^DIK
 ;
 ; repoint entry from 3P EMC Reference ID file if used
 ; this is a bad entry that will be removed
PREINST2 S ABMIEN=0
 F  S ABMIEN=$O(^ABMREFID("B","1B",ABMIEN)) Q:+ABMIEN=0  D
 .I $P($G(^ABMREFID(ABMIEN,0)),U,2)["Sheild" S ABMRMV=ABMIEN  ;this is the entry to remove/repoint
 .I $P($G(^ABMREFID(ABMIEN,0)),U,2)["Shield" S ABMUSE=ABMIEN  ;use this entry
 ;
 S ABMDUZ=0
 F  S ABMDUZ=$O(^ABMNINS(ABMDUZ)) Q:+ABMDUZ=0  D
 .S ABMI=0
 .F  S ABMI=$O(^ABMNINS(ABMDUZ,ABMI)) Q:+ABMI=0  D
 ..S ABMVI=0
 ..F  S ABMVI=$O(^ABMNINS(ABMDUZ,ABMI,1,ABMVI)) Q:+ABMVI=0  D
 ...I $P($G(^ABMNINS(ABMDUZ,ABMI,1,ABMVI,1)),U)=ABMRMV D
 ....S DUZ(2)=ABMDUZ
 ....S DA(1)=ABMI
 ....S DA=ABMVI
 ....S DIE="^ABMNINS(DUZ(2),"_DA(1)_",1,"
 ....S DR="101////"_ABMUSE
 ....D ^DIE
 Q
EN ; EP
 I $G(^DD(9002274.3021,.18,0))="" D EN^ABMPT259  ;if patch 9 not loaded do p9 post install
 D ERRCODES  ;new 3P Error codes
 D ECODES  ;new 3P CODES
 D PCCCODES  ;new 3P PCC Visit Status code
 D REINDEX^ABMPT259  ;re-index 3p provider taxonomy file
 Q
ERRCODES ;
 ;217 - DX deleted that was being referenced
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=217
 S X="DX HAS BEEN DELETED THAT IS BEING REFERENCED"
 S DIC("DR")=".02///Redo corresponding DX codes"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(217)
 ;218 - NO MSP FOR MEDICARE PATIENT
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=218
 S X="NO MSP FOR MEDICARE PATIENT"
 S DIC("DR")=".02///Enter MSP on page 4 of Pat Reg"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(218)
 ;219 - Medicare Active Insurer and DOB missing from page 4
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=219
 S X="MEDICARE ACTIVE INSURER AND DOB MISSING FROM PAT REG PAGE 4"
 S DIC("DR")=".02///Populate Date Of Birth on page 4 of Pat Reg"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(219)
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
 .S DIC("DR")=".03////E"
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
ECODES ;
 ;IM21196
 Q:+$O(^ABMDCODE("C","DISCHARGED/TRANSFERRED TO ANOT",0))'=0  ;entry already exists
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="62"
 S DIC("DR")=".02///P"
 S DIC("DR")=DIC("DR")_";.03///DISCHARGED/TRANSFERRED TO ANOTHER REHAB FAC"
 K DD,DO
 D FILE^DICN
 Q
PCCCODES ;
 S DIC="^ABMDCS("
 S DIC(0)="LM"
 S X="BILLED POS"
 D ^DIC
 Q
