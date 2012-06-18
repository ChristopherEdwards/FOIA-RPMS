ACHSODQ ; IHS/ITSC/PMF - DCR REPORT ;     [ 10/31/2003  11:51 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**6**;JUNE 11, 2001
 ;ACHS*3.1*6  3.27.03 IHS/SET/FCJ $O WAS SKIPPING FIRST DAY OF REPORT
 ;
 ;this prints out a report on the Document Control Register
 ;of your choice.  Reprints and multiple copies are allowed.
 ;
 ;IMPORTANT!! This is not just a report.  Printing an open
 ;DCR CLOSES it.
 ;
 K X2,X3
START ;
 S ACHSASK=0
 D ^ACHSUF
 I $D(ACHSERR),ACHSERR=1 G END
 ;
REPRINT ;
 W !!,"Do You Wish To Re-Print A Prior Register ? NO// "
 D READ^ACHSFU
 G END:$D(DUOUT)
 I Y?1"?".E D YN^ACHS,NOQUE G REPRINT
 I Y=""!(Y?1"N".E) G END:ACHSASK,DCR
 I Y'?1"Y".E W *7,"  ??" G REPRINT
RE2 ;
 W !!,"Re-Print Register Number: "
 D READ^ACHSFU
 G END:$D(DTOUT),REPRINT:$D(DUOUT),RE3:'(Y?1"?".E)
 W !,"  Enter The Register Number With The Fiscal Year Code And",!,"  Specific Register Number Separated By A Dash (e.g.  9-012)."
 W !,"  If You Wish To See A List Of Register Numbers Enter The Fiscal Year",!,"  And A Question Mark Separated By A Dash (e.g. 6-?)."
 G RE2
 ;
RE3 ;
 G END:Y=""
 S X=$E(Y,2)
 I " .,/\"[X S Y=$E(Y,1)_"-"_$E(Y,3,99)
 S R=$P(Y,"-",2,99),ACHSR1=$P(Y,"-",1)
 I ACHSR1?1N G RE4:R="?",RE3A:R?1N.N
 W *7,"  ??"
 G RE2
 ;
RE3A ; Print multiple copies of the selected DCR.
 W !!,"Enter number of copies: 1//"
 D READ^ACHSFU
 G RE3:$D(DTOUT),RE3:$D(DUOUT)!($E(Y)="?")
 I Y="" S Y=1 S ACHSNUM=+Y G RE4
 I Y'?1N.N G RE3A
 S ACHSNUM=+Y
RE4 ;
 S ACHSX=ACHSR1
 D FYCVT^ACHSFU
 S ACHSACY=ACHSY
 D REGHEAD
 G RE2:R="?"
 S Y=$$DIR^XBDIR("Y","Is This Correct","YES","","","",2)
 G END:$D(DTOUT),RE2:$D(DUOUT)
 G RE2:'Y
 ;ACHS*3.1*6 3.27.03 IHS/SET/FCJ ADD -1 TO ACHSBDT,$O SKIPPING FIRST DAY
 ;S R=+R,ACHSACRP=R,ACHSBDT=ACHSACY-1701_$P(^ACHSF(DUZ(2),0),U,6),ACHSEDT=$P(^ACHS(9,DUZ(2),"FY",ACHSACY,"W",R,0),U,2) ;ACHS*3.1*6
 S R=+R,ACHSACRP=R,ACHSBDT=ACHSACY-1701_($P(^ACHSF(DUZ(2),0),U,6)-1),ACHSEDT=$P(^ACHS(9,DUZ(2),"FY",ACHSACY,"W",R,0),U,2) ;ACHS*3.1*6
 I $D(^ACHS(9,DUZ(2),"FY",ACHSACY,"W",R-1,0)) S ACHSBDT=$P(^(0),U,2)
REDEV ;
 W !!
 S %ZIS="P"
 D ^%ZIS
 I POP W !!,*7,"  DCR REPRINT REQUEST CANCELLED" D HOME^%ZIS G END
 K ^TMP("ACHSOD",$J,DUZ(2))
 S ACHSIO=IO
 S D=$H,^TMP("ACHSOD",$J,DUZ(2),0)="^ACHSODP^"_DUZ_U_Y_U_D_U_D,^("DCR",ACHSACY,0)=DUZ(2)_U_ACHSIO_U_ACHSBDT_U_ACHSEDT_U_ACHSACY_U_ACHSACRP
 S ^TMP("ACHSOD",$J,DUZ(2),"DESC")="DCR "_ACHSACY_"-"_ACHSACRP_" from "_ACHSBDT_" to "_ACHSEDT
 G DCR5
 ;
DCR ;
 S ACHSACY=ACHSCFY,ACHSASK=1,R=+ACHSFYWK(DUZ(2),ACHSCFY)
 I $D(^ACHS(9,DUZ(2),"FY",ACHSACFY,"W",R,0)),$P(^(0),U,2)="" G DCR2
 W *7,!!,"The Current Register, Number ",$E(ACHSACY,4),"-",$E("1000"+R,2,4),!,"Has Been Printed. Use The Re-Print Option If You",!,"Wish To Print This Register Again."
 G REPRINT
 ;
DCR2 ;
 D VIDEO^ACHS
 F I=1:1:2 W *7,!!,"If you print this register, you will " W $G(IORVON) W "CLOSE THIS REGISTER!" W $G(IORVOFF) H 1
 W !!,"Print Register Number  ",$E(ACHSACY,4),"-",$E(1000+R,2,4),"  ...Ok ? NO// "
 D READ^ACHSFU
 G END:$D(DTOUT),START:$D(DUOUT),REPRINT:(Y="")
 I Y?1"?".E W !,"  Do You Wish To 'CLOSE' And Print This Register.",!,"  Enter 'Y' or 'N'." D NOQUE G DCR2
 G REPRINT:Y=""!(Y?1"N".E)
 I Y]"",Y'?1"Y".E W *7,"  ??" G DCR2
DCR2A ;PRINT MULTIPLE COPIES
 W !!,"Enter number of copies: 1// "
 D READ^ACHSFU
 G DCR2:$D(DTOUT),DCR2:$D(DUOUT)!($E(Y)="?")
 I Y="" S Y=1,ACHSNUM=+Y G DCR3
 I Y'?1N.N G DCR2A
 S ACHSNUM=+Y
DCR3 ;EP
 I $D(ACHSAUTO) S %ZIS("A")="ENTER DEVICE TO PRINT DCR: "
 I $D(ACHSAUTO) W !,"Closing Current Registers And Printing 'DCRs'.  Please Wait.....",!
 K ^TMP("ACHSOD",$J,DUZ(2))
 S ACHSIO=IO
 W !!,"The following REGISTERS have been CLOSED:",!!?12,"FY",?22,"REG #",!
 S ACHSDT=DT,X1=DT,X2=-1,X=DT
 D:$D(ACHS("DCR")) C^%DTC
 S ACHSDT=X
 K X1,X2
 F ACHS=0:0 S ACHS=$O(ACHSFYWK(DUZ(2),ACHS)) Q:'ACHS  D
 . S ACHSXX=ACHSFYWK(DUZ(2),ACHS),$P(^ACHS(9,DUZ(2),"FY",ACHS,"W",ACHSXX,0),U,2)=ACHSDT
 . S ^ACHS(9,DUZ(2),"FY",ACHS,"AR",9999999-ACHSDT,ACHSXX)=""
 . W !?10,ACHS,?20,$J(ACHSXX,5)
 .Q
 S D=$H,^TMP("ACHSOD",$J,DUZ(2),0)="^ACHSODP^"_DUZ_U_Y_U_D_U_D
 S ^TMP("ACHSOD",$J,DUZ(2),"DESC")="DCR run on "_ACHSDT
 S ACHSRX=0
 W !!
 S %ZIS="P"
 D ^%ZIS
 I POP W *7,!!,"  DCR REQUEST CANCELLED",! K %ZIS D HOME^%ZIS S:$D(ACHSAUTO) ACHSERR="" Q
 S ACHSIO=IO
DCR4 ;
 S ACHSRX=$O(ACHSFYWK(DUZ(2),ACHSRX))
 G:+ACHSRX=0 DCR5
 S ACHSXX=ACHSFYWK(DUZ(2),ACHSRX)
 ;ACHS*3.1*6 3.27.03 IHS/SET/FCJ CHANGED 10000 TO 10001,PICK UP 1ST DAY 
 ;S ACHSACRP=0,R=ACHSXX,ACHSDCR=R,ACHSEDT=ACHSDT,ACHSBDT=ACHSFYDT-10000 ;ACHS*3.1*6
 S ACHSACRP=0,R=ACHSXX,ACHSDCR=R,ACHSEDT=ACHSDT,ACHSBDT=ACHSFYDT-10000 ;ACHS*3.1*6
 I $D(^ACHS(9,DUZ(2),"FY",ACHSRX,"W",R-1,0)),$P(^(0),U,2) S ACHSBDT=$P(^(0),U,2)
 S ^TMP("ACHSOD",$J,DUZ(2),"DCR",ACHSRX,0)=DUZ(2)_U_ACHSIO_U_ACHSBDT_U_ACHSEDT_U_ACHSRX_U_ACHSDCR
 G DCR4
 ;
DCR5 ;
 U IO(0)
 W:'$D(IO("S")) !!,"  Your DCR will begin to print in a moment."
 D END,WAIT^DICD:'$D(IO("S"))
 U ACHSIO
 G ^ACHSODB
 ;
END ;
 K ACHSASK,ACHSDCR,ACHSX,ACHSY,ACHSACRP,ACHSACY,IOSC,ACHSXX
 Q
 ;
REGHEAD ;
 S I=$S(R="?":0,1:R-1),E=$S(R="?":1,1:0)
 W:R="?" @IOF
 W !!!,"Reg #",?8,"Ending Date",!,"-----",?8,"-----------",!
REGSHOW ;
 S I=$O(^ACHS(9,DUZ(2),"FY",ACHSACY,"W",I)) Q:I=""  G REGSHOW:'$D(^(I,0)) S X=$P(^(0),U,2)
 I I=1,X="" W !,"No Past Registers to Print"
 I X W $E(ACHSACY,4),"-",$E(1000+I,2,4),"    ",$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",$E(X,4,5))," ",$J(+$E(X,6,7),2),", ",$E(X,2,3),!
 G REGSHOW:E
 Q
 ;
NOQUE ;
 W !,"NOTE: Queuing is not allowed in order to provide",!?6,"positive control over the registers.",!
 Q
