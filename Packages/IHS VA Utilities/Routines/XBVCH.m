XBVCH ; IHS/ADC/GTH - CHANGE VARIABLE NAMES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Thanks to Paul Wesley, DSD/OIRM, for the original routine.
 ;
 I '$D(IOST(0)) D HOME^%ZIS
 S XBJ=$J
 D EXIT^XBVCH
 S XBJ=$J
 S X="IORVON;IORVOFF;IOUON;IOUOFF;IOINHI;IOINORM;IOAWM0;IOAWM1"
 D ENDR^%ZISS
 S XBD(0)=IOUON,XBD(1)=IOUOFF,XBD(2)=IORVON,XBD(3)=IORVOFF,XBD(4)=IORVON,XBD(5)=IORVOFF,XBD(6)=IOAWM0,XBD(7)=IOAWM1,XBXY=IOXY
 D KILL^%ZISS
 S XBP=" #&'()*+,'-/<=>@\_?;:[]!"""
 S XBS=" #&'()*+,'-/<=>@\_?;:[]!"""
 KILL DIR
 S DIR(0)="Y",DIR("B")="Y",DIR("A")="Do you have a %INDEX Summary in a Host File to work with ? "
 D ^DIR
 KILL DIR
 D:Y=1 ^XBVCHV
START ;
 KILL XBV0,XBV1,XBV2
V0 ;
 KILL DIR
 S DIR(0)="F:0,8",DIR("A")="Old Variable ? or '^' to exit "
 I $G(XBFILE) S DIR("A")=DIR("A")_" or '|' to see variables "
 D ^DIR
 KILL DIR
 G:(Y="^") EXIT
 I Y["|",$G(XBFILE) S XBV="" D SHOVAR G V0
 I $G(XBFILE),'$D(^XBVROU(XBJ,"V",Y)) W *7 G V0
 S XBV0=Y
V1 ;
 KILL DIR
 S DIR(0)="F:0,8",DIR("A")="New Variable ? or '^' to exit "
 D ^DIR
 KILL DIR
 G:(Y="^") V0
 S XBV1=Y
 I $G(XBFILE),$D(^XBVROU(XBJ,"V",XBV1)) W *7,!!,"FYI >> ",XBV1,"  << Already Exits" KILL DIR S DIR(0)="E" D ^DIR I Y'>0 G V1
 I $D(^XBVROU(XBJ,"NV",XBV1)) W *7,!!,"FYI >> ",XBV1,"  << is a >>NEW VARIABLE<" KILL DIR S DIR(0)="E" D ^DIR I Y'>0 G V1
 ;
V2 ;
 S XBV1L=$L(XBV1)
 I $E(XBV1,XBV1L)=")" S XBV2=$E(XBV1,1,XBV1L-1)_","
SELROU ;
 I '$G(XBFILE) X ^%ZOSF("RSEL") S %X="^UTILITY(XBJ,",%Y="^XBVROU(XBJ,""R""," D %XY^%RCR
 I $G(XBFILE) F XBVI=1:1 Q:'$D(^XBVROU(XBJ,"V",XBV0,XBVI))  S XBVRM=^(XBVI) D
 . I XBVRM'["," S ^XBVROU(XBJ,"R",XBVRM)="" Q
 . F XBVJ=1:1 S XBVR=$P(XBVRM,",",XBVJ) Q:XBVR=""  S ^XBVROU(XBJ,"R",XBVR)=""
 .Q
 ;
 ;----------------------------------------
 ;
PROCESS ;
 D ^XBVCH1
 G START
 ;
 ;--------------------
 ;
SHOVAR ;
 D ^XBCLS
 S XBVAR=""
 F XBI=0:1 S XBVAR=$O(^XBVROU(XBJ,"V",XBVAR)) Q:XBVAR=""  D:'(XBI#120) PAGE Q:X="^"  W:'(XBI#6) ! W ?((XBI#6)*10),XBVAR
 Q
 ;
PAGE ;
 Q:XBI=0
 KILL DIR
 S DIR(0)="E"
 D ^DIR
 Q
 ;
 ;----------------------
EXIT ;EP - Paginat, print, kill, quit.
 D ^XBCLS
 I $D(^XBVROU("PRT",XBJ,"VCHG")) D PRINT
 KILL ^XBVROU(XBJ),^UTILITY(XBJ)
 I '$D(ZTQUEUED) KILL ^XBVROU("PRT",XBJ)
 D EN^XBVK("XB")
 Q
 ;
PRINT ;print variables and routines changed
 ;
 KILL XBRC,XBRP,XBRX
 W !,"Changes were made and a Summary is available",!!
 S XBRP="PRINT1^XBVCH",XBNS="XB*"
 D ^XBDBQUE
 Q
 ;
PRINT1 ; Continue print
 S:'$D(XBJ) XBJ=$J
 S XBPG("HDR")="VARIABLES/ROUTINES CHANGED"
 D XBHDR
 S XBSUB=""
 F  S XBSUB=$O(^XBVROU("PRT",XBJ,"VCHG",XBSUB)) Q:XBSUB=""  D
 . U IO
 . W !!?5,XBSUB
 . S XBROU=""
 . F XBC=2:1 S XBROU=$O(^XBVROU("PRT",XBJ,"VCHG",XBSUB,XBROU)) Q:XBROU=""  D XBPG D
 .. U IO
 .. W ?(10*XBC),XBROU
 .. I (XBC+2)>(IOM\10) S XBC=0 W ! D XBPG
 ..Q
 .Q
 S XBROU=""
 F  S XBROU=$O(^XBVROU("PRT",XBJ,"RCHG",XBROU)) Q:XBROU=""  D XBPG D
 . U IO
 . W !!?5,XBROU
 . S XBSUB=""
 . F XBC=2:1 S XBSUB=$O(^XBVROU("PRT",XBJ,"RCHG",XBROU,XBSUB)) Q:XBSUB=""  D
 .. U IO
 .. W ?(20*XBC),XBSUB
 .. I (XBC+2)>(IOM\20) S XBC=0 W ! D XBPG
 ..Q
 .Q
 Q
 ;
XBPG ;EP PAGE CONTROLLER
 ; this utility uses variables XBPG("HDR"),XBPG("DT"),XBPG("LINE"),XBPG("PG") ; kill variables by D EXBPG
 ;
 Q:($Y<(IOSL-4))!($G(DUOUT))
 S XBPG("PG")=$G(XBPG("PG"))+1
 I $E(IOST)="C" S Y=$$DIR^XBDIR("E") Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT))
XBHDR ;EP write page header
 W:$Y @IOF
 W !
 Q:'$D(XBPG("HDR"))
 S:'$D(XBPG("LINE")) $P(XBPG("LINE"),"-",IOM-2)=""
 S:'$D(XBPG("PG")) XBPG("PG")=1
 I '$D(XBPG("DT")) S %H=$H D YX^%DTC S XBPG("DT")=Y
 U IO
 W ?(IOM-40-$L(XBPG("HDR"))/2),XBPG("HDR"),?(IOM-40),XBPG("DT"),?(IOM-10),"PAGE: ",XBPG("PG"),!,XBPG("LINE")
XBHD ;EP Write column header / message
 W !!
 Q
 ;
EXBPG ;
 KILL XBPG("LINE"),XBPG("PG"),XBPG("HDR"),XBPG("DT")
 Q
 ;
