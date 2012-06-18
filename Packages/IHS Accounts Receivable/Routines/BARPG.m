BARPG ; IHS/SD/LSL - page formatting subroutines called by Synchronization] ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ;
PG ;EP **page controller 
 ; This utility uses variables BARHDR,BAR("DT"),BAR("LINE"),BAR("PG")
 ; kill variables by D EBARPG
 ;
 Q:($Y<(IOSL-6))!($G(DOUT)!$G(DFOUT))
 S:'$D(BAR("PG")) BAR("PG")=0
 S BAR("PG")=BAR("PG")+1
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0) Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
Q ;
 Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
HDR ;
 ; Write the Report Header
 W:$Y @IOF
 W !
 Q:'$D(BARHDR)
 S:'$D(BAR("LINE")) $P(BAR("LINE"),"-",IOM-2)=""
 S:'$D(BAR("PG")) BAR("PG")=1
 I '$D(BAR("DT")) D
 . S %H=$H
 . D YX^%DTC
 . S BAR("DT")=Y
 U IO
 W ?(IOM-$L(BARHDR)/2),BARHDR
 W !?(IOM-75),BAR("DT"),?(IOM-15),"PAGE: ",BAR("PG")
 W !,BAR("LINE")
 Q:'$D(BARDET)
 ;
COLUMNS ; EP
 ; Write column header / message
 W !?4,"Bill",?13,"Date of",?23,"Patient",?37,"A/R",?45,"3P"
 W ?50,$J("Amount",10),?63,$J("A/R Current",10),!
 W ?4,"Number",?13,"Service",?23,"Name",?37,"IEN"
 W ?45,"IEN",?50,$J("Billed",10),?63,$J("Balance",10)
 I ($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT)) S BARQUIT=1
 Q
 ; *********************************************************************
 ;
EBARPG ;
 K BAR("LINE"),BAR("PG"),BARHDR,BAR("DT")
 Q
 ; *********************************************************************
 ;
DOTS ; displaying of dots
 S BARDISP=BARDISP+1
 W:'(BARDISP#200) ".."
 Q
