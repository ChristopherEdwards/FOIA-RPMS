ADGSTAT1 ; IHS/ADC/PDW/ENM - INPAT STATS BY SERV (cont) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 S DGFAC=$P(^DIC(4,DUZ(2),0),U),DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S DGSTOP=""
A ; -- main
 D HD,AD,AT,PG I DGSTOP=U D Q Q
 D PD,PT,PG I DGSTOP=U D Q Q
 D GT,NB,TR,PRTOPT^ADGVAR,Q Q
 ;
AD ; -- adult services
 W !?3,"ADULT PATIENTS"
 S (DGADT,DGDST,DGTIT,DGTOT,DGDTT,DGINT,DGAVT,DGALT,DGDVT)=0
 N TS S TS=0 F  S TS=$O(DGA(TS)) Q:'TS  D
 . Q:'$$AS  D A1
 Q
 ;
A1 Q:$P(^DIC(45.7,TS,0),U)="NEWBORN"
 ; -- adic (average daily inpatient census)
 S DGAV=$$DF($P(DGA(TS),U,4)/$$ND(DGEDT,DGBDT))
 ; -- alos
 S DGAL=$$DF($P(DGA(TS),U,5)/$S($$LA:$$LA,1:1))
 ; -- totals
 ; -- adm dis tx_in tx_out dth rem+1day adic losses los
 S DGADT=DGADT+$P(DGA(TS),U),DGDST=DGDST+$P(DGA(TS),U,2)
 S DGTIT=DGTIT+$P(DGA(TS),U,7),DGTOT=DGTOT+$P(DGA(TS),U,6)
 S DGDTT=DGDTT+$P(DGA(TS),U,3),DGINT=DGINT+$P(DGA(TS),U,4)
 S DGAVT=DGAVT+DGAV,DGDVT=DGDVT+$$LA,DGALT=DGALT+$P(DGA(TS),U,5)
 ; -- line
 I $Y>(IOSL-6) D PG
 W !,$E($P(^DIC(45.7,TS,0),U),1,15),?19,$J(+$P(DGA(TS),U),3)
 W ?25,$J(+$P(DGA(TS),U,7),3),?31,$J(+$P(DGA(TS),U,6),3)
 W ?37,$J(+$P(DGA(TS),U,2),3),?43,$J(+$P(DGA(TS),U,3),3)
 W ?49,$J(+$P(DGA(TS),U,4),4),?56,$J(DGAV,5)
 W ?64,$J(+$P(DGA(TS),U,5),4),?71,$J(DGAL,5) Q
 ;
AT ; -- adult totals
 W !,$$LN("-"),!!?8,"TOTAL:",?19,$J(DGADT,3)
 W ?25,$J(DGTIT,3),?31,$J(DGTOT,3),?37,$J(DGDST,3)
 W ?43,$J(DGDTT,3),?49,$J(DGINT,4),?56,$J($$DF(DGAVT),5)
 W ?64,$J(DGALT,4),?71,$J($$DF(DGALT/$S(DGDVT:DGDVT,1:1)),5) Q
 ;
PD W !!?3,"PEDIATRIC PATIENTS"
 S (DGADP,DGDSP,DGTIP,DGTOP,DGDTP,DGINP,DGALP,DGAVP,DGDVP)=0
 N TS S TS=0 F  S TS=$O(DGP(TS)) Q:'TS  D
 . Q:'$$AS  D P1
 Q
 ;
P1 I $P(^DIC(45.7,TS,0),U)="NEWBORN" S N=DGP(TS) Q
 ; -- adic (average daily inpatient census)
 S DGAV=$$DF($P(DGP(TS),U,4)/$$ND(DGEDT,DGBDT))
 ; -- alos
 S DGAL=$$DF($P(DGP(TS),U,5)/$S($$LP:$$LP,1:1))
 ; -- totals
 ; -- adm dis dth rem+1day adpl losses los
 S DGADP=DGADP+$P(DGP(TS),U),DGDSP=DGDSP+$P(DGP(TS),U,2)
 S DGTIP=DGTIP+$P(DGP(TS),U,7),DGTOP=DGTOP+$P(DGP(TS),U,6)
 S DGDTP=DGDTP+$P(DGP(TS),U,3),DGINP=DGINP+$P(DGP(TS),U,4)
 S DGAVP=DGAVP+DGAV,DGDVP=DGDVP+$$LP,DGALP=DGALP+$P(DGP(TS),U,5)
 ; -- line
 I $Y>(IOSL-6) D PG
 W !,$E($P(^DIC(45.7,TS,0),U),1,15),?19,$J(+$P(DGP(TS),U),3)
 W ?25,$J(+$P(DGP(TS),U,7),3),?31,$J(+$P(DGP(TS),U,6),3)
 W ?37,$J(+$P(DGP(TS),U,2),3),?43,$J(+$P(DGP(TS),U,3),3)
 W ?49,$J(+$P(DGP(TS),U,4),4),?56,$J(DGAV,5)
 W ?64,$J(+$P(DGP(TS),U,5),4),?71,$J(DGAL,5) Q
 ;
PT ; -- ped total
 W !,$$LN("-"),!!?8,"TOTAL:",?19,$J(DGADP,3),?25,$J(DGTIP,3)
 W ?31,$J(DGTOP,3),?37,$J(DGDSP,3),?43,$J(DGDTP,3)
 W ?49,$J(DGINP,4),?56,$J($$DF(DGAVP),5)
 W ?64,$J(DGALP,4),?71,$J($$DF(DGALP/$S(DGDVP:DGDVP,1:1)),5) Q
 ;
GT ; -- grand total      
 I $Y>(IOSL-6) D PG
 W !!?2,"GRAND TOTAL:",?19,$J(DGADT+DGADP,3),?25,$J(DGTIT+DGTIP,3)
 W ?31,$J(DGTOT+DGTOP,3),?37,$J(DGDST+DGDSP,3),?43,$J(DGDTT+DGDTP,3)
 W ?49,$J(DGINT+DGINP,4),?56,$J($$DF(DGAVT+DGAVP),5)
 W ?63,$J(DGALT+DGALP,5)
 W ?71,$J($$DF((DGALT+DGALP)/$S(DGDVT+DGDVP:DGDVT+DGDVP,1:1)),5) Q
 ;
NB ; -- newborn
 Q:'$D(N)  W !,$$LN("-"),!!?3,"NEWBORN",?19,$J($P(N,U),3)
 W ?25,$J($P(N,U,7),3),?31,$J($P(N,U,6),3)
 W ?37,$J($P(N,U,2),5),?43,$J($P(N,U,3),3)
 W ?49,$J($P(N,U,4),4),?56,$J($$DF($P(N,U,4)/$$ND(DGEDT,DGBDT)),5)
 W ?64,$J($P(N,U,5),4),?71,$J($$DF($P(N,U,5)/$S($$NL:$$NL,1:1)),5) Q
 ;
TR ; -- terms
 W !!!!,"TXI = transfers in, TXO = transfers out"
 W !,"DAYS = total inpatient service days"
 W !,"ADPL = average daily inpatient census"
 W !,"TLOS = total length of stay (discharge days)"
 W !,"ALOS = average length of stay (average stay)",!! Q
 ;
Q ; -- cleanup
 K DGADT,DGDST,DGTIT,DGTOT,DGDTT,DGINT,DGAVT,DGALT,DGDVT,DGDUZ,N
 K DGADP,DGDSP,DGTIP,DGTOP,DGDTP,DGINP,DGALP,DGAVP,DGDVP,DGFAC
 K DGBDT,DGEDT,DGA,DGP,DGAL,DGAV,DGD,DGZ,X,Y W @IOF D ^%ZISC Q
 ;
 ;
HD ; -- heading
 W:(IOST["C-") @IOF W DGDUZ,?80-$L(DGFAC)\2,DGFAC
 W ! D TIME^ADGUTIL W ?24,"INPATIENT STATISTICS BY SERVICE"
 W !,$$DT(DT),?25,"from ",$$DT(DGBDT)," to ",$$DT(DGEDT)
 W !!?5,"SERVICE",?19,"ADM",?25,"TXI",?31,"TXO",?37,"DIS",?43,"DTH"
 W ?49,"DAYS",?57,"ADPL",?64,"TLOS",?72,"ALOS",!,$$LN("="),! Q
 ;
PG ; -- page
 Q:IOST'["C-"
 W ! N X,Y K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U W @IOF D HD
 Q
 ;
AS() ; -- admitting service
 Q $S($P($G(^DIC(45.7,+TS,9999999)),U,3)="Y":1,1:0)
 ;
LA() ; -- losses, adu (dischages + tranfer outs + deaths)
 Q $P(DGA(TS),U,2)+$P(DGA(TS),U,3)+$P(DGA(TS),U,6)
 ;
LP() ; -- losses, ped (dischages + tranfer outs + deaths)
 Q $P(DGP(TS),U,2)+$P(DGP(TS),U,3)+$P(DGP(TS),U,6)
 ;
NL() ; -- newborn losses (dischages + tranfer outs + deaths)
 Q $P(N,U,2)+$P(N,U,3)+$P(N,U,6)
 ;
DF(X) ; -- decimal format
 Q $P(X,".")_"."_$E(($P(X,".",2)_"00"),1,2)
 ;
DT(X) ; -- date format
 Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)
 ;
LN(X,Y) ; -- line
 S Y="",$P(Y,X,IOM)="" Q Y
 ;
ND(X1,X2,X) ; -- number of days
 D ^%DTC Q X+1
