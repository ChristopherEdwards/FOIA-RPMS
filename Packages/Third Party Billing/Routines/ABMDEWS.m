ABMDEWS ; IHS/ASDST/DMJ - Print Worksheets ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ; Original;TMD;
 ;
 I '$D(IO)!'$D(IOF)!'$D(IOST) S IOP="HOME" D ^%ZIS
 K ABM,ABMP,ABMD,ABMM
 ;
 W !!,"PRINT WORKSHEET FOR:"
 K DIR
 S DIR(0)="SO^1:SELECTIVE CLAIMS;2:ALL CLAIMS FOR AN EXPORT DATE"
 S DIR("A")="Select Desired Option"
 D ^DIR
 K DIR
 G XIT:$D(DIROUT)!$D(DIRUT)
 S ABMP("DO")=$S(Y=1:"MULT^ABMDEDIC",1:"BATCH")
 D @ABMP("DO")
 G XIT:$D(DTOUT)!$D(DUOUT)!'$D(ABMM)
 ;
 W !!?10,"(NOTE: Standard plain paper needs to be loaded in the printer.)"
 ;
 S ABMP("PG")=0
 S ABMP("HEAD2")="WORKSHEET DATA"
 S ABMP("WORKSHEET")=""
 ;
ZIS ;
 W !!
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="QP"
 S %ZIS("B")=""
 D ^%ZIS
 G:POP XIT
 I '$D(IO("Q")) G BEGIN W !!,"JOB MUST BE QUEUED" G ZIS
 ;
QUE ;
 K IO("Q")
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G ZIS
 S ZTRTN="ENT^ABMDEWS"
 S ZTDESC="3P BILLING CLAIM DATA DETAILED DISPLAY"
 F ABM="ZTRTN","ZTDESC","ABMM(" S ZTSAVE(ABM)=""
 D ^%ZTLOAD
 ;
TSK ;
 I $D(ZTSK) W !,"(Job Queued, Task Number: ",ZTSK,")"
 D ^%ZISC
 G XIT
 ;
ENT ;TaskMan Entry Point
 S ABMD("QUEON")=""
 ;
BEGIN ;
 U IO
 S ABMM=""
 F  S ABMM=$O(ABMM(ABMM)) Q:'ABMM  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 . S ABMP("CDFN")=ABMM
 . S ABMP("SCRN")=1
 . S ABMP("RTN")="^ABMDE1"
 . S ABMD("CTR")=0
 . S ABMP("DDL")=""
 . S ABMP("WORKSHEET")=1
 . S ABMP("GL")="^ABMPCLM("_ABMP("CDFN")_","
 . S ABMP("PDFN")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,1),ABMP("VTYP")=$P(^(0),"^",7),ABMM("NINS")=$P(^(0),"^",8)
 . S ABMM("OINS")=0
 . S (ABM,ABM("OI"))=0
 . F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM)) Q:'ABM  D  Q:ABMM("OINS")
 . . S ABM("I")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,0))
 . . S ABM("S")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("I"),0)),U,3)
 . . I ABM("S")="I",ABM("OI"),ABMM("NINS")'=ABM("OI") D  Q
 . . . S ABMM("OINS")=ABM("OI")
 . . . S ABMM("CDFN")=ABMP("CDFN")
 . . S ABM("OI")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("I"),0),U)
 . I ABMM("OINS") D  Q:$D(ABM("DIE-FAIL"))
 . . S DIE="^ABMDCLM(DUZ(2),"
 . . S DA=ABMP("CDFN")
 . . S DR=".08////"_ABMM("OINS")
 . . D ^ABMDDIE
 . D ^ABMDEVAR
 . D SCRN^ABMDE
 . I ABMM("OINS") D  Q:$D(ABM("DIE-FAIL"))
 . . S DIE="^ABMDCLM(DUZ(2),"
 . . S DA=ABMM("CDFN")
 . . S DR=".08////"_ABMM("NINS")
 . . D ^ABMDDIE
 . I $E(IOST)="C",'$D(IO("S")),'$D(ABMD("QUEON")),'$D(DUOUT),'$D(DTOUT),'$D(DIRUT) K DIR S DIR(0)="E" D ^DIR K DIR
 I $E(IOST)'="C" W $$EN^ABMVDF("IOF")
 D ^%ZISC
 ;
XIT ;
 K ABMM,ABMP,ABM,ABMD,POP,ZTSK,DIRUT,DTOUT,IO("Q"),DIR,DIRUT,DIQ
 Q
 ;
BATCH ;
 W !!
 K DIC
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="QEAM"
 S DIC("A")="Select EXPORT BATCH (Date): "
 D ^DIC
 Q:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G BATCH
 S ABM=""
 F  S ABM=$O(^ABMDBILL(DUZ(2),"AX",+Y,ABM)) Q:'ABM  D
 . S ABM("C")=+^ABMDBILL(DUZ(2),ABM,0)
 . I $D(^ABMDCLM(DUZ(2),ABM("C"),0)) S ABMM(ABM("C"))=""
 K DIC
 ;
END Q
