AMHRSU5 ; IHS/CMI/LAB - ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 D INFORM
DATES K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR G:Y<1 XIT S AMHBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR G:Y<1 XIT  S AMHED=Y
 ;
 I AMHED<AMHBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S AMHSD=$$FMADD^XLFDT(AMHBD,-1)_".9999"
 ;
PROG ;
 S AMHPROG=""
 S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Run the Report for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) DATES
 I Y="A" G DEMO
 S DIR(0)="9002011,.02",DIR("A")="Which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROG
 I X="" G PROG
 S AMHPROG=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G PROG
ZIS ;call xbdbque
 S XBRC="DRIVER^AMHRSU5",XBRP="PRINT^AMHRSU5",XBRX="XIT^AMHRSU5",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ;EP entry point for taskman
 D PROCESS
 S AMHET=$H
 Q
XIT ;
 K DIR
 D EN^XBVK("AMH")  ;clean up AMH variables
 D ^XBFMK  ;clean up fileman variables
 Q
 ;
PROCESS ;
 D XTMP^AMHUTIL("AMHRSU5","BH - SUICIDE POV REPORT")
 S (AMHBT,AMHBTH)=$H,AMHJOB=$J
 K AMHMALEV,AMHFEMV,AMHALLV,AMHMALEP,AMHFEMP,AMHALLP
 F X=1:1:13 S (AMHMALEV(X),AMHFEMV(X),AMHALLV(X),AMHMALEP(X),AMHFEMP(X),AMHALLP(X))=0
 S AMHSD=$P(AMHBD,".")-1,AMHSD=AMHSD_".9999"
 K AMHPRAT S AMHGRTA=0
 S (AMHRCNT,AMHVIEN)=0 F  S AMHSD=$O(^AMHREC("B",AMHSD)) Q:AMHSD=""!($P(AMHSD,".")>$P(AMHED,"."))  D
 .S AMHVIEN=0 F  S AMHVIEN=$O(^AMHREC("B",AMHSD,AMHVIEN)) Q:AMHVIEN'=+AMHVIEN  D
 ..S AMHV0=$G(^AMHREC(AMHVIEN,0))
 ..Q:AMHV0=""
 ..S DFN=$P(^AMHREC(AMHVIEN,0),U,8)
 ..Q:DFN=""
 ..Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 ..I AMHPROG]"",$P(^AMHREC(AMHVIEN,0),U,2)'=AMHPROG Q  ;not correct program visit
 ..Q:'$D(^AMHRPRO("AD",AMHVIEN))  ;no pOVS
 ..S AMHAGE=$$AGE^AUPNPAT(DFN,$P($P(AMHV0,U),"."))
 ..S A=$$AG(AMHAGE)
 ..D SETT(1,A,DFN)
 ..Q:'$$SUICPOV(AMHVIEN)  ;no suicide pov
 ..D SETT(2,A,DFN)
 ..I $$SUICC(AMHVIEN,39) D SETT(3,A,DFN)
 ..I $$SUICC(AMHVIEN,40) D SETT(4,A,DFN)
 ..I $$SUICC(AMHVIEN,41) D SETT(5,A,DFN)
 ..I $$SUICC(AMHVIEN,"V62.84") D SETT(3,A,DFN)
 ..Q
 .Q
 S AMHET=$H
 Q
 ;
SETT(P,A,D) ;
 S $P(AMHALLV(13),U,P)=$P(AMHALLV(13),U,P)+1  ;all visits, all 39/40/41
 I $P(^DPT(D,0),U,2)="M" S $P(AMHMALEV(13),U,P)=$P(AMHMALEV(13),U,P)+1
 I $P(^DPT(D,0),U,2)="F" S $P(AMHFEMV(13),U,P)=$P(AMHFEMV(13),U,P)+1
 S $P(AMHALLV(A),U,P)=$P(AMHALLV(A),U,P)+1
 I $P(^DPT(D,0),U,2)="M" S $P(AMHMALEV(A),U,P)=$P(AMHMALEV(A),U,P)+1
 I $P(^DPT(D,0),U,2)="F" S $P(AMHFEMV(A),U,P)=$P(AMHFEMV(A),U,P)+1
 I $P($G(^XTMP("AMHRSU5",AMHJOB,AMHBTH,"PATIENTS",D)),U,P) Q
 S $P(^XTMP("AMHRSU5",AMHJOB,AMHBTH,"PATIENTS",D),U,P)=1
 S $P(AMHALLP(13),U,P)=$P(AMHALLP(13),U,P)+1
 I $P(^DPT(D,0),U,2)="M" S $P(AMHMALEP(13),U,P)=$P(AMHMALEP(13),U,P)+1
 I $P(^DPT(D,0),U,2)="F" S $P(AMHFEMP(13),U,P)=$P(AMHFEMP(13),U,P)+1
 S $P(AMHALLP(A),U,P)=$P(AMHALLP(A),U,P)+1
 I $P(^DPT(D,0),U,2)="M" S $P(AMHMALEP(A),U,P)=$P(AMHMALEP(A),U,P)+1
 I $P(^DPT(D,0),U,2)="F" S $P(AMHFEMP(A),U,P)=$P(AMHFEMP(A),U,P)+1
 Q
AG(A) ;
 I A<5 Q 1
 I A>4,A<10 Q 2
 I A>9,A<15 Q 3
 I A>14,A<20 Q 4
 I A>19,A<25 Q 5
 I A>24,A<35 Q 6
 I A>34,A<45 Q 7
 I A>44,A<55 Q 8
 I A>54,A<65 Q 9
 I A>64,A<75 Q 10
 I A>74,A<85 Q 11
 I A>84 Q 12
 Q ""
SUICPOV(V) ;
 S G=0
 S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AMHRPRO(X,0))
 .S Y=$P(^AMHRPRO(X,0),U)
 .Q:'$D(^AMHPROB(Y,0))
 .S Y=$P(^AMHPROB(Y,0),U)
 .I Y=39!(Y=40)!(Y=41)!(Y="V62.84") S G=1
 .Q
 Q G
SUICC(V,C) ;
 S G=0
 S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AMHRPRO(X,0))
 .S Y=$P(^AMHRPRO(X,0),U)
 .Q:'$D(^AMHPROB(Y,0))
 .S Y=$P(^AMHPROB(Y,0),U)
 .I Y=C S G=1
 .Q
 Q G
PRINT ;EP - called from xbdbque
 S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
 S AMHPG=0
 K AMHQUIT
 D PRINT1
DONE I $D(AMHET) S AMHDVTS=(86400*($P(AMHET,",")-$P(AMHBT,",")))+($P(AMHET,",",2)-$P(AMHBT,",",2)),AMHDVH=$P(AMHDVTS/3600,".") S:AMHDVH="" AMHDVH=0
 S AMHDVTS=AMHDVTS-(AMHDVH*3600),AMHDVM=$P(AMHDVTS/60,".") S:AMHDVM="" AMHDVM=0 S AMHDVTS=AMHDVTS-(AMHDVM*60),AMHDVS=AMHDVTS W !!,"RUN TIME (H.M.S): ",AMHDVH,".",AMHDVM,".",AMHDVS
 I $E(IOST)="C",IO=IO(0) S DIR("A")="End of Report, press Enter",DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
 Q
PRINT1 ;
 S AMHSUBH="BOTH MALE AND FEMALE PATIENTS' VISITS"
 D HEAD Q:$D(AMHQUIT)
 F AMHX=1:1:13 D  Q:$D(AMHQUIT)
 .Q:$D(AMHQUIT)
 .I $Y>(IOSL-2) D HEAD Q:$D(AMHQUIT)
 .W !!?1,$P($T(@AMHX),";;",2)
 .W ?13,$$RJ^XLFSTR($$C($P(AMHALLV(AMHX),U,1),0,6),6)
 .S N=$P(AMHALLV(AMHX),U,1),D=$P(AMHALLV(13),U,1)
 .I 'D W ?22,"0.0"
 .I D W ?20,$J(((N/D)*100),5,1)
 .;
 .W ?27,$$RJ^XLFSTR($$C($P(AMHALLV(AMHX),U,3),0,6),6)
 .S N=$P(AMHALLV(AMHX),U,3),D=$P(AMHALLV(AMHX),U,1)
 .I 'D W ?35,"0.0"
 .I D W ?34,$J(((N/D)*100),5,1)
 .;
 .W ?41,$$RJ^XLFSTR($$C($P(AMHALLV(AMHX),U,4),0,6),6)
 .S N=$P(AMHALLV(AMHX),U,4),D=$P(AMHALLV(AMHX),U,1)
 .I 'D W ?48,"0.0"
 .I D W ?47,$J(((N/D)*100),5,1)
 .;
 .W ?54,$$RJ^XLFSTR($$C($P(AMHALLV(AMHX),U,5),0,6),6)
 .S N=$P(AMHALLV(AMHX),U,5),D=$P(AMHALLV(AMHX),U,1)
 .I 'D W ?64,"0.0"
 .I D W ?62,$J(((N/D)*100),5,1)
 .;
 .W ?68,$$RJ^XLFSTR($$C($P(AMHALLV(AMHX),U,2),0,6),6)
 .S N=$P(AMHALLV(AMHX),U,2),D=$P(AMHALLV(AMHX),U,1)
 .I 'D W ?77,"0.0"
 .I D W ?74,$J(((N/D)*100),5,1)
MALEV ;MALE VISITS
 Q:$D(AMHQUIT)
 S AMHSUBH="MALE PATIENTS VISITS"
 D HEAD Q:$D(AMHQUIT)
 F AMHX=1:1:13 D  Q:$D(AMHQUIT)
 .I $Y>(IOSL-2) D HEAD Q:$D(AMHQUIT)
 .W !!?1,$P($T(@AMHX),";;",2)
 .W ?13,$$RJ^XLFSTR($$C($P(AMHMALEV(AMHX),U,1),0,6),6)
 .S N=$P(AMHMALEV(AMHX),U,1),D=$P(AMHMALEV(13),U,1)
 .I 'D W ?22,"0.0"
 .I D W ?20,$J(((N/D)*100),5,1)
 .;
 .W ?27,$$RJ^XLFSTR($$C($P(AMHMALEV(AMHX),U,3),0,6),6)
 .S N=$P(AMHMALEV(AMHX),U,3),D=$P(AMHMALEV(AMHX),U,1)
 .I 'D W ?35,"0.0"
 .I D W ?34,$J(((N/D)*100),5,1)
 .;
 .W ?41,$$RJ^XLFSTR($$C($P(AMHMALEV(AMHX),U,4),0,6),6)
 .S N=$P(AMHMALEV(AMHX),U,4),D=$P(AMHMALEV(AMHX),U,1)
 .I 'D W ?48,"0.0"
 .I D W ?47,$J(((N/D)*100),5,1)
 .;
 .W ?54,$$RJ^XLFSTR($$C($P(AMHMALEV(AMHX),U,5),0,6),6)
 .S N=$P(AMHMALEV(AMHX),U,5),D=$P(AMHMALEV(AMHX),U,1)
 .I 'D W ?64,"0.0"
 .I D W ?61,$J(((N/D)*100),5,1)
 .;
 .W ?68,$$RJ^XLFSTR($$C($P(AMHMALEV(AMHX),U,2),0,6),6)
 .S N=$P(AMHMALEV(AMHX),U,2),D=$P(AMHMALEV(AMHX),U,1)
 .I 'D W ?77,"0.0"
 .I D W ?77,$J(((N/D)*100),5,1)
 ;
FEMV ;FEMALE VISITSA
 Q:$D(AMHQUIT)
 S AMHSUBH="FEMALE PATIENTS VISITS"
 D HEAD Q:$D(AMHQUIT)
 F AMHX=1:1:13 D  Q:$D(AMHQUIT)
 .I $Y>(IOSL-2) D HEAD Q:$D(AMHQUIT)
 .W !!?1,$P($T(@AMHX),";;",2)
 .W ?13,$$RJ^XLFSTR($$C($P(AMHFEMV(AMHX),U,1),0,6),6)
 .S N=$P(AMHFEMV(AMHX),U,1),D=$P(AMHFEMV(13),U,1)
 .I 'D W ?22,"0.0"
 .I D W ?20,$J(((N/D)*100),5,1)
 .;
 .W ?27,$$RJ^XLFSTR($$C($P(AMHFEMV(AMHX),U,3),0,6),6)
 .S N=$P(AMHFEMV(AMHX),U,3),D=$P(AMHFEMV(AMHX),U,1)
 .I 'D W ?35,"0.0"
 .I D W ?34,$J(((N/D)*100),5,1)
 .;
 .W ?41,$$RJ^XLFSTR($$C($P(AMHFEMV(AMHX),U,4),0,6),6)
 .S N=$P(AMHFEMV(AMHX),U,4),D=$P(AMHFEMV(AMHX),U,1)
 .I 'D W ?48,"0.0"
 .I D W ?47,$J(((N/D)*100),5,1)
 .;
 .W ?54,$$RJ^XLFSTR($$C($P(AMHFEMV(AMHX),U,5),0,6),6)
 .S N=$P(AMHFEMV(AMHX),U,5),D=$P(AMHFEMV(AMHX),U,1)
 .I 'D W ?64,"0.0"
 .I D W ?61,$J(((N/D)*100),5,1)
 .;
 .W ?68,$$RJ^XLFSTR($$C($P(AMHFEMV(AMHX),U,2),0,6),6)
 .S N=$P(AMHFEMV(AMHX),U,2),D=$P(AMHFEMV(AMHX),U,1)
 .I 'D W ?77,"0.0"
 .I D W ?77,$J(((N/D)*100),5,1)
 ;
PRINT2 ;
 S AMHSUBH="UNDUPLICATED PATIENT COUNT - BOTH MALE AND FEMALE PATIENTS"
 Q:$D(AMHQUIT)
 D HEAD Q:$D(AMHQUIT)
 F AMHX=1:1:13 D  Q:$D(AMHQUIT)
 .I $Y>(IOSL-2) D HEAD Q:$D(AMHQUIT)
 .W !!?1,$P($T(@AMHX),";;",2)
 .W ?13,$$RJ^XLFSTR($$C($P(AMHALLP(AMHX),U,1),0,6),6)
 .S N=$P(AMHALLP(AMHX),U,1),D=$P(AMHALLP(13),U,1)
 .I 'D W ?22,"0.0"
 .I D W ?20,$J(((N/D)*100),5,1)
 .;
 .W ?27,$$RJ^XLFSTR($$C($P(AMHALLP(AMHX),U,3),0,6),6)
 .S N=$P(AMHALLP(AMHX),U,3),D=$P(AMHALLP(AMHX),U,1)
 .I 'D W ?35,"0.0"
 .I D W ?34,$J(((N/D)*100),5,1)
 .;
 .W ?41,$$RJ^XLFSTR($$C($P(AMHALLP(AMHX),U,4),0,6),6)
 .S N=$P(AMHALLP(AMHX),U,4),D=$P(AMHALLP(AMHX),U,1)
 .I 'D W ?48,"0.0"
 .I D W ?47,$J(((N/D)*100),5,1)
 .;
 .W ?54,$$RJ^XLFSTR($$C($P(AMHALLP(AMHX),U,5),0,6),6)
 .S N=$P(AMHALLP(AMHX),U,5),D=$P(AMHALLP(AMHX),U,1)
 .I 'D W ?64,"0.0"
 .I D W ?61,$J(((N/D)*100),5,1)
 .;
 .W ?68,$$RJ^XLFSTR($$C($P(AMHALLP(AMHX),U,2),0,6),6)
 .S N=$P(AMHALLP(AMHX),U,2),D=$P(AMHALLP(AMHX),U,1)
 .I 'D W ?77,"0.0"
 .I D W ?77,$J(((N/D)*100),5,1)
MALEP ;MALE PATS
 Q:$D(AMHQUIT)
 S AMHSUBH="UNDUPLICATED PATIENT COUNT - MALE PATIENTS"
 D HEAD Q:$D(AMHQUIT)
 F AMHX=1:1:13 D  Q:$D(AMHQUIT)
 .I $Y>(IOSL-2) D HEAD Q:$D(AMHQUIT)
 .W !!?1,$P($T(@AMHX),";;",2)
 .W ?13,$$RJ^XLFSTR($$C($P(AMHMALEP(AMHX),U,1),0,6),6)
 .S N=$P(AMHMALEP(AMHX),U,1),D=$P(AMHMALEP(13),U,1)
 .I 'D W ?22,"0.0"
 .I D W ?20,$J(((N/D)*100),5,1)
 .;
 .W ?27,$$RJ^XLFSTR($$C($P(AMHMALEP(AMHX),U,3),0,6),6)
 .S N=$P(AMHMALEP(AMHX),U,3),D=$P(AMHMALEP(AMHX),U,1)
 .I 'D W ?35,"0.0"
 .I D W ?34,$J(((N/D)*100),5,1)
 .;
 .W ?41,$$RJ^XLFSTR($$C($P(AMHMALEP(AMHX),U,4),0,6),6)
 .S N=$P(AMHMALEP(AMHX),U,4),D=$P(AMHMALEP(AMHX),U,1)
 .I 'D W ?48,"0.0"
 .I D W ?47,$J(((N/D)*100),5,1)
 .;
 .W ?54,$$RJ^XLFSTR($$C($P(AMHMALEP(AMHX),U,5),0,6),6)
 .S N=$P(AMHMALEP(AMHX),U,5),D=$P(AMHMALEP(AMHX),U,1)
 .I 'D W ?64,"0.0"
 .I D W ?61,$J(((N/D)*100),5,1)
 .;
 .W ?68,$$RJ^XLFSTR($$C($P(AMHMALEP(AMHX),U,2),0,6),6)
 .S N=$P(AMHMALEP(AMHX),U,2),D=$P(AMHMALEP(AMHX),U,1)
 .I 'D W ?77,"0.0"
 .I D W ?77,$J(((N/D)*100),5,1)
 ;
FEMP ;FEMALE PATS
 Q:$D(AMHQUIT)
 S AMHSUBH="UNDUPLICATED PATIENT COUNT - FEMALE PATIENTS"
 D HEAD
 Q:$D(AMHQUIT)
 F AMHX=1:1:13 D  Q:$D(AMHQUIT)
 .I $Y>(IOSL-2) D HEAD Q:$D(AMHQUIT)
 .W !!?1,$P($T(@AMHX),";;",2)
 .W ?13,$$RJ^XLFSTR($$C($P(AMHFEMP(AMHX),U,1),0,6),6)
 .S N=$P(AMHFEMP(AMHX),U,1),D=$P(AMHFEMP(13),U,1)
 .I 'D W ?22,"0.0"
 .I D W ?20,$J(((N/D)*100),5,1)
 .;
 .W ?27,$$RJ^XLFSTR($$C($P(AMHFEMP(AMHX),U,2),0,6),6)
 .S N=$P(AMHFEMP(AMHX),U,2),D=$P(AMHFEMP(AMHX),U,1)
 .I 'D W ?35,"0.0"
 .I D W ?34,$J(((N/D)*100),5,1)
 .;
 .W ?41,$$RJ^XLFSTR($$C($P(AMHFEMP(AMHX),U,3),0,6),6)
 .S N=$P(AMHFEMP(AMHX),U,3),D=$P(AMHFEMP(AMHX),U,1)
 .I 'D W ?48,"0.0"
 .I D W ?47,$J(((N/D)*100),5,1)
 .;
 .W ?54,$$RJ^XLFSTR($$C($P(AMHFEMP(AMHX),U,4),0,6),6)
 .S N=$P(AMHFEMP(AMHX),U,4),D=$P(AMHFEMP(AMHX),U,1)
 .I 'D W ?64,"0.0"
 .I D W ?61,$J(((N/D)*100),5,1)
 .;
 .W ?68,$$RJ^XLFSTR($$C($P(AMHFEMP(AMHX),U,5),0,6),6)
 .S N=$P(AMHFEMP(AMHX),U,5),D=$P(AMHFEMP(AMHX),U,1)
 .I 'D W ?77,"0.0"
 .I D W ?77,$J(((N/D)*100),5,1)
 ;
 Q
PAGEHEAD ;
HEAD ;EP;HEADER
 I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",AMHPG
 W !?29,"Behavioral Health"
 W !,$$CTR($$REPEAT^XLFSTR("*",35),80)
 W !,$$CTR("*   SUICIDE PURPOSE OF VISIT REPORT  *",80)
 W !,$$CTR($$REPEAT^XLFSTR("*",35),80)
 S X="VISIT Date Range: "_AMHBDD_" through "_AMHEDD W !,$$CTR(X,80)
 S X=AMHSUBH W !,$$CTR(X,80),!
 S X="39 & v62.84 - Suicide Ideation; 40 - Suicide Attempt/Gesture;" W !,$$CTR(X,80),!
 S X="41 - Suicide Completed" W $$CTR(X,80),!
 W !,"AGE GROUP",?13,"# Encs",?27,"# w POV 39",?41,"w/ POV 40",?54,"w/ POV 41",?68,"w/ 39/40/41"
 W !?27,"& v62.84",?68," & v62.84"
 W !?15,"#",?22,"%",?29,"#",?36,"%",?43,"#",?50,"%",?56,"#",?63,"%",?70,"#",?77,"%"
 W !,$$REPEAT^XLFSTR("-",80)
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;inform user what this report is all about
 W !,$$CTR($$LOC)
 W !!,$$CTR("BEHAVIORAL HEALTH SUICIDE PURPOSE OF VISIT REPORT")
 W !!,"This report will display the Suicide POVs (39,40,41) as a"
 W !,"percentage of the total number of Behavioral Health encounter"
 W !,"records (Encs).  Any records containing the ICD-9 code v62.84,"
 W !,"Suicidal Ideation will be included in the tallies for Problem"
 W !,"code 39.  A display by age and gender is also included."
 W !
 Q
OPRV ;one PROVIDER
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC K DIC
 I Y=-1 S AMHQ="" Q
 S AMHPRVS(+Y)=""
 Q
SPRV ;taxonomy of PROVIDERS
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"AMHPRVS(")
 I '$D(AMHPRVS) S AMHQ="" Q
 I $D(AMHPRVS("*")) S AMHPRVT="A" K AMHPRVS W !!,"**** all PROVIDERS will be included ****",! Q
 Q
 ;
1 ;;1-4 yrs
2 ;;5-9 yrs
3 ;;10-14 yrs
4 ;;15-19 yrs
5 ;;20-24 yrs
6 ;;25-34 yrs
7 ;;35-44 yrs
8 ;;45-54 yrs
9 ;;55-64 yrs
10 ;;65-74 yrs
11 ;;75-84 yrs
12 ;;85+ yrs
13 ;;TOTAL
