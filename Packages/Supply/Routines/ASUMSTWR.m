ASUMSTWR ; IHS/ITSC/LMH -UPDATE STATION MASTER FROM VARIABLES ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
M ;EP SET ALL FIELDS -STA MASTER
 S:'$D(ASUS("ADD")) ASUS("ADD")=1
 D MI,MIC,MEXP
 Q:'$D(ASUS("ADD"))
 Q:ASUS("ADD")'>0
 I ASUS("ADD")=1 D
 .S:$G(^ASUMS(ASUMS("E#","STA"),1,0))="" ^ASUMS(ASUMS("E#","STA"),1,0)="^9002031.02PA"
 .S $P(^ASUMS(ASUMS("E#","STA"),1,0),U,3)=$P(^ASUMS(ASUMS("E#","STA"),1,0),U,3)+1
 .S $P(^ASUMS(ASUMS("E#","STA"),1,0),U,4)=ASUMS("E#","IDX")
 .S ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),1,0)="^9002031.232A^12^12"
 D X
 K DIKGP,DIKND,DIKNX,DIKST,DIKZ1,DIKNM,DIG,DIH,DIV,DIW,%,DH,DIWF Q
X ;
 S DIK="^ASUMS("_ASUMS("E#","STA")_",1,",DA=ASUMS("E#","IDX"),DA(1)=ASUMS("E#","STA")
 D IX1^DIK K DIK
 Q
MIX ;EP ;SET ONLY MAIN FIELDS THEN RE-CROSSREFERENCE
 D MI,X Q
S ;EP SET FIELDS -STA MASTER
 I $G(ASUMS("E#","STA"))="",$G(ASUL(2,"STA","E#"))]"" S ASUMS("E#","STA")=ASUL(2,"STA","E#")
 Q:'$D(ASUMS("E#","STA"))
 S $P(ASUMS(0),U)=ASUMS("STA")
 S $P(ASUMS(0),U,2)=ASUMS("AR")
 S ^ASUMS(ASUMS("E#","STA"),0)=ASUMS(0)
 Q
MI ;EP SET STATION MASTER DATA VARIABLES
 I $G(ASUMS("E#","IDX"))="",$G(ASUMX("E#","IDX"))]"" S ASUMS("E#","IDX")=ASUMX("E#","IDX")
 Q:'$D(ASUMS("E#","IDX"))
 S:'$D(ASUS("ADD")) ASUS("ADD")=0
 S $P(ASUMS(0),U)=ASUMS("E#","IDX")
 S $P(ASUMS(0),U,2)=ASUMS("ESTB")
 S $P(ASUMS(0),U,3)=ASUMS("ORD#")
 S $P(ASUMS(0),U,4)=ASUMS("SRC")
 S $P(ASUMS(0),U,5)=ASUMS("LTM")
 S $P(ASUMS(0),U,6)=ASUMS("RPQ-O")
 S $P(ASUMS(0),U,7)=ASUMS("PMIQ")
 S $P(ASUMS(0),U,8)=ASUMS("RPQ")
 S $P(ASUMS(0),U,9)=ASUMS("EOQ","TB")
 S $P(ASUMS(0),U,10)=ASUMS("EOQ","MM")
 S $P(ASUMS(0),U,11)=ASUMS("EOQ","QM")
 S $P(ASUMS(0),U,12)=ASUMS("EOQ","AM")
 F ASUU(19)=1:1:4 D
 .Q:$E(ASUMS("EOQ","AM"),ASUU(19),ASUU(19))='0
 .S ASUMS("EOQ","AM")=$E(ASUMS("EOQ","AM"),1,ASUU(19)-1)_" "_$E(ASUMS("EOQ","AM"),ASUU(19)+1,$L(ASUMS("EOQ","AM")))
 S $P(ASUMS(0),U,13)=ASUMS("LSTISS")
 S $P(ASUMS(0),U,14)=ASUMS("VENAM")
 S $P(ASUMS(0),U,15)=+ASUMS("LPP")
 S $P(ASUMS(0),U,16)=ASUMS("VAL","O/H")
 S $P(ASUMS(0),U,17)=ASUMS("QTY","O/H")
 I ASUS("ADD")=1 G ASUN2
 S $P(ASUMS(0),U,18)=ASUMS("D/I","QTY",1)
 S $P(ASUMS(0),U,19)=ASUMS("D/I","VAL",1)
 S $P(ASUMS(0),U,20)=ASUMS("D/I","PO#",1)
 S $P(ASUMS(0),U,21)=ASUMS("D/I","DT",1)
 S $P(ASUMS(0),U,22)=ASUMS("D/I","SSA",1)
 S $P(ASUMS(0),U,23)=ASUMS("D/I","QTY",2)
 S $P(ASUMS(0),U,24)=ASUMS("D/I","VAL",2)
 S $P(ASUMS(0),U,25)=ASUMS("D/I","PO#",2)
 S $P(ASUMS(0),U,26)=ASUMS("D/I","DT",2)
 S $P(ASUMS(0),U,27)=ASUMS("D/I","SSA",2)
 S $P(ASUMS(0),U,28)=ASUMS("D/I","QTY",3)
 S $P(ASUMS(0),U,29)=ASUMS("D/I","VAL",3)
 S $P(ASUMS(0),U,30)=ASUMS("D/I","PO#",3)
 S $P(ASUMS(0),U,31)=ASUMS("D/I","DT",3)
 S $P(ASUMS(0),U,32)=ASUMS("D/I","SSA",3)
ASUN2 ;
 S $P(ASUMS(2),U)=ASUMS("SLC")
 S $P(ASUMS(2),U,2)=ASUMS("D/O","QTY")
 S $P(ASUMS(2),U,3)=ASUMS("VENUI")
 S $P(ASUMS(2),U,4)=ASUMS("SFSKM")
 S $P(ASUMS(2),U,5)=ASUMS("EOQ","TP")
 S $P(ASUMS(2),U,6)=ASUMS("SPQ")
 S $P(ASUMS(2),U,7)=ASUMS("VALBEG")
 S $P(ASUMS(2),U,8)=ASUMS("QTY-BEG")
 S $P(ASUMS(2),U,9)=ASUMS("D/I","DTR72",1)
 S $P(ASUMS(2),U,10)=ASUMS("D/I","DTR72",2)
 S $P(ASUMS(2),U,11)=ASUMS("D/I","DTR72",3)
ASUN3 ;
 S $P(ASUMS(3),U)=$G(ASUMS("R73","REM"))
 S $P(ASUMS(3),U,2)=$G(ASUMS("R73","PER"))
 S $P(ASUMS(3),U,3)=$G(ASUMS("R73","DT"))
 S $P(ASUMS(3),U,4)=$G(ASUMS("R13","TIMES"))
 S ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),0)=ASUMS(0)
 S ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),2)=ASUMS(2)
 S ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),3)=ASUMS(3)
 I ASUS("ADD")=0 K ASUS("ADD")
 Q
MIC ;EP SET STATION DEMAND DATA,(SUBSCRIPTED BY MONTH)
 I $D(ASUMS("E#","STA"))&($D(ASUMS("E#","IDX"))) D
 .S:'$D(ASUS("ADD")) ASUS("ADD")=0
 .F ASUV("MO")=1:1:12 D MMC
 .K ASUV("MO"),ASUMS("DMD",0)
 Q
MMC ;GET ONE MONTH
 S ASUMS("DMD",0)=""
 S $P(ASUMS("DMD",0),U)=ASUV("MO")
 S $P(ASUMS("DMD",0),U,2)=ASUMS("DMD","CALL",ASUV("MO"))
 S $P(ASUMS("DMD",0),U,3)=ASUMS("DMD","QTY",ASUV("MO"))
 S ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),1,ASUV("MO"),0)=ASUMS("DMD",0)
 S:ASUS("ADD") ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),1,"B",ASUV("MO"),ASUV("MO"))=""
 Q
MEXP ;
 N X
 K ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),4)
 S ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),4,0)="^9002031.244DA"
 I ASUMS("DXP")=0 S $P(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),4,0),U,3)=0 Q
 S Y=0
 F  S Y=$O(ASUMS("DXP",Y)) Q:Y=""  S ^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),4,$P(ASUMS("DXP",Y),U,2),0)=Y_U_$P(ASUMS("DXP",Y),U)
 Q
D ;EP; DELETE STATION MASTER
 ;Station Index record may be cleared of information
 S (ASUMS("E#","DEL"),DA)=ASUL(1,"AR","AP")_999999
 S $P(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),0),U)=ASUMS("E#","DEL")
 S $P(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),0),U,2)=$S($D(ASUT(ASUT,"DTEST")):ASUT(ASUT,"DTEST"),1:$E(ASUK("DT","YRMO")))
 S DIK="^ASUMS("_ASUL(2,"STA","E#")_",1,"        ;ASUL(2  is a constant
 S DA=ASUMS("E#","IDX"),DA(1)=ASUL(2,"STA","E#")
 D IX^DIK K DIK,DA
 Q