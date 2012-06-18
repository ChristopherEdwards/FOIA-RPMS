APCCPREI ;CREATED BY AUBPI ON JUL 10,1990
 ;;4;PCC MENUS/MASTER CONTROL;;JUL 10, 1990
 K ^UTILITY("AUDSET",$J) F AUBPI=1:1 S AUBPIX=$P($T(Q+AUBPI),";;",2) Q:AUBPIX=""  S AUBPIY=$P(AUBPIX,"=",2,99),AUBPIX=$P(AUBPIX,"=",1) S @AUBPIX=AUBPIY
 K AUBPI,AUBPIX,AUBPIY D EN2^%AUKD
 W !
 F I=1:1:5 W *7,"*** WARNING ***" H 1 W:I'=5 *13,$J("",79),*13
 W !,"If you are NOT installing PCC for the first time (i.e If PCC is already ",!,"running) it is VERY IMPORTANT that you answer NO to the following question ",!,"when it is asked:  ",!
 W ?5,"SHALL I WRITE OVER EXISTING OPTIONS OF THE SAME NAME? YES//",!?5,"DO NOT HIT RETURN - ANSWER NO!!",!
 W !,"You should respond YES to all other questions.",!
 W !,"If you are installing PCC for the first time, respond YES",!,"to ALL questions.",!
 F I=1:1:8 W $C(7),"*** WARNING ***" H 1 W:I'=8 $C(13),$J("",79),$C(13)
 S DIFQ(0)=1
Q Q
 ;;^UTILITY("AUDSET",$J,9001000)=S^S
