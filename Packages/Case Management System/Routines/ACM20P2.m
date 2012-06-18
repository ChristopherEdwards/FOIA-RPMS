ACM20P2 ; IHS/CMI/LAB - post init patch 2 [ 02/14/2000  1:54 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**2**;JAN 10, 1996
 ;
 ;update 2 entries in ^ACM(58.1)
 S DA=43,DIE="^ACM(58.1,",DR=".01///Primary Care Provider (PCC);.06///PRIMARY PROVIDER" D ^DIE
 S ^ACM(58.1,43,2)="S X=$S($P(^DD(9000001,.14,0),U,2)[200:$P(^VA(200,X,0),U),1:$P(^DIC(16,X,0),U))"
 D ^XBFMK
 S DA=87,DIE="^ACM(58.1,",DR=".01///Register Provider;.06///REGISTER PROVIDER" D ^DIE
 D ^XBFMK
 Q
