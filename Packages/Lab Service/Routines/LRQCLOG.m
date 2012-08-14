LRQCLOG ; IHS/DIR/FJE - QUALITY CONTROL LOGGING 3/28/90 15:20 ;
 ;;5.2;LR;**1013**;JUL 15, 2002
 ;
 ;;5.2;LAB SERVICE;**9,89**;Sep 27, 1994
 D WHICH G END:LRDPF<1
ASK S (LRINC,LREND)=0,DIC=LRDPF,DIC(0)="AEQ" D ^LRDPA G LRQCLOG:(LRDFN=-1)!$D(DUOUT)!$D(DTOUT)
TEST S DIC="^LAB(60,",DIC(0)="AEMOQ" D ^DIC G ASK:Y<1 S LRTEST=+Y
L2 S %DT="ET",%DT("A")="Collection date & time: ",%DT("B")="NOW" D DATE^LRWU G END:Y<1 S LRNOW=Y
 S LRINC=LRINC+1,LRNT=$$ADDDATE^LRAFUNC1(LRNOW,0,0,0,LRINC)
 S LRODT=LRNOW\1,LRAD=LRODT,LRIDT=(9999999-LRNT),LRCDT=LRNOW_"^1",LRSAMP="",LRSPEC=$S(62.3=+LRDPF:$P(^LAB(62.3,DFN,0),U,5),1:""),LROUTINE=$P(^LAB(69.9,1,3),U,2)
 I LRSPEC="" S LRTSTS=LRTEST,LRFLOG="^^MI" D GS^LRORD3 I $D(LROT)!LREND G END
 S:'$D(^LRO(69,LRODT,0)) ^(0)=$P(^LRO(69,0),U,1,2)_U_LRODT_U_(1+$P(^(0),U,4)),^LRO(69,LRODT,0)=LRODT,^LRO(69,"B",LRODT,LRODT)=""
 D ORDER^LROW2
 L +^LRO(69,LRODT)
 S LRSN=1+$S($D(^LRO(69,LRODT,1,0)):$P(^(0),U,3),1:0),LRSUM=1+$S($D(^LRO(69,LRODT,1,0)):$P(^(0),U,4),1:0)
QSN IF $D(^LRO(69,LRODT,1,LRSN,0)) S LRSN=LRSN+1 G QSN
 S DA=LRODT,^LRO(69,LRODT,1,LRSN,0)=LRDFN_U_DUZ_U_LRSAMP_U_U_LRNOW_"^^UNK^"_LRNOW,^(.1)=LRORD,^(1)=LRCDT_U_DUZ_U_"C",^(2,0)="^69.03PA^1^1",^(1,0)=LRTEST_U_LROUTINE
 S ^LRO(69,LRODT,1,LRSN,4,0)="^69.02PA^1^1",^(1,0)=LRSPEC
 S ^LRO(69,LRODT,1,LRSN,2,"B",LRTEST,1)="",^LRO(69,LRODT,1,"AA",LRDFN,LRSN)="",^LRO(69,"C",LRORD,LRODT,LRSN)="",^LRO(69,LRODT,1,0)="^69.01PA^"_LRSN_U_LRSUM
 L -^LRO(69,LRODT)
 K ^TMP("LR",$J,"TMP") S LRTSTS=0,LRLLOC="" D ^LRWLST
 G TEST
EN ;
ADDNAME D WHICH G END:LRDPF<1
 S (DIC,DLAYGO)=+LRDPF,DIC(0)="AQLEM" D ANY^LRDPA G END:LRDFN<1
 S DA=DFN,DR=".01:10",DR(2,62.31)=".01;1;2",DIE=U_$P(LRDPF,U,2)
 S LRGLB=DIE_DA_")" L +@LRGLB:1 I '$T W !!?7,"Someone else is editing this entry ",!,$C(7) G END
 D ^DIE L -@LRGLB G END
WHICH S LRDPF=0,DIR(0)="SO^62.3:Lab Control Name;67:Referral Patient;67.1:Research;67.2:Sterilizer;67.3:Environmental",DIR("A")="FILE" D ^DIR S LRDPF=Y
 Q:Y<1!($D(DIRUT))  S LRDPF=+Y_^DIC(+Y,0,"GL")
 W !!
 Q
END K %,A,DIC,DL,DX,H8,J,K,LRAA,LRACC,LRAD,LRAN,LRCDT,LRDFN,LRCS,LRCSN,LRDPF,LREAL,LREND,LRFLOG,LRIDT,LRIN,LRINC,LRIX,LRLBLBP,LRLLOC,LRNT,LRODT,LROT,LROUTINE,LRPR,LRPRAC,LRRB,LRSAMP,LRSN,LRSPEC,LRSSP,LRSS,LRST,LRSUM,LRTEST,LRTN,LRTS
 K LRUNQ,LRURG,LRWL0,LRWLC,S,X,Y,Z,LRDUZ,LRCAPLOC,DIC,DFN,DR,DIE,DD,D1,DIG,DIH,DIU,DIV,DLAYGO,DO,DPF,DQ,I,K,LRI,LRLABKY,LRLBL,LRLWC,LRNOW,LRODTSV,LROLLOC,LRORIFN,LRSNSV,LRTNSV,LRTREA,LRYR
 K %DT,%Y,A1,DIWL,DIWR,H,I5,LRCCOM,LRGCOM,LRNCWL,LRNIDT,LROCN,LROID,LROLRDFN,LRORD,LROSN,LRPHSET,LRSPCDSC,LRTJ,P,PNM,R,S5,X1,X2,ZTSK,DLAYGO,LRGLB
 Q