ASUV0NT ; IHS/ASDST/WAR -INVTR INITIALIZE INVENTORY ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;4.2T1;SUPPLY ACCOUNTING MGMT SYSTEM;;JAN 28, 2000
 ;This routine initializes the Physical Inventory Master (in ^ASUMV) for
 ;an account after verifying there is no current inventory active for
 ;that account. The Physical Inventory Master contains information from
 ;the Station Master (in ^ASUMS) concerning quantity and value at the
 ;beginning of an inventory.  Once the Physical Inventory Master is
 ;initialized, a Physical Inventory can be conducted at the same time
 ;items are being issued from the account.  It in effect 'freezes' the
 ;inventory information from the Station master for the items of that
 ;account.
 D:'$D(DT) ^XBKVAR
 D:$G(ASUK("DT","FM"))']"" DATE^ASUUDATE
 S ASUV("DT")=ASUK("DT","FM")
 D CLS^ASUUHDG
 I $G(ASUL(2,"STA","E#"))']"" D STA I $D(DTOUT)!($D(DUOUT)) G EXIT
 S DIC("A")="CREATE AN INVENTORY MASTER FILE FOR WHAT ACCOUNT? "
 S DIC="9002039.09",DIC(0)="AMEZQ"
 D ^DIC K DIC
 I $D(DTOUT)!($D(DUOUT)) G EXIT
 I Y>0 D
 .S ASUMV("ACC")=$P(Y,U),ASUMV("E#","ASA")=ASUL(2,"STA","E#")_ASUMV("ACC")
 .D ACC^ASULDIRF(ASUMV("ACC"))
 E  G EXIT
 G:ASUMV("E#","ASA")="" EXIT
 S ASUMS("E#","STA")=$O(^ASUMS("B",ASUL(2,"STA","E#"),""))  ;;CHG 3/13/95 CSC
 Q:ASUMS("E#","STA")'?1N.N
 I $D(^ASUMV(ASUMV("E#","ASA"),0)) D
 .D ACCOUNT^ASUV9IMR
 .I ASUMV("MODE")=4 D
 ..D REPACCT^ASUV9IMW
 .E  D
 ..W !!,"YOU HAVE REQUESTED AN PHYSICAL INVENTORY BE INITIALIZED, BUT AN"
 ..W !,"INVENTORY IS ALREADY ACTIVE FOR ACCOUNT ",ASUMV("ACC")," ",ASUL(9,"ACC","NM")
 ..W !,"THE STATUS OF THAT INVENTORY IS ",$S(ASUMV("MODE")=0:"INITIALIZED",ASUMV("MODE")=1:"INITIAL COUNT",ASUMV("MODE")=2:"RE-COUNT",ASUMV("MODE")=3:"RESEARCH",1:"COMPLETE")," MODE",!
 ..S DIR("A")="DO YOU WANT TO CANCEL THE CURRENT INVENTORY AND START AGAIN"
 ..S DIR(0)="Y",DIR("B")="N"
 ..S DIR("?")="Answer 'Y' to cancel the inventory or 'N' end the Inventory file Initialzation"
 ..D ^DIR K DIR
 ..Q:$D(DUOUT)  Q:$D(DTOUT)
 ..I Y=0 S DUOUT=1 Q
 ..W !!,"WARNING! THIS WILL CAUSE ALL COUNTS TO BE LOST FOR THE CURRENT INVENTORY!",!!
 ..S DIR("A")="ARE YOU SURE YOU WANT TO CANCEL THE CURRENT INVENTORY"
 ..S DIR(0)="Y",DIR("B")="N"
 ..D ^DIR K DIR
 ..Q:$D(DUOUT)  Q:$D(DTOUT)
 ..I Y=0 S DUOUT=1 Q
 ..D REPACCT^ASUV9IMW
 E  D
 .D NEWACCT^ASUV9IMW
 G:$D(DUOUT)!($D(DTOUT)) EXIT
 W !
 S DIR("A")="ENTER A VOUCHER NUMBER FOR THE INVENTORY ADJUSTMENTS"
 S DIR(0)="F^8:8^D VOU^ASUJVALF(.X,.DDSERROR)"
 S DIR("?")="Voucher Number must be 8 numeric digits, not all zeors in format FYMMNNNN"
 D ^DIR K DIR
 I $D(DUOUT)!($D(DTOUT)) D DELACCT^ASUV9IMW G EXIT
 S ASUR("VOU")=X
 S ASUMV("VOU")=ASUR("VOU")
 S ASUMV("MODE")=0
 D ACCOUNT^ASUV9IMW
 ;D ASUV0NT1
ASUV0NT1 ;
 S ASUMS("E#","STA")=$O(^ASUMS("B",ASUL(2,"STA","E#"),""))  ;;CHG 3/13/95 CSC
 Q:ASUMS("E#","STA")'?1N.N
 S (ASUC("ITEMS"),ASUMS("E#","IDX"))=0
 F  S ASUMS("E#","IDX")=$O(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"))) Q:((ASUMS("E#","IDX")'?1N.N)!(ASUMS("E#","IDX")[999999))  D
 .S (ASUMV("IDX"),ASUMX("E#","IDX"))=ASUMS("E#","IDX") D READ^ASUMXDIO
 .; ** LMH 6/15/00 QUIT IF INDEX MSTR. HAS BEEN DELETED **
 .Q:ASUMX("IDX")[999999!(ASUMX("IDX")="")
 .Q:'$D(ASUMX("ACC"))
 .Q:ASUMV("ACC")'=ASUMX("ACC")
 .S ASUC("ITEMS")=ASUC("ITEMS")+1
 .S ASUMV("E#","INDX")=ASUMX("IDX") D ^ASUMSTRD
 .Q:$G(ASUMS("DEL"))]""
 .S:ASUMS("SLC")=""!(ASUMS("SLC")=" ") ASUMS("SLC")="W"
 .S ASUMV("E#","SLC")=$O(^ASUL(10,"B",ASUMS("SLC"),""))
 .D NEWSLC^ASUV9IMW
 .S ASUMV("STA")=ASUMS("E#","STA")
 .I ASUMS("QTY","O/H")>0,ASUMS("VAL","O/H")>0 D
 ..S ASUMV("U/C")=$FN(ASUMS("VAL","O/H")/ASUMS("QTY","O/H"),"",2)
 .E  D
 ..S ASUMV("U/C")=ASUMS("LPP")
 .S ASUMV("QTY","STAM")=ASUMS("QTY","O/H")
 .I ASUMV("QTY","STAM")=""!(ASUMV("QTY","STAM")=" ") S ASUMV("QTY","STAM")=0
 .D NEWIDX^ASUV9IMW
 I ASUC("ITEMS") D
 .S ASUMV("E#","SLC")=""
 .F  S ASUMV("E#","SLC")=$O(^ASUMV(ASUMV("E#","ASA"),1,"B",ASUMV("E#","SLC"))) Q:ASUMV("E#","SLC")']""  D XREF^ASUV9IMW
 .W !!,ASUC("ITEMS")," ITEMS SCHEDULED FOR PHYSICAL INVENTORY FOR ACCOUNT ",ASUMV("ACC")," ",ASUL(9,"ACC","NM")
 .W !!,"NOW PRINT REPORT 37, 'PHYSICAL INVENTORY LIST' TO BEGIN THE INVENTORY",!!
 E  D
 .W !!,"NO ITEMS FOUND FOR ACCOUNT ",ASUMV("ACC")," ",ASUL(9,"ACC","NM"),!
 S DIR(0)="E" D ^DIR K DIR
 ;Q
 K DIK,DA
EXIT ;
 K ASUC("TR"),ASUMV,ASUMX,ASUMS,ASUR,ASUV
 K DTOUT,DUOUT,DIC,X,Y,X2
 K ASUL(3),ASUL(5),ASUL(6),ASUL(8),ASUL(9),ASUL(10)
 Q
STA ;EP ;
 D:'$D(DT) ^XBKVAR
 D:$G(ASUK("DT","FM"))']"" DATE^ASUUDATE
 D:$G(ASUL(1,"AR","AP"))']"" SETAREA^ASULARST
 S ASUV("DT")=ASUK("DT","FM")
 W !!
 S DIC("A")="PROCESS INVENTORY FOR WHAT STATION? "
 S DIC="9002039.02",DIC(0)="AMEZQ"
 D ^DIC K DIC
 I $D(DTOUT)!($D(DUOUT)) Q
 I Y>0 D
 .S ASUL(2,"STA","E#")=+Y
 .S X=ASUL(1,"AR","AP"),X1=$P(Y,U,1) D STAT^ASULARST
 .S ASUL(2,"STA","E#")=ASUL(1,"AR","AP")_"0"_ASUL(2,"STA","CD")
 .W ?30,ASUL(2,"STA","NM")
 E  S DUOUT=1
 W !
 Q
