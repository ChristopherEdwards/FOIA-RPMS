XBLFD ;IHS/SET/GTH - LISTS FILE DESCRIPTIONS ; [ 04/18/2003  9:05 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;IHS/SET/GTH XB*3*9 10/29/2002  New routine.
 ; This routine lists the number, name, global, and, optionally,
 ; description <if any> of the selected file(s).
 ;
START ;
 ; --- Display routine description.
 D HOME^%ZIS,DT^DICRW
 KILL ^UTILITY($J)
 S ^UTILITY($J,"XBLFD")=""
 D EN^XBRPTL
 KILL ^UTILITY($J)
 NEW QFLG,XBDESC
 S QFLG=0
 ; --- Get file(s).
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 ; --- Print DESCRIPTION flag.
 S XBDESC=$$DIR^XBDIR("Y","Print file DESCRIPTION ","Y",$G(DTIME,500),"You can include the DESCRIPTION of the file in your list")
 Q:Y="^"
 I XBDESC NEW DIWL,DIWR,DIWF S DIWL=14,DIWR=74,DIWF="W"
 ; --- Select device.
 W !
 S %ZIS="Q",ZTSAVE("^UTILITY(""XBDSET"",$J,")=""
 D EN^XUTMDEVQ("EN^XBLFD","List File Descriptions.",.ZTSAVE,.%ZIS)
 D EN^XBVK("ZT")
 Q
 ;
EN ;PEP - List 0th node of pre-selected list of FileMan files.
 ; IOF,IOSL must be set and U IO if appropriate.
 I $D(IOF)#2,$D(IOSL)#2
 E  Q
 NEW F,G,N,X,QFLG
 ; F:File #; G:Global; N:Zeroth
 S QFLG=0
 D HEADER
 S F=0
 F  S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  S G=$$FGLOB^XBFUNC(F) I G'=-1 D LIST Q:QFLG
 D ^%ZISC
 Q
 ;
LIST ;
 D:$Y>(IOSL-3) PAGE
 Q:QFLG
 W F,?13,$$FNAME^XBFUNC(F),?60,G,!
 I XBDESC D DESC(F)
 Q
 ;
DESC(F) ; Print file DESCRIPTION.
 NEW XB
 F XB=0:0 S XB=$O(^DIC(F,"%D",XB)) Q:'XB  S X=$G(^(XB,0)) D ^DIWP I $Y>(IOSL-3) D PAGE Q:QFLG
 Q:QFLG
 D ^DIWW
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
 W @IOF,$$FMTE^XLFDT($$NOW^XLFDT),?34,"FILE DESCRIPTIONS"
 X ^%ZOSF("UCI")
 W ?65,$P(Y," ",1),!,$$REPEAT^XLFSTR("-",IOM),!,"NUMBER",?13,"FILE",?60,"GLOBAL",!
 I XBDESC W ?13,"<DESCRIPTION>",!
 W $$REPEAT^XLFSTR("-",IOM),!!
 Q
 ;
