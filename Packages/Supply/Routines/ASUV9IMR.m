ASUV9IMR ; IHS/ITSC/LMH -INVTR READ MASTER ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This is a Physical Inventory utility to read an Inventory Master.
 D ACCOUNT,STORLOC,INDEX
 Q
ACCOUNT ;EP;
 Q:'$D(ASUMV("E#","ASA"))
 I '$D(^ASUMV(ASUMV("E#","ASA"),0)) S ASUF("ACC")=0 Q
 S ASUF("ACC")=1
 S ASUMV(0,"ASA")=^ASUMV(ASUMV("E#","ASA"),0)
 S ASUMV("ACC")=$E(ASUMV("E#","ASA"),6)
 S ASUL(9,"E#","ACC")=$P(ASUMV(0,"ASA"),U)
 S:ASUL(9,"E#","ACC")']"" ASUL(9,"E#","ACC")=ASUMV("ACC")
 D ACC^ASULDIRF(ASUL(9,"E#","ACC"))
 S ASUMV("INVBEG")=$P(ASUMV(0,"ASA"),U,2)
 S ASUMV("VOU")=$P(ASUMV(0,"ASA"),U,3)
 S ASUMV("MODE")=$P(ASUMV(0,"ASA"),U,4)
 S:$G(ASUL(2,"STA","E#"))']"" ASUL(2,"STA","E#")=$P(ASUMV(0,"ASA"),U,5)
 Q
STORLOC ;EP;
 Q:'$D(ASUMV("E#","ASA"))
 Q:$G(ASUMV("E#","SLC"))'?1N.N
 S ASUMV(0,"SLC")=^ASUMV(ASUMV("E#","ASA"),1,ASUMV("E#","SLC"),0)
 S ASUMV("SLC")=$P(ASUMV(0,"SLC"),U)
 S ASUMV("SL E#")=$P(ASUMV(0,"SLC"),U,2)
 I ASUMV("SL E#")']"" D
 .S ASUMV("SL E#")=$O(^ASUL(10,"B",ASUMV("SLC"),""))
 S ASUMV("SL NM")=$P(^ASUL(10,ASUMV("SL E#"),0),U,2)
 Q
INDEX ;EP;
 Q:'$D(ASUMV("E#","ASA"))
 Q:'$D(ASUMV("E#","SLC"))
 Q:'$D(ASUMV("E#","INDX"))
 S ASUMV(0,"IDX")=^ASUMV(ASUMV("E#","ASA"),1,ASUMV("E#","SLC"),1,ASUMV("E#","INDX"),0)
 S ASUMV("IDX")=$P(ASUMV(0,"IDX"),U,10)
 S ASUMX("E#","IDX")=$P(ASUMV(0,"IDX"),U)
 S ASUMV("IDX")=$P($G(^ASUMX(ASUMX("E#","IDX"),0)),U)
 S:ASUMV("IDX")']"" ASUMV("IDX")=$E(ASUMX("E#","IDX"),3,8)_"*"
 S ASUMV("STA")=$P(ASUMV(0,"IDX"),U,2)
 S ASUMV("QTY","STAM")=$P(ASUMV(0,"IDX"),U,3)
 S ASUMV("U/C")=$P(ASUMV(0,"IDX"),U,4)
 S ASUMV("CNT","1ST")=$P(ASUMV(0,"IDX"),U,5)
 S ASUMV("CNT","2ND")=$P(ASUMV(0,"IDX"),U,6)
 S ASUMV("QTY","DIF")=$P(ASUMV(0,"IDX"),U,7)
 S ASUMV("ADJQTY")=$P(ASUMV(0,"IDX"),U,8)
 S ASUMV("CNT-ENT")=$P(ASUMV(0,"IDX"),U,9)
 Q
