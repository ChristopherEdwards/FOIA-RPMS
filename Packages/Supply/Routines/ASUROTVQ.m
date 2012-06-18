ASUROTVQ ; IHS/ITSC/LMH -HIGH VAL/QTY ITEM PRINT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine selects Index items which have had the highest value
 ;total of issues or quantity of issues and prints a list in order
 ;from highest to lowest for a number of items selected.
 Q  ;WAR 5/21/99
 D ^XBCLS D:'$D(ASUK) ^ASUVAR D:'$D(U) ^XBKVAR D:'$D(IO) HOME^%ZIS
 I '$D(^XTMP("ASUTVQ")) D  G:$D(DUOUT)!($D(DTOUT)) END
 .W "NO DATA EXTRACTED FOR HIGH VALUE / QUANTITY ITEMS REPORT"
 .D TVQ0
 E  D  G:$D(DUOUT)!($D(DTOUT)) END
 .N DIR
 .S DIR(0)="Y",DIR("A")="Do you want to use data from last report" D ^DIR
 .Q:Y
 .D TVQ0
 S X=$G(^XTMP("ASUTVQ")) G:X']"" END
 S ASUU("DTFR")=$P(X,U),ASUU("DTFRDS")=$P(X,U,2),ASUU("DTTO")=$P(X,U,3),ASUU("DTTODS")=$P(X,U,4)
 S ASUU("ACC")=$P(X,U,5),ASUU("ACC","NM")=$P(X,U,6)
 K X
 S ASUL(1,"AR","NM")=$G(ASUL(1,"AR","NM"))
 I ASUL(1,"AR","NM")']"" K ASUL(1,"AR","AP") D AREA^ASULARST
 S ASUL(1,"AR","NM")=$G(ASUL(1,"AR","NM"))
 I ASUL(1,"AR","NM")']"" W !,"Unable to determine Area Name" Q
 W !!,"You may also choose how many high Value and Quantity items will be on the list",!
 S ASUU("TOP")=20
 K DIR S DIR(0)="N",DIR("A")="Enter Item Count: ",DIR("B")=ASUU("TOP") D ^DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 S ASUU("TOP")=+Y
 D O^ASUUZIS
 Q:$D(DTOUT)  Q:$D(DUOUT)
 D U^ASUUZIS
 S ASUU("TYPE")="VAL",ASUC("LN")=IOSL+1 D LOOP
 S ASUU("TYPE")="QTY",ASUC("LN")=IOSL+1 D LOOP
 S ASUU("TYPE")="DEL",ASUU("TOP")=99999,ASUC("LN")=IOSL+1 D LOOP
 G END
LOOP ;
 S (ASUHDA,ASUU("IDX"))=""
 S ASUC("PG")=1,ASUU("HIGH")="",ASUU(1)=1,ASUU("QUIT")=0
 F  S ASUU("HIGH")=$O(^XTMP("ASUTVQ",ASUU("TYPE"),ASUU("HIGH"))) D LOOP2 Q:ASUU("QUIT")
 Q
LOOP2 ;
 I ASUU("HIGH")']"" S ASUU("QUIT")=1 Q
 I ASUU(1)>ASUU("TOP") S ASUU("QUIT")=1 Q
 S ASUU("IDX")=""
 F ASUU(1)=ASUU(1):1 S ASUU("IDX")=$O(^XTMP("ASUTVQ",ASUU("TYPE"),ASUU("HIGH"),ASUU("IDX")))  Q:ASUU("IDX")']""  Q:ASUU(1)>ASUU("TOP")  D
 .I ASUU(1)>ASUU("TOP") S ASUU("QUIT")=1 Q
 .I ASUC("LN")>ASUK(ASUK("PTR"),"IOSL") D
 ..W @ASUK(ASUK("PTR"),"IOF")
 ..W !,"SAMS LISTING OF TOP ",$S(ASUU("TYPE")="DEL":"ALL ITEMS WHICH HAVE BEEN DELETED",1:ASUU("TOP")_" ITEMS BY "_ASUU("TYPE"))," FOR ACCOUNT ",ASUU("ACC","NM"),?72,"PAGE: ",ASUC("PG")
 ..W !?10,"FOR REGIONAL SUPPLY SERVICE CENTER -",ASUL(1,"AR","NM")
 ..W !?10,"FOR DATE RANGE FROM ",ASUU("DTFRDS")," TO ",ASUU("DTTODS")
 ..S ASUC("LN")=0,ASUC("PG")=ASUC("PG")+1
 .S ASUHDA=$O(^ASUMX("B",ASUU("IDX"),""))
 .I ASUHDA']"" D  Q
 ..Q:ASUU("TYPE")="DEL"
 ..S ^XTMP("ASUTVQ","DEL",1,ASUU("IDX"))=^XTMP("ASUTVQ",ASUU("TYPE"),ASUU("HIGH"),ASUU("IDX"))
 ..S ASUU(1)=ASUU(1) Q
 .S ASUV("DESC1")=$P(^ASUMX(ASUHDA,0),U,2)
 .S ASUV("DESC2")=$P(^ASUMX(ASUHDA,0),U,3)
 .S ASUV("U/I")=$P(^ASUMX(ASUHDA,0),U,4)
 .S ASUV("ACC")=$P(^XTMP("ASUTVQ",ASUU("IDX")),U,3)
 .S ASUV("QTY")=$P(^XTMP("ASUTVQ",ASUU("IDX")),U,2)
 .S ASUV("VAL2")=$P(^XTMP("ASUTVQ",ASUU("IDX")),U)
 .S ASUC("LN")=ASUC("LN")+3
 .I ASUU("TYPE")="DEL" D
 ..W !,"INDEX: ",$E(ASUU("IDX"),1,5),".",$E(ASUU("IDX"),6),?16,"QTY: ",$J(ASUV("QTY"),8)
 ..W ?35,"VALUE: ",$J($FN(ASUV("VAL2"),",",2),15),?72,"ACC: ",ASUV("ACC")
 .E  D
 ..W !!,"NO.: ",ASUU(1),?10,ASUV("DESC1")," ",ASUV("DESC2"),?72,"U/I: ",ASUV("U/I")
 ..W !,"INDEX: ",$E(ASUU("IDX"),1,5),".",$E(ASUU("IDX"),6),?16,"QTY: ",$J(ASUV("QTY"),8)
 ..W ?35,"VALUE: ",$J($FN(ASUV("VAL2"),",",2),15),?72,"ACC: ",ASUV("ACC")
 Q
TVQ0 ;
 D ^XBCLS D:'$D(U) ^XBKVAR D:'$D(IO) HOME^%ZIS K ^XTMP("ASUTVQ") S ^XTMP("ASUTVQ",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 S (Y,ASUU("DT"))=2911001 X ^DD("DD") S ASUU("DTFRDS")=Y
 W !!,"The Top Value and Quantity report is created for either all accounts ",!,"or for a selected account and by a Date Range",!
 K DIR S DIR(0)="Y",DIR("B")="N",DIR("A")="Do you want the report for all Accounts" D ^DIR
 I X="Y" D
 .S ASUU("ACC")="A",ASUU("ACC","NM")="ALL"
 E  D
 .K DIR S DIR(0)="P^9002039.09",DIR("A")="Enter Account: ",DIR("B")=1 D ^DIR
 .Q:$D(DTOUT)  Q:$D(DUOUT)
 .S ASUU("ACC")=$P(Y,U,2),ASUU("ACC","NM")=$P($G(^ASUL(9,+Y,0)),U,3)
 W !!,"You now need to select the Date Range for the Report.",!
 K DIR S DIR(0)="D",DIR("A")="Enter Starting Date: ",DIR("B")=ASUU("DTFRDS") D ^DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 S (ASUU("DT"),ASUU("DTFR"))=Y X ^DD("DD") S ASUU("DTFRDS")=Y
 S (Y,ASUU("DTTO"))=ASUU("DTFR")+10000 X ^DD("DD") S ASUU("DTTODS")=Y
 K DIR S DIR(0)="D",DIR("A")="Enter Ending Date: ",DIR("B")=ASUU("DTTODS") D ^DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 S ASUU("DTTO")=Y X ^DD("DD") S ASUU("DTTODS")=Y
 I ASUU("DTTO")']ASUU("DTFR") W !,"The ending date you selected is not after the beginning date" Q
 W !,"EXTRACT DATE RANGE = ",ASUU("DTFR")," THROUGH ",ASUU("DTTO")
 S ^XTMP("ASUTVQ")=ASUU("DTFR")_U_ASUU("DTFRDS")_U_ASUU("DTTO")_U_ASUU("DTTODS")_U_ASUU("ACC")_U_ASUU("ACC","NM")
 F ASUC=0:1 S ASUU("DT")=$O(^ASUT(3,"AX",ASUU("DT"))) Q:ASUU("DT")>ASUU("DTTO")  Q:ASUU("DT")']""  D
 .W !,"NOW PROCESSING EXTRACT DATE: ",ASUU("DT")
 .S ASUHDA="",ASUC("ACC")=0
 .F ASUU(0)=0:1 S ASUHDA=$O(^ASUT(3,"AX",ASUU("DT"),ASUHDA)) Q:ASUHDA']""  D
 ..D READ^ASU0TRRD(.ASUHDA,"H") Q:$G(ASUT)']""
 ..I ASUU("ACC")'="A",ASUT(ASUT,"ACC")'=ASUU("ACC") Q
 ..S ASUC("ACC")=ASUC("ACC")+1
 ..S ASUV("TVAL")=$P($G(^XTMP("ASUTVQ",ASUT(ASUT,"IDX"))),U)+ASUT(ASUT,"VAL")
 ..S ASUV("TQTY")=$P($G(^XTMP("ASUTVQ",ASUT(ASUT,"IDX"))),U,2)+ASUT(ASUT,"QTY","ISS")
 ..S ^XTMP("ASUTVQ",ASUT(ASUT,"IDX"))=ASUV("TVAL")_U_ASUV("TQTY")_U_ASUT(ASUT,"ACC")
 .W !,"PROCESSED: ",ASUU(0)," ISSUES "
 .W:ASUU("ACC")'="A" ASUC("ACC")," OF WHICH WERE FOR ACCOUNT ",ASUU("ACC","NM")
 I ASUC=0 W !,"NO DATA PROCESSED IN SELECTED DATE RANGE",! G END
XREF ;   
 I '$D(^XTMP("ASUTVQ")) W "NO DATA EXTRACTED FOR HIGH VALUE / QUANTITY ITEMS REPORT" G END
 S X=^XTMP("ASUTVQ"),ASUU("DTFR")=$P(X,U),ASUU("DTFRDS")=$P(X,U,2),ASUU("DTTO")=$P(X,U,3),ASUU("DTTODS")=$P(X,U,4),ASUU("ACC")=$P(X,U,5),ASUU("ACC","NM")=$P(X,U,6)
 S ASUU("IDX")=""
 F  S ASUU("IDX")=$O(^XTMP("ASUTVQ",ASUU("IDX"))) Q:ASUU("IDX")'?1N.N  D
 .S ASUU("VALRV")=$S($P(^XTMP("ASUTVQ",ASUU("IDX")),U)'>0:1,1:1/$P(^XTMP("ASUTVQ",ASUU("IDX")),U))
 .S ASUU("QTYRV")=$S($P(^XTMP("ASUTVQ",ASUU("IDX")),U,2)'>0:1,1:1/$P(^XTMP("ASUTVQ",ASUU("IDX")),U,2))
 .S ^XTMP("ASUTVQ","QTY",ASUU("QTYRV"),ASUU("IDX"))=""
 .S ^XTMP("ASUTVQ","VAL",ASUU("VALRV"),ASUU("IDX"))=""
END ;
 D:$D(ASUK("PTR")) C^ASUUZIS
 K ASUC,ASU,ASUR,ASUV,ASUK
 Q
