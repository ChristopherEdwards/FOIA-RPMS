ASURO26B ; IHS/ITSC/LMH - WAREHOUSE BIN LABEL REPORT 26B ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine prints report #26 Warehouse Bin labels
 Q  ;WAR 5/21/99
 D B0 I '$D(ASUR("26B")) D KIL Q
 ;
 ;Kill line variables
 K ASU1(1),ASU1(2),ASU1(3),ASUR(4)
 ;
 K %ZIS,IOP,IO("Q") S %ZIS="QM" D ^%ZIS I POP W !,"No device selected or report queued." G KIL
 I $D(IO("Q")) K IO("Q") S ZTIO=ION K ZTSAVE,ZTDTH,ZTSK S ZTRTN="QUE^ASURO26B",ZTSAVE("DUZ*")="",ZTSAVE("ASUR(""HEAD"")")="",ZTSAVE("ASURO26B(")="",ZTDTH=$H D ^%ZTLOAD W !,"Queued" G KIL
 ;
QUE ;EP; for task man
 ;Go build ^XTMP("ASUR","R26B"
 D EN1
 D KIL U IO
 W !!,"REPORT N0. 26B WAREHOUSE BIN LABELS"
 W !,ASUR("HEAD"),!!!
 ;Run output then quit
 S ASUC=0
 F  S ASURD(1)=$O(^XTMP("ASUR","R26B",$G(ASURD(1)))) Q:ASURD(1)=""  D
 .F  S ASURD(2)=$O(^XTMP("ASUR","R26B",ASURD(1),$G(ASURD(2)))) Q:ASURD(2)=""  D
 ..F  S ASURD(3)=$O(^XTMP("ASUR","R26B",ASURD(1),ASURD(2),$G(ASURD(3)))) Q:ASURD(3)=""  D
 ...F  S ASURD(4)=$O(^XTMP("ASUR","R26B",ASURD(1),ASURD(2),ASURD(3),$G(ASURD(4)))) Q:ASURD(4)=""  D
 ....F  S ASURD(5)=$O(^XTMP("ASUR","R26B",ASURD(1),ASURD(2),ASURD(3),ASURD(4),$G(ASURD(5)))) Q:ASURD(5)=""  S ASUR("26B","DATA")=^(ASURD(5)) S ASUC=ASUC+1 D B3
 I $D(ASU1(1)),$D(ASU1(2)),$D(ASU1(3)) D PL
 D KIL,PAZ^ASUURHDR,^%ZISC
 Q
PL ;Print out label
 ;
 ;LINE 1
 W !,"INDEX # ",$P(ASU1(1),U,2),?25,"SLC: ",$P(ASU1(1),U,3)
 W ?42,"INDEX # ",$P(ASU1(1),U,4),?67,"SLC: ",$P(ASU1(1),U,5)
 W ?82,"INDEX # ",$P(ASU1(1),U,6),?107,"SLC: ",$P(ASU1(1),U,7)
 ;
 ;LINE 2
 W !,"UNIT OF ISS: ",$J($P(ASU1(2),U,2),2),?25,"RPQ: ",$P(ASU1(2),U,3)
 W ?42,"UNIT OF ISS: ",$P(ASU1(2),U,4),?67,"RPQ: ",$P(ASU1(2),U,5)
 W ?82,"UNIT OF ISS: ",$P(ASU1(2),U,6),?107,"RPQ: ",$P(ASU1(2),U,7)
 ;
 ;LINE 3
 W !,"DESC: ",$P(ASU1(3),U,2),?42,"DESC: ",$P(ASU1(3),U,3),?82,"DESC: ",$P(ASU1(3),U,4)
 ;
 ;LINE 4
 W !?6,$P(ASUR(4),U,2),?48,$P(ASUR(4),U,3),?88,$P(ASUR(4),U,4),!!
 Q
KIL ;Kill variables
 K ASURD,ASUR("26B"),ASUC
 Q
B3 ;Build 3 labels accross
 ;Label stock is designed to print 3 across. This is hard coded in
 ;and if the stock changes, the code must be changed
 S ASU1(1)=$G(ASU1(1))_U_ASURD(5)_U_ASURD(4)
 S ASU1(2)=$G(ASU1(2))_U_$P(ASUR("26B","DATA"),U)_U_$P(ASUR("26B","DATA"),U,4)
 S ASU1(3)=$G(ASU1(3))_U_$P(ASUR("26B","DATA"),U,2)
 S ASUR(4)=$G(ASUR(4))_U_$P(ASUR("26B","DATA"),U,3)
 I ASUC=3 D PL S ASUC=0 K ASUR Q
 Q
B0 ;
 K ^XTMP("ASUR","R26B"),ASUR
 S ^XTMP("ASUR","R26B",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 S DIR("A")="Print WareHouse Bin Labels for"
 S DIR(0)="S^1:ACCOUNT 1;3:ACCOUNT 3;5:ALL OTHER ACCOUNTS;7:STORAGE LOCATION CODES;9:ALL BIN LABELS^S ASUR(""26B"",""ASK"")=Y"
 D ^DIR I $D(DIRUT)!($D(DIROUT))!(X="^") D KILL Q
 S ASUR("HEAD")=$S(Y=1:"ACCOUNT 1",Y=3:"ACCOUNT 3",Y=5:"ALL OTHER ACCOUNTS",1:"ALL BIN LABELS")
 ;
 I ASUR("26B","ASK")=7 D
 .S DIC=9002039.1,DIC(0)="AEQZ",DIC("A")="SELECT STORAGE LOCATION CODE : "  D ^DIC I Y<0 D KILL Q
 .S ASUR("26B","ASK")=$P(Y(0),U),ASUR("HEAD")="SLC: "_$P(Y(0),U)
 Q
EN1 ;EP Entry to build ^XTMP("ASUR","R26B"
 F ASUMS("E#","STA")=0:0 S ASUMS("E#","STA")=$O(^ASUMS(ASUMS("E#","STA"))) Q:'ASUMS("E#","STA")  D
 .F ASUMS("E#","IDX")=0:0 S ASUMS("E#","IDX")=$O(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"))) Q:'ASUMS("E#","IDX")  D
 ..D ^ASUMSTRD Q:ASUF("DLIDX")=1
 ..D ARE^ASULARST(ASUMS("AR"))
 ..D STA^ASULARST(ASUMS("STA"))
 ..D IDX^ASUMXDIO(ASUMS("E#","IDX")) S ASUR("IDX")=$E(ASUMX("IDX"),1,5)_"."_$E(ASUMX("IDX"),6)
 ..D ACC^ASULDIRF(ASUMX("ACC"))
 ..I ASUR("26B","ASK")=9 D SORT Q
 ..I ASUR("26B","ASK")=ASUMX("ACC") D SORT Q
 ..I ASUR("26B","ASK")=ASUMS("SLC") D SORT Q
KILL ;
 K ASUR("26B")
 Q
SORT ;Build sort global
 S X=ASUMX("AR U/I")_U_ASUMX("DESC",1)_U_ASUMX("DESC",2)_U_ASUMS("RPQ")
 S:ASUMS("SLC")']"" ASUMS("SLC")=" "
 S ^XTMP("ASUR","R26B",ASUL(1,"AR","AP")_"-"_ASUL(1,"AR","NM"),ASUL(2,"STA","CD")_"-"_ASUL(2,"STA","NM"),ASUMX("ACC"),ASUMS("SLC"),ASUR("IDX"))=X
 Q
