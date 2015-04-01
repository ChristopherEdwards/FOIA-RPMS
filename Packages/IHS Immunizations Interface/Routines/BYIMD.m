BYIMD ;IHS/CMI/THL - IMMUNIZATION DATA EXCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE;**3,4,5,6**;NOV 01, 2013;Build 229
 ;
 ;UTILITY TO CONTROL 'D' CROSS REFERENCE FOR DATA EXPORT
 ;
 Q
EN ;EP;TO SET DATE AND SET 'D' XREF FOR ALL IMMUNIZATIONS PRIOR TO DATE
 ;SO IMM'S WON'T BE EXPORTED
 ;
 K DIR
 S DIR(0)="DO"
 S DIR("A")="Enter a reference date"
 W @IOF
 W !!?5,"Enter a reference date."
 W !!?5,"ALL immunizations given prior to the date selected will be"
 W !?5,"flagged as 'exported' so they will not be exported again"
 W !?5,"in the daily batch immunization exports."
 W !
 D ^DIR
 K DIR
 Q:'Y
 S DATE=Y
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Are you sure you want to proceed"
 S DIR("B")="NO"
 S Y=DATE
 X ^DD("DD")
 W !!?5,"ALL immunizations given prior to: ",Y
 W !?5,"will now be flagged as 'exported'"
 W !
 D ^DIR
 K DIR
 Q:'Y
 N DA,X0,P,V,VD,J
 S DA=0
 F  S DA=$O(^AUPNVIMM(DA)) Q:'DA  S X0=$G(^(DA,0)) D
 .Q:$D(^BYIMEXP("D",DA))
 .S V=$P(X0,U,3)
 .Q:'V
 .S P=$P(X0,U,2)
 .Q:'P
 .S VD=+$G(^AUPNVSIT(V,0))
 .Q:'VD
 .Q:VD>DATE
 .L ^BYIMEXP(0):1
 .F J=3,4 S X=$P(^BYIMEXP(0),U,J),X=X+1,$P(^BYIMEXP(0),U,J)=X
 .L -^BYIMEXP(0)
 .L ^BYIMEXP(X,0):1
 .S ^BYIMEXP(X,0)=P_U_DATE_U_DA_U_"E^MARKED AS EXPORTED WITHOUT EXPORT"
 .L -^BYIMEXP(X,0)
 .S ^BYIMEXP("D",DA,X)="MARKED AS EXPORTED WITHOUT EXPORT"
 .W:'$D(ZTQUEUED) "."
 Q
 ;-----
EN1 ;EP;TO SELECT DATES TO CLEAR 'D' XREFS FOR IMMUNIZATIONS DURING
 ;A DATE ;RANGE
 ;
 K DIR
 S DIR(0)="DO"
 S DIR("A")="Enter a beginning date to resend all immunizations"
 W @IOF
 W !!?5,"Enter a reference date."
 W !!?5,"ALL immunizations given from the date selected will"
 W !?5,"have the 'exported' flag removed so they will be exported"
 W !?5,"again in the daily batch immunization exports."
 W !
 D ^DIR
 K DIR
 Q:'Y
 S DATE=Y
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Are you sure you want to proceed"
 S DIR("B")="NO"
 S Y=DATE
 X ^DD("DD")
 W !!?5,"ALL immunizations given on: ",Y," and after"
 W !?5,"will have the 'exported' flag removed"
 W !
 D ^DIR
 K DIR
 Q:'Y
 N DA,VDA,X0,P,V,VD,J
 S VD=DATE-.0001
 F  S VD=$O(^AUPNVSIT("B",VD)) Q:'VD  D
 .S VDA=0
 .F  S VDA=$O(^AUPNVSIT("B",VD,VDA)) Q:'VDA  D EN11
 Q
 ;-----
EN11 ;CHECK VISIT RELATED IMM'S
 S DA=0
 F  S DA=$O(^AUPNVIMM("AD",VDA,DA)) Q:'DA  D:$D(^BYIMEXP("D",DA))
 .K ^BYIMEXP("D",DA)
 .W:'$D(ZTQUEUED) "."
 Q
 ;-----
