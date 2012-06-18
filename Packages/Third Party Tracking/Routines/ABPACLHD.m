ABPACLHD ;PRINT CHECK LOG HEADING; [ 08/07/91  9:16 AM ]
 ;;1.4;AO PVT-INS TRACKING;*1*;IHS-OKC/KJR;AUGUST 7, 1991
 ;;PATCH 1: END+19 MODIFIED TO STUFF 'YES';IHS-OKC/KJR;07AUG91
HEAD W @IOF S ABPAPG=ABPAPG+1 D CHECK^ABPAOPT I +ABPAOPT(5)>0 D
 .F I=1:1:+ABPAOPT(5) W !
 W ?55,"PAGE ",ABPAPG F I=1:1:5 W !
 W ?12,+$E(DT,4,5)_"/"_+$E(DT,6,7)_"/"_+$E(DT,2,3),!!,?12,ABPAOPT(3)
 W !!!,?12,"Private Insurance Collections"," - ",ACCTPT,!!
 W ?12,"Finance",!?12,$P(^DIC(4,DUZ(2),0),"^"),!!!!
 W ?12,"Collections listed below totaling " S X=ABPA("SUM"),X2="2$"
 S X3=11 D COMMA^%DTC W X," are transmitted"
 W !,?12,"herewith for appropriate action.",!!!
 W ?5,"RECEIVED",?16,"CHECK #",?33,"PAYOR",?68,"AMOUNT",!
 W ?5,"________",?16,"_______",?33,"_______",?68,"______",!
 Q
 ;--------------------------------------------------------------------
END ;PROCEDURE TO PROCESS THE FINAL TASK DURING PRINTING OF THE CHECK LOG
 I $Y>46 W @IOF S ABPAPG=ABPAPG+1 W ?55,"PAGE ",ABPAPG,!!!!!!!!
 I $D(FINAL)=1 I 'FINAL D  Q
 .S X="* * *  D R A F T   C O P Y   O N L Y  * * *"
 .S Y="*******************************************"
 .W !!!!!?(40-($L(Y)/2)),Y,!?(40-($L(X)/2)),X,!?(40-($L(Y)/2)),Y,@IOF
 W !!!!?45,ABPAOPT(4),!,?45,ABPAOPT(10)
 W !?45,$P(^DIC(4,DUZ(2),0),"^")
 W !!!?5,"RECEIPT FOR $ __________________ IS HEREBY ACKNOWLEDGED."
 W !!!?45,"____________________",!?45,"Financial Management"
 D ^%AUCLS
 ;--------------------------------------------------------------------
 ;PROCEDURE TO FLAG CHECKS AS HAVING BEEN REPORTED ON A TRANSMITTAL
 I $D(FINAL)=1 I FINAL K DIE,DR,DA D
 .S DA(2)=DA2,DA(1)=0 F J=0:0 D  Q:+DA(1)=0
 ..S DA(1)=$O(^ABPACHKS("TR",ABPADT,"N",DA(2),DA(1))) Q:+DA(1)=0
 ..S DA=0 F K=0:0 D  Q:+DA=0
 ...S DA=$O(^ABPACHKS("TR",ABPADT,"N",DA(2),DA(1),DA)) Q:+DA=0
 ...S DIE="^ABPACHKS("_DA(2)_",""I"","_DA(1)_",""C"","
 ...S DR="11///YES" D ^DIE
 .;------------------------------------------------------------------
 .;PROCEDURE TO CREATE BATCH DATE FOR THIS TRANSMITTAL DATE
 .S R=0,LGTOT=0,DA2=1 F I=0:0 D  Q:+R=0
 ..S R=$O(^ABPACHKS("RB",DA2,R)) Q:+R=0
 ..S RR=0 F J=0:0 D  Q:+RR=0
 ...S RR=$O(^ABPACHKS("RB",DA2,R,RR)) Q:+RR=0
 ...Q:$D(^ABPACHKS(DA2,"I",R,"C",RR,0))'=1
 ...S LGDT=$P(^ABPACHKS(DA2,"I",R,"C",RR,0),"^",2)
 ...S LGDT=$P(LGDT,".") Q:LGDT'=ABPADT
 ...S LGTOT=LGTOT+(+^ABPACHKS("RB",DA2,R,RR))
 .K DIC,DA S DIC="^ABPAPBAT(",DIC(0)="LZ",X=ABPADT D ^DIC
 .I +$P(Y,"^",3)>0 D
 ..S ^ABPAPBAT(+Y,0)=^ABPAPBAT(+Y,0)_"^0^0^0^O^"_DUZ_"^"_DT
 ..F ABPAJ=11:1:14 S $P(^ABPAPBAT(+Y,0),"^",ABPAJ)=0
 ..K DIK,DA S DIK="^ABPAPBAT(",DA=+Y D IX^DIK K DIC,DIK,DA
 ..S P10=+$P(^ABPAPBAT(+Y,0),"^",10),P10=P10+LGTOT
 ..S $P(^ABPAPBAT(+Y,0),"^",10)=P10
 .;------------------------------------------------------------------
 .;PROCEDURE TO PROCESS ANY CORRECTIONS TO PREVIOUS CHECK LOGS
 .D MAIN^ABPACLG4 K ^TMP("ABPACLG1")
