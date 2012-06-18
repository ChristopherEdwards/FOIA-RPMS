ASURMBSP ; IHS/ITSC/LMH -PRINT BALANCE SHEETS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine formats and prints the Balance Sheet report
EN1 ;
 I '$D(DUZ(2)) W !,"Report must be run from Kernel option" Q
 I '$D(IO) D HOME^%ZIS
 D:'$D(U) ^XBKVAR
 D:'$D(ASUK("DT","FM")) DATE^ASUUDATE
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 S ASUK("PTRSEL")=$G(ASUK("PTRSEL"))
 I ASUK("PTRSEL")']"" D
 .S ZTRTN="PSER^ASUMBSP",ZTDESC="SAMS BALANCE SHEETS" D O^ASUUZIS
 .I POP S IOP=$I D ^%ZIS
 I '$D(ASUK(ASUK("PTR"),"Q")) Q
 I ASUK(ASUK("PTR"),"Q") Q
PSER ;EP;FOR TASKMAN QUEUE OF PRINT
 D U^ASUUZIS
 S ASUC("LN")=IOSL+1,ASUC("PG")=2
 D ASUMBSP1,ASUMBSP2 S ASUMC=3 D ASUMBSP3 S ASUMC=4 D ASUMBSP3
 K ASUX
 I ASUK("PTRSEL")]"" Q
 D C^ASUUZIS
 Q
EN2 ;EP ; SELECT DATE
 W !,"ENTER BALANCE SHEET DATE"
 D ASKDATE^ASUUDATE
 G EN1
ASUMBSP1 ;
 S ASUT="BAL"
 S ASUMC("ACC")=0,ASUX("TOT")=""
 D HDR1
 F  S ASUMC("ACC")=$O(^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),1,ASUMC("ACC"))) Q:ASUMC("ACC")'?1N.N  D
 .N X,Y
 .S X=^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),1,ASUMC("ACC"),0)
 .S ASUT(0)=$P(X,U,2)
 .S ASUT(0)=ASUT(0)_U_($P(X,U,3)+$P(X,U,4)+$P(X,U,5))
 .S ASUT(0)=ASUT(0)_U_($P(X,U,6)+$P(X,U,7)+$P(X,U,8))
 .S ASUT(0)=ASUT(0)_U_$P(X,U,9)
 .S ASUT(0)=ASUT(0)_U_$P(X,U,10)_U_$P(X,U,11)_U
 .F Y=1:1:4 S $P(ASUT(0),U,7)=$P(ASUT(0),U,7)+$P(ASUT(0),U,Y)
 .S $P(ASUT(0),U,7)=$P(ASUT(0),U,7)-$P(ASUT(0),U,5)
 .W !!,"125.",ASUMC("ACC")
 .N X F X=1:1:6 D
 ..S Y=$P(ASUT(0),U,X),Y=$S(Y']"":Y,Y=0:"",1:$J($FN(Y,"P,",2),12))
 ..W ?X*15,Y
 ..S $P(ASUX("TOT"),U,X)=$P(ASUX("TOT"),U,X)+$P(ASUT(0),U,X)
 .W:$P(ASUT(0),U,7)'=0 ?105,"**",$J($FN($P(ASUT(0),U,7),"P,",2),12),"OUTBAL**"
 D DASH
 W !,"TOTAL"
 F X=1:1:5 D
 .S Y=$P(ASUX("TOT"),U,X),Y=$S(Y']"":Y,1:$J($FN(Y,"P,",2),12))
 .W ?X*15,Y
 Q
HDR1 ;
 D CLS^ASUUHDG
 W "SAMS MONTHLY BALANCE SHEET -ACCOUNT BALANCES",?60,ASUK("DT","MONTH")," ",ASUK("DT","YEAR"),?100,"PAGE 1",!!
 W "ACCT#          OPENING BALANCE   RECEIPTS         ISSUES      ADJUSTMENTS  CLOSING BALANCE DIRECT ISSUES"
DASH ;
 W !,"_____            ____________   ____________   ____________   ____________   ____________   ____________",!!
 Q
ASUMBSP2 ;
 S (ASUMC("VOU"),ASUX("TOT"))=0,ASUC("LN")=ASUK(ASUK("PTR"),"IOSL")+1
 F  S ASUMC("VOU")=$O(^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),2,ASUMC("VOU"))) Q:ASUMC("VOU")'?1N.N  D
 .S ASUT(ASUT,"VOU")=$P(^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),2,ASUMC("VOU"),0),U)
 .S ASUC("LN")=ASUC("LN")+1 D:ASUC("LN")>ASUK(ASUK("PTR"),"IOSL") HDR2
 .W !,ASUT(ASUT,"VOU")
 .S Z=0
 .F X=1:1:5,9 D
 ..S Z=Z+1
 ..S ASUT(0)=$G(^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),2,ASUMC("VOU"),1,X,0))
 ..S Y=$J($FN($P(ASUT(0),U,2),",",2),12)
 ..W:Y'["0.00" ?Z*15,Y
 ..S $P(ASUX("TOT"),U,X)=$P(ASUX("TOT"),U,X)+$P(ASUT(0),U,2)
 D DASH2
 W !,"TOTAL"
 S Z=0
 F X=1:1:5,9 D
 .S Z=Z+1
 .S Y=$P(ASUX("TOT"),U,X),Y=$S(Y']"":Y,0=+Y:"",1:$J($FN(Y,",",2),12))
 .W ?Z*15,Y
 Q
HDR2 ;
 D CLS^ASUUHDG
 W "SAMS MONTHLY BALANCE SHEET - RECEIPT VOUCHERS",?60,ASUK("DT","MONTH")," ",ASUK("DT","YEAR"),?100,"PAGE ",ASUC("PG"),!!
 W "VOUCHER #           125.1          125.2          125.3          125.4          125.5          125.9"
 S ASUC("PG")=ASUC("PG")+1,ASUC("LN")=3
DASH2 ;
 W !,"____________     ____________   ____________   ____________   ____________   ____________   ____________",!!
 Q
ASUMBSP3 ;
 S (ASUMC("CAN"),ASUX("TOT"))=0,ASUC("LN")=ASUK(ASUK("PTR"),"IOSL")+1
 F  S ASUMC("CAN")=$O(^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),ASUMC,ASUMC("CAN"))) Q:ASUMC("CAN")'?1N.N  D
 .S ASUT(ASUT,"CAN")=$P(^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),ASUMC,ASUMC("CAN"),0),U)
 .S ASUC("LN")=ASUC("LN")+1 D:ASUC("LN")>ASUK(ASUK("PTR"),"IOSL") HDR3
 .W !,$S(ASUT(ASUT,"CAN")=" ":"UNKNOWN",1:ASUT(ASUT,"CAN"))
 .S Z=0,ASUX=0
 .F X=1:1:5,9 D
 ..S Z=Z+1
 ..S ASUT(0)=$G(^ASUMC(ASUL(2,"STA","E#"),1,ASUK("DT","FYM#"),ASUMC,ASUMC("CAN"),1,X,0))
 ..S Y=$J($FN($P(ASUT(0),U,2),"P,",2),12)
 ..W:Y'["0.00" ?Z*15,Y
 ..S $P(ASUX("TOT"),U,X)=$P(ASUX("TOT"),U,X)-$P(ASUT(0),U,2)
 ..S ASUX=ASUX-$P(ASUT(0),U,X)
 .W ?105,$J($FN(ASUX,"P,",2),12)
 D DASH3
 W !,"TOTAL"
 S Z=0,ASUX=0
 F X=1:1:5,9 D
 .S Z=Z+1
 .S Y=$P(ASUX("TOT"),U,X),Y=$S(Y']"":Y,Y=0:"",1:$J($FN(Y,",",2),12))
 .W:Z'="0.00" ?Z*15,Y
 .S ASUX=ASUX+$P(ASUX("TOT"),U,X)
 W ?105,$J($FN(ASUX,",",2),12)
 Q
HDR3 ;
 D CLS^ASUUHDG
 W "SAMS MONTHLY BALANCE SHEET -",$S(ASUMC=3:"ISS",1:"DIR")," CANS ",?60,ASUK("DT","MONTH")," ",ASUK("DT","YEAR"),?100,"PAGE ",ASUC("PG"),!!
 W "CAN NUMBER          125.1          125.2          125.3          125.4          125.5          125.9        TOTAL"
 S ASUC("PG")=ASUC("PG")+1,ASUC("LN")=3
DASH3 ;
 W !,"____________     ____________   ____________   ____________   ____________   ____________   ____________   ____________",!!
 Q
