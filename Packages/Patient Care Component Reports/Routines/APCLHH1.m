APCLHH1 ; IHS/CMI/LAB - INFANT FEEDING REPORT #1 ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 S APCLTEXT="INTROT" F APCLJ=1:1 S APCLX=$T(@APCLTEXT+APCLJ) Q:$P(APCLX,";;",2)="END"  S APCLT=$P(APCLX,";;",2) W !,APCLT
TRIBE ;
 K APCLTRIM S APCLTRIT=""
 S DIR(0)="S^O:One particular Tribe;A:All Tribes;S:Selected Set of Tribes (Taxonomy)",DIR("A")="List patients who are members of",DIR("B")="O" K DA D ^DIR K DIR
 I $D(DIRUT) G EOJ
 S APCLTRIT=Y
 I APCLTRIT="A" W !!,"Patients from all tribes will be included in the report.",! G CMMNTS
 I APCLTRIT="O" D  G:'$D(APCLTRIM) TRIBE  G CMMNTS
 .S DIC="^AUTTTRI(",DIC(0)="AEMQ",DIC("A")="Which TRIBE: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLTRIM(+Y)=""
 S X="TRIBE",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLERR=1 Q
 D PEP^AMQQGTX0(+Y,"APCLTRIM(")
 I '$D(APCLTRIM) G TRIBE
 I $D(APCLTRIM("*")) K APCLTRIM G TRIBE
CMMNTS ;
 K APCLCOMM S APCLCOMT=""
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="List patients who live in",DIR("B")="O" K DA D ^DIR K DIR
 I $D(DIRUT) G TRIBE
 S APCLCOMT=Y
 I APCLCOMT="A" W !!,"Patients from all communities will be included in the report.",! G BEN
 I APCLCOMT="O" D  G:'$D(APCLCOMM) CMMNTS  G BEN
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLCOMM($P(^AUTTCOM(+Y,0),U))=""
 S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLERR=1 Q
 D PEP^AMQQGTX0(+Y,"APCLCOMM(")
 I '$D(APCLCOMM) G CMMNTS
 I $D(APCLCOMM("*")) K APCLCOMM G CMMNTS
BEN ;
 S APCLBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CMMNTS
 S APCLBEN=Y
SORTR ;
 S APCLSORT=""
 S DIR(0)="S^H:HRN;P:Patient Name;R:Terminal Digit HRN;C:Community;T:Tribe;I:Household Income;N:Number in Household",DIR("A")="Sort Report by",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CMMNTS
 S APCLSORT=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G SORTR
 S XBRP="PRINT^APCLHH1",XBRC="PROC^APCLHH1",XBRX="EOJ^APCLHH1",XBNS="APCL"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 D EN^XBVK("APCL")
 Q
 ;
PROC ;
 S APCLJ=$J,APCLH=$H,APCLTOTP=0,APCLTHI=0,APCLTNHH=0,APCLTWD("NHH")=0,APCLTWD("THI")=0
 S ^XTMP("APCLHH1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"HOUSEHOLD INCOME REPORT"
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:'$D(^DPT(DFN))
 .Q:'$D(^AUPNPAT(DFN))
 .Q:'$D(^AUPNPAT(DFN,0))
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .S APCLHI=$P(^AUPNPAT(DFN,0),U,36)
 .S APCLNHH=$P(^AUPNPAT(DFN,0),U,35)
 .I APCLBEN=1,$$BEN^AUPNPAT(DFN,"C")'="01" Q  ;want only indians
 .I APCLBEN=2,$$BEN^AUPNPAT(DFN,"C")="01" Q  ;want only non indians
 .;check tribe
 .I $D(APCLTRIM) S X=$P($G(^AUPNPAT(DFN,11)),U,8) I X,'$D(APCLTRIM(X)) Q  ;not correct tribe
 .I $D(APCLCOMM) S X=$P($G(^AUPNPAT(DFN,11)),U,18) I X,'$D(APCLCOMM(X)) Q  ;not correct community
 .S APCLTOTP=APCLTOTP+1
 .I APCLNHH="",APCLHI="" Q  ;no data
 .I APCLNHH]"" S APCLTWD("NHH")=$G(APCLTWD("NHH"))+1
 .I APCLHI]"" S APCLTWD("THI")=$G(APCLTWD("THI"))+1
 .S X=$$SORT(DFN,APCLSORT)
 .I X="" S X="---"
 .S ^XTMP("APCLHH1",APCLJ,APCLH,"PTS",X,DFN)=APCLNHH_U_APCLHI
 .S APCLTHI=APCLTHI+APCLHI
 .S APCLTNHH=APCLTNHH+APCLNHH
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ;W:$D(IOF) @IOF
 K APCLTS,APCLS,APCLM,APCLET
 K ^XTMP("APCLHH1",APCLJ,APCLH),APCLJ,APCLH
 Q
 ;
 ;
PRINT ;EP - called from xbdbque
 S APCLQ=0,APCLPG=0
 D HEADER
 S APCLSV="" F  S APCLSV=$O(^XTMP("APCLHH1",APCLJ,APCLH,"PTS",APCLSV)) Q:APCLSV=""!(APCLQ)  D
 .S DFN=0 F  S DFN=$O(^XTMP("APCLHH1",APCLJ,APCLH,"PTS",APCLSV,DFN)) Q:DFN'=+DFN  D
 ..S Y=DFN D ^AUPNPAT
 ..I $Y>(IOSL-3) D HEADER Q:APCLQ
 ..W !,$E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$BEN^AUPNPAT(DFN,"C"),?34,$E($$VAL^XBDIQ1(9000001,DFN,1118),1,9)
 ..W ?44,$E($$VAL^XBDIQ1(2,DFN,.116),1,5),?50,$E($$VAL^XBDIQ1(9000001,DFN,1108),1,10)
 ..S APCLX=^XTMP("APCLHH1",APCLJ,APCLH,"PTS",APCLSV,DFN)
 ..S APCLHI=$P(APCLX,U,2)
 ..S APCLNHH=$P(APCLX,U,1)
 ..W ?62,$J(APCLNHH,3)
 ..W ?69,$$C(APCLHI,0,10)
 ..Q
 .Q
 ;NOW PRINT AVERAGES
 I APCLTWD("NHH") S X=(APCLTNHH/APCLTWD("NHH")) D
 .I $Y>(IOSL-2) D HEADER Q:APCLQ
 .W !!?3,"Total Number of Patients with Number in Household documented: ",$J(APCLTWD("NHH"),6,0)
 .W !?3,"Average Number in Household:  ",$J(X,5,1)
 I APCLTWD("THI") S X=(APCLTHI/APCLTWD("THI")) D
 .I $Y>(IOSL-2) D HEADER Q:APCLQ
 .W !!?3,"Total Number of Patients with Total Household Income documented: ",$J(APCLTWD("THI"),6,0)
 .W !?3,"Average Total Household Income:  ",$$C(X,0,12)
 D DONE
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 W !,$$CTR("HOUSEHOLD INCOME/NUMBER IN HOUSEHOLD TALLY",80)
 S X="Communities: "
 I APCLCOMT="O" S X=X_$O(APCLCOMM(""))
 I APCLCOMT="A" S X=X_"All Communities"
 I APCLCOMT="S" D
 .S Y="" F  S Y=$O(APCLCOMM(Y)) Q:Y'=+Y  S X=X_" "_Y
 I APCLTRIT="O" S X=X_$O(APCLTRIM(""))
 I APCLTRIT="A" S X=X_"All Communities"
 I APCLTRIT="S" D
 .S Y="" F  S Y=$O(APCLTRIM(Y)) Q:Y'=+Y  S X=X_" "_$P(^AUTTTRI(Y,0),U)
 W !!,"Patient Name",?22,"HRN",?29,"BENI",?34,"COMMUNITY",?44,"ZIP",?50,"TRIBE",?61,"# IN",?69,"TOTAL"
 W !?29,"FICI",?61,"HOUSE",?69,"HOUSEHOLD",!?29,"ARY",?61,"HOLD",?69,"INCOME"
 W !,$TR($J("",80)," ","-")
 Q
D(D) ;
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
SORT(P,S) ;
 NEW R
 S R=""
 D @(S_"SORT")
 I R="" S R="ZZZZZZZZ"
 Q R
 ;
ISORT ;
 S X=$$VAL^XBDIQ1(9000001,P,.36)
 Q
NSORT ;
 S X=$$VAL^XBDIQ1(9000001,P,.35)
 Q
CSORT ;
 S X=$$VAL^XBDIQ1(9000001,P,1118)
 Q
TSORT ;
 S R=$$VAL^XBDIQ1(9000001,P,1108)
 Q
PSORT ;
 S R=$$VAL^XBDIQ1(2,P,.01)
 Q
 ;
HSORT ;
 S R=$$HRN^AUPNPAT(P,DUZ(2))
 Q
 ;
RSORT ;
 S R=$$HRN^AUPNPAT(P,DUZ(2))
 S R=R+10000000,R=$E(R,7,8)_$E(R,1,6)
 Q
INTROT ;
 ;;                 NUMBER IN HOUSEHOLD/TOTAL INCOME REPORT
 ;;
 ;;This option will produce a report of all patients who have the number
 ;;in household or total household income recorded.  You will be able
 ;;to select to list all patients from a particular community or tribe.
 ;;
 ;;The report can be sorted by either HRN, Terminal Digit HRN, 
 ;;Community, Tribe, Household Income, Number in Household or Patient Name.
 ;;
 ;;An average of the household income and number in household will also
 ;;be displayed.
 ;;
 ;;END
