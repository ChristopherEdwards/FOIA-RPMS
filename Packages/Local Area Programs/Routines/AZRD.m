AZRD ; [ 09/03/87  8:16 AM ]
 ;REMOVED VARIABLE %SYS FROM LINE AZRD+4
 ;%WSYS FOLLOWED %UCI VARIABLE
 K:$D(^UTILITY($J)) ^UTILITY($J)
 D ^%RSEL G:$O(^UTILITY($J,""))="" EXIT
 W !,?21,"Routine Directory",?40 D ^%D,^%GUCI W !,?25,"of ",%UCI,?40 D ^%T W !
%ST1 S %NAM=""
 F I=0:1 S %NAM=$O(^UTILITY($J,%NAM)) Q:%NAM=""  W:'(I#8) ! W %NAM_$J("",9-$L(%NAM))
 W !,?5,I," Routines",!
EXIT ;
 K I,^UTILTIY($J),%NAM
 Q
