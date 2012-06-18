ABMDEOPN ; IHS/ASDST/DMJ - Open Claim for Editing ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 W !!,"If run, this Program will Open a Claim so that it may be edited."
 W !!,"WARNING: Opening a claim that is closed, pending the posting of a payment,",!?9,"may lead to the duplication of bills."
 D ^ABMDEDIC G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)!'+$G(ABMP("CDFN"))
 ;
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".04///E" D ^ABMDDIE G XIT:$D(ABM("DIE-FAIL"))
 W !,"CLAIM: ",ABMP("CDFN")," is now OPEN for Editing" H 3
XIT K ABMP
 Q
