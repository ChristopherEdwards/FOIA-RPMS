ABMDRFEE ; IHS/ASDST/DMJ - REPORT OF 3P FEE SCHEDULES ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 S U="^"
FEE W ! K DIC S DIC="^ABMDFEE(",DIC(0)="QEAM",DIC("A")="Select FEE SCHEDULE: " S:$P($G(^ABMDPARM(DUZ(2),1,0)),U,9)]"" DIC("B")=$P(^(0),U,9) D ^DIC
 G XIT:$D(DUOUT)!$D(DTOUT)
 I +Y<1 G FEE
 S ABM("FEE")=+Y,ABM("NM")=$P(^ABMDFEE(+Y,0),U,2)
SEL W !!,"======== FEE SCHEDULE CATEGORIES ========",!
 K DIR S (ABM("S"),DIR(0))="SO^1:MEDICAL;2:SURGICAL-ANESTHESIA;3:RADIOLOGY;4:LABORATORY",DIR("A")="Select Desired CATEGORY" D ^DIR
 G XIT:$D(DIROUT)!$D(DIRUT)
 S ABM("CAT")=+Y,ABM("S")=$P($P($P(ABM("S"),U,2),";",+Y),":",2)
 ;
W1 W !!,"NOTE: Report requires 132 Width Export Format!",! S %ZIS="Q",%ZIS("B")="",%ZIS("A")="Output DEVICE: " D ^%ZIS G:'$D(IO)!$G(POP) XIT
 D ^ABMDR16
 S ABM("IOP")=ION_";132;"_IOSL G:$D(IO("Q")) QUE
 I IO'=IO(0),$E(IOST)'="C",'$D(IO("S")),$P($G(^ABMDPARM(DUZ(2),1,0)),U,13)="Y" W !!,"As specified in the 3P Site Parameters File FORCED QUEUEING is in effect!",! G QUE
PRQUE ;EP - Entry Point for Taskman
 G ^ABMDRFE1
 ;
XIT D ^%ZISC K ABM
 Q
 ;
QUE S ZTRTN="PRQUE^ABMDRFEE",ZTDESC="REPORT OF 3P FEE SCHEDULES"
 D QUE^ABMDRUTL
 G XIT
