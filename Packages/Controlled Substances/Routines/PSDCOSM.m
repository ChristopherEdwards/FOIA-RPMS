PSDCOSM ;BIR/LTL-Send MM about 0$ in DRUG file (#50), PSDCOST (cont'd) ; 9 Nov 93
 ;;3.0; CONTROLLED SUBSTANCES ;**17**;13 Feb 97
 K PSD,PSDM,PSDN D KILL^XM
 S XMSUB="DRUG file cost missing",XMDUZ=PSDCHO(1)_" messenger" D XMZ^XMA2
 I XMZ<1 D KILL^XM Q
 S XMY(DUZ)=""
 S PSD(1)=$S($P($G(^VA(200,DUZ,.1)),U,4)]"":$P($G(^(.1)),U,4),1:$P($P($G(^VA(200,DUZ,0)),U),",",2))_", when you ran the "_PSDCHO(1)_" on "_PSDT(1)_","
 ;
 ;DAVE B (PSD*3*17 29APR99) - more detailed report
 S PSD(2)="either the PRICE PER DISPENSE UNIT from the DRUG file (#50), or the quantity"
 S PSD(3)="recorded for the transaction, had a value of zero for the drug(s) listed below:"
 S PSD(4)=" "
 S $P(PSD(5)," ",65)="Price"
 S $P(PSD(6)," ",65)="Per"
 S $P(PSD(7)," ",52)="Transaction  Disp."
 S PSD(8)="Drug Name                     Date/Time            Number       Unit    Qnty"
 S $P(PSD(9),"-",79)=""
 S PSDM=0,PSDN=10
 ;
LP ;Loop through temporary global
 S PSDM=$O(^TMP("PSDM",$J,PSDM)) G DONE:PSDM="" K DATE
DT S DATE=$S('$D(DATE):$O(^TMP("PSDM",$J,PSDM,0)),1:$O(^TMP("PSDM",$J,PSDM,DATE))) G LP:DATE="" S DATA=^TMP("PSDM",$J,PSDM,DATE)
 S XX=$E(PSDM,1,29),XXX=XX F X=$L(XX):1:29 S XXX=XXX_" "
 S XXX=XXX_DATE_$J($P(DATA,"^",1),10)_$J($P(DATA,"^",2),8,2)_$J($P(DATA,"^",3),8)
 S PSD(PSDN)=XXX,PSDN=PSDN+1,PSD(PSDN)=" ",PSDN=PSDN+1 G DT
 ;
DONE ;
 S XMTEXT="PSD(" D ^XMD,KILL^XM Q
