XBPATSE ; IHS/ADC/GTH - SEARCH ROUTINES FOR PATCHES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Search Routines for Patch Versions.
 ;
 ; Thanks to Ray A. Willie for the original routine.
 ;
MAIN ;
 NEW XB,DUZ,IO,IOF,IOM,IOSL,IOBS,IOXY,IOST,DT,DTIME,POP,U,X,Y
 D INIT
 D:'$D(ZTQUEUED)
 . D RSEL
 . D:'XB("END") DEVICE
 .Q
 D:'XB("END") SRCH
 D:'XB("END") PRT
 D EXIT
 Q
 ;
INIT ;
 S (XB("END"),XB("VER"),XB("PNBR"),XB("Q"))=0,XB("NAM")=""
 KILL ^TMP($J)
 D:'$D(ZTQUEUED) ^XBKVAR,DT^DICRW,HOME^%ZIS
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 S XB("DT")=Y
 X ^%ZOSF("UCI")
 S XB("UCI")=$P(Y,","),XB("VOL")=$P(Y,",",2)
 S XB("HD1")="R.P.M.S. PATCH SEARCH UTILITY  Version: "_$P($T(+2),";",3)
 S XB("HD2")="UCI: "_XB("UCI")_" CPU: "_XB("VOL")_"    "_XB("DT")
 Q
 ;
RSEL ;
 D SCHDR
 X ^%ZOSF("RSEL")
 S XB("END")='$D(^UTILITY($J))
 Q
 ;
DEVICE ;
 NEW %ZIS
 S %ZIS="NMQ"
 D ^%ZIS
 S XB("END")=POP
 Q:XB("END")
 S XB("IOP")=ION_";"_IOST_$S($D(IO("DOC")):";"_IO("DOC"),1:";"_IOM_";"_IOSL)
 D:$D(IO("Q")) QUE
 Q
 ;
QUE ;
 NEW ZTRTN,ZTIO,ZTDESC,ZTSAVE,ZTSK
 D:IO=IO(0)&($E(IOST,1,2)="C-")&($D(IO("Q"))#2)
 . W !,"Cannot Queue to HOME or CHARACTER Device",!
 . S XB("END")=1
 .Q
 Q:XB("END")
 S ZTRTN="^"_$TR($P($T(+1),";")," ",""),ZTIO=XB("IOP"),ZTDESC=$P($T(+1),";",2)
 F  Q:$E(ZTDESC)'=" "  S ZTDESC=$E(ZTDESC,2,99)
 S ZTSAVE("^UTILITY($J,")=""
 D ^%ZTLOAD
 I '$D(ZTSK) W !,"TASK not Queued with Task Manager",! S XB("END")=1
 Q:XB("END")
 S %H=ZTSK("D")
 D YX^%DTC
 W !,"TASK Queued with Task Manager: JOB # ",ZTSK," at ",Y,!
 D HOME^%ZIS
 S XB("END")=1
 Q
 ;
SRCH ;
 NEW XCNP,DIF
 D:'$D(ZTQUEUED) SCHDR
 S XB("NSP")=""
 F  S XB("NSP")=$O(^DIC(9.4,"C",XB("NSP"))) Q:XB("NSP")=""  D
 . S XB("EIN")=0,XB("EIN")=$O(^DIC(9.4,"C",XB("NSP"),XB("EIN")))
 . S XB("NAM")=$P($G(^DIC(9.4,XB("EIN"),0)),U)
 . S XB("VER")=$G(^DIC(9.4,XB("EIN"),"VERSION"),0)
 . S XB("ROU")=XB("NSP")
 . S:$D(^UTILITY($J,XB("ROU"))) XB("ROU")=$O(^UTILITY($J,XB("ROU")),-1)
 . F XB("RKT")=0:1 S XB("ROU")=$O(^UTILITY($J,XB("ROU"))) Q:$E(XB("ROU"),1,$L(XB("NSP")))'=XB("NSP")  D SRCH1
 . D:XB("RKT")>0 SRCH2
 .Q
 ;S XB("NSP")="~~",XB("ROU")="";IHS/SET/GTH XB*3*9 10/29/2002
 S XB("NSP")="~~",XB("ROU")=0 ;IHS/SET/GTH XB*3*9 10/29/2002
 F XB("RKT")=0:1 S XB("ROU")=$O(^UTILITY($J,XB("ROU"))) Q:XB("ROU")=""  D
 . S XB("NAM")="",XB("VER")=0
 . D SRCH1
 .Q
 S XB("NAM")="%",XB("VER")=0
 D:XB("RKT")>0 SRCH2
 Q
 ;
SRCH1 ;
 D:'$D(ZTQUEUED)
 . W:'(XB("RKT")#8) !
 . W XB("ROU"),$J("",9-$L(XB("ROU")))
 .Q
 S XCNP=0,DIF="^TMP("_$J_",""R"","""_XB("ROU")_""",",X=XB("ROU")
 X ^%ZOSF("TEST")
 Q:'$T
 X ^%ZOSF("LOAD")
 S XB("PPC")=$TR($P($G(^TMP($J,"R",XB("ROU"),2,0)),";",5),"*","")
 D:XB("PPC")]""&(XB("PPC")'=0)
 . S:XB("NAM")="" XB("NAM")=$P($G(^TMP($J,"R",XB("ROU"),2,0)),";",4)
 . S:XB("VER")=0 XB("VER")=$P($G(^TMP($J,"R",XB("ROU"),2,0)),";",3)
 . S XB("DESC")=$S($P($P($G(^TMP($J,"R",XB("ROU"),1,0)),";",2),"-",2,3)'="":$P($P($G(^TMP($J,"R",XB("ROU"),1,0)),";",2),"-",2,3),1:$P($G(^TMP($J,"R",XB("ROU"),1,0)),";",3))
 . F  Q:$E(XB("DESC"))'=" "  S XB("DESC")=$E(XB("DESC"),2,99)
 . D:XB("VER")]""&(XB("NAM")]"")
 ..  F XB("J")=1:1 S XB("PNR")=$P(XB("PPC"),",",XB("J")) Q:XB("PNR")=""  D:XB("PNR")?1.4N
 ...   S ^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),XB("PNR"),XB("ROU"))=XB("DESC")
 ...   S ^TMP($J,"P","P",XB("PNR"))=""
 ...   S ^TMP($J,"P","R",XB("ROU"))=""
 KILL ^TMP($J,"R",XB("ROU")),^UTILITY($J,XB("ROU"))
 Q
 ;
SRCH2 ;
 W:'$D(ZTQUEUED) !!?5,XB("RKT")," Routines Processed",!!
 S (XB("PNR"),XB("ROU"))=""
 F XB("PKT")=0:1 S XB("PNR")=$O(^TMP($J,"P","P",XB("PNR"))) Q:XB("PNR")=""
 F XB("PRK")=0:1 S XB("ROU")=$O(^TMP($J,"P","R",XB("ROU"))) Q:XB("ROU")=""
 KILL ^TMP($J,"P","P"),^TMP($J,"P","R")
 S ^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),.01)=XB("RKT")
 S ^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),.02)=XB("PKT")
 S ^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),.03)=XB("PRK")
 Q
 ;
SCHDR ;
 W !,?IOM-$L(XB("HD1"))\2,XB("HD1"),!,?IOM-$L(XB("HD2"))\2,XB("HD2"),!
 Q
 ;
PRT ;
 S XB("PAGE")=0,XB("NSP")=""
 D:'$D(ZTQUEUED)
 . S IOP=XB("IOP")
 . D ^%ZIS
 .Q
 U IO
 D HDR
 F  S XB("NSP")=$O(^TMP($J,"P",XB("NSP"))) Q:XB("NSP")=""!(XB("END"))  D
 . S XB("NAM")=""
 . F  S XB("NAM")=$O(^TMP($J,"P",XB("NSP"),XB("NAM"))) Q:XB("NAM")=""!(XB("END"))  D
 .. D:XB("NAM")="%"
 ... W !!,"****",?5,"ROUTINES THAT ARE NOT IN PACKAGE FILE NAME-SPACE"
 ... W !?5,^TMP($J,"P",XB("NSP"),"%",0,.01)," TOTAL ROUTINE(s): "
 ... W ^TMP($J,"P",XB("NSP"),"%",0,.02)," PATCHE(s) in "
 ... W ^TMP($J,"P",XB("NSP"),"%",0,.03)," ROUTINE(s)",!
 ... S XB("NAM")=$O(^TMP($J,"P",XB("NSP"),XB("NAM")))
 .. S XB("END")=(XB("NAM")="")
 .. Q:XB("END")
 .. S XB("VER")=.5
 .. F  S XB("VER")=$O(^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"))) Q:XB("VER")=""!(XB("END"))  D
 ... D:$Y+5>IOSL HDR
 ... Q:XB("END")
 ... W !!,XB("NSP"),?5,XB("NAM")," -- Version: ",XB("VER")
 ... D:XB("NSP")'="~~"
 .... W !?5,^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),.01)," TOTAL ROUTINE(s): "
 .... W ^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),.02)," PATCHE(s) in "
 .... W ^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),.03)," ROUTINE(s)",!
 ... S XB("PNBR")=.5
 ... F  S XB("PNBR")=$O(^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),XB("PNBR"))) Q:XB("PNBR")=""!(XB("END"))  D
 .... S XB("ROU")=""
 .... F  S XB("ROU")=$O(^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),XB("PNBR"),XB("ROU"))) Q:XB("ROU")=""!(XB("END"))  D
 ..... D:$Y+5>IOSL HDR
 ..... Q:XB("END")
 ..... W !,$J(XB("PNBR"),4),?5,XB("ROU"),?14,^TMP($J,"P",XB("NSP"),XB("NAM"),XB("VER"),XB("PNBR"),XB("ROU"))
 Q
 ;
HDR ;
 NEW DIRUT,DUOUT
 D:XB("PAGE")&($E(IOST,1,2)="C-")&(IO=IO(0))
 . S Y=$$DIR^XBDIR("E")
 . S:$D(DIRUT)!($D(DUOUT)) XB("END")=1
 .Q
 Q:XB("END")
HDR1 ;
 D:$D(IO("S"))&('XB("PAGE"))
 . S (DX,DY)=0
 . X ^%ZOSF("XY")
 .Q
 W:$E(IOST,1,2)="C-"!(($E(IOST,1,2)'="C-")&(XB("PAGE"))) @IOF
HDR2 ;
 S XB("PAGE")=XB("PAGE")+1
 W !,?IOM-$L(XB("HD1"))\2,XB("HD1"),?(IOM-15),"PAGE: ",$J(XB("PAGE"),3)
 W !,?IOM-$L(XB("HD2"))\2,XB("HD2")
 W !,"PATCH"
 W !,"NMBR",?5,"ROUTINE",?14,"ROUTINE DESCRIPTION"
 W !,"==== ======== ",$$REPEAT^XLFSTR("=",IOM-19)
 Q
 ;
EXIT ;
 D ^%ZISC
 KILL ^UTILITY($J),^TMP($J)
 Q
 ;
