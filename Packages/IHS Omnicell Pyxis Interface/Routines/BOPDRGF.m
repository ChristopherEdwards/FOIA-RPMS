BOPDRGF ;IHS/ILC/ALG/CIA/PLS - adding drugs to file that will not create unverified Rx;06-Apr-2005 13:41;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;;Jul 26, 2005
 ;
SET ;set a record
 S DIC=50,DIC(0)="QEAMZ"
 W !,"Enter the drug that WILL create a new unverified prescription."
 S DIC("A")="Enter Drug Name // "
 D ^DIC K DIC Q:Y'>0
 I $D(^BOP(90355.5,"B",Y(0,0))) W !,"This drug is already in the BOP Drug File",$C(7),! G SET
 K DD,DO
 S DIC=90355.5,DIC(0)="L",X=Y(0,0)
 S DIC("DR")="2////"_+Y
 D FILE^DICN
 I X]"" W !!,X_" has been added to the BOP Drug File.",$C(7),!!
 G SET
DEL ;EP - delete a record
 N DRUG,DIK,DA S DIC=90355.5,DIC(0)="QEAMZ"
 S DIC("A")="Enter the drug you want removed from the BOP Drug file. // "
 D ^DIC K DIC Q:Y'>0  S DRUG=Y(0,0)
 S DIK="^BOP(90355.5,",DA=+Y D ^DIK
 I X]"" W !!,DRUG,!,"has been deleted from the BOP Drug File.",$C(7),!!
 G DEL
