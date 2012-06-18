APCLPSU3 ; IHS/CMI/LAB - Suicide Form data element tally ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
 W:$D(IOF) @IOF
 D EOJ
 W:$D(IOF) @IOF
 W !!,"Extract Suicide Form Data Elements in Delimited format"
 W !!,"This report will extract all data elements on the Suicide Form in a ",!,"delimited form for a date range specified by the user.",!!
GETDATES ;
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Date of Suicide Act",DIR("?")="Enter the beginning date of suicide act for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) EOJ
 S APCLBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date of Suicide Act:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) EOJ
 I Y<APCLBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G GETDATES
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G EOJ
 I $G(Y)="B" D BROWSE,EOJ Q
 W !! S XBRP="PRINT^APCLPSU3",XBRC="PROC^APCLPSU3",XBNS="APCL",XBRX="EOJ^APCLPSU3"
 D ^XBDBQUE
 D EOJ
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCLPSU3"")"
 S XBNS="APCL",XBRC="PROC^APCLPSU3",XBRX="EOJ^APCLPSU3",XBIOP=0 D ^XBDBQUE
 Q
 ;
PAUSE ; 
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) APCLQUIT=1
 W:$D(IOF) @IOF
 Q
EOJ ;
 D EN^XBVK("APCL")
 K L,M,S,T,X,X1,X2,Y,Z,B,A
 D KILL^AUPNPAT
 D ^XBFMK
 Q
PROC ;EP
 S APCLJ=$J,APCLH=$H
 K ^XTMP("APCLPSU3",APCLJ,APCLH)
 D XTMP("APCLPSU3","APCL - SUICIDE")
V ; Run by visit date
 F  S APCLSD=$O(^AMHPSUIC("AD",APCLSD)) Q:APCLSD=""!((APCLSD\1)>APCLED)  D V1
 Q
 ;
V1 ;
 S APCLVDFN="" F  S APCLVDFN=$O(^AMHPSUIC("AD",APCLSD,APCLVDFN)) Q:APCLVDFN'=+APCLVDFN  D
 .Q:$$DEMO^APCLUTL($P(^AMHPSUIC(APCLVDFN,0),U,4))
 .S APCLREC="" F APCLX=1:1:21 S APCLT=$T(@APCLX) D
 ..S APCLP=$P(APCLT,";;",1),APCLV=$P(APCLT,";;",3)
 ..X APCLV
 ..S $P(APCLREC,U,APCLP)=X
 ..Q
 .;rest of multiples
 .S APCLC=21,APCLX=0 F  S APCLX=$O(^AMHPSUIC(APCLVDFN,11,APCLX)) Q:APCLX'=+APCLX!(APCLC>24)  D
 ..S APCLC=APCLC+1
 ..S Y=$P(^AMHPSUIC(APCLVDFN,11,APCLX,0),U),$P(APCLREC,U,APCLC)=$$EXTSET^XBFUNC(9002011.6511,.01,Y)
 .S APCLC=25,APCLX=0 S APCLX=$P(^AMHPSUIC(APCLVDFN,0),U,26)  D
 ..S APCLC=APCLC+1
 ..S Y=$P(^AMHPSUIC(APCLVDFN,0),U,26),$P(APCLREC,U,APCLC)=$$EXTSET^XBFUNC(9002011.65,.26,Y)
 .S APCLC=29,APCLX=0 F  S APCLX=$O(^AMHPSUIC(APCLVDFN,13,APCLX)) Q:APCLX'=+APCLX!(APCLC>32)  D
 ..S APCLC=APCLC+1
 ..S Y=$P(^AMHPSUIC(APCLVDFN,13,APCLX,0),U),$P(APCLREC,U,APCLC)=$P(^AMHTSCF(Y,0),U,1)
 .S ^XTMP("APCLPSU3",APCLJ,APCLH,"RECS",APCLVDFN)=APCLREC
 Q
PRINT ;EP called from xbdbque
 W:$D(IOF) @IOF
 W !,$$LOC,"^^^",$$FMTE^XLFDT(DT)
 S X="***** AGGREGATED SUICIDE DATA *****" W !,X,!
 W "Act Occurred","^",$$FMTE^XLFDT(APCLBD),"^",$$FMTE^XLFDT(APCLED),!
 F APCLX=1:1:21 S APCLT=$T(@APCLX),APCLT=$P(APCLT,";;",2) S $P(X,U,APCLX)=APCLT
 F APCLX=22:1:25 S $P(X,U,APCLX)="Method "_(APCLX-21)
 F APCLX=26:1:29 S $P(X,U,APCLX)="Substance Involved "
 F APCLX=30:1:33 S $P(X,U,APCLX)="Contributing Factor "_(APCLX-29)
 W !!,X
 S APCLVDFN="" F  S APCLVDFN=$O(^XTMP("APCLPSU3",APCLJ,APCLH,"RECS",APCLVDFN)) Q:APCLVDFN=""  D
 .W !,^XTMP("APCLPSU3",APCLJ,APCLH,"RECS",APCLVDFN)
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("APCLPSU3",APCLJ,APCLH)
 Q
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
XTMP(N,D) ;EP - set xtmp 0 node
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
 ;
LABEL ;
1 ;;Unique Case ID;;S X=$P(^AMHPSUIC(APCLVDFN,0),U)
2 ;;Local Case #;;S X=$P(^AMHPSUIC(APCLVDFN,0),U,2)
3 ;;Event logged by;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.031)
4 ;;Discipline of Prov;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.032)
5 ;;Unique ID of Patient;;S X=$P(^AMHPSUIC(APCLVDFN,0),U,4),X=$$UID^AGTXID(X)
6 ;;Sex of Patient;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.041)
7 ;;Age of Patient on date of act;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.043)
8 ;;Tribe of Enrollment;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.044)
9 ;;Community of Residence;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.045)
10 ;;Employment Status;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.05)
11 ;;Date of Act;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.06)
12 ;;Community where act occurred;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.07)
13 ;;Relationship Status;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.08)
14 ;;Relationship if Other;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.09)
15 ;;Education Level;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.11)
16 ;;If less than 12;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.12)
17 ;;Self Destructive Act;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.13)
18 ;;Previous Attempts;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.14)
19 ;;Location of Act;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.15)
20 ;;Lethality;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.24)
21 ;;Disposition;;S X=$$VAL^XBDIQ1(9002011.65,APCLVDFN,.25)
