ZIBRPRTD ; IHS/ADC/GTH - ROUTINE PRINT ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ; This routine lists routines edited after given date.
 ;
BEGIN ;
 ;Begin adds/edits;IHS/SET/GTH XB*3*9 10/29/2002
 ;I ^%ZOSF("OS")'["MSM" D OSNO^XB Q
 ;S X="ERR^ZIBRPRTD",@^%ZOSF("TRAP")
 ;W !?10,$P($P($ZV,","),"-")," - Routine Print Utility"
 NEW ZIBOS
 S ZIBOS=$$VERSION^%ZOSV(1)
 I '(ZIBOS["Cache"),'(ZIBOS["MSM") D OSNO^XB Q
 I ZIBOS["MSM" S X="ERR^ZIBRPRTD",@^%ZOSF("TRAP")
 I ZIBOS["Cache" S X="BACK^%ETN",@^%ZOSF("TRAP")
 W !?10,ZIBOS," - Routine Print Utility"
 ;End adds/edits;IHS/SET/GTH XB*3*9 10/29/2002
RSEL ;
 S %DEV=$I
 U 0
 KILL QUIT
 ;X ^%ZOSF("RSEL") ;IHS/SET/GTH XB*3*9 10/29/2002
 S %R=1 X ^%ZOSF("RSEL") ;IHS/SET/GTH XB*3*9 10/29/2002
 ;I $D(QUIT) W !,"No routines selected" G EXIT ;IHS/SET/GTH XB*3*9 10/29/2002
 I $D(QUIT)!(%R=0) W !,"No routines selected" G EXIT ;IHS/SET/GTH XB*3*9 10/29/2002
 S XBTYPE="PRINT"
 D ^XBDATE ;ADDED TO SPECIFY A DATE AND SCREEN OUT ROUTINES EDITED SINCE SPECIFIED DATE
 I $D(QUIT) W !,"No routines will be printed." H 2 G EXIT
SDEV ;
 ;I %DEV=$I D PR^%SDEV G:$D(QUIT) EXIT ;IHS/SET/GTH XB*3*9 10/29/2002
 D ^%ZIS G:POP EXIT S %DEV=IO ;IHS/SET/GTH XB*3*9 10/29/2002
F1 ;
 S %LPP=60,%W=132
 W !!,"Lines per page <",%LPP,">: "
 R %I:$G(DTIME,999)
 I %I="" S %I=%LPP W %I
 I %I'?1N.N G:%I="^" SDEV:$I'=%DEV,RSEL G:%I="^Q" EXIT W !,*7,"Response must be positive numeric" G F1
 S %LPP=+%I
F2 ;
 W !,"Characters per line <",%W,">: "
 R %I:$G(DTIME,999)
 I %I="" S %I=%W W %I
 I %I'?1N.N G EXIT:%I="^Q",F1:%I="^" W !,*7,"Response must be positive numeric" G F2
 S %W=+%I,%L=%W-18-63,%CMT=""
 G:%L'>0 START
CMT ;
 R !,"Enter comment for page header : ",%CMT:$G(DTIME,999)
 G F2:%CMT="^",CMT1:%CMT'="?"
 W !,"The comment will be displayed with the UCI, date, and time on each page header."
 G CMT
 ;
CMT1 ;
 I $L(%CMT)>%L W !,*7,"Too long. Maximum comment length is ",%L G CMT
START ;
 D INT^%T,INT^%D
 D FORMAT
 U %DEV
 ;Begin adds/edits;IHS/SET/GTH XB*3*9 10/29/2002
 ;W !!
 ;I %DEV<20!(%DEV>63) U %DEV:%W
 ;U 0
 I ZIBOS["Cache" W @IOF
 I %DEV<20!(%DEV>63),ZIBOS["MSM" U %DEV:%W
 U $P
 ;End adds/edits;IHS/SET/GTH XB*3*9 10/29/2002
 W !!,"Done. "
EXIT ;
 ;U 0 ;IHS/SET/GTH XB*3*9 10/29/2002
 ;I '$D(QUIT),%DEV'=$I,+%DEV S IO=%DEV D ^%ZISC ;IHS/SET/GTH XB*3*9 10/29/2002
 I '$D(QUIT),%DEV'=$I S IO=%DEV D ^%ZISC ;IHS/SET/GTH XB*3*9 10/29/2002
 KILL %DEV,%LPP,%W,%I,%J,%CMT,%TIM,%TIM1,%DAT,%DAT1,%PG,%PGG,%RN,%L,%R,%X,%,%BLK,QUIT
 Q
 ;
ERR ;EP - If error, from error trap.
 I $F($$Z^ZIBNSSV("ERROR"),"<INRPT>") U 0 W !!,"...Aborted." D EXIT V 0:$J:$ZB($V(0,$J,2),#0400,7):2
 ZQ
 ;
FORMAT ;
 S %PG=1,%PGG=1
 W !!,"Printing ...",!
F3 ;
 ;Begin adds/edits;IHS/SET/GTH XB*3*9 10/29/2002
 ;S %X="W:$Y # W !,""Routine: "",%RN,?20,""UCI: "",$ZU(0),""  Date/Time: "",%DAT1,"", "",%TIM1,?$X+3,%CMT,?%W-18,""Page: "",%PG,""-"",%PGG,! S %PGG=%PGG+1"
 ;U %DEV
 ;I %DEV<20!(%DEV>63) U %DEV:%W
 ;S %RN=""
 ;F %I=1:1 S %RN=$O(^UTILITY($J,%RN)) Q:%RN=""  X:$V(8,$J,2)'=$I "U 0 W ?$S($X=0:0,1:$X+10\10*10-1),%RN W:$X>70 ! U %DEV" D F4 S %PG=%PG+1,%PGG=1
 S:ZIBOS["MSM" %X="W:$Y # W !,""Routine: "",%RN,?20,""UCI: "",$ZU(0),""  Date/Time: "",%DAT1,"", "",%TIM1,?$X+3,%CMT,?%W-18,""Page: "",%PG,""-"",%PGG,! S %PGG=%PGG+1"
 S:ZIBOS["Cache" %X="W:$Y # W !,""Routine: "",%RN,?20,""Namespace: "",$ZU(5),""  Date/Time: "",%DAT,"", "",%TIM,?$X+3,%CMT,?%W-18,""Page: "",%PG,""-"",%PGG,! S %PGG=%PGG+1"
 U %DEV
 I ZIBOS["MSM" D
 . I %DEV<20!(%DEV>63) U %DEV:%W
 . S %RN=""
 . F %I=1:1 S %RN=$O(^UTILITY($J,%RN)) Q:%RN=""  X:$V(8,$J,2)'=$I "U 0 W ?$S($X=0:0,1:$X+10\10*10-1),%RN W:$X>70 ! U %DEV" D F4 S %PG=%PG+1,%PGG=1
 I ZIBOS["Cache" D
 . S %RN=0
 . F %I=1:1 S %RN=$O(^UTILITY($J,%RN)) Q:%RN=""  X "U $P W ?$S($X=0:0,1:$X+10\10*10-1),%RN W:$X>70 ! U %DEV" D F4 S %PG=%PG+1,%PGG=1
 ;End adds/edits;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
F4 ;
 X %X
 X "ZL @%RN F %I=1:1 S %J=$T(+%I) Q:%J=""""  S %L=$P(%J,"" ""),%R=$P(%J,"" "",2,255) X:$Y>%LPP %X W !,%L,?10 F %J=1:%W-10:255 S %L=$E(%R,1,%W-10),%R=$E(%R,%W-10+1,255) W %L Q:%R=""""  X:$Y>%LPP %X W !,"".........."""
 Q
 ;
