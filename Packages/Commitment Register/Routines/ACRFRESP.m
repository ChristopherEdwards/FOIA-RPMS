ACRFRESP ;IHS/OIRM/DSD/THL,AEF - ADD/EDIT APPROVAL RESPONSE; [ 09/23/2005   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**19**;NOV 05, 2001
 ;;UTILITY ROUTINE TO ADD/EDIT APPROVAL RESPONSE
RESP ;EP;TO PROCESS RESPONSE TO REQUEST FOR CHANGE OR CLARIFICATION OF A
 ;REQUEST
 N ACRDOCDT,ACRRESP,ACRINDV,ACRAPDA
 D RESP1
 Q
RESP1 S ACRDOCDT=$G(^ACRDOC(ACRDOCDA,"DT")),ACRAPDA=$P(ACRDOCDT,U,10)
 Q:'ACRAPDA!'+ACRDOCDT!($P(ACRDOCDT,U,2)=1)
 S ACRINDV=$G(^ACRAPVS(ACRAPDA,"DT")),ACRINDV=$S($P(ACRINDV,U,6):$P(ACRINDV,U,6),1:$P(ACRINDV,U,2))
 Q:'ACRINDV
 ;Q:'$D(^VA(200,ACRINDV,0))  S X=$P(^(0),U),ACRINDV=$P($P(X,",",2)," ")_" "_$P(X,",")  ;ACR*2.1*19.02 IM16848
 Q:'$D(^VA(200,ACRINDV,0))  S X=$$NAME2^ACRFUTL1(ACRINDV),ACRINDV=$P($P(X,",",2)," ")_" "_$P(X,",")  ;ACR*2.1*19.02 IM16848
 N ACRJ
 D APDA^ACRFDISA
 I ACRZ>1 D  Q:$D(ACRQUIT)!$D(ACROUT)
 .S DIR(0)="NO^1:"_ACRZ,DIR("A")="Respond to which message",DIR("B")=1
 .W !
 .D DIR^ACRFDIC
 .S ACRZ=+Y
 S DA=ACRAPDA
 S DIE="^ACRAPVS("
 S DR="[ACR RESPONSE]"
 D DDS^ACRFDIC
 I $D(ACRSCREN) K ACRSCREN W ! D DIE^ACRFDIC
 S ACRRESP=$G(^ACRAPVS(ACRAPDA,"RESP"))
 Q:$L(ACRRESP)<3
 D NOW^%DTC
 S ACRNOW=%
 S:ACRZ<1 ACRZ=1
 S:$D(^ACRAPVS(ACRAPDA,1,0))#2<1 ^ACRAPVS(ACRAPDA,1,0)="^9002190.01DA"
 I '$D(^ACRAPVS(ACRAPDA,1,ACRZ,0)) D
 .S X=ACRNOW,DIC="^ACRAPVS("_ACRAPDA_",1,",DA(1)=ACRAPDA,DIC(0)="L"
 .D FILE^ACRFDIC
 .S ACRZ=+Y
 S DIE="^ACRAPVS("_ACRAPDA_",1",DA(1)=ACRAPDA,DA=ACRZ,DR=".03////"_DUZ_";.04////"_ACRNOW
 D DIE^ACRFDIC
 S ^ACRAPVS(ACRAPDA,1,ACRZ,"RESP")=ACRRESP
 S DA=ACRDOCDA
 S DIE="^ACRDOC("
 S DR="[ACR RESPONSE COMPLETED]"
 D DDS^ACRFDIC
 Q:'$D(ACRSCREN)
 K ACRSCREN
 W !
 D DIE^ACRFDIC
 Q