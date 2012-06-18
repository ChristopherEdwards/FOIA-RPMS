BARACE ; IHS/SD/LSL - add new A/R Accounts ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 D:'$D(BARUSR) INIT^BARUTL
 ;
DIC ;EP
 ; loop A/R accounts
 K DIC,DA,DR
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AQMLZ"
 S DIC("S")="I $P(^(0),U,10)=BARUSR(29,""I"")"
 D ^DIC
 Q:Y'>0
 S DR="2///BILLABLE;Q;" ;billable
 I Y["BAR" S DR="2///FINANCIAL;Q;" ;financial
 S DIE=DIC
 S DR=DR_".01;10///^S X=BARUSR(29,""I"");8////^S X=DUZ(2)"
 S DA=+Y
 S DIDEL=90050
 D ^DIE
 K DIDEL
 G DIC
