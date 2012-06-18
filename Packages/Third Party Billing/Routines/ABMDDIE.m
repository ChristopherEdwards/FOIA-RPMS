ABMDDIE ; IHS/ASDST/DMJ - DIE utility ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; Routine to generically lock fileman entries prior to
 ; DIE calls
 ;
 ;  output vars: ABM("DIE-FAIL") - set to 1 upon failure
 ;
 K ABM("DIE-FAIL")
 L +@(DIE_DA_")"):1 G FAIL:'$T
 D ^DIE
 L -@(DIE_DA_")")
 Q
 ;
FAIL S ABM("DIE-FAIL")=1
 Q:$D(ZTQUEUED)
 W *7,!!?5,"ERROR: Record ",DA," for ",$P(DIE,"(")," in USE by another USER, try Later!"
 Q
