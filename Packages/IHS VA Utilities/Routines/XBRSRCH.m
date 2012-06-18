XBRSRCH ; IHS/ADC/GTH - SEARCH DD FOR CALLED ROUTINES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine searches a dictionary for called routines,
 ; excluding %DT*, DIC, DIK, and DIQ.
 ;
START ;
 W !,"This routine searches dictionaries for called routines, excluding %DT*, DIC,",!,"  DIK, and DIQ.",!
 S U="^"
 R !,"[D]etail or [L]ist only: L//",X:$G(DTIME,999)
 S:X'="D" XBRSRCH("NO DETAIL")=1
 ; could be a little friendlier
 W !
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 S XBRSRCH("QFLG")=0,XBRSRCH("FILE")=0
 F XBRSRCH("L")=0:0 S XBRSRCH("FILE")=$O(^UTILITY("XBDSET",$J,XBRSRCH("FILE"))) Q:XBRSRCH("FILE")=""  D CHECK Q:XBRSRCH("QFLG")
 KILL XBRSRCH,^UTILITY("XBDSET",$J)
 Q
 ;
CHECK ; CHECK FILES UNTIL ALL DONE
 W !!,"Searching ",$P(^DIC(XBRSRCH("FILE"),0),"^",1)," file (",XBRSRCH("FILE"),")"
 KILL ^UTILITY("XBRSRCH",$J)
 W !!,"INPUT TRANSFORMS",!
 S XBSINP("FILE")=XBRSRCH("FILE")
 D EN^XBRSRCH2
 W !!,"OUTPUT TRANSFORMS",!
 S XBSOUT("FILE")=XBRSRCH("FILE")
 D EN^XBRSRCH3
 W !!,"CROSS-REFERENCES",!
 S XBSXREF("FILE")=XBRSRCH("FILE")
 D EN^XBRSRCH4
 W !!,"MISCELLANEOUS ^DD ENTRIES",!
 S XBSM("FILE")=XBRSRCH("FILE")
 D EN^XBRSRCH5
 W !
 D LIST
 D EOJ
 Q
 ;
LIST ; LIST ROUTINE NAMES
 Q:'$D(^UTILITY("XBRSRCH",$J))
 W !!,"Sorted list of routines found:",!
 S X=""
 F XBRSRCH("L")=0:0 S X=$O(^UTILITY("XBRSRCH",$J,X)) Q:X=""  W !,"^",X
 W !
 Q
 ;
EOJ ;
 KILL ^UTILITY("XBRSRCH",$J),X,Y,DIC
 Q
 ;
