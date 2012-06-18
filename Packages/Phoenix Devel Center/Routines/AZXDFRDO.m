ABMDFRDO ; IHS/ASDST/DMJ - Re-Print Selected Bills ;    [ 10/11/2002  10:54 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**2**;APR 05, 2002
 ;Original;TMD;02/21/96 12:13 PM
 ;
 ; IHS/ASDS/LSL - 06/29/00 - V2.4 Patch 2 - NOIS XAA-0600-200091 V2.4
 ;     Modified to allow reprint of new export modes (13,15,17)
 ;
 ; IHS/ASDS/LSL - 05/04/01 - V2.4 Patch 5 - NOIS HQW-0401-100014
 ;     Modified to allow reprint of all new electronic exports for
 ;     UB-92's and HCFA-1500's regardless of when they are added.
 ;     Check UB's only once in code instead of 3 times.
 ;
 K ABMY,ABMP
 S ABMP("XMIT")=0
 S ABMY("TOT")="0^0^0"
 W !!,"Re-Print Bills for:"
 K DIR
 S DIR(0)="SO^1:SELECTIVE BILL(S);2:ALL BILLS FOR AN EXPORT BATCH;3:UNPAID BILLS"
 S DIR("A")="Select Desired Option"
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT),SEL:Y=1,UNPD:Y=3
 ;
BATCH ;
 W !
 K DIC
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("A")="Select EXPORT BATCH (Date): "
 D ^DIC
 K DIC("A")
 G XIT:X=""!$D(DTOUT)!$D(DUOUT),BATCH:+Y<1
 S (ABMY("BATCH"),ABMP("XMIT"))=+Y
 I $P(^ABMDTXST(DUZ(2),+Y,0),U,2) S ABMY("FORM")=$P(^(0),U,2)_U_$P($G(^ABMDEXP($P(^(0),U,2),0)),U)
 E  S ABMY("FORM")=$S($P(^ABMDTXST(DUZ(2),ABMY("BATCH"),0),U,2)="U":1,1:2)_U_$S($P(^(0),U,2)="U":"UB-82",1:"HCFA-1500A")
 G ZIS
 ;
SEL ;
 W !!
 K DIC
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="QZEAM"
 S ABMY=$G(ABMY)+1
 S ABM("E")=$E(ABMY,$L(ABMY))
 S DIC("A")="Select "_ABMY_$S(ABMY>3&(ABMY<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" BILL to Re-Print: "
 S DIC("S")="I $P(^(0),U)'=+^(0),""BTCP""[$P(^(0),""^"",4),$P(^(0),""^"",6)"
 S:ABMY>1 DIC("S")=DIC("S")_",$P(ABMY(""FORM""),""^"",1)[$P(^(0),""^"",6)"
 D BENT^ABMDBDIC
 G XIT:$D(DUOUT)!$D(DTOUT)
 I '$G(ABMP("BDFN")) G ZIS:ABMY>1,XIT
 D CKMULT
 I '$G(ABMP("BDFN")) S ABMY=ABMY-1 G SEL
 S ABMY(ABMP("BDFN"))=""
 G SEL:ABMY>1
 S ABMY("FORM")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6)_U_$P($G(^ABMDEXP($P(^(0),U,6),0)),U)
 G SEL
 ;
UNPD ;UN-PAID BILLS
 D ^ABMDBRUN
 S ABMY("TOT")="0^0^0"
 W !!,"For the parameters specified, the"
 W !,"           Number of Bills to Reprint: ",ABMP("CNT")
 I '$O(ABMY(0)) W *7 G XIT
 ;
ZIS ;
 S:$P(ABMY("FORM"),U,2)["UB-92-E" ABMY("FORM")="11^UB-92"
 S:$P(ABMY("FORM"),U,2)["HCFA-1500-E" ABMY("FORM")="14^HCFA-1500 Y2K"
 I +ABMY("FORM")=2,$P($G(^ABMDPARM(DUZ(2),1,2)),9)=2 D  G XIT:$D(DIRUT)
 .W !!,"Forms Previously Printed on Old HCFA-1500.",!!
 .K DIR
 .S DIR(0)="Y"
 .S DIR("B")="Y"
 .S DIR("A")="Want to print the New Version of the HCFA-1500 (Y/N)"
 .D ^DIR
 .I Y S ABMY("FORM")=3_U_$P(^ABMDEXP(3,0),U)
 S ABMP("EXP")=+ABMY("FORM")
 W !!?15,"(NOTE: "
 I $P($G(^ABMDEXP(ABMP("EXP"),1)),U,4) W "Plain Paper needs"
 E  W $P(ABMY("FORM"),U,2)," forms need"
 W " to be loaded in the printer.)"
 W !!
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="NPQ"
 S %ZIS("B")=""
 D ^%ZIS
 G XIT:POP
 I IO'=IO(0) D QUE2,HOME^%ZIS Q
 I $D(IOPAR) S %ZIS("IOPAR")=IOPAR
 U IO(0)
 ;W !!,"Printing..."  ;*** TESTING - AEF *** COMMENTED OUT AND REPLACED BY LINE BELOW
 I $E(IOST)="C" W !!,"Printing..." ;*** TESTING - AEF *** WRITE ONLY TO A TERMINAL SCREEN
 S IOP=ION
 D ^%ZIS
 G ENT
 ;
QUE2 ;
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G ZIS
 S ZTRTN="TSK^ABMDFRDO"
 S ZTDESC="3P Re-Print of Selective Bill."
 F ABM="ZTRTN","ZTDESC","ABMP(","ABMY(" S ZTSAVE(ABM)=""
 D ^%ZTLOAD
 I $D(ZTSK) W !,"(Job Queued, Task Number: ",ZTSK,")"
 G OUT
 ;
TSK ; Taskman Entry Point
 S ABMP("Q")=""
 ;
ENT ;
 I '$D(ABMY("BATCH")) D  G OUT
 .S ABMY=0
 .F  S ABMY=$O(ABMY(ABMY)) Q:'ABMY  D
 ..S ABMP("BDFN")=ABMY
 ..D FORMS
 S ABMY=0
 F  S ABMY=$O(^ABMDBILL(DUZ(2),"AX",ABMY("BATCH"),ABMY)) Q:'ABMY  D
 .; Quit if bill status is Reviewed, Approved, or Cancelled
 .Q:"RAX"[$P($G(^ABMDBILL(DUZ(2),ABMY,0)),U,4)
 .S ABMP("BDFN")=ABMY
 .D FORMS
 G OUT
 ;
FORMS ; Reprint Forms
 K ABMP("PAYED")  ; LSM/12-13-96
 I ABMP("EXP")>2 D @("ENT^ABMDF"_+ABMY("FORM")) Q
 ;
UB82 ;
 I +ABMY("FORM")=1 D  Q
 .D ENT^ABMDF1,^ABMDF1X
 .D:$D(ABMR)=10 UB82^ABMDF1
 ;
HCFA ;
 D ENT^ABMDF2
 I +$O(ABMR("")) S ABMR("MORE")=""
 D ^ABMDF2X
 D:+$O(ABMR("")) HCFA^ABMDF2
 Q
 ;
OUT ;
 D ^%ZISC
 ;
XIT ;
 D WTOT^ABMDFUTL:$G(ABMY("TOT"))
 K ABMP,ABMY,DIQ
 Q
 ;
CKMULT ; check if form is used for multiple bills  
 I $P($G(^ABMDEXP($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6),1)),U,3) D
 .W !!,*7,"Bill Number "
 .W $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)
 .W " was exported on a "
 .W $P(^ABMDEXP($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6),0),U)
 .W " form. Since this form may"
 .W !,"include multiple bills, a single bill can not be individually reprinted."
 .W !,"Thus, to reprint the bill you must reprint the entire export batch."
 .K ABMP("BDFN")
 Q
