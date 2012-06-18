%ZIBRD ; IHS/ADC/GTH - DISPLAY MSM DIRECTORY OF SELECTED RTNS ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Generate routine directory of selected routines
 ;
 ; Save, or %RCOPY, this routine to the MGR uci, named as
 ; %ZIBRD.  It may also be name %AZRD.
 ;
START ;
 I $$VERSION^%ZOSV(1)["Cache" D ^%RD KILL MSYS,R,nrou Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 X ^%ZOSF("RSEL")
 G:$O(^UTILITY($J,""))="" EXIT
 NEW I,NAM,Y
 W !?21,"Routine Directory",?40
 D ^%D
 X ^%ZOSF("UCI")
 W !?25,"of ",Y,?40
 D ^%T
 W !
%ST1 ;
 ;S NAM="" ;IHS/SET/GTH XB*3*9 10/29/2002
 S NAM=0 ;IHS/SET/GTH XB*3*9 10/29/2002
 F I=0:1 S NAM=$O(^UTILITY($J,NAM)) Q:NAM=""  W:'(I#8) ! W NAM,$J("",9-$L(NAM))
 W !?5,I," Routines",!
 G START ;IHS/SET/GTH XB*3*9 10/29/2002
EXIT ;
 KILL %UCI,%UCN
 KILL I,^UTILITY($J)
 Q
 ;
