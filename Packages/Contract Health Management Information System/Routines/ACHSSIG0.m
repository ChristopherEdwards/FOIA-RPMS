ACHSSIG0 ;ITSC/JVK/SET - ADD EDIT CHS AUTHORIZED E-SIG USERS  [ 11/26/2003  11:16 AM ]
 ;;3.1;CONTRACT HEALTH MANAGEMENT SYSTEM;**7**;JUNE 11,2001
 ;ACHS*3.1*7- NEW ROUTINE TO ADD EDIT E-SIG USERS
 ;
USRS ;EP
 D LOC
 W !!!,?5,"Add or Edit entries in the CHS E-Sig Authority File for ",ACHSSITE,".",!
 W ?5,"Users must have a written Delegation of Authority to sign",!?5,"Contract Health Services Purchase Orders.",!
 ;
 N DA,DIC,DIE,DR,DLAYGO
 S DIE="^ACHSESIG("
 S DR=".01;1",DA=DUZ(2)
 D ^DIE
 S DR="1.01:1.5"
 D ^DIE
 Q
SITE ;EP
 D LOC
 W !!!,?5,"Add a site to the CHS E-Sig Authority File."
 N DA,DIC,DIE,DR,DLAYGO
 S DIE="^ACHSESIG("
 I $P(^ACHSESIG(0),U,3)="" S $P(^ACHSESIG(0),U,3)=DUZ(2)
 I $P(^ACHSESIG(0),U,4)="" S $P(^ACHSESIG(0),U,4)=1
 S DR=".01;.02;.03",DA=DUZ(2)
 D ^DIE
 Q
LOC ;
 I '$D(^XUSEC("ACHSZMGR",DUZ)) Q
 S ACHSSITE=$P($G(^DIC(4,DUZ(2),0)),U)
 Q
