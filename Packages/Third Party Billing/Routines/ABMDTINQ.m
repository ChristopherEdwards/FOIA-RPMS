ABMDTINQ ; IHS/ASDST/DMJ - Inquire UTILITY ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/DSD/MRS - Patch 1 - NOIS QDA-299-130004 3/20/1999
 ;               Modified to change insurer look up to pull visit type
 ;               from abmnins instead of autnins
 ;
LOC ;EP for displaying Location Record
 S ABM("SUB")="LOCATION" D HD S DIC="^AUTTLOC(" G DIC
CPT ;EP for displaying CPT Record
 S ABM("SUB")="CPT PROCEDURE" D HD S DIC="^ICPT(" G DIC
INS ;EP for displaying Insurer Record
 S ABM("SUB")="INSURER" D HD S DIC="^AUTNINS(" D DIC Q
PRV ;EP for displaying Provider Record
 S ABM("SUB")="PROVIDER" D HD S DIC="^VA(200,",DIC("S")="I $D(^(""PS""))" G DIC
 ;
BILL ;EP for displaying Bill Record
 D ^ABMDBDIC
 G XIT:'$G(ABMP("BDFN"))
 S ABM("SUB")="BILL"
 S DA=ABMP("BDFN")
 W $$EN^ABMVDF("IOF")
 W !?80-$L(ABM("SUB"))-21\2,"*** ",ABM("SUB")," FILE INQUIRY ***"
 S DIC="^ABMDBILL(DUZ(2),"
 S ABM=""
 S $P(ABM,"=",80)=""
 W !!,ABM
 K S
 D EN^DIQ
 W ABM
 G BILL
 ;
DRUG ;EP for displaying Drug Record
 S ABM("SUB")="DRUG" D HD S DIC="^PSDRUG(" G DIC
 ;
DIC W !! S DIC("A")="Select "_ABM("SUB")_": ",DIC(0)="QEAM" D ^DIC
 G XIT:X=""!(X["^")!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G DIC
 S DA=+Y
 W $$EN^ABMVDF("IOF") W !?80-$L(ABM("SUB"))-21\2,"*** ",ABM("SUB")," FILE INQUIRY ***"
 S ABM="",$P(ABM,"=",80)="" W !!,ABM K S
 I DIC'["AUTNINS" D EN^DIQ W ABM G DIC
 S DR="0:31;43" D EN^DIQ ; Skip visit type node 39 in autnins
 ;S DIC="^ABMNINS(DUZ(2),",DR="1:2" D EN^DIQ ; Write it from abmnins  ;abm*2.6*6 5010
 S DIC="^ABMNINS(DUZ(2),",DR="1:2.5" D EN^DIQ ; Write it from abmnins  ;abm*2.6*6 5010
 W ABM
 G DIC
 ;
XIT K ABM,DIR,DIC,DIE
 Q
 ;
HD K DIC,DR
 Q
