ABMDR16 ; IHS/ASDST/DMJ - COMPRESSED PRINTING SETUP ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
16 ;EP for Compressed print for printer.
 W !?5,"(This report requires 132 Width export format)"
 K ABM("PRINT") S:$D(^%ZIS(2,IOST(0),12.1)) ABM("PRINT",16)=^(12.1)
 I $G(ABM("PRINT",16))="" W !,*7,"=== Condensed Print has not been established for this Device. ===" G XIT
 W ! K DIR S DIR(0)="Y",DIR("A")="Should Output be in CONDENSED PRINT (Y/N)",DIR("B")="Y" D ^DIR K DIR I '$G(Y) K ABM("PRINT") G 10
 Q
10 ;EP for resetting to standard print.
 I $D(^%ZIS(2,IOST(0),5)),$P(^(5),U)'="" S ABM("PRINT",10)=$P(^(5),U)
 I $D(ABM("PRINT",10)) W @ABM("PRINT",10)
 Q
 ;
XIT K ABM("PRINT")
 Q
