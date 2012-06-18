APCLM1 ; IHS/CMI/LAB - ADULT IMMUNIZATION NEEDS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - patch 4 for new imm package and 4 digit year display/Y2K
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W !!?12,"**********   ADULT IMMUNIZATION NEEDS   **********"
ST ;
 W !!,"This report displays the most recent Td, Pneumococcal, & Influenza Vaccinations",!,"for Adults considered as 'High Risk.'  Utilizing QMan, development of a",!
 W "Cohort (Template) of Patients is required prior to running this report.",!!
 W "Development of the Cohort of High Risk Adults usually consists of finding",!,"Living Patients who are over Age 65 OR who have one or more specific",!,"chronic diseases.",!!
 W "Feel free to contact the Help Desk for",!,"assistance in creating your Cohort.",!!
 W "Note:  Patients with Inactive charts will not appear on this report even",!,"if there were a member of the cohort (template).",!! ;IHS/CMI/LAB
 ;
 S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 Q:Y=-1
 S APCLSEAT=+Y
ZIS ;call to XBDBQUE
 S XBRP="PRN^APCLM1",XBRC="PROC^APCLM1",XBRX="XIT^APCLM1",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K APCLQUIT,APCLPG,DFN,APCLSEAT,APCL,APCLER,APCLX,APCLCOM,APCLNAME
 D KILL^AUPNPAT
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M
 Q
PROC ;
 S APCLJOB=$J,APCLBTH=$H
 D XTMP^APCLOSUT("APCLM1","PCC IMMUNIZATION REPORT 1")
 S X=0 F  S X=$O(^DIBT(APCLSEAT,1,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNPAT(X,41,DUZ(2),0)),U,5)]""  ;IHS/CMI/LAB - exlude inactive patients
 .S Y=$$COMMRES^AUPNPAT(X,"E") S:Y=""!(Y=-1) Y="?? - UNKNOWN" S ^XTMP("APCLM1",APCLJOB,APCLBTH,"PATS",Y,$P(^DPT(X,0),U),X)=""
 Q
PRN ;EP
 S APCLPG=0 D HEAD
 K APCLQUIT
 D PRINT
 ;
DONE ;
 K ^XTMP("APCLM1",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 D DONE^APCLOSUT
 Q
PRINT ;
 S APCLCOM="" F  S APCLCOM=$O(^XTMP("APCLM1",APCLJOB,APCLBTH,"PATS",APCLCOM)) Q:APCLCOM=""!($D(APCLQUIT))  D
 .S APCLNAME="" F  S APCLNAME=$O(^XTMP("APCLM1",APCLJOB,APCLBTH,"PATS",APCLCOM,APCLNAME)) Q:APCLNAME=""!($D(APCLQUIT))  D
 ..S DFN=0 F  S DFN=$O(^XTMP("APCLM1",APCLJOB,APCLBTH,"PATS",APCLCOM,APCLNAME,DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D PRINT1
 Q
BI() ;IHS/CMI/LAB - new subroutine patch 4
 Q $S($O(^AUTTIMM(0))>100:1,1:0)
 ;IHS/CMI/LAB - end new subroutine patch 4
PRINT1 ;
 I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)
 W !,$E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$E($$COMMRES^AUPNPAT(DFN,"E"),1,12),?44,$$AGE^AUPNPAT(DFN,DT)
TD ;
 S X=$$LASTTD(DFN)
 ;K APCL
 ;S APCLER=$$START1^APCLDF(DFN_"^LAST IMM "_$S($$BI:9,1:"02"),"APCL(") ;IHS/CMI/LAB - patch 4 new imm 1/5/99
 ;begin Y2K
 ;S X=$P($G(APCL(1)),U) S:X]"" X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) W ?50,X ;Y2000
 S:X]"" X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3)) W ?48,X ;Y2000
 ;end Y2K
FLU ;
 S X=$$LASTFLU(DFN)
 ;K APCL
 ;S APCLX=DFN_"^LAST IMM "_$S($$BI:88,1:12),APCLER=$$START1^APCLDF(APCLX,"APCL(") ;IHS/CMI/LAB - patch 4 new imm 1/5/1999
 ;begin Y2K
 ;S X=$P($G(APCL(1)),U) S:X]"" X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3)) W ?60,X ;Y2000
 S:X]"" X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3)) W ?59,X ;Y2000
 ;end Y2K
PNEUMOVX ;
 S X=$$LASTPN(DFN)
 ;K APCL
 ;S APCLER=$$START1^APCLDF(DFN_"^LAST IMM "_$S($$BI:33,1:19),"APCL(") ;IHS/CMI/LAB - patch 4 - new imm display
 ;begin Y2K
 ;S X=$P($G(APCL(1)),U) S:X]"" X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) W ?70,X ;Y2000
 S:X]"" X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3)) W ?70,X ;Y2000
 ;end Y2K
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^DIC(4,DUZ(2),0),U),?58,$$FMTE^XLFDT(DT),?72,"Page ",APCLPG,!
 W ?18,"********  ADULT IMMUNIZATION NEEDS  ********",!
 W !?22,$E($P(^DIC(4,DUZ(2),0),U),1,6),?70,"LAST"
 W !,"PATIENT NAME",?22,"NUMBER",?30,"COMMUNITY",?44,"AGE",?50,"LAST Td",?60,"LAST FLU",?70,"PNEUMOVAX"
 W !,$TR($J("",80)," ","-"),!
 Q
LASTFLU(P) ;EP
 NEW X,E,B,%DT,Y,TDD,D,APCLY
 K TDD
 I '$$BI D LASTFLO
 I $$BI D LASTFLN
 ;now check cpt codes
 F %=1:1 S T=$T(FLUCPTS+%) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S X=$O(^AUPNVCPT("AA",P,T,0)) I X]"" S TDD(X)=""
 K APCLY S %=P_"^LAST DX V04.8",E=$$START1^APCLDF(%,"APCLY(")
 I $D(APCLY(1)) S TDD(9999999-$P(APCLY(1),U))=""
 K APCLY S %=P_"^LAST DX V04.81",E=$$START1^APCLDF(%,"APCLY(")
 I $D(APCLY(1)) S TDD(9999999-$P(APCLY(1),U))=""
 K APCLY S %=P_"^LAST DX V06.6",E=$$START1^APCLDF(%,"APCLY(")
 I $D(APCLY(1)) S TDD(9999999-$P(APCLY(1),U))=""
 K APCLY S %=P_"^LAST PROCEDURE 99.52",E=$$START1^APCLDF(%,"APCLY(")
 I $D(APCLY(1)) S TDD(9999999-$P(APCLY(1),U))=""
 I '$D(TDD) Q ""
 Q 9999999-($O(TDD(0)))
 ;
LASTFLN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=15 S TDD(9999999-D)="" Q
 .I B=16 S TDD(9999999-D)="" Q
 .I B=88 S TDD(9999999-D)="" Q
 .I B=111 S TDD(9999999-D)="" Q
 Q
 ;;
LASTFLO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=12 S TDD(9999999-D)="" Q
 Q
LASTTD(P) ;EP
 NEW X,E,B,%DT,Y,TDD,D,APCLY
 K TDD
 I '$$BI D LASTTDO
 I $$BI D LASTTDN
 ;now check cpt codes
 F %=1:1 S T=$T(TDCPTS+%) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S X=$O(^AUPNVCPT("AA",P,T,0)) I X]"" S TDD(X)=""
 I '$D(TDD) Q ""
 Q 9999999-$O(TDD(0))
LASTTDN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=1 S TDD(9999999-D)="" Q
 .I B=9 S TDD(9999999-D)="" Q
 .I B=20 S TDD(9999999-D)="" Q
 .I B=22 S TDD(9999999-D)="" Q
 .I B=28 S TDD(9999999-D)="" Q
 .I B=35 S TDD(9999999-D)="" Q
 .I B=50 S TDD(9999999-D)="" Q
 .I B=106 S TDD(9999999-D)="" Q
 .I B=107 S TDD(9999999-D)="" Q
 .I B=110 S TDD(9999999-D)="" Q
 Q
 ;;
LASTTDO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B="04" S TDD(9999999-D)="" Q
 .I B=42 S TDD(9999999-D)="" Q
 .I B=34 S TDD(9999999-D)="" Q
 .I B="03" S TDD(9999999-D)="" Q
 .I B="02" S TDD(9999999-D)="" Q
 Q
LASTPN(P) ;EP
 NEW X,E,B,%DT,Y,TDD,D,APCLY
 K TDD
 I '$$BI D LASTPNO
 I $$BI D LASTPNN
 ;now check cpt codes
 F %=1:1 S T=$T(PNCPTS+%) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S X=$O(^AUPNVCPT("AA",P,T,0)) I X]"" S TDD(X)=""
 I '$D(TDD) Q ""
 Q 9999999-($O(TDD(0)))
 ;
LASTPNN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=33 S TDD(9999999-D)="" Q
 .I B=100 S TDD(9999999-D)="" Q
 .I B=109 S TDD(9999999-D)="" Q
 Q
 ;;
LASTPNO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S B=$P(^AUPNVIMM(X,0),U) Q:'B
 .Q:'$D(^AUTTIMM(B,0))
 .S B=$P(^AUTTIMM(B,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I B=19 S TDD(9999999-D)="" Q
 Q
TDCPTS ;;
 ;;90701
 ;;90718
 ;;90700
 ;;90720
 ;;90702
 ;;90703
 ;;90721
 ;;90723
 ;;
PAPCPTS ;;
 ;;88141
 ;;88142
 ;;88143
 ;;88144
 ;;88145
 ;;88146
 ;;88147
 ;;88148
 ;;88150
 ;;88152
 ;;88153
 ;;88154
 ;;88155
 ;;88156
 ;;88157
 ;;88158
 ;;88164
 ;;88165
 ;;88166
 ;;88167
 ;;
FLUCPTS ;;
 ;;90657
 ;;90658
 ;;90655
 ;;90724
 ;;90711
 ;;90659
 ;;90660
 ;;
SIGCPTS ;;
 ;;45330
 ;;45331
 ;;45332
 ;;45333
 ;;45334
 ;;45336
 ;;45337
 ;;45338
 ;;45339
 ;;45341
 ;;45342
 ;;45345
 ;;
BECPTS ;;
 ;;74270
 ;;74275
 ;;74280
 ;;
COLOCPTS ;;
 ;;45355
 ;;45360
 ;;45361
 ;;45362
 ;;45363
 ;;45364
 ;;45365
 ;;45366
 ;;45367
 ;;45368
 ;;45369
 ;;45370
 ;;45371
 ;;45372
 ;;45378
 ;;45379
 ;;45380
 ;;45382
 ;;45383
 ;;45384
 ;;45385
 ;;45387
 ;;
PNCPTS ;;
 ;;90732
 ;;90669
 ;;
