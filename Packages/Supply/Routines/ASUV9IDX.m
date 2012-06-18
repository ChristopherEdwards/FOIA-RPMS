ASUV9IDX ; IHS/ITSC/LMH -INVTR ENTER INDEX NUMBER ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This is a Physical Inventory utility to select an Index Number.
 N DIC
 S DIC("A")="ENTER INDEX NUMBER ",DIC(0)="AEMQZ",DIC="9002032"
 S DIC("S")="I $P(^(0),U,6)=ASUMV(""E#"",""ACC"")"
 D ^DIC
 I $D(DTOUT)!($D(DUOUT)) K X,Y Q
 I Y<0 S ASUMX("E#","IDX")="" K X,Y Q
 S X=$P(Y,U,2),ASUMX("E#","IDX")=$P(Y,U) K Y
 Q
