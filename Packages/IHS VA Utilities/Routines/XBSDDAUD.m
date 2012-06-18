XBSDDAUD ;IHS/SET/GTH - SET DICTIONARY AUDIT(S) ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;IHS/SET/GTH XB*3*9 10/29/2002 New Routine.
 ; This routine allows you to toggle the dictionary (dd) audit
 ; flag for selected files.  The global location for dictionary
 ; audit is:  ^DD(FILE,0,"DDA")
 ; If the valuey is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ;
START ;
 W !!,"^XBSDDAUD - This routine toggles the data dictionary audit flag(s)."
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 D DEV
 Q:POP
 D DISP
 Q:'$$DIR^XBDIR("Y","Proceed to toggling dd audit for file(s)","N")
 D SET
 KILL X,Y,^UTILITY("XBDSET",$J)
 Q
 ;
DISP ; Display current dd audit values for file(s).
 NEW F,G,P
 W !,"File #",?15,"File Name",?50,"Global",?65,"dd Audit On/Off"
 F F=0:0 S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  D
 . S G=$G(^DIC(F,0,"GL"))
 . S P=$G(^DD(F,0,"DDA"))
 . W !,F,?15,$$FNAME^XBFUNC(F),?50,G,?65,$S(P="Y":"on",1:"off")
 .Q
 ;
 Q
 ;
DEV ; Select device for report.
 W !
 S %=$$PB
 I %=U!$D(DTOUT)!$D(DUOUT) Q
 I %="B" D VIEWR^XBLM("DISP^XBSDDAUD"),EN^XBVK("VALM") Q
 D ^%ZIS
 Q
 ;
PB() ;
 Q $$DIR^XBDIR("SO^P:PRINT Output;B:BROWSE Output on Screen","Do you want to ","PRINT","","","",2)
 ;
SET ; Set DDA for the file(s).
 NEW F,G,P,Y
 S Y=$$DIR^XBDIR("S^1:ON;2:OFF","Set 'dd audit' ON or OFF?","OFF")
 Q:$D(DUOUT)!$D(DTOUT)
 S Y=$S(Y=1:"Y",1:"")
 W !
 F F=0:0 S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  D
 . Q:'$D(^DD(F))
 . S ^DD(F,0,"DDA")=Y
 . W !,F,"  set ",$S(Y="Y":"on",1:"off")
 .Q
 ;
 Q
 ;
