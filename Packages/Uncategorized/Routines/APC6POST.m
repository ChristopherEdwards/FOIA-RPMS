APC6POST ; IHS/TUCSON/LAB - POST INIT TO APC6 ;  [ 11/09/93  07:41 AM ]
 ;;1.6;PCC DATA ENTRY 1.6 PATCH 1;**1**;NOV 08, 1993
 ;
 D ^XBKSET
 W !,"I WILL NOW RE-COMPILE SOME TEMPLATES.",!!
 D ^APCDRECM
 ;
HFMNE ;
 W !!,"Fixing HF Mnemonic ..",!
 S DIE="^APCDTKW(",DR=".08///1",DA=$O(^APCDTKW("B","HF","")) D ^DIE K DIE,DA,DR
VIMM ;
 K ^AUPNVIMM("AQ")
 W !!,"Re-indexing the AQ cross reference on V Immunization.  Hold on...."
 S DIK="^AUPNVIMM(",DIK(1)=".04^AQ" D ENALL^DIK
 K DIK,DA,D0
HF ;updating health status file
 S APCDX=0 F  S APCDX=$O(^AUPNVHF(APCDX)) Q:APCDX'=+APCDX  D
 .S APCDPAT=$P(^AUPNVHF(APCDX,0),U,2) Q:APCDPAT=""
 .Q:$D(^AUPNHF("AC",APCDPAT))  ;quit if patient has a health status
 .S APCDDATE=$P($P(^AUPNVSIT($P(^AUPNVHF(APCDX,0),U,3),0),U),".")
 .Q:$P(^AUPNVHF(APCDX,0),U,3)=""
 .S APCDLS=$P(^AUPNVHF(APCDX,0),U,4)
 .W !,"Adding Health Status entry for ",APCDPAT
 .S DIC="^AUPNHF(",DIC(0)="L",DLAYGO=9000019,X="`"_$P(^AUPNVHF(APCDX,0),U),DIC("DR")=".02////"_APCDPAT_";.04////"_APCDLS_";.03////"_APCDDATE,DIADD=1
 .D ^DIC K DIC,DA,DR,DLAYGO,X
 .I Y=-1 W ".....FAILED!!",$C(7),$C(7)
 .Q
 W !!,"ALL DONE....BYE",!!
 K APCDX,APCDDATE,APCDPAT,APCDLS
 K DIADD,DLAYGO,DIC,DR,D0,DI,D1,DDH,DIE,DIK,DMAX,DNM,I,Y,X,DQ
 Q
