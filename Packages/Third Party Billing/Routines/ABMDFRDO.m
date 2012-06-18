ABMDFRDO ; IHS/ASDST/DMJ - Re-Print Selected Bills ;    
 ;;2.6;IHS Third Party Billing System;**2,4**;NOV 12, 2009
 ;Original;TMD;02/21/96 12:13 PM
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM14693/IM16105
 ;    Added code to use ADA-2002 for 837D when printing
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*2 - FIXPMS10006 - added prompt for DATE to use when reprinting
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
 S ABMY("EXP")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6)
 S ABMY("FORM")=ABMY("EXP")_"^"_$P($G(^ABMDEXP(ABMY("EXP"),0)),U)
 G SEL
 ;
UNPD ;UN-PAID BILLS
 D ^ABMDBRUN
 S ABMY("TOT")="0^0^0"
 W !!,"For the parameters specified, the"
 W !,"           Number of Bills to Reprint: ",ABMP("CNT")
 I '$O(ABMY(0)) W *7 G XIT
 ;
ZIS ;EP
 I '$G(ABMY("EXP")) S ABMY("EXP")=+ABMY("FORM")
 I $P($G(^ABMDEXP(ABMY("EXP"),1)),"^",5)="E" D
 .K DIC,DIE,DIR,X,Y
 .S DIR("A")="**Use the following export mode: "
 .I $P(ABMY("FORM"),U,2)["HCFA" D
 ..S DIR("B")="1500 (08/05)"
 ..S DIR(0)="S^3:1500 B;14:1500 Y2K;27:1500 (08/05)"
 .I $P(ABMY("FORM"),U,2)["UB" D
 ..S DIR("B")="UB-04"
 ..S DIR(0)="S^11:UB-92;28:UB-04"
 .I $P(ABMY("FORM"),U,2)["ADA" D
 ..S DIR("B")="ADA-2006"
 ..S DIR(0)="S^25:ADA-2002;29:ADA-2006"
 .D ^DIR K DIR
 .I $P(ABMY("FORM"),U,2)["HCFA" S ABMY("FORM")=$S(Y=3:"3^HCFA-1500B",Y=14:"14^HCFA-1500 Y2K",1:"27^HCFA 1500 (08/05)")
 .I $P(ABMY("FORM"),U,2)["UB" S ABMY("FORM")=$S(Y=11:"11^UB-92",1:"28^UB-04")
 .I $P(ABMY("FORM"),U,2)["ADA" S ABMY("FORM")=$S(Y=25:"25^ADA-2002",1:"29^ADA-2006")
 I +ABMY("FORM")=2,$P($G(^ABMDPARM(DUZ(2),1,2)),9)=2 D  G XIT:$D(DIRUT)
 .W !!,"Forms Previously Printed on Old HCFA-1500.",!!
 .K DIR
 .S DIR(0)="Y"
 .S DIR("B")="Y"
 .S DIR("A")="Want to print the New Version of the HCFA-1500 (Y/N)"
 .D ^DIR
 .I Y S ABMY("FORM")=3_U_$P(^ABMDEXP(3,0),U)
 S ABMP("EXP")=+ABMY("FORM")
 ;start new code abm*2.6*2 FIXPMS10006
 D ^XBFMK
 S DIR(0)="S^T:TODAY'S DATE;O:ORIGINAL PRINT DATE"
 S DIR("A")="Reprint using which date"
 S DIR("B")="TODAY"
 D ^DIR K DIR
 ;S ABMPDT=Y  ;abm*2.6*4 HEAT17615
 S ABMP("PRINTDT")=Y  ;abm*2.6*4 HEAT17615
 ;end new code FIXPMS10006
 W !!?15,"(NOTE: "
 I $P($G(^ABMDEXP(ABMP("EXP"),1)),U,4) W "Plain Paper needs"
 E  W $P(ABMY("FORM"),U,2)," forms need"
 W " to be loaded in the printer.)"
 W !!
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="PQ"
 D ^%ZIS
 G XIT:POP
 I IO'=IO(0),IOT'="HFS" D  Q
 .D QUE2
 .D HOME^%ZIS
 U IO(0)
 W:'$D(IO("S")) !!,"Printing..."
 U IO
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
 K ABMP("PAYED")
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
