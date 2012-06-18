ACRFCLOS ;IHS/OIRM/DSD/THL,AEF - UTILITY TO CLOSE FISCAL YEAR ACCOUNTS; [ 09/23/2005   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**19**;NOV 05, 2001
EN D EN1
EXIT K ACR,ACRXYR
 Q
EN1 ;SPECIFY FISCAL YEAR
 W @IOF
 W !,"This utility will allow you to delete user access to DEPARTMENT ACCOUNTS"
 W !,"for a selected fiscal year."
 W !!,"You should NOT do this until you have created your next fiscal year accounts."
 W !,"If you have completed this process, proceed with closing DEPARTMENT ACCOUNTS."
 S DIR(0)="NOA^1000:9999"
 S DIR("A")="Fiscal Year: "
 S DIR("?")="Enter the four digit fiscal year for which you want to delete account access."
 W !
 D DIR^ACRFDIC
 Q:Y<1
 S ACRFY=Y
 D EX
 D ALL
 Q
ALL ;DECIDE WHETHER TO DELETE ACCESS TO ALL ACCOUNTS OR SELECTED ACCOUNTS
 K ACRXYR
 S DIR(0)="YO"
 S DIR("A",1)="Do you want CLOSE Multi-year and"
 S DIR("A")="'X' appropriation accounts"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)
 I Y=1 D  Q:$D(ACRQUIT)
 .S DIR(0)="YO"
 .S DIR("A",1)="Are you certain you want to CLOSE"
 .S DIR("A")="Multi-year and 'X' appropriaiton accounts."
 .S DIR("B")="NO"
 .W !
 .D DIR^ACRFDIC
 .Q:$D(ACRQUIT)
 .Q:Y'=1
 .S ACRXYR=""
 S DIR(0)="SO^1:All Department Accounts;2:Selected Department Accounts;3:One selected account"
 S DIR("A")="Which one"
 S DIR("?")="Enter the appropriate code from the list"
 S DIR("?",1)="Number '1' deletes access of users from ALL Department Accounts."
 S DIR("?",2)="Number '2' deletes access of users from ONLY selected Department Accounts."
 S DIR("?",3)="Number '3' deletes access of users from ONE selected Department Account."
 D DIR^ACRFDIC
 Q:'$D(Y)
 Q:"123"'[Y
 S ACRALL=Y
 I +Y=1 D A1 Q
 I +Y=2 D SOME Q
 I +Y=3 D SELECT Q
 Q
A1 ;PROCESS ALL DEPARTMENT ACCOUNTS FOR THE SPECIFIED FISCAL YEAR
 D CERTAIN
 Q:$D(ACRQUIT)
 W !!
 S (ACR,ACRI)=0
 F  S ACR=$O(^ACRLOCB("FY",ACRFY,ACR)) Q:'ACR  I $D(^ACRLOCB(ACR,0)) S ACR0=^(0),ACRDT=^ACRLOCB(ACR,"DT") D
 .Q:$P(ACR0,U,23)
 .S ACRI=ACRI+1
 .D DELETE
 Q
SOME ;PROCESS SELECTED DEPARTMENT ACCOUNTS
 S (ACR,ACRI)=0
 F  S ACR=$O(^ACRLOCB("FY",ACRFY,ACR)) Q:'ACR!$D(ACRQUIT)  I $D(^ACRLOCB(ACR,0)) S ACR0=^(0),ACRDT=^ACRLOCB(ACR,"DT") D
 .S ACRI=ACRI+1
 .W !!?10,"-----------------------------------------------------"
 .W !?10,"ID NO."
 .W ?19,"DEPARTMENT"
 .W ?52,"CAN"
 .W !?10,"------"
 .W ?19,"------------------------------"
 .W ?52,"-------"
 .W !?10,ACR
 .W ?19,$S($P($G(^AUTTPRG(+$P(ACR0,U,5),0)),U)]"":$P(^(0),U),1:"NOT STATED")
 .W ?52,$S($P($G(^AUTTCAN(+$P(ACRDT,U,9),0)),U)]"":$P(^(0),U),1:"NOT STATED")
 .S DIR(0)="YO"
 .S DIR("A")="Delete access to account (ID NO. "_ACR_")"
 .S DIR("B")="NO"
 .W !
 .D DIR^ACRFDIC
 .Q:Y'=1
 .D DELETE
 Q
DELETE ;DELETE USER ACCESS FROM DEPARTMENT ACCOUNT
 ;DO NOT DELETE USER ACCESS TO MULTI-YEAR ACCOUNTS
 N X
 S X=$P($G(^AUTTPRO(+$P($G(ACRDT),U,4),0)),U)
 I '$D(ACRXYR),X["X"!(X["/") Q
 W !!?10,ACR
 W ?19,$S($P($G(^AUTTPRG(+$P(ACR0,U,5),0)),U)]"":$P(^(0),U),1:"NOT STATED")
 W ?50,"<USER ACCESS DELETED>"
 S ACRDA=0
 F  S ACRDA=$O(^ACRLOCB(ACR,"SC",ACRDA)) Q:'ACRDA  D
 .I $D(^ACRLOCB(ACR,"SC",ACRDA,0)),'$D(ACREX(+^(0))) D
 ..S DA(1)=ACR
 ..S DA=ACRDA
 ..S DIK="^ACRLOCB("_ACR_",""SC""," W "."
 ..D DIK^ACRFDIC
 Q
EX ;CHOOSE USER(S) TO EXCLUDE FROM ACCOUNT ACCESS DELETE
 ;SELECT 'EMPLOYEE'
 W !!,"You may identify employees for whom access will NOT be deleted."
 W !,"The employees selected below will NOT have their account access deleted."
 F  D EX1 Q:$D(ACRQUIT)
 Q
EX1 ;CHOOSE EMPLOYEE
 S DIC="^VA(200,"
 S DIC(0)="AEMQZ"
 S DIC("A")="EMPLOYEE............: "
 S DIC("DR")=""
 W !!?21,"|" F ACRI=1:1:30 W "="
 W "|"
 D DIC^ACRFDIC
 I U[$E(X)!(+Y<1) S ACRQUIT="" Q
 S ACRDUZ=+Y
 S ACREX(+Y)=""
 ;S ACRUSER=Y(0,0)  ;ACR*2.1*19.02 IM16848
 ;S ACRUSER=$P(ACRUSER,",",2)_" "_$P(ACRUSER,",")  ;ACR*2.1*19.02 IM16848
 S ACRUSER=$$NAME3^ACRFUTL1(ACRDUZ)  ;ACR*2.1*19.02 IM16848
 W !!,ACRUSER," will NOT be deleted from account access."
 Q
SELECT ;SELECT SINGLE DEPARTMENT ACCOUNT FROM WHICH TO DELETE ACCESS
 S DIC="^ACRLOCB("
 S DIC(0)="AENQZ"
 S DIC("A")="Account ID NO.: "
 S DIC("?")="Enter the ID NO. of the account from which to delete access."
 W !
 D DIC^ACRFDIC
 Q:+Y<1
 I $D(^ACRLOCB(+Y,0)) D
 .S ACR=+Y,ACR0=^ACRLOCB(+Y,0),ACRDT=^ACRLOCB(+Y,"DT")
 .D CERTAIN
 .Q:$D(ACRQUIT)
 .D DELETE
 Q
CERTAIN ;CHECK TO ENSURE USER WANST TO DELETE ACCOUNT ACCESS
 S DIR(0)="YO"
 S DIR("A")="Are you CERTAIN you want to delete account access"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 S:Y'=1 ACRQUIT=""
 Q
