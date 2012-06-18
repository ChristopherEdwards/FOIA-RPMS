%AUGSE ;MVB; 21-Jan-87 10:45 ;GLOBAL SEARCH EVERY
 ;
 ;SEARCH EVERY SPECIFIED NODE AND ITS DATA FOR A GIVEN VALUE
 ;
START K ^UTILITY($J) D ^%GSEL Q:$O(^UTILITY($J,""))=""
 R !,"Search for: ",AUS,! Q:AUS=""
 S AUG=""
LOOP F AU=0:0 S AUG=$O(^UTILITY($J,AUG)) Q:AUG=""  I $D(@("^"_AUG)) D  W !
 .S $ZT="ERR",AU="^"_AUG,AUX="" I $L(^UTILITY($J,AUG)) F %=1:1:$L(^(AUG),",")-1 Q:'$L($P(^(AUG),",",%))  S AUX=AUX_$P(^(AUG),",",%)_","
 .I $D(@AU),$L(AUX) S AU=AU_"("_AUX 
 .W !,"Searching "_AU I $D(@($E(AU,1,$L(AU)-(AU[","))_$E(")",(AU[","))))'[0,$ZR[AUS!(@$ZR[AUS) W !?2,$ZR_"="_@$ZR
 .I $ZO[AUS!($ZR[AUS) W !?2,$ZR_"="_@$ZR
L1 .F %=0:0 Q:$P($ZR,AU)]""  I $ZO[AUS!($ZR[AUS) W !?2,$ZR_"="_@$ZR
 Q
ERR I $ZE["<UNDEF",$ZE["L1^" Q
 ZQ
