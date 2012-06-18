XBGCMP ; IHS/ADC/GTH - COMPARES TWO DIFFERENT GLOBALS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ;;This utility is to be used to compare two globals.  The initial
 ;;globals entered must be identically subscripted.  The utility will
 ;;indicate which nodes of the first global have values different
 ;;than similarly subscipted nodes of the second global.  It will
 ;;also indicate if a node in one global exists and if a similarly
 ;;subscripted node in the other does not exist.  You may utilize the
 ;;[UCI,VOLUME] syntax to compare across UCIs and volume groups.
 ;;  
 ;;###
 ;
 NEW X
 D INIT
A ;
 D ASK
 I XBQ G X1
 D SETUP ; sets up up print/display, calls subrtn to process gbls
 G A
X1 ;
 D EOJ
 Q
 ;
INIT ; Setup
 D ^XBKVAR
 S (XBS,XBQ)=0
 X ^%ZOSF("UCI")
 S XBVOL=$P(Y,",",2)
 Q
 ;
ASK ; Get globals to be compared
1 ;
 R !,"First global to compare, i.e., NAME, NAME(1) or NAME(""B""): ^",X:DTIME
 D:X["?" HELP^XBHELP("XBGCMP","XBGCMP")
 G:X["?" 1
 I "^"[X S XBQ=1 G X2
 D CHECK
 I XBS S XBS=0 G 1
 S XBG1=X
2 ;
 R !,"Second global to compare: ^",X:DTIME
 D:X["?" HELP^XBHELP("XBGCMP","XBGCMP")
 G:X["?" 2
 I "^"[X S XBQ=1 G X2
 D CHECK
 I XBS S XBS=0 G 2
 S XBG2=X
 D CHECK2
 I XBS S XBS=0 G 1
X2 ;
 Q
 ;
CHECK ; Check each global
 I X["(",X'[")" S XBS=1 W !,*7,"  Must end in "")""" G X6
 S XBT=$P(X,"(")
 I XBT["[" D
 . I XBT'["]" W !,*7,"  Invalid cross UCI notation" S XBS=1 G X4
 . S XBT=$P(XBT,"]")
 . I XBT["""" F XBI=1:1:$L(XBT)  I $E(XBT,XBI)="""" S $E(XBT,XBI)="",XBI=XBI-1
 . I XBT?1"["3U1","3U!(XBT?1"["3U)
 . E  W !,*7,"  Invalid cross UCI notation" S XBS=1 G X4
 . I XBT'[","!($P(XBT,",",2)'=XBVOL) S X="["""_$P(XBT,"[",2)_"""]"_$P(X,"]",2) G X4
 . S X="["""_$P($P(XBT,"[",2),",")_"""]"_$P(X,"]",2)
X4 . Q
 S XBT(1)=$S($P(X,"(")["[":$P($P(X,"]",2),"("),1:$P(X,"("))
 I $L(XBT(1))>8 W !,*7,"  Invalid global name" S XBS=1 G X6
 I XBT(1)?1A.AN!(XBT(1)?1"XB".AN)
 E  W !,*7,"  Invalid global name" S XBS=1 G X6
 S XBT(2)=X,X="TRAP^XBGCMP",@^%ZOSF("TRAP"),X=XBT(2)
 I '$D(@("^"_X)) W !,*7,"  Global does not exist" S XBS=1
X6 ;
 Q
 ;
TRAP ; Error trap for missing quotes
 I $$Z^ZIBNSSV("ERROR")["<UNDEF" W !,*7,"*** Probably missing quotes",! S XBS=1
 Q
 ;
CHECK2 ; Check both globals
 I (XBG1["("&(XBG2'["("))!(XBG1'["("&(XBG2["(")) W !,*7,"  Starting globals must be identically subscripted",! S XBS=1 G X5
 I XBG1'["("
 E  I $P(XBG1,"(",2)'=$P(XBG2,"(",2) W !,*7,"  Starting globals must be identically subscripted",! S XBS=1 G X5
 E  I $E(XBG1,$L(XBG1))'=")"!($E(XBG2,$L(XBG2))'=")") W !,*7,"  Starting globals must end in a "")""",! S XBS=1
X5 ;
 Q
 ;
SETUP ; Get print parameters, task?
 KILL ZTSK,IOP,%ZIS
 S %ZIS="PQM"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D QUE I 1
 E  D NOQUE
 Q
 ;
NOQUE ;
 S ^DISV($I,"^%ZIS(1,")=$O(^%ZIS(1,"C",IO,""))
 U IO
 D PROCESS
 D ^%ZISC
 Q
 ;
QUE ;
 S XBION=ION
 KILL ZTSAVE
 F %="XBG1","XBG2","XBION" S ZTSAVE(%)=""
 S ZTRTN="PROCESS^XBGCMP",ZTDESC="COMPARE TWO GLOBALS",ZTIO="",ZTDTH=""
 D ^%ZTLOAD
 KILL ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 D ^%ZISC
 W !
 Q
 ;
PROCESS ; Compare
 S XBG1="^"_XBG1,XBG2="^"_XBG2,XBN=$J_$H,XBC=0
 I '$D(ZTQUEUED) W:$D(IOF) @IOF W !!,"Comparison of globals ",XBG1," and ",XBG2,!
 I $D(@XBG1)#2,'($D(@XBG2)#2) S XBC=XBC+1,XBTEMP=XBG1 D CHANGE S ^TMP("XBGCMP",XBN,XBTEMP)=XBG1_"   Exists~"_XBG2_"   Missing"
 I '($D(@XBG1)#2),$D(@XBG2)#2 S XBC=XBC+1,XBTEMP=XBG1 D CHANGE S ^TMP("XBGCMP",XBN,XBTEMP)=XBG1_"   Missing~"_XBG2_"   Exists"
 I $D(@XBG1)#2,$D(@XBG2)#2,'(@XBG1=@XBG2) S XBTEMP=XBG1 D CHANGE S XBC=XBC+1,^TMP("XBGCMP",XBN,XBTEMP)=XBG1_"   Not Equal To~"_XBG2
 S XBA=$P(XBG1,"("),XBB=$P(XBG2,"("),XB=XBG1
 F  S XB=$Q(@XB) Q:XB=""  D
 . I '($D(@(XBB_$P(XB,XBA,2)))#2) S XBC=XBC+1,XBTEMP=XB D CHANGE S ^TMP("XBGCMP",XBN,XBTEMP)=XB_"   Exists~"_XBB_$P(XB,XBA,2)_"   Missing" G X3
 . I @XB'=@(XBB_$P(XB,XBA,2)) S XBC=XBC+1,XBTEMP=XB D CHANGE S ^TMP("XBGCMP",XBN,XBTEMP)=XB_"   Not Equal To~"_XBB_$P(XB,XBA,2)
X3 . Q
 S XBA=$P(XBG2,"("),XBB=$P(XBG1,"("),XB=XBG2
 F  S XB=$Q(@XB) Q:XB=""  D
 . I '($D(@(XBB_$P(XB,XBA,2)))#2) S XBC=XBC+1,XBTEMP=XBB_$P(XB,XBA,2) D CHANGE S ^TMP("XBGCMP",XBN,XBTEMP)=XBB_$P(XB,XBA,2)_"   Missing~"_XB_"   Exists"
 I '$D(ZTQUEUED) D PRINT I 1
 E  D SCHED
 Q
 ;
CHANGE ; Temp change double quotes to single
 I XBTEMP["""" S XBTMP="",XBQTE=$L(XBTEMP,"""") F XBI=1:1:(XBQTE-1) S XBTMP=XBTMP_$P(XBTEMP,"""",XBI)_"" I XBI=(XBQTE-1) D
 . S XBTEMP=XBTMP_$P(XBTEMP,"""",XBQTE)
 KILL XBTMP,XBQTE
 Q
 ;
PRINT ; Prints or displays results
 I $D(ZTQUEUED) W:$D(IOF) @IOF W !!,"Comparison of globals ",XBG1," and ",XBG2,!
 S XBL=IOSL-3,XB=""
 F  S XB=$O(^TMP("XBGCMP",XBN,XB)) Q:XB=""  D  I XBL'>0 D PAUSE Q:$G(XBSTP)  S XBL=IOSL-3 W !
 . I $L(^TMP("XBGCMP",XBN,XB))>76 W !,$P(^(XB),"~"),!,$P(^(XB),"~",2),! S XBL=XBL-3.25
 . E  W !,$P(^TMP("XBGCMP",XBN,XB),"~"),"   ",$P(^(XB),"~",2),! S XBL=XBL-2
 I '$G(XBSTP) W !,"Comparison completed with ",XBC," difference",$S(XBC'=1:"s",1:"")," found.",!
 KILL ^TMP("XBGCMP",XBN)
 I $D(ZTQUEUED) S ZTREQ="@" D EOJ
 Q
 ;
PAUSE ; Quit display?
 I $E(IOST,1,2)="C-" S Y=$$DIR^XBDIR("E") S:$D(DIRUT)!($D(DUOUT)) XBSTP=1 KILL DIRUT,DUOUT W !
 Q
 ;
SCHED ; Schedules another task to print
 KILL ZTSAVE
 F %="XBN","XBG1","XBG2","XBC" S ZTSAVE(%)=""
 S ZTRTN="PRINT^XBGCMP",ZTDESC="PRINT COMPARISON OF TWO GLOBALS",ZTIO=XBION,ZTDTH=DT
 D ^%ZTLOAD
 KILL ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
 ;
EOJ ;
 KILL XB,XBA,XBB,XBC,XBI,XBL,XBG1,XBG2,XBION,XBN,XBQ,XBS,XBSTP,XBT,XBTEMP,XBTMP,XBVOL
 Q
 ;
HELP ;EP - Dooda about the utility
 ;;@;!
