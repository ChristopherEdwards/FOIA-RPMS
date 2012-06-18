XBLFMD ;IHS/SET/GTH - LISTS FIELDS MARKED FOR DELETION ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;IHS/SET/GTH XB*3*9 10/29/2002 New Routine.
 ;  List fields in the selected files that are marked for deletion.
 ;  Output is File#, File Name, Field#, Field Name, Date Of Edit
START ;
 ; --- Display routine description.
 D HOME^%ZIS,DT^DICRW
 KILL ^UTILITY($J)
 S ^UTILITY($J,"XBLFMD")=""
 D EN^XBRPTL
 KILL ^UTILITY($J)
 NEW QFLG
 S QFLG=0
 ; --- Get file(s).
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 D DEVICE
 Q:QFLG
 NEW F,X,XBUCI,XBDASH,XBTIME
 X ^%ZOSF("UCI")
 S XBUCI=Y,XBDASH=$$REPEAT^XLFSTR("-",IOM),XBTIME=$$FMTE^XLFDT($$NOW^XLFDT)
 ; F:File #
 S F=0
 F  S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  D FIELDS(F) Q:QFLG
 D ^%ZISC
 Q
 ;
FIELDS(F) ; Process fields in File F.
 ;  Output is File#, Field#, Field Name, Date Of Edit
 NEW X,XB
 S X=""
 F XB=0:0 S XB=$O(^DD(F,XB)) Q:'(XB=+XB)  D  D:$Y>(IOSL-3) PAGE Q:QFLG
 . I $E($P($G(^DD(F,XB,0)),"^",1))="*" W $J(F,10),?12,$E($$FNAME^XBFUNC(F),1,20),?32,$J(XB,10),?44,$E($P($G(^DD(F,XB,0)),"^",1),1,24),?68,$$FMTE^XLFDT($G(^DD(F,XB,"DT"))),!
 . I $P(^DD(F,XB,0),"^",2) D FIELDS(+$P(^DD(F,XB,0),"^",2)) Q  ; Recurse sub-file.
 .Q
 Q
 ;
PAGE ; PAGE BREAK
 NEW F,G,N,X
 I IO=IO(0),$E(IOST,1,2)="C-" S QFLG='$$DIR^XBDIR("E") I QFLG Q
 W @IOF
 W !,"Fields Marked For Deletion in ",XBUCI," uci.",?(IOM-$L(XBTIME)),XBTIME
 W !,"File#",?12,"File Name",?32,"Field#",?44,"Field Name",?68,"Date Of Edit"
 W !,XBDASH,!
 Q
 ;
DEVICE ; GET DEVICE (QUEUEING ALLOWED)
 W !
 S %ZIS="Q"
 D ^%ZIS
 I POP S QFLG=1 KILL POP Q
 I $D(IO("Q")) D  S QFLG=1 Q
 . S ZTRTN="EN^XBLFMD",ZTIO=ION,ZTDESC="List 0th nodes",ZTSAVE("^UTILITY(""XBDSET"",$J,")=""
 . D ^%ZTLOAD
 . W !!,$S($D(ZTSK):"Request queued!",1:"Request cancelled!")
 . D ^%ZISC
 . KILL ZTSK,IO("Q")
 . KILL ZTIO ; ^%ZTLOAD kills other ZT* variables, but not this one
 . Q
 U IO
 Q
 ;
