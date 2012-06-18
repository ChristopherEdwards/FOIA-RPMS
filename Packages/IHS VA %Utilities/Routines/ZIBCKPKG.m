ZIBCKPKG ; IHS/ADC/GTH - CHECK UCI FOR PACKAGE CONTENT ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Change MSM systax to use $ROUTINE.
 D INIT
 S XBQUEST=1 D ASKIT G:XBQ=U EXIT S XBINPR=XBQ
 S XBQUEST=2 D ASKIT G:XBQ=U EXIT S XBLC=XBQ
 S XBQUEST=3 D ASKIT G:XBQ=U EXIT S XBLNPR=XBQ
 ;
ZIS ; SELECT DEVICE
 KILL ZTSK,IOP,%ZIS
 S %ZIS="PQM"
 D ^%ZIS
 G:POP EXIT
 G:$D(IO("Q")) QUE
NOQUE ;
 U IO
 D EN
 D ^%ZISC
 G EXIT
 ;
QUE ;
 KILL ZTSAVE
 F %="XBINPR","XBLNPR","XBLC" S ZTSAVE(%)=""
 S ZTRTN="EN^ZIBCKPKG",ZTDESC="SCAN UCI FOR PACKAGES",ZTIO=IO,ZTDTH=0
 D ^%ZTLOAD
 KILL ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
EXIT ;
 D KILLS
 Q
 ;
EN1 ; ENTRY FOR SILENT OPERATION
 D INIT
 S (XBINPR,XBLC)=1
 G EN
 ;
INIT ; INITIALIZATION
 S U="^"
 S:'$D(DTIME) DTIME=300
 Q
 ;
EN ; COMMON INTERNAL ENTRY
 S XBQUIT=0
 KILL ^UTILITY($J,"ZIBCKPKG")
 D SCAN
 Q:XBQUIT
 D:XBLNPR SHOWNPR
 D:XBLC SHOWLC
 I $D(IOST),$D(IOF),$E(IOST,1,2)="P-" W @IOF
 SET:$D(ZTQUEUED) ZTREQ="@"
KILLS ;
 KILL XBINPR,XBRNPR,XBLNPR,XBLC,XBQUIT,XBR,XBR2,XBPF,XBI,XBJ,XBP,XBQ,XBCNT,XBQUEST
 KILL ^UTILITY($J,"ZIBCKPKG"),ZTSK
 Q
 ;
SCAN ;
 X ^%ZOSF("UCI")
 W "- - - PACKAGE SCAN OF UCI ",Y,$S($D(^DD("SITE")):" ON "_^("SITE"),1:"")," - - -",!!
 ; S XBR=$O(^ ("%zzzzzzz")) ;IHS/SET/GTH XB*3*9 10/29/2002
 S XBR=$O(^$R("%zzzzzzz")) ;IHS/SET/GTH XB*3*9 10/29/2002
 F  Q:XBR=""  Q:XBR?1L.E  D CHKPKG Q:XBQUIT
 Q:XBQUIT
 F  Q:XBR=""  D GETNXT
 Q
 ;
CHKPKG ; CHECK FOR PACKAGE
 S XBPF=$E(XBR,1,4)
 F XBI=$L(XBPF):-1:0 S XBPF=$E(XBPF,1,XBI) Q:XBPF=""  S XBP=$O(^DIC(9.4,"C",XBPF,0)) Q:XBP
 I XBPF=""  D NOTPKG Q
 W XBPF,?4," - ",$P(^DIC(9.4,XBP,0),U,1)
 S XBRNPR=0
 D SKIP
 W " (",XBCNT,")",!
 Q
 ;
NOTPKG ;
 I XBINPR S ^UTILITY($J,"ZIBCKPKG",2,XBR)="" S XBPF="" D GETNXT Q
 F  W XBR R " -- Package prefix? ",XBPF:DTIME S:'$T XBPF=U Q:XBPF[U  D GETPKG Q:XBPF'="-"
 I XBPF[U S XBQUIT=1 Q
 W !
 I XBPF="" D GETNXT Q
 S XBI=$L(XBPF),XBRNPR=1
 D SKIP
 W " ",XBCNT," ROUTINES SKIPPED.",!
 Q
 ;
GETPKG ;
 I XBPF?1."?" S XBQUEST=4 D DSPHLP W ! S XBPF="-" Q
 I XBPF?1."?"1.E D DSPLY S XBPF="-" Q
 Q:XBPF'?.E1CL.E&($L(XBPF)<5)
 W " -- Package id must be upper case, length 1-4",!
 S XBPF="-"
 Q
 ;
SKIP ;
 F XBCNT=1:1 S:XBRNPR ^UTILITY($J,"ZIBCKPKG",2,XBR)="" D GETNXT Q:$E(XBR,1,XBI)'=XBPF
 Q
 ;
GETNXT ;
 S:XBR?.E1L.E ^UTILITY($J,"ZIBCKPKG",1,XBR)=""
 ; S XBR=$O(^ (XBR)) ;IHS/SET/GTH XB*3*9 10/29/2002
 S XBR=$O(^$R(XBR)) ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
DSPLY ;
 S (XBPF,XBR2)=$E(XBPF,2,$L(XBPF))
 W !
 S XBJ=0
 S X=XBR2
 X ^%ZOSF("TEST")
 I  S XBJ=1 W !,XBR2
 ; F XBJ=XBJ:1 S XBR2=$O(^ (XBR2)) Q:$E(XBR2,1,$L(XBPF))'=XBPF  W:XBJ#8=0 ! W ?XBJ#8*10,XBR2 ;IHS/SET/GTH XB*3*9 10/29/2002
 F XBJ=XBJ:1 S XBR2=$O(^$R(XBR2)) Q:$E(XBR2,1,$L(XBPF))'=XBPF  W:XBJ#8=0 ! W ?XBJ#8*10,XBR2 ;IHS/SET/GTH XB*3*9 10/29/2002
 W:$X !
 W !
 Q
 ;
SHOWNPR ;
 Q:'$D(^UTILITY($J,"ZIBCKPKG",2))
 W !!,"Non-package routines:",!
 S XBR2=""
 F XBJ=0:1 S XBR2=$O(^UTILITY($J,"ZIBCKPKG",2,XBR2)) Q:XBR2=""  W:XBJ#8=0 ! W ?XBJ#8*10,XBR2
 W !
 Q
 ;
SHOWLC ;
 Q:'$D(^UTILITY($J,"ZIBCKPKG",1))
 W !!,"Routine names containing lower case letters:",!
 S XBR2=""
 F XBJ=0:1 S XBR2=$O(^UTILITY($J,"ZIBCKPKG",1,XBR2)) Q:XBR2=""  W:XBJ#8=0 ! W ?XBJ#8*10,XBR2
 W !
 Q
 ;
ASKIT ; ASK A YES/NO QUESTION
 KILL XBQ
 S %=$T(@XBQUEST),XBQ("Q")=$P(%,";;",2),XBQ("D")=$P(%,";;",3)
ASKIT2 ;
 W !,XBQ("Q")," ",XBQ("D"),"// "
 R XBQ:DTIME
 S:'$T XBQ=U
 I XBQ="" S XBQ=XBQ("D") W XBQ
 S XBQ("R")=XBQ,XBQ=""
 I XBQ("R")[U S XBQ=U
 I $P("YES",XBQ("R"))="" S XBQ=1
 I $P("yes",XBQ("R"))="" S XBQ=1
 I $P("NO",XBQ("R"))="" S XBQ=0
 I $P("no",XBQ("R"))="" S XBQ=0
 I XBQ]"" W ! Q
 W !,"-- Please answer YES or NO"
 D DSPHLP
 G ASKIT
 ;
DSPHLP ;
 F XBI=1:1 S %=$T(@XBQUEST+XBI) Q:%=""  Q:$P(%," ")]""  W !,"-- ",$P(%,";;",2)
 W !
 KILL %
 Q
 ;
QUEST ;
 ;
1 ;;Ignore non-package routines?;;YES
 ;;Responding NO will cause you to be asked if a routine for which
 ;;a namespace cannot be identified in the package file can be
 ;;considered part of a "psuedo-package" with which a namespace can
 ;;be associated.
2 ;;Display routine names containing lower case letters?;;YES
 ;;Responding YES will cause a tabular listing to be produced
 ;;displaying all routine names which contain a lower case letter.
3 ;;Display names of non-package routines?;;YES
 ;;Responding YES will cause a tabular listing to be produced
 ;;displaying the names of all routines which were not found
 ;;to be part of a package.
4 ;;
 ;;If you enter a namespace, routines will be processed as though a
 ;;formal package association was made.
