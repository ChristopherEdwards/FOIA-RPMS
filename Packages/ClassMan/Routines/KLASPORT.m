KLASPORT ;NEW PROGRAM [ 08/11/92  3:53 PM ]
 ;;
SET ;set and clear IO port bits
 K DIR S (XS,XC)=""
 I IO=IO(0) W !,"IO=IO(0)  not a good idea !",! S X=$$TERMINAL^%HOSTCMD("stty -a")
 W !!!,"***** DEVICE = ",IO D ZA
 I IO=157 W ! S X=$$TERMINAL^%HOSTCMD("stty -a < /dev/tty57")
 K DIR
 W ! S DIR(0)="LO^0:23",DIR("A")="Set bits ? : " D ^DIR
 K PWZ F I=1:1 S Z=$P(Y,",",I) Q:Z=""  S:'$D(PWZ(Z)) XS=$G(XS)+(2**$P(Y,",",I)),PWZ(Z)=""
 W !,XS S X=XS D EN
 K DIR
 W ! S DIR(0)="LO:23",DIR("A")="Clear bits ? : " D ^DIR
 K PWZ F I=1:1 S Z=$P(Y,",",I) Q:Z=""  S:'$D(PWZ(Z)) XC=$G(XC)+(2**$P(Y,",",I)),PWZ(Z)=""
 W !,XC S X=XC D EN
 I XS="",XC="" Q
 I XC]"" S PWX="U IO:(::::"_XS_":"_XC_")"
 E  S PWX="U IO:(::::"_XS_")"
 W !!,PWX X PWX D ZA
 G SET
 ; --------------------------
EN U IO(0) W !,"BITS : "
 F I=25:-1:0 I X'<(2**I) W " ",I S X=X-(2**I) 
 Q
ZA U IO S ZA=$ZA,X=ZA D EN
 Q
READ ;decimal binary to bit map of binary
 F  R !,"decimal number ? ",X Q:X'>0  D EN
 Q
TBL ;generate bit - decimal map
 F I=0:1:25 W !,I,?5,2**I
 Q
PORT U IO:(::::8388608+2097152+4096+512+1:4194304+262144) ;set passall;ctrl/O as data;assert DTR;no echo;;input buffer XON;7b data
 Q
