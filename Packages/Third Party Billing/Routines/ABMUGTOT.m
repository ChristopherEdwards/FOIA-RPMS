ABMUGTOT ; IHS/SD/SDR - 3PB/UFMS Grand Total Report only   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ; New routine - v2.5 p15
 ;
START ;START HERE
 ; Find the requested UFMS export batch in the UFMS export file.
 ;
BEG ;
 ; Find beginning export batch
 S ABMTRIBL=$P($G(^ABMDPARM(DUZ(2),1,4)),U,14)
 W !
 K DIC,DIE,X,Y,DA
 S DIC="^ABMUTXMT("
 S DIC(0)="AEMQ"
 S DIC("A")="Select beginning export: "
 S ABMSCRND=$P($G(^ABMDPARM(DUZ(2),1,4)),U,16)  ;only show limited entries
 S DIC("S")="S X1=DT,X2=$P(^ABMUTXMT(Y,0),U) D ^%DTC I X<ABMSCRND"
 D ^DIC
 Q:Y<0
 S ABME("XMITB")=+Y
 ;
END ;
 ; Find ending export batch
 W !
 S DIC("A")="Select ending export: "
 D ^DIC
 K DIC
 Q:Y<0
 S ABME("XMITE")=+Y
 I ABME("XMITE")<ABME("XMITB") W !!,"INVALID RANGE!" G BEG
 ;
SUMDET ;summary or detail?
 S ABMSUMDT="G"
 K ABMSAV
 ;
SEL ;
 ; Select device
 S %ZIS="NQ"
 S %ZIS("A")="Enter DEVICE: "
 D ^%ZIS Q:POP
 I IO'=IO(0) D QUE^ABMUVBCH,HOME^%ZIS S DIR(0)="E" D ^DIR K DIR Q
 I $D(IO("S")) S IOP=ION D ^%ZIS
PRINT ;EP
 ; Callable point for queuing
 S ABME("PG")=0
 S ABMP("XMIT")=ABME("XMITB")-1
 D SET^ABMUVBCH  Q:(IOST["C")&(($G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 W !!,$$EN^ABMVDF("HIN"),"E N D   O F   R E P O R T",$$EN^ABMVDF("HIF"),!
 I $E(IOST)="C" S DIR(0)="E" D ^DIR K DIR
 I $E(IOST)="P" W $$EN^ABMVDF("IOF")
 I $D(IO("S")) D ^%ZISC
 K ABME
 Q
