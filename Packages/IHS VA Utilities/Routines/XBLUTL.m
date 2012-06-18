XBLUTL ; IHS/ADC/GTH - LIST ^UTILITY FOR $J ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; This routine lists all entries in the ^UTILITY global for
 ; the current $J where $J is the first or second subscript.
 ;
 ; This is most useful from programmer mode.  If used thru the
 ; XB menu, ^UTILITY($J) is killed in ^XBKSET before this
 ; routine is run.
 ;
START ;
 W @($S($D(IOF):IOF,1:"#"))
 X ^%ZOSF("UCI")
 ;W !,"^UTILITY nodes for job ",$J," in UCI ",Y,!;IHS/SET/GTH XB*3*9 10/29/2002
 W !,"^UTILITY nodes for job ",$J," in ",$S($$VERSION^%ZOSV(1)["Cache":"Namespace",1:"UCI")," ",Y,! ;IHS/SET/GTH XB*3*9 10/29/2002
 S XBLUTL("QFLG")=0,XBLUTL("X")="^UTILITY($J,"""")"
 F  S XBLUTL("X")=$Q(@XBLUTL("X")) Q:$P($P(XBLUTL("X"),"(",2),",")'=$J  D LIST Q:XBLUTL("QFLG")
 S XBLUTL("Y")=" "
 F  S XBLUTL("Y")=$O(^UTILITY(XBLUTL("Y"))) Q:XBLUTL("Y")=""  I $D(^UTILITY(XBLUTL("Y"),$J)) D
 . S XBLUTL("X")="^UTILITY("""_XBLUTL("Y")_""","_$J_")",XBLUTL("Z")="1""^UTILITY("""""_XBLUTL("Y")_""""","_$J_"""1P.E"
 . D:$D(@(XBLUTL("X")))#2 LIST
 . Q:XBLUTL("QFLG")
 . F  S XBLUTL("X")=$Q(@XBLUTL("X")) Q:XBLUTL("X")'?@XBLUTL("Z")  D LIST Q:XBLUTL("QFLG")
 . Q
 KILL XBLUTL
 Q
 ;
LIST ;
 I $Y>($S($D(IOSL):IOSL,1:24)-3) S Y=$$DIR^XBDIR("E"),XBLUTL("QFLG")='Y W:Y @($S($D(IOF):IOF,1:"#"))
 Q:XBLUTL("QFLG")
 W !,XBLUTL("X")," = ",@XBLUTL("X")
 Q
 ;
