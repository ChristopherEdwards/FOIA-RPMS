ABMDRTX ; IHS/ASDST/DMJ - Transmittal Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 K ABM
 S ABM("PRIVACY")=1
 S ABM("SUBR")="ABM-TX2" K ^TMP("ABM-TX2",$J)
SELB W ! K DIR S DIR(0)="YO",DIR("A")="List BILLS for all EXPORT BATCHES that havn't been Previously Printed",DIR("B")="Y"
 S DIR("?")="Answer 'YES' if it is desired to print a Transmittal List that contains all bills associated with the Export Batches which have not been previously printed." D ^DIR K DIR
 G XIT:$D(DIRUT)
 G SELBE:'Y
 S DA=0 F  S DA=$O(^ABMDTXST(DUZ(2),"AT",1,DA)) Q:'DA  D
 .Q:'$D(^ABMDTXST(DUZ(2),DA,0))
 .S DIE="^ABMDTXST(DUZ(2),",DR=".08///@" D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))
 .S ABM("DFN",DA)="",ABM("DT")=$P(^ABMDTXST(DUZ(2),DA,0),U)
 I '$O(ABM("DFN","")) W !!,*7,"*** A Transmittal List has already been Printed for all Export Batches! ***",! K DIR S DIR(0)="E" D ^DIR G XIT
 G TYP
 ;
SELBE W !! K DIC S ABM("C")=0,DIC="^ABMDTXST(DUZ(2),",DIC(0)="QEAM",ABM("M")=1
SELBO S ABM("E")=$E(ABM("M"),$L(ABM("M"))),DIC("A")="Select "_ABM("M")_$S(ABM("M")>3&(ABM("M")<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" EXPORT BATCH (NUMBER or DATE): " D ^DIC
 Q:$D(DUOUT)!$D(DTOUT)  G TYP:X=""
 I +Y<1 G SELBO
 S ABM("M")=ABM("M")+1
 S ABM("DFN",+Y)="",ABM("DT")=$P(^ABMDTXST(DUZ(2),+Y,0),U)
 G SELBO
 ;
TYP W !!,"AVAILABLE REPORTS:",!,"=================="
 K DIR S DIR(0)="S^1:Sorted by LOCATION/VISIT TYPE;2:Separated by INSURER for attachment to COVER LETTERS",DIR("A")="Select desired REPORT TYPE" D ^DIR K DIR
 G XIT:$D(DIRUT)
 S ABM("RTN")=+Y
 ;
 D ZIS^ABMDRUTL
 G:'$D(IO)!$G(POP) XIT
 G @("^ABMDRTX"_ABM("RTN"))
 ;
XIT K ABM
 Q
