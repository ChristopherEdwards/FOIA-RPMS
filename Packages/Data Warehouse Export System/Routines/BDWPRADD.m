BDWPRADD ; IHS/CMI/LAB - SET PATIENT AS AN ADD ;
 ;;1.0;IHS DATA WAREHOUSE;**2**;JAN 23, 2006
 ;
START ;EP - called from option
 W !!,"This option is used to flag a patient to be sent to the Data"
 W !,"Warehouse as an ADD.  This option should be used if an edit"
 W !,"patient record has failed at the warehouse because the patient"
 W !,"was never received as an add prior to the edit message being"
 W !,"sent.  The patient(s) that you choose will be flagged as adds"
 W !,"and sent on the next regularly scheduled data warehouse export (GDW)."
 W !!
 K BDWR
PATIENT ;
 K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 D DONE Q
 S BDWPAT=+Y
 W !,"Flagging ",$P(^DPT(BDWPAT,0),U)," as an add."
 D ^XBFMK
 S DA=BDWPAT,DIE="^AUPNPAT(",DR=".41///@;.42///@;.43///@;.44///@;.45///@" D ^DIE K DA,DIE,DR  ;set all export date fields to null
 S DA=BDWPAT,DIK="^AUPNDWAF(" D ^DIK K DA,DIK
 S DINUM=BDWPAT,X=BDWPAT,DIC="^AUPNDWAF(",DR=".02////"_DT_";.04////"_DT_";.06////"_$S($O(^DPT(BDWPAT,.01,0)):DT,1:"")_";.11////"_$S($$ELIG(BDWPAT):DT,1:"")
 S DIC(0)="L",DIADD=1,DLAYGO=9000003.3 K DD,D0,DO D FILE^DICN K DINUM,DIC,DA,DIADD,DLAYGO,DD,DO,D0
 I Y=-1 W !!,"adding to dw audit file failed...notify programmer"
 D ^XBFMK
 G PATIENT
ELIG(P) ;
 I $D(^AUPNMCR(P)) Q 1
 I $D(^AUPNPRVT(P)) Q 1
 I $O(^AUPNMCD("B",P,0)) Q 1
 Q 0
DONE ;
 D ^XBFMK
 K BDWPAT
 Q
