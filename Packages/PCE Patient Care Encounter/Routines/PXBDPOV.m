PXBDPOV ;ISL/JVS - DISPLAY POV (DIAGNOSIS) ;7/24/96  08:41
 ;;1.0;PCE PATIENT CARE ENCOUNTER;;Aug 12, 1996
 ;
 ;
EN0 ;---Main entry point
 ;
 I '$D(IOCUU) D TERM^PXBCC
 ;
HEAD ;--HEADER ON LIST
 S HEAD="- - E N C O U N T E R  D I A G N O S I S  (ICD9 CODES) - -"
 W !,IOCUU,?(IOM-$L(HEAD))\2,IOINHI,HEAD
 W IOINLOW,IOELEOL K HEAD
 ;
 I $D(CLINIC) D POV^PXBUTL2(CLINIC)
 I PXBCNT<11 D DPOV1
 I PXBCNT>10&($D(PXBNPOV)) D DPOV4("SAME")
 I PXBCNT>10&('$D(PXBNPOV)) D DPOV4("BEGIN")
 Q
 ;
 ;
DPOV1 ;--Display the POV Data
 N ENTRY
 D UNDON^PXBCC
 W !,"No.",?5,"ICD",?13,"DESCRIPTION",?64,"PROBLEM LIST"
 W IOEDEOP
 D UNDOFF^PXBCC
 ;
 ;
 S J=0 F  S J=$O(PXBSAM(J)) Q:J=""  D
 .S ENTRY=$G(PXBSAM(J)) I $D(PXBNPOV($P(ENTRY,"^",1))) S $P(ENTRY,"^",1)=$P(ENTRY,"^",1)_"*"
 .W !,J,?4,$J($P($P(ENTRY,"^",1),".",1),4),".",$P($P(ENTRY,"^",1),".",2),?13,$E($P(ENTRY,"^",3),1,30),?44 W:$P(ENTRY,"^",4)["PRI" $P(ENTRY,"^",4)
 .I $P(ENTRY,"^",4)["PRI" W ?71,$P(ENTRY,"^",5)
 .E  W ?74,$P(ENTRY,"^",5)
 .D DIS
 ;---Write no entries if none exsist
 I '$D(PXBSAM) D NONE^PXBUTL(3)
 ;-------------UNCOMMENT TO LIST CLINIC POV TO SCREEN-----
 ;D DEF^PXBDPOV("A")
 ;----------------------------------------------------
 D DEF^PXBDPOV("D") I '$D(FIRST) K PXBDPOV
 Q
 ;
 ;
 ;
DPOV4(SIGN) ;--Display the PROVIDER Data
 ;
 ;SIGN=
 ; '+' add 10 to the starting point in ^TMP("PXBDPOV",$J)
 ; '-' subtract 10 from the starting point but not less that 0
 ; 'BEGIN' start at the beginning
 ; 'SAME' start stays where it's at
 ; '3'--any number set start to that number
 ;
 N PXBSTART
 I SIGN="BEGIN" S ^TMP("PXBDPOV",$J,"START")=0,PXBSTART=0
 I SIGN="SAME" S PXBSTART=^TMP("PXBDPOV",$J,"START")
 I SIGN="+" S PXBSTART=($G(^TMP("PXBDPOV",$J,"START"))+(10)) S:PXBSTART'<PXBCNT PXBSTART=(PXBCNT-(10)) S ^TMP("PXBDPOV",$J,"START")=PXBSTART
 I SIGN="-" S PXBSTART=$G(^TMP("PXBDPOV",$J,"START"))-10,^TMP("PXBDPOV",$J,"START")=PXBSTART I PXBSTART<0 S PXBSTART=0 S ^TMP("PXBDPOV",$J,"START")=0
 I +SIGN>0&(SIGN#10) S PXBSTART=$P((SIGN/10),".")*10 S:PXBSTART<10 PXBSTART=0  Q:^TMP("PXBDPOV",$J,"START")=PXBSTART  S ^TMP("PXBDPOV",$J,"START")=PXBSTART
 I +SIGN>0&'(SIGN#10) S PXBSTART=(($P((SIGN/10),".")*10)-10) S:PXBSTART<10 PXBSTART=0 Q:^TMP("PXBDPOV",$J,"START")=PXBSTART  S ^TMP("PXBDPOV",$J,"START")=PXBSTART
 ;
 ;
 I SIGN'="BEGIN" D LOC^PXBCC(3,0) W IOEDEOP
 ;
HEAD4 ;--HEADER ON LIST
 S HEAD="- - E N C O U N T E R  D I A G N O S I S  (ICD9 CODES) - -"
 W !,IOCUU,?(IOM-$L(HEAD))\2,IOINHI,HEAD ;----F  W $C(32) Q:$X=(IOM-(1))
 W IOINLOW,IOELEOL K HEAD
 ;
 ;
 N ENTRY,J
 D UNDON^PXBCC
 W !,"No.",?5,"ICD",?13,"DESCRIPTION",?64,"PROBLEM LIST"
 W IOEDEOP
 D UNDOFF^PXBCC
 ;
 ;
 S J=PXBSTART F  S J=$O(PXBSAM(J)) Q:J=""  Q:J=(PXBSTART+(11))  D
 .S ENTRY=$G(PXBSAM(J)) I $D(PXBNCPT($P(ENTRY,"^",1))) S $P(ENTRY,"^",1)=$P(ENTRY,"^",1)_"*"
 .W !,J,?4,$J($P($P(ENTRY,"^",1),".",1),4),".",$P($P(ENTRY,"^",1),".",2),?13,$E($P(ENTRY,"^",3),1,30),?44 W:$P(ENTRY,"^",4)["PRI" IOINHI,$P(ENTRY,"^",4),IOINLOW
 .I $P(ENTRY,"^",4)["PRI" W ?81,$P(ENTRY,"^",5)
 .E  W ?74,$P(ENTRY,"^",5)
 .D DIS
 I SIGN'="BEGIN" W !!
 ;------------UNCOMMENT TO LIST PORVIDERS TO SCREEN--------
 ;D DEF^PXBDPOV("A")
 ;---------------------------------------------------------
 D DEF^PXBDPOV("D") I '$D(FIRST) K PXBDPOV
 Q
 ;
 ;
DEF(CODE) ;---PROCESS DEFAULT LIST OF DIAGNOSIS
 ; I CODE="D" JUST SEND DEFAULT
 ; I CODE="A" JUST SEND THE ARRAY OF PROVIDERS
 D POV^PXBUTL2(CLINIC,3)
 N POV,X,CLNAME,STOP,LIST,NAME,NUMBER
 I '$D(IORC) D TERM^PXBCC
 I '$D(CODE) W !,"SEND PARAMETER = TO 'D'efault OR 'A'rray" Q
 I $G(CODE)="D",$D(PXBPMT("DEF")) S NAME=$O(PXBPMT("DEF",0)) S PXBDPOV=NAME
 I $G(CODE)="A" K PXBPMT("DEF") D
 .S (POV,STOP)="" F  S POV=$O(PXBPMT("POV",POV)) Q:POV=""  Q:STOP=0  D
 ..I '$D(PXBKY(POV)) S STOP=0
 .I STOP="" Q
 .S CLNAME=$P(^SC(CLINIC,0),"^",1)
 .S X="Other ICD CODES associated with "_CLNAME_" clinic."
 .W:PXBCNT<7 ! W !,?(IOM-$L(X))/2,IOINHI,X,IOINLOW K X
 .S (POV,LIST)="" F  S POV=$O(PXBPMT("POV",POV)) Q:POV=""  D
 ..I $D(PXBKY(+POV)) Q
 ..S LIST=LIST_POV_"  " I $L(LIST,"  ")>2 W !,?(IOM-$L(LIST))/2,LIST S LIST=""
 I $G(LIST)]"" W !,?(IOM-$L(LIST))/2,LIST
 Q
 ;
DIS ;----DISPLAY
 Q
 I $D(PXBPMT("POV",$P($P(ENTRY,"^",1),"*"))) W:PXBCNT>11 IORVON W ?37," --Clinic Associated--",IORVOFF
 Q
 ;
