ABMDRCPI ; IHS/ASDST/DMJ - Utility for Pitch Selection ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 U IO(0) S ABMP("CPI")=1
 K DIR S DIR(0)="S^10:10 CPI;12:12 CPI;16:16.7 CPI",DIR("B")=10,DIR("A")="Select Desired PITCH (characters per inch)" D ^DIR
 U IO Q:$D(DIRUT)!$D(DIROUT)!'Y
 D @Y W:$P(ABMP("CPI"),U,2)]"" @$P(ABMP("CPI"),U,2)
 Q
16 I $D(^%ZIS(2,IOST(0),12.1)) S $P(ABMP("CPI"),U,2)=^(12.1),$P(ABMP("CPI"),U)=1.667
 Q
10 I $P($G(^%ZIS(2,IOST(0),5)),U)]"" S $P(ABMP("CPI"),U,2)=$P(^(5),U,1),$P(ABMP("CPI"),U)=1
 Q
12 I $P($G(^%ZIS(2,IOST(0),5)),U,2)]"" S $P(ABMP("CPI"),U,2)=$P(^(5),U,1),$P(ABMP("CPI"),U)=1.2
 Q
