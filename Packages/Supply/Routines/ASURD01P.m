ASURD01P ; IHS/ITSC/LMH -TRANS COUNTS REPORT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine formats and prints report 1 from sorted extracts.
EN ;EP;PRIMARY ENTRY POINT FOR REPORT 01
 ; JDH
 I '$D(IO) D HOME^%ZIS
 I '$D(DUZ(2)) W !,"Report must be run from Kernel option" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 S ASUK("PTRSEL")=$G(ASUK("PTRSEL")) I ASUK("PTRSEL")]"" G PSER
 S ZTRTN="PSER^ASURD01P",ZTDESC="SAMS RPT 01" D O^ASUUZIS
 I POP S IOP=$I D ^%ZIS Q
 I ASUK(ASUK("PTR"),"Q") Q
PSER ;EP;FOR TASKMAN QUEUE OF PRINT
 ; JDH
 D U^ASUUZIS
 I ($D(ASUK("DT"))#10)=0 D ^ASUUDATE
 ;N X,Y S (X,Y)=$P(^XTMP("ASUR","R01",0),U,2) I Y'=ASUK("DT","FM") D SETDT^ASUUDATE(X)
 ; JDH N X,Y S (X,Y)=$P(^XTMP("ASUR01",0),U,2) I Y'=ASUK("DT","FM") D SETDT^ASUUDATE(X)
 D HEADER
 S ASUR("TR")="",ASUV("TY")=""
 F  S ASUR("TR")=$O(^XTMP("ASUR","R01",3,ASUR("TR"))) Q:ASUR("TR")']""  D
 .D TRN^ASULARST(ASUR("TR"))
 .I ASUL(11,"TRN","TYPE")'=ASUV("TY") D
 ..I $G(ASUC(1))]"" W !?50,"_______",?60,"_______",?70,"_______",!?33,"SUB TOT:",?50,$J($FN($P(ASUC(1),U,1),",",0),7),?60,$J($FN($P(ASUC(1),U,2),",",0),7),?70,$J($FN($P(ASUC(1),U,3),",",0),7)
 ..F X=1:1:3 S $P(ASUC(2),U,X)=$P($G(ASUC(2)),U,X)+$P($G(ASUC(1)),U,X)
 ..K ASUC(1)
 ..W !!?2,ASUL(11,"TRN","TYPN") S ASUV("TY")=ASUL(11,"TRN","TYPE")
 .E  D
 ..W !
 .W ?14,ASUL(11,"TRN","DBCR"),?22,ASUL(11,"TRN","EXTN")," ",$S(ASUL(11,"TRN","REV")=1:"REVERSAL",1:"")
 .S ASUC(0)=$P($G(^XTMP("ASUR","R01",1,ASUR("TR"))),U,2)_U_$P($G(^XTMP("ASUR","R01",2,ASUR("TR"))),U,2)_U_$P($G(^XTMP("ASUR","R01",3,ASUR("TR"))),U,2)
 .W ?50,$J($FN($P(ASUC(0),U,1),",",0),7),?60,$J($FN($P(ASUC(0),U,2),",",0),7),?70,$J($FN($P(ASUC(0),U,3),",",0),7)
 .F X=1:1:3 S $P(ASUC(1),U,X)=$P($G(ASUC(1)),U,X)+$P($G(ASUC(0)),U,X)
 I $G(ASUC(1))]"" W !?50,"_______",?60,"_______",?70,"_______",!?33,"SUB TOT:",?50,$J($FN($P(ASUC(1),U,1),",",0),7),?60,$J($FN($P(ASUC(1),U,2),",",0),7),?70,$J($FN($P(ASUC(1),U,3),",",0),7)
 F X=1:1:3 S $P(ASUC(2),U,X)=$P($G(ASUC(2)),U,X)+$P($G(ASUC(1)),U,X)
 W !!?50,"_______",?60,"_______",?70,"_______",!?30,"TOTAL:",?50,$J($FN($P($G(ASUC(2)),U,1),",",0),7),?60,$J($FN($P($G(ASUC(2)),U,2),",",0),7),?70,$J($FN($P($G(ASUC(2)),U,3),",",0),7)
 D PAZ^ASUURHDR
 K ASUX("E#"),ASUR,ASUR,ASUTR,ASUT,ASUC
 K DA,ASUX(0),DI,DIC,DIE,DQ,DR,X
 I $G(ASUK("PTRSEL"))]"" W @IOF Q
 D C^ASUUZIS
 Q
HEADER ;
 S ASUC("PG")=$G(ASUC("PG"))+1
 D CLS^ASUUHDG
 W !?2,"REPORT #1.    TRANSACTION COUNTS",?50,"DATE: ",ASUK("DT","MO"),"/",ASUK("DT","DA"),"/",ASUK("DT","YR"),?65,"PAGE: ",ASUC("PG")
 W !?2,"TYPE",?13,"Db/Cr",?21,"TRANSACTION",?54,"DAILY   MONTHLY  YR TO DT",!?54,"COUNT     COUNT     COUNT"
 W !,"-------------------------------------------------------------------------------",!!
 Q
