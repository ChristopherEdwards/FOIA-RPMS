XBTM ; IHS/ADC/GTH - TECH MANUAL : MAIN ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine, and subsequent routines in the XBTM*
 ; namespace, produce a technical manual from information
 ; contained in the package.  The manual is approximately 80
 ; pages.  All, or individual chapters can be printed.
 ;
 D HOME^%ZIS,DT^DICRW
 NEW DIR,XBSEL
SEL ;
 S XBSEL=$$DIR^XBDIR("S^1:only one chapter;A:All chapters","Print 1 chapter, or all?  1/A","1")
 S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I XBSEL S XBSEL=$$DIR^XBDIR("N^1:15:0","Which chapter?","","","","^D CHAPS^XBTM") S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
DEV ;
 S %ZIS="OPQ"
 D ^%ZIS
 I POP S IOP=$I D ^%ZIS G K
 G:'$D(IO("Q")) START
 KILL IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 S ZTRTN="START^XBTM",ZTDESC="TECHNICAL MANUAL.",ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL,ZTSAVE("XBSEL")=""
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
K ;
 KILL XB,ZTSK
 D ^%ZISC
 G END
 ;
START ;EP - TaskMan.
 NEW DIWL,DIWR,DIWF,XBBM,XBCONT,XBSAVX,XBTM,XBTITL,XBPG,XBHDR,XBHDRE,XBHDRO,XBDASH
 D ^XBKTMP
 S DIWL=10,DIWR=74,DIWF="W",XBBM=IOSL-5,XBTM=6,XBTITL="IHS/VA UTILITIES TECHNICAL MANUAL",XBPG=0,XBHDR="Index",(XBHDRE,XBHDRO)="",XBDASH="",$P(XBDASH,"-",81)="",XBDASH=$E(XBDASH,DIWL,DIWR)
 U IO
 I 'XBSEL D ^XBTMI S DIWF="WN" D ^XBTMTI W @IOF S DIWF="W" D ^XBTMPR W @IOF
BODY ;
 S (XBCONT,XBHDR,XBPG)=0
 KILL ^TMP("XBTM-CONTENTS",$J)
 I XBSEL S XBCHAP=XBSEL D MAKEHDRS,TOF Q:$D(DUOUT)  D HDR(XBCHAP),@("^XBTM"_XBCHAP) G END
 F XBCHAP=1:1:15  D MAKEHDRS,TOF Q:$D(DUOUT)  D HDR(XBCHAP),@("^XBTM"_XBCHAP)
 ;
INDEX ;
 S XBHDR="Index"
 D TOF
 G:$D(DUOUT) HAT
 W !!!
 S X="|NOWRAP||SETTAB(""C"")||TAB|INDEX"
 D ^DIWP,^DIWW
 W !!!
 D CONT("INDEX^^"_XBPG)
 S (XB,XBCONT)="",$P(XBCONT,".",81)=""
 F  S XB=$O(^TMP("XBTM-INDEX",$J,XB)) Q:XB=""  Q:$D(DUOUT)  S X="" D
 .F XBX=0:0 S XBX=$O(^TMP("XBTM-INDEX",$J,XB,XBX)) Q:$D(DUOUT)  S X=X_XBX_"," I '$O(^(XBX)) D  Q
 ..S X=XB_$E(XBCONT,1,DIWR-DIWL-$L(XB)-$L(X))_$E(X,1,$L(X)-1)
 ..S XBSAVX=X
 ..F  S X=$E(XBSAVX,1,DIWR-DIWL),XBSAVX=$E(XBSAVX,DIWR-DIWL+1,$L(XBSAVX)) Q:'$L(X)  D TOF:$Y>XBBM Q:$D(DUOUT)  D ^DIWP
 ..Q
 .Q
 D ^DIWW,PAUSE^XB
 G:$D(DUOUT) HAT
 ;
CONTENTS ;
 W @IOF,!!!!!
 S X="|SETTAB(""C"")||TAB|CONTENTS"
 D ^DIWP,^DIWW
 W !!
 S XB=0
 F  S XB=$O(^TMP("XBTM-CONTENTS",$J,XB)) Q:'+XB  S X=^(XB),X=$P(X,U)_" "_$P(X,U,2)_$E(XBCONT,1,DIWR-DIWL-$L(X)+1)_$P(X,U,3) D TOF:$Y>XBBM Q:$D(DUOUT)  D ^DIWP
 G:$D(DUOUT) HAT
 D ^DIWW,PAUSE^XB
 G:$D(DUOUT) HAT
END ;
 D PAUSE^XB
 G:$D(DUOUT) HAT
 W @IOF
HAT ;     
 D ^%ZISC
 KILL XB,XBBM,XBCHAP,XBCONT,XBODD,XBHDR,XBIEN,XBPARA,XBPG,XBROOT,XBTITL,XBTM,XBX,XBY,DIC,DIWF,DIWL,DIWR
 D ^XBKTMP
 Q
 ;
TEXT(XBLAB) ;
 F XB=1:1 S X=$P($T(@XBLAB+XB),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 Q
 ;
PR(X) ;EP
 I X="|TOP|" D TOF Q
 D INDX(X),^DIWP,TOF:$Y>XBBM
 Q
 ;
INDX(X) ;
 Q:'$D(XBPG)
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S %=""
 F  S %=$O(^TMP("XBTM-I",$J,%)) Q:'$L(%)  I $F(X,%) S ^TMP("XBTM-INDEX",$J,%,XBPG)=""
 Q
 ;
HDR(XB) ;
 F X="|SETTAB(""C"")||TAB|Chapter "_XB,"|SETTAB(""C"")||TAB|"_$P($T(@XB),";",3) D ^DIWP
 W !!
 D CONT(XB_U_$P($T(@XB),";",3)_U_XBPG)
 Q
 ;
TOF ;EP
 F  Q:$Y>XBBM  W !
 I XBPG>0 W !?(DIWL-1),XBDASH,!,?$S(XBODD:DIWR-$L(XBTITL),1:DIWL-1),XBTITL
 D PAUSE^XB
 Q:$D(DUOUT)
 W @IOF
 S XBPG=XBPG+1,XBODD=XBPG#2
 F  Q:$Y=(XBTM-2)  W !
 W ?$S(XBODD:DIWR-$L("Page "_XBPG),1:DIWL-1),"Page ",XBPG
 I '(XBHDR="Index") W !?DIWL-1,$S(XBODD:XBHDRO,1:XBHDRE)
 W !?(DIWL-1),XBDASH,!!
 Q
 ;
MAKEHDRS ; 
 S (XBHDRE,XBHDRO)=$P($T(@XBCHAP),";",3)
 S XBHDRO=XBHDRO_$J("",DIWR-DIWL-$L(XBHDRO)-$L("Chapter "_XBCHAP)+1)_"Chapter "_XBCHAP
 S XBHDRE="Chapter "_XBCHAP_$J("",DIWR-DIWL-$L(XBHDRE)-$L("Chapter "_XBCHAP)+1)_XBHDRE
 Q
 ;
CONT(X) ;
 S XBCONT=XBCONT+1,^TMP("XBTM-CONTENTS",$J,XBCONT)=X
 Q
 ;
CHAPS ;EP - From DIR
 F %=1:1:15 W !?3,$J(%,2),". ",$P($T(@%),";",3)
 Q
1 ;;Facility Parameters
2 ;;Area Office Parameters
3 ;;Security Keys
4 ;;Options
5 ;;Fields in Files
6 ;;Archiving and Purging
7 ;;Callable Routines
8 ;;External Relations
9 ;;Internal Relations
10 ;;How to Generate On-Line Documentation
11 ;;Glossary
12 ;;System Requirements
13 ;;Installation notes
14 ;;Enhancements
15 ;;KILL of Unsubscripted Globals
