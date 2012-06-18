ABMPPFLR ; IHS/SD/SDR - Prior Payments/Adjustments filer (CE) ;
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
 ; ABMPL(Insurer priority, Insurer IEN)=13 multiple IEN ^ Billing status
 ; ABMPP(Insurer IEN, "P" or "A", Counter)=Amount ^ Adj Category ^ Trans. Type ^ Std Adj. Reason
 ;
 ; IHS/SD/SDR - v2.5 p13 - IM25471 - Changes for CAS when SAR=A2
 ; IHS/SD/SDR - v2.6 p1 - HEAT414 - <UNDEF>EN+29^ABMPPFLR
 ;
EN ;EP
 S ABMSTAT=""
 ; bill status x-ref
 F  S ABMSTAT=$O(^ABMDBILL(DUZ(2),"AS",ABMP("CDFN"),ABMSTAT)) Q:ABMSTAT=""  D
 .Q:ABMSTAT="X"
 .S ABMBIEN=0
 .F  S ABMBIEN=$O(^ABMDBILL(DUZ(2),"AS",ABMP("CDFN"),ABMSTAT,ABMBIEN)) Q:+ABMBIEN=0  D
 ..S ABMAINS=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,8)  ;active insurer
 ..Q:'$D(ABMPP(ABMAINS))  ;quit if no data for insurer
 ..K ABMBPIEN
 ..S ABMCAT=""
 ..F  S ABMCAT=$O(ABMPP(ABMAINS,ABMCAT)) Q:ABMCAT=""  D
 ...S ABMLN=0
 ...F  S ABMLN=$O(ABMPP(ABMAINS,ABMCAT,ABMLN)) Q:+ABMLN=0  D
 ....S ABMLAMT=$P(ABMPP(ABMAINS,ABMCAT,ABMLN),U)  ;amt
 ....I +ABMLAMT=0,$P($G(ABMPP(ABMAINS,ABMCAT,ABMLN)),U,6)'="" D  Q
 .....S DA(1)=ABMBIEN
 .....S DIK="^ABMDBILL(DUZ(2),DA(1),3,"
 .....S DA=$P(ABMPP(ABMAINS,ABMCAT,ABMLN),U,6)
 .....D ^DIK
 ....Q:+ABMLAMT=0
 ....S ABMADJC=$P($G(ABMPP(ABMAINS,ABMCAT,ABMLN)),U,2)  ;adj category
 ....S ABMADJT=$P($G(ABMPP(ABMAINS,ABMCAT,ABMLN)),U,3)  ;trans type
 ....S ABMSAR=$S($P($G(ABMPP(ABMAINS,ABMCAT,ABMLN)),U,4)'="":$P(ABMPP(ABMAINS,ABMCAT,ABMLN),U,4),1:"@")  ;std adj reason
 ....S ABMBPIEN=$P($G(ABMPP(ABMAINS,ABMCAT,ABMLN)),U,6)  ;IEN of entry
 ....I +ABMBPIEN=0 D  ;file as new entry
 .....D ^XBFMK
 .....S DA(1)=ABMBIEN
 .....;S X=ABMOPDT  ;abm*2.6*1 HEAT414
 .....S X=$S($G(ABMOPDT)'="":ABMOPDT,1:DT)  ;abm*2.6*1 HEAT414
 .....S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",3,"
 .....S DIC(0)="L"
 .....S DIC("P")=$P(^DD(9002274.4,3,0),U,2)
 .....K DD,DO D FILE^DICN
 .....S ABMBPIEN=+Y
 .....S $P(ABMPP(ABMAINS,ABMCAT,ABMLN),U,6)=ABMBPIEN
 ....K X,Y,DIC,DIE,DR,DA
 ....S DA(1)=ABMBIEN
 ....S DIE="^ABMDBILL(DUZ(2),DA(1),3,"
 ....S DA=ABMBPIEN
 ....I ABMCAT="P" D
 .....S DR=".02///"_ABMLAMT_";.1///"_ABMLAMT
 ....I ABMCAT="A" D
 .....I ABMADJC=3 S DR=".06///"_ABMLAMT
 .....I ABMADJC=4 S DR=".07///"_ABMLAMT
 .....I ABMADJC=13 S DR=".03///"_ABMLAMT
 .....I ABMADJC=14 S DR=".04///"_ABMLAMT
 .....I ABMADJC=15 S DR=".09///"_ABMLAMT
 .....I ABMADJC=16 S DR=".12///"_ABMLAMT
 .....I ABMADJC=19 S DR=".13///"_ABMLAMT
 .....I ABMADJC=20 S DR=".14///"_ABMLAMT
 .....S DR=$G(DR)_";.15///"_ABMADJC_";.16///"_ABMADJT_";.17////"_ABMSAR
 ....D ^DIE
 S ABMSPLFG=1
 Q
