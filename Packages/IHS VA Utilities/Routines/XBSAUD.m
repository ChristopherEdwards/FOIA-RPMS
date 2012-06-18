XBSAUD ; IHS/ADC/GTH - SET AUDIT AT FILE LEVEL ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine sets 'audit' on at the file level for
 ; selected files
 ;
START ;
 W !!,"^XBSAUD - This routine sets 'audit' at the file level."
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 NEW F,G,P
 S Y=$$DIR^XBDIR("S^1:ON;2:OFF","Set 'audit' ON or OFF?","ON")
 Q:$D(DUOUT)!$D(DTOUT)
 S Y=Y-1
 W !
 F F=0:0 S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  D
 . S G=^DIC(F,0,"GL")
 . S P=$P(@(G_"0)"),"^",2)
 . I Y S P=$P(P,"a",1)_$P(P,"a",2) I 1
 . E  S P=P_$S(P'["a":"a",1:"")
 . S $P(@(G_"0)"),"^",2)=P
 . W !,F,"  set ",$S(Y:"off",1:"on")
 .Q
 D EOJ
 Q
 ;
EOJ ;
 KILL X,Y,^UTILITY("XBDSET",$J)
 Q
 ;
