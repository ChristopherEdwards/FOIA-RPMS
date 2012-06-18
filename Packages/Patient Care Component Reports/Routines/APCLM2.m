APCLM2 ; IHS/CMI/LAB - ADULT IMMUNIZATION NEEDS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;IHS/CMI/LAB - patch 4 1/5/1999 for new immunization package
 ;
START ;
 W:$D(IOF) @IOF
 W !!?12,"**********   CHILDREN NOT ON IMMUNIZATION REGISTER   **********"
 W !!,"This report will list all children in an age range that you select, who are not",!,"on the immunization register.  You will be asked to specify an age range",!,"and the community or communities that you are interested in.",!!
AGE ;
 W !
 K APCLAGER
 S DIR(0)="FO^1:7",DIR("A")="Enter an AGE Range (e.g. 5-12) [HIT RETURN TO INCLUDE ALL AGES]" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT) G XIT
 I Y="" W !!,"No age range entered.  All ages will be included." G COMM
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter an age range in the format nnn-nnn.  E.g. 2-5, 12-74, 5-20." G AGE
 S APCLAGER=Y
COMM ;
 K APCLCOMM
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="List children who live in",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) AGE
 I Y="A" W !!,"Kids from all communities will be included in the report.",! G ZIS
 I Y="O" D  G:'$D(APCLCOMM) COMM G:$D(APCLCOMM) ZIS I 1
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLCOMM($P(^AUTTCOM(+Y,0),U))=""
 S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLCOMM(")
 I '$D(APCLCOMM) G COMM
 I $D(APCLCOMM("*")) K APCLCOMM
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G COMM
 S XBRP="PRN^APCLM2",XBRC="PROC^APCLM2",XBRX="XIT^APCLM2",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K APCLAGE,APCLAGER,APCLBT,APCLCNT,APCLCOM,APCLCOMM,APCLET,APCLJOB,APCLNAME,APCLPG,APCLQUIT
 K A,B,C,D,S,DA,DFN,DIC,DIR,DIRUT,DTOUT,DUOUT,H,I,K,M,N,TS,V,X,X1,X2,Y
 D KILL^AUPNPAT
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M
 Q
PROC ;
 S APCLBT=$H,APCLJOB=$J,APCLCNT=0
 D XTMP^APCLOSUT("APCLM2","PCC IMMUNIZATION REPORT 2")
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:DFN'=+DFN  D PROC1
 S APCLET=$H
 Q
PROC1 ;
 Q:$P($G(^DPT(DFN,.35)),U)]""  ;don't include deceased patients
 Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 I $O(^AUTTIMM(0))<100 Q:$D(^AMCH(85,"B",DFN))  ;skip if on MCH register (mch pt) ;IHS/CMI/LAB - changed for new imm package patch 4
 I $O(^AUTTIMM(0))>99 Q:$D(^BIP("B",DFN))  ;IHS/CMI/LAB - new line for new imm package patch 4
 I $D(APCLCOMM),$$COMMRES^AUPNPAT(DFN,"E")="" Q  ;quit if want a particular community and patient's community is blank
 I $D(APCLCOMM),'$D(APCLCOMM($$COMMRES^AUPNPAT(DFN,"E"))) Q  ;quit if community selected is not this patient's community
 S APCLAGE=$$AGE^AUPNPAT(DFN,DT)
 I $D(APCLAGER),APCLAGE<$P(APCLAGER,"-") Q
 I $D(APCLAGER),APCLAGE>$P(APCLAGER,"-",2) Q
 S ^XTMP("APCLM2",APCLJOB,APCLBT,"CHILDREN",$S($$COMMRES^AUPNPAT(DFN,"E")=-1:"?? - UNKNOWN",$$COMMRES^AUPNPAT(DFN,"E")]"":$$COMMRES^AUPNPAT(DFN,"E"),1:"??"),$P(^DPT(DFN,0),U),DFN)=""
 S APCLCNT=APCLCNT+1
 Q
PRN ;EP
 S APCLPG=0
 I '$D(^XTMP("APCLM2",APCLJOB,APCLBT,"CHILDREN")) D HEAD W !!,"NO DATA TO REPORT",! G DONE
 I '$D(APCLCOMM) D HEAD
 K APCLQUIT
 D PRINT
 ;
DONE ;
 D DONE^APCLOSUT
 Q
PRINT ;
 S APCLCOM="" F  S APCLCOM=$O(^XTMP("APCLM2",APCLJOB,APCLBT,"CHILDREN",APCLCOM)) Q:APCLCOM=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 .W !!,"Community: ",APCLCOM,!,$TR($J("",$L(APCLCOM)+11)," ","-"),!
 .S APCLNAME="" F  S APCLNAME=$O(^XTMP("APCLM2",APCLJOB,APCLBT,"CHILDREN",APCLCOM,APCLNAME)) Q:APCLNAME=""!($D(APCLQUIT))  D
 ..S DFN=0 F  S DFN=$O(^XTMP("APCLM2",APCLJOB,APCLBT,"CHILDREN",APCLCOM,APCLNAME,DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D PRINT1
 Q
PRINT1 ;
 I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)
 W !,$E($P(^DPT(DFN,0),U),1,20),?23,"(",$$HRN^AUPNPAT(DFN,DUZ(2)),")",?34,$$DOB^AUPNPAT(DFN,"E"),?50,$$RAGE($P(^DPT(DFN,0),U,3)),?66,$$VAL^XBDIQ1(2,DFN,.02),!
 D GETIMM
 I 'C W !?12,"No prior immunizations listed",! Q
 S D=0 F  S D=$O(B(D)) Q:D=""!($D(APCLQUIT))  D SBW
 W !
 Q
SBW ;
 I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)
 W !,?16,$$FMTE^XLFDT(D),?30
 S (C,N)=0 F  S C=$O(B(D,C)) Q:C=""  W:N ", " D
 .S N=N+1,V=$P(B(D,C),U),S=$P(B(D,C),U,2)
 .I V,$D(^AUTTIMM(V,0)) S V=$P(^(0),U,2) W:S S," " W V
 .Q
 Q
GETIMM ;
 K A,B S (C,I)=0 NEW X,S,K,V,D
 F  S I=$O(^AUPNVIMM("AC",DFN,I)) Q:I'=+I  D
 .Q:'$D(^AUPNVIMM(I,0))
 .S X=^AUPNVIMM(I,0),V=$P(X,U)
 .S S=$P(X,U,4),K=$P(X,U,3),D=""
 .I K,$D(^AUPNVSIT(K,0)) S D=+$P(^(0),".",1)
 .S C=C+1,B(D,C)=V_U_S
 Q
RAGE(D) ;printable age
 NEW X1,X2,X,%
 S X1=DT,X2=D
 D ^%DTC
 S %=$S(X<60:X_" Days",X<1096:$J(X/30.44,0,0)_" Months",1:$J(X\365.25,0,0)_" Years")
 Q %
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?5,"WARNING:  CONFIDENTIAL PATIENT INFORMATION, PRIVACY ACT APPLIES",!
 W !?3,$P(^DIC(4,DUZ(2),0),U),?58,$$FMTE^XLFDT(DT),?72,"Page ",APCLPG
 W !?12,"********  CHILDREN NOT ON IMMUNIZATION REGISTER  ********",!!
 Q
