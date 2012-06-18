APCLRPT ; IHS/CMI/LAB - INTERACTIVE ROUTINE FOR DATA FETCHER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
CREATE ; - ENTRY POINT - from menu option to create report template
 S DIR(0)="FO^3:30",DIR("A")="ENTER THE NAME OF A NEW REPORT TEMPLATE",DIR("?",1)="Enter a name, 3-30 characters long for a report template.  This option for",DIR("?")="creation of new report templates only." D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)!(X="") Q
 S APCLA=0 F  S APCLA=$O(^APCLRPT("B",X,APCLA)) Q:'APCLA  I $P(^APCLRPT(APCLA,0),U,2)=DUZ W !,*7,"This option for creation of new report templates only!",! Q
 G:APCLA CREATE
 S DIC="^APCLRPT(",DIC("DR")=".02////"_DUZ,DIC(0)="EL",DIADD=1,DLAYGO=9001200 D ^DIC K DIC,DIADD
 I Y>0 S APCLRPT=+Y D DATA
 E  W !,*7  Q
 K APCLA
 W ! G CREATE
 Q
 ;
EDIT ; - ENTRY POINT - from menu option to modify/delete report template
 S DIC="^APCLRPT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y>0 S APCLRPT=+Y
 E  Q
 D DATA
 W ! G EDIT
 Q
 ;
DATA ; Enter or edit field values
 S DR=".01;1101;2101;3101",DR(2,9001200.03101)=".01;1101;2101",DA=APCLRPT,DIE="^APCLRPT(" D ^DIE K DIE,DR
 K APCLRPT
 Q
 ;
PRINT ; - ENTRY POINT - for print option from report template menu
 ;S DIC="^APCLRPT(",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,2)=DUZ" D ^DIC K DIC
 S DIC="^APCLRPT(",DIC(0)="AEMQ" D ^DIC K DIC ;FORGET THE SCREEN IHS/OKCAO/POC 4/20/97
 I Y>0 S APCLRPT=+Y
 E  Q
 D START1^APCLASK(APCLRPT)
 K APCLRPT
 Q
 ;
