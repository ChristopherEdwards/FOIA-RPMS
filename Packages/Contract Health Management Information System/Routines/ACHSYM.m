ACHSYM ; IHS/ITSC/PMF - CHS PROGRAMMER UTILITIES MENU DRIVER ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**11,12,13,18**;JUN 11, 2001
 ;ITSC/SET/JVK ACHS*3.1*11 ADDED THE 4 YEAR EXPORT CALL
 ;ITSC/SET/JVK ACHS*3.1*12 REMOVE THE 4 YEAR EXPORT CALL
 ;ACHS*3.1*13 12.7.06 IHS/OIT/FCJ ADDED ACHSRMVD TO MENU OPTIONS
 ;
 ;  Note:  If you want any other routines to appear on the programmer
 ;         utility menu produced by this routine, add the name of the
 ;         routine after the label R.
 ;
 D HOME^%ZIS,DT^DICRW,^XBKTMP:$L($T(^XBKTMP))
 I '$$RSEL^ZIBRSEL("ACHSY*","^TMP(""ACHSYM"",$J,") W !,"No ""ACHSY*"" Routines to process..." Q
 K ^TMP("ACHSYM",$J,"ACHSYM") ; Don't show THIS routine.
 F %=1:1 S X=$P($T(R+%),";",3) Q:X="###"  S ^TMP("ACHSYM",$J,X)=""
START ;
 W @IOF,!!,$$C^XBFUNC("***   "_$P($P($T(+1),"-",2),";",1)_"   ***"),!!
 N ACHS,C,R
 S R=""
 F C=1:1 S R=$O(^TMP("ACHSYM",$J,R)) Q:'$L(R)  D
 . S X=R,DIF="^TMP(""ACHSYM"",$J,""R"",",XCNP=0
 . X ^%ZOSF("LOAD")
 . S ACHS(C)=R_U_$P($P($G(^TMP("ACHSYM",$J,"R",1,0)),"-",2),";",1)
 . W !,$J(C,2),". ",U,R," -",$P(ACHS(C),U,2)
 . I (R="ACHSYCN")!(R="ACHSYCS") W !,?6,"No longer available for UFMS type records" ;ACHS*3.1*18 IHS/OIT/FCJ ADDED NEW LINE
 . K ^TMP("ACHSYM",$J,"R")
 .Q
 S ACHS=$$DIR^XBDIR("FO^1:"_($L(C)+1),"     Select # to run or ""?#"" for help","","","","",1)
 Q:$D(DUOUT)!$D(DTOUT)!('$L(ACHS))
 I ACHS?1"?"1N.E,+$E(ACHS,2,99)>0,+$E(ACHS,2,99)<C D HELP($P(ACHS(+$E(ACHS,2,99)),U))
 Q:$D(DUOUT)!$D(DTOUT)
 I ACHS,ACHS>0,ACHS<(C+1) D RUN($P(ACHS(ACHS),U)) I 1
 E  W *7,"    ??"
 G START
 ;
HELP(R) ; 
 N ACHS,ACHSGURF,C,QT
 S QT=""""
 S ACHSGURF="K"_" ^UTILIT"_"Y("_$J_")"
 X ACHSGURF
 S ACHSGURF="S"_" ^UTILIT"_"Y("_$J_","_QT_R_QT_")="_QT_QT
 X ACHSGURF
 D EN^XBRPTL
 S C=$$DIR^XBDIR("EO")
 Q
 ;
RUN(R) ;
 N ACHS,C
 D @(U_R)
 S C=$$DIR^XBDIR("EO")
 Q
 ;
 ;ACHS*3.1*13 12.7.06 IHS/OIT/FCJ ADDED ACHSRMVD TO MENU OPTIONS
R ; Non-namespaced routines that you want to appear on the menu.
 ;;ACHSSTL
 ;;ACHSBRF
 ;;ACHSRMVD
 ;;###
 ;;;ACHSTXP-REMOVED ACHS*3.1*12
