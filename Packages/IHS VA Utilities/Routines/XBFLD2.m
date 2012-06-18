XBFLD2 ; IHS/ADC/GTH - INITIALIZATION FOR ^XBFLD ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Part of XBFLD
 ;
 ; ^UTILITY("XBDSET",$J, is used to store the list of files
 ; to be listed so that other software can pass files to be
 ; listed to the external entry point EN^XBFLD, and the other
 ; software could select files by using ^XBDSET.
 ;
INIT ; INITIALIZATION
 NEW XBFILE
 D ^XBKVAR
 KILL ^UTILITY($J),^UTILITY("XBDSET",$J)
 S XBQFLG=0
 D ^XBDSET
 S:'$D(^UTILITY("XBDSET",$J)) XBQFLG=1
 Q:XBQFLG
 D FORMAT^XBFLD
 D DEVICE ;                 Get device
 Q
 ;
DEVICE ; GET DEVICE (QUEUEING ALLOWED)
XBLM ;
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 KILL DA
 Q:$D(DIRUT)
 I Y="B" S XBFLD("BROWSE")=1 D VIEWR^XBLM("EN^XBFLD"),FULL^VALM1 W:$D(IOF) @IOF D  Q
 . D CLEAR^VALM1 ;clears out all list man stuff
 . KILL XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF,VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMKEY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMY,XQORS,XQORSPEW,VALMCOFF
XBLME .Q
 S %ZIS="Q"
 D ^%ZIS
 I POP S XBQFLG=1 KILL POP Q
 I $D(IO("Q")) D  S XBQFLG=1 Q
 . S ZTRTN="EN^XBFLD",ZTIO=ION,ZTDESC="List dictionary",ZTSAVE("^UTILITY(""XBDSET"",$J,")="",ZTSAVE("XBFMT")=""
 . D ^%ZTLOAD
 . W !!,$S($D(ZTSK):"Request queued!",1:"Request cancelled!")
 . D ^%ZISC
 . KILL ZTSK,IO("Q")
 . KILL ZTIO ; ^%ZTLOAD kills other ZT* variables, but not this one
 .Q
 U IO
 Q
 ;
