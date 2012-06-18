ABMDE23P ; IHS/ASDST/DMJ - PAGE 2 - 3RD PARTY SOURCES ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; *********************************************************************
 ;
MCD ;
 S $P(ABMV("X1"),U,4)=$P(ABMX("REC"),U,3)
 I $P(ABMX("REC"),U,9)]"" D
 .S $P(ABMV("X2"),U,1)=$P(ABMX("REC"),U,9)
 .S $P(ABMV("X2"),U,2)=$P(ABMX("REC"),U,6)
 S:$P(ABMV("X2"),U,1)="" ABME(65)=""
 S:$P(ABMV("X2"),U,2)="" ABME(67)=""
 I $D(^AUPNMCD(ABMX(2),21)) D
 .S:$P(^AUPNMCD(ABMX(2),21),U)]"" $P(ABMV("X1"),U,5)=$P(^AUPNMCD(ABMX(2),21),U)
 .S:$P(^AUPNMCD(ABMX(2),21),U,2)]"" $P(ABMV("X1"),U,6)=$P(^AUPNMCD(ABMX(2),21),U,2)
 D COV
 Q
 ;
 ; *********************************************************************
PRVT ;
 I '$D(^AUPNPRVT(ABMX(2),11,ABMX(1),0)) D  Q
 .S DA(1)=ABMP("CDFN")
 .S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 .S DA=ABMX(1)
 .D ^DIK
 S ABMX("REC")=^AUPNPRVT(ABMX(2),11,ABMX(1),0)
 S $P(ABMV("X1"),U,4)=$P(ABMX("REC"),U,2)
 I $P(ABMX("REC"),U,8)]"" D
 .S $P(ABMV("X2"),U,1)=$P(ABMX("REC"),U,8)
 .S $P(ABMV("X2"),U,2)=$P(ABMX("REC"),U,5)
 S:$P(ABMV("X2"),U,1)="" ABME(65)=""
 S:$P(ABMV("X2"),U,2)="" ABME(67)=""
 S:$P(ABMX("REC"),U,9)]"" $P(ABMV("X1"),U,5)=$P(ABMX("REC"),U,9)
 S:$P(ABMX("REC"),U,11)]"" $P(ABMV("X1"),U,6)=$P(ABMX("REC"),U,11)
 D COV
 Q
 ;
 ; *********************************************************************
MCR ;
 S $P(ABMV("X1"),U,4)=$P(ABMX("REC"),U,3)_"-"_$P(^AUTTMCS($P(ABMX("REC"),U,4),0),U)
 I $D(^AUPNMCR(ABMX(2),21)) D
 .S:$P(^AUPNMCR(ABMX(2),21),U)]"" $P(ABMV("X1"),U,5)=$P(^AUPNMCR(ABMX(2),21),U)
 .S:$P(^AUPNMCR(ABMX(2),21),U,2)]"" $P(ABMV("X1"),U,6)=$P(^AUPNMCR(ABMX(2),21),U,2)
 D COV
 Q
 ;
 ; *********************************************************************
RRE ;
 S $P(ABMV("X1"),U,4)=$P(^AUTTRRP($P(ABMX("REC"),U,3),0),U)_"-"_$P(ABMX("REC"),U,4)
 I $D(^AUPNRRE(ABMX(2),21)) D
 .S:$P(^AUPNRRE(ABMX(2),21),U)]"" $P(ABMV("X1"),U,5)=$P(^AUPNRRE(ABMX(2),21),U)
 .S:$P(^AUPNRRE(ABMX(2),21),U,2)]"" $P(ABMV("X1"),U,6)=$P(^AUPNRRE(ABMX(2),21),U,2)
 D COV
 Q
 ;
 ; *********************************************************************
NON ;
 Q
 ;
 ; *********************************************************************
COV ;
 S ABMX=0
 F ABMX("C")=1:1 S ABMX=$O(@(ABMP("GL")_"13,"_ABMX("INS")_",11,"_ABMX_")")) Q:'ABMX  S $P(ABMV("X1"),U,9)=$S($P(ABMV("X1"),U,9)]"":$P(ABMV("X1"),U,9)_";"_$P(^AUTTPIC(ABMX,0),U),1:$P(^AUTTPIC(ABMX,0),U))
 Q
 ;
 ; *********************************************************************
XIT ;
 K ABMX
 Q
