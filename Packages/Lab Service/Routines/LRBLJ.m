LRBLJ ; IHS/DIR/FJE - BLOOD BANK INVENTORY OPTS 5/30/86 3:40 PM ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 S X="BLOOD BANK" D ^LRUTL Q:Y=-1
OPTS R !!,"Select Blood Inventory Option: ",X:DTIME Q:X=""!(X[U)
 F A=1:1 S Y=$P($T(OPT+A),";",3) Q:Y=""  G:$E(X,1)=$P(Y,U,2) DO
 W !!,"Select from:" G LST
DO W " ",$E($P(Y,U,1),7,$L($P(Y,U,1))),! S LROPT=$P(Y,U,3,4) D @LROPT G OPTS
LST F A=1:1 W !,?15,$P($P($T(OPT+A),";",3),U,1) Q:$T(OPT+A)=""
 G OPTS
OPT ;;OPTION LIST
 ;;L ==> Log-in components^L^^LRBLJLG
 ;;I ==> Inventory Data Entry^I^^LRBLJDA
 ;;P ==> Print Inventory Data^P^^LRBLJP
 ;;E ==> Edit Inventory Data^E^^LRBLJED
 ;;W ==> Worksheet for ABO/Rh testing^W^^LRBLJW
