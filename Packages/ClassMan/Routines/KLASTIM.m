KLASTIM ;DSD/PDW TIMER FOR CLASS WELCOME [ 09/02/93  11:04 AM ]
 ;;
 ; This routine prints out a welcome message continually
 R !,"CLASS NAME ? : ",KLASX:DTIME
 R !,"STARTING TIME ? : ",KLAST:DTIME
 W !,"You may enter any character to interupt the welcome message.",!
 S KLASZ=""
 F I=1:1 Q:KLASZ>0  F J=0:1:5 W:J=0 !,"Class Starts at ",KLAST,?40,"Current Time is : " D:J=0 ^%T W !,?(J*5),"Welcome to the ",KLASX," Class!" D  R "",*KLASZ:9 Q:KLASZ>0
 .;
 K KLAST,KLASX,KLASZ
 Q
