ABMDLBL ; IHS/ASDST/DMJ - Print Selected Insurer Labels ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
SEL ;
 K ABM
 S (ABM("TM"),ABM("LM"))=0
 ;
 W !!,"PRINT MAILING LABELS FOR:"
 K DIR
 S DIR(0)="SO^1:SELECTIVE INSURERS;2:ALL INSURERS FOR AN EXPORT BATCH"
 S DIR("A")="Select Desired Option"
 D ^DIR
 K DIR
 G XIT:$D(DIROUT)!$D(DIRUT)
 S ABM("DO")=$S(Y=1:"SELI",1:"SELB")
 D @ABM("DO")
 I '$D(ABM("INS")) G XIT
 ;
 W !
 K DIR
 S DIR(0)="NO^1:50"
 S DIR("A")="Enter Desired Number of Labels Printed Per Insurer"
 S DIR("B")=1
 D ^DIR
 K DIR
 G XIT:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABM("COPIES")=Y
 ;
 W !
 K DIR
 S DIR(0)="NO^4:8"
 S DIR("A")="Enter the Number of Lines per Label"
 S DIR("B")=6
 D ^DIR
 K DIR
 G XIT:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABM("LINES")=Y
 ;
 W !!?15,"(NOTE: Mailing Labels need to be loaded in the printer.)"
 ;
ZIS ;
 W !!
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="QP"
 S %ZIS("B")=""
 D ^%ZIS
 G:POP XIT
 I '$D(IO("Q")) D ^ABMDLBLA G LBL
 ;
QUE2 ;
 K IO("Q")
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G ZIS
 S ZTRTN="ENT^ABMDLBL"
 S ZTDESC="3P Print of Insurer Labels."
 F ABM="ABM(" S ZTSAVE(ABM)=""
 D ^%ZTLOAD
 G SEL
 ;
ENT ;EP - Entry Point for Taskman
 S ABM("Q")=""
 ;
LBL ;
 I '$D(IO("S")) U IO
 E  X ABM("OPEN")
 ;
MARG ;
 S ABM("LM")=$P($G(^ABMDPARM(DUZ(2),1,0)),"^",11),ABM("TM")=$P(^(0),"^",12)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM=1:1:ABM("TM") W !
 ;
GET ;Loop through ABM("INS") array
 S (ABM("I"),ABM("J"))=0
 F  S ABM("I")=$O(ABM("INS",ABM("I"))) Q:ABM("I")=""  D
 . F ABM("K")=1:1 S ABM("J")=$O(ABM("INS",ABM("I"),ABM("J"))) Q:'ABM("J")  D BADDR^ABMDLBL1,PRNT
 I IO'=IO(0)!$D(IO("S")) W $$EN^ABMVDF("IOF")
 D ^%ZISC
 I '$D(ABM("Q")) G SEL
 D:$D(ZTQUEUED) KILL^%ZTLOAD
 ;
XIT ;
 K ABM
 Q
 ;
PRNT ;
 I $D(ABM("IP",ABM("I"))),ABM("IP",ABM("I"))#20'=0,ABM("I")'["NON-BENEFICIARY PATIENT" Q
 S ABM("IP",ABM("I"))=ABM("K")
 F ABM("C")=1:1:ABM("COPIES") F ABM("L")=1:1:ABM("LINES")+1 W !?ABM("LM"),$P(ABM("ADD"),U,ABM("L"))
 Q
 ;
SELI ;
 K DIC
 S ABM("C")=0
 S DIC="^AUTNINS("
 S DIC(0)="QEAM"
 W !
 F ABM=1:1 D  Q:X=""!$D(DUOUT)!$D(DTOUT)
 . W !
SELO . S ABM("E")=$E(ABM,$L(ABM))
 . S DIC("A")="Select "_ABM_$S(ABM>3&(ABM<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" INSURER: "
 . S DIC(0)="QEAM"
 . D ^DIC
 . Q:X=""!$D(DUOUT)!$D(DTOUT)
 . I +Y<1 G SELO
 . S ABM("INS",$P(^AUTNINS(+Y,0),U)_"-"_+Y,1)=""
 K DIC
 Q
 ;
SELB ;
 W !
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Print Labels for all EXPORT BATCHES that havn't been Previously Printed"
 S DIR("B")="N"
 S DIR("?")="Answer 'YES' if it is desired to print mailing labels for those Insurers associated with the Export Batches that labels have not been previously printed."
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 G SELBE:'Y
 S ABM("M")=0
 F  S ABM("M")=$O(^ABMDTXST(DUZ(2),"AM",1,ABM("M"))) Q:'ABM("M")  D
 . S (DA,ABM("BAT"))=ABM("M")
 . S DIE="^ABMDTXST(DUZ(2),"
 . S DR=".07///@"
 . D ^ABMDDIE,BATCH
 Q
 ;
SELBE ;
 W !!
 K DIC
 S ABM("C")=0
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="QEAM"
 S ABM("M")=1
 ;
SELBO ;
 S ABM("E")=$E(ABM("M"),$L(ABM("M")))
 S DIC("A")="Select "_ABM("M")_$S(ABM("M")>3&(ABM("M")<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" EXPORT BATCH (NUMBER or DATE): "
 D ^DIC
 Q:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G SELBO
 S ABM("M")=ABM("M")+1
 S ABM("BAT")=+Y
 D BATCH
 G SELBO
 ;
BATCH ;LOOP THROUGH EXPORT BATCH
 S ABM("NBP")=$O(^AUTNINS("B","NON-BENEFICIARY PATIENT",0))
 S ABM=""
 F  S ABM=$O(^ABMDBILL(DUZ(2),"AX",ABM("BAT"),ABM)) Q:'ABM  D
 . S ABM("I")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,8)
 . I $D(^AUTNINS(ABM("I"),0)) D
 . . S ABM("INS",$P(^AUTNINS(ABM("I"),0),U)_"-"_ABM("I"),ABM)=$S(ABM("NBP")=ABM("I"):$P(^ABMDBILL(DUZ(2),ABM,0),"^",5),1:"")
 Q
