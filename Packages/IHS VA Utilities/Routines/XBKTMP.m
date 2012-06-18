XBKTMP ; IHS/ADC/GTH - CLEAN ^TMP NODES FOR CURRENT JOB ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Called from the top, this routine KILLs entries in the
 ; ^TMP global that have $J as the first or second subscript.
 ;
 KILL ^TMP($J)
 NEW X
 S X=""
 F  S X=$O(^TMP(X)) Q:X=""  KILL ^TMP(X,$J)
 Q
 ;
