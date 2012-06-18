XUTMTEP ;SEA/RDS - TaskMan: Toolkit, Edit Priority ; ; [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;;Jul 10, 1995
 ;
EDIT ;Edit task's priority
 N DIR
 S DIR(0)="NO^1:10"
 S DIR("A")="PRIORITY"
 I $P(ZTSK(0),U,15) S DIR("B")=$P(ZTSK(0),U,15)
 S DIR("?")="^D HELP^XUTMTEP"
 S DIR("??")="^D HELP2^XUTMTEP"
 D ^DIR K DIR
 I $D(DTOUT) W $C(7)
 I $D(DIRUT) Q
 S $P(ZTSK(0),U,15)=X
 Q
 ;
HELP ;EDIT--? help for prompt
 W !!?5,"Answer must be an integer between 1 and 10."
 Q
 ;
HELP2 ;EDIT--?? help for prompt
 W !!?5,"Answer will set the starting priority for the task."
 W !?5,"Answer 10 to specify high priority, 1 for low, etc."
 W !?5,"If no priority is specified, site default will be used."
 Q
 ;
