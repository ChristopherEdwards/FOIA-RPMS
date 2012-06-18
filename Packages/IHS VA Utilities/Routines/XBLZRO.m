XBLZRO ; IHS/ADC/GTH - LISTS 0TH NODES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine lists the 0th nodes of FileMan files.
 ;
START ;
 NEW QFLG
 S QFLG=0
 W !,"^XBLZRO - This routine lists the 0th nodes of FileMan files."
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 D DEVICE
 I QFLG KILL QFLG Q
EN ;PEP - List 0th node of pre-selected list of FileMan files.
 ; IOF,IOSL must be set and U IO if appropriate.
 I $D(IOF)#2,$D(IOSL)#2
 E  Q
 NEW F,G,N,X,QFLG
 S QFLG=0
 D HEADER
 S F=0
 F  S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  I $D(^DIC(F,0,"GL")) S G=^("GL") D LIST Q:QFLG
 D ^%ZISC
 Q
 ;
LIST ;
 S X=$L(G),X=$E(G,1,X-1)_$S($E(G,X)=",":",0)",1:"(0)")
 S N="<DOES NOT EXIST>"
 S:$D(@X) N=^(0)
 D:$Y>(IOSL-3) PAGE
 Q:QFLG
 W F,?15,X,?35,N,!
 Q
 ;
PAGE ; PAGE BREAK
 NEW F,G,N,X
 I IO=IO(0),$E(IOST,1,2)="C-" S Y=$$DIR^XBDIR("E") S:$D(DIRUT)!($D(DUOUT)) QFLG=1 KILL DIRUT,DUOUT
 Q:QFLG
 D HEADER
 Q
 ;
HEADER ; PRINT HEADER
 NEW TITLE,TM,HR,MIN,TME,UCI
 W:$D(IOF) @IOF
 S TITLE="FILE 0TH NODE LIST",TM=$P($H,",",2),HR=TM\3600,MIN=TM#3600\60
 S:MIN<10 MIN="0"_MIN
 S TME=HR_":"_MIN
 I '$D(DT) S %DT="",X="T" D ^%DT S DT=Y
 S Y=DT
 X ^DD("DD")
 W Y,"@",TME,?30,TITLE
 X ^%ZOSF("UCI")
 S UCI="UCI: "_$P(Y,",",1)
 W ?65,UCI,!,"FILE",?15,"GLOBAL",?35,"0TH NODE",!!
 Q
 ;
DEVICE ; GET DEVICE (QUEUEING ALLOWED)
 W !
 S %ZIS="Q"
 D ^%ZIS
 I POP S QFLG=1 KILL POP Q
 I $D(IO("Q")) D  S QFLG=1 Q
 . S ZTRTN="EN^XBLZRO",ZTIO=ION,ZTDESC="List 0th nodes",ZTSAVE("^UTILITY(""XBDSET"",$J,")=""
 . D ^%ZTLOAD
 . W !!,$S($D(ZTSK):"Request queued!",1:"Request cancelled!")
 . D ^%ZISC
 . KILL ZTSK,IO("Q")
 . KILL ZTIO ; ^%ZTLOAD kills other ZT* variables, but not this one
 . Q
 U IO
 Q
 ;
