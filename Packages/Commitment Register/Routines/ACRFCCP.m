ACRFCCP ;IHS/OIRM/DSD/THL,AEF - CREDIT CARD PURCHASE MANAGEMENT REPORTS;  [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;ROUTINE TO SELECT DATE RANGE AND CARDHOLDERS AND PRINT THE CREDIT
 ;;CARD REPORT
EN D EN1
EXIT K ACR,ACRBEGIN,ACREND,ACRDUZ,ACRCAN,ACRDATE,ACRDOC0,ACRDOCDA,ACRJ,ACRI,ACROBJ,ACRP,ACRPAID,ACRPO,ACRQUAN,ACRRCD,ACRREQ,ACRREQ2,ACRRTN,ACRSSDA,ACRT,ACRTOT,ACRTOTAL,ACRTOTP,ACRTOTPD,ACRTP,ACRUC,ACRUI,ACRQUIT,ACRBYCAN,ACRCANDA
 Q
EN1 ;
 D PO
 Q:$D(ACRQUIT)!$D(ACROUT)!'$D(ACRPODA)
 W @IOF
 W !?20,"CREDIT CARD REPORT"
 W !!!,"Select the DATE RANGE and CARDHOLDER(S) for this report:"
 W !
 D DATE
 Q:$D(ACRQUIT)!$D(ACROUT)!'$D(ACRBEGIN)
 D HOLDER
 Q:$D(ACRQUIT)!$D(ACROUT)
 D TYPE
 Q:$D(ACRQUIT)!$D(ACROUT)
 I ACRBEGIN="" D  Q:$G(Y)'=1
 .W !!,"You have chosen to print the CREDIT CARD REPORT for"
 .W !,"ALL dates and ALL cardholders."
 .W !,"(This could be a VERY lengthy report!"
 .W !
 .S DIR(0)="YO"
 .S DIR("B")="NO"
 .S DIR("A")="Are you certain this is what you want"
 .D DIR^ACRFDIC
ZIS S (ACRRTN,ZTRTN)="PRINT^ACRFCCP1"
 S ZTDESC="CREDIT CARD REPORT"
 S ACRCOND=""
 D ^ACRFZIS
 Q
DATE ;
 S DIR(0)="DO^::E"
 S DIR("A")="Beginning Date"
 S DIR("?",1)="Enter the earliest date for which you want to include credit card purchases"
 S DIR("?")="Do not enter any date if you want to list all credit card purchases"
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 Q:'Y
 K ACRQUIT
 S ACRBEGIN=Y,ACREND=""
 I ACRBEGIN D  Q:$D(ACRQUIT)
 . S DIR(0)="DO^::E"
 .S DIR("A")="Ending Date..."
 .S DIR("?",1)="Enter the latest date for which you want to include credit card purchases."
 .S DIR("?")="Do not enter any date if you want to list all credit card purchases."
 .D DIR^ACRFDIC
 .I $E(X)[U S ACRQUIT="" Q
 .K ACRQUIT
 .S ACREND=$S(Y="":DT,1:Y)
 Q
HOLDER ;
 S DIC="^ACRAU("
 S DIC(0)="AEMQZ"
 S DIC("A")="Cardholder....: "
 S DIC("S")="I $P($G(^ACRAU(+Y,1)),U,5)=1"
 D DIC^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 S ACRDUZ=$S(+Y>0:+Y,1:"")
 Q
TYPE ;SELECT TYPE OF REPORT
 S DIR(0)="SO^1:Standard Report by Cardholder;2:Finance Report by CAN"
 S DIR("B")="Standard Report"
 S DIR("A")="Which Report"
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 Q:'Y
 I Y=2 S ACRBYCAN=""
 Q
PO ;SELECT PURCHASING OFFICE
 D OFFICE^ACRFPA
 I '+$G(ACRDA) S ACRQUIT="" Q
 I '$D(^ACRPO(ACRDA,0)) S ACRQUIT="" Q
 S ACRPODA=ACRDA
 Q
