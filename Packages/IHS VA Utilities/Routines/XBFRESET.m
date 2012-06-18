XBFRESET ; IHS/ADC/GTH - RESET FILE GLOBALS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine removes all data from FileMan files by
 ; saving the 0th node, killing the global, then resetting
 ; the 0th node.
 ;
START ;
 NEW I
 W !!,$$REPEAT^XLFSTR("*",78),!,"This routine kills file data globals and resets the 0th nodes.  If you are not",!,"absolutely sure of what you are doing, please ^ out at the first opportunity!",!,$$REPEAT^XLFSTR("*",78),!!
 F I=1:1:3 W *7,"*** WARNING ***" H 1 W:I'=3 *13,$J("",79),*13
 KILL I
 W !!,"Select the files you wish reset."
 D ^XBDSET
EN1 ;PEP - Interactive entry, files already selected.
 Q:'$D(^UTILITY("XBDSET",$J))
 W !!,"The following files globals will be killed and reset.",!
 H 2
 D EN^XBLZRO
 Q:'$$DIR^XBDIR("Y","Do you want to continue","NO","","","",1)
EN2 ;PEP - Non-interactive entry, files already selected.
 NEW F,G,X,Y
 S F=""
 F  S F=$O(^UTILITY("XBDSET",$J,F)) Q:F=""  D
 . Q:'$D(^DIC(F,0,"GL"))  S G=^("GL")
 . S Y=G_"0)"
 . S G=$E(G,1,$L(G)-1)_$S($E(G,$L(G))="(":"",1:")")
 . W:'$D(ZTQUEUED) "."
 . S X=@Y,X=$P(X,"^",1,2)_"^0^0"
 . KILL @G
 . S @Y=X
 . Q
 KILL ^UTILITY("XBDSET",$J)
 Q
 ;
