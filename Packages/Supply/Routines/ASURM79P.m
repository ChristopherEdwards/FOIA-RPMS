ASURM79P ; IHS/ITSC/LMH -PRINT S.A.M.S. REPORT 79 ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine formats and prints report 79 Analysis of Issues 
 ;to Program.
 ;^XTMP("ASUR","R79",AREA/STA,PROGRAM,SUB STATION,USER,ACCOUNT)
 ;*********************************************************************
EN ;EP;PRIMARY ENTRY POINT FOR REPORT 79
 Q  ;WAR 5/21/99
 I '$D(IO) D HOME^%ZIS
 I '$D(DUZ(2)) W !,"Report must be run from Kernel option" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 S ASUK("PTRSEL")=$G(ASUK("PTRSEL"))
 I ASUK("PTRSEL")]"" G PSER
 S ZTRTN="PSER^ASURM79P",ZTDESC="SAMS RPT 79" D O^ASUUZIS
 I POP S IOP=$I D ^%ZIS Q
 I ASUK(ASUK("PTR"),"Q") Q
PSER ;EP;FOR TASKMAN QUEUE OF PRINT
 D:'$D(^XTMP("ASUR","R79")) CMPT
 D U^ASUUZIS
 D SETHEADR ;Set header values
 F  S ASUX("ARST")=$O(^XTMP("ASUR","R79",$G(ASUX("ARST")))) Q:ASUX("ARST")=""  D  Q:$D(DUOUT)
 .F  D INITPGM S ASUX("PGM")=$O(^XTMP("ASUR","R79",ASUX("ARST"),$G(ASUX("PGM")))) Q:ASUX("PGM")=""  D HEADER Q:$D(DUOUT)  D  Q:$D(DUOUT)
 ..F  D NEWPAGE Q:$D(DUOUT)  D INITSST S ASUX("SST")=$O(^XTMP("ASUR","R79",ASUX("ARST"),ASUX("PGM"),$G(ASUX("SST")))) Q:ASUX("SST")=""  D  Q:$D(DUOUT)
 ...D SST^ASULDIRR(ASUX("SST"))
 ...W !,ASUL(18,"SST")," - ",ASUL(18,"SST","NM")
 ...F  D INITUSR D NEWPAGE Q:$D(DUOUT)  S ASUX("USR")=$O(^XTMP("ASUR","R79",ASUX("ARST"),ASUX("PGM"),ASUX("SST"),$G(ASUX("USR")))) Q:ASUX("USR")=""  D  Q:$D(DUOUT)
 ....S ASUX("REQ")=ASUX("SST")_$E(ASUX("USR"),3,6)
 ....D USR^ASULDIRR(ASUX("USR")),REQ^ASULDIRR(ASUX("REQ"))
 ....W !,ASUL(20,"REQ")," - ",ASUL(19,"USR","NM")
 ....F  D NEWPAGE Q:$D(DUOUT)  S ASUX("ACC")=$O(^XTMP("ASUR","R79",ASUX("ARST"),ASUX("PGM"),ASUX("SST"),ASUX("USR"),$G(ASUX("ACC")))) Q:ASUX("ACC")=""  S ASUX("DTA")=^(ASUX("ACC")) D NEWPAGE Q:$D(DUOUT)  W !?4,$$ACC(ASUX("ACC")) D SETDATA
 ....D NEWPAGE Q:$D(DUOUT)  W !?4,"USER TOT:"
 ....D OUT("USR")
 ....W ! Q
 ...D NEWPAGE Q:$D(DUOUT)  W !,"SUB-STA TOT:"
 ...F ASUU(1)=0:0 S ASUU(1)=$O(ASUX("SST",ASUU(1))) Q:'ASUU(1)  I ASUX("SST",ASUU(1))]"" F ASUU(2)=1:1:13 S ASUX("SS",ASUU(2))=$P(ASUX("SST",ASUU(1)),U,ASUU(2)) I ASUU(2)=13 D  Q:$D(DUOUT)
 ....D NEWPAGE Q:$D(DUOUT)  W !?4,$$ACC(ASUU(1))
 ....D OUT("SS")
 ...D NEWPAGE Q:$D(DUOUT)  W !,"SUB ST TOT:"
 ...D OUT("SSU")
 ...W !!!!
 ..D NEWPAGE Q:$D(DUOUT)  W !,"PROGRAM TOT:"
 ..F ASUU(1)=0:0 S ASUU(1)=$O(ASUX("PGM",ASUU(1))) Q:'ASUU(1)  I ASUX("PGM",ASUU(1))]"" F ASUU(2)=1:1:13 S ASUX("US1",ASUU(2))=$P(ASUX("PGM",ASUU(1)),U,ASUU(2)) I ASUU(2)=13 D  Q:$D(DUOUT)
 ...D NEWPAGE Q:$D(DUOUT)  W !?4,$$ACC(ASUU(1))
 ...D OUT("US1")
 ..D NEWPAGE Q:$D(DUOUT)  W !,"PROGRAM TOT:"
 ..D OUT("PGU")
 ..W !
 D PAZ^ASUURHDR W @IOF D:$G(ASUK("PTRSEL"))']"" ^%ZISC ;Run output then quit
 K ASUR,ASUX,POP,Y,ASUU,ASUC
 F X=3:1:22 K ASUL(X) ;Clear Table Lookup fields
 I $G(ASUK("PTRSEL"))']"" K ASUK
 Q
NEWPAGE ;FF
 I $Y+4>IOSL D HEADER
 Q
INITSST ;Initialize counters for sub-station totals 1 and 2
 ;1,2,3,4,5,9 are accounts used by S.A.M.S.
 F ASUU(0)=1,2,3,4,5,9 S ASUX("SST",ASUU(0))=""
 K ASUX("SSU")
 Q
INITPGM ;Initialize counters for program totals 1 and 2
 F ASUU(0)=1,2,3,4,5,9 S ASUX("PGM",ASUU(0))=""
 K ASUX("PGU")
 Q
INITUSR ;Initialize counters for program totals 1 and 2
 F ASUU(0)=1:1:13 S ASUX("USR",ASUU(0))=""
 K ASUX("US1")
 Q
ACC(X) ;Write account -extrinsic
 S X=$S(X=1:"DRUGS",X=2:"MEDICA",X=3:"SUBSIS",X=4:"LABORA",X=5:"OF/ADM",X=9:"OTHER",1:"NF")
 Q X
SETHEADR ;Set hdrs
 ;Hdr1
 S ASU1(1)=" STOCK  ISSUE   VALUE ",ASU1(2)=" DIRECT  ISSUE  VALUE ",ASU1(3)=" TOTAL ISSUE VALUE ",ASU1(4)="  STOCK LINE ITEMS  ",ASU1(5)="DIRECT  ISS",ASU1(6)=" STOCK",ASU1(7)="DIRECT"
 ;Hdr2
 S ASU2(1)="CM",ASU2(2)="Y-T-D",ASU2(3)="CM",ASU2(4)="Y-T-D",ASU2(5)="CM",ASU2(6)="Y-T-D",ASU2(7)="CM    Y-T-D  %OUT",ASU2(8)="LINE  ITEMS",ASU2(9)="IS DOC",ASU2(10)="IS DOC"
 ;Hdr3
 S ASU3(1)="CM  Y-T-D",ASU3(2)="Y-T-D",ASU3(3)="Y-T-D"
 Q
HEADER ;Print hdr
 I ($D(ASUK("DT"))#10)'=1 D DATE^ASUUDATE
 S ASUX("PG")=$G(ASUX("PG"))+1 D:ASUX("PG")>1 PAZ^ASUURHDR Q:$D(DUOUT)  W @IOF
 W !,"REPORT # 79 SUMMARY OF ISSUES TO PROGRAM",?60,ASUK("DT"),?120,"PAGE ",ASUX("PG"),!,"AREA NAME: ",ASUL(1,"AR","NM")
 ;Hdr1
 D PGM^ASULDIRR(ASUX("PGM"))
 W !,"PROGRAM ",ASUL(22,"PGM")," - ",ASUL(22,"PGM","NM"),!!!,"SUB-STA",?13,ASU1(1),?36,ASU1(2),?60,ASU1(3),?82,ASU1(4),?104,ASU1(5),?118,ASU1(6),?126,ASU1(7)
 ;Hdr2
 W !?2,"USER",?20,ASU2(1),?29,ASU2(2),?41,ASU2(3),?52,ASU2(4),?65,ASU2(5),?73,ASU2(6),?84,"REQUESTED",?104,ASU2(8),?118,ASU2(9),?126,ASU2(10)
 ;Hdr3
 W !?4,"ACCNT",?84,ASU2(7),?106,ASU3(1),?119,ASU3(2),?127,ASU3(3)
 S:'$D(ASUR("LN")) $P(ASUR("LN"),"=",131)="=" W !!,ASUR("LN")
 Q
SETDATA ;Set DATA line
 S ASUX("FLD",1)=$FN($P(ASUX("DTA"),U,2),"",0)
 S ASUX("FLD",2)=$FN($P(ASUX("DTA"),U,3),"",0)
 S ASUX("FLD",3)=$FN($P(ASUX("DTA"),U,5),"",0)
 S ASUX("FLD",4)=$FN($P(ASUX("DTA"),U,6),"",0)
 S ASUX("FLD",5)=$FN(($P(ASUX("DTA"),U,2)+$P(ASUX("DTA"),U,5)),"",0)
 S ASUX("FLD",6)=$FN(($P(ASUX("DTA"),U,3)+$P(ASUX("DTA"),U,6)),"",0)
 S ASUX("FLD",7)=$FN(($P(ASUX("DTA"),U,7)+$P(ASUX("DTA"),U,11)),"",0)
 S ASUX("FLD",8)=$FN(($P(ASUX("DTA"),U,8)+$P(ASUX("DTA"),U,12)),"",0)
 I +$P(ASUX("DTA"),U,8)>0 D
 .S X=($P(ASUX("DTA"),U,15)/+$P(ASUX("DTA"),U,8))*100
 .S ASUX("FLD",9)=$FN(X,"",0)
 E  D
 .S ASUX("FLD",9)=0
 S ASUX("FLD",10)=$FN($P(ASUX("DTA"),U,19),"",0)
 S ASUX("FLD",11)=$FN($P(ASUX("DTA"),U,20),"",0)
 S ASUX("FLD",12)=$FN(($P(ASUX("DTA"),U,10)+$P(ASUX("DTA"),U,14)),"",0)
 S ASUX("FLD",13)=$FN($P(ASUX("DTA"),U,22),"",0)
 ;
UT ;Set user totals
 F ASUU(0)=1:1:13 S ASUX("USR",ASUU(0))=$G(ASUX("USR",ASUU(0)))+ASUX("FLD",ASUU(0))
 ;
SST ;Set totals for sub-stations
 F ASUU(0)=1:1:13 S $P(ASUX("SST",ASUX("ACC")),U,ASUU(0))=$P($G(ASUX("SST",ASUX("ACC"))),U,ASUU(0))+ASUX("FLD",ASUU(0))
 F ASUU(0)=1:1:13 S ASUX("SSU",ASUU(0))=$G(ASUX("SSU",ASUU(0)))+ASUX("FLD",ASUU(0))
 ;
PT ;Set program totals
 F ASUU(0)=1:1:13 S $P(ASUX("PGM",ASUX("ACC")),U,ASUU(0))=$P($G(ASUX("PGM",ASUX("ACC"))),U,ASUU(0))+ASUX("FLD",ASUU(0))
 F ASUU(0)=1:1:13 S ASUX("PGU",ASUU(0))=$G(ASUX("PGU",ASUU(0)))+ASUX("FLD",ASUU(0))
 ;
 ;Print data line
 D OUT("FLD")
 Q
 ;
OUT(X) ;EP; -Print Data line and subtotals for user/sub-station/program
 ;Formal parameter is X (NAME OF COUNTER)
 ;Actual parameter will be 1 of the following:
 ;"USR" for user total
 ;"SS" for sub-station total
 ;"SSU" for 2nd sub-station total in form of user total
 ;"PGM" for program total
 ;"PGU" for 2nd program total in form of user total
 ;"FLD" for data line
 W ?15,$J($FN(ASUX(X,1),","),7)
 W ?25,$J($FN(ASUX(X,2),","),9)
 W ?36,$J($FN(ASUX(X,3),","),7)
 W ?48,$J($FN(ASUX(X,4),","),9)
 W ?60,$J($FN(ASUX(X,5),","),7)
 W ?70,$J($FN(ASUX(X,6),","),9)
 W ?82,$J($FN(ASUX(X,7),","),4)
 W ?89,$J($FN(ASUX(X,8),","),6)
 W ?97,$J(ASUX(X,9),4,1)
 W ?103,$J($FN(ASUX(X,10),","),5)
 W ?108,$J($FN(ASUX(X,11),","),7)
 W ?118,$J($FN(ASUX(X,12),","),6)
 W ?126,$J($FN(ASUX(X,13),","),6)
 Q
CMPT ;EP ;SORT
 K ^XTMP("ASUR","R79")
 S ^XTMP("ASUR","R79",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 F ASUMY("E#","REQ")=0:0 S ASUMY("E#","REQ")=$O(^ASUMY(ASUMY("E#","REQ"))) Q:ASUMY("E#","REQ")'?1N.N  D
 .F ASUMY("E#","SSA")=0:0 S ASUMY("E#","SSA")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"))) Q:ASUMY("E#","SSA")'?1N.N  D
 ..F ASUMY("E#","ACC")=0:0 S ASUMY("E#","ACC")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"))) Q:ASUMY("E#","ACC")'?1N.N  D
 ...K ASUF("OK")
 ...D READ^ASUMYDIO
 ...F ASUU(0)=1:1:22 I $P(ASUMY(0),U,ASUU(0)) S ASUF("OK")=1
 ...Q:'$D(ASUF("OK"))
 ...S ASUX("SST")=$E(ASUMY("E#","REQ"),1,5),ASUX("USR")=ASUL(1,"AR","AP")_$E(ASUMY("E#","REQ"),6,9)
 ...S ASUMY=$G(^XTMP("ASUR","R79","*",ASUMY("E#","PGM"),ASUX("SST"),ASUX("USR"),ASUMY("E#","ACC"))) D
 ....I ASUMY="" S ASUMY=ASUMY(0) Q
 ....F ASUX=1:1:22 S $P(ASUMY,U,ASUX)=$P(ASUMY,U,ASUX)+$P(ASUMY(0),U,ASUX)
 ...S ^XTMP("ASUR","R79","*",ASUMY("E#","PGM"),ASUX("SST"),ASUX("USR"),ASUMY("E#","ACC"))=U_ASUMY
 K ASUX,ASUMY,ASU1,ASU2,ASU3,ASUF("OK")
 I $G(ASUP("TYP"))="" K ASUK,ASUW
 Q
