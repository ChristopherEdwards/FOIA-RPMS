XBHEDD6 ;402,DJB,10/23/91,EDD - Xref,Groups,Pointers In
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;; David Bolduc - Togus, ME
XREF ;Cross Reference Listing
 I '$D(^DD(ZNUM,0,"IX")) W ?30,"No XREF for this file." S FLAGG=1 Q
 S NM="",HD="HD1" D INIT^XBHEDD7 G:FLAGQ EX D HD1
 F  S NM=$O(^DD(ZNUM,0,"IX",NM)) Q:NM=""  D:$Y>SIZE PAGE Q:FLAGQ  S ZDD="",ZDD=$O(^DD(ZNUM,0,"IX",NM,ZDD)),ZFLD="",ZFLD=$O(^DD(ZNUM,0,"IX",NM,ZDD,ZFLD)) D XREFPRT
 G EX
XREFPRT ;
 S GLTEMP=ZGL_""""_NM_""""_")"
 W ! W:$D(@(GLTEMP)) ?1,"*" W ?4,"""",NM,"""",?22,$J(ZDD,8),?33,$J(ZFLD,10)
 I $D(^DD(ZDD,ZFLD,0)) W ?46,$P(^(0),U) Q
 W ?46,"---> Field doesn't exist"
 Q
PT ;Pointers to this file
 I '$D(^DD(ZNUM,0,"PT")) W ?30,"No files point to this file." S FLAGG=1 Q
 D INIT^XBHEDD7 G:FLAGQ EX D HD3 S ZFILE="",ZCNT=1,HD="HD3"
 F  S ZFILE=$O(^DD(ZNUM,0,"PT",ZFILE)) Q:ZFILE=""!FLAGQ  S FLAGPT=0 D @$S($D(^DIC(ZFILE,0)):"PTYES",1:"PTNO") I 'FLAGPT S ZFLD="" F  S ZFLD=$O(^DD(ZNUM,0,"PT",ZFILE,ZFLD)) Q:ZFLD=""  D PTPRT Q:FLAGQ
 G EX
PTNO ;
 I '$D(^DD(ZFILE,0,"UP")) S FLAGPT=1 Q
 S ZFILETP=ZFILE F  S ZFILETP=^DD(ZFILETP,0,"UP") Q:$D(^DIC(ZFILETP,0))  I '$D(^DD(ZFILETP,0,"UP")) Q
 I '$D(^DIC(ZFILETP,0)) S FLAGPT=1 Q
 S GL=^DIC(ZFILETP,0,"GL"),ZFILEN=$P(^DIC(ZFILETP,0),U)
 Q
PTYES ;
 S GL=^DIC(ZFILE,0,"GL"),ZFILEN=$P(^DIC(ZFILE,0),U) Q
PTPRT ;
 W !,$J(ZCNT,4),".",?6,GL,?21,$E(ZFILEN,1,25)
 W ?48 I $D(^DD(ZFILE,ZFLD,0)),$P(^(0),U)]"" W $E($P(^(0),U),1,22)," (",ZFLD,")"
 E  W "--> Field ",ZFLD," does not exist."
 S ZCNT=ZCNT+1 I $Y>SIZE D PAGE Q:FLAGQ
 Q
GRP ;Groups
 S ZMULT="",HD="HD2" D GRPBLD G:FLAGG EX D INIT^XBHEDD7 G:FLAGQ EX D HD2,GRPPRT
 G EX
GRPBLD ;
 S Z="",X=1
 F  S Z=$O(^UTILITY($J,"TMP",Z)) Q:Z=""  I $D(^DD(Z,"GR")) S GRP="" F  S GRP=$O(^DD(Z,"GR",GRP)) Q:GRP=""  S ZFLD="" F  S ZFLD=$O(^DD(Z,"GR",GRP,ZFLD)) Q:ZFLD=""  S ^UTILITY($J,"GROUP",GRP,Z,ZFLD)=$P(^DD(Z,ZFLD,0),U),X=X+1 I X#9=0 W "."
 I '$D(^UTILITY($J,"GROUP")) W ?30,"No Groups established." S FLAGG=1
 Q
GRPPRT ;
 S GRP="" F I=1:1 S GRP=$O(^UTILITY($J,"GROUP",GRP)) Q:GRP=""!FLAGQ  W !,$J(I,3),". ",GRP D GRPPRT1
 Q
GRPPRT1 ;
 S GRP1=""
 F  S GRP1=$O(^UTILITY($J,"GROUP",GRP,GRP1)) Q:GRP1=""!FLAGQ  S GRP2="" F  S GRP2=$O(^UTILITY($J,"GROUP",GRP,GRP1,GRP2)) Q:GRP2=""  W ?18,$J(GRP1,6),?27,$J(GRP2,8),?39,^(GRP2),! I $Y>SIZE D PAGE Q:FLAGQ
 Q
EX ;
 K FLAGPT,GL,GLTEMP,GRP,GRP1,GRP2,HD,NM,ZDD,ZFILE,ZFILEN,ZFILETP,ZFLD,ZGL1,ZMULT
 K ^UTILITY($J,"GROUP") Q
HD1 ;XREF
 W !?9,"XREF",?25,"DD",?34,"FLD NUM",?56,"FIELD NAME",!?4,"---------------",?22,"--------",?33,"----------",?46,"------------------------------"
 Q
HD2 ;Groups
 W !?5,"GROUP NAME",?20,"DD",?27,"FLD NUM",?48,"FIELD NAME",!?5,"-----------",?18,"------",?27,"--------",?39,"------------------------------",!
 Q
HD3 ;Pointers to this file
 W !?3,"Pointers TO this file..",!?9,"GLOBAL",?22,"FILE  (Truncated to 25)",?50,"FIELD   (Truncated to 22)",!?6,"-------------",?21,"-------------------------",?48,"------------------------------"
 Q
PAGE ;
 I FLAGP,IO'=IO(0) W @IOF,!!! D @HD Q
 R !!?2,"<RETURN> to continue, '^' to quit, '^^' to exit: ",Z1:DTIME S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 W @IOF D @HD
 Q
