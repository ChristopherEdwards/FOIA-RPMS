XBHEDD ;402,DJB,5/1/90,EDD - Electronic Data Dictionary
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;FLAGQ='^',FLAGE='^^',FLAGP=Printing on,FLAGP1=Option 11 selected to turn on printing
 ;;FLAGH=Bypass 1st screen
 ;;FLAGS=Scrolling speed set,FLAGL=Last item in list,FLAGM='^' or
 ;;'^^' in menu,FLAGG=No Groups,FLAGNFF=Suppress Form Feed,FLAGPT=Pointer File or Field nonexistent
 ;;FLAGGL=Invalid entry in GLOBAL
TOP ;
 S:'$D(DUZ)#2 DUZ=0 I +DUZ=0 W *7,!!?5,"Your DUZ is not defined!",! Q
 N FLAGE,FLAGG,FLAGGL,FLAGGL1,FLAGL,FLAGM,FLAGP,FLAGP1,FLAGQ,FLAGS
 N A,B,BAR,C,C1,DASHES,DIC,E,EDDDATE,FGRP,FILE,FLD,G,GROUP,GROUP1,GRP1,GRP2,GT,H,HD,I,I2,II,III,IOP,J,K,L,LENGTH,LEVEL,LINE,M1,M2,M3,M4,M5,NORMAL,NUM,O,PAGE,SCROLL,SIZE,SLOW,SPACE,STRING,X,XREF,XREFNAM,XREFTYPE,XX,Y,YCNT
 N Z,Z1,ZA,ZANS,ZAP,ZB,ZCNT,ZD,ZDATA,ZDATA1,ZDSUB,ZFLDNAM,ZFLDNUM,ZGL,ZGL1,ZHELP,ZHNUM,ZLINE,ZLINE1,ZLINE2,ZMULT,ZMZ,ZNAM,ZPOTMP,ZZGL
 N ZNUM,ZONE,ZPAGE,ZPF,ZPO,ZPO1,ZPO2,ZTHREE,ZTWO,ZX,ZY1,ZZ,ZZ1,ZZA,ZZB,ZZH,ZZX
 D INIT
EN S (FLAGP,FLAGQ,FLAGS)=0 K ^UTILITY($J)
 D:'FLAGH HD
 D GETFILE G:FLAGQ EX D MULT^XBHEDD7,MENU G:FLAGE EX
 S FLAGH=1 G EN ;Set FLAGH to bypass opening screen
EX ;Exit
 K FLAGH,FLAGNFF,^UTILITY($J)
 Q
GETFILE ;File lookup
 R !?8,"Select FILE: ",X:DTIME S:'$T X="^" I "^"[X S FLAGQ=1 Q
 I $L(X)>1,$E(X)="^" D GLOBAL^XBHEDD9 G:FLAGGL GETFILE Q
 I X="?" W !?1,"Enter global in the format '^DG' or '^RA(78', or"
 S DIC="^DIC(",DIC(0)="QEM" D ^DIC K DIC I Y<0 G GETFILE
 S ZNUM=+Y,ZNAM=$P(Y,U,2),ZGL=^DIC(ZNUM,0,"GL")
 Q
MENU ;
 S (FLAGE,FLAGG,FLAGL,FLAGM,FLAGQ,FLAGP1,FLAGS)=0
 D HD1,^XBHEDDM G:FLAGP1 MENU I FLAGP S:IO'=IO(0) FLAGQ=1 D PRINT^XBHEDD7 ;Turn off printing
 Q:FLAGM!FLAGE  G:FLAGQ MENU
 I $Y'>SIZE F I=$Y:1:SIZE W !
 R !!?2,"<RETURN> to go to Main Menu, '^' to exit: ",Z1:DTIME S:'$T Z1="^" I Z1="^" S FLAGE=1 Q
 G MENU
DIR ;Supress heading
 S FLAGH=1 G TOP
GL ;Call XBHEDD here to get listing of Globals in ASCII order.
 N FLAGH,FLAGNFF,FLAGP,FLAGQ,M1,M2,M3,M4,M5,SIZE,Z1,ZLINE,ZLINE1,ZLINE2
 S SIZE=(IOSL-5),(FLAGP,FLAGQ)=0 D INIT,GL^XBHEDD10 G EX
PRT ;Stop page feeds. Use on ptr/keyboard
 S (FLAGH,FLAGNFF)=1 G TOP
HD ;
 W:'FLAGNFF @IOF
 W !?65,"David Bolduc",!?65,"Togus, ME"
 W !!!?35,"E D D",!?34,"~~~~~~~",!?35,"~~~~~",!?36,"~~~",!?37,"~",!?25,"Electronic Data Dictionary",!?32,"Version 2.3",!
 W !?22,"*",?25,"Everything you ever wanted",?53,"*",!?22,"*",?25,"to know about a file but",?53,"*",!?22,"*",?25,"were afraid to ask.",?53,"*"
 W !!
 Q
HD1 ;Heading for Top of Main Menu
 W:'FLAGNFF @IOF W !?M1,"A.) FILE NAME:------------- ",ZNAM
 W !?48,"F.) FILE ACCESS:"
 W !?M1,"B.) FILE NUMBER:----------- ",ZNUM
 W ?53,"DD______ ",$S($D(^DIC(ZNUM,0,"DD")):^("DD"),1:"")
 W !?53,"Read____ ",$S($D(^DIC(ZNUM,0,"RD")):^("RD"),1:"")
 W !?M1,"C.) NUM OF FLDS:----------- ",^UTILITY($J,"TOT")
 W ?53,"Write___ ",$S($D(^DIC(ZNUM,0,"WR")):^("WR"),1:"")
 W !?53,"Delete__ ",$S($D(^DIC(ZNUM,0,"DEL")):^("DEL"),1:"")
 W !?M1,"D.) DATA GLOBAL:----------- ",ZGL
 W ?53,"Laygo___ ",$S($D(^DIC(ZNUM,0,"LAYGO")):^("LAYGO"),1:"")
 W !!?M1,"E.) TOTAL GLOBAL ENTRIES:-- "
 S ZZGL=ZGL_"0)",ZZGL=@ZZGL W $S($P(ZZGL,U,4)]"":$P(ZZGL,U,4),1:"Blank")
 W ?48,"G.) PRINTING STATUS:-- ",$S(FLAGP:"On",1:"Off")
 W !,$E(ZLINE1,1,80)
 Q
INIT ;
 S:'$D(DTIME) DTIME=600 S M1=2,M2=15,M3=20,M4=22,M5=25 ;Variables for column numbers
 K ZLINE,ZLINE1,ZLINE2 S $P(ZLINE,"-",212)="",$P(ZLINE1,"=",212)="",$P(ZLINE2,". ",106)="",U="^"
 S IOP=0 D ^%ZIS K IOP S SIZE=(IOSL-5) S:'$D(FLAGNFF) FLAGNFF=0 S:'$D(FLAGH) FLAGH=0
 Q
